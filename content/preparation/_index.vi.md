---
title: "2. Chuẩn Bị"
date: 2025-07-11T11:00:00+07:00
weight: 20
chapter: true
pre: "<b>2. </b>"
draft: false
---

### Chương 2

# Chuẩn Bị

Tìm hiểu cách chuẩn bị môi trường và thu thập các điều kiện tiên quyết để triển khai RDS Performance Insights và tối ưu hóa truy vấn.

## Điều Kiện Tiên Quyết

Trước khi bắt đầu với RDS Performance Insights, hãy đảm bảo bạn có:

- **Tài khoản AWS** với quyền phù hợp
- **RDS Instance** chạy engine được hỗ trợ (MySQL, PostgreSQL, Oracle, SQL Server, MariaDB)
- **AWS CLI** được cấu hình với thông tin xác thực phù hợp
- **Hiểu biết cơ bản** về SQL và các khái niệm cơ sở dữ liệu

## Các Engine Cơ Sở Dữ Liệu Được Hỗ Trợ

Performance Insights có sẵn cho các RDS engines sau:

| Engine | Phiên Bản Tối Thiểu | Ghi Chú |
|--------|-------------------|---------|
| MySQL | 5.6.10+ | Tất cả instance classes được hỗ trợ |
| PostgreSQL | 9.6+ | Tất cả instance classes được hỗ trợ |
| Oracle | 12.1.0.2+ | Yêu cầu Enterprise Edition |
| SQL Server | 2016+ | Tất cả editions được hỗ trợ |
| MariaDB | 10.1+ | Tất cả instance classes được hỗ trợ |

## Quyền Yêu Cầu

User hoặc role AWS của bạn cần các quyền sau:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds:DescribeDBInstances",
                "rds:DescribeDBClusters",
                "rds:ModifyDBInstance",
                "pi:DescribeDimensionKeys",
                "pi:GetResourceMetrics"
            ],
            "Resource": "*"
        }
    ]
}
```

## Thiết Lập Môi Trường

Thực hiện theo các bước sau để chuẩn bị môi trường của bạn:

1. **Kích hoạt Performance Insights** trên RDS instance của bạn
2. **Cấu hình thời gian lưu trữ** (7 ngày miễn phí, lên đến 2 năm với chi phí bổ sung)
3. **Thiết lập công cụ giám sát** và bảng điều khiển
4. **Chuẩn bị khối lượng công việc thử nghiệm** để phân tích hiệu suất

## Cân Nhắc Chi Phí

- **Gói miễn phí**: 7 ngày lưu trữ dữ liệu Performance Insights
- **Lưu trữ mở rộng**: Áp dụng phí bổ sung cho việc lưu trữ quá 7 ngày
- **Không có phí bổ sung** cho chính tính năng Performance Insights
- **Giám sát chi phí** thông qua AWS Cost Explorer và cảnh báo thanh toán

Sẵn sàng tiếp tục? Hãy chuyển sang thiết lập Performance Insights!
