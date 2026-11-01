---
description: Giai đoạn 0, đầu bước B9. Từ HLD và thông tin nguồn lực (I8), soạn nháp team-map.md: thành phần mỗi team sở hữu, ranh giới việc xuyên suốt, vai trò, RACI; báo thành phần chưa có team và team thiếu người hoặc kỹ năng. Không ghi đè file đã Approved.
---

Bạn hỗ trợ PM/Delivery và Architect ở **đầu bước B9**, trước khi chạy `/project.breakdown`. Bạn **soạn nháp** `docs/delivery/team-map.md`; con người quyết định ai làm gì.

## Đầu vào

1. `docs/architecture/hld.md`: bảng thành phần và team sở hữu (mục 4), bảng "Team thực hiện" (mục 7, 8, 10, 11).
2. `docs/architecture/domain-model.md`, `docs/architecture/api-catalog.md`.
3. Nguồn lực (I8): `docs/discovery/inputs/*.md` (thường là `stakeholders.md` hoặc file nguồn lực riêng), biên bản trong `docs/discovery/workshops/`.
4. `docs/delivery/team-map.md` hiện có (giữ cấu trúc và tên team đã dùng).
5. `docs/product/feature-map.md` (lượt 1), `docs/delivery/release-plan.md` (nếu có).

Phạm vi hoặc ràng buộc từ người dùng (ví dụ số team tối đa, team cố định không đổi, `gaps` để chỉ kiểm tra): $ARGUMENTS

## Việc cần làm

1. **Kiểm tra thiếu (luôn làm):**
   - Thành phần trong HLD chưa có team sở hữu, hoặc có nhiều team sở hữu.
   - Tên team trong HLD không khớp nhau giữa các mục, hoặc không có trong I8.
   - Hạng mục trong bảng "Team thực hiện" chưa có team, hoặc thiếu team duyệt.
   - Team trong I8 không sở hữu thành phần nào.
   - Team sở hữu quá nhiều thành phần Tier 1, hoặc thiếu kỹ năng cho thành phần được giao (theo I8).
   - Team chuyên trách (Infra, SRE, Security, DBA, QA) không có trong I8 nhưng HLD cần.
2. **Soạn nháp `team-map.md`** theo đúng các mục của template:
   - **Danh sách team:** thành phần sở hữu ghi **cụ thể** (tên service, lớp hạ tầng L0–L6, công cụ), không ghi chung "hạ tầng", "backend". Tech Lead và kênh liên lạc lấy từ I8, thiếu thì `{cần xác nhận}`. Cột "Tính năng đang làm" để `—` (chưa chia việc).
   - **Ranh giới trách nhiệm việc xuyên suốt:** gộp từ các bảng "Team thực hiện" trong HLD; mỗi việc một team thực hiện, có team duyệt. Hai mục HLD ghi khác nhau cho cùng một việc thì nêu xung đột, không tự chọn.
   - **Vai trò dùng chung** và **RACI theo loại việc:** điền theo I8; không tự gán người.
3. **Cập nhật `open-questions.md`:** thêm câu hỏi mới, không xóa câu hỏi của người khác.

## Quy tắc

- File có `Trạng thái: Approved` thì **không sửa**; chỉ ghi đề xuất thay đổi trong báo cáo.
- File bạn soạn ghi `Trạng thái: Draft (AI)` ở đầu.
- Ranh giới team đi theo ranh giới thành phần trong HLD (bounded context). Không chia team theo tầng kỹ thuật (frontend/backend/database) trừ khi I8 bắt buộc; khi đó nêu rủi ro phụ thuộc.
- **Không tự lập team mới, không gán người, không đánh giá năng lực cá nhân.** Thiếu team thì đề xuất trong báo cáo để Engineering Manager quyết.
- Nếu `team-map.md` khác HLD, không sửa HLD; nêu chỗ lệch để Architect quyết bên nào đúng.

## Đầu ra trong chat

1. Danh sách file đã tạo hoặc sửa.
2. Bảng chỗ thiếu, xếp theo mức độ (Chặn chia việc / Quan trọng / Nhỏ).
3. Bảng tải theo team: số thành phần, số thành phần Tier 1, số hạng mục xuyên suốt; đánh dấu team quá tải hoặc không có việc.
4. Xung đột ranh giới cần quyết, kèm người cần quyết (Architect, Engineering Manager, PM).
5. Bước tiếp theo: `/project.breakdown` khi không còn mục "Chặn chia việc".
