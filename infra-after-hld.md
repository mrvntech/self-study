# Công việc của team Infra sau HLD: monitoring và security

> Ghi chú tự học · Cập nhật: 2026-11-02
> Liên quan: [hld-template.md](hld-template.md) · [monitoring-design-hld.md](monitoring-design-hld.md) · [sdlc.md](sdlc.md) · [speckit-big-picture.md](speckit-big-picture.md)

Sau khi HLD chốt các mục Security (7), DR (8), Monitoring (10) và Deployment (11), team infra **không viết Terraform ngay**. Họ đi qua 6 bước: **thiết kế chi tiết hạ tầng → dựng nền tảng IaC → xây hạ tầng theo lớp → hiện thực monitoring và security dưới dạng code → kiểm chứng → bàn giao và vận hành**.

## Tổng quan

```
HLD được duyệt (mục 7, 8, 10, 11)
   │
   ▼
1. Infra LLD ─────────── IP plan, ma trận firewall, IAM model, sizing, thiết kế pipeline log/metrics
   │
   ▼
2. Nền tảng IaC ──────── repo, remote state, CI cho IaC, policy as code, quản lý secret
   │
   ▼
3. Xây hạ tầng theo lớp (Terraform → Ansible → Helm/GitOps)
   L0 account/IAM → L1 network → L2 security baseline → L3 compute/K8s/DB
   → L4 cấu hình OS → L5 observability stack → L6 platform cho app
   │
   ▼
4. Monitoring & Security as code ── alert rule, dashboard, log pipeline, policy, hardening
   │
   ▼
5. Kiểm chứng ────────── test IaC, test alert, CIS benchmark, diễn tập failover/DR, pentest
   │
   ▼
6. Production Readiness Review → bàn giao → vận hành (drift, patch, chi phí)
```

---

## Bước 1: Thiết kế chi tiết hạ tầng (Infra LLD)

HLD nói *cái gì*; Infra LLD trả lời **chính xác thì dựng ra sao**, là đầu vào trực tiếp để viết Terraform và Ansible.

| Mục HLD | Output trong Infra LLD |
| --- | --- |
| 11. Deployment & Infra | **IP plan** (CIDR cho từng VPC, subnet, môi trường), sizing (loại instance, số node, ổ đĩa), thiết kế K8s cluster (node pool, namespace), quy ước đặt tên và gắn tag |
| 7. Security | **Ma trận firewall** (nguồn → đích → port → lý do), **IAM model** (role, policy, ai được làm gì), quản lý secret và key, chuẩn hardening (CIS level nào) |
| 8. DR | Cấu hình backup (snapshot, WAL archive, vùng lưu), mô hình failover, quy trình khôi phục |
| 10. Monitoring | Kiến trúc pipeline log/metrics/trace, cấu hình agent, quy ước label, retention từng loại dữ liệu, sizing storage của monitoring |

Ví dụ ma trận firewall:

| # | Nguồn | Đích | Port | Giao thức | Lý do |
| --- | --- | --- | --- | --- | --- |
| 1 | Internet | WAF/LB | 443 | TCP | Truy cập người dùng |
| 2 | LB | K8s ingress | 443 | TCP | Chuyển tiếp request |
| 3 | K8s app subnet | DB subnet | 5432 | TCP | Service gọi PostgreSQL |
| 4 | Bastion | Mọi VM | 22 | TCP | Quản trị, chỉ từ VPN |
| 5 | Mọi node | Monitoring subnet | 4317, 3100 | TCP | Gửi trace (OTLP), log (Loki) |
| 6 | Monitoring subnet | Mọi node | 9100 | TCP | Prometheus lấy metrics |

### Ai tham gia LLD

LLD không chỉ có Dev và DevOps. Hai nhóm này là người **viết chính**; các role khác viết một phần hoặc review.

| Loại LLD | Người viết chính | Người tham gia |
| --- | --- | --- |
| LLD ứng dụng (mỗi service) | Dev team sở hữu | Architect, SRE, Security, QA |
| LLD dữ liệu | Dev + **DBA** | Architect |
| **LLD hạ tầng** | **DevOps/Infra + Network Engineer** | Architect, Security, SRE, DBA (backup) |
| **LLD observability** | **SRE** (cùng Infra) | Dev (instrument), Ops/NOC |
| **LLD bảo mật** (hoặc phần trong các LLD trên) | **Security** cùng Dev/Infra | Architect |
| LLD giao diện | Frontend Dev + UI/UX | QA |
| LLD tích hợp | Dev các team liên quan | Architect |

