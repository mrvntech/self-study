# Ví dụ output của `/project.teammap` – dự án ShopNow

> **Kết quả chạy thật** (Claude Code, `claude -p "/project.teammap"`, 2026-11-02), chạy ngay sau [`/project.hld`](shopnow-hld.example.md), không chỉnh sửa.
>
> Liên quan: [../.claude/commands/project.teammap.md](../.claude/commands/project.teammap.md) · [shopnow/](shopnow/) · bước tiếp theo: [shopnow-breakdown.example.md](shopnow-breakdown.example.md)

## Đầu vào

- Đầu vào của ShopNow sau B7: [shopnow/input/](shopnow/input/). Nguồn lực I8 ([resources.md](shopnow/input/docs/discovery/inputs/resources.md)): Team Alpha (4 dev Java), Team Beta (3 dev Node.js), Team Gamma (3 dev frontend), Platform (2 DevOps), Phòng ATTT (1 người, 30%), QA (2 tester); **không có SRE, DBA**.
- HLD do `/project.hld` soạn: [hld.md](shopnow/output/docs/architecture/hld.md).
- `team-map.md` còn là mẫu của skeleton.

## File lệnh đã sửa

[team-map.md](shopnow/output/docs/delivery/team-map.md) · [open-questions.md](shopnow/output/docs/discovery/open-questions.md) (thêm Q-15 đến Q-23).

---

## Output

Tôi đã soạn nháp `team-map.md` và thêm câu hỏi mới vào `open-questions.md`. Hiện còn **5 mục chặn chia việc**, nên **chưa chạy được `/project.breakdown`**.

## 1. File đã tạo hoặc sửa

| File | Thay đổi |
| --- | --- |
| `docs/delivery/team-map.md` | Viết lại từ mẫu (file chưa có `Approved`), ghi `Trạng thái: Draft (AI)`. Dùng đúng 6 tên team trong I8, có 32 hạng mục việc xuyên suốt (X-01…X-32) và bảng RACI. |
| `docs/discovery/open-questions.md` | Thêm Q-15 đến Q-23. Không sửa hay xóa câu hỏi cũ. |

Tôi không sửa HLD và `domain-model.md`. `domain-model.md` đã `Approved` nhưng cột "Service sở hữu" vẫn là `{chưa đặt}`. Đề xuất: sau khi Architect chốt HLD mục 3, điền cột này theo HLD.

## 2. Chỗ thiếu

| Mức | Chỗ thiếu | Câu hỏi |
| --- | --- | --- |
| **Chặn chia việc** | `notification-service` chưa có team sở hữu. HLD mục 9 ghi "team Notification", nhưng I8 không có team này. | Q-03 |
| **Chặn chia việc** | `ERP integration (ACL)`: team sở hữu tùy ADR-0008 (tách riêng hay nằm trong từng service). | Q-15 |
| **Chặn chia việc** | `data-migration` có hai team cùng sở hữu (Beta làm Customer, Alpha làm Order, hai ngôn ngữ khác nhau), trái nguyên tắc P1. | Q-10 |
| **Chặn chia việc** | Nhất quán Order–Payment (X-13): HLD giao cùng lúc cho Alpha và Beta. | Q-18 |
| **Chặn chia việc** | Platform (2 người) đang gánh luôn việc của SRE và DBA theo giả định của HLD. | Q-23, Q-08 |
| Quan trọng | On-call 24/7 cho Tier 1 chưa có ai nhận. | Q-08 |
| Quan trọng | API gateway/BFF giao Platform, nhưng theo I8 Platform không có kỹ năng viết code ứng dụng. | Q-16 |
| Quan trọng | Phòng ATTT chỉ có 1 người dành 30% thời gian, nhưng phải duyệt 10 hạng mục và làm pentest trước MVP. | Q-19 |
| Quan trọng | Load test giao QA, nhưng I8 chỉ ghi QA biết test thủ công và Playwright. | Q-20 |
| Nhỏ | CDN/cache tĩnh: HLD ghi hai team thực hiện. | Q-17 |
| Nhỏ | Việc đào tạo đội vận hành và bàn giao runbook giao cho SRE, nhưng chưa có SRE. | Q-21 |
| Nhỏ | Thiếu tên Architect, PO, PM, EM và kênh liên lạc của các team. | Q-22 |
| Nhỏ | Phần chung "Nền tảng dùng chung" ở HLD mục 3 ghi quá chung chung. Trong team-map tôi đã tách thành các lớp L0–L6 cụ thể. | — |

## 3. Tải theo team

| Team | Số thành phần | Số thành phần Tier 1 | Số hạng mục xuyên suốt (thực hiện) | Đánh giá |
| --- | --- | --- | --- | --- |
| Team Alpha (4 người) | 3–4 (có thêm ACL nếu tách riêng) | 1–2 | 2, cộng X-13 đang xung đột, cộng 3 việc team nào cũng làm | ⚠ Nặng nếu nhận thêm ACL |
| Team Beta (3 người) | 2, cộng một phần migration | 2 (identity Tier 1 là giả định) | 2, cộng X-13, cộng 3 việc team nào cũng làm | ⚠ 2 thành phần Tier 1 với 3 người |
| Team Gamma (3 người) | 2 | 1 | 1, cộng X-17 đang xung đột | Ổn |
| Platform (2 người) | API gateway, cộng nền tảng L0–L6 | 1 | 16 (17 nếu nhận thêm CDN) | 🔴 **Quá tải** |
| Phòng ATTT (1 người, 30%) | 0 (đúng vai trò) | 0 | 3 thực hiện, 10 duyệt | 🔴 **Thiếu năng lực** |
| QA (2 người) | 0 (đúng vai trò) | 0 | 3 | ⚠ Thiếu kỹ năng load test |

Không team nào trong I8 bị bỏ không việc.

## 4. Xung đột ranh giới cần quyết

| Xung đột | Người quyết |
| --- | --- |
| Ai sở hữu notification-service: Gamma chỉ làm frontend; Alpha có kinh nghiệm Kafka nhưng đã nhiều việc; Beta mới 3 người mà đã có 2 thành phần Tier 1 | Engineering Manager (Q-03) |
| Ai sở hữu ACL ERP, kéo theo việc chốt ADR-0008 | Architect, sau đó Engineering Manager (Q-15) |
| data-migration giao một team hay giữ chia đôi | Engineering Manager, PO (Q-10) |
| Outbox/saga Order–Payment: ai sở hữu phần dùng chung | Architect (Q-18) |
| SLO/alert/runbook: HLD mục 9 giao Platform thực hiện, team service duyệt; mẫu RACI lại giao team service làm R, SRE làm A. Hiện để ⚠ trong RACI. | Architect |
| CDN/cache tĩnh: Platform hay Gamma thực hiện | Architect (Q-17) |
| BFF có code ứng dụng thì team nào viết | Architect, Engineering Manager (Q-16) |
| Tải của Platform và Phòng ATTT: chấp nhận như hiện tại, bổ sung người, hay thuê pentest bên ngoài | Engineering Manager (Q-19, Q-23) |

HLD cũng cần Architect sửa sau khi các câu hỏi trên có kết quả: bỏ "team Notification" ở mục 9, và dùng một tên team sở hữu cho ACL và data-migration ở mục 3.

## 5. Bước tiếp theo

Chạy `/project.breakdown` sau khi đã giải quyết 5 mục chặn: Q-03, Q-15, Q-10, Q-18, Q-23 (gồm cả Q-08). Sau đó cập nhật `team-map.md`, hoặc chạy lại `/project.teammap`, rồi Engineering Manager duyệt và chuyển trạng thái sang `Approved`.
