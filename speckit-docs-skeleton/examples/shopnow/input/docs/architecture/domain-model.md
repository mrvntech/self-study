# Domain model

Trạng thái: Approved · Cập nhật: 2026-10-12

| Entity | Context | Service sở hữu | Thuộc tính chính | Tính năng tạo/sửa |
| --- | --- | --- | --- | --- |
| User | Identity | {chưa đặt} | id, email, phone, status | F-001 |
| Customer | Identity | {chưa đặt} | id, userId, name, address | F-001 |
| Product | Catalog | {chưa đặt} | id, erpCode, name, price, stock | F-002 |
| Cart | Sales | {chưa đặt} | id, customerId, items | F-003 |
| Order | Sales | {chưa đặt} | id, customerId, status, total | F-003, F-005 |
| Payment | Payment | {chưa đặt} | id, orderId, amount, status, gatewayRef | F-003 |
| Notification | Notification | {chưa đặt} | id, customerId, channel, template, status | F-004 |
