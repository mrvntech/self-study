# Constitution – {Tên dự án}

> Bản mẫu bổ sung cho constitution mặc định của Spec Kit. Gộp vào constitution của dự án, giữ các nguyên tắc sẵn có.

## I. Ngữ cảnh tổng thể là bắt buộc

- Trước khi `/speckit.specify`: đọc `docs/product/prd.md`, `docs/product/feature-map.md`, `docs/product/nfr.md`, `docs/product/glossary.md`.
- Trước khi `/speckit.plan`: đọc `docs/architecture/hld.md`, `docs/architecture/domain-model.md`, `docs/architecture/api-catalog.md` và các ADR trong `docs/architecture/adr/`.
- Chỉ specify tính năng đã có mã F-xxx trong feature map.
- Không tạo entity, API, event hay thuật ngữ trùng hoặc mâu thuẫn với các tài liệu trên.
- Plan đi ngược HLD hoặc ADR phải đề xuất ADR mới ở trạng thái `Proposed` và dừng lại chờ con người duyệt.

## II. Tài liệu tổng thể là tài liệu sống

- Mỗi tính năng chỉ được coi là xong khi phase "Đồng bộ tài liệu tổng thể" trong `tasks.md` hoàn tất.

## III. Con người duyệt giữa các bước

- Không chạy `/speckit.implement` khi spec, plan và tasks chưa được con người duyệt.

## IV. Vận hành

- Mọi service có `/health/live` và `/health/ready`.
- Log dạng JSON, có `trace_id`; không ghi mật khẩu, token, dữ liệu cá nhân chưa che.
- Mỗi API có metrics RED. Chức năng Tier 1 có SLO và alert kèm runbook.

## V. Bảo mật

- Xác thực qua OIDC, phân quyền RBAC.
- Không hardcode secret; dùng {Vault / KMS}.
- CI chạy SAST và quét dependency, chặn merge khi có lỗi mức High trở lên.

## VI. Chất lượng

- Viết test trước khi viết code; acceptance test bám theo acceptance criteria trong spec.
- Ưu tiên giải pháp đơn giản. Thêm thư viện hoặc lớp trừu tượng mới phải ghi lý do trong `research.md`.
