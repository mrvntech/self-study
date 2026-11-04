---
description: Sinh docs/delivery/backlog.json từ feature map đã duyệt (và tùy chọn từ tasks.md của các feature), để script scripts/backlog-sync.sh đồng bộ lên GitHub Issues. Không tự tạo issue.
---

Bạn chuẩn bị **dữ liệu backlog** để đồng bộ lên GitHub Issues. Bạn chỉ ghi file `docs/delivery/backlog.json`. **Không** gọi `gh`, GitHub MCP hay API nào để tạo, sửa issue, và **không** chạy `scripts/backlog-sync.sh --apply`.

## Đầu vào

1. `docs/product/feature-map.md`: feature, team, phụ thuộc, mốc, cột Issue.
2. `docs/delivery/release-plan.md`: mốc và ngày (nếu có).
3. `docs/delivery/dependencies.md`, `docs/delivery/team-map.md`.
4. Nếu `$ARGUMENTS` có `--with-tasks`: mọi `workspace/*/specs/*/tasks.md`. Đọc mã task, nhãn `[Team: …]`, `[Needs: …]`, `[Provides: …]`; bỏ qua task đã tick. Spec của mọi team nằm trong các repo team; đọc qua bản checkout trong `workspace/<repo>/` do `scripts/workspace-sync.sh` tạo (người dùng tự chạy trước; nếu `workspace/` trống hoặc thiếu repo có trong bảng "Danh sách repo" của `team-map.md` thì dừng và nhắc chạy script). Ghi đường dẫn dạng `<repo>:specs/…`.
5. `docs/delivery/backlog.json` hiện có (nếu có), để giữ nguyên key và thứ tự.

Tham số: $ARGUMENTS

## Định dạng `backlog.json`

Theo đúng mẫu trong `docs/delivery/backlog.example.json`:

- `milestones[]`: `key` (M0…), `title`, `due_on` (YYYY-MM-DD, chỉ khi có trong release-plan), `description`.
- `labels[]` (tùy chọn): nhãn cần màu hoặc mô tả riêng. Script tự tạo `type:*` và `team:*`.
- `items[]`:
  - `key`: `F-xxx`, `C-xx`, hoặc `F-xxx/Txxx` cho task.
  - `type`: `feature` | `enabler` | `contract` | `task`.
  - `title`: tiêu đề ngắn, không chứa key (script tự thêm `[key]`).
  - `team`: tên viết thường, không dấu cách (ví dụ `order`, `infra`).
  - `milestone`: key của milestone, hoặc `null`.
  - `parent`: key của feature cha (cho task), hoặc `null`.
  - `blocked_by[]`: key của item phải xong trước.
  - `repo`: repo chứa issue. Feature, enabler, contract để trống (issue nằm ở `project-docs`). Task ghi tên repo chứa `tasks.md` (tên thư mục trong `workspace/`, đúng tên trong "Danh sách repo").
  - `source`: đường dẫn nguồn sự thật (ví dụ `order-service:specs/F-002a-checkout/tasks.md#T012` hoặc `docs/product/feature-map.md#F-002a`).
  - `labels[]` (tùy chọn), `body`: mô tả ngắn, có acceptance criteria hoặc tiêu chí hoàn thành nếu có trong nguồn.

## Quy tắc

- Item phụ thuộc phải đứng **sau** item mà nó phụ thuộc.
- Mọi `parent`, `blocked_by`, `milestone` phải trỏ tới key có trong file.
- Không tự đặt ngày, team hay phụ thuộc không có trong nguồn.
- Feature đã `Done` trong feature map thì không đưa vào.
- Task của một tính năng nằm cùng repo với `specs/` của tính năng đó; issue cha (feature) nằm ở `project-docs`, script gắn task làm sub-issue xuyên repo.

## Sau khi ghi file

Báo cho người dùng:

1. Số item theo loại và theo team; item mới so với lần trước.
2. Các bước tiếp theo **do người dùng tự chạy**:

```bash
git diff docs/delivery/backlog.json                # xem lại
scripts/backlog-sync.sh                            # chạy thử, không tạo gì
scripts/backlog-sync.sh --apply                    # tạo/cập nhật issue thật
```

3. Sau khi chạy `--apply`, cập nhật cột Issue trong `feature-map.md` theo `docs/delivery/backlog-issues.json` (giá trị dạng `owner/repo#số`).
