---
title: "10. Dọn dẹp tài nguyên"
date: 2025-07-14T15:00:00+07:00
weight: 100
chapter: true
pre: "<b>10. </b>"
draft: false
---

### Chương 10

# Dọn dẹp tài nguyên

Hướng dẫn chi tiết cách dọn dẹp và tối ưu hóa tài nguyên AWS để tiết kiệm chi phí.

## Mục tiêu

Giảm thiểu chi phí phát sinh bằng cách dọn dẹp các tài nguyên không cần thiết và tối ưu hóa cấu hình hiện tại.

## 1. Dọn dẹp RDS Resources

### Xóa RDS Instances không sử dụng

```bash
# Liệt kê tất cả RDS instances
aws rds describe-db-instances --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus,Engine]' --output table

# Xóa RDS instance (tạo snapshot trước khi xóa)
aws rds create-db-snapshot \
    --db-instance-identifier mydb-instance \
    --db-snapshot-identifier mydb-final-snapshot-$(date +%Y%m%d)

# Xóa RDS instance
aws rds delete-db-instance \
    --db-instance-identifier mydb-instance \
    --final-db-snapshot-identifier mydb-final-snapshot-$(date +%Y%m%d) \
    --delete-automated-backups
```

### Xóa Read Replicas

```bash
# Liệt kê Read Replicas
aws rds describe-db-instances --query 'DBInstances[?ReadReplicaSourceDBInstanceIdentifier!=null].[DBInstanceIdentifier,ReadReplicaSourceDBInstanceIdentifier]' --output table

# Xóa Read Replica
aws rds delete-db-instance \
    --db-instance-identifier mydb-replica \
    --skip-final-snapshot \
    --delete-automated-backups
```

### Dọn dẹp Snapshots cũ

```bash
# Liệt kê snapshots cũ hơn 30 ngày
aws rds describe-db-snapshots \
    --snapshot-type manual \
    --query 'DBSnapshots[?SnapshotCreateTime<=`2024-12-01`].[DBSnapshotIdentifier,SnapshotCreateTime]' \
    --output table

# Xóa snapshot cũ
aws rds delete-db-snapshot --db-snapshot-identifier old-snapshot-name
```

## 2. Dọn dẹp CloudWatch Resources

### Xóa Custom Dashboards

```bash
# Liệt kê dashboards
aws cloudwatch list-dashboards --output table

# Xóa dashboard
aws cloudwatch delete-dashboards --dashboard-names "RDS-Performance-Dashboard"
```

### Dọn dẹp CloudWatch Alarms

```bash
# Liệt kê alarms
aws cloudwatch describe-alarms --query 'MetricAlarms[*].[AlarmName,StateValue]' --output table

# Xóa alarm không cần thiết
aws cloudwatch delete-alarms --alarm-names "RDS-CPU-High" "RDS-Memory-Low"
```

### Xóa Log Groups cũ

```bash
# Liệt kê log groups
aws logs describe-log-groups --query 'logGroups[*].[logGroupName,creationTime]' --output table

# Xóa log group
aws logs delete-log-group --log-group-name "/aws/rds/instance/mydb/slowquery"
```

## 3. Tối ưu hóa Performance Insights

### Giảm Retention Period

```bash
# Kiểm tra retention period hiện tại
aws rds describe-db-instances \
    --db-instance-identifier mydb-instance \
    --query 'DBInstances[0].PerformanceInsightsRetentionPeriod'

# Giảm retention period xuống 7 ngày (miễn phí)
aws rds modify-db-instance \
    --db-instance-identifier mydb-instance \
    --performance-insights-retention-period 7 \
    --apply-immediately
```

## 4. Dọn dẹp SNS và Lambda

### Xóa SNS Topics và Subscriptions

```bash
# Liệt kê SNS topics
aws sns list-topics --output table

# Xóa subscription
aws sns unsubscribe --subscription-arn "arn:aws:sns:region:account:topic:subscription"

# Xóa topic
aws sns delete-topic --topic-arn "arn:aws:sns:region:account:rds-alerts"
```

### Xóa Lambda Functions

```bash
# Liệt kê Lambda functions
aws lambda list-functions --query 'Functions[*].[FunctionName,Runtime,LastModified]' --output table

# Xóa Lambda function
aws lambda delete-function --function-name rds-alert-processor
```

## 5. Tối ưu hóa Instance Types

### Downgrade Instance Size

