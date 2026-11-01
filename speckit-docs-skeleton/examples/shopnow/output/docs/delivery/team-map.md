# Team map

Trạng thái: Draft (AI) · Soạn ở đầu B9 · Cập nhật: 2026-11-02 · Nguồn: HLD mục 3, 6–10 (Draft), I8 `resources.md` (Approved), `release-plan.md`

> Tầng điều phối. Ai sở hữu thành phần nào và đang làm tính năng nào. Nhãn `[Team: …]` trong `tasks.md`, cột Team trong `feature-map.md` và bảng "Team thực hiện" trong HLD phải dùng đúng tên team ở đây. Lệnh `/project.breakdown` đọc file này để chia việc.
>
> **Ghi chú bản nháp:** tên team lấy đúng theo I8: Team Alpha, Team Beta, Team Gamma, Platform, Phòng ATTT, QA. I8 **không có** team Infra, SRE, DBA hay Security riêng. Việc Infra/SRE/DBA tạm giao Platform, việc Security giao Phòng ATTT; dòng nào chỉ dựa trên giả định thì ghi "(giả định)". Mọi chỗ ghi `(giả định)` hoặc `{…}` cần Engineering Manager hoặc Architect xác nhận.

## Danh sách team

| Team | Tech Lead | Thành phần sở hữu | Tính năng đang làm | Kênh liên lạc |
| --- | --- | --- | --- | --- |
| Team Alpha (4 dev; Java Spring, PostgreSQL, Kafka) | Minh | `sales-service` (Cart, Order, API CSKH, giữ tồn kho ERP – Tier 1); `catalog-service` (Product, tìm kiếm, đồng bộ giá/tồn kho ERP – Tier 2, giả định); `ERP integration (ACL)` nếu tách riêng theo ADR-0008 (Tier 1, giả định – Q-15); `data-migration` phần Order (giả định – Q-10) | — | {cần xác nhận} |
| Team Beta (3 dev; Node.js, PostgreSQL) | Lan | `identity-service` (User, Customer, OIDC khách – Tier 1, giả định); `payment-service` (Payment, cổng thanh toán, callback – Tier 1); `data-migration` phần Customer, khử trùng ~5% (giả định – Q-10) | — | {cần xác nhận} |
| Team Gamma (3 dev; React, Next.js; chỉ làm frontend) | Tuấn | `customer-web` (web/mobile web, WCAG 2.1 AA – Tier 1); `cskh-web` (màn hình CSKH, SSO Keycloak – Tier 2, giả định – Q-10) | — | {cần xác nhận} |
| Platform (2 DevOps; Kubernetes, Terraform, Ansible, GitLab CI) | Hùng | L0 nền móng (namespace, state backend Terraform); L1 mạng, DNS, ingress, TLS; L2 hiện thực network policy, quản lý secret/khóa (ADR-0014); L3 cụm K8s nội bộ dev/staging/prod, autoscaling, cụm DB dùng chung và migration tooling (giả định thay DBA); L4 hardening OS/node K8s; L5 stack observability (ADR-0012); L6 golden path Helm chart cho Java và Node.js (ADR-0011); CI/CD GitLab và registry (ADR-0016); `API gateway / BFF` (Tier 1, giả định – Q-16); backup/replication DB, kiến trúc DR (ADR-0013); SLO, alert, dashboard, runbook, diễn tập DR (giả định thay SRE – Q-08) | — | {cần xác nhận} |
| Phòng ATTT (1 người, 30%, dùng chung toàn công ty) | Hà (người phụ trách, không phải Tech Lead) | Không sở hữu thành phần. Sở hữu việc: chính sách bảo mật, threat model, quét lỗ hổng, pentest; WAF rule, SIEM (giả định); đánh giá tuân thủ NĐ 13/2023 (giả định) | — | {cần xác nhận} |
| QA (2 tester; test thủ công, Playwright) | Mai | Không sở hữu thành phần. Sở hữu: bộ test E2E Playwright dùng chung, môi trường và dữ liệu test dùng chung, UAT; load test NFR-002 (giả định – I8 chưa ghi kỹ năng load test, Q-20) | — | {cần xác nhận} |

**Thành phần chưa có team sở hữu (chặn chia việc):**

