# Team map

> Tầng điều phối. Ai sở hữu thành phần nào và đang làm tính năng nào. Nhãn `[Team: …]` trong `tasks.md`, cột Team trong `feature-map.md` và bảng "Team thực hiện" trong HLD phải dùng đúng tên team ở đây. Lệnh `/project.breakdown` đọc file này để chia việc. Bảng "Danh sách repo" là nguồn cho cột Profile và `CODEOWNERS` của từng repo (core constitution II-b, II-c).

## Danh sách team

Ghi thành phần sở hữu **cụ thể**. Ví dụ "Infra: hạ tầng" là quá chung, khiến việc bị gom thành một feature khổng lồ.

| Team | Tech Lead | Thành phần sở hữu | Tính năng đang làm | Kênh liên lạc |
| --- | --- | --- | --- | --- |
| {Infra} | {Tên} | {Account/IAM nền, mạng/DNS/VPN, K8s cluster, CI/CD, registry, Terraform/Ansible, golden path Helm chart, hạ tầng stack monitoring, backup hạ tầng} | F-000 | {#team-infra} |
| {SRE} | {Tên} | {Định nghĩa SLO; alert hạ tầng, dashboard tổng quan, Alertmanager; duyệt observability của các service; on-call; diễn tập DR} | F-011 | {#team-sre} |
| {Security} | {Tên} | {Chính sách bảo mật, threat model, SIEM, WAF rule, quét lỗ hổng, pentest} | F-012 | {#team-security} |
| {DBA} | {Tên} | {Cụm DB dùng chung, chuẩn schema, migration tooling, backup DB} | — | {#team-dba} |
| {QA} | {Tên} | {Test E2E dùng chung, môi trường và dữ liệu test} | — | {#team-qa} |
| {Team Identity} | {Tên} | {auth-service} | F-001 | {#team-identity} |
| {Team Order} | {Tên} | {order-service} | F-002a | {#team-order} |
| {Team Payment} | {Tên} | {payment-service} | F-002b | {#team-payment} |

## Danh sách repo

Mỗi repo có **một team giữ**. Team khác có thể **đóng góp theo đường dẫn**; tính năng của họ đặt `specs/` trong repo đó. Cột "Team duyệt" là nguồn cho `CODEOWNERS`: đường dẫn ghi ở đây bắt buộc team đó duyệt.

Team chuyên trách chỉ có repo riêng khi code của họ có vòng đời độc lập (thay đổi thường xuyên, triển khai khác nhịp) **và** đủ người chạy luồng Spec Kit; nếu không thì đóng góp vào repo khác theo đường dẫn. Team không có code (ví dụ Security chỉ ra chính sách) không cần repo.

| Repo | Team giữ | Thành phần (HLD mục 4) | Team đóng góp: đường dẫn | Team duyệt: đường dẫn | Profile |
| --- | --- | --- | --- | --- | --- |
| `project-docs` | {Architect, PO, PM} | Tài liệu tổng thể | {Security: `docs/security/`, threat model trong HLD 7.1; SRE: SLO trong HLD 10; DBA: `docs/architecture/db-standards.md`} | {Architect: `docs/architecture/`; PO: `docs/product/`; PM: `docs/delivery/`} | — (chạy `/project.*`) |
| `{infra}` | {Infra} | {L0–L6, CI/CD, registry, golden path chart, stack monitoring} | {SRE: `observability/`, `k8s/observability/`; Security: `policies/`; DBA: `terraform/live/*/30-database/`, `terraform/modules/rds-*/`} | {SRE: `observability/`, `k8s/observability/`; Security: `policies/`; DBA: đường dẫn DB} | `infra` + `observability` + `security-policy` |
| `{auth-service}` | {Team Identity} | {auth-service} | {DBA: `migrations/`; SRE: `observability/`} | {DBA: `migrations/`; SRE: `observability/`} | `service` |
| `{order-service}` | {Team Order} | {order-service} | {như trên} | {như trên} | `service` |
| `{payment-service}` | {Team Payment} | {payment-service} | {như trên} | {như trên} | `service` |
| `{e2e-tests}` | {QA} | {Bộ test E2E, kịch bản load test} | — | {SRE: `load/` (ngưỡng)} | `test` |

Team giữ repo có thể sửa mọi đường dẫn; team đóng góp chỉ sửa đường dẫn ghi ở cột của mình. Ở repo service, team giữ repo viết `migrations/` và `observability/`, DBA và SRE duyệt; DBA, SRE chỉ đóng góp khi cần (ví dụ sửa alert theo chuẩn mới).

## Ranh giới trách nhiệm việc xuyên suốt

Phần dễ tranh chấp nhất giữa các team. Ghi rõ ở đây để `/project.breakdown` không gộp việc của hai team vào một feature.

Cột "Nơi làm" có một trong ba dạng: `repo:đường-dẫn` (code, có tính năng Spec Kit), `project-docs:file` (tài liệu), hoặc `hoạt động` (ticket và biên bản, không tạo spec).

| Việc | Team thực hiện | Team duyệt / phối hợp | Nơi làm |
| --- | --- | --- | --- |
| Dựng stack monitoring (Prometheus, Loki, Tempo, Grafana, Alertmanager, agent) | {Infra} | {SRE} | `{infra}:k8s/observability/` |
| Định nghĩa SLO, error budget | {SRE} cùng team sở hữu service | {Architect} | `project-docs:docs/architecture/hld.md` mục 10 |
| Recording rule, alert, dashboard, runbook của từng service | {Team sở hữu service} | {SRE} | `<repo service>:observability/` |
| Alert hạ tầng, dashboard tổng quan, Alertmanager, alert mặc định của golden path | {SRE} | {Infra} | `{infra}:observability/` |
| Instrument code (metrics, log, trace, health check) | {Mỗi team dev} | {SRE} | `<repo service>:src/` |
| On-call | {SRE, team sở hữu service} | {Engineering Manager} | hoạt động |
| Chính sách IAM, firewall, threat model | {Security} | {Infra, Architect} | `project-docs:docs/security/` |
| Policy as code (OPA, Kyverno) | {Security} | {Infra} | `{infra}:policies/` |
| Hiện thực IAM, security group, KMS, secret manager | {Infra} | {Security} | `{infra}:terraform/` |
| Hardening OS theo CIS | {Infra} | {Security} | `{infra}:ansible/` |
| Pentest, duyệt kết quả quét lỗ hổng | {Security} | {Architect} | hoạt động |
| Golden path Helm chart | {Infra} | {SRE, Security} | `{infra}:k8s/` |
| Cụm DB dùng chung, backup và replication DB | {DBA} | {Infra} | `{infra}:terraform/live/*/30-database/` |
| Chuẩn schema | {DBA} | {Architect} | `project-docs:docs/architecture/db-standards.md` |
| Schema và migration của từng service | {Team sở hữu service} | {DBA} | `<repo service>:migrations/` |
| Diễn tập DR | {SRE} | {Infra, DBA} | hoạt động |
| Test E2E, load test | {QA} | {PO, SRE} | `{e2e-tests}` |
| UAT | {QA} | {PO} | hoạt động |

## Vai trò dùng chung

| Vai trò | Người | Trách nhiệm |
| --- | --- | --- |
| Solution Architect | {Tên} | Giữ HLD, duyệt ADR, review plan có "Ảnh hưởng kiến trúc" |
| Product Owner | {Tên} | Giữ PRD, feature map, ưu tiên |
| Delivery / Project Manager | {Tên} | Giữ release plan, dependencies, điều phối giữa các team |

## RACI theo loại việc

| Việc | Team sở hữu tính năng | Infra | SRE | Security | QA | Architect | PO |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Spec tính năng | R | I | C | C | C | C | A |
| Plan tính năng | R/A | C | C | C | I | C | I |
| Contract API/event giữa team | R | I | I | C | I | A | I |
| Môi trường, CI/CD, golden path | C | R/A | C | C | I | I | I |
| SLO, alert, runbook | R | C | A | I | I | I | C |
| Test end-to-end, UAT | C | I | I | I | R | I | A |
