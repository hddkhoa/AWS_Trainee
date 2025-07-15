---
title: "5. Hệ thống Cảnh báo"
date: 2025-07-14T14:00:00+07:00
weight: 50
chapter: true
pre: "<b>5. </b>"
draft: false
---

### Chương 5

# Hệ thống Cảnh báo

Đảm bảo phản ứng kịp thời khi có các vấn đề về hiệu suất.

## Mục tiêu

Tự động thông báo khi các chỉ số vượt quá ngưỡng hoặc có hành vi bất thường.

## Các thành phần

### Amazon CloudWatch Alarms
Cấu hình cảnh báo dựa trên các chỉ số của RDS:
- CPU > 80% trong 5 phút
- Freeable Memory < 20% tổng RAM
- DB Load cao bất thường từ Performance Insights

### Amazon SNS (Simple Notification Service)
Dùng làm kênh gửi thông báo:
- Email
- SMS
- Tích hợp với Slack, PagerDuty thông qua Lambda

### CloudWatch Anomaly Detection (tùy chọn)
Phát hiện các hành vi bất thường mà không cần đặt ngưỡng cố định, rất hữu ích cho các chỉ số có biến động.

## Quy tắc cảnh báo

- **So sánh với đường cơ sở hiệu suất** đã thiết lập
- **Cảnh báo theo mức độ nghiêm trọng**:
  - Warning (Cảnh báo)
  - Critical (Nghiêm trọng)

## Ví dụ cấu hình

```json
{
  "AlarmName": "RDS-CPU-High",
  "ComparisonOperator": "GreaterThanThreshold",
  "EvaluationPeriods": 2,
  "MetricName": "CPUUtilization",
  "Namespace": "AWS/RDS",
  "Period": 300,
  "Statistic": "Average",
  "Threshold": 80.0,
  "ActionsEnabled": true,
  "AlarmActions": [
    "arn:aws:sns:region:account:topic-name"
  ]
}
```
