<!-- Chỉ dùng cho repo Infra. Chèn vào .specify/templates/tasks-template.md, thay cho thứ tự phase mặc định; giữ phần nhãn bắt buộc và phase cuối "Đồng bộ tài liệu tổng thể" từ common. -->

## Thứ tự phase cho tính năng hạ tầng

Test và policy viết trước module (core VI). Mỗi môi trường là một phase riêng, kết thúc bằng một gate do con người làm: AI không apply (core III, INF-62).

1. **Phase 1: Test và policy** — `terraform test` cho module, rule `{checkov}` tuỳ chỉnh nếu luật trong constitution chưa có sẵn rule.
2. **Phase 2: Module** — viết hoặc sửa `modules/<tên>/`, chạy `fmt`, `validate`, `tflint`, `{checkov}`, `terraform test`.
3. **Phase 3: dev** — cấu hình `live/<account>/dev/…`, AI chạy `plan`, đính kèm output, con người apply, kiểm AC.
4. **Phase 4: staging** — như dev, thêm diễn tập failover, restore, load test theo spec.
5. **Phase 5: prod** — chỉ chuẩn bị cấu hình và PR; apply qua pipeline trong khung giờ thay đổi.
6. **Phase cuối: Đồng bộ tài liệu tổng thể** — theo common, thêm cập nhật mục "Tài nguyên hạ tầng" trong `api-catalog.md`.

Task gate dùng nhãn `[Gate: human]` để `/speckit-implement` dừng lại tại đó, không tự làm.

Ví dụ:

```markdown
## Phase 1: Test và policy
- [ ] T001 [Team: Infra] Viết `terraform test` cho module `rds-postgres`: Multi-AZ bật, KMS key bắt buộc, không public (INF-21, INF-22, INF-30)

## Phase 2: Module
- [ ] T002 [Team: Infra] Viết module `modules/rds-postgres/` cho tới khi T001 pass
- [ ] T003 [P] [Team: Infra] Output endpoint, ARN secret; ghi vào SSM `/{project}/{env}/order-db/` (INF-81)

## Phase 3: dev
- [ ] T004 [Team: Infra] Cấu hình `live/workload-dev/dev/order-db/`, chạy `plan`, đính kèm output vào PR
- [ ] T005 [Team: Infra] [Gate: human] Review plan và apply lên dev
- [ ] T006 [Team: Infra] [Provides: rds-order-db] Kiểm AC-04 với IAM role của order-service ở dev

## Phase 4: staging
- [ ] T007 [Team: Infra] Cấu hình staging, chạy `plan`
- [ ] T008 [Team: Infra] [Gate: human] Review plan và apply lên staging
- [ ] T009 [Team: Infra] [Gate: human] Diễn tập failover và restore, ghi kết quả AC-02, AC-03

## Phase 5: prod
- [ ] T010 [Team: Infra] Cấu hình prod, mở PR kèm output `plan` và ước tính chi phí
- [ ] T011 [Team: Infra] [Gate: human] Apply qua pipeline trong khung giờ thay đổi
```
