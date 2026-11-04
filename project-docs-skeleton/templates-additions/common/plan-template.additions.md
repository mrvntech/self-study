<!-- Chèn mục này vào .specify/templates/plan-template.md, sau phần Constitution Check. -->

**Dựa trên:** `project-docs@{sha}` (`git -C .project rev-parse --short HEAD`) · core constitution v{X.Y.Z}

Constitution Check ở trên gồm cả luật `MUST` trong các profile của repo (core II-c). Ghi mã luật khi có vi phạm hoặc ngoại lệ, ví dụ `INF-22`.

**Đường dẫn sẽ sửa và team** (core II-b): {`src/order/` – Team Order; `migrations/` – Team Order, DBA duyệt; `observability/` – Team Order, SRE duyệt}

## Ảnh hưởng kiến trúc *(bắt buộc)*

| Hạng mục | Thay đổi | Đối chiếu với |
| --- | --- | --- |
| Entity mới hoặc sửa | {không có / danh sách} | `.project/docs/architecture/domain-model.md` |
| API mới hoặc sửa | {…} | `.project/docs/architecture/api-catalog.md` |
| Event mới hoặc sửa | {…} | `.project/docs/architecture/api-catalog.md` |
| Mục HLD cần cập nhật | {…} | `.project/docs/architecture/hld.md` |
| Cần ADR mới? | {Không / ADR-xxxx: lý do} | `.project/docs/architecture/adr/` |

**Cách đáp ứng NFR:**

| NFR | Cách đáp ứng trong plan này |
| --- | --- |
| NFR-xxx | {…} |