| Thành phần | Tier | Tình trạng | Câu hỏi |
| --- | --- | --- | --- |
| `notification-service` | Tier 3 | Chưa có team (H2). HLD mục 9 ghi "team Notification", nhưng I8 không có team này | Q-03 |
| `ERP integration (ACL)` | Tier 1 (phần giữ tồn kho) | Team sở hữu tùy ADR-0008: tách riêng thì Team Alpha (giả định), nằm trong từng service thì thuộc team của service đó | Q-15 |
| `data-migration` | Tier 3 | Hai team cùng sở hữu (Beta: Customer, Alpha: Order), trái nguyên tắc P1 | Q-10 |

## Ranh giới trách nhiệm việc xuyên suốt

Gộp từ các bảng "Team thực hiện" ở HLD mục 6–10 và `release-plan.md`. Mỗi việc một team thực hiện. Khi HLD ghi hai team cho một việc, dòng đó được tách theo phần việc chính HLD đã ghi trong ngoặc, hoặc được đánh dấu **⚠ xung đột** để người có thẩm quyền quyết.

| # | Việc | Team thực hiện | Team duyệt / phối hợp | Nguồn |
| --- | --- | --- | --- | --- |
| X-01 | Chính sách bảo mật, threat model, quét lỗ hổng, pentest | Phòng ATTT | Architect | HLD 6 |
| X-02 | WAF rule, SIEM | Phòng ATTT (giả định) | Platform | HLD 6 |
| X-03 | Hiện thực network policy, TLS/cert, quản lý secret và khóa mã hóa (ADR-0014) | Platform | Phòng ATTT | HLD 6 |
| X-04 | Hardening OS / node K8s | Platform | Phòng ATTT | HLD 6 |
| X-05 | AuthN/AuthZ khách hàng OIDC (ADR-0005) | Team Beta | Phòng ATTT | HLD 6 |
| X-06a | SSO + MFA nhân viên: đăng nhập Keycloak trên `cskh-web` | Team Gamma | Phòng ATTT; Phòng IT cấp client Keycloak | HLD 6 |
| X-06b | SSO + MFA nhân viên: phân quyền API Sales | Team Alpha | Phòng ATTT | HLD 6 |
| X-07 | Mã hóa dữ liệu cá nhân khi lưu, trong từng service | Team sở hữu service (Alpha, Beta; `notification-service`: chưa có team) | Phòng ATTT | HLD 6 |
| X-08 | Tích hợp cổng thanh toán không lưu số thẻ | Team Beta | Phòng ATTT | HLD 6 |
| X-09 | Đánh giá tuân thủ NĐ 13/2023, data residency | Phòng ATTT (giả định) | Pháp chế | HLD 6 |
| X-10 | Kiến trúc DR, site dự phòng (ADR-0013) | Platform | Architect | HLD 7 |
| X-11 | Backup và replication DB (RPO ≤ 5 phút) | Platform (giả định – chưa có DBA) | Architect | HLD 7 |
| X-12a | HA ứng dụng: replica, probe, PodDisruptionBudget trong golden path | Platform | Architect | HLD 7 |
| X-12b | HA ứng dụng: cấu hình HA cho từng service | Team sở hữu service | Architect | HLD 7 |
| X-13 | Nhất quán Order – Payment (idempotency, retry, outbox/saga, ADR-0004) | **⚠ xung đột:** HLD ghi "Team Alpha, Team Beta" | Architect | HLD 7 |
| X-14 | Diễn tập DR | Platform (giả định – chưa có SRE) | Architect; phối hợp Team Alpha, Team Beta | HLD 7 |
| X-15 | On-call 24/7 cho Tier 1 | **{cần xác nhận – Q-08}** | Engineering Manager | HLD 7 |
| X-16 | Autoscaling, dung lượng cụm K8s | Platform | Architect | HLD 8 |
| X-17 | CDN / cache tĩnh cho `customer-web` | **⚠ xung đột:** HLD ghi "Platform (giả định), Team Gamma" | Architect | HLD 8 |
| X-18 | Cache dữ liệu ERP, tìm kiếm (ADR-0008, ADR-0009) | Team Alpha | Architect | HLD 8 |
| X-19 | Load test theo NFR-002 | QA (giả định – thiếu kỹ năng theo I8) | Platform, Architect | HLD 8 |
| X-20 | Dựng stack observability (ADR-0012) | Platform | Architect | HLD 9 |
| X-21 | SLO, alert, dashboard, runbook | Platform (giả định – chưa có SRE) | Team sở hữu service | HLD 9 |
| X-22 | Instrument code: health check, log JSON có trace_id, metrics RED | Mỗi team dev (Team Alpha, Team Beta, Team Gamma; `notification-service`: chưa có team) | Platform | HLD 9 |
| X-23 | SLO dashboard cho đặt hàng, thanh toán | Platform (giả định) | Team Alpha, Team Beta | HLD 9 |
| X-24 | Namespace, môi trường dev / staging / prod | Platform | Architect | HLD 10 |
| X-25 | Mạng, DNS, ingress, TLS | Platform | Phòng ATTT | HLD 10 |
| X-26 | CI/CD pipeline, registry (ADR-0016) | Platform | Phòng ATTT | HLD 10 |
| X-27 | Golden path Helm chart cho Java và Node.js (ADR-0011) | Platform | Phòng ATTT; Team Alpha, Team Beta | HLD 10 |
| X-28 | Cụm DB dùng chung, migration tooling (ADR-0003) | Platform (giả định – chưa có DBA) | Architect | HLD 10 |
| X-29 | Môi trường và dữ liệu test dùng chung | QA | Platform | HLD 10 |
| X-30 | Change ticket go-live | Platform | Architect | HLD 10, release-plan |
| X-31 | Test E2E, UAT | QA | PO | release-plan, mẫu team-map |
| X-32 | Đào tạo đội vận hành, bàn giao runbook | **{cần xác nhận – Q-21}**: release-plan giao SRE, nhưng I8 chưa có SRE | Đội vận hành (I2) | release-plan |

