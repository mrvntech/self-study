<!-- Profile "observability": phần observability trong repo infra (`observability/`, `k8s/observability/`). Ghép sau profile infra. Alert và dashboard riêng của từng service KHÔNG nằm ở đây mà ở repo service (profile service, SVC-50…53). Nguyên tắc: team sở hữu thành phần viết alert của thành phần đó, SRE duyệt; SRE viết phần dùng chung. -->

## Profile observability

> Đường dẫn: `{infra}:observability/`, `{infra}:k8s/observability/` · Infra viết: `observability/alerts/`, `dashboards/infra/`, `runbooks/`, `k8s/observability/` · SRE đóng góp: `observability/alertmanager/`, `dashboards/overview/`, `golden-path/` · CODEOWNERS (duyệt bắt buộc): {SRE} · Định nghĩa SLO: `.project/docs/architecture/hld.md` mục 10, `.project/docs/product/nfr.md`

### Phạm vi · *SRE giữ*

- **OBS-01 (MUST)** Ở đây chỉ chứa: alert, dashboard, runbook của **thành phần hạ tầng** (node, cluster, DB, queue, ingress); cấu hình Alertmanager; dashboard tổng quan SLO; template alert và recording rule của golden path; meta-monitoring. Alert, recording rule và dashboard riêng của một service nằm ở repo service đó.

### Chuẩn alert · *SRE giữ* · áp cho mọi alert, kể cả ở repo service

- **OBS-10 (MUST)** Chỉ alert khi cần con người làm ngay (`monitoring-design-hld.md` X.6). Ưu tiên alert theo triệu chứng (SLO burn rate) hơn theo nguyên nhân.
- **OBS-11 (MUST)** Mọi alert có nhãn `team`, `severity` (P1–P4) và `runbook_url`; alert P1/P2 có runbook.
- **OBS-13 (MUST)** CI chạy `promtool check rules`, `promtool test rules` và `amtool check-config`.
- **OBS-14 (SHOULD)** Mỗi {tháng} xoá hoặc sửa alert không dẫn tới hành động nào; ghi lại trong PR.

### Stack monitoring · *Infra giữ, SRE duyệt*

- **OBS-02 (MUST)** Stack (Prometheus, Loki, Tempo, Grafana, Alertmanager, agent) triển khai qua `k8s/observability/` theo GitOps; không cài tay.
- **OBS-03 (MUST)** Stack có HA, retention và giới hạn series, dung lượng log theo HLD mục 10; chi phí của stack nằm trong ước tính chi phí của plan (INF-50).

### Alert và dashboard của thành phần hạ tầng · *Infra giữ, SRE duyệt*

- **OBS-15 (MUST)** Thành phần hạ tầng mới (cluster, node pool, DB, queue, ingress) có alert, dashboard trong `dashboards/infra/` và runbook trong cùng tính năng tạo ra nó (INF-63); nhãn `team` là {Infra} và route về on-call hạ tầng.
- **OBS-16 (SHOULD)** Dùng exporter và mixin có sẵn của cộng đồng (kube-prometheus, postgres-exporter) làm nền, chỉnh ngưỡng theo NFR thay vì viết lại.

### Alertmanager · *SRE giữ*

- **OBS-12 (MUST)** Route định tuyến theo nhãn `team`; tên team đúng theo `team-map.md`. Có alert "Watchdog" gửi tới dead man's switch bên ngoài.

### Dashboard · *SRE giữ*

- **OBS-20 (MUST)** Dashboard dạng code (`{Grafana JSON / Jsonnet}`), triển khai bằng provisioning; không tạo hay sửa tay trên prod.
- **OBS-21 (SHOULD)** Dashboard tổng quan (`dashboards/overview/`) hiển thị SLO và error budget còn lại của mọi chức năng Tier 1.

### Golden path cho service · *SRE giữ, Infra duyệt*

- **OBS-30 (MUST)** Template trong `observability/golden-path/` (alert RED mặc định, recording rule theo burn rate) được golden path chart nhúng vào mọi service; service chỉ khai báo SLO và thêm phần riêng.
- **OBS-31 (MUST)** Template CI cho repo service có bước kiểm `observability/` (SVC-52), do SRE giữ.

### Log và trace · *Infra giữ pipeline, Security duyệt phần che dữ liệu*

- **OBS-40 (MUST)** Pipeline log che email, số điện thoại, token **trước khi** gửi đi; audit log định tuyến sang SIEM.
- **OBS-41 (MUST)** Retention log, metrics, trace theo bảng trong HLD mục 10.