| Nếu thiếu | Hậu quả thường gặp |
| --- | --- |
| Security | Lỗ hổng chỉ phát hiện khi pentest, sửa rất tốn kém |
| SRE | Không có metrics, timeout/retry sai, không có runbook |
| DBA | Thiếu index, migration khóa bảng lâu trên production |
| QA | Thiết kế khó test, không có dữ liệu test |
| Architect | Mỗi team một kiểu, LLD lệch HLD |
| BA/PO | Dev tự đoán quy tắc nghiệp vụ |

Quyết định quan trọng (chọn công cụ, mô hình mạng) ghi thành ADR. Infra LLD được Architect, Security và SRE duyệt.

---

## Bước 2: Dựng nền tảng IaC

### Cấu trúc repo

```
infra/
├── terraform/
│   ├── modules/                 # network, k8s, rds, iam, kms…
│   └── live/
│       ├── global/              # IAM, DNS, state backend
│       ├── dev/  staging/  prod/
│       │   ├── 00-network/
│       │   ├── 10-security/
│       │   ├── 20-k8s/
│       │   ├── 30-database/
│       │   └── 40-observability/
├── ansible/
│   ├── inventories/{dev,staging,prod}/
│   ├── roles/                   # hardening, node_exporter, fluent_bit, auditd, chrony…
│   └── playbooks/
├── k8s/                         # Helm values / manifest theo GitOps (Argo CD, Flux)
│   ├── platform/                # ingress, cert-manager, external-secrets, kyverno
│   └── observability/           # prometheus, loki, tempo, grafana, alertmanager
├── observability/
│   ├── alerts/                  # PrometheusRule theo service
│   ├── recording-rules/         # SLI/SLO
│   ├── dashboards/              # Grafana JSON / Jsonnet
│   └── runbooks/
└── policies/                    # OPA/Conftest, Kyverno policy
```

### Thành phần nền tảng

| Thành phần | Mục đích | Ví dụ công cụ |
| --- | --- | --- |
| Remote state có khóa | Không mất state, không hai người apply cùng lúc | S3 + DynamoDB, GCS, Terraform Cloud |
| CI cho IaC | Mọi thay đổi qua PR, có `plan` để review | GitHub Actions, GitLab CI, Atlantis |
| Kiểm tra tĩnh | Bắt lỗi cú pháp và cấu hình không an toàn trước khi apply | `terraform fmt/validate`, tflint, Checkov, Trivy (tfsec), ansible-lint |
| Policy as code | Chặn cấu hình vi phạm (bucket public, thiếu mã hóa, thiếu tag) | OPA/Conftest, Sentinel |
| Quản lý secret | Không để secret trong repo | Vault, SOPS, cloud secret manager |
| Phân quyền apply | Chỉ pipeline được apply prod | OIDC từ CI sang cloud, role riêng cho từng môi trường |

Pipeline IaC:

```
PR → fmt/validate/lint → Checkov/Trivy → Conftest → terraform plan (đăng lên PR)
   → review (≥ 1 người infra, + Security nếu chạm IAM/network)
   → merge → apply dev → apply staging → phê duyệt thủ công → apply prod
```

---

## Bước 3: Xây hạ tầng theo lớp

Lớp sau phụ thuộc lớp trước. **Terraform tạo tài nguyên, Ansible cấu hình bên trong VM, Helm/GitOps triển khai trên K8s.**

| Lớp | Nội dung | Công cụ | Monitoring / security |
| --- | --- | --- | --- |
| **L0 – Nền móng** | Tài khoản/project, IAM, state backend, tag | Terraform | IAM least privilege; bật audit log của cloud ngay từ đầu |
| **L1 – Mạng** | VPC, subnet, route, NAT, DNS, VPN/bastion | Terraform | Phân vùng theo ma trận firewall; bật VPC flow log |
| **L2 – Security baseline** | KMS, secret manager, WAF, chuyển audit log về SIEM | Terraform | Mã hóa mặc định; WAF rule; audit log không sửa được |
| **L3 – Compute & dữ liệu** | K8s, node pool, VM, DB, cache, object storage, backup | Terraform | DB không có IP public; mã hóa khi lưu; backup mã hóa sang vùng khác |
| **L4 – Cấu hình OS** (VM) | Hardening CIS, user/SSH, NTP, agent | **Ansible** | `node_exporter`, `fluent-bit`, `auditd`; SSH chỉ dùng key |
| **L5 – Observability stack** | Prometheus/Mimir, Loki, Tempo, Grafana, Alertmanager, OTel Collector | Helm + GitOps | Cluster/vùng riêng; Grafana đăng nhập SSO |
| **L6 – Platform cho app** | Ingress, cert-manager, External Secrets, Kyverno/Gatekeeper, Helm chart chuẩn | Helm + GitOps | TLS tự động; secret từ Vault; chặn image chưa ký hoặc chạy root |

### Terraform và Ansible

