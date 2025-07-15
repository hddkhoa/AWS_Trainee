---
title: "Hiểu về Dashboard Performance Insights"
date: 2024-07-14
weight: 30
description: "Hướng dẫn đầy đủ về cách điều hướng và diễn giải dashboard Performance Insights"
---

## Tổng quan Dashboard

Dashboard Performance Insights cung cấp cái nhìn toàn diện về hiệu suất database với các phần chính:

### 1. Biểu đồ Database Load
Biểu đồ chính hiển thị database load theo thời gian, đo bằng Average Active Sessions (AAS).

**Các thành phần chính:**
- **Trục Y:** Database load (AAS)
- **Trục X:** Thời gian
- **Đường ngang:** Số vCPU (baseline hiệu suất)
- **Vùng màu:** Các loại wait event khác nhau

### 2. Panel Top Dimensions
Hiển thị các yếu tố đóng góp nhiều nhất vào database load:
- **Top SQL:** Các query tiêu tốn tài nguyên nhiều nhất
- **Top Wait Events:** Các wait event phổ biến nhất
- **Top Hosts:** Các host tạo ra load nhiều nhất
- **Top Users:** Các user tạo ra load nhiều nhất
- **Top Databases:** Các database có load cao nhất

## Diễn giải Biểu đồ Database Load

### Hiệu suất Tốt
```
DB Load (AAS)
     4 |                                    
     3 |     ████                          
     2 |  ████████████                     
     1 |████████████████████               
     0 |________________________________   
       0    5    10   15   20   25   30   Thời gian (phút)
       
Số vCPU: 4 (hiển thị bằng đường ngang)
Trạng thái: ✅ Tốt (Load < số vCPU)
```

### Vấn đề Hiệu suất
```
DB Load (AAS)
     8 |        ████████████               
     6 |     ████████████████              
     4 |  ████████████████████  ←── Giới hạn vCPU
     2 |████████████████████████           
     0 |________________________________   
       0    5    10   15   20   25   30   Thời gian (phút)
       
Trạng thái: ⚠️ Quá tải (Load > số vCPU)
```

## Phân tích Wait Events

### Wait Events phổ biến trong MySQL

#### 1. CPU
- **Màu:** Thường là đỏ/cam
- **Ý nghĩa:** Xử lý CPU đang hoạt động
- **Hành động:** Kiểm tra các query tiêu tốn CPU

#### 2. io/file/sql/binlog
- **Màu:** Xanh dương
- **Ý nghĩa:** Chờ ghi binary log
- **Hành động:** Cân nhắc storage nhanh hơn hoặc tối ưu write operations

#### 3. io/table/sql/handler
- **Màu:** Xanh lá
- **Ý nghĩa:** Chờ các thao tác I/O trên table
- **Hành động:** Kiểm tra indexes, cân nhắc read replicas

#### 4. synch/mutex/innodb
- **Màu:** Tím
- **Ý nghĩa:** Khóa nội bộ InnoDB
- **Hành động:** Tối ưu transactions, giảm lock contention

### Wait Events phổ biến trong PostgreSQL

#### 1. CPU
- **Ý nghĩa:** Xử lý CPU đang hoạt động
- **Hành động:** Tối ưu queries, kiểm tra full table scans

#### 2. IO:DataFileRead
- **Ý nghĩa:** Đọc dữ liệu từ disk
- **Hành động:** Tăng shared_buffers, thêm indexes

#### 3. Lock:relation
- **Ý nghĩa:** Chờ table locks
- **Hành động:** Tối ưu transactions, giảm thời gian lock

#### 4. LWLock:buffer_mapping
- **Ý nghĩa:** Tranh chấp quản lý buffer
- **Hành động:** Tăng shared_buffers, tối ưu queries

## Phân tích Top SQL

### Chi tiết SQL Statement
Khi bạn click vào một SQL statement, bạn sẽ thấy:

1. **SQL Text:** Query thực tế (có thể bị cắt ngắn)
2. **Thống kê:**
   - Đóng góp load
   - Số lần thực thi mỗi phút
   - Độ trễ trung bình
   - Số rows examined/returned

3. **Xu hướng Hiệu suất:**
   - Load theo thời gian
   - Tần suất thực thi
   - Xu hướng độ trễ

### Ví dụ Phân tích
```sql
-- Ví dụ query có load cao
SELECT * FROM orders o 
JOIN customers c ON o.customer_id = c.id 
WHERE o.order_date > '2024-01-01'
ORDER BY o.order_date DESC;

Thống kê:
- Load: 2.5 AAS (50% tổng load)
- Thực thi: 120/phút
- Độ trễ TB: 1.2s
- Rows Examined: 1.2M
- Rows Returned: 15K
```

**Cơ hội Tối ưu hóa:**
- Thêm index trên `order_date`
- Cân nhắc phân vùng theo date range
- Giới hạn kích thước kết quả
- Sử dụng covering indexes

## Chọn Khoảng Thời gian

