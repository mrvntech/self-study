---
description: Giai đoạn 0. Từ các file trong docs/discovery/, soạn nháp story map, PRD, NFR, glossary và feature map lượt 1; liệt kê chỗ thiếu và câu hỏi mở. Không ghi đè file đã Approved.
---

Bạn hỗ trợ Giai đoạn 0 – Discovery (các bước B1–B10: kickoff, mục tiêu, AS-IS, story mapping, PRD/NFR, feature map lượt 1, event storming, HLD, chia việc, cổng Ready for Spec Kit). Lệnh này phục vụ B4–B6. Bạn **soạn nháp**; con người quyết định.

## Đầu vào

1. `docs/discovery/inputs/*.md` (đề bài, stakeholder, hệ thống hiện có, ràng buộc).
2. `docs/discovery/workshops/*.md` (biên bản).
3. `docs/discovery/business-context.md`, `as-is.md`, `story-map.md`, `event-storming.md`, `open-questions.md` (nếu đã có).
4. `docs/product/prd.md`, `nfr.md`, `glossary.md`, `feature-map.md` (nếu đã có).

Phạm vi từ người dùng (ví dụ `story-map`, `prd`, `nfr`, `glossary`, `feature-map`, `gaps`; để trống = tất cả): $ARGUMENTS

## Việc cần làm

1. **Kiểm tra thiếu (luôn làm):**
   - Đầu vào I1–I8 nào chưa có.
   - Mục tiêu không có KPI hoặc không đo được.
   - Persona chưa được xác nhận qua phỏng vấn.
   - Điểm đau mức 4–5 chưa có story.
   - Story chưa thuộc REQ nào; REQ chưa thuộc feature nào.
   - NFR thiếu số đo hoặc cách đo; ràng buộc trong `constraints.md` chưa phản ánh vào NFR.
   - Thuật ngữ dùng lẫn lộn nhiều tên cho một khái niệm.
2. **Soạn nháp** theo phạm vi được yêu cầu, đúng template sẵn có trong `docs/`:
   - `story-map.md`: backbone, story, lát cắt MVP đi trọn hành trình.
   - `prd.md`: REQ-xx có ưu tiên Must/Should/Could, không mô tả công nghệ.
   - `nfr.md`: NFR-xxx có số đo; số nào không có nguồn thì để `{cần xác nhận}`.
   - `glossary.md`: một thuật ngữ, một tên, một nghĩa.
   - `feature-map.md` lượt 1: gom story/REQ thành feature, gắn release; cột Team và Loại ghi `chưa chia`.
3. **Cập nhật `open-questions.md`:** thêm câu hỏi mới, không xóa câu hỏi của người khác.

## Quy tắc

- File có `Trạng thái: Approved` thì **không sửa**; chỉ ghi đề xuất thay đổi trong báo cáo.
- File bạn soạn ghi `Trạng thái: Draft (AI)` ở đầu.
- Mỗi REQ, NFR, story ghi nguồn (file biên bản, đầu vào) trong cột Ghi chú hoặc Nguồn.
- Không bịa số liệu, ngày, tên người, quy định. Thiếu thì ghi `{cần xác nhận}` và thêm vào `open-questions.md`.
- Không đề xuất công nghệ; việc đó thuộc HLD (B8).

## Đầu ra trong chat

1. Danh sách file đã tạo hoặc sửa.
2. Bảng chỗ thiếu, xếp theo mức độ (Chặn MVP / Quan trọng / Nhỏ).
3. Câu hỏi cần hỏi stakeholder ở buổi workshop tiếp theo, nhóm theo người cần hỏi.
4. Bước tiếp theo theo hướng dẫn (B4, B5, B6 hoặc B7). Sau B7, dùng `/project.hld` cho B8.
