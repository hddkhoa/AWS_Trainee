---
title: "3. Thiết lập Đường cơ sở Hiệu suất"
date: 2025-07-14T14:00:00+07:00
weight: 30
chapter: true
pre: "<b>3. </b>"
draft: false
---

### Chương 3

# Thiết lập Đường cơ sở Hiệu suất

Đây là bước nền tảng để hiểu hoạt động bình thường của cơ sở dữ liệu trước khi tối ưu hóa.

## Mục tiêu

Thu thập và phân tích các chỉ số hiệu suất trong điều kiện hoạt động bình thường để làm cơ sở so sánh khi có vấn đề.

## Các thành phần thu thập dữ liệu

### Amazon CloudWatch
Thu thập các chỉ số mặc định của RDS như:
- CPU Utilization
- Freeable Memory
- Database Connections
- Disk IOPS
- Network Throughput

### RDS Performance Insights
Thu thập các chỉ số chi tiết về:
- Tải cơ sở dữ liệu
- Các truy vấn SQL hàng đầu
- Sự kiện chờ (wait events)
- Host, user

### Slow Query Logs (RDS Parameter Group)
Bật và cấu hình để ghi lại các truy vấn vượt quá ngưỡng thời gian thực thi.

## Quá trình thực hiện

1. **Thu thập dữ liệu** trong một khoảng thời gian đủ dài (vài tuần đến một tháng) để bao quát các chu kỳ tải công việc khác nhau (giờ cao điểm, giờ thấp điểm).

2. **Xác định các giá trị** trung bình, đỉnh và phân phối cho các chỉ số quan trọng:
   - CPU trung bình 40%, đỉnh 70%
   - Số lượng kết nối trung bình 100, đỉnh 250

3. **Lập tài liệu** và biểu đồ hóa các đường cơ sở này.
