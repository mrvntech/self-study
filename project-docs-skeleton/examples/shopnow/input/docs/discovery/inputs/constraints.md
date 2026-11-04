# I5 – Ràng buộc

Trạng thái: Approved · Người cung cấp: Sponsor, Pháp chế, Phòng ATTT, IT · Ngày: 2026-09-05

| Loại | Ràng buộc | Nguồn | Bắt buộc / Mong muốn | Ảnh hưởng tới |
| --- | --- | --- | --- | --- |
| Pháp lý | Dữ liệu cá nhân xử lý theo NĐ 13/2023 | Pháp chế | Bắt buộc | NFR, HLD security |
| Pháp lý | Dữ liệu khách hàng lưu tại Việt Nam | Pháp chế | Bắt buộc | HLD infra |
| Compliance | Không lưu số thẻ; thanh toán thẻ qua cổng thanh toán của ngân hàng đối tác (redirect/tokenization) | Phòng ATTT | Bắt buộc | HLD security, tích hợp |
| Công nghệ | Chạy trên cụm Kubernetes nội bộ tại data center của công ty | Chuẩn kiến trúc công ty | Bắt buộc | HLD infra |
| Công nghệ | Nhân viên đăng nhập qua SSO công ty (Keycloak, OIDC) | Phòng ATTT | Bắt buộc | HLD security |
| Công nghệ | Tích hợp ERP hiện có qua API, không đọc DB trực tiếp | IT | Bắt buộc | HLD tích hợp |
| Ngân sách | {cần xác nhận} | — | — | HLD chi phí |
| Thời gian | Ra mắt MVP trước 2027-01-25 | Business brief | Bắt buộc | Release plan |
| Vận hành | Hỗ trợ 24/7 cho đặt hàng và thanh toán | Sponsor | Mong muốn | NFR, on-call |
