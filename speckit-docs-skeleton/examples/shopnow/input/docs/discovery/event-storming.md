# Event storming

Trạng thái: Approved · Người tham gia: PO, BA, Architect (Quang), Lead Alpha/Beta · Ngày: 2026-10-10

| # | Actor / hệ thống | Command | Event | Chính sách | Bounded context |
| --- | --- | --- | --- | --- | --- |
| 1 | Khách hàng | Đăng ký | Khách hàng đã đăng ký | Gửi email chào mừng | Identity |
| 2 | ERP | Đồng bộ giá, tồn kho | Sản phẩm đã được cập nhật | — | Catalog |
| 3 | Khách hàng | Đặt hàng | Đơn hàng đã được tạo | Yêu cầu thanh toán; giữ tồn kho trên ERP | Sales |
| 4 | Cổng thanh toán | Xác nhận thanh toán | Thanh toán đã thành công | Xác nhận đơn; gửi thông báo | Payment |
| 5 | Cổng thanh toán | Báo thất bại | Thanh toán đã thất bại | Hủy giữ tồn kho; gửi thông báo | Payment |
| 6 | Nhân viên CSKH | Cập nhật trạng thái | Trạng thái đơn đã thay đổi | Gửi thông báo cho khách | Sales |
| 7 | ERP | Xuất kho | Đơn hàng đã được giao cho vận chuyển | Gửi thông báo cho khách | Fulfillment (ERP) |

## Bounded context

| Context | Trách nhiệm | Entity chính | Event phát ra | Event lắng nghe | Team dự kiến |
| --- | --- | --- | --- | --- | --- |
| Identity | Tài khoản khách, đăng nhập | User, Customer | `customer.registered` | — | Team Beta |
| Catalog | Sản phẩm, tìm kiếm, đồng bộ ERP | Product | `product.updated` | — | Team Alpha |
| Sales | Giỏ hàng, đơn hàng, màn hình CSKH | Cart, Order | `order.created`, `order.status_changed` | `payment.succeeded`, `payment.failed`, `order.shipped` | Team Alpha |
| Payment | Thanh toán qua cổng ngân hàng | Payment | `payment.succeeded`, `payment.failed` | `order.created` | Team Beta |
| Notification | Gửi email/SMS | Notification | — | `customer.registered`, `payment.*`, `order.status_changed`, `order.shipped` | |

## Điểm nóng

| Điểm nóng | Mô tả | Người xử lý |
| --- | --- | --- |
| H1 | Giữ tồn kho trên ERP: API ERP chậm, chưa rõ có hỗ trợ giữ hàng không | Architect, IT |
| H2 | Notification chưa có team nhận | EM |
