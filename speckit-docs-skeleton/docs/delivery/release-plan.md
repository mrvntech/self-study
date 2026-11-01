# Release plan

> Tầng điều phối. Các mốc release, mốc tích hợp giữa các team, và việc thủ công không đi qua Spec Kit. Lệnh `/project.plan` sinh bản nháp cập nhật; con người duyệt.

## Các mốc

| Mốc | Ngày dự kiến | Tính năng | Tiêu chí hoàn thành |
| --- | --- | --- | --- |
| M0 – Foundation | {YYYY-MM-DD} | F-000, F-010, F-011 | {Môi trường staging chạy được; CI/CD; health check, log, metrics cơ bản} |
| M1 – Tích hợp lần 1 | {YYYY-MM-DD} | F-001, F-002a, F-002b | {Luồng đăng nhập → đặt hàng → thanh toán chạy end-to-end trên staging} |
| MVP | {YYYY-MM-DD} | {…} | {UAT đạt, pentest không còn lỗi High, SLO dashboard sẵn sàng} |

## Lịch tích hợp

- Ghép code của các team trên staging: {mỗi sprint / mỗi tuần}.
- Contract API/event phải được duyệt trước mốc tích hợp ít nhất {1 sprint}.
- Test end-to-end chạy tự động sau mỗi lần deploy lên staging.

## Việc thủ công (ngoài Spec Kit)

| Việc | Team | Mốc | Trạng thái |
| --- | --- | --- | --- |
| Pentest | {Security / bên ngoài} | MVP | {Planned} |
| UAT với người dùng thật | {QA + PO} | MVP | {Planned} |
| Change ticket go-live | {Platform} | MVP | {Planned} |
| Đào tạo đội vận hành, bàn giao runbook | {SRE} | MVP | {Planned} |

## Sơ đồ thời gian

```mermaid
gantt
    dateFormat YYYY-MM-DD
    title Kế hoạch release (ví dụ)
    section Platform
    F-000 Foundation       :f000, 2026-12-01, 14d
    section SRE / Security
    F-010 Observability    :f010, after f000, 10d
    F-011 Security baseline:f011, after f000, 10d
    section Team Identity
    F-001 Đăng nhập        :f001, after f000, 14d
    section Team Order / Payment
    Chốt contract order.created :milestone, c1, after f001, 0d
    F-002a Thanh toán – đơn hàng :f002a, after f001, 14d
    F-002b Thanh toán – cổng     :f002b, after f001, 14d
    section Tích hợp
    M1 Tích hợp lần 1      :milestone, m1, after f002a, 0d
```
