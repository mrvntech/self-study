---
description: Từ HLD và PRD đã duyệt, đề xuất cách chia việc thành feature/epic theo team (gồm cả enabler cho Infra, SRE, Security, DBA, QA), contract giữa các team, phụ thuộc và mốc. Chỉ đề xuất, không sửa file.
---

Bạn đang chia việc ở **mức dự án**, sau khi HLD (`/project.hld`) và team map (`/project.teammap`) đã được duyệt và trước khi các team chạy `/speckit.specify`. Không sửa file nào; chỉ đưa ra bản đề xuất để con người review.

## Đầu vào

1. `docs/product/prd.md` (REQ-xx), `docs/product/nfr.md` (NFR-xxx, cột "Mục HLD đáp ứng"), `docs/product/feature-map.md` (feature lượt 1 và các dòng đã có).
2. `docs/architecture/hld.md`:
   - Mục thành phần: bảng thành phần và **team sở hữu**.
   - Các mục xuyên suốt (Security, Availability/DR, Scalability, Monitoring, Deployment/Infra): bảng **"Team thực hiện"** ở đầu mỗi mục.
3. `docs/architecture/domain-model.md`, `docs/architecture/api-catalog.md`.
4. `docs/delivery/team-map.md`: thành phần sở hữu và bảng ranh giới trách nhiệm việc xuyên suốt.
5. `docs/delivery/release-plan.md` (nếu đã có mốc).

Phạm vi hoặc ràng buộc bổ sung từ người dùng: $ARGUMENTS

## Bước 0: kiểm tra đầu vào

Trước khi chia, liệt kê các thiếu sót sau. Thiếu sót nào ảnh hưởng tới cách chia thì ghi rõ giả định bạn dùng:

- Thành phần trong HLD chưa có team sở hữu.
- Mục xuyên suốt trong HLD chưa có bảng "Team thực hiện".
- Tên team trong HLD không có trong `team-map.md`.
- NFR chưa điền "Mục HLD đáp ứng".
- Team trong `team-map.md` không sở hữu thành phần nào.

## Quy tắc chia chung

1. Mỗi REQ trong PRD thuộc ít nhất một feature.
2. **Một feature, một team**, chia theo lát cắt dọc, dựa trên thành phần mà team sở hữu. Feature buộc phải trải qua nhiều team thì tách thành F-xxxa, F-xxxb.
3. Mỗi mục xuyên suốt trong HLD và mỗi NFR có ít nhất một **enabler feature** cho team thực hiện.
4. Mỗi API/event giữa hai team sinh ra một **contract** `C-xx`, xếp trước các feature dùng nó.
5. Feature quá lớn (khoảng hơn 5–7 user story, hoặc hơn một lớp hạ tầng không liên quan) thì tách.
6. Không tự đặt ngày. Chỉ gán mốc có trong `release-plan.md`; chưa có thì đề xuất M0, M1… không kèm ngày.
7. Giữ nguyên mã của feature đã có; chỉ thêm mã mới.

## Ánh xạ mặc định từ HLD sang team

Dùng **bảng "Team thực hiện" trong HLD** và **`team-map.md`** trước. Chỉ khi hai nguồn này không ghi, mới dùng bảng mặc định dưới đây, và đánh dấu dòng đó là "giả định".

