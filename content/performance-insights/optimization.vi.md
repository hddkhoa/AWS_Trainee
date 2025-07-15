---
title: "Tối ưu hóa Query với Performance Insights"
date: 2024-07-14
weight: 40
description: "Học cách sử dụng Performance Insights để xác định và tối ưu hóa các query chậm"
---

## Quy trình Tối ưu hóa Query

Sử dụng Performance Insights để tối ưu hóa query theo cách tiếp cận có hệ thống:

1. **Xác định các query có vấn đề** sử dụng Top SQL
2. **Phân tích patterns thực thi query** và wait events
3. **Điều tra execution plans của query**
4. **Áp dụng kỹ thuật tối ưu hóa**
5. **Giám sát kết quả tối ưu hóa**

## Xác định Queries có Vấn đề

### Sử dụng Panel Top SQL

Panel Top SQL hiển thị các query được xếp hạng theo đóng góp vào database load:

```
Top SQL (theo Load)
┌─────────────────────────────────────────────────────────┐
│ SQL ID: 0x1A2B3C4D5E6F | Load: 3.2 AAS (40%)          │
│ SELECT * FROM orders WHERE order_date > ?               │
│ Thực thi: 150/phút | Độ trễ TB: 1.8s                   │
├─────────────────────────────────────────────────────────┤
│ SQL ID: 0x2B3C4D5E6F7A | Load: 2.1 AAS (26%)          │
│ UPDATE inventory SET quantity = ? WHERE product_id = ?  │
│ Thực thi: 80/phút | Độ trễ TB: 2.3s                    │
└─────────────────────────────────────────────────────────┘
```

### Metrics Chính cần Tập trung

1. **Đóng góp Load Cao:** Queries đóng góp >10% tổng load
2. **Tần suất Thực thi Cao:** Queries chạy >100 lần/phút
3. **Độ trễ Trung bình Cao:** Queries mất >1 giây trung bình
4. **Xu hướng Tăng:** Queries có load tăng theo thời gian

## Kỹ thuật Phân tích Query

### 1. Phân tích Thống kê Thực thi

Với mỗi query có vấn đề, phân tích:

```sql
-- Ví dụ query có vấn đề
SELECT o.*, c.name, c.email 
FROM orders o 
JOIN customers c ON o.customer_id = c.id 
WHERE o.order_date >= '2024-01-01' 
ORDER BY o.order_date DESC 
LIMIT 100;

Metrics Performance Insights:
- Load: 2.5 AAS (31% tổng)
- Thực thi: 200/phút
- Độ trễ TB: 1.2s
- Rows Examined: 500K
- Rows Returned: 100
```

**Phân tích:**
- Tỷ lệ rows examined vs returned cao (5000:1)
- Gợi ý thiếu hoặc indexes không hiệu quả
- ORDER BY không có index gây filesort

### 2. Phân tích Wait Events

Kiểm tra query đang chờ gì:

```
Wait Events cho SQL ID 0x1A2B3C4D5E6F:
├── io/table/sql/handler: 60% (I/O operations)
├── filesort: 25% (Sorting không có index)
├── CPU: 10% (Xử lý)
└── synch/mutex/innodb: 5% (Lock contention)
```

**Diễn giải:**
- I/O waits cao gợi ý thiếu indexes
- Filesort waits chỉ ra cần tối ưu ORDER BY
- CPU thấp cho thấy không bị computation-bound

## Kỹ thuật Tối ưu hóa Phổ biến

### 1. Tối ưu hóa Index

#### Phát hiện Index Thiếu
```sql
-- Trước tối ưu hóa
SELECT * FROM orders 
WHERE order_date >= '2024-01-01' 
  AND status = 'pending';

-- Performance Insights hiển thị:
-- - High io/table/sql/handler waits
-- - Rows examined: 1M, Rows returned: 1K

-- Thêm composite index
CREATE INDEX idx_orders_date_status 
ON orders(order_date, status);

-- Sau tối ưu hóa:
-- - Rows examined: 1K, Rows returned: 1K
-- - Độ trễ giảm từ 2.1s xuống 0.05s
```

