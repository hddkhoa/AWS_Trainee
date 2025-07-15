---
title: "Ví dụ sử dụng ảnh trong Hugo"
date: 2025-07-14
draft: false
---

# Ví dụ các cách thêm ảnh

## 1. Ảnh cơ bản
```markdown
![Mô tả ảnh](/images/ten-anh.jpg)
```

Kết quả:
![CloudWatch Dashboard](/images/dashboard-example.png)

## 2. Ảnh với kích thước tùy chỉnh
```html
<img src="/images/ten-anh.jpg" alt="Mô tả" width="600" height="400">
```

Kết quả:
<img src="/images/alarm-setup.png" alt="Thiết lập Alarm" width="600">

## 3. Ảnh với chú thích
```markdown
![RDS Performance](/images/rds-performance.png)
*Hình 1: Bảng điều khiển RDS Performance*
```

Kết quả:
![RDS Performance](/images/rds-performance.png)
*Hình 1: Bảng điều khiển RDS Performance*

## 4. Nhiều ảnh trong một phần

### Bước 1: Tạo Dashboard
![Bước 1](/images/step1-create-dashboard.png)

### Bước 2: Thêm Widget
![Bước 2](/images/step2-add-widget.png)

### Bước 3: Cấu hình Metric
![Bước 3](/images/step3-configure-metric.png)

## 5. Ảnh với liên kết
```markdown
[![Click để xem kích thước đầy đủ](/images/thumbnail.png)](/images/full-size.png)
```

## 6. Ảnh với viền và căn giữa
```html
<div align="center">
<img src="/images/architecture-diagram.png" alt="Sơ đồ kiến trúc" style="border: 1px solid #ddd; border-radius: 4px; padding: 5px;">
</div>
```

## 7. Gallery ảnh
```html
<div style="display: flex; justify-content: space-around; flex-wrap: wrap;">
<img src="/images/before.png" alt="Trước" width="300">
<img src="/images/after.png" alt="Sau" width="300">
</div>
```

## Danh sách ảnh cần thêm:
- `/images/cloudwatch-console.png` - Giao diện CloudWatch
- `/images/create-dashboard.png` - Tạo dashboard mới  
- `/images/cpu-widget.png` - Widget CPU
- `/images/database-connections.png` - Widget kết nối cơ sở dữ liệu
- `/images/memory-widget.png` - Widget bộ nhớ
- `/images/create-alarm.png` - Tạo cảnh báo
- `/images/alarm-conditions.png` - Điều kiện cảnh báo
- `/images/performance-insights.png` - Performance Insights
- `/images/query-optimization.png` - Tối ưu hóa truy vấn
- `/images/monitoring-setup.png` - Thiết lập giám sát

## Lưu ý khi sử dụng ảnh:
1. **Tối ưu hóa kích thước:** Nén ảnh để tải nhanh hơn
2. **Alt text:** Luôn thêm mô tả cho accessibility
3. **Responsive:** Sử dụng CSS để ảnh hiển thị tốt trên mobile
4. **Lazy loading:** Sử dụng loading="lazy" cho ảnh lớn
5. **Format phù hợp:** PNG cho screenshot, JPG cho ảnh thực