### Các Khoảng Thời gian Có sẵn
- **Giờ qua:** Troubleshooting real-time
- **3 giờ qua:** Phân tích hiệu suất gần đây
- **Ngày qua:** Phân tích pattern hàng ngày
- **Tuần qua:** Phân tích xu hướng hàng tuần
- **Tùy chỉnh:** Điều tra sự cố cụ thể

### Tùy chọn Granularity
- **5 phút:** Mặc định cho free tier
- **1 phút:** Có sẵn với extended retention
- **1 giờ:** Cho phân tích xu hướng dài hạn

## Lọc và Drill-Down

### Tùy chọn Lọc
1. **Theo SQL ID:** Tập trung vào queries cụ thể
2. **Theo User:** Phân tích load theo user
3. **Theo Host:** Xác định hosts có vấn đề
4. **Theo Database:** Phân tích multi-database

### Quy trình Drill-Down
1. **Xác định thời điểm high-load** trong biểu đồ chính
2. **Click vào khoảng thời gian** để zoom in
3. **Chọn top dimension** (SQL, Wait Event, v.v.)
4. **Phân tích contributor cụ thể**
5. **Xem thống kê chi tiết**

## Mẹo Điều hướng Dashboard

### 1. Bắt đầu với Bức tranh Tổng thể
- Xem xu hướng load tổng thể
- Xác định thời điểm peak usage
- Kiểm tra xem load có vượt quá số vCPU không

### 2. Xác định Top Contributors
- Kiểm tra Top SQL cho expensive queries
- Xem Top Wait Events cho bottlenecks
- Review Top Users/Hosts cho nguồn load

### 3. Tương quan Metrics
- Khớp thời điểm high load với SQL cụ thể
- Tương quan wait events với query patterns
- Tìm các vấn đề hiệu suất lặp lại

### 4. Sử dụng Time Correlation
- So sánh hiệu suất hiện tại với lịch sử
- Xác định patterns hàng ngày/tuần
- Phát hiện xu hướng suy giảm hiệu suất

## Patterns Dashboard Phổ biến

### 1. CPU Bound Workload
```
Wait Events:
├── CPU: 70%
├── Lock waits: 20%
└── I/O waits: 10%

Hành động: Tối ưu các query tiêu tốn CPU
```

### 2. I/O Bound Workload
```
Wait Events:
├── I/O operations: 60%
├── CPU: 25%
└── Lock waits: 15%

Hành động: Thêm indexes, tối ưu storage
```

### 3. Lock Contention
```
Wait Events:
├── Lock waits: 50%
├── CPU: 30%
└── I/O operations: 20%

Hành động: Tối ưu transactions, giảm thời gian lock
```

## Troubleshooting với Dashboard

### Tình huống 1: Suy giảm Hiệu suất Đột ngột
1. **Kiểm tra timeline** khi vấn đề bắt đầu
2. **So sánh wait events** trước/sau sự cố
3. **Xác định SQL statements mới** hoặc thay đổi
4. **Tìm patterns cạn kiệt tài nguyên**

### Tình huống 2: Suy giảm Hiệu suất Dần dần
1. **Sử dụng khoảng thời gian dài** (tuần/tháng)
2. **Tìm trending metrics** (load tăng dần)
3. **Kiểm tra impact của data growth**
4. **Xác định nhu cầu capacity planning**

### Tình huống 3: Vấn đề Không liên tục
1. **Sử dụng granularity chi tiết** (1 phút)
2. **Tìm spike patterns**
3. **Tương quan với application events**
4. **Kiểm tra impact của batch jobs**

## Best Practices

### 1. Giám sát Thường xuyên
- Kiểm tra dashboard hàng ngày trong giờ làm việc
- Thiết lập automated alerts cho key thresholds
- Review xu hướng hiệu suất hàng tuần

### 2. Thiết lập Baseline
- Ghi chép patterns hiệu suất bình thường
- Xác định thời điểm peak usage
- Đặt mục tiêu hiệu suất thực tế

### 3. Phân tích Proactive
- Giám sát trending metrics
- Xác định suy giảm hiệu suất sớm
- Lập kế hoạch nâng cấp capacity proactively

### 4. Tài liệu hóa
- Ghi chép các sự cố hiệu suất
- Theo dõi kết quả tối ưu hóa
- Duy trì performance runbooks

## Tích hợp với Công cụ Khác

### Tích hợp CloudWatch
- Thiết lập alarms cho key Performance Insights metrics
- Tạo custom dashboards kết hợp PI và CloudWatch
- Sử dụng CloudWatch Logs cho phân tích query chi tiết

### Application Monitoring
- Tương quan hiệu suất database với application metrics
- Theo dõi end-to-end request latency
- Giám sát connection pool utilization

### Database Logs
- Sử dụng slow query logs cho phân tích chi tiết
- Bật general query log cho troubleshooting
- Tương quan log entries với Performance Insights data

## Bước tiếp theo

1. **[Tối ưu hóa Query](../optimization/)** - Học kỹ thuật tối ưu hóa query
2. **[Thiết lập Alerting](../alerting/)** - Thiết lập performance alerts
3. **[Best Practices](../best-practices/)** - Tuân theo performance best practices
