#!/usr/bin/env bash
# workspace-sync.sh – Chạy trong repo project-docs. Clone hoặc cập nhật mọi repo team
# (theo bảng "Danh sách repo" trong docs/delivery/team-map.md) vào workspace/, để các lệnh
# /project.review, /project.plan, /project.backlog --with-tasks đọc specs/ của mọi team.
#
# workspace/ nằm trong .gitignore và chỉ để đọc: không sửa, không commit trong đó.
#
#   scripts/workspace-sync.sh                     clone/pull nhánh mặc định của mọi repo
#   scripts/workspace-sync.sh --base git@github.com:acme/
#   scripts/workspace-sync.sh --list              chỉ in danh sách repo đọc được từ team-map
#
# Yêu cầu: git; quyền đọc các repo team.

set -euo pipefail

TEAM_MAP="docs/delivery/team-map.md"
WORKSPACE="workspace"
BASE=""
LIST_ONLY=0

usage() {
  cat <<'EOF'
Cách dùng: scripts/workspace-sync.sh [--base URL_PREFIX] [--team-map PATH] [--workspace DIR] [--list]

  --base       Tiền tố URL git của repo team, ví dụ git@github.com:acme/ hoặc https://gitlab.example.com/shop/
               (mặc định: lấy từ remote origin của repo hiện tại, bỏ tên repo ở cuối)
  --list       Chỉ in danh sách repo, không clone
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base) BASE="$2"; shift 2 ;;
    --team-map) TEAM_MAP="$2"; shift 2 ;;
    --workspace) WORKSPACE="$2"; shift 2 ;;
    --list) LIST_ONLY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Tham số không hợp lệ: $1" >&2; usage; exit 2 ;;
  esac
done

die()  { echo "LỖI: $*" >&2; exit 1; }
warn() { echo "CẢNH BÁO: $*" >&2; }

[[ -f "$TEAM_MAP" ]] || die "không thấy $TEAM_MAP"

# Cột đầu của bảng dưới tiêu đề "## Danh sách repo", dạng `tên-repo`.
mapfile -t REPOS < <(awk '
  /^## / { in_table = ($0 ~ /^## Danh sách repo/) ; next }
  in_table && /^\| *`/ {
    split($0, cells, "|"); name = cells[2]
    gsub(/[ `]/, "", name); print name
  }' "$TEAM_MAP")

(( ${#REPOS[@]} > 0 )) || die "không đọc được repo nào từ bảng \"Danh sách repo\" trong $TEAM_MAP"

if [[ -z "$BASE" ]]; then
  origin=$(git remote get-url origin 2>/dev/null) || die "không có remote origin; dùng --base"
  # git@host:org/project-docs.git -> git@host:org/ ; https://host/org/project-docs -> https://host/org/
  [[ "$origin" =~ ^(.*[:/])[^:/]+$ ]] || die "không tách được tiền tố từ '$origin'; dùng --base"
  BASE="${BASH_REMATCH[1]}"
fi

mkdir -p "$WORKSPACE"
ok=0; skipped=0; failed=0
for repo in "${REPOS[@]}"; do
  if [[ "$repo" == "project-docs" ]]; then continue; fi
  if [[ "$repo" == *"{"* || "$repo" == *"}"* ]]; then
    warn "bỏ qua '$repo': tên còn là placeholder trong team-map"; skipped=$((skipped + 1)); continue
  fi
  url="${BASE}${repo}.git"
  dir="$WORKSPACE/$repo"
  if (( LIST_ONLY )); then echo "$repo  $url"; continue; fi

  if [[ -d "$dir/.git" ]]; then
    echo "# Cập nhật $repo"
    if git -C "$dir" fetch -q origin && git -C "$dir" checkout -q --detach "$(git -C "$dir" symbolic-ref -q --short refs/remotes/origin/HEAD || echo origin/main)"; then
      ok=$((ok + 1))
    else
      warn "không cập nhật được $repo"; failed=$((failed + 1))
    fi
  else
    echo "# Clone $repo từ $url"
    if git clone -q "$url" "$dir"; then ok=$((ok + 1)); else warn "không clone được $url"; failed=$((failed + 1)); fi
  fi
done

(( LIST_ONLY )) && exit 0
echo
echo "Xong: $ok repo sẵn sàng trong $WORKSPACE/, $skipped bỏ qua, $failed lỗi."
echo "Bản checkout ở trạng thái detached theo nhánh chính của từng repo; chỉ dùng để đọc."
(( failed == 0 ))
