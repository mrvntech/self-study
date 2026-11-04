# Yêu cầu phi chức năng (NFR) dùng chung

Trạng thái: Approved · Cập nhật: 2026-10-01

| Mã | Nhóm | Yêu cầu | Đo bằng | Mục HLD đáp ứng | Tính năng hiện thực |
| --- | --- | --- | --- | --- | --- |
| NFR-001 | Availability | Đặt hàng, thanh toán đạt 99.9%/30 ngày | SLO dashboard | | |
| NFR-002 | Performance | p95 API ≤ 500 ms ở {cần xác nhận} req/s (cao điểm Tết) | Load test | | |
| NFR-003 | Security | Khách xác thực OIDC; nhân viên qua SSO công ty, MFA | Security review | | |
| NFR-004 | Security | Mã hóa dữ liệu cá nhân khi lưu và khi truyền | Security review | | |
| NFR-005 | Observability | Mọi service có health check, log JSON có trace_id, metrics RED | Checklist review | | |
| NFR-006 | Recovery | RPO ≤ 5 phút, RTO ≤ 1 giờ cho dữ liệu đơn hàng | Diễn tập DR | | |
| NFR-007 | Compliance | Tuân thủ NĐ 13/2023; dữ liệu lưu tại Việt Nam | Rà soát pháp lý | | |
| NFR-008 | Accessibility | Giao diện khách đạt WCAG 2.1 AA | Kiểm tra tự động và thủ công | | |