| | Terraform | Ansible |
| --- | --- | --- |
| Làm gì | **Provision**: tạo, sửa, xóa tài nguyên | **Configure**: cài đặt, cấu hình bên trong máy |
| Cách hoạt động | Khai báo trạng thái mong muốn, có state | Chạy task theo thứ tự, idempotent, không có state |
| Ví dụ | VPC, security group, K8s, RDS, IAM, KMS | Hardening OS, agent, `sshd`, `auditd`, `chrony` |
| Không nên | Cài phần mềm trong VM bằng `remote-exec` | Tạo tài nguyên cloud |

Hai công cụ nối nhau qua **dynamic inventory**: Ansible lấy danh sách VM theo tag mà Terraform đã gắn. Hệ thống chạy hoàn toàn trên K8s thì Ansible chỉ còn dùng cho bastion, VM đặc biệt, hoặc tạo golden image cùng Packer.

---

## Bước 4a: Monitoring dưới dạng code

### Hợp đồng observability với team dev

Infra không instrument code thay dev; họ đưa ra hợp đồng và golden path:

| Dev phải làm | Infra/SRE cung cấp |
| --- | --- |
| Endpoint `/metrics` theo quy ước tên | `ServiceMonitor` tự sinh từ Helm chart chuẩn |
| Log JSON ra stdout, có `trace_id`, `service`, `env` | Fluent Bit DaemonSet thu log, parse JSON, che PII |
| Gửi trace qua OTLP | OTel Collector, sampling cấu hình tập trung |
| `/health/live`, `/health/ready` | Probe mặc định trong Helm chart, blackbox check |
| Khai báo SLO của service | Template recording rule và alert theo burn rate |

### SLO → recording rule → alert

```yaml
# observability/alerts/order-service.yaml (rút gọn)
groups:
- name: order-slo
  rules:
  - record: sli:order_availability:ratio_rate1h
    expr: |
      sum(rate(http_requests_total{service="order",code!~"5.."}[1h]))
      / sum(rate(http_requests_total{service="order"}[1h]))
  - alert: OrderAvailabilityBurnFast
    expr: (1 - sli:order_availability:ratio_rate1h) > (14.4 * 0.001)
    for: 5m
    labels: { severity: P1, team: order }
    annotations:
      summary: "Order đang đốt error budget nhanh"
      runbook_url: "https://…/runbooks/order-availability"
```

Kiểm tra trong CI: `promtool check rules` và `promtool test rules` (giả lập dữ liệu, khẳng định alert kích hoạt).

### Pipeline log

| Việc | Cấu hình |
| --- | --- |
| Thu log | Fluent Bit (DaemonSet trên K8s, role Ansible trên VM) |
| Parse, làm giàu | Parse JSON, thêm `namespace`, `pod`, `env` |
| Che dữ liệu nhạy cảm | Filter che email, số điện thoại, token **trước khi** gửi đi |
| Định tuyến | Log ứng dụng → Loki/Elasticsearch; audit log → SIEM |
| Retention | Theo bảng trong HLD (ví dụ 14 ngày nóng, 90 ngày lạnh) |
| Giới hạn | Rate limit theo namespace |

### Dashboard, định tuyến alert, meta-monitoring

- **Dashboard as code:** Grafana JSON/Jsonnet trong git, triển khai bằng provisioning hoặc Terraform provider; không tạo tay trên prod.
- **Alertmanager:** định tuyến theo `team`, `severity` tới PagerDuty/Slack; `inhibit_rules`; silence khi bảo trì.
- **Meta-monitoring:** alert "Watchdog" luôn bật, gửi tới dead man's switch bên ngoài.
- **Synthetic check:** blackbox exporter kiểm tra user journey chính từ bên ngoài.

---

## Bước 4b: Security dưới dạng code

Mỗi biện pháp trong threat model của HLD phải ứng với **code hoặc policy kiểm tra được**.

| Biện pháp trong HLD | Hiện thực | Công cụ |
| --- | --- | --- |
| Least privilege | IAM role theo service; workload identity thay access key | Terraform |
| Phân vùng mạng | Security group theo ma trận firewall; `NetworkPolicy` mặc định chặn hết | Terraform, Helm |
| Mã hóa khi lưu | KMS key theo môi trường; mã hóa disk, DB, bucket, backup | Terraform + policy |
| Mã hóa khi truyền | cert-manager cấp TLS; mTLS nếu HLD yêu cầu | Helm |
| Quản lý secret | Vault/secret manager; External Secrets; xoay vòng định kỳ | Terraform, Helm |
| Hardening OS | Role CIS: SSH, sysctl, tắt dịch vụ thừa, `auditd` | **Ansible** |
| An toàn container | Chặn image chưa ký, chạy root, privileged; chỉ registry nội bộ | Kyverno/Gatekeeper, Cosign |
| Audit log | Cloud audit, K8s audit, `auditd` → SIEM; lưu không sửa được | Terraform, Ansible, Fluent Bit |
| Bảo vệ biên | WAF (OWASP), rate limit, chống DDoS | Terraform |
| Quét lỗ hổng | Quét image trong CI và registry; quét IaC | CI |
| Vá lỗi | Lịch vá OS, nâng cấp K8s | Ansible, Packer |