#### Triển khai Covering Index
```sql
-- Các cột được truy cập thường xuyên
SELECT order_id, customer_id, order_date, total_amount 
FROM orders 
WHERE status = 'completed' 
  AND order_date >= '2024-01-01';

-- Tạo covering index
CREATE INDEX idx_orders_covering 
ON orders(status, order_date, order_id, customer_id, total_amount);

-- Lợi ích:
-- - Loại bỏ table lookups
-- - Giảm I/O operations
-- - Cải thiện hiệu suất query 70%
```

### 2. Viết lại Query

#### Tránh SELECT *
```sql
-- Query có vấn đề
SELECT * FROM products p 
JOIN categories c ON p.category_id = c.id 
WHERE p.price > 100;

-- Query được tối ưu
SELECT p.id, p.name, p.price, c.name as category_name 
FROM products p 
JOIN categories c ON p.category_id = c.id 
WHERE p.price > 100;

-- Cải thiện hiệu suất:
-- - Giảm data transfer
-- - Sử dụng memory thấp hơn
-- - Truyền tải mạng nhanh hơn
```

#### Tối ưu hóa JOINs
```sql
-- Thứ tự JOIN không hiệu quả
SELECT o.order_id, c.name, p.product_name 
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
JOIN customers c ON o.customer_id = c.customer_id 
WHERE o.order_date >= '2024-01-01';

-- Tối ưu với thứ tự JOIN và điều kiện phù hợp
SELECT o.order_id, c.name, p.product_name 
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id 
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
WHERE o.order_date >= '2024-01-01' 
  AND o.status = 'completed';
```

### 3. Tối ưu hóa Pagination

#### OFFSET Pagination Không hiệu quả
```sql
-- Có vấn đề với offset lớn
SELECT * FROM orders 
ORDER BY order_date DESC 
LIMIT 20 OFFSET 10000;

-- Performance Insights hiển thị:
-- - High filesort waits
-- - Độ trễ tăng với offset lớn hơn
```

#### Cursor-based Pagination
```sql
-- Cách tiếp cận cursor-based hiệu quả
SELECT * FROM orders 
WHERE order_date < '2024-01-15 10:30:00' 
ORDER BY order_date DESC 
LIMIT 20;

-- Lợi ích:
-- - Hiệu suất ổn định bất kể trang nào
-- - Sử dụng index hiệu quả
-- - Loại bỏ filesort operations
```

## Tối ưu hóa Theo Database Cụ thể

### Tối ưu hóa MySQL

#### Cấu hình InnoDB
```sql
-- Kiểm tra cài đặt hiện tại
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'innodb_log_file_size';

-- Tối ưu cho workload của bạn
SET GLOBAL innodb_buffer_pool_size = 1073741824; -- 1GB
SET GLOBAL innodb_log_buffer_size = 16777216;    -- 16MB
```

#### Query Cache (MySQL 5.7 và cũ hơn)
```sql
-- Bật query cache cho read-heavy workloads
SET GLOBAL query_cache_type = ON;
SET GLOBAL query_cache_size = 268435456; -- 256MB

-- Giám sát hiệu quả cache
SHOW STATUS LIKE 'Qcache%';
```

### Tối ưu hóa PostgreSQL

#### Tuning Cấu hình
```sql
-- Tối ưu shared_buffers
ALTER SYSTEM SET shared_buffers = '256MB';

-- Tối ưu work_mem cho sorting/hashing
ALTER SYSTEM SET work_mem = '4MB';

-- Tối ưu effective_cache_size
ALTER SYSTEM SET effective_cache_size = '1GB';

-- Reload cấu hình
SELECT pg_reload_conf();
```

#### Statistics và Vacuum
```sql
-- Cập nhật table statistics
ANALYZE orders;

-- Vacuum để reclaim space
VACUUM ANALYZE orders;

-- Cấu hình auto-vacuum
ALTER SYSTEM SET autovacuum = on;
ALTER SYSTEM SET autovacuum_vacuum_scale_factor = 0.1;
```

## Giám sát Kết quả Tối ưu hóa

### So sánh Trước và Sau

Theo dõi các metrics này trong Performance Insights:

