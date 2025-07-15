---
title: "Tổng quan"
date: 2025-07-11T11:00:00+07:00
weight: 5
draft: false
---

# Tổng quan tối ưu hóa truy vấn

## 🎯 Tối ưu hóa truy vấn là gì?

Tối ưu hóa truy vấn là quá trình cải thiện hiệu suất truy vấn cơ sở dữ liệu thông qua các kỹ thuật khác nhau bao gồm tối ưu hóa chỉ mục, viết lại truy vấn và phân tích kế hoạch thực thi.

> **Thông tin**: Tối ưu hóa truy vấn hiệu quả có thể cải thiện hiệu suất 70% hoặc hơn trong khi giảm tiêu thụ tài nguyên.

---

## 🚀 Kỹ thuật tối ưu hóa

### 1. Tối ưu hóa chỉ mục
- **Composite Indexes**: Chỉ mục nhiều cột cho các truy vấn phức tạp
- **Partial Indexes**: Chỉ mục với điều kiện WHERE
- **Covering Indexes**: Bao gồm tất cả các cột cần thiết
- **Index Maintenance**: Giám sát và dọn dẹp thường xuyên

### 2. Viết lại truy vấn
- **Subquery Optimization**: Chuyển đổi thành JOINs khi phù hợp
- **Window Functions**: Thay thế nhiều truy vấn GROUP BY
- **CTE Usage**: Common Table Expressions cho logic phức tạp
- **LIMIT Usage**: Giảm kích thước tập kết quả

### 3. Phân tích kế hoạch thực thi
- **EXPLAIN Analysis**: Hiểu việc thực thi truy vấn
- **Cost Analysis**: Xác định các hoạt động tốn kém
- **Join Optimization**: Chọn loại join phù hợp
- **Sort Optimization**: Giảm thiểu các hoạt động sắp xếp

---

## 📊 Tác động hiệu suất

### Trước và sau tối ưu hóa

| Chỉ số | Trước | Sau | Cải thiện |
|--------|-------|-----|-----------|
| **Thời gian phản hồi truy vấn** | 3-5 giây | 1-1.5 giây | **70%** |
| **Sử dụng tài nguyên** | CPU/IO cao | Được tối ưu | **60%** |
| **Thông lượng** | 100 QPS | 250 QPS | **150%** |
| **Tỷ lệ trúng chỉ mục** | 75% | 95% | **27%** |

---

## 🎯 Chiến lược tối ưu hóa

### Giai đoạn 1: Xác định nút thắt
1. **Giám sát các truy vấn chậm** sử dụng Performance Insights
2. **Phân tích kế hoạch thực thi** cho các hoạt động tốn kém
3. **Xác định chỉ mục bị thiếu** thông qua các mẫu truy vấn
4. **Xem xét thống kê bảng** và phân phối dữ liệu

### Giai đoạn 2: Triển khai tối ưu hóa
1. **Tạo chỉ mục có mục tiêu** cho các truy vấn chậm
2. **Viết lại các truy vấn không hiệu quả** sử dụng best practices
3. **Tối ưu hóa các hoạt động JOIN** và điều kiện
4. **Triển khai caching kết quả truy vấn** khi phù hợp

### Giai đoạn 3: Giám sát và xác thực
1. **Đo lường cải thiện hiệu suất** sử dụng các chỉ số
2. **Giám sát thay đổi sử dụng tài nguyên**
3. **Xác thực logic business** vẫn đúng
4. **Tài liệu hóa các thay đổi tối ưu hóa** để tham khảo trong tương lai

---

## 💡 Chiến thắng nhanh

> **Chiến thắng nhanh #1**: Thêm chỉ mục trên các cột được lọc thường xuyên - có thể cung cấp cải thiện hiệu suất ngay lập tức 50-80%.

> **Chiến thắng nhanh #2**: Sử dụng mệnh đề LIMIT để giảm kích thước tập kết quả - đặc biệt hiệu quả cho các truy vấn phân trang.

