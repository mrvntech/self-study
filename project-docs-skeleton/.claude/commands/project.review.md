---
description: Kiểm tra chéo mọi spec và plan với tài liệu tổng thể (PRD, NFR, glossary, HLD, domain model, API catalog). Chỉ đọc, không sửa file.
---

Bạn đang review tính nhất quán **giữa các tính năng** của dự án. Không sửa bất kỳ file nào; chỉ báo cáo.

## Đầu vào

1. Tài liệu tổng thể:
   - `docs/product/prd.md`, `docs/product/feature-map.md`, `docs/product/nfr.md`, `docs/product/glossary.md`
   - `docs/architecture/hld.md`, `docs/architecture/domain-model.md`, `docs/architecture/api-catalog.md`, `docs/architecture/adr/*.md`
2. Mọi tính năng: `workspace/*/specs/*/spec.md`, `plan.md`, `data-model.md`, `contracts/`, `tasks.md` (file nào chưa có thì bỏ qua). Spec của mọi team nằm trong các repo team; đọc qua bản checkout trong `workspace/<repo>/` do `scripts/workspace-sync.sh` tạo (người dùng tự chạy trước; nếu `workspace/` trống hoặc thiếu repo có trong bảng "Danh sách repo" của `team-map.md` thì dừng và nhắc chạy script). Ghi đường dẫn dạng `<repo>:specs/…`.
3. `docs/delivery/team-map.md` (bảng "Danh sách repo"), và trong mỗi repo: `workspace/<repo>/.specify/memory/constitution.md`, commit submodule `.project` (`git -C workspace/<repo> ls-tree HEAD .project`).

Phạm vi bổ sung từ người dùng (nếu có): $ARGUMENTS

## Kiểm tra

1. **Truy vết yêu cầu**
   - REQ trong PRD chưa có tính năng nào nhận.
   - Spec thiếu mục "Liên kết tổng thể", hoặc dùng mã F-xxx / REQ-xx / NFR-xxx không tồn tại.
   - Tính năng trong `workspace/*/specs/` không có dòng trong feature map, hoặc ngược lại; cột Spec trong feature map trỏ sai repo.
2. **NFR**
   - NFR chưa có tính năng nào hiện thực, hoặc chưa có mục HLD đáp ứng.
   - Plan áp dụng NFR nhưng không nói cách đáp ứng.
3. **Domain model**
   - Entity xuất hiện ở nhiều `data-model.md` với định nghĩa khác nhau.
   - Entity có trong spec/plan nhưng không có trong `domain-model.md`.
   - Hai service cùng ghi dữ liệu vào một entity.
4. **API và event**
   - API/event trùng chức năng giữa các tính năng.
   - Contract trong `workspace/*/specs/*/contracts/` chưa có trong `api-catalog.md` (mục API, Event hoặc Tài nguyên hạ tầng).
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
8. **Repo và team** (core constitution II-b, II-c)
   - Tính năng nằm ở repo mà team sở hữu tính năng không giữ và không được ghi là team đóng góp.
   - Mục "Đường dẫn sẽ sửa" trong `plan.md` có đường dẫn ngoài phần của team ghi ở `[Team: …]`, hoặc trỏ ra ngoài repo.
   - Task mô tả việc ở repo khác thay vì dùng `[Needs: …]`.
   - Đoạn core trong constitution của repo khác `constitution/core.md` hiện tại (so phiên bản ở marker `core:begin`); submodule `.project` của repo cũ hơn nhánh chính của `project-docs`.
   - Profile trong constitution của repo khác cột Profile của repo đó trong "Danh sách repo".

## Đầu ra

Một báo cáo Markdown:

1. **Tóm tắt:** số vấn đề theo mức độ (Critical / High / Medium / Low).
2. **Bảng vấn đề:** Mã | Mức độ | Loại (1–8) | Vị trí (`repo:file:dòng`) | Mô tả | Đề xuất xử lý.
3. **Bảng truy vết:** REQ → F-xxx → spec; NFR → mục HLD → F-xxx.
4. **Việc cần con người quyết định** (ví dụ ADR cần duyệt).

Chỉ báo cáo vấn đề có bằng chứng trong file; ghi rõ đường dẫn. Không suy đoán.