## Vai trò dùng chung

I8 và I2 không ghi tên người cho các vai trò dưới đây. Bản nháp này không tự điền tên (Q-22).

| Vai trò | Người | Trách nhiệm |
| --- | --- | --- |
| Solution Architect | {cần xác nhận} | Giữ HLD, duyệt ADR, review plan có "Ảnh hưởng kiến trúc"; duyệt các việc X-* có cột duyệt là Architect |
| Product Owner | {cần xác nhận} | Giữ PRD, feature map, ưu tiên; duyệt UAT |
| Delivery / Project Manager | {cần xác nhận} | Giữ release plan, dependencies, điều phối giữa các team |
| Engineering Manager | {cần xác nhận tên} (người cung cấp I8) | Quyết team sở hữu (Q-03, Q-10, Q-15), on-call (Q-08), tuyển SRE Q1/2027 |
| Đầu mối Phòng ATTT | Hà (I8, 30%) | Thực hiện X-01, X-02, X-09; duyệt X-03…X-08, X-25…X-27 |
| Đầu mối Phòng IT (Keycloak, ERP) | {cần xác nhận} | Cấp client Keycloak; trả lời Q-04 về API ERP |
| Pháp chế | {cần xác nhận} (I2) | Duyệt X-09; trả lời Q-06, Q-13 |

## RACI theo loại việc

Cột Infra và SRE của mẫu gộp vào **Platform** (I8 không có SRE); cột Security đổi thành **Phòng ATTT**. Ô có ⚠ là chỗ HLD khác mẫu, Architect cần chọn.

| Việc | Team sở hữu tính năng | Platform | Phòng ATTT | QA | Architect | PO |
| --- | --- | --- | --- | --- | --- | --- |
| Spec tính năng | R | I | C | C | C | A |
| Plan tính năng | R/A | C | C | I | C | I |
| Contract API/event giữa team | R | I | C | I | A | I |
| Môi trường, CI/CD, golden path | C | R/A | C | I | I | I |
| SLO, alert, runbook | ⚠ C/A (HLD 9: team service duyệt) – mẫu: R | ⚠ R (HLD 9) – mẫu: A (SRE) | I | I | I | C |
| Backup DB, DR, diễn tập DR | C | R | I | I | A | I |
| Security review, pentest | C | C | R | I | A | I |
| Load test NFR-002 | C | C | I | R (giả định) | A | I |
| Test end-to-end, UAT | C | I | I | R | I | A |
