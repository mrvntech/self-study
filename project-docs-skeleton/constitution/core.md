# Constitution core – {Tên dự án}

> Phiên bản core: **1.0.0** · Người giữ: Solution Architect · Sửa qua PR vào repo `project-docs`
>
> Phần chung cho **mọi repo team**. Mỗi repo team chép nguyên văn file này vào `.specify/memory/constitution.md`, giữa hai marker `<!-- core:begin vX.Y.Z -->` và `<!-- core:end -->`. Không sửa đoạn này trong repo team; CI so nó với `.project/constitution/core.md` ở commit submodule đang pin.
>
> Đường dẫn `.project/` là submodule trỏ tới repo `project-docs`. Đổi số phiên bản theo semver: MAJOR khi thêm hoặc siết luật làm plan cũ có thể vi phạm, MINOR khi thêm hướng dẫn không chặn, PATCH khi sửa câu chữ.

## I. Ngữ cảnh tổng thể là bắt buộc

- Trước khi `/speckit-specify`: đọc `.project/docs/product/prd.md`, `.project/docs/product/feature-map.md`, `.project/docs/product/nfr.md`, `.project/docs/product/glossary.md`.
- Trước khi `/speckit-plan`: đọc `.project/docs/architecture/hld.md`, `.project/docs/architecture/domain-model.md`, `.project/docs/architecture/api-catalog.md` và các ADR trong `.project/docs/architecture/adr/`.
- Chỉ specify tính năng đã có mã F-xxx trong feature map **và** thuộc team sở hữu repo này theo `.project/docs/delivery/team-map.md`. Thư mục spec đặt tên `specs/F-xxx-<tên-ngắn>/`.
- Không tạo entity, API, event, tài nguyên hạ tầng dùng chung hay thuật ngữ trùng hoặc mâu thuẫn với các tài liệu trên.
- Plan đi ngược HLD hoặc ADR phải đề xuất ADR mới ở trạng thái `Proposed` và dừng lại chờ con người duyệt.
- Mỗi plan ghi commit `project-docs` mà nó dựa vào (`project-docs@<sha>`, lấy từ `git -C .project rev-parse --short HEAD`).

## II. Tài liệu tổng thể là tài liệu sống

- Mỗi tính năng chỉ được coi là xong khi phase "Đồng bộ tài liệu tổng thể" trong `tasks.md` hoàn tất.
- Tài liệu tổng thể chỉ sửa trong repo `project-docs`. AI sửa trong `.project/` trên một nhánh mới; con người review, push và mở PR vào `project-docs`.
- Task đồng bộ chỉ được tick khi PR đó đã merge và repo này đã bump submodule `.project/` lên commit chứa thay đổi.

## II-b. Phối hợp giữa các team

- Mỗi tính năng thuộc về đúng một team trong `.project/docs/delivery/team-map.md`.
- Mỗi task trong `tasks.md` có nhãn `[Team: …]`; task cần hoặc cung cấp thứ cho team khác có thêm `[Needs: …]` hoặc `[Provides: …]`, dùng đúng tên trong `.project/docs/architecture/api-catalog.md`.
- Không bắt đầu task có `Needs` khi phụ thuộc tương ứng trong `.project/docs/delivery/dependencies.md` chưa ở trạng thái `Contract approved`.

## II-c. Core và phần riêng của team

- Phần sau marker `core:end` là nguyên tắc riêng của team sở hữu repo, khởi tạo từ `.project/constitution/team-parts/`.
- Phần riêng chỉ được **thêm** luật hoặc **siết** luật của core, không được nới hay bỏ. Khi hai bên mâu thuẫn, core thắng.
- Luật trong phần riêng có mã và mức:
  - `MUST`: kiểm trong Constitution Check của `/speckit-plan`; `/speckit-analyze` báo vi phạm là CRITICAL, như vi phạm core.
  - `SHOULD`: hướng dẫn; vi phạm phải ghi lý do trong `research.md`, `/speckit-analyze` báo mức MEDIUM.
- Quyết định kỹ thuật (ngôn ngữ, framework, dịch vụ cloud, phiên bản công cụ) nằm ở ADR. Phần riêng trỏ tới ADR, không chép lại nội dung quyết định.
- Luật trong phần riêng chạm tới trách nhiệm của team khác (theo bảng "Ranh giới trách nhiệm" trong `team-map.md`) phải có team đó duyệt.

## III. Con người duyệt giữa các bước

- Không chạy `/speckit-implement` khi spec, plan và tasks chưa được con người duyệt.
- Chia việc (`/project.breakdown`) và backlog (`/project.backlog`) chỉ là bản đề xuất; con người duyệt trước khi ghi vào `docs/`.
- AI không tự chạy các thao tác ghi ra hệ thống bên ngoài: push, mở hoặc merge PR, `scripts/backlog-sync.sh --apply`, tạo/sửa issue, `terraform apply` lên bất kỳ môi trường nào ngoài môi trường sandbox cá nhân. Người dùng tự chạy sau khi xem lại.

## IV. Vận hành

- Mọi service có `/health/live` và `/health/ready`.
- Log dạng JSON, có `trace_id`; không ghi mật khẩu, token, dữ liệu cá nhân chưa che.
- Mỗi API có metrics RED. Chức năng Tier 1 có SLO và alert kèm runbook.

## V. Bảo mật

- Xác thực qua OIDC, phân quyền RBAC.
- Không hardcode secret; dùng {Vault / KMS} theo HLD.
- CI chạy SAST (với IaC: quét cấu hình như checkov, tfsec) và quét dependency, chặn merge khi có lỗi mức High trở lên.

## VI. Chất lượng

- Viết test trước khi viết code (với IaC: test và policy trước module); acceptance test bám theo acceptance criteria trong spec.
- Ưu tiên giải pháp đơn giản. Thêm thư viện, module hoặc lớp trừu tượng mới phải ghi lý do trong `research.md`.
