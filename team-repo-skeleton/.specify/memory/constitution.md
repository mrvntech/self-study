# Constitution – {order-service} ({Team Order})

> Gồm hai phần:
> 1. **Core** giữa hai marker: chép nguyên văn từ `.project/constitution/core.md` ở commit submodule đang pin. Không sửa ở repo này; CI báo lỗi nếu lệch. Khi chạy `/speckit-constitution`, giữ nguyên đoạn giữa hai marker.
> 2. **Phần riêng của team** sau marker `core:end`: khởi tạo từ `.project/constitution/team-parts/dev.md` hoặc `infra.md`, Tech Lead của team giữ.

<!-- core:begin v1.0.0 -->
{Dán toàn bộ nội dung .project/constitution/core.md vào đây; đổi v1.0.0 ở marker cho khớp phiên bản trong file.}
<!-- core:end -->

{Dán phần riêng từ .project/constitution/team-parts/<dev|infra>.md vào đây rồi điền.}

## Governance

- **Phiên bản phần riêng:** 1.0.0 · **Phê chuẩn:** {YYYY-MM-DD} · **Sửa lần cuối:** {YYYY-MM-DD}
- Sửa phần riêng: PR trong repo này, Tech Lead của team duyệt. Luật chạm tới trách nhiệm team khác cần team đó duyệt (core II-c).
- Sửa core: PR vào repo `project-docs`, Solution Architect duyệt. Sau khi merge, bump `.project/` rồi chép lại đoạn core trong cùng một PR.
- Đổi phiên bản phần riêng theo semver như core.
