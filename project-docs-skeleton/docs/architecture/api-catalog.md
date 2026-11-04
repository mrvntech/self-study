# API & event catalog

> Tầng 2 – Hệ thống. Mọi API và event giữa các service. `contracts/` trong mỗi `<repo>:specs/F-xxx-…` là chi tiết; file này là danh mục tổng thể để phát hiện trùng lặp và phụ thuộc.

## API đồng bộ

| API | Service cung cấp | Service gọi | Phiên bản | Contract | Tính năng |
| --- | --- | --- | --- | --- | --- |
| `POST /api/v1/orders` | {order-service} | {web, mobile} | v1 | `{order-service}:specs/F-00x-…/contracts/` | F-00x |
| `GET /api/v1/users/{id}` | {auth-service} | {order-service} | v1 | `{auth-service}:specs/F-001-…/contracts/` | F-001 |

## Event bất đồng bộ

| Event | Producer | Consumer | Schema | Tính năng |
| --- | --- | --- | --- | --- |
| `order.created` | {order-service} | {payment-service, notification-service} | {link} | F-00x |
| `payment.succeeded` | {payment-service} | {order-service} | {link} | F-00x |

## Tài nguyên hạ tầng

Tài nguyên do Infra (hoặc team chuyên môn khác) cung cấp cho team khác dùng. Cột Tên là tên dùng trong `[Provides: …]`, `[Needs: …]`.

| Tên | Loại | Team cung cấp | Team dùng | Công bố tại | Contract | Tính năng |
| --- | --- | --- | --- | --- | --- | --- |
| `rds-order-db` | {RDS PostgreSQL, Multi-AZ} | {Infra} | {Team Order} | `/{project}/{env}/order-db/` (SSM) | `{infra}:specs/F-00x-…/contracts/` | F-00x |
| `irsa-order-service` | {IAM role cho service account} | {Infra} | {Team Order} | `/{project}/{env}/order-service/role-arn` (SSM) | `{infra}:specs/F-000-…/contracts/` | F-000 |

## Quy tắc

- Không tạo API hoặc event mới trùng chức năng với dòng đã có.
- Thay đổi không tương thích ngược phải tăng phiên bản và giữ bản cũ ít nhất {6 tháng}.
- Tên event: `{entity}.{động từ quá khứ}`.