| Mục HLD | Hạng mục | Team mặc định | Enabler đề xuất |
| --- | --- | --- | --- |
| Deployment/Infra | Account, IAM nền, state backend (L0) | Infra | Foundation |
| Deployment/Infra | Mạng, DNS, VPN/bastion (L1) | Infra | Foundation |
| Deployment/Infra | K8s cluster, VM, node pool (L3) | Infra | Foundation |
| Deployment/Infra | CI/CD pipeline, registry | Infra | Foundation |
| Deployment/Infra | Golden path: Helm chart chuẩn, ingress, cert-manager, External Secrets (L6) | Infra (+ SRE review) | Golden path |
| Security | Chính sách bảo mật, threat model, SIEM, WAF rule, quét lỗ hổng, pentest | Security | Security baseline |
| Security | Hiện thực IAM, security group, KMS, secret manager (L2) | Infra | Foundation hoặc Security infra |
| Security | Hardening OS theo CIS, `auditd` (L4, Ansible) | Infra (+ Security duyệt) | OS hardening |
| Security | AuthN/AuthZ trong ứng dụng | Team sở hữu service auth | Business hoặc Foundation |
| Availability/DR | Backup, replication, failover hạ tầng | Infra | Backup & DR |
| Availability/DR | Backup và replication DB | DBA (+ Infra) | Backup & DR (tách nếu khác team) |
| Scalability | Auto-scaling, cache dùng chung, CDN | Infra | Scaling |
| Monitoring | Dựng stack Prometheus/Loki/Tempo/Grafana/Alertmanager, agent (L5) | Infra | Observability stack |
| Monitoring | SLO, recording rule, alert, dashboard, runbook, on-call | SRE (+ team sở hữu service) | SLO & alerting |
| Monitoring | Instrument code (metrics, log, trace, health check) | Mỗi team dev, trong feature business của mình | Không tạo enabler riêng |
| Dữ liệu | Cụm DB dùng chung, chuẩn schema, migration tooling | DBA | Data platform |
| Testing | Test E2E dùng chung, môi trường test, dữ liệu test | QA | Test platform |

## Quy tắc riêng cho việc hạ tầng

1. **Tách theo lớp và theo kết quả đầu ra**, không gom thành một feature "làm hạ tầng". Thứ tự lớp: L0 nền móng → L1 mạng → L2 security baseline → L3 compute/K8s/DB → L4 cấu hình OS → L5 observability stack → L6 golden path.
2. Có thể gộp các lớp liền nhau vào một feature nếu cùng team và cùng mốc (ví dụ Foundation = L0–L3), nhưng golden path (L6) và observability stack (L5) luôn là feature riêng, vì nhiều team phụ thuộc vào chúng.
3. **Hạ tầng dựng stack, team chuyên trách cấu hình nội dung:** Infra dựng stack monitoring, SRE viết SLO và alert; Infra hiện thực IAM và mạng, Security đặt chính sách và duyệt.
4. Mỗi enabler hạ tầng ghi **kết quả cho team khác dùng được**, ví dụ "các team deploy được service mẫu lên staging qua pipeline".

## Quy tắc phụ thuộc

| Feature | Phụ thuộc |
| --- | --- |
| Mọi enabler hạ tầng L1–L6 | Foundation L0 |
| Golden path (L6) | Foundation (L0–L3) |
| Observability stack (L5) | Foundation |
| SLO & alerting (SRE) | Observability stack |
| OS hardening | Foundation; chuẩn CIS đã được Security chốt |
| Security baseline (công cụ) | Foundation |
| Mọi feature business cần chạy trên staging | **Golden path** (không chỉ Foundation) |
| Feature business dùng API/event của team khác | Contract `C-xx` tương ứng |
| Backup & DR | Foundation và cụm DB |

Đánh dấu feature hạ tầng nằm trên **đường găng** của nhiều team (thường là Foundation và Golden path).

## Đầu ra (Markdown)

1. **Thiếu sót đầu vào** (Bước 0) và giả định đã dùng.
2. **Đề xuất feature map:** bảng theo đúng cột của `docs/product/feature-map.md`, có cột **Loại** (Business / Enabler / Contract), **Nguồn** (REQ, NFR hoặc mục HLD), **Lớp** (L0–L6, nếu là hạ tầng) và **Cỡ** (S/M/L). Đánh dấu dòng mới hoặc thay đổi, và dòng dùng ánh xạ mặc định.
3. **Việc theo team:** mỗi team một danh sách feature; riêng Infra liệt kê theo thứ tự lớp.
4. **Phụ thuộc đề xuất:** theo định dạng của `docs/delivery/dependencies.md`; ghi rõ feature nằm trên đường găng.
5. **Sơ đồ phụ thuộc** dạng Mermaid `flowchart LR`.
6. **Truy vết:**
   - REQ chưa có feature.
   - NFR hoặc mục HLD chưa có enabler.
   - Team có quá nhiều hoặc không có việc; team nằm trên đường găng của nhiều team khác.
7. **Câu hỏi cần con người quyết định:** ranh giới team, ưu tiên, tách hay gộp feature, giả định ánh xạ mặc định có đúng không.

Sau khi con người duyệt và cập nhật các file trong `docs/`, bước tiếp theo là `/project.backlog`.
