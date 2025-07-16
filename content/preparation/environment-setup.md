---
title: "Environment Setup"
date: 2025-07-11T11:00:00+07:00
weight: 10
draft: false
---

# Environment Setup

## 🏗️ Development Environment

### Local Development Setup

#### Required Tools Installation
```bash
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify installation
aws --version

# Configure AWS credentials
aws configure
```

#### Database Client Tools
```bash
# PostgreSQL client
sudo apt-get install postgresql-client

# MySQL client  
sudo apt-get install mysql-client

# Universal database client (optional)
sudo snap install dbeaver-ce
```

#### Monitoring Tools
```bash
# Install Python for custom scripts
sudo apt-get install python3 python3-pip

# Install required Python packages
pip3 install boto3 pandas matplotlib psycopg2-binary pymysql
```

---

## 🔧 AWS Environment Configuration

### IAM Setup

#### Create Performance Insights Role
```bash
# Create IAM policy for Performance Insights
aws iam create-policy \
    --policy-name PerformanceInsightsPolicy \
    --policy-document file://performance-insights-policy.json

# Create IAM role
aws iam create-role \
    --role-name PerformanceInsightsRole \
    --assume-role-policy-document file://trust-policy.json

# Attach policy to role
aws iam attach-role-policy \
    --role-name PerformanceInsightsRole \
    --policy-arn arn:aws:iam::ACCOUNT-ID:policy/PerformanceInsightsPolicy
```

#### Policy Documents

**performance-insights-policy.json**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "pi:*",
                "rds:DescribeDBInstances",
                "rds:DescribeDBClusters",
                "rds:DescribeDBParameterGroups",
                "rds:DescribeDBParameters",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
```

**trust-policy.json**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "rds.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

---

## 🗄️ Database Environment Setup

### Parameter Group Configuration

#### PostgreSQL Parameter Group
```bash
# Create custom parameter group
aws rds create-db-parameter-group \
    --db-parameter-group-name pg-performance-insights \
    --db-parameter-group-family postgres13 \
    --description "Parameter group for Performance Insights"

# Configure key parameters
aws rds modify-db-parameter-group \
    --db-parameter-group-name pg-performance-insights \
    --parameters "ParameterName=shared_preload_libraries,ParameterValue=pg_stat_statements,ApplyMethod=pending-reboot"

aws rds modify-db-parameter-group \
    --db-parameter-group-name pg-performance-insights \
    --parameters "ParameterName=log_statement,ParameterValue=all,ApplyMethod=immediate"

aws rds modify-db-parameter-group \
    --db-parameter-group-name pg-performance-insights \
    --parameters "ParameterName=log_min_duration_statement,ParameterValue=1000,ApplyMethod=immediate"
```

#### MySQL Parameter Group
```bash
# Create custom parameter group
aws rds create-db-parameter-group \
    --db-parameter-group-name mysql-performance-insights \
    --db-parameter-group-family mysql8.0 \
    --description "Parameter group for Performance Insights"

# Configure key parameters
aws rds modify-db-parameter-group \
    --db-parameter-group-name mysql-performance-insights \
    --parameters "ParameterName=performance_schema,ParameterValue=1,ApplyMethod=pending-reboot"

aws rds modify-db-parameter-group \
    --db-parameter-group-name mysql-performance-insights \
    --parameters "ParameterName=slow_query_log,ParameterValue=1,ApplyMethod=immediate"

aws rds modify-db-parameter-group \
    --db-parameter-group-name mysql-performance-insights \
    --parameters "ParameterName=long_query_time,ParameterValue=2,ApplyMethod=immediate"
```

---

## 📊 Monitoring Infrastructure

### CloudWatch Dashboard Setup

#### Create Custom Dashboard
```python
import boto3
import json

def create_performance_dashboard():
    cloudwatch = boto3.client('cloudwatch')
    
    dashboard_body = {
        "widgets": [
            {
                "type": "metric",
                "x": 0, "y": 0,
                "width": 12, "height": 6,
                "properties": {
                    "metrics": [
                        ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "your-db-instance"],
                        [".", "DatabaseConnections", ".", "."],
                        [".", "ReadLatency", ".", "."],
                        [".", "WriteLatency", ".", "."]
                    ],
                    "period": 300,
                    "stat": "Average",
                    "region": "us-east-1",
                    "title": "RDS Performance Metrics"
                }
            },
            {
                "type": "metric",
                "x": 0, "y": 6,
                "width": 12, "height": 6,
                "properties": {
                    "metrics": [
                        ["AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", "your-db-instance"],
                        [".", "WriteIOPS", ".", "."]
                    ],
                    "period": 300,
                    "stat": "Average",
                    "region": "us-east-1",
                    "title": "RDS IOPS Metrics"
                }
            }
        ]
    }
    
    response = cloudwatch.put_dashboard(
        DashboardName='RDS-Performance-Insights',
        DashboardBody=json.dumps(dashboard_body)
    )
    
    return response

# Execute dashboard creation
create_performance_dashboard()
```

### SNS Topic for Alerts
```bash
# Create SNS topic for alerts
aws sns create-topic --name rds-performance-alerts

