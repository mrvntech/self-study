# Team map

Trạng thái: Approved (giả lập cho ví dụ) · Cập nhật: 2026-11-02 · Nguồn: HLD mục 3, 6–10 (Approved – giả lập cho ví dụ), I8 `resources.md` (Approved), `release-plan.md`, quyết định trong `open-questions.md`

> Tầng điều phối. Ai sở hữu thành phần nào và đang làm tính năng nào. Nhãn `[Team: …]` trong `tasks.md`, cột Team trong `feature-map.md` và bảng "Team thực hiện" trong HLD phải dùng đúng tên team ở đây. Lệnh `/project.breakdown` đọc file này để chia việc.
>
> **Ghi chú:** tên team lấy đúng theo I8: Team Alpha, Team Beta, Team Gamma, Platform, Phòng ATTT, QA. I8 **không có** team Infra, SRE, DBA hay Security riêng. Việc Infra và DBA giao Platform; Hùng (Platform) giữ vai trò SRE tạm đến khi tuyển SRE (Q1/2027) (Q-08); việc Security giao Phòng ATTT. Dòng còn ghi `(giả định)` hoặc `{…}` là chỗ chưa có quyết định.

## Danh sách team

| Team | Tech Lead | Thành phần sở hữu | Tính năng đang làm | Kênh liên lạc |
| --- | --- | --- | --- | --- |
| Team Alpha (4 dev; Java Spring, PostgreSQL, Kafka) | Minh | `sales-service` (Cart, Order, API CSKH, adapter ERP giữ tồn kho và nhận xuất kho – Tier 1); `catalog-service` (Product, tìm kiếm, adapter ERP đồng bộ giá/tồn kho – Tier 2, giả định – Q-09); `data-migration` (Customer và Order – Q-10) | — | {cần xác nhận} |
| Team Beta (3 dev; Node.js, PostgreSQL) | Lan | `identity-service` (User, Customer, OIDC khách – Tier 1, giả định – Q-09); `payment-service` (Payment, cổng thanh toán, callback – Tier 1); `notification-service` (Notification, consumer event gửi email/SMS – Tier 3, Q-03) | — | {cần xác nhận} |
| Team Gamma (3 dev; React, Next.js; chỉ làm frontend) | Tuấn | `customer-web` (web/mobile web, WCAG 2.1 AA, cache header – Tier 1); `cskh-web` (màn hình CSKH, SSO Keycloak, dùng API của `sales-service` qua contract – Tier 2, Q-10) | — | {cần xác nhận} |
| Platform (2 DevOps + 1 DevOps hợp đồng từ 2026-12; Kubernetes, Terraform, Ansible, GitLab CI) | Hùng (kiêm SRE tạm) | L0 nền móng (namespace, state backend Terraform); L1 mạng, DNS, ingress, TLS; L2 hiện thực network policy, quản lý secret/khóa (ADR-0014); L3 cụm K8s nội bộ dev/staging/prod, autoscaling, cụm PostgreSQL dùng chung và migration tooling; L4 hardening OS/node K8s; L5 stack observability (ADR-0012); L6 golden path Helm chart cho Java và Node.js (ADR-0011); CI/CD GitLab và registry (ADR-0016); `API gateway` (cấu hình ingress, không có BFF – Tier 1, Q-16); vận hành Kafka (ADR-0004); CDN (Q-17); backup/replication DB, kiến trúc DR (ADR-0013); duyệt SLO, điều phối diễn tập DR, on-call hạ tầng (Q-08); đào tạo đội vận hành (Q-21) | — | {cần xác nhận} |
| Phòng ATTT (1 người, 30%, dùng chung toàn công ty) | Hà (người phụ trách, không phải Tech Lead) | Không sở hữu thành phần. Sở hữu việc: chính sách bảo mật, threat model, quét lỗ hổng; duyệt kết quả pentest bên ngoài (Q-19); WAF rule, SIEM (giả định); đánh giá tuân thủ NĐ 13/2023 (giả định) | — | {cần xác nhận} |
| QA (2 tester; test thủ công, Playwright; k6 sau đào tạo) | Mai | Không sở hữu thành phần. Sở hữu: bộ test E2E Playwright dùng chung, môi trường và dữ liệu test dùng chung, UAT; load test NFR-002 bằng k6 (Q-20) | — | {cần xác nhận} |

