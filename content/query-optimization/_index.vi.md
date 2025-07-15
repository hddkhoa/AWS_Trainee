---
title: "6. Kỹ thuật Tối ưu hóa Truy vấn"
date: 2025-07-14T14:00:00+07:00
weight: 60
chapter: true
pre: "<b>6. </b>"
draft: false
---

### Chương 6

# Kỹ thuật Tối ưu hóa Truy vấn

Các phương pháp để cải thiện hiệu suất của các truy vấn SQL.

## Mục tiêu

Giảm thời gian thực thi truy vấn, giảm tài nguyên tiêu thụ.

## Các nguồn phát hiện vấn đề

### RDS Performance Insights
Xác định các truy vấn SQL tiêu tốn nhiều tài nguyên nhất (Top SQL).

### Slow Query Logs
Các truy vấn vượt quá ngưỡng thời gian được ghi lại.

### Database Activity Streams (DAS)
(Với Aurora và RDS cho PostgreSQL) Cung cấp luồng hoạt động DB chi tiết để phân tích sâu hơn.

## Các kỹ thuật tối ưu hóa

### 1. Tối ưu hóa Index

#### Tạo Index phù hợp
- Các cột trong mệnh đề WHERE
- Các cột trong JOIN
- Các cột trong ORDER BY, GROUP BY

#### Quản lý Index
- Xóa các index không sử dụng
- Sử dụng Covering Index để tối thiểu hóa việc truy cập bảng

```sql
-- Ví dụ tạo covering index
CREATE INDEX idx_order_covering 
ON orders (customer_id, order_date) 
INCLUDE (total_amount, status);
```

### 2. Viết lại Truy vấn (Query Rewriting)

#### Best Practices
- Tránh `SELECT *`
- Tối ưu hóa mệnh đề JOIN (chọn đúng loại JOIN, thứ tự JOIN)
- Tránh các hàm trên cột có index trong mệnh đề WHERE
- Sử dụng `UNION ALL` thay vì `UNION` nếu không cần loại bỏ trùng lặp
- Tối ưu hóa GROUP BY và ORDER BY

```sql
-- Thay vì
SELECT * FROM orders WHERE YEAR(order_date) = 2023;

-- Sử dụng
SELECT order_id, customer_id, total_amount 
FROM orders 
WHERE order_date >= '2023-01-01' 
  AND order_date < '2024-01-01';
```

### 3. Tối ưu hóa Schema

#### Lựa chọn kiểu dữ liệu
- Chọn kiểu dữ liệu phù hợp (ví dụ: dùng INT thay vì BIGINT nếu đủ)
- Chuẩn hóa/Phi chuẩn hóa phù hợp với workload

#### Phân vùng bảng (Table Partitioning)
Cho các bảng lớn để cải thiện hiệu suất truy vấn.

### 4. Sử dụng Caching

#### Application-level Caching
Cache kết quả truy vấn ở tầng ứng dụng:
- Redis
- Memcached

#### Database-level Caching
Tự động bởi RDS, nhưng cần tối ưu hóa truy vấn để tận dụng.
