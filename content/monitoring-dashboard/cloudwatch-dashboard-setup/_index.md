---
title: "4.1 CloudWatch Dashboard Setup"
date: 2025-07-14
weight: 10
draft: false
---

# CloudWatch Dashboard Setup

## Step 1: Access CloudWatch
1. Search for "CloudWatch" in AWS Console
2. Click on "Amazon CloudWatch"


## Step 2: Create Dashboard
<img src="/dangkhoa/images/2025-07-14_16-15-20.png" alt="2025-07-14_16-15-20" width="800">

1. In the left menu, click "Dashboards"
2. Click "Create dashboard"
3. Dashboard name: RDS-Performance-Dashboard
4. Click "Create dashboard"

<img src="/dangkhoa/images/2025-07-14_16-16-13.png" alt="2025-07-14_16-16-13" width="800">

## Step 3: Add First Widget - CPU Utilization
1. Select "Line" widget type
2. Click "Next"
3. Metrics:
   • **Namespace:** AWS/RDS
   • **Metric name:** CPUUtilization
   • **DBInstanceIdentifier:** Select the newly created instance
4. Period: 5 minutes
5. Click "Create widget"

<img src="/dangkhoa/images/2025-07-14_16-25-18.png" alt="2025-07-14_16-25-18" width="800">

## Step 4: Add Second Widget - Database Connections
1. Click "Add widget"
2. Select "Line" → "Next"
3. Metrics:
   • **Namespace:** AWS/RDS
   • **Metric name:** DatabaseConnections
   • **DBInstanceIdentifier:** Select your instance
4. Click "Create widget"

<img src="/dangkhoa/images/2025-07-14_16-30-33.png" alt="2025-07-14_16-30-33" width="800">

## Step 5: Add Third Widget - Free Memory
1. Click "Add widget"
2. Select "Line" → "Next"
3. Metrics:
   • **Namespace:** AWS/RDS
   • **Metric name:** FreeableMemory
   • **DBInstanceIdentifier:** Select your instance
4. Click "Create widget"



## Step 6: Add Additional Widgets

### Read/Write IOPS Widget
1. Click "Add widget"
2. Select "Line" → "Next"
3. Add two metrics:
   • **ReadIOPS:** Number of read operations per second
   • **WriteIOPS:** Number of write operations per second
4. Click "Create widget"



### Read/Write Latency Widget
1. Click "Add widget"
2. Select "Line" → "Next"
3. Add two metrics:
   • **ReadLatency:** Read operations latency
   • **WriteLatency:** Write operations latency
4. Click "Create widget"



### Network Throughput Widget
1. Click "Add widget"
2. Select "Line" → "Next"
3. Add two metrics:
   • **NetworkReceiveThroughput:** Network receive throughput
   • **NetworkTransmitThroughput:** Network transmit throughput
4. Click "Create widget"


## Step 7: Customize Dashboard

### Arrange Widgets
1. Drag and drop widgets to arrange as desired
2. Resize widgets by dragging corners
3. Group related metrics together



### Set Time Range
1. In the top right corner, select time range:
   • **1h** - 1 hour
   • **3h** - 3 hours
   • **12h** - 12 hours
   • **1d** - 1 day
   • **3d** - 3 days
   • **1w** - 1 week

### Auto Refresh
1. Click the refresh icon
2. Select auto refresh interval:
   • **10s** - 10 seconds
   • **1m** - 1 minute
   • **2m** - 2 minutes
   • **5m** - 5 minutes
   • **15m** - 15 minutes

## Step 8: Save and Share Dashboard

<img src="/dangkhoa/images/2025-07-14_16-31-10.png" alt="2025-07-14_16-31-10" width="800">

### Save Dashboard
1. Click "Save dashboard"
2. Dashboard will be saved automatically



### Share Dashboard
1. Click "Share dashboard"
2. Choose permissions:
   • **Public:** Anyone can view
   • **Account:** Current account only
   • **Specific users:** Only designated users

### Export Dashboard
1. Click "Actions" → "View/edit source"
2. Copy JSON configuration
3. Can import to other accounts

## Step 9: Best Practices

### Organize Widgets
1. **Group by function:**
   • Performance metrics (CPU, Memory)
   • I/O metrics (IOPS, Latency)
   • Network metrics (Throughput)
   • Connection metrics (Connections, Queries)

2. **Use consistent colors:**
   • Red: Critical metrics
   • Yellow: Warning metrics
   • Green: Normal metrics

### Monitoring Strategy
1. **Real-time monitoring:** 1-5 minute intervals
2. **Historical analysis:** 1 hour - 1 week
3. **Capacity planning:** 1 month - 1 year
4. **Alerting:** Set appropriate thresholds

### Performance Optimization
1. **Limit widget count:** No more than 20 widgets/dashboard
2. **Use appropriate time ranges:** Don't query too many data points
3. **Group related metrics:** Easy to analyze and compare


