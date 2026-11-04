<!-- Profile "security-policy": policy as code, thường nằm ở `policies/` trong repo infra (Security đóng góp, CODEOWNERS Security). Ghép sau profile infra. Chính sách bảo mật và threat model dạng tài liệu nằm ở `project-docs`; pentest, duyệt kết quả quét lỗ hổng là hoạt động, đi qua ticket. -->

## Profile security-policy

> Đường dẫn: `{infra}:policies/` · Team đóng góp: {Security} · CODEOWNERS (duyệt bắt buộc): {Security} · Chính sách gốc: `.project/docs/{security/policy.md}`, threat model: HLD mục 7.1

### Phạm vi · *Security giữ*

- **SEC-01 (MUST)** Ở đây chứa policy chặn cấu hình vi phạm: OPA/Conftest cho Terraform plan, Kyverno (hoặc Gatekeeper) cho manifest K8s, và {WAF rule, rule SIEM} nếu quản lý dạng code.
- **SEC-02 (MUST)** Mỗi policy ghi luật gốc mà nó hiện thực (mã trong chính sách bảo mật, hoặc mã luật constitution như `INF-22`).

### Viết policy · *Security giữ*

- **SEC-10 (MUST)** Mỗi policy có test với ít nhất một input vi phạm và một input hợp lệ (`conftest verify`, `kyverno test`); CI chạy test trước khi merge.
- **SEC-11 (MUST)** Policy mới bật ở chế độ cảnh báo (`audit` / `warn`) tối thiểu {1 tuần}, liệt kê các vi phạm đang có và báo team sở hữu, rồi mới chuyển sang chặn (`enforce` / `deny`).
- **SEC-12 (MUST)** Không chứa secret, IP nội bộ nhạy cảm hay chi tiết lỗ hổng chưa vá trong policy hoặc message lỗi.

### Ngoại lệ · *Security giữ*

- **SEC-20 (MUST)** Ngoại lệ khai báo trong `policies/exceptions/` (resource, policy, lý do, người duyệt, ngày hết hạn) hoặc qua ADR; không sửa policy để né một trường hợp.
- **SEC-21 (MUST)** Ngoại lệ hết hạn thì CI báo lỗi; gia hạn cần Security duyệt lại.
