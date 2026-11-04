# API & event catalog

> Tầng 2 – Hệ thống. Mọi API và event giữa các service. `contracts/` trong mỗi `specs/xxx-…` là chi tiết; file này là danh mục tổng thể để phát hiện trùng lặp và phụ thuộc.

## API đồng bộ

| API | Service cung cấp | Service gọi | Phiên bản | Contract | Tính năng |
| --- | --- | --- | --- | --- | --- |
| `POST /api/v1/orders` | {order-service} | {web, mobile} | v1 | `specs/00x-…/contracts/` | F-00x |
| `GET /api/v1/users/{id}` | {auth-service} | {order-service} | v1 | `specs/000-foundation/contracts/` | F-000 |

## Event bất đồng bộ

| Event | Producer | Consumer | Schema | Tính năng |
| --- | --- | --- | --- | --- |
| `order.created` | {order-service} | {payment-service, notification-service} | {link} | F-00x |
| `payment.succeeded` | {payment-service} | {order-service} | {link} | F-00x |

## Quy tắc

- Không tạo API hoặc event mới trùng chức năng với dòng đã có.
- Thay đổi không tương thích ngược phải tăng phiên bản và giữ bản cũ ít nhất {6 tháng}.
- Tên event: `{entity}.{động từ quá khứ}`.
