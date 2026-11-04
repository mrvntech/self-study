<!-- Profile "test": repo bộ test dùng chung (E2E, load test) do QA giữ. Chép vào sau marker core:end trong .specify/memory/constitution.md của repo, điền {…}, xoá luật không áp dụng. Test unit, tích hợp, contract của một service nằm ở repo service đó (profile service). -->

## Profile test

> Repo: `{e2e-tests}` · Team giữ repo: {QA} · Thành phần: theo bảng "Danh sách repo" trong `.project/docs/delivery/team-map.md`

### Phạm vi · *QA giữ*

- **TST-01 (MUST)** Repo này chứa test **xuyên service**: E2E theo user journey, load test theo NFR, dữ liệu test dùng chung. Test chỉ đụng một service đặt ở repo service đó.
- **TST-02 (MUST)** Tính năng của repo này là bộ test cho một tính năng business: spec ghi mã tính năng được test (`F-xxx`) và AC được phủ; task dùng `[Needs: …]` tới môi trường hoặc API cần có.

### Stack · *QA giữ*

| Hạng mục | Theo |
| --- | --- |
| E2E | {ADR-xxxx: Playwright} |
| Load test | {ADR-xxxx: k6} |

### Viết test · *QA giữ*

- **TST-10 (MUST)** Mỗi test E2E đặt tên kèm mã tính năng và AC (`F-002a AC-03 …`), để truy ngược về spec.
- **TST-11 (MUST)** Chọn phần tử UI theo `data-testid` hoặc role; không theo CSS class hay vị trí.
- **TST-12 (MUST)** Test độc lập với nhau: mỗi test tự tạo và dọn dữ liệu của mình, chạy được song song và theo thứ tự bất kỳ.
- **TST-13 (MUST)** Không dùng dữ liệu khách hàng thật; dữ liệu test sinh từ fixture hoặc factory.
- **TST-14 (SHOULD)** Không dùng `sleep` cố định; chờ theo điều kiện.

### Load test · *QA giữ, SRE duyệt ngưỡng*

- **TST-20 (MUST)** Kịch bản và ngưỡng (p95, tỷ lệ lỗi, throughput) lấy từ NFR (`nfr.md`); kịch bản ghi mã NFR.
- **TST-21 (MUST)** Chỉ chạy ở staging hoặc môi trường load test riêng, có báo trước cho Infra và SRE; không chạy vào prod.

### CI · *QA giữ*

- **TST-30 (MUST)** Bộ smoke E2E chạy sau mỗi lần triển khai lên staging; bộ đầy đủ chạy {hằng đêm}. Kết quả báo về kênh của team sở hữu tính năng.
- **TST-31 (SHOULD)** Test chập chờn (flaky) bị cách ly trong {24 giờ} và có ticket; không tắt test mà không có ticket.
