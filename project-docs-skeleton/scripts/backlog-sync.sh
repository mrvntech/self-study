#!/usr/bin/env bash
# backlog-sync.sh – Đồng bộ docs/delivery/backlog.json lên GitHub Issues, nhiều repo.
#
# Feature, enabler, contract (item không có "repo") tạo ở repo mặc định, thường là
# project-docs. Task (item có "repo") tạo ở repo của team, rồi gắn làm sub-issue của
# feature cha ở project-docs.
#
# Mặc định chạy thử (dry-run): chỉ đọc GitHub và in ra việc sẽ làm.
# Thêm --apply để tạo/cập nhật nhãn, milestone, issue và liên kết sub-issue.
#
# Idempotent: issue được nhận diện bằng tiền tố "[KEY]" trong tiêu đề, trong đúng repo
# đích của item, nên chạy lại chỉ cập nhật, không tạo trùng.
#
# Yêu cầu: gh (đã gh auth login, có quyền ghi issue ở mọi repo đích), jq, bash >= 4.

set -euo pipefail

FILE="docs/delivery/backlog.json"
MAP_OUT="docs/delivery/backlog-issues.json"
REPO=""
OWNER=""
APPLY=0

usage() {
  cat <<'EOF'
Cách dùng: scripts/backlog-sync.sh [--apply] [--repo OWNER/NAME] [--owner OWNER] [--file PATH] [--map-out PATH]

  --apply          Thực sự ghi lên GitHub (mặc định chỉ chạy thử)
  --repo           Repo mặc định cho item không có "repo" (mặc định: repo của thư mục hiện tại)
  --owner          Owner/org cho "repo" ghi tên ngắn (mặc định: owner của --repo)
  --file           File backlog (mặc định: docs/delivery/backlog.json)
  --map-out        File ghi ánh xạ key -> owner/repo#số (mặc định: docs/delivery/backlog-issues.json)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --apply) APPLY=1; shift ;;
    --repo) REPO="$2"; shift 2 ;;
    --owner) OWNER="$2"; shift 2 ;;
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
      (.items[] | select(.repo != null and ((.repo | type) != "string" or .repo == ""))
                | "\(.key): repo phải là chuỗi khác rỗng hoặc null"),
      (.items[] | select(.type == "task" and .repo == null)
                | "\(.key): task phải có repo (repo chứa tasks.md)"),
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
[[ -n "$OWNER" ]] || OWNER="${REPO%%/*}"

