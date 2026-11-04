# Câu hỏi mở

| Mã | Câu hỏi | Phát sinh ở | Người trả lời | Hạn | Chặn MVP? | Trạng thái | Câu trả lời / quyết định |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Q-01 | Lưu lượng cao điểm Tết dự kiến bao nhiêu req/s? | B5 | PO, Marketing | 2026-10-20 | Có | Open | |
| Q-02 | Ngân sách hạ tầng mỗi tháng? | B5 | Sponsor | 2026-10-20 | Không | Open | |
| Q-03 | Team nào sở hữu notification-service (điểm nóng H2)? | B8 | Engineering Manager | {cần xác nhận} | Có | Open | |
| Q-04 | ERP có API giữ / hủy giữ tồn kho không (H1)? ERP có phát sự kiện xuất kho (webhook, file, queue) hay ShopNow phải poll? | B8 | Phòng IT, Architect | {cần xác nhận} | Có | Open | |
| Q-05 | Data center chạy cụm K8s đặt ở đâu (xác nhận tại Việt Nam)? Có site thứ hai cho DR để đạt RPO 5 phút / RTO 1 giờ không? | B8 | Phòng IT, Platform | {cần xác nhận} | Có | Open | |
| Q-06 | Email/SMS gateway xử lý và lưu dữ liệu ở đâu? Đã có hợp đồng xử lý dữ liệu cá nhân theo NĐ 13/2023 chưa? | B8 | Marketing, Pháp chế | {cần xác nhận} | Có | Open | |
| Q-07 | Ngân hàng đối tác cổng thanh toán là ai; hỗ trợ redirect, tokenization hay cả hai; có callback/webhook không? | B8 | Sponsor, Phòng ATTT | {cần xác nhận} | Có | Open | |
| Q-08 | Trước khi tuyển SRE (Q1/2027), ai trực on-call 24/7 cho đặt hàng, thanh toán và ai làm việc DBA (backup, replication)? | B8 | Engineering Manager | {cần xác nhận} | Có | Open | |
| Q-09 | Identity và Catalog có thuộc SLO 99.9% không (NFR-001 chỉ nêu đặt hàng, thanh toán)? Mục tiêu cho Tier 2? | B8 | PO, Architect | {cần xác nhận} | Không | Open | |
| Q-10 | Team nào sở hữu chuyển đổi dữ liệu F-006 và màn hình CSKH (cskh-web)? | B8 | Engineering Manager | {cần xác nhận} | Có | Open | |
| Q-11 | Đăng nhập bằng số điện thoại (REQ-01) dùng mật khẩu hay OTP SMS? | B8 | PO, Phòng ATTT | {cần xác nhận} | Có | Open | |
| Q-12 | Quy tắc khử trùng ~5% bản ghi khách hàng khi chuyển đổi? | B8 | PO | {cần xác nhận} | Có | Open | |
| Q-13 | Thời hạn lưu dữ liệu cá nhân (khách, đơn, thông báo) theo NĐ 13/2023? | B8 | Pháp chế | {cần xác nhận} | Không | Open | |
| Q-14 | Thời gian tối thiểu giữ phiên bản API/event cũ khi thay đổi không tương thích ngược? | B8 | Architect | {cần xác nhận} | Không | Open | |
| Q-15 | ERP integration (ACL) là thành phần riêng hay nằm trong từng service (ADR-0008)? Nếu tách riêng, team nào sở hữu (HLD giả định Team Alpha, vốn đã có sales-service Tier 1)? | B9 (teammap) | Architect, Engineering Manager | Trước `/project.breakdown` | Có | Open | |
| Q-16 | API gateway / BFF (ADR-0010): nếu là BFF có code ứng dụng thì team nào viết? Platform (giả định) theo I8 chỉ có kỹ năng K8s, Terraform, Ansible, GitLab CI | B9 (teammap) | Architect, Engineering Manager | Trước `/project.breakdown` | Có | Open | |
| Q-17 | CDN / cache tĩnh cho customer-web: HLD mục 8 ghi hai team thực hiện (Platform, Team Gamma). Team nào thực hiện, team nào duyệt? | B9 (teammap) | Architect | {cần xác nhận} | Không | Open | |
| Q-18 | Nhất quán Order – Payment (outbox/saga, ADR-0004): HLD mục 7 ghi Team Alpha và Team Beta cùng thực hiện. Ai sở hữu phần dùng chung (thư viện outbox, schema event, điều phối saga), mỗi team làm phần nào? | B9 (teammap) | Architect | Trước `/project.breakdown` | Có | Open | |
| Q-19 | Phòng ATTT có 1 người, 30%, nhưng thực hiện 3 hạng mục và duyệt 10 hạng mục (gồm pentest trước MVP). Có thuê pentest bên ngoài hay tăng phân bổ không? | B9 (teammap) | Engineering Manager, Phòng ATTT | {cần xác nhận} | Có | Open | |
| Q-20 | Load test NFR-002 giao QA (giả định), nhưng I8 chỉ ghi kỹ năng test thủ công và Playwright. Ai làm load test, dùng công cụ gì? | B9 (teammap) | Engineering Manager | {cần xác nhận} | Có | Open | |
| Q-21 | Đào tạo đội vận hành và bàn giao runbook (release-plan giao SRE): khi chưa có SRE thì team nào làm? | B9 (teammap) | Engineering Manager | {cần xác nhận} | Không | Open | |
| Q-22 | Tên Solution Architect, PO, Delivery/PM, Engineering Manager, đầu mối Phòng IT và kênh liên lạc của từng team? | B9 (teammap) | Engineering Manager, PM | {cần xác nhận} | Không | Open | |
| Q-23 | Platform (2 DevOps) gánh cả việc Infra, SRE (SLO, alert, diễn tập DR) và DBA (backup, replication, cụm DB) theo giả định của HLD, tổng 16 hạng mục xuyên suốt (17 nếu nhận thêm CDN). Có chấp nhận tải này trước mốc 2027-01-25 không, hay cần bổ sung người? | B9 (teammap) | Engineering Manager | Trước `/project.breakdown` | Có | Open | |
