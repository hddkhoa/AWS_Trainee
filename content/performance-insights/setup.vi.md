---
title: "Thiết lập RDS Instance với Performance Insights"
date: 2024-07-14
weight: 20
description: "Hướng dẫn chi tiết cách tạo RDS Instance và kích hoạt Performance Insights"
---

## 1. Tạo RDS Instance với Performance Insights

### Bước 1: Truy cập RDS Console
1. Đăng nhập vào AWS Console
2. Tìm kiếm "RDS" trong thanh tìm kiếm
3. Click vào "Amazon RDS"



### Bước 2: Tạo Database
<img src="/images/2025-07-14_15-55-30.png" alt="2025-07-14_15-55-30" width="800">

1. Click nút "Create database" màu cam
2. Chọn "Standard create" (không chọn Easy create)
3. Engine options:
   • Chọn MySQL (hoặc PostgreSQL tùy nhu cầu)
   • Version: Chọn phiên bản mới nhất (ví dụ: MySQL 8.0.35)



### Bước 3: Templates và Settings
<img src="/images/2025-07-14_15-58-04.png" alt="2025-07-14_15-58-04" width="800">

1. Templates: Chọn "Free tier" (nếu đủ điều kiện) hoặc "Dev/Test"
2. Settings:
   • **DB instance identifier:** mydb-performance-test
   • **Master username:** admin
   • **Master password:** Tạo mật khẩu mạnh hoặc chọn "Auto generate"



### Bước 4: Instance Configuration
<img src="/images/2025-07-14_16-02-05.png" alt="2025-07-14_16-02-05" width="800">

1. DB instance class:
   • Chọn "Burstable classes (includes t classes)"
   • Chọn db.t3.micro (Free tier) hoặc db.t3.small
2. Storage:
   • **Storage type:** General Purpose SSD (gp2)
   • **Allocated storage:** 20 GB
   • Bỏ tick "Enable storage autoscaling" (để tiết kiệm chi phí)



### Bước 5: Connectivity
<img src="/images/2025-07-14_16-03-40.png" alt="2025-07-14_16-03-40" width="800">

1. Virtual private cloud (VPC): Chọn Default VPC
2. Subnet group: default
3. Public access: Chọn "Yes" (để test từ bên ngoài)
4. VPC security group: 
   • Chọn "Create new"
   • **New VPC security group name:** rds-performance-sg


### Bước 6: Database Authentication

1. Database authentication: Chọn "Password authentication"



### Bước 7: Monitoring 
⚠️ **Warning:** 
(Quan trọng!)


<img src="/images/2025-07-14_16-08-09.png" alt="2025-07-14_16-08-09" width="800">

1. Enable Enhanced monitoring: Tick chọn
   • **Granularity:** 60 seconds
   • **Monitoring Role:** Chọn "Default" hoặc tạo mới
2. **Enable Performance Insights: TICK CHỌN ✅**
   • **Retention period:** Chọn "7 days (free)"
   • **Master key:** Chọn "Default"



### Bước 8: Additional Configuration
<img src="/images/2025-07-14_16-10-09.png" alt="2025-07-14_16-10-09" width="800">

1. Initial database name: testdb
2. DB parameter group: default
3. Backup:
   • **Backup retention period:** 7 days
   • **Backup window:** Chọn thời gian ít sử dụng
4. Maintenance:
   • **Enable auto minor version upgrade:** Tick
   • **Maintenance window:** Chọn thời gian ít sử dụng



### Bước 9: Tạo Database
<img src="/images/2025-07-14_16-11-19.png" alt="2025-07-14_16-11-19" width="800">
<img src="/images/2025-07-14_16-45-15.png" alt="2025-07-14_16-45-15" width="800">
1. Click "Create database"
2. Đợi 10-15 phút để database được tạo
3. Trạng thái sẽ chuyển từ "Creating" → "Available"





## 2. Kích hoạt Performance Insights cho RDS hiện có

Nếu bạn đã có RDS instance và muốn kích hoạt Performance Insights:

### Bước 1: Chọn Database
<img src="/images/22.png" alt="22" width="800">


1. Vào RDS Console
2. Click vào "Databases" ở sidebar
3. Chọn database instance cần kích hoạt

### Bước 2: Modify Database
<img src="/images/33.png" alt="33" width="800">

1. Click nút "Modify"
2. Scroll xuống phần "Monitoring"
3. Tìm "Performance Insights"
4. Tick chọn "Enable Performance Insights"
5. Chọn retention period (7 days free)
6. Click "Continue"

### Bước 3: Apply Changes
1. Chọn "Apply immediately" hoặc "Apply during maintenance window"
2. Click "Modify DB instance"

## 3. Xác minh Performance Insights đã hoạt động

### Kiểm tra trạng thái:
1. Vào RDS Console
2. Chọn database instance
3. Tab "Configuration" → kiểm tra "Performance Insights" = Enabled
4. Tab "Monitoring" → sẽ có link "View in Performance Insights"

### Truy cập Performance Insights Dashboard:
1. Click "View in Performance Insights"
2. Hoặc vào menu "Performance Insights" ở sidebar RDS
3. Chọn database từ dropdown

## 4. Cấu hình Security Group

Để kết nối từ bên ngoài, cần cấu hình Security Group:

```bash
# Tìm Security Group ID
aws ec2 describe-security-groups --group-names rds-performance-sg

# Thêm rule cho MySQL (port 3306)
aws ec2 authorize-security-group-ingress \
    --group-id sg-xxxxxxxxx \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0
```

⚠️ **Lưu ý bảo mật:** Chỉ mở 0.0.0.0/0 cho môi trường test. Trong production, hãy giới hạn IP cụ thể.

## 5. Test kết nối

```bash
# Cài đặt MySQL client
sudo apt-get install mysql-client

# Kết nối đến RDS
mysql -h mydb-performance-test.xxxxxxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p testdb
```

## Troubleshooting

### Lỗi thường gặp:
1. **Performance Insights không hiển thị data:**
   - Đợi 5-10 phút sau khi enable
   - Kiểm tra có traffic đến database không

2. **Không kết nối được database:**
   - Kiểm tra Security Group rules
   - Kiểm tra Public accessibility = Yes
   - Kiểm tra VPC và Subnet configuration

3. **Enhanced Monitoring không hoạt động:**
   - Kiểm tra IAM role permissions
   - Tạo lại monitoring role nếu cần

## Chi phí ước tính

- **RDS db.t3.micro:** ~$12.41/tháng (Free tier: 750 giờ/tháng)
- **Performance Insights:** Free cho 7 days retention
- **Enhanced Monitoring:** ~$2.50/tháng cho 60-second granularity
- **Storage 20GB:** ~$2.30/tháng

**Tổng:** ~$17/tháng (hoặc free nếu trong Free tier)