Mọi thành phần trong HLD mục 3 đều đã có đúng một team sở hữu. Không có thành phần ERP integration (ACL) riêng (ADR-0008).

## Danh sách repo

*(Bổ sung sau khi template có bảng này, giả lập cho ví dụ; chưa chạy lại `/project.teammap`.)* Mỗi team dev một repo chứa mọi thành phần của team. Platform giữ repo hạ tầng; Phòng ATTT đóng góp policy vào đó. Không có SRE, DBA riêng (Q-08): Hùng (Platform) duyệt observability và migration đến khi tuyển SRE. Phòng ATTT không có repo riêng.

| Repo | Team giữ | Thành phần (HLD mục 3) | Team đóng góp: đường dẫn | Team duyệt: đường dẫn | Profile |
| --- | --- | --- | --- | --- | --- |
| `project-docs` | Architect, PO, PM {cần xác nhận} | Tài liệu tổng thể | Phòng ATTT: `docs/security/`, threat model HLD 6; Platform (SRE tạm): SLO HLD 9 | Architect: `docs/architecture/`; PO: `docs/product/`; PM: `docs/delivery/` | — |
| `alpha` | Team Alpha | `sales-service`, `catalog-service`, `data-migration` | — | Platform: `migrations/`, `observability/` | `service` |
| `beta` | Team Beta | `identity-service`, `payment-service`, `notification-service` | — | Platform: `migrations/`, `observability/` | `service` |
| `gamma-web` | Team Gamma | `customer-web`, `cskh-web` | — | Platform: `observability/` | `service` (mục Frontend) |
| `platform` | Platform | L0–L6, CI/CD GitLab, registry, golden path chart, API gateway, Kafka, CDN, cụm PostgreSQL dùng chung | Phòng ATTT: `policies/` | Phòng ATTT: `policies/`; Platform (SRE tạm): `observability/` | `infra` + `observability` + `security-policy` |
| `qa-tests` | QA | Bộ E2E Playwright, kịch bản k6 | — | Platform: `load/` (ngưỡng, môi trường) | `test` |

Profile `infra` trong skeleton viết cho AWS; ShopNow chạy K8s nội bộ (Terraform, Ansible, GitLab CI), nên Platform phải thay các luật AWS (KMS, SSM, SCP, GuardDuty) bằng công cụ tương ứng theo ADR-0014, ADR-0016 trước khi dùng. Repo dùng GitLab nên `CODEOWNERS` đặt ở gốc hoặc `.gitlab/`, bật "Code Owner approval" cho nhánh chính.

## Ranh giới trách nhiệm việc xuyên suốt

Gộp từ các bảng "Team thực hiện" ở HLD mục 6–10 và `release-plan.md`. Mỗi việc một team thực hiện; các xung đột trước đây đã được giải quyết theo `open-questions.md`.

