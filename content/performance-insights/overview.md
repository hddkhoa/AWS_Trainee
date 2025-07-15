---
title: "Performance Insights Overview"
date: 2024-07-14
weight: 10
description: "Introduction to Amazon RDS Performance Insights and its key features"
---

## What is Performance Insights?

Amazon RDS Performance Insights is a database performance monitoring tool that helps you:

- **Analyze database performance** visually and intuitively
- **Identify bottlenecks** and performance issues
- **Optimize queries** based on real data
- **Monitor real-time** and historical performance

## Key Features

### 1. Database Load Monitoring
- **DB Load:** Average number of active sessions
- **Wait Events:** Database wait events
- **Top SQL:** Most resource-intensive queries

### 2. Visual Dashboard
- **Timeline view:** View performance over time
- **Top dimensions:** Analyze by user, host, database
- **Drill-down capability:** Deep dive into specific metrics

### 3. Query Analysis
- **SQL statement analysis:** Analyze individual SQL statements
- **Execution statistics:** Execution statistics
- **Performance trends:** Performance trends over time

## Supported Database Engines

Performance Insights supports the following engines:

### Amazon Aurora
- **Aurora MySQL:** Versions 5.6, 5.7, 8.0
- **Aurora PostgreSQL:** Versions 9.6, 10, 11, 12, 13, 14, 15

### Amazon RDS
- **MySQL:** 5.6, 5.7, 8.0
- **PostgreSQL:** 9.6, 10, 11, 12, 13, 14, 15
- **MariaDB:** 10.2, 10.3, 10.4, 10.5, 10.6
- **Oracle:** 12c, 19c, 21c
- **SQL Server:** 2016, 2017, 2019, 2022

## Key Metrics Explained

### 1. DB Load
- **Definition:** Average number of active sessions
- **Unit:** Average Active Sessions (AAS)
- **Meaning:** 
  - Load < vCPU count: Database performing well
  - Load > vCPU count: Database may have bottlenecks

### 2. Wait Events
Common wait event types:

#### MySQL Wait Events:
- **io/file/sql/binlog:** Waiting for binary log writes
- **io/table/sql/handler:** Waiting for table data reads/writes
- **synch/mutex/innodb:** Waiting for InnoDB mutex
- **synch/cond/sql/MYSQL_BIN_LOG:** Waiting for binary log condition

#### PostgreSQL Wait Events:
- **CPU:** CPU processing
- **IO:DataFileRead:** Reading data files
- **Lock:relation:** Waiting for table locks
- **LWLock:buffer_mapping:** Waiting for buffer mapping

### 3. Top SQL
- **SQL ID:** Unique identifier for each query
- **Load:** Average load of the query
- **Executions:** Number of executions
- **Avg Latency:** Average latency

## Benefits of Performance Insights

### 1. Proactive Monitoring
- **Real-time alerts:** Alerts when issues occur
- **Historical analysis:** Analyze historical trends
- **Capacity planning:** Plan for scaling

### 2. Query Optimization
- **Identify slow queries:** Find slow queries
- **Resource consumption:** Analyze resource consumption
- **Optimization recommendations:** Optimization suggestions

### 3. Cost Optimization
- **Right-sizing instances:** Choose appropriate instance sizes
- **Resource utilization:** Optimize resource usage
- **Performance vs cost:** Balance performance and cost

## Pricing

### Free Tier
- **Retention:** 7 days
- **Granularity:** 5 minutes
- **Cost:** Free

### Extended Retention
- **Retention:** Up to 2 years
- **Granularity:** 1 minute
- **Cost:** $0.02 per vCPU per day

### Cost Examples:
```
db.t3.micro (1 vCPU):
- 7 days retention: $0/month
- 1 year retention: ~$0.60/month

db.r5.large (2 vCPU):
- 7 days retention: $0/month  
- 1 year retention: ~$1.20/month
```

## Common Use Cases

### 1. Performance Troubleshooting
- Application suddenly running slow
- High database response times
- Timeout errors from applications

### 2. Capacity Planning
- Predict when to scale up
- Analyze growth patterns
- Optimize instance sizing

### 3. Query Optimization
- Find most expensive queries
- Analyze execution plans
- Monitor optimization results

### 4. Proactive Monitoring
- Set up alerts for key metrics
- Monitor database health
- Prevent performance issues

## Best Practices

### 1. Enable Early
- Enable Performance Insights when creating RDS
- No significant performance impact
- Historical data is valuable

### 2. Monitor Key Metrics
- **DB Load:** Should not exceed vCPU count
- **Wait Events:** Identify bottlenecks
- **Top SQL:** Focus on high-impact queries

### 3. Regular Reviews
- Weekly performance reviews
- Monthly capacity planning
- Quarterly optimization cycles

### 4. Combine with Other Tools
- CloudWatch metrics
- Enhanced Monitoring
- Database logs
- Application monitoring

## Limitations

### 1. Data Retention
- Free tier: only 7 days
- Maximum: 2 years
- Cannot export raw data

### 2. Granularity
- Minimum: 5 minutes (free tier)
- Maximum: 1 minute (paid)
- No real-time streaming

### 3. Query Text
- May be truncated if too long
- Sensitive data may be visible
- No query parameterization

## Getting Started

1. **[Setup & Configuration](../setup/)** - Set up Performance Insights
2. **[Dashboard Overview](../dashboard/)** - Learn about the dashboard
3. **[Query Analysis](../analysis/)** - Analyze queries
4. **[Optimization Techniques](../optimization/)** - Optimization techniques

## Conclusion

Performance Insights is a powerful and easy-to-use tool for:
- Monitoring database performance
- Optimizing queries and performance
- Capacity planning
- Troubleshooting performance issues

With the free 7-day tier, you can start using it immediately without incurring costs.
