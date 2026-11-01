# Chia việc cho các team và tạo backlog với Spec Kit

> Ghi chú tự học · Cập nhật: 2026-11-02
> Liên quan: [speckit-big-picture.md](speckit-big-picture.md) · [speckit-vs-sdlc.md](speckit-vs-sdlc.md)
> Hiện thực: [speckit-docs-skeleton/](speckit-docs-skeleton/) (lệnh `/project.breakdown`, `/project.backlog`, script `scripts/backlog-sync.sh`)

## Vấn đề

Spec Kit bắt đầu từ `/speckit.specify` cho **một tính năng**. Nó không có bước nào biến HLD thành **danh sách việc cho từng team** và **backlog** trên công cụ quản lý công việc. Lệnh Spec Kit thực chất là file prompt Markdown, nên ta tự thêm lệnh, chạy **sau HLD và trước `specify`**.

## Quy trình

```mermaid
flowchart TB
    A[HLD + PRD + NFR + team-map đã duyệt] --> B["/project.breakdown<br/>AI đề xuất feature theo team,<br/>enabler, contract, phụ thuộc"]
    B --> C[Con người review qua PR<br/>PO, Architect, Tech Lead]
    C --> D[feature-map.md, dependencies.md,<br/>release-plan.md]
    D --> E["/project.backlog<br/>AI sinh backlog.json"]
    E --> F["scripts/backlog-sync.sh<br/>chạy thử → --apply<br/>(người dùng tự chạy)"]
    F --> G[GitHub Issues: feature, milestone,<br/>nhãn team, blocked by]
    G --> H["Từng team: /speckit.specify → plan → tasks"]
    H --> I["/project.backlog --with-tasks<br/>→ backlog-sync.sh"]
    I --> J[Task thành sub-issue của feature<br/>= sprint backlog]
```

## Hai cấp backlog

| Cấp | Tạo khi nào | Nguồn | Ai quyết định |
| --- | --- | --- | --- |
| Product backlog (feature/epic) | Sau HLD, trước `specify` | `/project.breakdown` → `feature-map.md` | PO ưu tiên, Architect duyệt cách chia |
| Sprint backlog (task) | Sau `/speckit.tasks` của từng feature | `specs/xxx/tasks.md` | Team tự nhận và ước lượng |

## `/project.breakdown`: chia việc từ HLD

**Đầu vào:** PRD, NFR, HLD, domain model, API catalog, team map, release plan.

**Quy tắc chia:**

| Quy tắc | Lý do |
| --- | --- |
| Mỗi REQ thuộc ít nhất một feature | Không bỏ sót yêu cầu |
| Một feature, một team; chia theo lát cắt dọc dựa trên thành phần team sở hữu trong HLD | Tránh feature phải chờ nhiều team |
| Mỗi mục xuyên suốt của HLD (Security, DR, Monitoring, Infra) và mỗi NFR sinh **enabler feature** | Phần hay bị bỏ quên |
| Mỗi API/event giữa hai team là một **contract `C-xx`**, xếp trước feature dùng nó | Các team làm song song được |
| `F-000` foundation đứng đầu | Không chặn team dev |
| Feature lớn hơn khoảng 5–7 user story thì tách | Vừa sức AI, vừa một mốc |
| Không tự đặt ngày | Ngày do con người quyết |

**Đầu ra (chỉ đề xuất):** bảng feature map có cột Loại (Business / Enabler / Contract), Nguồn, Cỡ; việc theo team; phụ thuộc; sơ đồ; truy vết REQ/NFR/HLD chưa có feature; câu hỏi cần con người quyết định.

## `/project.backlog` và `backlog-sync.sh`: đẩy backlog lên GitHub

Tách làm hai bước để có chỗ cho con người duyệt:

1. **AI sinh dữ liệu:** `/project.backlog` đọc `feature-map.md` (và `tasks.md` nếu có `--with-tasks`), ghi `docs/delivery/backlog.json`. AI không gọi API.
2. **Người dùng chạy script:** `scripts/backlog-sync.sh` đọc `backlog.json`, mặc định **chạy thử**; thêm `--apply` mới ghi lên GitHub.

| Trong `backlog.json` | Trên GitHub |
| --- | --- |
| `milestones[]` (M0, M1…) | Milestone (có hạn nếu `due_on`) |
| `items[]` với `type` feature/enabler/contract | Issue có nhãn `type:*`, `team:*`, gắn milestone |
| `items[]` với `type: task` và `parent` | Sub-issue của issue feature |
| `blocked_by[]` | Dòng "Blocked by: #n" trong nội dung issue |
| `source` | Dòng "Nguồn sự thật" trỏ về file trong git |

Đặc điểm của script:

- **Kiểm tra dữ liệu trước:** key trùng, `parent`/`blocked_by`/`milestone` trỏ tới key không tồn tại thì dừng.
- **Idempotent:** issue nhận diện bằng tiền tố `[KEY]` trong tiêu đề; chạy lại chỉ cập nhật.
- **Hai lượt:** lượt 1 tạo/cập nhật issue; lượt 2 ghi nội dung cuối (khi đã biết số issue cho "Blocked by") và gắn sub-issue.
- **Ghi ánh xạ** key → số issue vào `docs/delivery/backlog-issues.json` để cập nhật cột Issue trong feature map.

```bash
git diff docs/delivery/backlog.json        # xem lại dữ liệu AI sinh
scripts/backlog-sync.sh                    # chạy thử
scripts/backlog-sync.sh --apply            # ghi thật
```

Với Jira: giữ nguyên `backlog.json`, viết script tương tự gọi Jira REST API (feature → Epic, milestone → Fix version, `blocked_by` → issue link "is blocked by").

## Nguyên tắc

- **Git giữ nội dung, công cụ quản lý giữ tiến độ.** Mô tả feature nằm ở `feature-map.md` và `spec.md`; issue trỏ ngược về đó và chỉ dùng để giao việc, theo dõi.
- **AI soạn nháp, con người quyết định.** PO quyết ưu tiên, Architect quyết ranh giới, Tech Lead quyết khả năng nhận việc.
- **AI không tự ghi ra hệ thống bên ngoài.** Tạo issue hàng loạt sai rất khó dọn; luôn chạy thử và xem lại trước khi `--apply`.

## Giới hạn

| Giới hạn | Cách xử lý |
| --- | --- |
| AI không biết năng lực thực tế của team | Tech Lead điều chỉnh khi review; team tự ước lượng |
| AI chỉ biết ưu tiên viết trong PRD | PO sắp xếp lại thứ tự |
| HLD sơ sài thì cách chia sơ sài | HLD phải có mục thành phần và team sở hữu, cùng các mục xuyên suốt |
| Sub-issue cần GitHub hỗ trợ tính năng này | Script cảnh báo và bỏ qua nếu không gắn được; quan hệ vẫn ghi trong key `F-xxx/Txxx` |
| Một số bản Spec Kit có sẵn lệnh chuyển task thành issue | Có thể dùng lệnh đó cho task; `backlog-sync.sh` vẫn hữu ích cho cấp feature và milestone |
