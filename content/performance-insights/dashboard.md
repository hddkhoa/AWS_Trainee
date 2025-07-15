---
title: "Understanding the Performance Insights Dashboard"
date: 2024-07-14
weight: 30
description: "Complete guide to navigating and interpreting the Performance Insights dashboard"
---

## Dashboard Overview

The Performance Insights dashboard provides a comprehensive view of your database performance with several key sections:

### 1. Database Load Chart
The main chart shows database load over time, measured in Average Active Sessions (AAS).

**Key Elements:**
- **Y-axis:** Database load (AAS)
- **X-axis:** Time
- **Horizontal line:** vCPU count (performance baseline)
- **Colored areas:** Different wait event types

### 2. Top Dimensions Panel
Shows the top contributors to database load by various dimensions:
- **Top SQL:** Most resource-intensive queries
- **Top Wait Events:** Most common wait events
- **Top Hosts:** Hosts generating the most load
- **Top Users:** Users generating the most load
- **Top Databases:** Databases with highest load

## Interpreting the Database Load Chart

### Healthy Performance
```
DB Load (AAS)
     4 |                                    
     3 |     ████                          
     2 |  ████████████                     
     1 |████████████████████               
     0 |________________________________   
       0    5    10   15   20   25   30   Time (minutes)
       
vCPU Count: 4 (shown as horizontal line)
Status: ✅ Healthy (Load < vCPU count)
```

### Performance Issues
```
DB Load (AAS)
     8 |        ████████████               
     6 |     ████████████████              
     4 |  ████████████████████  ←── vCPU limit
     2 |████████████████████████           
     0 |________________________________   
       0    5    10   15   20   25   30   Time (minutes)
       
Status: ⚠️ Overloaded (Load > vCPU count)
```

## Wait Event Analysis

### Common MySQL Wait Events

#### 1. CPU
- **Color:** Usually red/orange
- **Meaning:** Active CPU processing
- **Action:** Check for CPU-intensive queries

#### 2. io/file/sql/binlog
- **Color:** Blue
- **Meaning:** Waiting for binary log writes
- **Action:** Consider faster storage or optimize write operations

#### 3. io/table/sql/handler
- **Color:** Green
- **Meaning:** Waiting for table I/O operations
- **Action:** Check indexes, consider read replicas

#### 4. synch/mutex/innodb
- **Color:** Purple
- **Meaning:** InnoDB internal locking
- **Action:** Optimize transactions, reduce lock contention

### Common PostgreSQL Wait Events

#### 1. CPU
- **Meaning:** Active CPU processing
- **Action:** Optimize queries, check for full table scans

#### 2. IO:DataFileRead
- **Meaning:** Reading data from disk
- **Action:** Increase shared_buffers, add indexes

#### 3. Lock:relation
- **Meaning:** Waiting for table locks
- **Action:** Optimize transactions, reduce lock duration

#### 4. LWLock:buffer_mapping
- **Meaning:** Buffer management contention
- **Action:** Increase shared_buffers, optimize queries

## Top SQL Analysis

### SQL Statement Details
When you click on a SQL statement, you'll see:

1. **SQL Text:** The actual query (may be truncated)
2. **Statistics:**
   - Load contribution
   - Executions per minute
   - Average latency
   - Rows examined/returned

3. **Performance Trends:**
   - Load over time
   - Execution frequency
   - Latency trends

### Example Analysis
```sql
-- High-load query example
SELECT * FROM orders o 
JOIN customers c ON o.customer_id = c.id 
WHERE o.order_date > '2024-01-01'
ORDER BY o.order_date DESC;

Statistics:
- Load: 2.5 AAS (50% of total load)
- Executions: 120/min
- Avg Latency: 1.2s
- Rows Examined: 1.2M
- Rows Returned: 15K
```

**Optimization Opportunities:**
- Add index on `order_date`
- Consider date range partitioning
- Limit result set size
- Use covering indexes

