#!/usr/bin/env bash
# check-core.sh – Chạy trong repo team. Kiểm tra đoạn core trong constitution của repo
# khớp nguyên văn với .project/constitution/core.md ở commit submodule đang pin.
#
#   .project/scripts/check-core.sh            kiểm tra, lệch thì exit 1 (dùng trong CI)
#   .project/scripts/check-core.sh --write    chép core.md vào giữa hai marker (sau khi bump submodule)
#   .project/scripts/check-core.sh --stale    chỉ báo submodule cũ hơn nhánh chính của project-docs bao nhiêu commit
#
# Không ghi gì ra ngoài repo; --write chỉ sửa file constitution trong working tree.

set -euo pipefail

CONSTITUTION=".specify/memory/constitution.md"
PROJECT_DIR=".project"
MODE="check"

usage() {
  cat <<'EOF'
Cách dùng: .project/scripts/check-core.sh [--write | --stale] [--constitution PATH] [--project-dir PATH]
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --write) MODE="write"; shift ;;
    --stale) MODE="stale"; shift ;;
    --constitution) CONSTITUTION="$2"; shift 2 ;;
    --project-dir) PROJECT_DIR="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Tham số không hợp lệ: $1" >&2; usage; exit 2 ;;
  esac
done

die()  { echo "LỖI: $*" >&2; exit 1; }
warn() { echo "CẢNH BÁO: $*" >&2; }

CORE="$PROJECT_DIR/constitution/core.md"
[[ -f "$CORE" ]] || die "không thấy $CORE. Đã chạy 'git submodule update --init' chưa?"

# ---------- --stale: so commit đang pin với nhánh chính của project-docs ----------
if [[ "$MODE" == "stale" ]]; then
  git -C "$PROJECT_DIR" fetch -q origin || die "không fetch được project-docs"
  head_ref=$(git -C "$PROJECT_DIR" symbolic-ref -q --short refs/remotes/origin/HEAD || echo origin/main)
  behind=$(git -C "$PROJECT_DIR" rev-list --count "HEAD..$head_ref")
  pinned=$(git -C "$PROJECT_DIR" rev-parse --short HEAD)
  if (( behind > 0 )); then
    warn ".project đang pin $pinned, cũ hơn $head_ref $behind commit. Bump: git submodule update --remote $PROJECT_DIR"
    if ! git -C "$PROJECT_DIR" diff --quiet HEAD "$head_ref" -- constitution/core.md; then
      warn "core.md đã đổi trên $head_ref; sau khi bump chạy check-core.sh --write và commit trong cùng PR"
    fi
  else
    echo "OK: .project ($pinned) đã ở commit mới nhất của $head_ref"
  fi
  exit 0
fi

[[ -f "$CONSTITUTION" ]] || die "không thấy $CONSTITUTION"

core_version=$(sed -n 's/.*Phiên bản core: \*\*\([0-9][0-9.]*\)\*\*.*/\1/p' "$CORE" | head -n1)
[[ -n "$core_version" ]] || die "không đọc được 'Phiên bản core: **X.Y.Z**' trong $CORE"

begin_count=$(grep -c '^<!-- core:begin v[0-9.]* -->$' "$CONSTITUTION" || true)
end_count=$(grep -c '^<!-- core:end -->$' "$CONSTITUTION" || true)
[[ "$begin_count" == 1 && "$end_count" == 1 ]] \
  || die "$CONSTITUTION phải có đúng một '<!-- core:begin vX.Y.Z -->' và một '<!-- core:end -->' (đang có $begin_count và $end_count)"

begin_line=$(grep -n '^<!-- core:begin v[0-9.]* -->$' "$CONSTITUTION" | cut -d: -f1)
end_line=$(grep -n '^<!-- core:end -->$' "$CONSTITUTION" | cut -d: -f1)
(( begin_line < end_line )) || die "marker core:end đứng trước core:begin"
marker_version=$(sed -n "${begin_line}s/^<!-- core:begin v\([0-9.]*\) -->$/\1/p" "$CONSTITUTION")

# Nội dung giữa hai marker, bỏ dòng trống ở đầu và cuối.
trim() { sed -e '/./,$!d' | tac | sed -e '/./,$!d' | tac; }
current=$(sed -n "$((begin_line + 1)),$((end_line - 1))p" "$CONSTITUTION" | trim)
expected=$(trim < "$CORE")

if [[ "$MODE" == "write" ]]; then
  tmp=$(mktemp)
  {
    head -n "$((begin_line - 1))" "$CONSTITUTION"
    echo "<!-- core:begin v$core_version -->"
    printf '%s\n' "$expected"
    tail -n "+$end_line" "$CONSTITUTION"
  } > "$tmp"
  mv "$tmp" "$CONSTITUTION"
  echo "Đã chép core v$core_version ($(git -C "$PROJECT_DIR" rev-parse --short HEAD)) vào $CONSTITUTION. Xem lại: git diff $CONSTITUTION"
  exit 0
fi

status=0
if [[ "$marker_version" != "$core_version" ]]; then
  echo "LỖI: marker ghi core v$marker_version nhưng $CORE là v$core_version" >&2
  status=1
fi
if [[ "$current" != "$expected" ]]; then
  echo "LỖI: đoạn core trong $CONSTITUTION khác $CORE ở commit $(git -C "$PROJECT_DIR" rev-parse --short HEAD):" >&2
  diff -u --label "$CORE" --label "$CONSTITUTION (core)" <(printf '%s\n' "$expected") <(printf '%s\n' "$current") >&2 || true
  status=1
fi

if (( status )); then
  echo "Sửa: không sửa tay đoạn core. Chạy .project/scripts/check-core.sh --write rồi commit; muốn đổi luật thì mở PR vào project-docs." >&2
  exit 1
fi
echo "OK: core v$core_version khớp $CORE"
