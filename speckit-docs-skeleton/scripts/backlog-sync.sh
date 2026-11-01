#!/usr/bin/env bash
# backlog-sync.sh – Đồng bộ docs/delivery/backlog.json lên GitHub Issues.
#
# Mặc định chạy thử (dry-run): chỉ đọc GitHub và in ra việc sẽ làm.
# Thêm --apply để tạo/cập nhật nhãn, milestone, issue và liên kết sub-issue.
#
# Idempotent: issue được nhận diện bằng tiền tố "[KEY]" trong tiêu đề,
# nên chạy lại chỉ cập nhật, không tạo trùng.
#
# Yêu cầu: gh (đã gh auth login), jq, bash >= 4.

set -euo pipefail

FILE="docs/delivery/backlog.json"
MAP_OUT="docs/delivery/backlog-issues.json"
REPO=""
APPLY=0

usage() {
  cat <<'EOF'
Cách dùng: scripts/backlog-sync.sh [--apply] [--repo OWNER/NAME] [--file PATH] [--map-out PATH]

  --apply          Thực sự ghi lên GitHub (mặc định chỉ chạy thử)
  --repo           Repo đích (mặc định: repo của thư mục hiện tại)
  --file           File backlog (mặc định: docs/delivery/backlog.json)
  --map-out        File ghi ánh xạ key -> số issue (mặc định: docs/delivery/backlog-issues.json)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) APPLY=1; shift ;;
    --repo) REPO="$2"; shift 2 ;;
    --file) FILE="$2"; shift 2 ;;
    --map-out) MAP_OUT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Tham số không hợp lệ: $1" >&2; usage; exit 2 ;;
  esac
done

die()  { echo "LỖI: $*" >&2; exit 1; }
warn() { echo "CẢNH BÁO: $*" >&2; }
plan() { echo "  - $*"; }

command -v gh >/dev/null || die "chưa cài gh"
command -v jq >/dev/null || die "chưa cài jq"
(( BASH_VERSINFO[0] >= 4 )) || die "cần bash >= 4"
[[ -f "$FILE" ]] || die "không thấy $FILE"
jq empty "$FILE" 2>/dev/null || die "$FILE không phải JSON hợp lệ"

