# I4 – Hệ thống hiện có

Trạng thái: Approved · Người cung cấp: IT · Ngày: 2026-09-05

| Hệ thống | Mục đích | Công nghệ | Chủ sở hữu | Dữ liệu chính | Người dùng / lưu lượng | Điểm yếu | Hướng xử lý dự kiến |
| --- | --- | --- | --- | --- | --- | --- | --- |
| ERP | Kế toán, kho, giá | SAP | Phòng IT | Sản phẩm, tồn kho, giá | 200 user nội bộ | API chậm (p95 ~2 s) | Giữ, tích hợp |
| Website cũ | Bán hàng | PHP, MySQL | Agency | Đơn hàng, khách hàng | 5.000 lượt/ngày, cao điểm Tết 40.000 | Không mở rộng được | Thay thế |
| Keycloak công ty | SSO nhân viên | Keycloak | Phòng IT | Tài khoản nhân viên | 1.500 nhân viên | — | Dùng lại |
| Email/SMS gateway | Gửi thông báo | Dịch vụ bên ngoài | Marketing | — | — | — | Dùng lại |

## Dữ liệu cần chuyển đổi

| Dữ liệu | Khối lượng | Chất lượng | Bắt buộc chuyển? |
| --- | --- | --- | --- |
| Khách hàng | 300.000 bản ghi | Trùng lặp ~5% | Có |
| Đơn hàng cũ | 1,2 triệu | Tốt | Chỉ 24 tháng gần nhất |
