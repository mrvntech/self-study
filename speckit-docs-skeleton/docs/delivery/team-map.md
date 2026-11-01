# Team map

> Tầng điều phối. Ai sở hữu thành phần nào và đang làm tính năng nào. Nhãn `[Team: …]` trong `tasks.md`, cột Team trong `feature-map.md` và bảng "Team thực hiện" trong HLD phải dùng đúng tên team ở đây. Lệnh `/project.breakdown` đọc file này để chia việc.

## Danh sách team

Ghi thành phần sở hữu **cụ thể**. Ví dụ "Infra: hạ tầng" là quá chung, khiến việc bị gom thành một feature khổng lồ.

| Team | Tech Lead | Thành phần sở hữu | Tính năng đang làm | Kênh liên lạc |
| --- | --- | --- | --- | --- |
| {Infra} | {Tên} | {Account/IAM nền, mạng/DNS/VPN, K8s cluster, CI/CD, registry, Terraform/Ansible, golden path Helm chart, hạ tầng stack monitoring, backup hạ tầng} | F-000 | {#team-infra} |
| {SRE} | {Tên} | {SLO, recording rule, alert, dashboard, runbook, on-call, diễn tập DR} | F-011 | {#team-sre} |
| {Security} | {Tên} | {Chính sách bảo mật, threat model, SIEM, WAF rule, quét lỗ hổng, pentest} | F-012 | {#team-security} |
| {DBA} | {Tên} | {Cụm DB dùng chung, chuẩn schema, migration tooling, backup DB} | — | {#team-dba} |
| {QA} | {Tên} | {Test E2E dùng chung, môi trường và dữ liệu test} | — | {#team-qa} |
| {Team Identity} | {Tên} | {auth-service} | F-001 | {#team-identity} |
| {Team Order} | {Tên} | {order-service} | F-002a | {#team-order} |
| {Team Payment} | {Tên} | {payment-service} | F-002b | {#team-payment} |

## Ranh giới trách nhiệm việc xuyên suốt

Phần dễ tranh chấp nhất giữa các team. Ghi rõ ở đây để `/project.breakdown` không gộp việc của hai team vào một feature.

| Việc | Team thực hiện | Team duyệt / phối hợp |
| --- | --- | --- |
| Dựng stack monitoring (Prometheus, Loki, Tempo, Grafana, Alertmanager, agent) | {Infra} | {SRE} |
| SLO, alert, dashboard, runbook | {SRE} | {Team sở hữu service} |
| Instrument code (metrics, log, trace, health check) | {Mỗi team dev} | {SRE} |
| Chính sách IAM, firewall | {Security} | {Infra} |
| Hiện thực IAM, security group, KMS, secret manager | {Infra} | {Security} |
| Hardening OS theo CIS | {Infra} | {Security} |
| Golden path Helm chart | {Infra} | {SRE, Security} |
| Backup và replication DB | {DBA} | {Infra} |
| Diễn tập DR | {SRE} | {Infra, DBA} |
| Test E2E, UAT | {QA} | {PO} |

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
