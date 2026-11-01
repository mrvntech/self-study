# Ví dụ output của `/project.hld` – dự án ShopNow

> **Kết quả chạy thật** (Claude Code, `claude -p "/project.hld"`, 2026-11-02), không chỉnh sửa. Dùng để biết lệnh `/project.hld` trả về gì với một bộ đầu vào cụ thể.
>
> Liên quan: [../.claude/commands/project.hld.md](../.claude/commands/project.hld.md) · [shopnow/](shopnow/) (đầu vào và file lệnh sinh ra) · [shopnow-teammap.example.md](shopnow-teammap.example.md) (bước tiếp theo)

## Đầu vào

Dự án ShopNow đã xong B7: PRD, NFR, glossary, feature map lượt 1, event storming, domain model, các đầu vào I1, I4, I5, I8 đều `Approved`. `hld.md`, `api-catalog.md`, `team-map.md` vẫn là mẫu của skeleton. Toàn bộ ở [shopnow/input/](shopnow/input/).

Đầu vào có cài sẵn các lỗ hổng để xem lệnh có phát hiện không: xem [shopnow/README.md](shopnow/README.md).

## File lệnh đã sửa

[hld.md](shopnow/output/docs/architecture/hld.md) · [api-catalog.md](shopnow/output/docs/architecture/api-catalog.md) · [open-questions.md](shopnow/output/docs/discovery/open-questions.md). Không tạo file ADR (chỉ liệt kê trong mục 11 của HLD); muốn tạo thì chạy `/project.hld adr`.

---

## Output

Tôi đã dựng khung HLD cho ShopNow và soạn `api-catalog.md` mức đầu. Đây là bản nháp (Draft (AI)) để Architect, Phòng ATTT và Platform duyệt. Chưa tạo file ADR nào và chưa commit.

## 1. File đã tạo hoặc sửa

| File | Thay đổi |
| --- | --- |
| `docs/architecture/hld.md` | Viết lại thành khung HLD, giữ 12 mục lục sẵn có của dự án. Đã điền: mục 1 và 2 (sơ đồ C4 mức 1 và 2, 9 nguyên tắc kiến trúc có ghi nguồn), mục 3 (bảng thành phần, team sở hữu, tier), bảng "Team thực hiện" ở mục 6–10, mục 11 (16 ADR cần có), mục 12 (truy vết NFR). Mục 4 và 5 mới có bảng khung. |
| `docs/architecture/api-catalog.md` | Bỏ các dòng ví dụ, thay bằng 14 API đồng bộ và 7 event lấy từ event storming. Cột Contract để `{chưa có}`. |
| `docs/discovery/open-questions.md` | Thêm Q-03 đến Q-14, giữ nguyên Q-01 và Q-02. |

Tên team lấy theo nguồn lực I8 (Team Alpha, Beta, Gamma, Platform, Phòng ATTT, QA), vì `team-map.md` vẫn còn là mẫu.

## 2. Chỗ thiếu

| Mức | Chỗ thiếu | Câu hỏi |
| --- | --- | --- |
| **Chặn chia việc** | `notification-service` chưa có team sở hữu (điểm nóng H2) | Q-03 |
| **Chặn chia việc** | I8 không có SRE và DBA. Việc SLO, alert, on-call, diễn tập DR, backup DB tạm giao Platform, ghi "giả định" | Q-08 |
| **Chặn chia việc** | Chưa rõ ai làm chuyển đổi dữ liệu F-006 và màn hình CSKH (`cskh-web`, tạm giao Team Gamma). Phần tích hợp ERP chưa có chủ, tùy ADR-0008 | Q-10 |
| **Chặn chia việc** | `team-map.md` còn là mẫu, nên tên team chỉ dựa trên I8 | `/project.teammap` |
| Quan trọng | NFR-002 chưa có số req/s. I4 chỉ có lượt/ngày (cao điểm Tết 40.000), không quy đổi được | Q-01 |
| Quan trọng | API ERP p95 khoảng 2 s, vượt ngưỡng p95 500 ms nếu gọi đồng bộ khi đặt hàng. Chưa rõ ERP có hỗ trợ giữ hàng không, có phát sự kiện xuất kho không | Q-04 |
| Quan trọng | Chưa rõ vị trí data center và có site DR hay không, nên chưa kiểm chứng được RPO 5 phút / RTO 1 giờ | Q-05 |
| Quan trọng | Email/SMS gateway là dịch vụ ngoài: nơi lưu dữ liệu và việc tuân thủ NĐ 13 chưa rõ | Q-06 |
| Quan trọng | Chưa biết ngân hàng đối tác, chưa chọn redirect hay tokenization | Q-07 |
| Quan trọng | Phòng ATTT chỉ có 30% của 1 người cho mọi việc bảo mật | — |
| Quan trọng | Chưa có ngân sách. HLD dự án không có mục chi phí | Q-02 |
| Quan trọng | Có 14 lựa chọn mở chưa có file ADR, ngoài ra còn 2 ADR chỉ cần ghi nhận ràng buộc | — |
| Nhỏ | `product.updated` không có consumer nào trong event storming | — |
| Nhỏ | Tier của Identity và Catalog là giả định | Q-09 |
| Nhỏ | NFR-008 (WCAG) không có mục HLD riêng, chỉ trỏ tới nguyên tắc P8 và `customer-web` | — |
| Nhỏ | Thời gian giữ phiên bản API cũ vẫn để chỗ trống | Q-14 |

