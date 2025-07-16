---
title: "5.1 CloudWatch Alarms Setup"
date: 2025-07-14
weight: 10
draft: false
---

# CloudWatch Alarms Setup

## Step 1: Create CPU Alarm
1. In CloudWatch, click "Alarms" → "All alarms"
2. Click "Create alarm"
3. Select metric:
   • **Namespace:** AWS/RDS
   • **Metric name:** CPUUtilization
   • **DBInstanceIdentifier:** Select your instance
   • Click "Select metric"



## Step 2: Configure Alarm Conditions
<img src="https://hddkhoa.github.io/AWS_Trainee/images/2025-07-14_16-36-57.png" alt="2025-07-14_16-36-57" width="800">

1. Conditions:
   • **Threshold type:** Static
   • **Whenever CPUUtilization is:** Greater than
   • **Threshold value:** 80
2. Additional configuration:
   • **Datapoints to alarm:** 2 out of 2
   • **Period:** 5 minutes



## Step 3: Configure Actions
<img src="https://hddkhoa.github.io/AWS_Trainee/images/2025-07-14_16-38-15.png" alt="2025-07-14_16-38-15" width="800">

1. Alarm state trigger: In alarm
2. Send a notification to: 
   • **Create new topic**
   • **Topic name:** rds-alerts
   • **Email endpoints:** Enter your email
3. Click "Create topic"


## Step 4: Add Name and Description
<img src="https://hddkhoa.github.io/AWS_Trainee/images/2025-07-14_16-42-46.png" alt="22025-07-14_16-42-46" width="800">


1. Alarm name: RDS-CPU-High
2. Alarm description: RDS CPU utilization is above 80%
3. Click "Next"




## Step 5: Preview and Create
<img src="https://hddkhoa.github.io/AWS_Trainee/images/2025-07-14_16-43-53.png" alt="2025-07-14_16-43-53" width="800">

1. Review all settings
2. Click "Create alarm"
3. Confirm email: Check your email and click confirm subscription


<img src="https://hddkhoa.github.io/AWS_Trainee/images/2025-07-14_16-44-13.png" alt="2025-07-14_16-44-13" width="800">


## Step 6: Create Additional Alarms for Other Metrics

### Memory Alarm
1. Create new alarm with **FreeableMemory** metric
2. Threshold: Less than 1GB (1073741824 bytes)
3. Alarm name: RDS-Memory-Low

### Database Connections Alarm
1. Create new alarm with **DatabaseConnections** metric
2. Threshold: Greater than 80% of max connections
3. Alarm name: RDS-Connections-High

### Read/Write Latency Alarms
1. **ReadLatency**: Greater than 0.2 seconds
2. **WriteLatency**: Greater than 0.2 seconds
3. Alarm names: RDS-ReadLatency-High, RDS-WriteLatency-High

### IOPS Alarms
1. **ReadIOPS**: Monitor read operations per second
2. **WriteIOPS**: Monitor write operations per second
3. Set thresholds based on instance capacity

## Step 7: Verify and Test Alarms

### Verify Alarm Status
1. Return to CloudWatch Alarms dashboard
2. Check status of all alarms
3. Ensure alarms are in "OK" or "INSUFFICIENT_DATA" state

### Test Notifications
1. Temporarily lower threshold to trigger alarm
2. Check email notification
3. Restore original threshold

## Step 8: Best Practices

### Threshold Configuration
1. **Based on baseline**: Use historical data
2. **Avoid false positives**: Don't set thresholds too low
3. **Datapoints to alarm**: Use 2 out of 3 to reduce noise
4. **Appropriate period**: 5 minutes for most metrics

### Notification Strategy
1. **Critical alarms**: Immediate notification
2. **Warning alarms**: Delayed notification
3. **Multiple channels**: Email + SMS for critical
4. **Escalation**: Auto-escalate if no response

### Monitoring Coverage
1. **Core metrics**: CPU, Memory, Connections
2. **Performance metrics**: Latency, IOPS
3. **Availability metrics**: Database status
4. **Custom metrics**: Application-specific metrics