> **Chiến thắng nhanh #3**: Thay thế SELECT * bằng tên cột cụ thể - giảm I/O và network overhead.

---

## 🔧 Công cụ tối ưu hóa

### PostgreSQL
```sql
-- Phân tích truy vấn
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM orders WHERE customer_id = 123;

-- Tìm các truy vấn chậm
SELECT query, mean_time, calls 
FROM pg_stat_statements 
ORDER BY mean_time DESC 
LIMIT 10;

-- Kiểm tra sử dụng chỉ mục
SELECT schemaname, tablename, indexname, idx_scan, idx_tup_read, idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

### MySQL
```sql
-- Phân tích truy vấn
EXPLAIN FORMAT=JSON SELECT * FROM orders WHERE customer_id = 123;

-- Tìm các truy vấn chậm
SELECT DIGEST_TEXT, AVG_TIMER_WAIT/1000000000 as avg_time_sec, COUNT_STAR
FROM performance_schema.events_statements_summary_by_digest
ORDER BY AVG_TIMER_WAIT DESC
LIMIT 10;

-- Kiểm tra sử dụng chỉ mục
SHOW INDEX FROM orders;
```

---

## 📈 Các mẫu tối ưu hóa phổ biến

### 1. Tối ưu hóa JOIN
```sql
-- Trước: Subquery không hiệu quả
SELECT * FROM customers 
WHERE id IN (SELECT customer_id FROM orders WHERE total > 1000);

-- Sau: JOIN hiệu quả hơn
SELECT DISTINCT c.* FROM customers c
INNER JOIN orders o ON c.id = o.customer_id
WHERE o.total > 1000;
```

### 2. Tối ưu hóa phân trang
```sql
-- Trước: OFFSET không hiệu quả cho trang lớn
SELECT * FROM products ORDER BY created_at OFFSET 10000 LIMIT 20;

-- Sau: Cursor-based pagination
SELECT * FROM products 
WHERE created_at > '2023-01-01 10:00:00'
ORDER BY created_at LIMIT 20;
```

### 3. Tối ưu hóa COUNT
```sql
-- Trước: COUNT(*) chậm trên bảng lớn
SELECT COUNT(*) FROM orders WHERE status = 'completed';

-- Sau: Sử dụng approximate count hoặc cached value
SELECT reltuples::BIGINT AS estimate
FROM pg_class
WHERE relname = 'orders';
```

---

## 🎯 Best Practices

### Thiết kế truy vấn
1. **Sử dụng WHERE clauses hiệu quả**: Đặt điều kiện selective nhất trước
2. **Tránh SELECT ***: Chỉ chọn các cột cần thiết
3. **Sử dụng LIMIT**: Giới hạn kết quả khi có thể
4. **Tối ưu hóa ORDER BY**: Sử dụng chỉ mục cho sorting

### Thiết kế chỉ mục
1. **Chỉ mục composite**: Thứ tự cột quan trọng
2. **Chỉ mục covering**: Bao gồm tất cả cột cần thiết
3. **Chỉ mục partial**: Cho các điều kiện cụ thể
4. **Bảo trì chỉ mục**: Xóa các chỉ mục không sử dụng

### Giám sát hiệu suất
1. **Theo dõi slow queries**: Thiết lập thresholds phù hợp
2. **Phân tích execution plans**: Hiểu chi phí truy vấn
3. **Giám sát resource usage**: CPU, I/O, memory
4. **Benchmark thường xuyên**: So sánh hiệu suất theo thời gian

---

## 🔗 Bước tiếp theo

1. **[Chiến lược chỉ mục](index-strategies/)** - Học các kỹ thuật indexing nâng cao
2. **[Viết lại truy vấn](query-rewriting/)** - Thành thạo các mẫu tối ưu hóa truy vấn
3. **[Kế hoạch thực thi](execution-plans/)** - Hiểu và phân tích query plans