## Time Range Selection

### Available Time Ranges
- **Last hour:** Real-time troubleshooting
- **Last 3 hours:** Recent performance analysis
- **Last day:** Daily pattern analysis
- **Last week:** Weekly trend analysis
- **Custom range:** Specific incident investigation

### Granularity Options
- **5 minutes:** Default for free tier
- **1 minute:** Available with extended retention
- **1 hour:** For long-term trend analysis

## Filtering and Drill-Down

### Filter Options
1. **By SQL ID:** Focus on specific queries
2. **By User:** Analyze user-specific load
3. **By Host:** Identify problematic hosts
4. **By Database:** Multi-database analysis

### Drill-Down Process
1. **Identify high-load period** in main chart
2. **Click on time period** to zoom in
3. **Select top dimension** (SQL, Wait Event, etc.)
4. **Analyze specific contributor**
5. **View detailed statistics**

## Dashboard Navigation Tips

### 1. Start with the Big Picture
- Look at overall load trends
- Identify peak usage periods
- Check if load exceeds vCPU count

### 2. Identify Top Contributors
- Check Top SQL for expensive queries
- Look at Top Wait Events for bottlenecks
- Review Top Users/Hosts for load sources

### 3. Correlate Metrics
- Match high load periods with specific SQL
- Correlate wait events with query patterns
- Look for recurring performance issues

### 4. Use Time Correlation
- Compare current performance with historical
- Identify daily/weekly patterns
- Spot performance degradation trends

## Common Dashboard Patterns

### 1. CPU Bound Workload
```
Wait Events:
├── CPU: 70%
├── Lock waits: 20%
└── I/O waits: 10%

Action: Optimize CPU-intensive queries
```

### 2. I/O Bound Workload
```
Wait Events:
├── I/O operations: 60%
├── CPU: 25%
└── Lock waits: 15%

Action: Add indexes, optimize storage
```

### 3. Lock Contention
```
Wait Events:
├── Lock waits: 50%
├── CPU: 30%
└── I/O operations: 20%

Action: Optimize transactions, reduce lock duration
```

## Troubleshooting with Dashboard

### Scenario 1: Sudden Performance Degradation
1. **Check timeline** for when issues started
2. **Compare wait events** before/after incident
3. **Identify new SQL statements** or changes
4. **Look for resource exhaustion** patterns

### Scenario 2: Gradual Performance Decline
1. **Use longer time ranges** (week/month)
2. **Look for trending metrics** (increasing load)
3. **Check for data growth** impact
4. **Identify capacity planning needs**

### Scenario 3: Intermittent Issues
1. **Use detailed time granularity** (1-minute)
2. **Look for spike patterns**
3. **Correlate with application events**
4. **Check for batch job impacts**

## Best Practices

### 1. Regular Monitoring
- Check dashboard daily during business hours
- Set up automated alerts for key thresholds
- Review weekly performance trends

### 2. Baseline Establishment
- Document normal performance patterns
- Identify peak usage periods
- Set realistic performance targets

### 3. Proactive Analysis
- Monitor trending metrics
- Identify performance degradation early
- Plan capacity upgrades proactively

### 4. Documentation
- Document performance incidents
- Track optimization results
- Maintain performance runbooks

## Integration with Other Tools

### CloudWatch Integration
- Set up alarms for key Performance Insights metrics
- Create custom dashboards combining PI and CloudWatch
- Use CloudWatch Logs for detailed query analysis

### Application Monitoring
- Correlate database performance with application metrics
- Track end-to-end request latency
- Monitor connection pool utilization

### Database Logs
- Use slow query logs for detailed analysis
- Enable general query log for troubleshooting
- Correlate log entries with Performance Insights data

## Next Steps

1. **[Query Optimization](../optimization/)** - Learn query optimization techniques
2. **[Alerting Setup](../alerting/)** - Set up performance alerts
3. **[Best Practices](../best-practices/)** - Follow performance best practices
