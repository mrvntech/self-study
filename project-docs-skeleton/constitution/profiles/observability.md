<!-- Profile "observability": phần observability dùng chung toàn hệ thống, thường nằm ở `observability/` trong repo infra (SRE đóng góp, CODEOWNERS SRE). Ghép sau profile infra. Alert và dashboard riêng của từng service KHÔNG nằm ở đây mà ở repo service (profile service, SVC-50…53). -->

## Profile observability

> Đường dẫn: `{infra}:observability/`, `{infra}:k8s/observability/` · Team đóng góp: {SRE} · CODEOWNERS (duyệt bắt buộc): {SRE} · Định nghĩa SLO: `.project/docs/architecture/hld.md` mục 10, `.project/docs/product/nfr.md`

### Phạm vi · *SRE giữ*

- **OBS-01 (MUST)** Ở đây chỉ chứa những gì dùng chung: alert hạ tầng (node, cluster, DB, queue, ingress), dashboard tổng quan SLO và hạ tầng, cấu hình Alertmanager (route, inhibition, receiver), alert mặc định của golden path, meta-monitoring. Alert, recording rule và dashboard riêng của một service nằm ở repo service đó.
- **OBS-02 (MUST)** Stack (Prometheus, Loki, Tempo, Grafana, Alertmanager, agent) triển khai qua `k8s/observability/` theo GitOps; không cài tay.

### Alert · *SRE giữ*

- **OBS-10 (MUST)** Chỉ alert khi cần con người làm ngay (`monitoring-design-hld.md` X.6). Ưu tiên alert theo triệu chứng (SLO burn rate) hơn theo nguyên nhân.
- **OBS-11 (MUST)** Mọi alert có nhãn `team`, `severity` (P1–P4) và `runbook_url`; alert P1/P2 có runbook trong `observability/runbooks/`.
- **OBS-12 (MUST)** Route của Alertmanager định tuyến theo nhãn `team`; tên team đúng theo `team-map.md`. Có alert "Watchdog" gửi tới dead man's switch bên ngoài.
- **OBS-13 (MUST)** CI chạy `promtool check rules`, `promtool test rules` và `amtool check-config`.
- **OBS-14 (SHOULD)** Mỗi {tháng} xoá hoặc sửa alert không dẫn tới hành động nào; ghi lại trong PR.

### Dashboard · *SRE giữ*

- **OBS-20 (MUST)** Dashboard dạng code (`{Grafana JSON / Jsonnet}`) trong `observability/dashboards/`, triển khai bằng provisioning; không tạo hay sửa tay trên prod.
- **OBS-21 (SHOULD)** Dashboard tổng quan hiển thị SLO và error budget còn lại của mọi chức năng Tier 1.

### Golden path cho service · *SRE giữ, Infra duyệt*

- **OBS-30 (MUST)** Golden path chart sinh sẵn `ServiceMonitor`, probe, alert RED mặc định và template recording rule theo burn rate; service chỉ khai báo SLO và thêm phần riêng.
- **OBS-31 (MUST)** Template CI cho repo service có bước kiểm `observability/` (SVC-52), do SRE giữ.

### Log và trace · *SRE giữ, Security duyệt phần che dữ liệu*

- **OBS-40 (MUST)** Pipeline log che email, số điện thoại, token **trước khi** gửi đi; audit log định tuyến sang SIEM.
- **OBS-41 (MUST)** Retention log, metrics, trace theo bảng trong HLD mục 10.
