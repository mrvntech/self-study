# Yêu cầu phi chức năng (NFR) dùng chung

> Tầng 1 – Sản phẩm. Mỗi spec ghi rõ các NFR áp dụng trong mục "Liên kết tổng thể". Mỗi NFR phải được đáp ứng ở ít nhất một mục của `docs/architecture/hld.md`. Số liệu dưới đây là ví dụ.

| Mã | Nhóm | Yêu cầu | Đo bằng | Mục HLD đáp ứng | Tính năng hiện thực |
| --- | --- | --- | --- | --- | --- |
| NFR-001 | Availability | {Chức năng Tier 1 đạt 99.9%/30 ngày} | {SLO dashboard} | {8.1, 10.2} | F-000 |
| NFR-002 | Performance | {p95 API ≤ 500 ms ở 300 req/s} | {Load test} | {9.2} | |
| NFR-003 | Security | {Xác thực OIDC, MFA cho admin} | {Security review} | {7.2} | F-000 |
| NFR-004 | Security | {Mã hóa dữ liệu cá nhân khi lưu} | {Security review} | {7.3} | |
| NFR-005 | Observability | {Mọi service có health check, log JSON có trace_id, metrics RED} | {Checklist review} | {10} | F-000 |
| NFR-006 | Recovery | {RPO ≤ 5 phút, RTO ≤ 1 giờ} | {Diễn tập DR} | {8.4} | |
| NFR-007 | Compliance | {Tuân thủ NĐ 13/2023 về dữ liệu cá nhân} | {Rà soát pháp lý} | {12} | |
| NFR-008 | Accessibility | {Giao diện đạt WCAG 2.1 AA} | {Kiểm tra tự động và thủ công} | — | |
