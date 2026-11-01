# PRD – ShopNow

Trạng thái: Approved · Người sở hữu: PO (An) · Cập nhật: 2026-10-01

## 1. Vấn đề và tầm nhìn

- **Vấn đề:** Khách mua đồ gia dụng online bỏ giỏ vì website chậm, thanh toán rườm rà; CSKH phải tra đơn thủ công trên nhiều hệ thống.
- **Tầm nhìn:** Mua đồ gia dụng online nhanh như ở cửa hàng.

## 2. Mục tiêu và chỉ số đo

| Mục tiêu | Chỉ số | Hiện tại | Mục tiêu | Hạn |
| --- | --- | --- | --- | --- |
| Tăng chuyển đổi | Tỷ lệ đơn / phiên | 1,2% | 2,5% | 2027-07-31 |
| Giảm thời gian xử lý đơn | Phút / đơn (CSKH) | 15 | 5 | 2027-07-31 |

## 3. Persona

| Persona | Mô tả | Nhu cầu chính |
| --- | --- | --- |
| Khách hàng | Mua online, chủ yếu trên điện thoại | Tìm nhanh, thanh toán nhanh, biết đơn đang ở đâu |
| Nhân viên CSKH | Xử lý đơn, trả lời khách | Xem và cập nhật đơn ở một chỗ |

## 4. Phạm vi

- **Trong phạm vi (MVP):** đăng ký/đăng nhập khách, danh mục và tìm kiếm, giỏ hàng, đặt hàng, thanh toán thẻ, theo dõi đơn, thông báo email/SMS, màn hình CSKH.
- **Ngoài phạm vi:** app native, ví điện tử, mã giảm giá (v1.1).

## 5. Yêu cầu cấp sản phẩm

| Mã | Yêu cầu | Persona | Ưu tiên | Tính năng đáp ứng |
| --- | --- | --- | --- | --- |
| REQ-01 | Khách đăng ký, đăng nhập bằng email hoặc số điện thoại | Khách hàng | Must | F-001 |
| REQ-02 | Khách xem danh mục, tìm sản phẩm theo tên; giá và tồn kho lấy từ ERP | Khách hàng | Must | F-002 |
| REQ-03 | Khách thêm vào giỏ, đặt hàng | Khách hàng | Must | F-003 |
| REQ-04 | Khách thanh toán bằng thẻ | Khách hàng | Must | F-003 |
| REQ-05 | Khách xem trạng thái đơn | Khách hàng | Must | F-004 |
| REQ-06 | Khách nhận email/SMS khi đơn đổi trạng thái | Khách hàng | Should | F-004 |
| REQ-07 | CSKH đăng nhập SSO, tìm và cập nhật trạng thái đơn | Nhân viên CSKH | Must | F-005 |
| REQ-08 | Chuyển dữ liệu khách hàng và đơn 24 tháng từ website cũ | — | Must | F-006 |