resolve_repo() {
  # $1: giá trị "repo" của item (rỗng = repo mặc định).
  if [[ -z "$1" ]]; then echo "$REPO"
  elif [[ "$1" == */* ]]; then echo "$1"
  else echo "$OWNER/$1"
  fi
}

mapfile -t ITEMS < <(jq -c '.items[]' "$FILE")
declare -A ITEM_REPO=()
declare -A TARGETS=()
for item in "${ITEMS[@]}"; do
  key=$(jq -r .key <<<"$item")
  r=$(resolve_repo "$(jq -r '.repo // ""' <<<"$item")")
  ITEM_REPO["$key"]="$r"
  TARGETS["$r"]=1
done

if (( APPLY )); then
  echo "== Chế độ APPLY: ghi lên ${!TARGETS[*]} =="
else
  echo "== Chế độ CHẠY THỬ trên ${!TARGETS[*]} (không ghi gì). Thêm --apply để thực hiện =="
fi

for r in "${!TARGETS[@]}"; do
  gh repo view "$r" --json name >/dev/null 2>&1 || die "không truy cập được repo $r (sai tên trong \"repo\", hoặc thiếu quyền)"
done

# ---------- 2. Nhãn, theo từng repo ----------
echo
echo "# Nhãn"
for r in "${!TARGETS[@]}"; do
  existing_labels=$(gh label list --repo "$r" --limit 500 --json name -q '.[].name')
  label_specs=$(jq -r --arg r "$r" --arg def "$REPO" --arg owner "$OWNER" '
    def target: if .repo == null then $def elif (.repo | contains("/")) then .repo else "\($owner)/\(.repo)" end;
    ([.items[] | select(target == $r) | "type:\(.type)", "team:\(.team)", (.labels // [])[]]
     | unique | map({name: ., color: (if startswith("team:") then "c5def5" else "ededed" end), description: ""})) as $auto
    | ([(.labels // [])[] | select(.name as $n | $auto | any(.name == $n))] + $auto) | unique_by(.name)[]
    | [.name, (.color // "ededed"), (.description // "")] | @tsv' "$FILE")
  while IFS=$'\t' read -r name color desc; do
    [[ -z "$name" ]] && continue
    grep -qxF "$name" <<<"$existing_labels" && continue
    plan "$r: tạo nhãn $name"
    if (( APPLY )); then
      gh label create "$name" --repo "$r" --color "$color" --description "$desc" --force >/dev/null
    fi
  done <<<"$label_specs"
done

# ---------- 3. Milestone, theo từng repo có item dùng milestone ----------
echo
echo "# Milestone"
declare -A MS_TITLE=()
while IFS=$'\t' read -r key title due desc; do
  [[ -n "$key" ]] && MS_TITLE["$key"]="$title"
done < <(jq -r '(.milestones // [])[] | [.key, .title, (.due_on // ""), (.description // "")] | @tsv' "$FILE")

for r in "${!TARGETS[@]}"; do
  existing_ms=$(gh api "repos/$r/milestones?state=all&per_page=100" --paginate --jq '.[].title')
  while IFS=$'\t' read -r key title due desc; do
    [[ -z "$key" ]] && continue
    used=$(jq -r --arg k "$key" --arg r "$r" --arg def "$REPO" --arg owner "$OWNER" '
      def target: if .repo == null then $def elif (.repo | contains("/")) then .repo else "\($owner)/\(.repo)" end;
      [.items[] | select(.milestone == $k and target == $r)] | length' "$FILE")
    (( used > 0 )) || continue
    grep -qxF "$title" <<<"$existing_ms" && continue
    plan "$r: tạo milestone \"$title\"${due:+ (hạn $due)}"
    if (( APPLY )); then
      args=(-X POST "repos/$r/milestones" -f "title=$title" -f "description=$desc")
      [[ -n "$due" ]] && args+=(-f "due_on=${due}T00:00:00Z")
      gh api "${args[@]}" >/dev/null
    fi
  done < <(jq -r '(.milestones // [])[] | [.key, .title, (.due_on // ""), (.description // "")] | @tsv' "$FILE")
done

# ---------- 4. Issue, lượt 1: tạo hoặc cập nhật ----------
echo
echo "# Issue"
declare -A NUM=()        # key -> số issue trong repo đích của key ("new" khi chạy thử)
for r in "${!TARGETS[@]}"; do
  while IFS=$'\t' read -r number title; do
    if [[ "$title" =~ ^\[([^]]+)\] ]]; then
      k="${BASH_REMATCH[1]}"
      [[ "${ITEM_REPO[$k]:-}" == "$r" ]] && NUM["$k"]="$number"
    fi
  done < <(gh issue list --repo "$r" --state all --limit 5000 --json number,title -q '.[] | [.number, .title] | @tsv')
done

ref_for() {
  # $1: key. In "owner/repo#số" nếu đã có số issue, ngược lại in `key`.
  local n="${NUM[$1]:-}"
  if [[ -n "$n" && "$n" != "new" ]]; then echo "${ITEM_REPO[$1]}#$n"; else echo "\`$1\`"; fi
}

body_for() {
  # $1: JSON của item. In nội dung issue, blocked_by đổi thành owner/repo#số nếu có.
  local item="$1" blocked="" b
  while IFS= read -r b; do
    [[ -z "$b" ]] && continue
    blocked+="$(ref_for "$b") ($b), "
  done < <(jq -r '(.blocked_by // [])[]' <<<"$item")
  blocked="${blocked%, }"
  jq -r --arg blocked "$blocked" '
    (.body // "")
    + "\n\n---\n"
    + "- Key: `\(.key)`\n"
    + "- Team: \(.team)\n"
    + (if .source then "- Nguồn sự thật: `\(.source)`\n" else "" end)
    + (if $blocked != "" then "- Blocked by: \($blocked)\n" else "" end)
    + "\n_Đồng bộ bởi scripts/backlog-sync.sh từ docs/delivery/backlog.json trong project-docs. Sửa nội dung ở file nguồn, không sửa trực tiếp ở đây._"
  ' <<<"$item"
}

for item in "${ITEMS[@]}"; do
  key=$(jq -r .key <<<"$item")
  r="${ITEM_REPO[$key]}"
  title="[$key] $(jq -r .title <<<"$item")"
  labels=$(jq -r '(["type:\(.type)", "team:\(.team)"] + (.labels // [])) | unique | join(",")' <<<"$item")
  ms_key=$(jq -r '.milestone // ""' <<<"$item")
  ms_title="${MS_TITLE[$ms_key]:-}"

  if [[ -n "${NUM[$key]:-}" ]]; then
    plan "$r: cập nhật #${NUM[$key]} $title"
    if (( APPLY )); then
      args=(issue edit "${NUM[$key]}" --repo "$r" --title "$title" --add-label "$labels")
      [[ -n "$ms_title" ]] && args+=(--milestone "$ms_title")
      gh "${args[@]}" >/dev/null
    fi
  else
    plan "$r: tạo issue $title [${labels}]${ms_title:+ → $ms_title}"
    if (( APPLY )); then
      args=(issue create --repo "$r" --title "$title" --body "$(body_for "$item")" --label "$labels")
      [[ -n "$ms_title" ]] && args+=(--milestone "$ms_title")
      url=$(gh "${args[@]}")
      NUM["$key"]="${url##*/}"
    else
      NUM["$key"]="new"
    fi
  fi
done

# ---------- 5. Issue, lượt 2: nội dung cuối và sub-issue (có thể xuyên repo) ----------
echo
echo "# Nội dung và quan hệ cha-con"
for item in "${ITEMS[@]}"; do
  key=$(jq -r .key <<<"$item")
  parent=$(jq -r '.parent // ""' <<<"$item")
  r="${ITEM_REPO[$key]}"
  n="${NUM[$key]}"

  if (( APPLY )); then
    gh issue edit "$n" --repo "$r" --body "$(body_for "$item")" >/dev/null
  fi

  if [[ -n "$parent" ]]; then
    pr="${ITEM_REPO[$parent]}"
    p="${NUM[$parent]}"
    plan "gắn $key ($r) làm sub-issue của $parent ($pr)"
    if (( APPLY )); then
      child_id=$(gh api "repos/$r/issues/$n" --jq .id)
      if ! gh api -X POST "repos/$pr/issues/$p/sub_issues" -F "sub_issue_id=$child_id" >/dev/null 2>&1; then
        warn "không gắn được $r#$n vào $pr#$p (có thể đã gắn từ trước, repo chưa hỗ trợ sub-issue, hoặc hai repo khác owner)"
      fi
    fi
  fi
done

# ---------- 6. Ghi ánh xạ ----------
if (( APPLY )); then
  {
    for k in "${!NUM[@]}"; do printf '%s\t%s#%s\n' "$k" "${ITEM_REPO[$k]}" "${NUM[$k]}"; done
  } | jq -R -s 'split("\n") | map(select(length > 0) | split("\t") | {(.[0]): .[1]}) | add // {}' \
    > "$MAP_OUT"
  echo
  echo "Đã ghi ánh xạ key -> owner/repo#số vào $MAP_OUT. Cập nhật cột Issue trong feature-map.md theo file này."
else
  echo
  echo "Chạy thử xong. Không có gì được ghi. Thêm --apply để thực hiện."
fi