# Subscribe email to topic
aws sns subscribe \
    --topic-arn arn:aws:sns:us-east-1:ACCOUNT-ID:rds-performance-alerts \
    --protocol email \
    --notification-endpoint your-email@company.com
```

---

## 🧪 Testing Environment

### Test Database Setup

#### Create Test RDS Instance
```bash
# Create test PostgreSQL instance
aws rds create-db-instance \
    --db-instance-identifier test-performance-insights \
    --db-instance-class db.t3.micro \
    --engine postgres \
    --engine-version 13.7 \
    --master-username testuser \
    --master-user-password YourSecurePassword123! \
    --allocated-storage 20 \
    --db-parameter-group-name pg-performance-insights \
    --enable-performance-insights \
    --performance-insights-retention-period 7 \
    --backup-retention-period 7 \
    --storage-encrypted \
    --vpc-security-group-ids sg-12345678 \
    --db-subnet-group-name default
```

#### Sample Data Generation
```sql
-- Create test tables
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20)
);

-- Generate sample data
INSERT INTO customers (name, email)
SELECT 
    'Customer ' || generate_series,
    'customer' || generate_series || '@example.com'
FROM generate_series(1, 10000);

INSERT INTO orders (customer_id, order_date, total_amount, status)
SELECT 
    (random() * 10000)::integer + 1,
    CURRENT_DATE - (random() * 365)::integer,
    (random() * 1000)::decimal(10,2),
    CASE WHEN random() < 0.8 THEN 'completed' ELSE 'pending' END
FROM generate_series(1, 50000);
```

---

## 🔍 Validation & Testing

### Environment Validation Script
```python
import boto3
import psycopg2
import sys

def validate_environment():
    """Validate that all components are properly configured"""
    
    # Test AWS connectivity
    try:
        rds = boto3.client('rds')
        pi = boto3.client('pi')
        print("✓ AWS connectivity successful")
    except Exception as e:
        print(f"✗ AWS connectivity failed: {e}")
        return False
    
    # Test RDS instance
    try:
        response = rds.describe_db_instances(
            DBInstanceIdentifier='test-performance-insights'
        )
        instance = response['DBInstances'][0]
        
        if instance['PerformanceInsightsEnabled']:
            print("✓ Performance Insights enabled")
        else:
            print("✗ Performance Insights not enabled")
            return False
            
    except Exception as e:
        print(f"✗ RDS instance check failed: {e}")
        return False
    
    # Test database connectivity
    try:
        conn = psycopg2.connect(
            host=instance['Endpoint']['Address'],
            port=instance['Endpoint']['Port'],
            database='postgres',
            user='testuser',
            password='YourSecurePassword123!'
        )
        cursor = conn.cursor()
        cursor.execute('SELECT version();')
        version = cursor.fetchone()
        print(f"✓ Database connectivity successful: {version[0]}")
        conn.close()
    except Exception as e:
        print(f"✗ Database connectivity failed: {e}")
        return False
    
    # Test Performance Insights API
    try:
        response = pi.get_resource_metrics(
            ServiceType='RDS',
            Identifier=instance['DbiResourceId'],
            MetricQueries=[
                {
                    'Metric': 'db.load.avg'
                }
            ],
            StartTime='2023-01-01T00:00:00Z',
            EndTime='2023-01-01T01:00:00Z'
        )
        print("✓ Performance Insights API accessible")
    except Exception as e:
        print(f"✗ Performance Insights API failed: {e}")
        return False
    
    print("\n🎉 Environment validation successful!")
    return True

if __name__ == "__main__":
    if not validate_environment():
        sys.exit(1)
```

---

## 📋 Environment Checklist

### Pre-Setup Checklist
- [ ] **AWS CLI installed and configured**
- [ ] **Database client tools installed**
- [ ] **Python environment set up with required packages**
- [ ] **IAM roles and policies created**
- [ ] **Parameter groups configured**
- [ ] **Security groups configured**

### Post-Setup Validation
- [ ] **Test RDS instance created successfully**
- [ ] **Performance Insights enabled and collecting data**
- [ ] **Database connectivity verified**
- [ ] **CloudWatch dashboard created**
- [ ] **SNS alerts configured**
- [ ] **Sample data loaded**
- [ ] **Validation script passes all tests**

### Documentation
- [ ] **Environment configuration documented**
- [ ] **Access credentials securely stored**
- [ ] **Connection strings documented**
- [ ] **Troubleshooting procedures documented**
- [ ] **Team access verified**

---

## 🔗 Next Steps

With your environment properly set up, you're ready to:

1. **[Performance Insights Setup](../../performance-insights/)** - Enable monitoring on production databases
2. **[Query Optimization](../../query-optimization/)** - Begin optimizing database performance
3. **[Monitoring & Alerting](../../monitoring/)** - Implement comprehensive monitoring
4. **[Best Practices](../../best-practices/)** - Follow proven methodologies

💡 **Tip:** 
Keep your test environment running throughout the implementation process - it's invaluable for testing changes before applying them to production.

