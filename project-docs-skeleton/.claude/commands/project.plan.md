---
description: Tổng hợp tasks của mọi tính năng thành kế hoạch theo team, phụ thuộc giữa các team và đường găng. Chỉ đề xuất, không tự sửa file.
---

Bạn đang lập kế hoạch điều phối **giữa các team**. Không sửa bất kỳ file nào; chỉ đưa ra báo cáo và bản nháp để con người duyệt.

## Đầu vào

1. `docs/product/feature-map.md`: tính năng, team, phụ thuộc, release.
2. `docs/delivery/team-map.md`, `docs/delivery/release-plan.md`, `docs/delivery/dependencies.md`.
3. `docs/architecture/api-catalog.md`.
4. Mọi `workspace/*/specs/*/tasks.md`: đọc các nhãn `[Team: …]`, `[Needs: …]`, `[Provides: …]`, `[Gate: human]`, `[P]` và trạng thái checkbox. Spec của mọi team nằm trong các repo team; đọc qua bản checkout trong `workspace/<repo>/` do `scripts/workspace-sync.sh` tạo (người dùng tự chạy trước; nếu `workspace/` trống hoặc thiếu repo có trong bảng "Danh sách repo" của `team-map.md` thì dừng và nhắc chạy script). Ghi đường dẫn dạng `<repo>:specs/…`.

Phạm vi bổ sung từ người dùng (ví dụ một mốc release hoặc một team): $ARGUMENTS

## Phân tích

1. **Kiểm tra nhãn**
   - Task thiếu `[Team: …]`, hoặc tên team không có trong `team-map.md`.
   - Team trong task khác team sở hữu tính năng trong `feature-map.md` (có thể hợp lệ, nhưng phải nêu ra).
2. **Ghép phụ thuộc**
   - Mỗi `Needs` tìm `Provides` tương ứng (cùng tên API/event hoặc cùng mã F-xxx/Txxx).
   - `Needs` không có `Provides` nào.
   - `Provides` chưa có trong `api-catalog.md`.
   - Phụ thuộc vòng.
   - So sánh với `dependencies.md`: phụ thuộc mới chưa ghi, phụ thuộc đã ghi nhưng không còn trong tasks.
3. **Tiến độ**
   - Tỷ lệ task đã xong theo team, theo repo và theo tính năng.
   - Task `[Gate: human]` chưa tick đang giữ các task phía sau (thường là apply hạ tầng, diễn tập): liệt kê kèm người cần làm.
   - Bên cần đang bị chặn vì phụ thuộc chưa `Contract approved`.
4. **Đường găng**
   - Chuỗi phụ thuộc dài nhất dẫn tới từng mốc trong `release-plan.md`.
   - Mốc có nguy cơ trễ: còn nhiều task chưa xong trên đường găng, hoặc phụ thuộc trễ hạn.

## Đầu ra

Một báo cáo Markdown gồm:

1. **Tóm tắt:** tình trạng từng mốc (Đúng hạn / Có rủi ro / Trễ), số cảnh báo.
2. **Việc theo team:** mỗi team một bảng: Tính năng | Task còn lại | Đang bị chặn bởi | Đang chặn ai.
3. **Bảng phụ thuộc đề xuất** theo đúng định dạng của `docs/delivery/dependencies.md`, đánh dấu dòng mới hoặc thay đổi.
4. **Sơ đồ phụ thuộc** dạng Mermaid `flowchart LR`.
5. **Đường găng** cho từng mốc.
6. **Cảnh báo và việc cần con người quyết định:** dời mốc, đổi thứ tự, chốt contract, thêm người.

Chỉ dựa trên nội dung có trong file, ghi rõ đường dẫn (`<repo>:specs/…`) và mã task. Không tự đoán ngày; ngày nào không có trong file thì ghi "chưa có".
