---
title: "Kế hoạch Thực thi"
date: 2025-07-15T11:00:00+07:00
weight: 30
draft: false
---

# Kế hoạch Thực thi - Hiểu và phân tích kế hoạch truy vấn

Kế hoạch thực thi là "lộ trình" mà cơ sở dữ liệu sẽ đi theo để thực hiện một truy vấn. Hiểu được nó là chìa khóa để chẩn đoán và khắc phục các vấn đề hiệu suất truy vấn.

## Cách lấy Execution Plan

### Sử dụng EXPLAIN
Sử dụng lệnh `EXPLAIN` trước bất kỳ truy vấn SQL nào:
```sql
EXPLAIN SELECT * FROM users WHERE id = 1;
```

### Sử dụng EXPLAIN ANALYZE
Có trong các phiên bản MySQL gần đây và PostgreSQL để thực sự chạy truy vấn và thu thập số liệu thống kê thời gian thực về kế hoạch thực thi, bao gồm thời gian và số hàng thực tế được xử lý:
```sql
EXPLAIN ANALYZE SELECT * FROM users WHERE id = 1;
```

## Các yếu tố chính cần phân tích trong một Execution Plan

### type
Chỉ ra phương pháp truy cập bảng:
- `ALL` - Xấu (quét toàn bộ bảng)
- `ref`, `eq_ref`, `const` - Tốt (sử dụng index hiệu quả)

### key
Index nào được sử dụng. Nếu `NULL`, không có index nào được sử dụng.

### rows
Số lượng hàng ước tính mà MySQL phải kiểm tra. Con số này càng nhỏ càng tốt. Một số lớn cho thấy quét bảng hoặc index không hiệu quả.

### filtered
Phần trăm hàng ước tính còn lại sau khi áp dụng điều kiện bảng. Giá trị thấp cho thấy nhiều hàng đã được đọc nhưng bị loại bỏ sau đó.

### Extra
Cung cấp thông tin quan trọng về các hoạt động bổ sung mà trình tối ưu hóa phải thực hiện:

#### Using filesort
Sắp xếp dữ liệu bằng cách sử dụng một thuật toán tốn kém. Cố gắng sử dụng index để sắp xếp (thêm các cột ORDER BY vào index).

#### Using temporary
MySQL cần tạo bảng tạm thời trên đĩa hoặc trong bộ nhớ để xử lý truy vấn (ví dụ: cho GROUP BY hoặc DISTINCT không thể dùng index). Cố gắng tối ưu hóa truy vấn để tránh điều này.

#### Using where
Mệnh đề WHERE được áp dụng để lọc hàng. Nếu kết hợp với ALL, nó cho thấy quét bảng không hiệu quả.

#### Using index
Rất tốt! Truy vấn được thỏa mãn hoàn toàn bằng cách sử dụng index (covering index), không cần truy cập dữ liệu bảng.

#### Using join buffer
Dữ liệu đang được lưu vào bộ đệm cho các phép nối, điều này có thể chỉ ra một phép nối kém hiệu quả.

## Các vấn đề hiệu suất phổ biến và giải pháp

### Quét toàn bộ bảng (type = ALL)
**Vấn đề**: Cơ sở dữ liệu đọc mọi hàng trong bảng
**Giải pháp**: Thêm index phù hợp trên các cột trong mệnh đề WHERE

### Số lượng hàng lớn
**Vấn đề**: Số lượng cao trong cột `rows`
**Giải pháp**: 
- Thêm index có tính chọn lọc cao hơn
- Viết lại truy vấn để cụ thể hơn
- Cân nhắc tối ưu hóa truy vấn

### Using filesort
**Vấn đề**: Thao tác sắp xếp tốn kém
**Giải pháp**: Tạo composite index bao gồm các cột ORDER BY

### Using temporary
**Vấn đề**: Chi phí tạo bảng tạm thời
**Giải pháp**: 
- Tối ưu hóa mệnh đề GROUP BY
- Thêm index phù hợp
- Viết lại cấu trúc truy vấn

## Thực hành tốt nhất cho phân tích Execution Plan

1. **Luôn kiểm tra cột `type` trước** - Tránh quét `ALL`
2. **Tìm `NULL` trong cột `key`** - Cho thấy thiếu index
3. **Theo dõi cột `rows`** - Số lượng cao gợi ý cơ hội tối ưu hóa
4. **Chú ý thông tin `Extra`** - Cung cấp gợi ý tối ưu hóa quan trọng
5. **Sử dụng EXPLAIN ANALYZE khi có thể** - Lấy thống kê thực tế vs ước tính

## Công cụ và kỹ thuật

- **MySQL Workbench**: Hiển thị execution plan trực quan
- **Performance Schema**: Phân tích truy vấn nâng cao
- **Slow Query Log**: Xác định các truy vấn có vấn đề
- **Performance Insights**: Công cụ phân tích chuyên dụng cho AWS RDS

---

*Trước đó: [Viết lại Truy vấn](../query-rewriting/) | Tiếp theo: Quay lại [Tổng quan Tối ưu hóa Truy vấn](../)*
