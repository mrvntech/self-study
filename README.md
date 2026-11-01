# self-study

Ghi chú tự học về quy trình phát triển phần mềm (SDLC), thiết kế hệ thống (HLD) và phát triển phần mềm với AI theo hướng spec-driven (Spec Kit).

## Nội dung

### Quy trình phát triển phần mềm

| File | Nội dung |
| --- | --- |
| [sdlc.md](sdlc.md) | 7 phase của SDLC: input, output, role từng phase; monitoring và security xuyên suốt SDLC; so sánh Waterfall, V-Model, Agile, DevOps |

### Thiết kế hệ thống

| File | Nội dung |
| --- | --- |
| [hld-template.md](hld-template.md) | Khung HLD đầy đủ 17 mục: kiến trúc, dữ liệu, tích hợp, security, availability/DR, performance, monitoring, deployment, compliance, chi phí, ADR, truy vết NFR, checklist review |
| [monitoring-design-hld.md](monitoring-design-hld.md) | Mẫu mục Monitoring Design cho HLD: SLI/SLO, monitoring theo tầng, logging/tracing, kiến trúc công cụ, alerting/on-call, dashboard, retention, RACI |

### Phát triển phần mềm với AI (Spec Kit)

| File | Nội dung |
| --- | --- |
| [speckit-vs-sdlc.md](speckit-vs-sdlc.md) | Ánh xạ lệnh Spec Kit vào SDLC; phase nào bị thu gọn hoặc bỏ qua, vì sao, và cách bù; 10 điểm cần lưu ý |
| [speckit-big-picture.md](speckit-big-picture.md) | Mô hình tầng tài liệu (sản phẩm, hệ thống, điều phối, tính năng) để giữ cái nhìn tổng thể và phân việc cho nhiều team khi Spec Kit làm theo từng tính năng |
| [speckit-docs-skeleton/](speckit-docs-skeleton/) | Bộ khung dùng ngay: PRD, feature map, NFR, glossary, HLD, domain model, API catalog, ADR, team map, release plan, dependencies, constitution, phần bổ sung template, lệnh `/project.review` và `/project.plan` |

### Runbook

| File | Nội dung |
| --- | --- |
| [runbook-nodejs-dist.md](runbook-nodejs-dist.md) | Cài Node.js từ tarball chính thức trên nodejs.org/dist, có kiểm tra chữ ký GPG và SHA256 |

## Lộ trình đọc gợi ý

1. [sdlc.md](sdlc.md): nắm các phase và input/output.
2. [hld-template.md](hld-template.md) → [monitoring-design-hld.md](monitoring-design-hld.md): phase Design viết ra tài liệu gì.
3. [speckit-vs-sdlc.md](speckit-vs-sdlc.md) → [speckit-big-picture.md](speckit-big-picture.md): AI thay đổi SDLC thế nào.
4. [speckit-docs-skeleton/](speckit-docs-skeleton/): áp dụng vào dự án thật.

## Quy ước

- Phần trong `{...}` trong các mẫu là placeholder; số liệu trong bảng là ví dụ minh họa.
- Sơ đồ viết bằng Mermaid. GitHub tự hiển thị; trên VS Code cần extension `bierner.markdown-mermaid`.
- Nội dung về Spec Kit viết theo hiểu biết tại thời điểm ghi chú; đối chiếu với [github/spec-kit](https://github.com/github/spec-kit) vì công cụ cập nhật nhanh.
