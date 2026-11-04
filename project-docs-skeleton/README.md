# Khung repo tài liệu trung tâm (`project-docs`) cho dự án dùng Spec Kit

Dự án tổ chức theo **nhiều repo**: một repo `project-docs` giữ cái nhìn tổng thể (tầng sản phẩm, hệ thống, điều phối), mỗi team có repo riêng để chạy Spec Kit cho từng tính năng. Khung này dùng để tạo `project-docs`; khung cho repo team ở [../team-repo-skeleton/](../team-repo-skeleton/). Giải thích chi tiết: [../speckit-big-picture.md](../speckit-big-picture.md).

```
project-docs  ── docs/, constitution/, templates-additions/, lệnh /project.*, scripts/
   ▲  submodule .project/ (pin theo commit)
   │
<repo team>   ── .specify/memory/constitution.md (core + profile), specs/F-xxx-…/, code
```

- Repo team đọc tài liệu tổng thể qua submodule `.project/`; sửa tài liệu tổng thể bằng PR vào `project-docs`.
- `project-docs` đọc spec của mọi team qua `workspace/` (bản checkout chỉ đọc, do `scripts/workspace-sync.sh` tạo).
- Mỗi repo có một team giữ, có thể có team đóng góp theo đường dẫn; ghi ở bảng "Danh sách repo" trong `docs/delivery/team-map.md`.

## Cách dùng

1. Tạo repo `project-docs`, copy toàn bộ thư mục này vào (kể cả `.claude/`, `.gitignore`). Repo này không cần `specify init`: nó chỉ chạy các lệnh `/project.*`.
2. Làm Giai đoạn 0 – Discovery theo [hướng dẫn](../discovery-phase0-guideline.md):
   - Thu thập đầu vào vào `docs/discovery/inputs/`, ghi biên bản vào `docs/discovery/workshops/`.
   - B2–B4: `business-context.md`, `as-is.md`, `story-map.md`.
   - B5–B6: `/project.discovery` soạn nháp `prd.md`, `nfr.md`, `glossary.md`, `feature-map.md` lượt 1; con người duyệt.
   - B7: `event-storming.md`, `domain-model.md`.
   - B8: `/project.hld` soạn nháp từng mục `hld.md`, `adr/`, `api-catalog.md`; Architect, Security, SRE duyệt.
3. Điền tầng điều phối:
   - `/project.teammap` soạn nháp `team-map.md`: team, **danh sách repo** (team giữ, team đóng góp, team duyệt, profile), ranh giới việc xuyên suốt kèm **nơi làm**. Con người duyệt rồi điền `release-plan.md`.
   - Architect chốt `constitution/core.md` và chỉnh các profile trong `constitution/profiles/` theo NFR, ADR của dự án.
4. Tạo repo cho từng dòng trong "Danh sách repo" theo [../team-repo-skeleton/README.md](../team-repo-skeleton/README.md): submodule `.project/`, `specify init`, constitution = core + profile, template additions, `CODEOWNERS`.
5. Chia việc và tạo backlog:
   - `/project.breakdown`: AI đề xuất feature/epic theo team, enabler, contract, phụ thuộc. Con người duyệt rồi cập nhật `feature-map.md` (cột Spec dạng `<repo>:specs/F-xxx-…`), `dependencies.md`.
   - `/project.backlog`: AI sinh `docs/delivery/backlog.json` từ feature map.
   - Người dùng tự chạy `scripts/backlog-sync.sh` (chạy thử), rồi `--apply`: issue feature tạo ở `project-docs`. Cập nhật cột Issue trong `feature-map.md`.
6. Các team chạy Spec Kit trong repo của mình, bắt đầu từ `F-000` (foundation, repo infra). Tên thư mục spec theo mã tính năng: `specs/F-xxx-<tên>/`.
7. Định kỳ, trong `project-docs`:

   ```bash
   scripts/workspace-sync.sh          # clone/cập nhật mọi repo team vào workspace/
   /project.review                    # kiểm tra chéo spec, plan với tài liệu tổng thể; repo và team (mục 8)
   /project.plan                      # việc theo team, phụ thuộc, đường găng, gate còn mở
   /project.backlog --with-tasks      # task của mọi repo → backlog.json
   scripts/backlog-sync.sh            # chạy thử; --apply: task tạo ở repo team, gắn sub-issue vào feature
   ```

