<!-- Chỉ dùng cho repo Infra. Chèn sau mục "Liên kết tổng thể" (từ common) trong .specify/templates/spec-template.md. -->

## Bên dùng hạ tầng *(bắt buộc)*

User story của tính năng hạ tầng viết từ góc nhìn **team dùng** hạ tầng, không phải người dùng cuối. Ví dụ: *"Là Team Order, tôi cần một PostgreSQL Multi-AZ, RPO 5 phút, chỉ truy cập được từ namespace `order`, để lưu đơn hàng."*

| Team dùng | Cần gì | Tên trong api-catalog (mục Tài nguyên hạ tầng) | Cần trước mốc |
| --- | --- | --- | --- |
| {Team Order} | {DB PostgreSQL cho order-service} | `{rds-order-db}` | {M1} |

## Môi trường trong phạm vi *(bắt buộc)*

| Môi trường | Account | Có trong tính năng này | Ghi chú |
| --- | --- | --- | --- |
| dev | {…} | {Có / Không} | |
| staging | {…} | {…} | |
| prod | {…} | {…} | {khung giờ thay đổi} |

## Acceptance criteria đo được

Mỗi AC kiểm được bằng công cụ hoặc thao tác cụ thể, không viết "hệ thống ổn định". Ví dụ:

- **AC-01** `checkov` và `tflint` không còn lỗi mức High trở lên.
- **AC-02** Failover sang AZ khác trong ≤ {2 phút} khi diễn tập ở staging.
- **AC-03** Restore từ backup ra instance mới, dữ liệu mất ≤ RPO {5 phút} (NFR-xxx).
- **AC-04** `Team Order` đọc được endpoint và secret qua `/{project}/{env}/order-db/` bằng IAM role của service, không cần thông tin đăng nhập nào khác.
- **AC-05** Chi phí ước tính cho prod ≤ {…} USD/tháng.
