---
title: "2. Preparation"
date: 2025-07-11T11:00:00+07:00
weight: 20
chapter: true
pre: "<b>2. </b>"
draft: false
---

### Chapter 2

# Preparation

Learn how to prepare your environment and gather prerequisites for implementing RDS Performance Insights and query optimization.

## Prerequisites

Before you begin with RDS Performance Insights, ensure you have:

- **AWS Account** with appropriate permissions
- **RDS Instance** running a supported engine (MySQL, PostgreSQL, Oracle, SQL Server, MariaDB)
- **AWS CLI** configured with proper credentials
- **Basic understanding** of SQL and database concepts

## Supported Database Engines

Performance Insights is available for the following RDS engines:

| Engine | Minimum Version | Notes |
|--------|----------------|-------|
| MySQL | 5.6.10+ | All instance classes supported |
| PostgreSQL | 9.6+ | All instance classes supported |
| Oracle | 12.1.0.2+ | Requires Enterprise Edition |
| SQL Server | 2016+ | All editions supported |
| MariaDB | 10.1+ | All instance classes supported |

## Required Permissions

Your AWS user or role needs the following permissions:

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

## Environment Setup

Follow these steps to prepare your environment:

1. **Enable Performance Insights** on your RDS instance
2. **Configure retention period** (7 days free, up to 2 years with additional cost)
3. **Set up monitoring tools** and dashboards
4. **Prepare test workloads** for performance analysis

## Cost Considerations

- **Free tier**: 7 days of Performance Insights data retention
- **Extended retention**: Additional charges apply for retention beyond 7 days
- **No additional charges** for the Performance Insights feature itself
- **Monitor costs** through AWS Cost Explorer and billing alerts

Ready to proceed? Let's move on to setting up Performance Insights!
