# Team map

> Tầng điều phối. Ai sở hữu thành phần nào và đang làm tính năng nào. Nhãn `[Team: …]` trong `tasks.md` phải dùng đúng tên team ở đây.

## Danh sách team

| Team | Tech Lead | Thành phần sở hữu (theo HLD mục 4) | Tính năng đang làm | Kênh liên lạc |
| --- | --- | --- | --- | --- |
| {Platform} | {Tên} | {CI/CD, K8s, API gateway} | F-000 | {#team-platform} |
| {Team Identity} | {Tên} | {auth-service} | F-001 | {#team-identity} |
| {Team Order} | {Tên} | {order-service} | F-002a | {#team-order} |
| {Team Payment} | {Tên} | {payment-service} | F-002b | {#team-payment} |
| {SRE} | {Tên} | {Stack monitoring, alerting} | F-010 | {#team-sre} |
| {Security} | {Tên} | {SIEM, chính sách bảo mật} | F-011 | {#team-security} |
| {QA} | {Tên} | {Test tự động end-to-end, môi trường test} | — | {#team-qa} |

## Vai trò dùng chung

| Vai trò | Người | Trách nhiệm |
| --- | --- | --- |
| Solution Architect | {Tên} | Giữ HLD, duyệt ADR, review plan có "Ảnh hưởng kiến trúc" |
| Product Owner | {Tên} | Giữ PRD, feature map, ưu tiên |
| Delivery / Project Manager | {Tên} | Giữ release plan, dependencies, điều phối giữa các team |

## RACI theo loại việc

| Việc | Team sở hữu tính năng | Platform | SRE | Security | QA | Architect | PO |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Spec tính năng | R | I | C | C | C | C | A |
| Plan tính năng | R/A | C | C | C | I | C | I |
| Contract API/event giữa team | R | I | I | C | I | A | I |
| Môi trường, CI/CD | C | R/A | C | C | I | I | I |
| SLO, alert, runbook | R | C | A | I | I | I | C |
| Test end-to-end, UAT | C | I | I | I | R | I | A |
