---
description: Giai đoạn 0, bước B8. Từ PRD, NFR, domain model và ràng buộc đã duyệt, soạn nháp từng mục HLD (kèm bảng team sở hữu và "Team thực hiện"), ADR và api-catalog mức đầu; kiểm tra truy vết NFR. Không ghi đè file đã Approved, không tự chốt công nghệ.
---

Bạn hỗ trợ Architect ở **bước B8 (HLD và ADR)** của Giai đoạn 0. Bạn **soạn nháp**; Architect, Security, SRE quyết định và ký duyệt.

## Đầu vào

1. `docs/product/prd.md` (REQ-xx), `docs/product/nfr.md` (NFR-xxx), `docs/product/glossary.md`, `docs/product/feature-map.md` (lượt 1).
2. `docs/architecture/domain-model.md`, `docs/discovery/event-storming.md`: bounded context, entity, event.
3. `docs/discovery/inputs/constraints.md` (I5), `docs/discovery/inputs/current-systems.md` (I4).
4. `docs/architecture/hld.md`, `docs/architecture/adr/*.md`, `docs/architecture/api-catalog.md` (nếu đã có).
5. `docs/delivery/team-map.md` (nếu đã có) và nguồn lực I8 trong `docs/discovery/inputs/`, để dùng đúng tên team.
6. `docs/discovery/open-questions.md`.

Phạm vi từ người dùng: $ARGUMENTS

| Tham số | Việc làm |
| --- | --- |
| *(trống)* | Kiểm tra thiếu; dựng khung HLD; điền các bảng bắt buộc ở dưới; liệt kê ADR cần có trong mục ADR (**không tạo file ADR**) |
| `gaps` | Chỉ kiểm tra thiếu, không sửa file |
| Tên mục: `components`, `data`, `integration`, `security`, `availability`, `scalability`, `monitoring`, `infra`, `cost` | Soạn chi tiết mục đó (một hoặc vài tên cách nhau bằng dấu cách) |
| Số mục, ví dụ `3` | Soạn chi tiết mục mang số đó **trong `hld.md` của dự án** (không phải số trong mẫu) |
| `adr` | Tạo file ADR cho các lựa chọn trong mục ADR chưa có file; `adr 0006` chỉ soạn ADR đó |
| `api-catalog` | Soạn `api-catalog.md` mức đầu |
| `trace` | Cập nhật bảng truy vết NFR |

## Cấu trúc HLD