```bash
# Kiểm tra utilization trước khi downgrade
aws cloudwatch get-metric-statistics \
    --namespace AWS/RDS \
    --metric-name CPUUtilization \
    --dimensions Name=DBInstanceIdentifier,Value=mydb-instance \
    --start-time 2024-12-01T00:00:00Z \
    --end-time 2024-12-31T23:59:59Z \
    --period 3600 \
    --statistics Average

# Downgrade instance class nếu CPU < 50%
aws rds modify-db-instance \
    --db-instance-identifier mydb-instance \
    --db-instance-class db.t3.small \
    --apply-immediately
```

## 6. Dọn dẹp Storage

### Giảm Allocated Storage

```bash
# Lưu ý: Không thể giảm allocated storage, chỉ có thể tối ưu hóa
# Thay vào đó, tạo instance mới với storage nhỏ hơn và migrate data

# Kiểm tra storage utilization
aws cloudwatch get-metric-statistics \
    --namespace AWS/RDS \
    --metric-name FreeStorageSpace \
    --dimensions Name=DBInstanceIdentifier,Value=mydb-instance \
    --start-time 2024-12-01T00:00:00Z \
    --end-time 2024-12-31T23:59:59Z \
    --period 3600 \
    --statistics Average
```

### Tắt Multi-AZ nếu không cần thiết

```bash
# Tắt Multi-AZ deployment
aws rds modify-db-instance \
    --db-instance-identifier mydb-instance \
    --no-multi-az \
    --apply-immediately
```

## 7. Script tự động dọn dẹp

### Bash Script để dọn dẹp hàng loạt

```bash
#!/bin/bash
# cleanup-rds-resources.sh

echo "=== Script Dọn dẹp Tài nguyên RDS ==="

# 1. Xóa snapshots cũ hơn 30 ngày
echo "Đang dọn dẹp snapshots cũ..."
OLD_SNAPSHOTS=$(aws rds describe-db-snapshots \
    --snapshot-type manual \
    --query 'DBSnapshots[?SnapshotCreateTime<=`2024-11-01`].DBSnapshotIdentifier' \
    --output text)

for snapshot in $OLD_SNAPSHOTS; do
    echo "Đang xóa snapshot: $snapshot"
    aws rds delete-db-snapshot --db-snapshot-identifier $snapshot
done

# 2. Xóa unused alarms
echo "Đang dọn dẹp CloudWatch alarms..."
aws cloudwatch delete-alarms --alarm-names \
    "RDS-CPU-High-Test" \
    "RDS-Memory-Low-Test" \
    "RDS-Connection-High-Test"

# 3. Giảm Performance Insights retention
echo "Đang tối ưu hóa Performance Insights retention..."
aws rds modify-db-instance \
    --db-instance-identifier mydb-instance \
    --performance-insights-retention-period 7 \
    --apply-immediately

echo "Dọn dẹp hoàn tất!"
```

## 8. Giám sát Chi phí

### Thiết lập Budget Alerts

```bash
# Tạo budget để theo dõi chi phí RDS
aws budgets create-budget \
    --account-id 123456789012 \
    --budget '{
        "BudgetName": "RDS-Monthly-Budget",
        "BudgetLimit": {
            "Amount": "100",
            "Unit": "USD"
        },
        "TimeUnit": "MONTHLY",
        "BudgetType": "COST",
        "CostFilters": {
            "Service": ["Amazon Relational Database Service"]
        }
    }'
```

## 9. Best Practices cho Tối ưu hóa Chi phí

### Lịch trình tự động

- **Tắt Dev/Test instances** vào cuối tuần
- **Automated snapshots cleanup** hàng tuần
- **Performance Insights retention** review hàng tháng
- **Instance right-sizing** review hàng quý

### Checklist dọn dẹp định kỳ

- [ ] Xóa snapshots cũ hơn 30 ngày
- [ ] Review và xóa unused alarms
- [ ] Kiểm tra instance utilization
- [ ] Tối ưu hóa storage allocation
- [ ] Review Multi-AZ necessity
- [ ] Cleanup unused log groups
- [ ] Review Performance Insights retention

## 10. Ước tính tiết kiệm chi phí

### Potential Savings

| Hành động | Tiết kiệm ước tính/tháng |
|-----------|-------------------------|
| Downgrade db.m5.large → db.t3.medium | ~$50-80 |
| Tắt Multi-AZ (nếu không cần) | ~50% chi phí instance |
| Giảm Performance Insights retention | ~$10-20 |
| Xóa unused Read Replicas | ~$100-200 |
| Cleanup old snapshots | ~$5-15 |

### Cost Calculator

Sử dụng [AWS Pricing Calculator](https://calculator.aws) để ước tính chính xác chi phí sau khi tối ưu hóa.
