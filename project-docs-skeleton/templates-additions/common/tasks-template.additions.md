<!-- Phần 1: chèn vào đầu .specify/templates/tasks-template.md, cùng chỗ với phần giải thích định dạng task. -->

## Nhãn bắt buộc cho task

Mỗi task mang thêm các nhãn sau, bên cạnh nhãn mặc định của Spec Kit (ví dụ `[P]` cho task chạy song song):

| Nhãn | Bắt buộc | Ý nghĩa | Ví dụ |
| --- | --- | --- | --- |
| `[Team: …]` | Có | Team làm task, theo `.project/docs/delivery/team-map.md` | `[Team: Order]` |
| `[Needs: …]` | Khi có | Cần thứ do tính năng hoặc team khác cung cấp | `[Needs: F-000/T005 auth middleware]`, `[Needs: payment.succeeded v1]` |
| `[Provides: …]` | Khi có | Cung cấp thứ mà tính năng hoặc team khác dùng | `[Provides: order.created v1]`, `[Provides: POST /api/v1/orders]` |
| `[Gate: human]` | Khi có | Con người làm; `/speckit-implement` dừng tại đây | `[Gate: human] Review plan và apply lên staging` |

Ví dụ:

```markdown
- [ ] T012 [Team: Order] [Needs: F-000/T005 auth middleware] Kiểm tra token khi tạo đơn
- [ ] T013 [P] [Team: Order] [Provides: order.created v1] Phát event khi tạo đơn
```

`Needs` và `Provides` dùng đúng tên API/event trong `.project/docs/architecture/api-catalog.md`, để lệnh `/project.plan` ghép được phụ thuộc giữa các tính năng.

<!-- Phần 2: chèn phase này vào cuối .specify/templates/tasks-template.md. -->

## Phase cuối: Đồng bộ tài liệu tổng thể (Definition of Done)

Sửa trong `.project/` trên nhánh `sync/F-xxx` của repo `project-docs` (core constitution mục II). AI sửa file; con người push và mở PR.

- [ ] Cập nhật trạng thái tính năng trong `.project/docs/product/feature-map.md`
- [ ] Đánh dấu REQ đã đáp ứng trong `.project/docs/product/prd.md`
- [ ] Cập nhật cột "Tính năng hiện thực" trong `.project/docs/product/nfr.md`
- [ ] Thêm thuật ngữ mới vào `.project/docs/product/glossary.md`
- [ ] Cập nhật `.project/docs/architecture/domain-model.md` nếu có entity mới hoặc thay đổi
- [ ] Cập nhật `.project/docs/architecture/api-catalog.md` nếu có API/event mới hoặc thay đổi
- [ ] Viết hoặc cập nhật ADR nếu có quyết định kiến trúc mới
- [ ] Cập nhật `.project/docs/architecture/hld.md` và bảng "Lịch sử thay đổi do tính năng"
- [ ] Cập nhật `.project/docs/delivery/dependencies.md`: đánh dấu các `Provides` đã sẵn sàng
- [ ] PR vào `project-docs` đã merge (ghi link PR)
- [ ] Bump `.project/` trong repo này lên commit chứa thay đổi
