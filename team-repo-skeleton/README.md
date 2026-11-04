# Khung repo team dùng Spec Kit

Mỗi team một repo. Tài liệu tổng thể (PRD, HLD, team map, API catalog…) nằm ở repo trung tâm `project-docs` (khởi tạo từ [../project-docs-skeleton/](../project-docs-skeleton/)); repo team kéo về qua git submodule tại `.project/`, pin theo commit.

## Cài đặt (một lần cho mỗi repo)

1. Thêm submodule:

   ```bash
   git submodule add <url-repo-project-docs> .project
   ```

2. Cài Spec Kit: `specify init --here --integration claude`.
3. Copy `.specify/memory/constitution.md` của khung này vào repo, rồi:
   - Dán nội dung `.project/constitution/core.md` vào giữa hai marker, sửa số phiên bản ở marker `core:begin`.
   - Dán phần riêng từ `.project/constitution/team-parts/` (`dev.md` cho team dev, `infra.md` cho team Infra) sau marker `core:end`, điền giá trị và xoá luật không áp dụng.
4. Chèn phần bổ sung vào template trong `.specify/templates/`:
   - Mọi repo: `.project/templates-additions/common/`.
   - Repo Infra: thêm `.project/templates-additions/infra/`.
5. Thêm repo vào cột Repo trong `team-map.md` của `project-docs` (qua PR).

## Quy ước

- Thư mục spec theo mã tính năng: `specs/F-xxx-<tên-ngắn>/`.
- Không commit thay đổi bên trong `.project/` vào repo này. Sửa tài liệu tổng thể bằng nhánh và PR trên chính repo `project-docs` (core constitution mục II).
- Bump `.project/` khi `project-docs` có thay đổi: `git submodule update --remote .project`. Nếu `core.md` đổi, chép lại đoạn core trong cùng PR.
