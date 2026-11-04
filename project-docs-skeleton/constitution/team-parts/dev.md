<!-- Khung phần riêng cho team dev. Chép vào sau marker core:end trong .specify/memory/constitution.md của repo team, điền {…}, xoá luật không áp dụng. -->

## Nguyên tắc riêng của {Team Order}

> Repo: `{order-service}` · Thành phần sở hữu: theo `.project/docs/delivery/team-map.md` · Người giữ: Tech Lead {Tên}

### Stack

Không chép quyết định vào đây, chỉ trỏ tới ADR.

| Hạng mục | Theo |
| --- | --- |
| Ngôn ngữ, runtime | {ADR-0003} |
| Framework | {ADR-0003} |
| Truy cập DB, migration | {ADR-0005} |
| Messaging | {ADR-0006} |

### Cấu trúc và convention

- **DEV-01 (MUST)** Tổ chức code theo {cấu trúc: module theo bounded context trong `domain-model.md`; tầng `api/`, `application/`, `domain/`, `infrastructure/`}. Code `domain/` không import framework hay SDK hạ tầng.
- **DEV-02 (MUST)** Lint và format theo cấu hình trong repo (`{eslint + prettier / ruff / golangci-lint}`); CI chặn merge khi lint lỗi.
- **DEV-03 (SHOULD)** Đặt tên theo glossary: entity, biến, bảng dùng đúng thuật ngữ trong `.project/docs/product/glossary.md` (bản tiếng Anh).
- **DEV-04 (MUST)** Lỗi trả ra API theo một định dạng chung `{RFC 9457 Problem Details}`; không trả stack trace ra ngoài.

### API và contract

- **DEV-10 (MUST)** API và event cung cấp ra ngoài có contract trong `specs/F-xxx-…/contracts/` (`{OpenAPI 3.1 / AsyncAPI 3}`) trước khi viết code.
- **DEV-11 (MUST)** Mỗi `Provides` có contract test phía provider; mỗi `Needs` có contract test phía consumer (`{Pact / schema test}`).
- **DEV-12 (MUST)** Thay đổi không tương thích ngược tăng phiên bản theo quy tắc trong `api-catalog.md`.

### Test

- **DEV-20 (MUST)** Unit test cho logic `domain/` và `application/`; coverage dòng của hai tầng này ≥ {80%}.
- **DEV-21 (MUST)** Mỗi acceptance criteria trong spec có ít nhất một acceptance test, đặt tên kèm mã (`AC-xx`).
- **DEV-22 (SHOULD)** Test tích hợp với DB và broker thật qua `{Testcontainers}`, không mock driver.

### Dependency và dữ liệu

- **DEV-30 (MUST)** Thêm thư viện mới: ghi lý do và license trong `research.md`; không dùng license {GPL/AGPL} cho code phân phối.
- **DEV-31 (MUST)** Migration DB theo chuẩn của team DBA (`team-map.md`): chỉ tiến, tương thích ngược với bản code đang chạy, có review của DBA khi đụng bảng dùng chung.

### Vận hành (siết thêm core IV)

- **DEV-40 (MUST)** Service đóng gói và triển khai bằng golden path Helm chart của Infra; không tự viết chart riêng.
- **DEV-41 (SHOULD)** Mỗi endpoint mới có dashboard panel và alert đề xuất gửi SRE review trong cùng tính năng.
