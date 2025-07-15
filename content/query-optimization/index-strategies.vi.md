---
title: "Chiến lược Index"
date: 2025-07-15T11:00:00+07:00
weight: 10
draft: false
---

# Chiến lược Index - Học các kỹ thuật lập chỉ mục nâng cao

Việc sử dụng index hiệu quả là yếu tố quan trọng nhất để tăng tốc độ truy vấn. Một index giống như mục lục của một cuốn sách, giúp cơ sở dữ liệu tìm kiếm dữ liệu nhanh hơn mà không cần quét toàn bộ bảng.

## Tầm quan trọng của Index

Khi một truy vấn được thực thi, nếu không có index phù hợp, cơ sở dữ liệu phải thực hiện quét toàn bộ bảng (full table scan) để tìm kiếm dữ liệu, đặc biệt tốn kém với bảng lớn. Index giúp cơ sở dữ liệu định vị các hàng dữ liệu cần thiết một cách trực tiếp hơn.

## Các loại Index cơ bản

### Primary Key Index (Index Khóa Chính)
- Tự động tạo khi bạn định nghĩa khóa chính
- Đảm bảo tính duy nhất và không cho phép giá trị NULL

### Unique Index (Index Duy nhất)
- Đảm bảo tất cả các giá trị trong cột được lập chỉ mục là duy nhất
- Cho phép một giá trị NULL duy nhất

### Non-Unique Index (Index Không duy nhất)
- Index thông thường, cho phép các giá trị trùng lặp

## Các kỹ thuật Index nâng cao

### Composite Indexes (Index Hợp phần/Đa cột)

Tạo index trên nhiều cột:
```sql
CREATE INDEX idx_name_dob ON users (last_name, first_name, date_of_birth);
```

**Thứ tự cột rất quan trọng**: Thứ tự của các cột trong index phải phù hợp với các cột trong mệnh đề WHERE, ORDER BY, và GROUP BY của truy vấn để đạt hiệu quả tối đa.

Ví dụ:
- `WHERE last_name = 'Smith' AND first_name = 'John'` sẽ sử dụng được index trên (last_name, first_name)
- `WHERE first_name = 'John'` sẽ không tận dụng được hoàn toàn index này (chỉ sử dụng được phần đầu của index nếu có)

**Tối ưu hóa "Leftmost Prefix"**: Index hợp phần chỉ hiệu quả khi bạn sử dụng các cột từ bên trái sang phải của index trong mệnh đề WHERE của bạn.

### Covering Indexes (Index Bao phủ)

Một index bao phủ là một index chứa tất cả các cột mà truy vấn cần (trong mệnh đề SELECT, WHERE, ORDER BY, GROUP BY).

Khi có một index bao phủ, cơ sở dữ liệu không cần phải truy cập bảng gốc để lấy thêm dữ liệu, giúp tăng tốc độ đáng kể.

Ví dụ:
```sql
SELECT first_name, last_name FROM users WHERE last_name = 'Smith';
```

Có thể được bao phủ bởi `idx_name_dob` nếu `first_name` cũng là một phần của index. EXPLAIN sẽ hiển thị "Using index" trong cột Extra.

### Functional Indexes (Index Hàm)
(Phổ biến hơn trong PostgreSQL, Oracle, nhưng MySQL cũng có giới hạn)

Cho phép lập chỉ mục trên kết quả của một hàm hoặc biểu thức. Hữu ích khi bạn thường xuyên truy vấn dựa trên các giá trị đã được tính toán.

### Partial Indexes (Index một phần)
(Phổ biến hơn trong PostgreSQL)

Chỉ lập chỉ mục cho một tập hợp con của các hàng trong bảng dựa trên một điều kiện nhất định. Giúp giảm kích thước index và tăng tốc độ cho các truy vấn nhắm mục tiêu vào tập dữ liệu đó. (MySQL có thể mô phỏng bằng cách sử dụng các chiến lược khác nhau).

## Khi nào nên và không nên dùng Index

### Nên dùng:
- Các cột thường xuyên xuất hiện trong WHERE, JOIN, ORDER BY, GROUP BY
- Các cột có nhiều giá trị duy nhất

### Không nên dùng:
- Các cột có rất ít giá trị duy nhất (ví dụ: gender)
- Các bảng rất nhỏ
- Các bảng có tần suất ghi (INSERT/UPDATE/DELETE) rất cao, vì mỗi lần ghi phải cập nhật index, gây ra chi phí I/O

## Công cụ

- Sử dụng **EXPLAIN** để xác định các truy vấn không sử dụng index hoặc sử dụng không hiệu quả
- **Database Insights** sẽ cho bạn thấy các truy vấn chậm nhất, là những ứng cử viên hàng đầu để lập chỉ mục

---

*Tiếp theo: Tìm hiểu về các kỹ thuật [Viết lại Truy vấn](../query-rewriting/) để tối ưu hóa câu lệnh SQL.*