Kết quả kiểm tra: cả 5 bounded context đều thuộc đúng một thành phần. Mọi event đi qua hai thành phần đều đã có trong `api-catalog.md`. Các ràng buộc trong I5 đều đã vào HLD, trừ ngân sách.

**Đề xuất sửa file đã Approved** (tôi không sửa các file này):
- `nfr.md`, cột "Mục HLD đáp ứng":
  - NFR-001 → 3, 7, 9
  - NFR-002 → 8, 5
  - NFR-003 → 6
  - NFR-004 → 6, 4, 10
  - NFR-005 → 9, 10
  - NFR-006 → 7, 4
  - NFR-007 → 6, 10, 4, 5
  - NFR-008 → 2, 3
- `domain-model.md`, cột "Service sở hữu": điền theo HLD mục 3 (`identity-service`, `catalog-service`, `sales-service`, `payment-service`, `notification-service`).

## 3. ADR đang chờ quyết định

| ADR | Nội dung | Người quyết |
| --- | --- | --- |
| 0001 | Kiểu kiến trúc: microservice hay modular monolith | Architect |
| 0002 | Chạy trên K8s nội bộ: đã bị ràng buộc bởi I5, chỉ cần ghi nhận | Architect |
| 0003 | Cơ sở dữ liệu và cách chia sở hữu DB | Architect, DBA (chưa có người) |
| 0004 | Message broker, cách giữ nhất quán Order–Payment | Architect |
| 0005 | IdP cho khách hàng | Architect, Phòng ATTT |
| 0006 | SSO Keycloak cho nhân viên: đã bị ràng buộc bởi I5 | Phòng ATTT |
| 0007 | Cổng thanh toán: redirect hay tokenization | Phòng ATTT, Architect |
| 0008 | Tích hợp ERP và giữ tồn kho | Architect, Phòng IT |
| 0009 | Tìm kiếm sản phẩm | Architect |
| 0010 | Frontend, API gateway hoặc BFF | Architect |
| 0011 | Stack theo team (Java, Node.js) | Architect |
| 0012 | Stack observability | Platform, SRE (chưa có người) |
| 0013 | Chiến lược DR | Architect, Platform, SRE (chưa có người) |
| 0014 | Mã hóa dữ liệu và quản lý secret | Phòng ATTT |
| 0015 | Cách chuyển đổi dữ liệu | Architect, PO |
| 0016 | CI/CD | Platform, Architect |

## 4. Câu hỏi cho buổi review kiến trúc

- **Engineering Manager:** team nào nhận Notification (Q-03), F-006 và `cskh-web` (Q-10)? Ai trực on-call và làm việc DBA trước khi tuyển SRE (Q-08)? Team Alpha và Team Beta mỗi team đã ôm 2 thành phần, có quá tải không?
- **Phòng IT:** ERP có giữ hàng được không, có phát sự kiện xuất kho không (Q-04)? Data center đặt ở đâu, có site DR không (Q-05)?
- **Phòng ATTT:** ngân hàng đối tác và kiểu tích hợp thanh toán (Q-07)? Đăng nhập bằng số điện thoại dùng OTP hay mật khẩu (Q-11)? Năng lực 30% có đủ cho pentest trước 2027-01-25 không?
- **Pháp chế và Marketing:** Email/SMS gateway lưu dữ liệu ở đâu, đã có hợp đồng xử lý dữ liệu chưa (Q-06)? Thời hạn lưu dữ liệu cá nhân (Q-13)?
- **PO:** số req/s cao điểm (Q-01)? Tier của Identity và Catalog (Q-09)? Quy tắc khử trùng bản ghi khách hàng (Q-12)?
- **Architect:** chốt ADR-0001 và ADR-0008 trước, vì hai quyết định này ảnh hưởng nhiều mục khác. Thời gian giữ phiên bản API cũ (Q-14)?

## 5. Bước tiếp theo

1. Trả lời các câu hỏi Q-03, Q-08, Q-10, rồi chạy `/project.teammap` để chốt tên team và bỏ các ghi chú "giả định".
2. Chạy `/project.hld adr` để tạo file cho các ADR (nên làm 0001, 0004, 0008 trước).
3. Soạn chi tiết từng mục, ưu tiên `/project.hld integration`, rồi `availability`, `security`.
