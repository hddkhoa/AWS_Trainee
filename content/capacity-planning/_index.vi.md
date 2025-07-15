---
title: "8. Lập kế hoạch Năng lực"
date: 2025-07-14T14:00:00+07:00
weight: 80
chapter: true
pre: "<b>8. </b>"
draft: false
---

### Chương 8

# Lập kế hoạch Năng lực

Đảm bảo tài nguyên cơ sở dữ liệu đủ để đáp ứng nhu cầu hiện tại và tương lai.

## Mục tiêu

Dự báo nhu cầu tài nguyên, tránh tình trạng thiếu hụt hoặc lãng phí.

## Các nguồn dữ liệu

### Dữ liệu lịch sử
- CloudWatch metrics
- Performance Insights data
- Historical performance trends

### Thông tin business
- Tăng trưởng người dùng
- Tính năng mới từ đội ngũ phát triển
- Seasonal patterns và business cycles

## Các hoạt động chính

### 1. Phân tích xu hướng
Xác định các mẫu tăng trưởng:
- CPU utilization trends
- RAM usage patterns
- IOPS requirements
- Số lượng kết nối database

### 2. Dự báo nhu cầu
Ước tính tài nguyên cần thiết trong tương lai:
- **3 tháng**: Kế hoạch ngắn hạn
- **6 tháng**: Kế hoạch trung hạn
- **1 năm**: Kế hoạch chiến lược dài hạn

### 3. Lựa chọn Instance Type
Quyết định kích thước và loại instance RDS phù hợp:

| Loại Workload | Instance Family Khuyến nghị |
|---------------|----------------------------|
| General Purpose | db.t3, db.m5 |
| Memory Intensive | db.r5, db.x1e |
| Compute Intensive | db.c5 |
| Storage Intensive | db.i3 |

## Chiến lược mở rộng (Scaling Strategy)

### Vertical Scaling
**Nâng cấp instance size** (tăng CPU, RAM)
- Ưu điểm: Đơn giản, không thay đổi architecture
- Nhược điểm: Có giới hạn, downtime khi upgrade

### Read Replicas
**Sử dụng bản sao chỉ đọc** để phân tải các truy vấn đọc
- Ưu điểm: Giảm tải cho primary instance
- Nhược điểm: Eventual consistency, phức tạp hơn

### Sharding (tùy chọn)
**Phân chia dữ liệu** ra nhiều cơ sở dữ liệu nhỏ hơn
- Ưu điểm: Horizontal scaling không giới hạn
- Nhược điểm: Rất phức tạp, thay đổi application logic

## Kiểm tra tải (Load Testing)

### Mục đích
Mô phỏng tải công việc dự kiến để xác minh khả năng chịu tải của hệ thống.

### Các công cụ
- **AWS Database Migration Service**: Load testing
- **Apache JMeter**: Application load testing
- **Artillery.io**: Modern load testing toolkit

### Quy trình
1. **Baseline testing**: Đo hiệu suất hiện tại
2. **Stress testing**: Tìm giới hạn của hệ thống
3. **Volume testing**: Test với dữ liệu lớn
4. **Endurance testing**: Test trong thời gian dài

## Best Practices

- **Monitor continuously**: Theo dõi liên tục các metrics
- **Plan ahead**: Không đợi đến khi có vấn đề
- **Test thoroughly**: Luôn test trước khi production
- **Document everything**: Ghi chép tất cả quyết định và kết quả
