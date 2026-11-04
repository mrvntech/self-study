# API & event catalog

Trạng thái: Draft (AI) · Cập nhật: 2026-11-02 · Mức đầu, rút từ PRD và event storming; tên service là tên dự kiến ở HLD mục 3

> Tầng 2 – Hệ thống. Mọi API và event giữa các service. `contracts/` trong mỗi `specs/xxx-…` là chi tiết; file này là danh mục tổng thể để phát hiện trùng lặp và phụ thuộc.

## API đồng bộ

| API | Service cung cấp | Service gọi | Phiên bản | Contract | Tính năng | Ghi chú |
| --- | --- | --- | --- | --- | --- | --- |
| `POST /api/v1/customers` (đăng ký) | identity-service | customer-web | v1 | {chưa có} | F-001 | Hình dạng phụ thuộc IdP {theo ADR-0005} |
| `GET /api/v1/customers/me` | identity-service | customer-web | v1 | {chưa có} | F-001 | |
| `GET /api/v1/customers/{id}/contact` | identity-service | notification-service | v1 | {chưa có} | F-004 | Hoặc mang thông tin liên hệ trong event – cân nhắc NFR-004 |
| `GET /api/v1/products?q=` | catalog-service | customer-web | v1 | {chưa có} | F-002 | Danh mục, tìm theo tên {theo ADR-0009} |
| `GET /api/v1/products/{id}` | catalog-service | customer-web, sales-service | v1 | {chưa có} | F-002, F-003 | Sales lấy giá lúc đặt hàng |
| `GET /api/v1/carts/me`, `POST /api/v1/carts/me/items`, `DELETE /api/v1/carts/me/items/{productId}` | sales-service | customer-web | v1 | {chưa có} | F-003 | |
| `POST /api/v1/orders` | sales-service | customer-web | v1 | {chưa có} | F-003 | Phát `order.created` |
| `GET /api/v1/orders`, `GET /api/v1/orders/{id}` | sales-service | customer-web | v1 | {chưa có} | F-004 | Khách xem trạng thái đơn |
| `GET /api/v1/admin/orders?…`, `PATCH /api/v1/admin/orders/{id}/status` | sales-service | cskh-web | v1 | {chưa có} | F-005 | Token SSO Keycloak; phát `order.status_changed` |
| `POST /api/v1/payments/{orderId}/checkout` | payment-service | customer-web | v1 | {chưa có} | F-003 | Trả URL redirect / phiên tokenization {theo ADR-0007} |
| `POST /api/v1/payments/callbacks/{gateway}` | payment-service | Cổng thanh toán (ngoài) | v1 | {chưa có} | F-003 | Kiểm chữ ký, idempotent |
| Giữ / hủy giữ tồn kho trên ERP | ERP (qua ERP integration) | sales-service | {cần xác nhận} | {chưa có} | F-003 | H1, Q-04; {theo ADR-0008} |
| Đọc sản phẩm, giá, tồn kho từ ERP | ERP (qua ERP integration) | catalog-service | {cần xác nhận} | {chưa có} | F-002 | {theo ADR-0008} |
| Gửi email/SMS | Email/SMS gateway (ngoài) | notification-service | {cần xác nhận} | {chưa có} | F-004 | Q-06 |

## Event bất đồng bộ

| Event | Producer | Consumer | Schema | Tính năng | Nguồn |
| --- | --- | --- | --- | --- | --- |
| `customer.registered` | identity-service | notification-service | {chưa có} | F-001, F-004 | event storming #1 |
| `product.updated` | catalog-service | {chưa có consumer trong event storming} | {chưa có} | F-002 | event storming #2 |
| `order.created` | sales-service | payment-service | {chưa có} | F-003 | event storming #3 |
| `payment.succeeded` | payment-service | sales-service, notification-service | {chưa có} | F-003, F-004 | event storming #4 |
| `payment.failed` | payment-service | sales-service, notification-service | {chưa có} | F-003, F-004 | event storming #5 |
| `order.status_changed` | sales-service | notification-service | {chưa có} | F-004, F-005 | event storming #6 |
| `order.shipped` | ERP integration {theo ADR-0008} | sales-service, notification-service | {chưa có} | F-004 | event storming #7; Q-04 |

## Quy tắc

- Không tạo API hoặc event mới trùng chức năng với dòng đã có.
- Thay đổi không tương thích ngược phải tăng phiên bản và giữ bản cũ ít nhất {cần xác nhận – Architect}.
- Tên event: `{entity}.{động từ quá khứ}`.