# ---------- 1. Kiểm tra dữ liệu ----------
errors=$(jq -r '
  (.items | map(.key)) as $keys
  | ((.milestones // []) | map(.key)) as $ms
  | [
      (.items | group_by(.key)[] | select(length > 1) | "Trùng key: \(.[0].key)"),
      (.items[] | select((.key // "") == "" or (.title // "") == "" or (.team // "") == "")
                | "Thiếu key/title/team: \(.key // "?")"),
      (.items[] | select(.parent != null) | . as $i
                | select(($keys | any(. == $i.parent)) | not)
                | "\($i.key): parent \($i.parent) không tồn tại"),
      (.items[] | . as $i | (.blocked_by // [])[]
                | select(. as $b | ($keys | any(. == $b)) | not)
                | "\($i.key): blocked_by \(.) không tồn tại"),
      (.items[] | select(.milestone != null) | . as $i
                | select(($ms | any(. == $i.milestone)) | not)
                | "\($i.key): milestone \($i.milestone) không tồn tại")
    ] | .[]' "$FILE")
[[ -z "$errors" ]] || die $'dữ liệu không hợp lệ:\n'"$errors"

if [[ -z "$REPO" ]]; then
  REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner) || die "không xác định được repo, dùng --repo"
fi

if (( APPLY )); then
  echo "== Chế độ APPLY: ghi lên $REPO =="
else
  echo "== Chế độ CHẠY THỬ trên $REPO (không ghi gì). Thêm --apply để thực hiện =="
fi

# ---------- 2. Nhãn ----------
echo
echo "# Nhãn"
existing_labels=$(gh label list --repo "$REPO" --limit 500 --json name -q '.[].name')

label_specs=$(jq -r '
  ([.items[] | "type:\(.type)"] + [.items[] | "team:\(.team)"] + [.items[] | (.labels // [])[]]
   | unique | map({name: ., color: (if startswith("team:") then "c5def5" else "ededed" end), description: ""})) as $auto
  | ((.labels // []) + $auto) | unique_by(.name)[]
  | [.name, (.color // "ededed"), (.description // "")] | @tsv' "$FILE")

while IFS=$'\t' read -r name color desc; do
  [[ -z "$name" ]] && continue
  if grep -qxF "$name" <<<"$existing_labels"; then
    continue
  fi
  plan "tạo nhãn $name"
  if (( APPLY )); then
    gh label create "$name" --repo "$REPO" --color "$color" --description "$desc" --force >/dev/null
  fi
done <<<"$label_specs"

# ---------- 3. Milestone ----------
echo
echo "# Milestone"
declare -A MS_TITLE=()
existing_ms=$(gh api "repos/$REPO/milestones?state=all&per_page=100" --paginate --jq '.[].title')

while IFS=$'\t' read -r key title due desc; do
  [[ -z "$key" ]] && continue
  MS_TITLE["$key"]="$title"
  if grep -qxF "$title" <<<"$existing_ms"; then
    continue
  fi
  plan "tạo milestone \"$title\"${due:+ (hạn $due)}"
  if (( APPLY )); then
    args=(-X POST "repos/$REPO/milestones" -f "title=$title" -f "description=$desc")
    [[ -n "$due" ]] && args+=(-f "due_on=${due}T00:00:00Z")
    gh api "${args[@]}" >/dev/null
  fi
done < <(jq -r '(.milestones // [])[] | [.key, .title, (.due_on // ""), (.description // "")] | @tsv' "$FILE")

# ---------- 4. Issue, lượt 1: tạo hoặc cập nhật ----------
echo
echo "# Issue"
declare -A NUM=()
while IFS=$'\t' read -r number title; do
  if [[ "$title" =~ ^\[([^]]+)\] ]]; then
    NUM["${BASH_REMATCH[1]}"]="$number"
  fi
done < <(gh issue list --repo "$REPO" --state all --limit 5000 --json number,title -q '.[] | [.number, .title] | @tsv')

body_for() {
  # $1: JSON của item. In nội dung issue, với blocked_by đã đổi thành #số nếu có.
  local item="$1" blocked="" b n
  while IFS= read -r b; do
    [[ -z "$b" ]] && continue
    n="${NUM[$b]:-}"
    if [[ -n "$n" && "$n" != "new" ]]; then blocked+="#$n ($b), "; else blocked+="\`$b\`, "; fi
  done < <(jq -r '(.blocked_by // [])[]' <<<"$item")
  blocked="${blocked%, }"
  jq -r --arg blocked "$blocked" '
    (.body // "")
    + "\n\n---\n"
    + "- Key: `\(.key)`\n"
    + "- Team: \(.team)\n"
    + (if .source then "- Nguồn sự thật: `\(.source)`\n" else "" end)
    + (if $blocked != "" then "- Blocked by: \($blocked)\n" else "" end)
    + "\n_Đồng bộ bởi scripts/backlog-sync.sh từ docs/delivery/backlog.json. Sửa nội dung ở file nguồn, không sửa trực tiếp ở đây._"
  ' <<<"$item"
}

mapfile -t ITEMS < <(jq -c '.items[]' "$FILE")

for item in "${ITEMS[@]}"; do
  key=$(jq -r .key <<<"$item")
  title="[$key] $(jq -r .title <<<"$item")"
  labels=$(jq -r '(["type:\(.type)", "team:\(.team)"] + (.labels // [])) | unique | join(",")' <<<"$item")
  ms_key=$(jq -r '.milestone // ""' <<<"$item")
  ms_title="${MS_TITLE[$ms_key]:-}"

  if [[ -n "${NUM[$key]:-}" ]]; then
    plan "cập nhật #${NUM[$key]} $title"
    if (( APPLY )); then
      args=(issue edit "${NUM[$key]}" --repo "$REPO" --title "$title" --add-label "$labels")
      [[ -n "$ms_title" ]] && args+=(--milestone "$ms_title")
      gh "${args[@]}" >/dev/null
    fi
  else
    plan "tạo issue $title [${labels}]${ms_title:+ → $ms_title}"
    if (( APPLY )); then
      args=(issue create --repo "$REPO" --title "$title" --body "$(body_for "$item")" --label "$labels")
      [[ -n "$ms_title" ]] && args+=(--milestone "$ms_title")
      url=$(gh "${args[@]}")
      NUM["$key"]="${url##*/}"
    else
      NUM["$key"]="new"
    fi
  fi
done

# ---------- 5. Issue, lượt 2: nội dung cuối và sub-issue ----------
echo
echo "# Nội dung và quan hệ cha-con"
for item in "${ITEMS[@]}"; do
  key=$(jq -r .key <<<"$item")
  parent=$(jq -r '.parent // ""' <<<"$item")
  n="${NUM[$key]}"

  if (( APPLY )); then
    gh issue edit "$n" --repo "$REPO" --body "$(body_for "$item")" >/dev/null
  fi

  if [[ -n "$parent" ]]; then
    p="${NUM[$parent]}"
    plan "gắn $key làm sub-issue của $parent"
    if (( APPLY )); then
      child_id=$(gh api "repos/$REPO/issues/$n" --jq .id)
      if ! gh api -X POST "repos/$REPO/issues/$p/sub_issues" -F "sub_issue_id=$child_id" >/dev/null 2>&1; then
        warn "không gắn được sub-issue #$n vào #$p (có thể đã gắn từ trước, hoặc repo chưa hỗ trợ sub-issue)"
      fi
    fi
  fi
done

# ---------- 6. Ghi ánh xạ ----------
if (( APPLY )); then
  {
    for k in "${!NUM[@]}"; do printf '%s\t%s\n' "$k" "${NUM[$k]}"; done
  } | jq -R -s 'split("\n") | map(select(length > 0) | split("\t") | {(.[0]): (.[1] | tonumber)}) | add // {}' \
    > "$MAP_OUT"
  echo
  echo "Đã ghi ánh xạ key -> số issue vào $MAP_OUT. Cập nhật cột Issue trong feature-map.md theo file này."
else
  echo
  echo "Chạy thử xong. Không có gì được ghi. Thêm --apply để thực hiện."
fi
