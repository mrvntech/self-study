# Release plan

Trạng thái: Approved (giả lập cho ví dụ) · Cập nhật: 2026-11-02

> Tầng điều phối. Các mốc release, mốc tích hợp giữa các team, và việc thủ công không đi qua Spec Kit. Lệnh `/project.plan` sinh bản nháp cập nhật; con người duyệt.

## Các mốc

| Mốc | Ngày dự kiến | Tính năng | Tiêu chí hoàn thành |
| --- | --- | --- | --- |
| M0 – Foundation | {cần xác nhận} | {theo /project.breakdown} | Môi trường staging chạy được; CI/CD; golden path dùng được; stack monitoring nhận được log, metrics |
| M1 – Tích hợp lần 1 | {cần xác nhận} | {theo /project.breakdown} | Luồng đăng nhập → đặt hàng → thanh toán chạy end-to-end trên staging |
| MVP | 2027-01-25 (hạn chót theo [constraints.md](../discovery/inputs/constraints.md)) | {theo /project.breakdown} | UAT đạt, pentest không còn lỗi High, SLO dashboard sẵn sàng |

## Lịch tích hợp

- Ghép code của các team trên staging: {mỗi sprint / mỗi tuần}.
- Contract API/event phải được duyệt trước mốc tích hợp ít nhất {1 sprint}.
- Test end-to-end chạy tự động sau mỗi lần deploy lên staging.

## Việc thủ công (ngoài Spec Kit)

| Việc | Team | Mốc | Trạng thái |
| --- | --- | --- | --- |
| Pentest | Đơn vị pentest bên ngoài (thuê); Phòng ATTT duyệt kết quả (Q-19) | MVP | Planned |
| UAT với người dùng thật | QA + PO | MVP | Planned |
| Change ticket go-live | Platform | MVP | Planned |
| Đào tạo đội vận hành, bàn giao runbook | Platform (Q-21) | MVP | Planned |
