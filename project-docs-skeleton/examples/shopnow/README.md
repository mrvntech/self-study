# Dự án mẫu ShopNow

Bộ đầu vào đã điền sẵn để chạy thử các lệnh B8–B9 (`/project.hld`, `/project.teammap`, `/project.breakdown`) và xem kết quả.

ShopNow thay website bán hàng cũ bằng nền tảng bán đồ gia dụng online (web, mobile web), MVP ra mắt trước Tết.

## Nội dung

| Thư mục | Nội dung |
| --- | --- |
| [input/](input/) | Trạng thái sau B7: chỉ các file khác mẫu skeleton. Mọi file đều `Approved` |
| [output/](output/) | File do `/project.hld` rồi `/project.teammap` sinh ra hoặc sửa (`Draft (AI)`). Link tương đối trong các file này tính theo cây `docs/` của một dự án |
| [reviewed/](reviewed/) | Sau **review giả lập**: câu trả lời cho các câu hỏi chặn chia việc, HLD, team-map, release-plan đã `Approved`. Đây là đầu vào của `/project.breakdown` |
| [../shopnow-hld.example.md](../shopnow-hld.example.md) | Báo cáo trong chat của `/project.hld` |
| [../shopnow-teammap.example.md](../shopnow-teammap.example.md) | Báo cáo trong chat của `/project.teammap` |
| [../shopnow-breakdown.example.md](../shopnow-breakdown.example.md) | Báo cáo của `/project.breakdown` (lệnh không sửa file) |

## Chuỗi đã chạy

```
input/ (sau B7)
  └─ /project.hld ─► /project.teammap ─► output/      Draft (AI), còn 5 câu hỏi chặn chia việc
       └─ review giả lập (EM, Architect trả lời) ─► reviewed/   Approved
            └─ /project.breakdown ─► báo cáo: 10 contract, 15 feature business, 20 enabler
```

Bước review trong thực tế do con người làm qua PR. Ở ví dụ này, câu trả lời được viết tay vào `open-questions.md` (ghi "giả lập cho ví dụ"), còn việc chép quyết định vào HLD, team-map, release-plan do Claude làm theo một prompt thường, không phải lệnh `/project.*`.

## Lỗ hổng cài sẵn trong đầu vào

| Lỗ hổng | Ở đâu | `/project.hld` | `/project.teammap` |
| --- | --- | --- | --- |
| Context Notification chưa có team | `event-storming.md` (H2) | Chặn chia việc | Chặn chia việc |
| Không có SRE, DBA | `resources.md` (I8) | Chặn chia việc | Chặn chia việc, Platform quá tải |
| Phòng ATTT chỉ 1 người, 30% | `resources.md` | Quan trọng | Thiếu năng lực |
| Team Gamma chỉ làm frontend | `resources.md` | Giả định Gamma nhận frontend | — |
| NFR-002 thiếu tải mục tiêu | `nfr.md` | Quan trọng | — |
| Ngân sách chưa có | `constraints.md` | Quan trọng | — |
| ERP chậm (p95 ~2 s), `order.shipped` đến từ ERP | `current-systems.md`, `event-storming.md` | Quan trọng, ADR-0008 | Ai sở hữu ACL ERP |

Kết quả có thể khác đôi chút giữa các lần chạy (số câu hỏi, số ADR, cách đặt tên thành phần), nhưng các lỗ hổng trên nên được phát hiện mỗi lần.

## Chạy lại

```bash
specify init shopnow && cd shopnow                      # hoặc một thư mục trống
cp -r <self-study>/project-docs-skeleton/. .            # skeleton (kể cả .claude/, .specify/)
rm -rf examples
cp -r <self-study>/project-docs-skeleton/examples/shopnow/input/docs/. docs/
git init && git add -A && git commit -m "ShopNow sau B7"

claude -p "/project.hld"          # hoặc chạy /project.hld trong phiên Claude Code
git diff                          # so với output/
claude -p "/project.teammap"

# Bỏ qua review: dùng luôn các file đã duyệt giả lập
cp -r <self-study>/project-docs-skeleton/examples/shopnow/reviewed/docs/. docs/
claude -p "/project.breakdown"
```
