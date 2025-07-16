---
title: "4.1 Thiết lập CloudWatch Dashboard"
date: 2025-07-14
weight: 10
draft: false
---

# Thiết lập CloudWatch Dashboard

## Bước 1: Truy cập CloudWatch
1. Tìm kiếm "CloudWatch" trong AWS Console
2. Click vào "Amazon CloudWatch"

## Bước 2: Tạo Dashboard
<img src="/images/2025-07-14_16-15-20.png" alt="2025-07-14_16-15-20" width="800">

1. Trong menu bên trái, click "Dashboards"
2. Click "Create dashboard"

<img src="/images/2025-07-14_16-16-13.png" alt="2025-07-14_16-16-13" width="800">

3. Dashboard name: RDS-Performance-Dashboard
4. Click "Create dashboard"


## Bước 3: Thêm Widget đầu tiên - CPU Utilization
<img src="/images/2025-07-14_16-17-19.png" alt="2025-07-14_16-17-19" width="800">

1. Chọn "Line" widget type
2. Click "Next"

<img src="/images/2025-07-14_16-25-18.png" alt="2025-07-14_16-25-18" width="800">

3. Metrics:
   • **Namespace:** AWS/RDS
   • **Metric name:** CPUUtilization
   • **DBInstanceIdentifier:** Chọn instance vừa tạo
4. Period: 5 minutes
5. Click "Create widget"


## Bước 4: Thêm Widget thứ hai - Database Connections


1. Click "Add widget"
2. Chọn "Line" → "Next"
3. Metrics:
   • **Namespace:** AWS/RDS
   • **Metric name:** DatabaseConnections
   • **DBInstanceIdentifier:** Chọn instance của bạn
4. Click "Create widget"


## Bước 5: Thêm Widget thứ ba - Free Memory


1. Click "Add widget"
2. Chọn "Line" → "Next"
3. Metrics:
   • **Namespace:** AWS/RDS
   • **Metric name:** FreeableMemory
   • **DBInstanceIdentifier:** Chọn instance của bạn
4. Click "Create widget"


## Bước 6: Thêm Widget bổ sung

### Widget Read/Write IOPS


1. Click "Add widget"
2. Chọn "Line" → "Next"
3. Thêm hai metrics:
   • **ReadIOPS:** Số lượng read operations per second
   • **WriteIOPS:** Số lượng write operations per second
4. Click "Create widget"

### Widget Read/Write Latency
1. Click "Add widget"
2. Chọn "Line" → "Next"
3. Thêm hai metrics:
   • **ReadLatency:** Độ trễ read operations
   • **WriteLatency:** Độ trễ write operations
4. Click "Create widget"

### Widget Network Throughput
1. Click "Add widget"
2. Chọn "Line" → "Next"
3. Thêm hai metrics:
   • **NetworkReceiveThroughput:** Lưu lượng mạng nhận
   • **NetworkTransmitThroughput:** Lưu lượng mạng gửi
4. Click "Create widget"


## Bước 7: Tùy chỉnh Dashboard

### Sắp xếp Widgets
1. Kéo thả các widgets để sắp xếp theo ý muốn
2. Resize widgets bằng cách kéo góc
3. Nhóm các metrics liên quan gần nhau

### Thiết lập Time Range
1. Ở góc trên bên phải, chọn time range:
   • **1h** - 1 giờ
   • **3h** - 3 giờ
   • **12h** - 12 giờ
   • **1d** - 1 ngày
   • **3d** - 3 ngày
   • **1w** - 1 tuần

### Auto Refresh
1. Click vào biểu tượng refresh
2. Chọn auto refresh interval:
   • **10s** - 10 giây
   • **1m** - 1 phút
   • **2m** - 2 phút
   • **5m** - 5 phút
   • **15m** - 15 phút

## Bước 8: Lưu và Chia sẻ Dashboard

<img src="/images/2025-07-14_16-30-33.png" alt="2025-07-14_16-30-33" width="800">

### Lưu Dashboard
1. Click "Save dashboard"
2. Dashboard sẽ được lưu tự động

### Chia sẻ Dashboard
1. Click "Share dashboard"
2. Chọn permissions:
   • **Public:** Ai cũng có thể xem
   • **Account:** Chỉ account hiện tại
   • **Specific users:** Chỉ users được chỉ định

### Export Dashboard
1. Click "Actions" → "View/edit source"
2. Copy JSON configuration
3. Có thể import vào account khác

## Bước 9: Best Practices

### Tổ chức Widgets
1. **Nhóm theo chức năng:**
   • Performance metrics (CPU, Memory)
   • I/O metrics (IOPS, Latency)
   • Network metrics (Throughput)
   • Connection metrics (Connections, Queries)

2. **Sử dụng màu sắc nhất quán:**
   • Đỏ: Critical metrics
   • Vàng: Warning metrics
   • Xanh: Normal metrics

### Monitoring Strategy
1. **Real-time monitoring:** 1-5 phút intervals
2. **Historical analysis:** 1 giờ - 1 tuần
3. **Capacity planning:** 1 tháng - 1 năm
4. **Alerting:** Thiết lập thresholds phù hợp

### Performance Optimization
1. **Giới hạn số widgets:** Không quá 20 widgets/dashboard
2. **Sử dụng appropriate time ranges:** Không query quá nhiều data points
3. **Group related metrics:** Dễ dàng phân tích và so sánh
