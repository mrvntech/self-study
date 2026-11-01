---
description: Kiểm tra chéo mọi spec và plan với tài liệu tổng thể (PRD, NFR, glossary, HLD, domain model, API catalog). Chỉ đọc, không sửa file.
---

Bạn đang review tính nhất quán **giữa các tính năng** của dự án. Không sửa bất kỳ file nào; chỉ báo cáo.

## Đầu vào

1. Tài liệu tổng thể:
   - `docs/product/prd.md`, `docs/product/feature-map.md`, `docs/product/nfr.md`, `docs/product/glossary.md`
   - `docs/architecture/hld.md`, `docs/architecture/domain-model.md`, `docs/architecture/api-catalog.md`, `docs/architecture/adr/*.md`
2. Mọi tính năng: `specs/*/spec.md`, `specs/*/plan.md`, `specs/*/data-model.md`, `specs/*/contracts/`, `specs/*/tasks.md` (file nào chưa có thì bỏ qua).

Phạm vi bổ sung từ người dùng (nếu có): $ARGUMENTS

## Kiểm tra

1. **Truy vết yêu cầu**
   - REQ trong PRD chưa có tính năng nào nhận.
   - Spec thiếu mục "Liên kết tổng thể", hoặc dùng mã F-xxx / REQ-xx / NFR-xxx không tồn tại.
   - Tính năng trong `specs/` không có dòng trong feature map, hoặc ngược lại.
2. **NFR**
   - NFR chưa có tính năng nào hiện thực, hoặc chưa có mục HLD đáp ứng.
   - Plan áp dụng NFR nhưng không nói cách đáp ứng.
3. **Domain model**
   - Entity xuất hiện ở nhiều `data-model.md` với định nghĩa khác nhau.
   - Entity có trong spec/plan nhưng không có trong `domain-model.md`.
   - Hai service cùng ghi dữ liệu vào một entity.
4. **API và event**
   - API/event trùng chức năng giữa các tính năng.
   - Contract trong `specs/*/contracts/` chưa có trong `api-catalog.md`.
   - Tính năng dùng API/event của tính năng khác chưa được khai báo.
5. **Thuật ngữ**
   - Từ trong cột "Không dùng" của glossary xuất hiện trong spec/plan.
   - Thuật ngữ nghiệp vụ mới chưa có trong glossary.
6. **Kiến trúc**
   - Plan đi ngược HLD hoặc ADR `Accepted` mà không có ADR mới.
   - Tính năng `Done` nhưng phase "Đồng bộ tài liệu tổng thể" trong `tasks.md` chưa tick hết.
7. **Phụ thuộc**
   - Tính năng đang làm phụ thuộc tính năng chưa `Done` và chưa có contract được duyệt.
   - Phụ thuộc vòng.

## Đầu ra

Một báo cáo Markdown:

1. **Tóm tắt:** số vấn đề theo mức độ (Critical / High / Medium / Low).
2. **Bảng vấn đề:** Mã | Mức độ | Loại (1–7) | Vị trí (file:dòng) | Mô tả | Đề xuất xử lý.
3. **Bảng truy vết:** REQ → F-xxx → spec; NFR → mục HLD → F-xxx.
4. **Việc cần con người quyết định** (ví dụ ADR cần duyệt).

Chỉ báo cáo vấn đề có bằng chứng trong file; ghi rõ đường dẫn. Không suy đoán.
