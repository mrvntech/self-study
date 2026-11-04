<!-- Chỉ dùng cho repo Infra. Chèn sau mục "Ảnh hưởng kiến trúc" (từ common) trong .specify/templates/plan-template.md. -->

## Ý nghĩa các file thiết kế trong repo Infra

Spec Kit sinh các file theo mẫu cho service; ở repo Infra dùng như sau:

| File | Nội dung trong repo Infra |
| --- | --- |
| `research.md` | So sánh phương án (ví dụ RDS hay Aurora, NAT Gateway hay VPC endpoint), số đo hoặc ước lượng tải, kiểm tra quota |
| `data-model.md` | **Danh sách resource** sẽ tạo hoặc sửa: loại, tên, module, môi trường, dữ liệu nhạy cảm hay không |
| `contracts/` | **Interface của module** (variables, outputs) và giá trị công bố cho team khác qua `{SSM}` (luật INF-80, INF-81) |
| `quickstart.md` | Cách team dùng lấy giá trị và kết nối tới tài nguyên; cách kiểm tra thủ công sau apply |

## Well-Architected Check *(bắt buộc)*

Mỗi trụ cột ghi cách plan đáp ứng và mã luật liên quan trong profile infra của constitution. Luật `MUST` không đáp ứng được phải đề xuất ADR ngoại lệ và dừng chờ duyệt.

| Trụ cột | Cách đáp ứng | Luật | Đạt? |
| --- | --- | --- | --- |
| Security | {IAM role tối thiểu cho …, KMS key …, SG chỉ mở từ …} | INF-20…24 | {Đạt / Ngoại lệ ADR-xxxx} |
| Reliability | {Multi-AZ, backup, RPO/RTO theo NFR-xxx, cách diễn tập restore} | INF-30…32 | |
| Performance | {loại instance, autoscaling, load test ở staging} | INF-40…41 | |
| Cost | {ước tính theo môi trường, xem bảng dưới} | INF-50…52 | |
| Operational excellence | {pipeline, drift detection, metrics và alarm gửi SRE} | INF-60…63 | |
| Sustainability | {Graviton, managed service} | INF-70 | |

## Ước tính chi phí

| Môi trường | Hiện tại (USD/tháng) | Sau thay đổi | Chênh lệch | Nguồn |
| --- | --- | --- | --- | --- |
| dev | | | | `{infracost}` |
| staging | | | | |
| prod | | | | |

## Triển khai và rollback

| Môi trường | Thứ tự apply (stack) | Phạm vi ảnh hưởng nếu lỗi | Cách rollback | Người duyệt apply |
| --- | --- | --- | --- | --- |
| dev | {network → db} | {chỉ dev} | {revert PR + apply} | {Tech Lead Infra} |
| staging | | | | |
| prod | | {…} | {…; với thay đổi không đảo ngược được như xoá DB, đổi CIDR: ghi rõ và cần Architect duyệt} | {Tech Lead Infra + …} |