```
Kết quả Tối ưu hóa Query:
┌─────────────────────────────────────────────────────────┐
│                    TRƯỚC     │    SAU     │ CẢI THIỆN   │
├─────────────────────────────────────────────────────────┤
│ Load (AAS)         │  2.5    │    0.3     │    -88%     │
│ Độ trễ TB          │  1.8s   │    0.2s    │    -89%     │
│ Thực thi/phút      │  150    │    150     │     0%      │
│ Rows Examined      │  500K   │    1K      │    -99.8%   │
│ CPU Wait %         │  15%    │    60%     │   Thay đổi  │
│ I/O Wait %         │  70%    │    25%     │   Giảm      │
└─────────────────────────────────────────────────────────┘
```

### Giám sát Dài hạn

Thiết lập giám sát cho:

1. **Xu hướng Hiệu suất Query**
   - Theo dõi độ trễ theo thời gian
   - Giám sát thay đổi tần suất thực thi
   - Theo dõi performance regressions

2. **Sử dụng Tài nguyên**
   - Patterns sử dụng CPU
   - Xu hướng I/O operations
   - Sử dụng memory

3. **Thay đổi Wait Events**
   - Chuyển từ I/O sang CPU waits (tốt)
   - Xuất hiện wait events mới
   - Patterns lock contention

## Workflow Tối ưu hóa

### 1. Giai đoạn Xác định
```bash
# Sử dụng Performance Insights để xác định top queries
# Tập trung vào queries có:
# - Load > 10% tổng
# - Độ trễ > 1 giây
# - Tần suất thực thi cao
```

### 2. Giai đoạn Phân tích
```sql
-- Lấy query execution plan
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM orders WHERE order_date > '2024-01-01';

-- Kiểm tra sử dụng index
SHOW INDEX FROM orders;

-- Phân tích table statistics
SHOW TABLE STATUS LIKE 'orders';
```

### 3. Giai đoạn Tối ưu hóa
```sql
-- Áp dụng tối ưu hóa
CREATE INDEX idx_orders_date ON orders(order_date);

-- Viết lại query nếu cần
SELECT order_id, customer_id, total_amount 
FROM orders 
WHERE order_date > '2024-01-01';
```

### 4. Giai đoạn Validation
```bash
# Giám sát trong Performance Insights cho:
# - Giảm query load
# - Cải thiện độ trễ
# - Thay đổi wait event patterns
# - Hiệu suất database tổng thể
```

## Best Practices

### 1. Cách tiếp cận Có hệ thống
- Luôn đo lường trước khi tối ưu
- Tập trung vào queries có impact cao nhất trước
- Test tối ưu hóa trong staging environment
- Giám sát kết quả theo thời gian

### 2. Chiến lược Index
- Tạo indexes dựa trên query patterns
- Tránh over-indexing (ảnh hưởng writes)
- Sử dụng composite indexes hiệu quả
- Bảo trì index thường xuyên

### 3. Thiết kế Query
- Chỉ select các cột cần thiết
- Sử dụng WHERE clauses phù hợp
- Tối ưu JOIN conditions
- Cân nhắc query caching

### 4. Giám sát Liên tục
- Review Performance Insights thường xuyên
- Thiết lập alerts cho performance degradation
- Theo dõi kết quả tối ưu hóa
- Lập kế hoạch cho capacity growth

## Lỗi Phổ biến

### 1. Over-Optimization
- Thêm quá nhiều indexes
- Tối ưu hóa sớm
- Bỏ qua impact đến write performance

### 2. Phân tích Không đầy đủ
- Chỉ tập trung vào individual queries
- Bỏ qua overall system impact
- Không cân nhắc concurrent workloads

### 3. Thiếu Giám sát
- Không theo dõi kết quả tối ưu hóa
- Bỏ lỡ performance regressions
- Thiết lập alerting không đầy đủ

## Bước tiếp theo

1. **[Performance Alerting](../alerting/)** - Thiết lập performance alerts
2. **[Capacity Planning](../capacity-planning/)** - Lập kế hoạch cho tăng trưởng tương lai
3. **[Best Practices](../best-practices/)** - Tuân theo optimization best practices