| # | Việc | Team thực hiện | Team duyệt / phối hợp | Nguồn |
| --- | --- | --- | --- | --- |
| X-01 | Chính sách bảo mật, threat model, quét lỗ hổng | Phòng ATTT | Architect | HLD 6 |
| X-01b | Pentest trước MVP | Đơn vị pentest bên ngoài (thuê) | Phòng ATTT (duyệt kết quả) | HLD 6, Q-19 |
| X-02 | WAF rule, SIEM | Phòng ATTT (giả định) | Platform | HLD 6 |
| X-03 | Hiện thực network policy, TLS/cert, quản lý secret và khóa mã hóa (ADR-0014) | Platform | Phòng ATTT | HLD 6 |
| X-04 | Hardening OS / node K8s | Platform | Phòng ATTT | HLD 6 |
| X-05 | AuthN/AuthZ khách hàng OIDC (ADR-0005) | Team Beta | Phòng ATTT | HLD 6 |
| X-06a | SSO + MFA nhân viên: đăng nhập Keycloak trên `cskh-web` | Team Gamma | Phòng ATTT; Phòng IT cấp client Keycloak | HLD 6 |
| X-06b | SSO + MFA nhân viên: phân quyền API Sales | Team Alpha | Phòng ATTT | HLD 6 |
| X-07 | Mã hóa dữ liệu cá nhân khi lưu, trong từng service | Team sở hữu service (Alpha, Beta) | Phòng ATTT | HLD 6 |
| X-08 | Tích hợp cổng thanh toán không lưu số thẻ | Team Beta | Phòng ATTT | HLD 6 |
| X-09 | Đánh giá tuân thủ NĐ 13/2023, data residency | Phòng ATTT (giả định) | Pháp chế | HLD 6 |
| X-10 | Kiến trúc DR, site dự phòng (ADR-0013) | Platform | Architect | HLD 7 |
| X-11 | Backup và replication DB (RPO ≤ 5 phút) | Platform | Architect | HLD 7, Q-08 |
| X-12a | HA ứng dụng: replica, probe, PodDisruptionBudget trong golden path | Platform | Architect | HLD 7 |
| X-12b | HA ứng dụng: cấu hình HA cho từng service | Team sở hữu service | Architect | HLD 7 |
| X-13a | Nhất quán Order – Payment: outbox, idempotency, retry trong `sales-service` (ADR-0004, choreography) | Team Alpha | Architect | HLD 7, Q-18 |
| X-13b | Nhất quán Order – Payment: outbox, idempotency, retry trong `payment-service` (ADR-0004, choreography) | Team Beta | Architect | HLD 7, Q-18 |
| X-13c | Schema event | Team producer của event | Architect (giữ quy ước schema) | HLD 7, Q-18 |
| X-14 | Diễn tập DR | Platform (Hùng – SRE tạm, điều phối) | Architect; phối hợp Team Alpha, Team Beta | HLD 7, Q-08 |
| X-15a | On-call 24/7 Tier 1 – ứng dụng | Team Alpha, Team Beta (luân phiên) | Engineering Manager | HLD 7, Q-08 |
| X-15b | On-call 24/7 Tier 1 – hạ tầng | Platform | Engineering Manager | HLD 7, Q-08 |
| X-16 | Autoscaling, dung lượng cụm K8s | Platform | Architect | HLD 8 |
| X-17a | CDN / cache tĩnh cho `customer-web` | Platform | Architect | HLD 8, Q-17 |
| X-17b | Cache header của `customer-web` | Team Gamma | Architect | HLD 8, Q-17 |
| X-18 | Cache dữ liệu ERP, tìm kiếm (ADR-0008, ADR-0009) | Team Alpha | Architect | HLD 8 |
| X-19 | Load test theo NFR-002 (k6, có đào tạo) | QA | Platform (cấp môi trường), Architect | HLD 8, Q-20 |
| X-20 | Dựng stack observability (ADR-0012) | Platform | Architect | HLD 9 |
| X-21 | SLO, alert, runbook cho từng service | Team sở hữu service | Platform (Hùng – SRE tạm, duyệt SLO) | HLD 9, Q-08 |
| X-22 | Instrument code: health check, log JSON có trace_id, metrics RED | Mỗi team dev (Team Alpha, Team Beta, Team Gamma) | Platform | HLD 9 |
| X-23 | Dashboard, SLO dashboard cho đặt hàng, thanh toán | Platform (giả định) | Team Alpha, Team Beta | HLD 9 |
| X-24 | Namespace, môi trường dev / staging / prod | Platform | Architect | HLD 10 |
| X-25 | Mạng, DNS, ingress (gồm cấu hình API gateway), TLS | Platform | Phòng ATTT | HLD 10, Q-16 |
| X-26 | CI/CD pipeline, registry (ADR-0016) | Platform | Phòng ATTT | HLD 10 |
| X-27 | Golden path Helm chart cho Java và Node.js (ADR-0011) | Platform | Phòng ATTT; Team Alpha, Team Beta | HLD 10 |
| X-28a | Cụm PostgreSQL dùng chung, migration tooling (ADR-0003) | Platform | Architect | HLD 10, Q-08 |
| X-28b | Schema và migration của từng service | Team sở hữu service | Architect | HLD 10, Q-08 |
| X-29 | Môi trường và dữ liệu test dùng chung | QA | Platform | HLD 10 |
| X-30 | Change ticket go-live | Platform | Architect | HLD 10, release-plan |
| X-31 | Test E2E, UAT | QA | PO | release-plan, mẫu team-map |
| X-32 | Đào tạo đội vận hành, bàn giao runbook | Platform | Đội vận hành (I2) | release-plan, Q-21 |
| X-33 | Vận hành Kafka (ADR-0004) | Platform | Architect | HLD 10, Q-18 |

