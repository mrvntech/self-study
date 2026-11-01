---
description: Từ HLD và PRD đã duyệt, đề xuất cách chia việc thành feature/epic theo team (gồm cả enabler cho Platform, SRE, Security, QA), contract giữa các team, phụ thuộc và mốc. Chỉ đề xuất, không sửa file.
---

Bạn đang chia việc ở **mức dự án**, sau khi HLD đã được duyệt và trước khi các team chạy `/speckit.specify`. Không sửa file nào; chỉ đưa ra bản đề xuất để con người review.

## Đầu vào

1. `docs/product/prd.md` (REQ-xx), `docs/product/nfr.md` (NFR-xxx), `docs/product/feature-map.md` (nếu đã có dòng).
2. `docs/architecture/hld.md`, đặc biệt mục thành phần và team sở hữu, Security, DR, Monitoring, Deployment.
3. `docs/architecture/domain-model.md`, `docs/architecture/api-catalog.md`.
4. `docs/delivery/team-map.md`, `docs/delivery/release-plan.md` (nếu đã có mốc).

Phạm vi hoặc ràng buộc bổ sung từ người dùng: $ARGUMENTS

## Quy tắc chia

1. Mỗi REQ trong PRD thuộc ít nhất một feature.
2. **Một feature, một team**, chia theo lát cắt dọc, dựa trên thành phần mà team sở hữu trong HLD. Feature buộc phải trải qua nhiều team thì tách thành F-xxxa, F-xxxb.
3. Mỗi mục xuyên suốt trong HLD (Security, Availability/DR, Monitoring, Deployment/Infra) và mỗi NFR phải có ít nhất một **enabler feature** cho team tương ứng (Platform, SRE, Security, QA…).
4. Mỗi API/event giữa hai team sinh ra một **contract** `C-xx`, xếp trước các feature dùng nó.
5. `F-000` (foundation) đứng đầu; feature khác phụ thuộc vào nó khi cần môi trường, CI/CD hoặc auth.
6. Feature quá lớn (khoảng hơn 5–7 user story) thì tách.
7. Không tự đặt ngày. Chỉ gán mốc đã có trong `release-plan.md`; nếu chưa có mốc thì đề xuất mốc dạng M0, M1… không kèm ngày.
8. Giữ nguyên mã của các feature đã có trong `feature-map.md`; chỉ thêm mã mới.

## Đầu ra (Markdown)

1. **Đề xuất feature map:** bảng theo đúng cột của `docs/product/feature-map.md`, thêm cột **Loại** (Business / Enabler / Contract), **Nguồn** (REQ, NFR hoặc mục HLD) và **Cỡ** (S/M/L). Đánh dấu dòng mới hoặc thay đổi.
2. **Việc theo team:** mỗi team liệt kê các feature được giao.
3. **Phụ thuộc đề xuất:** theo định dạng của `docs/delivery/dependencies.md`.
4. **Sơ đồ phụ thuộc** dạng Mermaid `flowchart LR`.
5. **Truy vết:**
   - REQ chưa có feature.
   - NFR hoặc mục HLD chưa có enabler.
   - Team có quá nhiều hoặc không có việc.
6. **Câu hỏi cần con người quyết định:** ranh giới team, ưu tiên, tách hay gộp feature.

Sau khi con người duyệt và cập nhật các file trong `docs/`, bước tiếp theo là `/project.backlog`.
