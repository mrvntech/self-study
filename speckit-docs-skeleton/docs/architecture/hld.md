# HLD – {Tên hệ thống}

> Tầng 2 – Hệ thống. AI đọc file này trước mỗi lần `/speckit.plan`. Plan nào cần đi ngược HLD phải đề xuất ADR mới.
>
> Dùng mẫu đầy đủ: [hld-template.md](https://github.com/mrvntech/self-study/blob/main/hld-template.md). Mục monitoring dùng: [monitoring-design-hld.md](https://github.com/mrvntech/self-study/blob/main/monitoring-design-hld.md).

## Mục lục tối thiểu cho Giai đoạn 0

1. Bối cảnh hệ thống (C4 – Level 1)
2. Kiến trúc tổng thể (C4 – Level 2) và nguyên tắc kiến trúc
3. Danh sách thành phần và team sở hữu
4. Kiến trúc dữ liệu → chi tiết ở [domain-model.md](domain-model.md)
5. Tích hợp và API → chi tiết ở [api-catalog.md](api-catalog.md)
6. Security
7. Availability, Reliability, DR
8. Scalability, Performance
9. Monitoring & Observability
10. Deployment, Infrastructure
11. Quyết định kiến trúc → [adr/](adr/)
12. Truy vết NFR → [../product/nfr.md](../product/nfr.md)

## Lịch sử thay đổi do tính năng

| Ngày | Tính năng | Mục thay đổi | ADR liên quan |
| --- | --- | --- | --- |
| {YYYY-MM-DD} | F-000 | {Thêm mục 9 Monitoring} | {ADR-0001} |
