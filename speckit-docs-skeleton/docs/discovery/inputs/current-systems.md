# I4 – Hệ thống hiện có

| Thông tin | Giá trị |
| --- | --- |
| Người cung cấp | {IT / Architect} |
| Ngày | {YYYY-MM-DD} |

## Danh sách hệ thống

| Hệ thống | Mục đích | Công nghệ | Chủ sở hữu | Dữ liệu chính | Người dùng / lưu lượng | Điểm yếu | Hướng xử lý dự kiến |
| --- | --- | --- | --- | --- | --- | --- | --- |
| {ERP} | {Kế toán, kho} | {SAP} | {Phòng IT} | {Sản phẩm, tồn kho} | {200 user nội bộ} | {API chậm} | Giữ, tích hợp |
| {Website cũ} | {Bán hàng} | {PHP} | {Agency} | {Đơn hàng} | {5.000 lượt/ngày} | {Không mở rộng được} | Thay thế |

## Tích hợp hiện có

| Từ | Đến | Cách tích hợp | Tần suất | Ghi chú |
| --- | --- | --- | --- | --- |
| {Website cũ} | {ERP} | {File CSV qua FTP} | {Mỗi đêm} | {Hay lỗi} |

## Dữ liệu cần chuyển đổi

| Dữ liệu | Khối lượng | Chất lượng | Bắt buộc chuyển? |
| --- | --- | --- | --- |
| {Khách hàng} | {300.000 bản ghi} | {Trùng lặp ~5%} | {Có} |