## Vai trò dùng chung

I8 và I2 không ghi tên người cho phần lớn các vai trò dưới đây; tên còn chờ Q-22.

| Vai trò | Người | Trách nhiệm |
| --- | --- | --- |
| Solution Architect | {cần xác nhận} | Giữ HLD, duyệt ADR, review plan có "Ảnh hưởng kiến trúc"; giữ quy ước schema event; duyệt các việc X-* có cột duyệt là Architect |
| Product Owner | {cần xác nhận} | Giữ PRD, feature map, ưu tiên; duyệt UAT |
| Delivery / Project Manager | {cần xác nhận} | Giữ release plan, dependencies, điều phối giữa các team |
| Engineering Manager | {cần xác nhận tên} (người cung cấp I8) | Đã quyết team sở hữu và phân việc (Q-03, Q-08, Q-10, Q-15, Q-16, Q-19–Q-21, Q-23); duyệt on-call (X-15a, X-15b); tuyển SRE Q1/2027 |
| SRE tạm | Hùng (Platform) | Duyệt SLO của các team service, điều phối diễn tập DR (X-14, X-21) đến khi tuyển SRE (Q1/2027) |
| Đầu mối Phòng ATTT | Hà (I8, 30%) | Thực hiện X-01, X-02, X-09; duyệt kết quả pentest bên ngoài (X-01b); duyệt X-03…X-08, X-25…X-27 |
| Đầu mối Phòng IT (Keycloak, ERP) | {cần xác nhận} | Cấp client Keycloak; trả lời Q-04 về API ERP |
| Pháp chế | {cần xác nhận} (I2) | Duyệt X-09; trả lời Q-06, Q-13 |

## RACI theo loại việc

Cột Infra và SRE của mẫu gộp vào **Platform** (I8 không có SRE; Hùng là SRE tạm); cột Security đổi thành **Phòng ATTT**.

| Việc | Team sở hữu tính năng | Platform | Phòng ATTT | QA | Architect | PO |
| --- | --- | --- | --- | --- | --- | --- |
| Spec tính năng | R | I | C | C | C | A |
| Plan tính năng | R/A | C | C | I | C | I |
| Contract API/event giữa team | R | I | C | I | A | I |
| Môi trường, CI/CD, golden path | C | R/A | C | I | I | I |
| SLO, alert, runbook | R | A (Hùng – SRE tạm) | I | I | I | C |
| Backup DB, DR, diễn tập DR | C | R | I | I | A | I |
| Security review | C | C | R | I | A | I |
| Pentest MVP (đơn vị bên ngoài thực hiện) | C | C | A (duyệt kết quả) | I | I | I |
| Load test NFR-002 | C | C (cấp môi trường) | I | R | A | I |
| Test end-to-end, UAT | C | I | I | R | I | A |
