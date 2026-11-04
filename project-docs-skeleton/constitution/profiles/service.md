<!-- Profile "service": repo chứa service backend hoặc frontend của một team dev. Chép vào sau marker core:end trong .specify/memory/constitution.md của repo, điền {…}, xoá luật không áp dụng. Mỗi mục ghi team giữ: sửa luật trong mục nào cần team đó duyệt (core II-c). -->

## Profile service

> Repo: `{order-service}` · Team giữ repo: {Team Order} · Thành phần: theo bảng "Danh sách repo" trong `.project/docs/delivery/team-map.md`

### Stack · *team giữ repo*

Không chép quyết định vào đây, chỉ trỏ tới ADR.

| Hạng mục | Theo |
| --- | --- |
| Ngôn ngữ, runtime | {ADR-0003} |
| Framework | {ADR-0003} |
| Truy cập DB, migration | {ADR-0005} |
| Messaging | {ADR-0006} |

### Cấu trúc và convention · *team giữ repo*

- **SVC-01 (MUST)** Tổ chức code theo {cấu trúc: module theo bounded context trong `domain-model.md`; tầng `api/`, `application/`, `domain/`, `infrastructure/`}. Code `domain/` không import framework hay SDK hạ tầng.
- **SVC-02 (MUST)** Lint và format theo cấu hình trong repo (`{eslint + prettier / ruff / golangci-lint}`); CI chặn merge khi lint lỗi.
- **SVC-03 (SHOULD)** Đặt tên theo glossary: entity, biến, bảng dùng đúng thuật ngữ trong `.project/docs/product/glossary.md` (bản tiếng Anh).
- **SVC-04 (MUST)** Lỗi trả ra API theo một định dạng chung `{RFC 9457 Problem Details}`; không trả stack trace ra ngoài.

### API và contract · *team giữ repo*

- **SVC-10 (MUST)** API và event cung cấp ra ngoài có contract trong `specs/F-xxx-…/contracts/` (`{OpenAPI 3.1 / AsyncAPI 3}`) trước khi viết code.
- **SVC-11 (MUST)** Mỗi `Provides` có contract test phía provider; mỗi `Needs` có contract test phía consumer (`{Pact / schema test}`).
- **SVC-12 (MUST)** Thay đổi không tương thích ngược tăng phiên bản theo quy tắc trong `api-catalog.md`.

### Test · *team giữ repo*

- **SVC-20 (MUST)** Unit test cho logic `domain/` và `application/`; coverage dòng của hai tầng này ≥ {80%}.
- **SVC-21 (MUST)** Mỗi acceptance criteria trong spec có ít nhất một acceptance test, đặt tên kèm mã (`AC-xx`).
- **SVC-22 (SHOULD)** Test tích hợp với DB và broker thật qua `{Testcontainers}`, không mock driver.

### Dependency · *team giữ repo*

- **SVC-30 (MUST)** Thêm thư viện mới: ghi lý do và license trong `research.md`; không dùng license {GPL/AGPL} cho code phân phối.

### Migration DB · *DBA giữ* · CODEOWNERS `migrations/`: {DBA}

- **SVC-35 (MUST)** Migration nằm trong `migrations/`, dùng migration tooling chuẩn của DBA, chỉ tiến; bản migration tương thích ngược với bản code đang chạy (expand → migrate → contract).
- **SVC-36 (MUST)** Tuân theo chuẩn schema trong `.project/docs/architecture/{db-standards.md}`: tên bảng, khoá chính, cột audit, index cho khoá ngoại.
- **SVC-37 (MUST)** Migration xoá cột hoặc bảng, hay khoá bảng lớn hơn {1 triệu dòng}, ghi kế hoạch chạy và rollback trong `plan.md`.

### Triển khai · *Infra giữ*

- **SVC-40 (MUST)** Service đóng gói và triển khai bằng golden path Helm chart của Infra; không tự viết chart riêng. Cần thêm khả năng thì gửi `[Needs: …]` sang Infra.

### Observability · *SRE giữ* · CODEOWNERS `observability/`: {SRE}

Hiện thực SLO của chính service. Định nghĩa SLO nằm ở `.project/docs/` (HLD mục 10, `nfr.md`); alert hạ tầng và dashboard tổng quan nằm ở repo `infra` (profile observability).

- **SVC-50 (MUST)** Recording rule SLI, alert và dashboard chi tiết của service nằm trong `observability/` của repo này và triển khai cùng service qua golden path chart (`PrometheusRule`, dashboard dạng ConfigMap).
- **SVC-51 (MUST)** Alert theo SLO burn rate, mang nhãn `team` và `severity`; mọi alert P1/P2 có runbook trong `observability/runbooks/` và `runbook_url` trỏ tới đó.
- **SVC-52 (MUST)** CI chạy `promtool check rules` và `promtool test rules` cho `observability/`.
- **SVC-53 (SHOULD)** Endpoint hoặc consumer mới thêm alert và panel dashboard trong cùng tính năng, không để tính năng sau.

### Frontend (chỉ repo frontend) · *team giữ repo*

- **SVC-60 (MUST)** Đáp ứng {WCAG 2.1 AA} theo NFR; CI chạy kiểm tra accessibility tự động (`{axe}`).
- **SVC-61 (MUST)** Ngân sách hiệu năng theo NFR: {LCP ≤ 2.5s, bundle JS ban đầu ≤ 200 KB gzip}; CI báo khi vượt.
- **SVC-62 (MUST)** Gọi backend chỉ qua API có trong `api-catalog.md`; không gọi thẳng service nội bộ.
