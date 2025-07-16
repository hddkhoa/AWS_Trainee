---
title: "9. Tối Ưu Hóa Chi Phí"
date: 2025-07-11T11:00:00+07:00
weight: 90
chapter: true
pre: "<b>9. </b>"
draft: false
---

### Chương 9

# Tối Ưu Hóa Chi Phí

Tối ưu hóa chi phí AWS RDS thông qua giám sát, lập ngân sách và các chiến lược quản lý tài nguyên thông minh.

## Tổng Quan

Tối ưu hóa chi phí là yếu tố quan trọng để duy trì hoạt động AWS RDS hiệu quả trong khi kiểm soát chi phí. Phần này bao gồm giám sát chi phí toàn diện, thiết lập ngân sách và các chiến lược tối ưu hóa.

<img src="https://hddkhoa.github.io/AWS_Trainee/images/2025-07-14_17-27-43.png" alt="AWS Cost Management Dashboard" width="800">

## Các Bước Tối Ưu Hóa Chi Phí

### Bước 1: Xem Xét Chi Phí
1. Truy cập AWS Billing Console
2. Click "Bills" để xem chi phí hiện tại
3. Lọc theo "Amazon Relational Database Service"
4. Phân tích xu hướng và mẫu chi phí
5. Xác định tài nguyên chi phí cao và các đỉnh sử dụng

<img src="https://hddkhoa.github.io/AWS_Trainee/images/2025-07-14_17-28-12.png" alt="AWS Billing Console - Chi phí RDS" width="800">

### Bước 2: Thiết Lập Cảnh Báo Ngân Sách
1. Trong Billing Console, click "Budgets"
2. Click "Create budget"
3. Budget type: Cost budget
4. Budget name: RDS-Monthly-Budget
5. Budgeted amount: $10 (hoặc số tiền bạn mong muốn)
6. Budget scope: Service = Amazon Relational Database Service
7. Thiết lập email alerts khi đạt 80% và 100% ngân sách
8. Cấu hình người nhận thông báo
9. Xem xét và tạo ngân sách

<img src="https://hddkhoa.github.io/AWS_Trainee/images/2025-07-14_17-30-58.png" alt="Thiết lập AWS Budget cho RDS" width="800">

### Bước 3: Chiến Lược Tối Ưu Hóa Chi Phí
1. **Điều chỉnh kích thước instance**: Khớp loại instance với yêu cầu workload thực tế
2. **Reserved Instances**: Mua RDS Reserved Instances cho workload có thể dự đoán được
3. **Tối ưu hóa storage**: Sử dụng loại storage phù hợp (gp2, gp3, io1, io2)
4. **Automated backups**: Tối ưu hóa thời gian lưu trữ backup
5. **Multi-AZ deployment**: Đánh giá tính cần thiết cho high availability
6. **Read replicas**: Sử dụng read replicas hiệu quả cho workload đọc nhiều

### Bước 4: Giám Sát và Cảnh Báo
- Thiết lập CloudWatch alarms cho ngưỡng chi phí
- Giám sát metrics sử dụng database
- Theo dõi mẫu tăng trưởng storage
- Xem xét báo cáo chi phí hàng tháng
- Triển khai khuyến nghị tối ưu hóa chi phí tự động

<img src="https://hddkhoa.github.io/AWS_Trainee/images/2025-07-14_17-31-38.png" alt="Thiết lập Giám sát Chi phí và Cảnh báo" width="800">

## Thực Hành Tốt Nhất
- Xem xét chi phí định kỳ (hàng tuần/tháng)
- Sử dụng AWS Cost Explorer để phân tích chi tiết
- Triển khai chiến lược tagging để phân bổ chi phí
- Cân nhắc các tùy chọn serverless (Aurora Serverless) cho workload biến đổi
- Giám sát và tối ưu hóa chi phí truyền dữ liệu
