# Khung tài liệu tổng thể cho dự án dùng Spec Kit

Bộ khung này giữ cái nhìn tổng thể (tầng sản phẩm và tầng hệ thống) cho dự án phát triển bằng Spec Kit. Giải thích chi tiết: [../speckit-big-picture.md](../speckit-big-picture.md).

## Cách dùng

1. Copy toàn bộ thư mục này (kể cả các thư mục ẩn `.specify/` và `.claude/`) vào gốc dự án **sau khi** đã chạy `specify init`.
2. Gộp `.specify/memory/constitution.md` với constitution sẵn có của dự án, hoặc dùng lệnh `/speckit.constitution` để AI gộp giúp.
3. Chèn nội dung trong `.specify/templates-additions/` vào cuối các template tương ứng trong `.specify/templates/` (`spec-template.md`, `plan-template.md`, `tasks-template.md`).
4. Điền Giai đoạn 0 theo thứ tự: `prd.md` → `feature-map.md` → `nfr.md` → `glossary.md` → `hld.md` → `domain-model.md` → `api-catalog.md`.
5. Điền tầng điều phối: `team-map.md` → gán team cho từng tính năng trong `feature-map.md` → `release-plan.md`.
6. Chạy Spec Kit cho `000-foundation` trước, sau đó các team làm song song các tính năng của mình theo `feature-map.md`.
7. Định kỳ chạy:
   - `/project.review`: kiểm tra chéo nội dung giữa các tính năng.
   - `/project.plan`: tổng hợp việc theo team, phụ thuộc, đường găng; cập nhật `dependencies.md` và `release-plan.md` sau khi duyệt.

Tên thư mục và template của Spec Kit có thể khác theo phiên bản. Đối chiếu với README của [github/spec-kit](https://github.com/github/spec-kit). Thư mục lệnh `.claude/commands/` dành cho Claude Code; agent khác dùng thư mục lệnh riêng.

## Cấu trúc

```
docs/
├── product/
│   ├── prd.md
│   ├── feature-map.md
│   ├── nfr.md
│   └── glossary.md
├── architecture/
│   ├── hld.md
│   ├── domain-model.md
│   ├── api-catalog.md
│   └── adr/
│       └── 0000-template.md
└── delivery/
    ├── team-map.md
    ├── release-plan.md
    └── dependencies.md
.specify/
├── memory/constitution.md
└── templates-additions/
    ├── spec-template.additions.md
    ├── plan-template.additions.md
    └── tasks-template.additions.md
.claude/commands/
├── project.review.md
└── project.plan.md
```

| Tầng | Thư mục | Trả lời |
| --- | --- | --- |
| 1. Sản phẩm | `docs/product/` | Làm gì, cho ai, theo thứ tự nào |
| 2. Hệ thống | `docs/architecture/` | Các phần ghép với nhau thế nào |
| 2.5. Điều phối | `docs/delivery/` | Team nào làm gì, chờ ai, khi nào tích hợp |
| 3. Tính năng | `specs/` (Spec Kit sinh) | Tính năng này làm gì, xây thế nào |

## Quy ước mã

| Tiền tố | Ý nghĩa | Định nghĩa ở |
| --- | --- | --- |
| `REQ-xx` | Yêu cầu cấp sản phẩm | `docs/product/prd.md` |
| `F-xxx` | Tính năng (ứng với `specs/xxx-…`) | `docs/product/feature-map.md` |
| `NFR-xxx` | Yêu cầu phi chức năng dùng chung | `docs/product/nfr.md` |
| `ADR-xxxx` | Quyết định kiến trúc | `docs/architecture/adr/` |
| `D-xx` | Phụ thuộc giữa các team | `docs/delivery/dependencies.md` |
| `M0`, `M1`… | Mốc release, mốc tích hợp | `docs/delivery/release-plan.md` |
| `[Team: …]`, `[Needs: …]`, `[Provides: …]` | Nhãn task | `specs/xxx-…/tasks.md` |
| `FR-xxx`, `SC-xxx` | Requirement và success criteria trong một tính năng | `specs/xxx-…/spec.md` (Spec Kit sinh) |