Tên thư mục và template của Spec Kit có thể khác theo phiên bản. Đối chiếu với README của [github/spec-kit](https://github.com/github/spec-kit). Thư mục lệnh `.claude/commands/` dành cho Claude Code; agent khác dùng thư mục lệnh riêng.

## Constitution: core và profile

| File | Nội dung | Ai giữ |
| --- | --- | --- |
| `constitution/core.md` | Nguyên tắc chung cho mọi repo team, có số phiên bản. Repo team chép nguyên văn giữa hai marker; CI (`scripts/check-core.sh`) báo lỗi nếu lệch | Solution Architect |
| `constitution/profiles/service.md` | Repo service backend, frontend: code, contract, test; mục Migration (DBA giữ), Observability của service (SRE giữ), Frontend | Team giữ repo, DBA, SRE theo mục |
| `constitution/profiles/infra.md` | Repo IaC (AWS + Terraform): quy ước IaC, các trụ cột Well-Architected, DB dùng chung (DBA giữ), guardrail | Infra; Security giữ luật mục Security |
| `constitution/profiles/observability.md` | Phần observability trong repo infra: stack, alert hạ tầng (Infra), chuẩn alert, Alertmanager, dashboard tổng quan, golden path (SRE) | Infra, SRE theo mục |
| `constitution/profiles/security-policy.md` | Policy as code trong repo infra: test, bật dần, ngoại lệ | Security |
| `constitution/profiles/test.md` | Repo test dùng chung: E2E, load test | QA |

Profile chia theo **loại việc**, không theo team; một repo ghép nhiều profile (repo infra: `infra` + `observability` + `security-policy`). Mỗi luật có mã (`SVC-10`, `INF-22`…) và mức `MUST` (kiểm trong Constitution Check) hoặc `SHOULD`.

## Cấu trúc

```
docs/
├── discovery/                   # Giai đoạn 0
│   ├── inputs/                  # business-brief, stakeholders, current-systems, constraints
│   ├── workshops/               # workshop-notes (template biên bản)
│   ├── business-context.md
│   ├── as-is.md
│   ├── story-map.md
│   ├── event-storming.md
│   └── open-questions.md
├── product/
│   ├── prd.md
│   ├── feature-map.md           # cột Spec: <repo>:specs/F-xxx-…
│   ├── nfr.md
│   └── glossary.md
├── architecture/
│   ├── hld.md
│   ├── domain-model.md
│   ├── api-catalog.md           # API, event, tài nguyên hạ tầng
│   └── adr/
│       └── 0000-template.md
└── delivery/
    ├── team-map.md              # team, danh sách repo, ranh giới việc + nơi làm
    ├── release-plan.md
    ├── dependencies.md
    └── backlog.example.json     # mẫu dữ liệu cho backlog.json (item có "repo")
constitution/
├── core.md                      # phần chung, chép vào mọi repo team
└── profiles/                    # service, infra, observability, security-policy, test
templates-additions/
├── common/                      # spec, plan, tasks: mọi repo team
└── infra/                       # spec, plan, tasks: thêm cho repo có profile infra
.claude/commands/
├── project.discovery.md         # discovery → nháp story map, PRD, NFR, glossary, feature map lượt 1
├── project.hld.md               # PRD, NFR, domain model → nháp HLD, ADR, API catalog
├── project.teammap.md           # HLD + nguồn lực → nháp team map, danh sách repo
├── project.breakdown.md         # HLD → đề xuất chia việc theo team
├── project.backlog.md           # feature map (+ tasks trong workspace/) → backlog.json
├── project.review.md            # kiểm tra chéo giữa các tính năng và các repo
└── project.plan.md              # việc theo team, phụ thuộc, đường găng
scripts/
├── backlog-sync.sh              # backlog.json → GitHub Issues ở nhiều repo (mặc định chạy thử)
├── workspace-sync.sh            # clone/cập nhật repo team vào workspace/ (chỉ đọc)
└── check-core.sh                # chạy trong repo team: core trong constitution khớp .project/
workspace/                       # .gitignore; bản checkout repo team
examples/
├── shopnow/                     # dự án mẫu: đầu vào sau B7, file do /project.hld, /project.teammap sinh ra, bản đã duyệt giả lập
├── shopnow-hld.example.md       # output thật của /project.hld
├── shopnow-teammap.example.md   # output thật của /project.teammap
└── shopnow-breakdown.example.md # output thật của /project.breakdown
```

`backlog-sync.sh` cần `gh` (đã đăng nhập, có quyền ghi issue ở mọi repo đích), `jq` và bash 4 trở lên. Script nhận diện issue bằng tiền tố `[KEY]` trong tiêu đề, trong đúng repo đích của item, nên chạy lại không tạo trùng. Sub-issue xuyên repo cần các repo cùng owner/org.