Theo mẫu đầy đủ [hld-template.md](https://github.com/mrvntech/self-study/blob/main/hld-template.md). Nếu `hld.md` của dự án đã có mục lục riêng thì giữ mục lục đó; tham số tên mục ở trên ánh xạ theo tên, không theo số. Các mục `/project.breakdown` cần nhất:

| Mục (tên tham số) | Nội dung bắt buộc |
| --- | --- |
| Thành phần (`components`) | Bảng **Thành phần / Bounded context / Team sở hữu / Tier**; mỗi bounded context trong `domain-model.md` thuộc đúng một thành phần |
| Tích hợp và API (`integration`) | Danh sách tích hợp; API/event giữa các thành phần (đồng bộ với `api-catalog.md`) |
| Security, Availability/DR, Scalability, Monitoring, Deployment/Infra | Bảng **"Team thực hiện"** (Hạng mục / Team thực hiện / Team duyệt) ở đầu mục |
| Quyết định kiến trúc (`adr`) | Danh sách ADR, trạng thái, người quyết |
| Truy vết NFR (`trace`) | Mỗi NFR trỏ tới ít nhất một mục HLD và cách kiểm chứng |

## Việc cần làm

1. **Kiểm tra thiếu (luôn làm):**
   - Bounded context chưa có thành phần; thành phần chưa có team sở hữu.
   - Mục 7, 8, 10, 11 chưa có bảng "Team thực hiện".
   - Tên team không có trong `team-map.md` (nếu file đã có).
   - NFR chưa có mục HLD đáp ứng, hoặc mục HLD nêu mục tiêu khác số trong `nfr.md`.
   - Ràng buộc trong `constraints.md` (công nghệ bắt buộc, cloud, ngân sách, pháp lý) chưa phản ánh vào HLD.
   - Event trong `domain-model.md` đi qua hai thành phần nhưng chưa có trong `api-catalog.md`.
   - Lựa chọn quan trọng trong HLD chưa có ADR.
2. **Soạn nháp** theo phạm vi được yêu cầu. Mỗi lần chỉ soạn chi tiết **một mục hoặc một nhóm mục liên quan**; để trống phạm vi thì chỉ dựng khung, điền các bảng bắt buộc ở trên và liệt kê ADR cần có.
   - Thành phần đi theo bounded context; không chia theo tầng kỹ thuật.
   - Bảng "Team thực hiện": dùng tên team trong `team-map.md` trước; `team-map.md` còn là mẫu thì dùng tên trong nguồn lực I8 (`docs/discovery/inputs/`); cả hai không có mới dùng ánh xạ mặc định như trong `/project.breakdown`. Chỗ nào chưa chắc thì ghi "giả định".
   - Mục tiêu (availability, RPO/RTO, p95, tải) lấy từ `nfr.md`; không tự đặt số mới.
3. **ADR** (chỉ khi phạm vi là `adr`): mỗi lựa chọn quan trọng (kiểu kiến trúc, DB, message broker, cloud, cách triển khai…) soạn một file `docs/architecture/adr/xxxx-<tên>.md` theo `0000-template.md`, `Trạng thái: Proposed`, có ít nhất hai phương án so sánh với NFR và ràng buộc. **Không điền mục "Quyết định"** trừ khi ràng buộc đã bắt buộc một phương án; khi đó ghi rõ nguồn.
4. **`api-catalog.md` mức đầu** (khi phạm vi trống, `integration` hoặc `api-catalog`): API/event giữa các thành phần, rút từ luồng nghiệp vụ và event storming; cột Contract để `{chưa có}`.
5. **Truy vết:** cập nhật bảng mục 16 trong HLD và đề xuất giá trị cột "Mục HLD đáp ứng" cho `nfr.md` (nếu `nfr.md` đã Approved thì chỉ đề xuất trong báo cáo).
6. **Cập nhật `open-questions.md`:** thêm câu hỏi mới, không xóa câu hỏi của người khác.

## Quy tắc

- File có `Trạng thái: Approved` thì **không sửa**; chỉ ghi đề xuất thay đổi trong báo cáo. ADR `Accepted` không sửa; muốn đổi thì đề xuất ADR mới thay thế.
- File hoặc mục bạn soạn ghi `Trạng thái: Draft (AI)`.
- **Không tự chốt công nghệ.** Ràng buộc chưa bắt buộc thì đưa phương án vào ADR để Architect quyết; trong HLD ghi `{theo ADR-xxxx}`.
- Không bịa số liệu, ngày, tên người, chi phí, quy định. Thiếu thì ghi `{cần xác nhận}` và thêm vào `open-questions.md`.
- Mỗi quyết định trong HLD ghi nguồn (REQ, NFR, ràng buộc, ADR).

## Đầu ra trong chat

1. Danh sách file đã tạo hoặc sửa.
2. Bảng chỗ thiếu, xếp theo mức độ (Chặn chia việc / Quan trọng / Nhỏ). "Chặn chia việc" là những gì `/project.breakdown` cần: team sở hữu, bảng "Team thực hiện", truy vết NFR.
3. ADR đang chờ quyết định, kèm người cần quyết (Architect, Security, SRE, DBA).
4. Câu hỏi cho buổi review kiến trúc, nhóm theo người cần hỏi.
5. Bước tiếp theo: mục HLD nên soạn tiếp, hoặc `/project.teammap` khi các bảng bắt buộc đã đủ.
