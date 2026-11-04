# Khung repo team dùng Spec Kit

Tài liệu tổng thể (PRD, HLD, team map, API catalog…) nằm ở repo trung tâm `project-docs` (khởi tạo từ [../project-docs-skeleton/](../project-docs-skeleton/)); mỗi repo team kéo về qua git submodule tại `.project/`, pin theo commit.

Mỗi repo có **một team giữ** và có thể có **team đóng góp theo đường dẫn** (ví dụ SRE đóng góp `observability/` trong repo infra). Danh sách repo, team giữ, team đóng góp, team duyệt và profile nằm ở bảng "Danh sách repo" trong `.project/docs/delivery/team-map.md`.

## Cài đặt (một lần cho mỗi repo)

1. Thêm submodule:

   ```bash
   git submodule add <url-repo-project-docs> .project
   ```

2. Cài Spec Kit: `specify init --here --integration claude`.
3. Copy `.specify/memory/constitution.md` của khung này vào repo, rồi:
   - Dán nội dung `.project/constitution/core.md` vào giữa hai marker, sửa số phiên bản ở marker `core:begin`.
   - Dán các profile của repo (cột Profile trong "Danh sách repo") từ `.project/constitution/profiles/` sau marker `core:end`, điền giá trị và xoá luật không áp dụng.

   | Repo | Profile |
   | --- | --- |
   | Service backend, frontend | `service.md` |
   | Infra | `infra.md` + `observability.md` + `security-policy.md` |
   | Bộ test dùng chung | `test.md` |

4. Chèn phần bổ sung vào template trong `.specify/templates/`:
   - Mọi repo: `.project/templates-additions/common/`.
   - Repo có profile `infra`: thêm `.project/templates-additions/infra/`.
5. Copy `.github/CODEOWNERS.example` thành `.github/CODEOWNERS`, điền theo cột "Team duyệt" của repo trong "Danh sách repo", bật "Require review from Code Owners" cho nhánh chính.
6. Nếu repo chưa có trong "Danh sách repo", thêm qua PR vào `project-docs`.

## Quy ước

- Thư mục spec theo mã tính năng: `specs/F-xxx-<tên-ngắn>/`, kể cả tính năng của team đóng góp.
- Task chỉ sửa file trong repo này, trong đường dẫn của team ghi ở nhãn `[Team: …]` (core II-b).
- Không commit thay đổi bên trong `.project/` vào repo này. Sửa tài liệu tổng thể bằng nhánh và PR trên chính repo `project-docs` (core II).
- Bump `.project/` khi `project-docs` có thay đổi: `git submodule update --remote .project`. Nếu `core.md` đổi, chép lại đoạn core trong cùng PR.
