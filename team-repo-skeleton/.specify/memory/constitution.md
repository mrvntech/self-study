# Constitution – {order-service}

> Gồm hai phần:
> 1. **Core** giữa hai marker: chép nguyên văn từ `.project/constitution/core.md` ở commit submodule đang pin. Không sửa ở repo này; CI báo lỗi nếu lệch. Khi chạy `/speckit-constitution`, giữ nguyên đoạn giữa hai marker.
> 2. **Profile** sau marker `core:end`: một hoặc nhiều profile từ `.project/constitution/profiles/`, theo cột Profile của repo này trong bảng "Danh sách repo" (`team-map.md`). Mỗi mục trong profile có team giữ riêng (core II-c).

<!-- core:begin v1.0.0 -->
{Dán toàn bộ nội dung .project/constitution/core.md vào đây; đổi v1.0.0 ở marker cho khớp phiên bản trong file.}
<!-- core:end -->

{Dán từng profile của repo, theo thứ tự trong cột Profile, ví dụ repo infra: infra.md → observability.md → security-policy.md. Điền {…}, xoá luật không áp dụng.}

## Governance

- **Phiên bản phần profile:** 1.0.0 · **Phê chuẩn:** {YYYY-MM-DD} · **Sửa lần cuối:** {YYYY-MM-DD}
- Sửa luật trong profile: PR trong repo này, team giữ mục đó duyệt (ghi ở tiêu đề mục). Mục do team khác giữ (ví dụ DBA, SRE) thì PR phải có người của team đó approve. CODEOWNERS không bắt được việc này vì cả file chỉ có một dòng owner, nên người review của team giữ repo tự kiểm.
- Sửa core hoặc khung profile dùng chung: PR vào repo `project-docs`, Solution Architect duyệt. Sau khi merge, bump `.project/` rồi chép lại đoạn core trong cùng một PR.
- Đổi phiên bản phần profile theo semver như core.