Ví dụ policy chặn trong CI trước khi apply:

```rego
# policies/terraform/s3_encryption.rego (Conftest)
deny[msg] {
  r := input.resource_changes[_]
  r.type == "aws_s3_bucket"
  not r.change.after.server_side_encryption_configuration
  msg := sprintf("Bucket %s chưa bật mã hóa", [r.address])
}
```

---

## Bước 5: Kiểm chứng

| Loại | Kiểm tra gì | Công cụ |
| --- | --- | --- |
| Test IaC | Module tạo đúng tài nguyên; role Ansible idempotent | Terratest, `terraform test`, Molecule |
| Policy | Không có cấu hình vi phạm | Checkov, Conftest, Kyverno CLI |
| Benchmark bảo mật | Đạt CIS cho OS và K8s | kube-bench, OpenSCAP, Lynis |
| Test alert | Alert kích hoạt đúng, đến đúng người | `promtool test rules`; tắt thử service trên staging |
| Test log | Log đến đúng nơi, PII đã che | Gửi log mẫu chứa dữ liệu giả |
| Failover / chaos | Chịu được mất node, zone, DB primary | Chaos Mesh, Litmus, diễn tập |
| Backup / DR | Đạt RPO/RTO trong HLD | Diễn tập khôi phục thật, đo thời gian |
| Pentest | Lỗ hổng từ bên ngoài | Security hoặc bên thứ ba |

---

## Bước 6: Production Readiness Review và vận hành

### Checklist trước go-live

- [ ] Mọi hạ tầng tạo bằng code; không có tài nguyên tạo tay
- [ ] Ma trận firewall và IAM đã được Security duyệt
- [ ] Mọi service Tier 1 có SLO, alert, runbook, người nhận alert
- [ ] Log đến đúng nơi, PII đã che, audit log đã vào SIEM
- [ ] Meta-monitoring hoạt động
- [ ] Đã diễn tập khôi phục backup và failover; có số đo RPO/RTO thực tế
- [ ] CIS benchmark đạt mức đã chốt; pentest không còn lỗi High
- [ ] Có lịch on-call và quy trình escalation

### Sau go-live

| Việc | Tần suất |
| --- | --- |
| Phát hiện drift (`terraform plan` theo lịch) | Hằng ngày |
| Vá OS, cập nhật image | Hằng tháng; lỗ hổng nghiêm trọng làm ngay |
| Xem lại alert ồn, alert không ai xử lý | Hằng tháng |
| Xoay vòng secret, chứng chỉ | Theo chính sách |
| Rà soát chi phí hạ tầng và monitoring | Hằng tháng |
| Diễn tập DR | 6 tháng một lần |

---

## Phối hợp với các team khác

```
Tuần:         1    2    3    4    5    6    7    8
Infra:       [L0-L1][L2-L3 ][L4-L5   ][L6][Test, PRR]
                    │      │          │
                    ▼      ▼          ▼
Dev:            dev env  staging   golden path (Helm chart, ServiceMonitor)
                sẵn sàng sẵn sàng  → các team onboard service
Security:    [duyệt IAM/firewall]  [CIS, quét]      [pentest]
SRE:              [SLO chi tiết]  [alert, dashboard] [test alert, runbook]
```

- **Môi trường dev phải có trước khi team dev cần.** Đây là các phụ thuộc D-xx trong `dependencies.md`, bên cung cấp là Platform.
- **Golden path:** Helm chart chuẩn đã gắn probe, `ServiceMonitor`, `NetworkPolicy` mặc định, cấu hình log. Service dùng chart này thì mặc định tuân thủ hợp đồng monitoring và security.

## Liên hệ với Spec Kit

- Các lớp hạ tầng tương ứng các enabler feature: `000-foundation` (L0–L3, L6), `010-observability` (L5 + bước 4a), `011-security-baseline` (L2, L4 + bước 4b).
- AI viết Terraform, Ansible, rule, policy rất nhanh, nhưng **`terraform plan` phải được con người review**, và **AI không được quyền apply lên staging hoặc prod**. Ghi vào constitution.
- Code hạ tầng do AI sinh phải qua Checkov/Conftest và có test (Terratest, Molecule, `promtool`) trước khi merge.

Thời gian trong sơ đồ phối hợp và các tần suất là ví dụ, tùy quy mô dự án.
