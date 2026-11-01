<!-- Phần 1: chèn vào đầu .specify/templates/tasks-template.md, cùng chỗ với phần giải thích định dạng task. -->

## Nhãn bắt buộc cho task

Mỗi task mang thêm các nhãn sau, bên cạnh nhãn mặc định của Spec Kit (ví dụ `[P]` cho task chạy song song):

| Nhãn | Bắt buộc | Ý nghĩa | Ví dụ |
| --- | --- | --- | --- |
| `[Team: …]` | Có | Team làm task, theo `docs/delivery/team-map.md` | `[Team: Order]` |
| `[Needs: …]` | Khi có | Cần thứ do tính năng hoặc team khác cung cấp | `[Needs: F-000/T005 auth middleware]`, `[Needs: payment.succeeded v1]` |
| `[Provides: …]` | Khi có | Cung cấp thứ mà tính năng hoặc team khác dùng | `[Provides: order.created v1]`, `[Provides: POST /api/v1/orders]` |

Ví dụ:

```markdown
- [ ] T012 [Team: Order] [Needs: F-000/T005 auth middleware] Kiểm tra token khi tạo đơn
- [ ] T013 [P] [Team: Order] [Provides: order.created v1] Phát event khi tạo đơn
```

`Needs` và `Provides` dùng đúng tên API/event trong `docs/architecture/api-catalog.md`, để lệnh `/project.plan` ghép được phụ thuộc giữa các tính năng.

<!-- Phần 2: chèn phase này vào cuối .specify/templates/tasks-template.md. -->

## Phase cuối: Đồng bộ tài liệu tổng thể (Definition of Done)

- [ ] Cập nhật trạng thái tính năng trong `docs/product/feature-map.md`
- [ ] Đánh dấu REQ đã đáp ứng trong `docs/product/prd.md`
- [ ] Cập nhật cột "Tính năng hiện thực" trong `docs/product/nfr.md`
- [ ] Thêm thuật ngữ mới vào `docs/product/glossary.md`
- [ ] Cập nhật `docs/architecture/domain-model.md` nếu có entity mới hoặc thay đổi
- [ ] Cập nhật `docs/architecture/api-catalog.md` nếu có API/event mới hoặc thay đổi
- [ ] Viết hoặc cập nhật ADR nếu có quyết định kiến trúc mới
- [ ] Cập nhật `docs/architecture/hld.md` và bảng "Lịch sử thay đổi do tính năng"
- [ ] Cập nhật `docs/delivery/dependencies.md`: đánh dấu các `Provides` đã sẵn sàng
