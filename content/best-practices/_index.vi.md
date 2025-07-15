---
title: "10. Dọn dẹp Tài nguyên"
date: 2025-07-15T11:00:00+07:00
weight: 100
chapter: true
pre: "<b>10. </b>"
draft: false
---

### Chương 10

# Dọn dẹp Tài nguyên

Sau khi hoàn thành workshop RDS Performance Insights, điều quan trọng là phải dọn dẹp các tài nguyên AWS để tránh các khoản phí không cần thiết. Thực hiện theo các bước sau để xóa đúng cách tất cả các tài nguyên đã tạo.

## 🗑️ Các bước Dọn dẹp Tài nguyên

### 1. Xóa RDS Instance

Điều hướng đến RDS Console và xóa database instance của bạn:

1. **Mở RDS Console** → Chọn instance của bạn
2. **Actions** → **Delete**
3. **Create final snapshot:** Chọn **No** (để tiết kiệm chi phí)
4. **Gõ "delete me"** để xác nhận xóa
5. Click **Delete DB Instance**

> **Cảnh báo**: Hành động này không thể hoàn tác. Đảm bảo bạn đã sao lưu bất kỳ dữ liệu quan trọng nào trước khi tiến hành.

### 2. Xóa CloudWatch Alarms

Xóa tất cả các alarm giám sát được tạo trong workshop:

1. **CloudWatch Console** → **Alarms**
2. **Chọn tất cả alarm liên quan đến workshop**
3. **Actions** → **Delete**
4. **Xác nhận xóa**

### 3. Xóa SNS Topic

Dọn dẹp các topic thông báo:

1. **SNS Console** → **Topics**
2. **Chọn topic** được tạo cho RDS alerts
3. **Delete**
4. **Xác nhận bằng cách gõ "delete me"**

### 4. Xóa CloudWatch Dashboard

Xóa dashboard giám sát:

1. **CloudWatch Console** → **Dashboards**
2. **Chọn RDS dashboard của bạn**
3. **Actions** → **Delete**
4. **Xác nhận xóa**

## 💰 Mẹo Tối ưu hóa Chi phí

- **Luôn xóa các tài nguyên không sử dụng** để tránh các khoản phí liên tục
- **Thiết lập cảnh báo billing** để giám sát chi tiêu AWS
- **Sử dụng AWS Cost Explorer** để theo dõi chi phí tài nguyên
- **Cân nhắc sử dụng AWS Budgets** để quản lý chi phí

## ✅ Danh sách Kiểm tra Xác minh

Sau khi dọn dẹp, xác minh rằng tất cả tài nguyên đã được xóa:

- [ ] RDS Instance đã xóa
- [ ] CloudWatch Alarms đã xóa
- [ ] SNS Topics đã xóa
- [ ] CloudWatch Dashboards đã xóa
- [ ] Không có khoản phí bất ngờ trong billing

## 🎯 Best Practices cho Các dự án Tương lai

1. **Gắn tag cho tài nguyên** để dễ dàng xác định và dọn dẹp
2. **Tài liệu hóa các phụ thuộc tài nguyên** trước khi xóa
3. **Sử dụng Infrastructure as Code** (CloudFormation/Terraform) để dọn dẹp dễ dàng hơn
4. **Thiết lập automated cleanup** cho môi trường development
5. **Kiểm tra tài nguyên thường xuyên** để xác định các tài nguyên không sử dụng

---

*Chúc mừng! Bạn đã hoàn thành thành công workshop RDS Performance Insights và dọn dẹp tất cả tài nguyên. 🎉*
