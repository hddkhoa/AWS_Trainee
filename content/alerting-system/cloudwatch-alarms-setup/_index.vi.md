---
title: "5.1 Thiết lập CloudWatch Alarms"
date: 2025-07-14
weight: 10
draft: false
---

# Thiết lập CloudWatch Alarms

## Bước 1: Tạo CPU Alarm
1. Trong CloudWatch, click "Alarms" → "All alarms"
2. Click "Create alarm"
3. Select metric:
   • **Namespace:** AWS/RDS
   • **Metric name:** CPUUtilization
   • **DBInstanceIdentifier:** Chọn instance của bạn
   • Click "Select metric"

## Bước 2: Cấu hình Alarm Conditions
<img src="/dangkhoa/images/2025-07-14_16-36-57.png" alt="2025-07-14_16-36-57" width="800">

1. Conditions:
   • **Threshold type:** Static
   • **Whenever CPUUtilization is:** Greater than
   • **Threshold value:** 80
2. Additional configuration:
   • **Datapoints to alarm:** 2 out of 2
   • **Period:** 5 minutes

## Bước 3: Cấu hình Actions
<img src="/dangkhoa/images/2025-07-14_16-38-15.png" alt="2025-07-14_16-38-15" width="800">

1. Alarm state trigger: In alarm
2. Send a notification to: 
   • **Create new topic**
   • **Topic name:** rds-alerts
   • **Email endpoints:** Nhập email của bạn
3. Click "Create topic"

## Bước 4: Thêm Name và Description
<img src="/dangkhoa/images/2025-07-14_16-42-46.png" alt="2025-07-14_16-42-46" width="800">

1. Alarm name: RDS-CPU-High
2. Alarm description: RDS CPU utilization is above 80%
3. Click "Next"

## Bước 5: Preview và Create
<img src="/dangkhoa/images/2025-07-14_16-43-53.png" alt="2025-07-14_16-43-53" width="800">

1. Review tất cả settings
2. Click "Create alarm"
3. Confirm email: Kiểm tra email và click confirm subscription

<img src="/dangkhoa/images/2025-07-14_16-44-13.png" alt="2025-07-14_16-44-13" width="800">


## Bước 6: Tạo Additional Alarms cho Other Metrics

### Memory Alarm
1. Tạo new alarm với **FreeableMemory** metric
2. Threshold: Less than 1GB (1073741824 bytes)
3. Alarm name: RDS-Memory-Low

### Database Connections Alarm
1. Tạo new alarm với **DatabaseConnections** metric
2. Threshold: Greater than 80% của max connections
3. Alarm name: RDS-Connections-High

### Read/Write Latency Alarms
1. **ReadLatency**: Greater than 0.2 seconds
2. **WriteLatency**: Greater than 0.2 seconds
3. Alarm names: RDS-ReadLatency-High, RDS-WriteLatency-High

### IOPS Alarms
1. **ReadIOPS**: Monitor read operations per second
2. **WriteIOPS**: Monitor write operations per second
3. Set thresholds based on instance capacity

## Bước 7: Verify và Test Alarms

<img src="/dangkhoa/images/2025-07-14_16-31-10.png" alt="2025-07-14_16-31-10" width="800">

### Verify Alarm Status
1. Return to CloudWatch Alarms dashboard
2. Check status của tất cả alarms
3. Ensure alarms are in "OK" hoặc "INSUFFICIENT_DATA" state

### Test Notifications
1. Temporarily lower threshold để trigger alarm
2. Check email notification
3. Restore original threshold

## Bước 8: Best Practices

### Threshold Configuration
1. **Based on baseline**: Use historical data
2. **Avoid false positives**: Don't set thresholds quá thấp
3. **Datapoints to alarm**: Use 2 out of 3 để reduce noise
4. **Appropriate period**: 5 minutes cho most metrics

### Notification Strategy
1. **Critical alarms**: Immediate notification
2. **Warning alarms**: Delayed notification
3. **Multiple channels**: Email + SMS cho critical
4. **Escalation**: Auto-escalate nếu no response

### Monitoring Coverage
1. **Core metrics**: CPU, Memory, Connections
2. **Performance metrics**: Latency, IOPS
3. **Availability metrics**: Database status
4. **Custom metrics**: Application-specific metrics
