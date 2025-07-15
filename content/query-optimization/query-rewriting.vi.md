---
title: "Viết lại Truy vấn"
date: 2025-07-15T11:00:00+07:00
weight: 20
draft: false
---

# Viết lại Truy vấn - Nắm vững các mẫu tối ưu hóa truy vấn

Viết lại hoặc điều chỉnh cấu trúc của truy vấn SQL có thể ảnh hưởng lớn đến cách cơ sở dữ liệu thực thi chúng. Mục tiêu là giúp trình tối ưu hóa truy vấn (Query Optimizer) của cơ sở dữ liệu chọn một kế hoạch thực thi hiệu quả hơn.

## Các nguyên tắc cơ bản

### Tránh SELECT *
Chỉ chọn những cột bạn thực sự cần. Điều này giảm lượng dữ liệu đọc từ đĩa và truyền qua mạng.

### Sử dụng JOIN thay vì Subqueries (đối với một số trường hợp)

Đôi khi, subquery (truy vấn con) có thể được viết lại thành JOIN để cải thiện hiệu suất, đặc biệt là IN subquery.

**Ví dụ:**

Kém tối ưu:
```sql
SELECT * FROM orders 
WHERE customer_id IN (SELECT id FROM customers WHERE region = 'Asia');
```

Tối ưu hơn:
```sql
SELECT o.* FROM orders o 
JOIN customers c ON o.customer_id = c.id 
WHERE c.region = 'Asia';
```

### Tránh các phép toán hoặc hàm trên cột được lập chỉ mục trong WHERE

Nếu bạn áp dụng một hàm cho cột được lập chỉ mục trong mệnh đề WHERE, index đó sẽ không được sử dụng.

**Ví dụ:**

Kém tối ưu:
```sql
SELECT * FROM users WHERE YEAR(registration_date) = 2023;
-- (sẽ không dùng index trên registration_date)
```

Tối ưu hơn:
```sql
SELECT * FROM users 
WHERE registration_date BETWEEN '2023-01-01' AND '2023-12-31';
-- (có thể dùng index)
```

## Các kỹ thuật tối ưu hóa nâng cao

### Sử dụng LIMIT và OFFSET hiệu quả

Khi phân trang, OFFSET lớn có thể rất chậm vì MySQL vẫn phải đọc và loại bỏ nhiều hàng trước khi trả về kết quả.

**Kỹ thuật tối ưu hóa phân trang**: Sử dụng index và truy vấn con để lấy PRIMARY KEY của các hàng cần thiết trước, sau đó JOIN với bảng chính.

### Tối ưu hóa mệnh đề LIKE

- Nếu `LIKE '%value'`, index sẽ không được sử dụng
- Nếu `LIKE 'value%'`, index có thể được sử dụng
- Cân nhắc sử dụng Full-Text Search hoặc các giải pháp tìm kiếm chuyên dụng cho các tìm kiếm chuỗi phức tạp

### Sử dụng UNION ALL thay vì UNION

UNION ALL không loại bỏ các bản ghi trùng lặp, nên nhanh hơn UNION (trừ khi bạn thực sự cần loại bỏ trùng lặp).

### Tránh ORDER BY RAND()

Rất chậm trên tập dữ liệu lớn. Hãy sử dụng các phương pháp khác để lấy mẫu ngẫu nhiên (ví dụ: lấy một ID ngẫu nhiên trong một phạm vi rồi truy vấn ID đó).

## Tối ưu hóa cho các thao tác đọc và ghi

### Đọc (SELECT)
Tập trung vào index, tối ưu hóa JOIN và WHERE clause.

### Ghi (INSERT/UPDATE/DELETE)
Ít có khả năng tối ưu hóa bằng cách viết lại truy vấn nhiều, nhưng việc tối ưu hóa WHERE clause vẫn quan trọng để tìm các hàng cần cập nhật/xóa nhanh chóng. Đối với INSERT hàng loạt, hãy cân nhắc sử dụng `LOAD DATA INFILE` hoặc `INSERT INTO ... VALUES (),(),()...`.

## Công cụ

**EXPLAIN** là công cụ chính để xem liệu việc viết lại truy vấn có tạo ra một kế hoạch thực thi tốt hơn hay không.

---

*Tiếp theo: Tìm hiểu cách phân tích [Kế hoạch Thực thi](../execution-plans/) để hiểu hiệu suất truy vấn.*
