<!-- Profile "infra": repo IaC (AWS + Terraform) do Infra giữ. Chép vào sau marker core:end trong .specify/memory/constitution.md của repo, điền {…}, xoá luật không áp dụng. Giá trị mặc định là gợi ý; đổi theo NFR và ADR của dự án. Repo infra thường ghép thêm profile observability và security-policy. Mỗi mục ghi team giữ: sửa luật trong mục nào cần team đó duyệt (core II-c). -->

## Profile infra

> Repo: `{infra}` · Team giữ repo: {Infra} · Thành phần: theo bảng "Danh sách repo" trong `.project/docs/delivery/team-map.md`

### Phạm vi dùng Spec Kit · *Infra giữ*

- **INF-01 (MUST)** Dùng luồng `/speckit-specify` → `plan` → `tasks` → `implement` cho việc **tạo mới hoặc thay đổi kiến trúc** hạ tầng: account, VPC, cluster, DB, môi trường mới, đổi mô hình mạng hay IAM.
- **INF-02 (MUST)** Việc vận hành định kỳ (rotate certificate, scale node group, nâng bản patch, xử lý sự cố) đi qua ticket và runbook, không tạo spec.

### Stack · *Infra giữ*

| Hạng mục | Theo |
| --- | --- |
| Cloud, region, mô hình account | {ADR-0002} |
| IaC, phiên bản Terraform và provider | {ADR-0004} |
| CI/CD cho hạ tầng | {ADR-0007} |

### Quy ước IaC · *Infra giữ*

- **INF-10 (MUST)** Cấu trúc repo theo `infra-after-hld.md`: `terraform/modules/<tên>/` cho module dùng lại, `terraform/live/<env>/<NN-stack>/` (ví dụ `20-k8s`, `30-database`) cho cấu hình từng môi trường, `terraform/live/global/` cho tài nguyên dùng chung. `live/` chỉ gọi module, không khai báo resource trực tiếp.
- **INF-11 (MUST)** State để ở backend từ xa có khoá và mã hoá (`{S3 + use_lockfile}`), mỗi stack một state. Không commit state hay file `.tfvars` chứa secret.
- **INF-12 (MUST)** Pin phiên bản Terraform và provider; module nội bộ gọi theo tag.
- **INF-13 (MUST)** Tên resource `{project}-{env}-{component}`. Tag bắt buộc trên mọi resource có hỗ trợ tag: `Project`, `Environment`, `OwnerTeam`, `CostCenter`, `DataClassification`, `ManagedBy=terraform` (đặt qua `default_tags` của provider).
- **INF-14 (MUST)** Không hardcode account ID, region, AMI ID; lấy qua biến hoặc data source.

### Security · *Infra hiện thực, Security giữ luật*

- **INF-20 (MUST)** IAM theo least privilege: không dùng `"Action": "*"` hoặc `"Resource": "*"` trừ khi có ADR ghi ngoại lệ. Workload trên cluster dùng IAM role cho service account (IRSA hoặc Pod Identity), không dùng access key.
- **INF-21 (MUST)** Mã hoá at rest bằng KMS cho S3, EBS, RDS, backup; in transit TLS ≥ 1.2.
- **INF-22 (MUST)** Không có S3 bucket, DB, snapshot công khai. Security group không mở inbound `0.0.0.0/0` trừ load balancer cổng 443.
- **INF-23 (MUST)** Secret nằm trong `{Secrets Manager / SSM SecureString}`, không nằm trong code, biến Terraform hay output.
- **INF-24 (MUST)** Giữ baseline của Security trên mọi account: CloudTrail, GuardDuty, Config, chặn truy cập root. Không tắt qua Terraform của stack ứng dụng.

### Reliability · *Infra giữ, SRE duyệt*

- **INF-30 (MUST)** Thành phần phục vụ chức năng Tier 1 chạy Multi-AZ, theo NFR availability.
- **INF-31 (MUST)** Dữ liệu có backup tự động, RPO và RTO theo `nfr.md`; plan ghi cách kiểm chứng restore.
- **INF-32 (SHOULD)** Kiểm tra service quota trước khi tạo tài nguyên lớn; ghi trong `research.md`.

### Performance · *Infra giữ*

- **INF-40 (SHOULD)** Chọn loại và kích thước instance dựa trên số đo hoặc ước lượng tải ghi trong `research.md`; có autoscaling cho workload thay đổi theo tải.
- **INF-41 (MUST)** Thay đổi hạ tầng của chức năng Tier 1 có load test ở staging trước khi lên prod.

### Cost · *Infra giữ*

- **INF-50 (MUST)** Plan có ước tính chi phí theo tháng cho từng môi trường (`{infracost}`); tăng quá {20%} so với hiện tại cần PO hoặc người giữ ngân sách duyệt.
- **INF-51 (MUST)** Mỗi account có budget alert.
- **INF-52 (SHOULD)** Môi trường dev tắt hoặc scale về 0 ngoài giờ làm việc.

### Operational excellence · *Infra giữ*

- **INF-60 (MUST)** Mọi thay đổi qua Terraform và pipeline; không sửa tay trên console. Pipeline chạy phát hiện drift {hằng ngày}.
- **INF-61 (MUST)** CI chạy `terraform fmt -check`, `validate`, `tflint`, `{checkov}` và đính kèm output `plan` vào PR.
- **INF-62 (MUST)** Apply chỉ chạy từ pipeline, có người duyệt; prod theo khung giờ thay đổi {…}. AI chỉ chạy `plan` ở dev hoặc sandbox (core III).
- **INF-63 (MUST)** Tài nguyên mới có metrics và log đổ về stack monitoring; alert cho tài nguyên đó viết trong `observability/` theo profile observability.

### Database dùng chung · *DBA giữ* · CODEOWNERS `terraform/live/*/30-database/`, `terraform/modules/{rds-*}/`: {DBA}

- **INF-65 (MUST)** Cụm DB dùng chung chỉ tạo qua module do DBA duyệt; tham số engine (phiên bản, parameter group, connection limit) thay đổi phải có DBA duyệt.
- **INF-66 (MUST)** Backup và replication DB theo RPO, RTO trong `nfr.md`; diễn tập restore theo lịch {hằng quý}, kết quả ghi vào runbook.
- **INF-67 (MUST)** Mỗi service có DB user và schema riêng, quyền tối thiểu; không dùng tài khoản master cho ứng dụng.

### Sustainability · *Infra giữ*

- **INF-70 (SHOULD)** Ưu tiên instance Graviton và dịch vụ managed khi đáp ứng được yêu cầu.

### Cung cấp cho team khác · *Infra giữ*

- **INF-80 (MUST)** Mỗi tài nguyên team khác dùng có một dòng trong mục "Tài nguyên hạ tầng" của `.project/docs/architecture/api-catalog.md`; tên dòng là tên dùng trong `[Provides: …]` và `[Needs: …]`.
- **INF-81 (MUST)** Giá trị team khác cần (endpoint, ARN role, tên secret) công bố qua `{SSM Parameter Store}` theo đường dẫn `/{project}/{env}/{component}/{key}`, không gửi qua chat hay tài liệu.
