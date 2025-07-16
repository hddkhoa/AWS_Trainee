---
title: "Thiết lập môi trường"
date: 2025-07-11T11:00:00+07:00
weight: 10
draft: false
---

# Thiết lập môi trường

## 🏗️ Môi trường phát triển

### Thiết lập môi trường phát triển cục bộ

#### Cài đặt các công cụ cần thiết
```bash
# Cài đặt AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Xác minh cài đặt
aws --version

# Cấu hình AWS credentials
aws configure
```

#### Công cụ Database Client
```bash
# PostgreSQL client
sudo apt-get install postgresql-client

# MySQL client  
sudo apt-get install mysql-client

# Universal database client (tùy chọn)
sudo snap install dbeaver-ce
```

#### Công cụ giám sát
```bash
# Cài đặt Python cho custom scripts
sudo apt-get install python3 python3-pip

# Cài đặt các Python packages cần thiết
pip3 install boto3 pandas matplotlib psycopg2-binary pymysql
```

---

## 🔧 Cấu hình môi trường AWS

### Thiết lập IAM

#### Tạo Performance Insights Role
```bash
# Tạo IAM policy cho Performance Insights
aws iam create-policy \
    --policy-name PerformanceInsightsPolicy \
    --policy-document file://performance-insights-policy.json

# Tạo IAM role
aws iam create-role \
    --role-name PerformanceInsightsRole \
    --assume-role-policy-document file://trust-policy.json

# Gắn policy vào role
aws iam attach-role-policy \
    --role-name PerformanceInsightsRole \
    --policy-arn arn:aws:iam::ACCOUNT-ID:policy/PerformanceInsightsPolicy
```

#### Tài liệu Policy

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

## 🗄️ Thiết lập môi trường cơ sở dữ liệu

### Cấu hình Parameter Group

#### PostgreSQL Parameter Group
```bash
# Tạo custom parameter group
aws rds create-db-parameter-group \
    --db-parameter-group-name pg-performance-insights \
    --db-parameter-group-family postgres13 \
    --description "Parameter group for Performance Insights"

# Cấu hình các tham số chính
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
# Tạo custom parameter group
aws rds create-db-parameter-group \
    --db-parameter-group-name mysql-performance-insights \
    --db-parameter-group-family mysql8.0 \
    --description "Parameter group for Performance Insights"

# Cấu hình các tham số chính
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

## 📊 Hạ tầng giám sát

### Thiết lập CloudWatch Dashboard

#### Tạo Custom Dashboard
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

# Thực thi tạo dashboard
create_performance_dashboard()
```

### SNS Topic cho Alerts
```bash
# Tạo SNS topic cho alerts
aws sns create-topic --name rds-performance-alerts

# Subscribe email vào topic
aws sns subscribe \
    --topic-arn arn:aws:sns:us-east-1:ACCOUNT-ID:rds-performance-alerts \
    --protocol email \
    --notification-endpoint your-email@company.com
```

---

## 🧪 Môi trường kiểm thử

### Thiết lập Test Database

#### Tạo Test RDS Instance
```bash
# Tạo test PostgreSQL instance
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

#### Tạo dữ liệu mẫu
```sql
-- Tạo bảng test
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

-- Tạo dữ liệu mẫu
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

## 🔍 Xác thực & Kiểm thử

### Script xác thực môi trường
```python
import boto3
import psycopg2
import sys

def validate_environment():
    """Xác thực rằng tất cả các thành phần được cấu hình đúng"""
    
    # Test AWS connectivity
    try:
        rds = boto3.client('rds')
        pi = boto3.client('pi')
        print("✓ Kết nối AWS thành công")
    except Exception as e:
        print(f"✗ Kết nối AWS thất bại: {e}")
        return False
    
    # Test RDS instance
    try:
        response = rds.describe_db_instances(
            DBInstanceIdentifier='test-performance-insights'
        )
        instance = response['DBInstances'][0]
        
        if instance['PerformanceInsightsEnabled']:
            print("✓ Performance Insights đã được kích hoạt")
        else:
            print("✗ Performance Insights chưa được kích hoạt")
            return False
            
    except Exception as e:
        print(f"✗ Kiểm tra RDS instance thất bại: {e}")
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
        print(f"✓ Kết nối cơ sở dữ liệu thành công: {version[0]}")
        conn.close()
    except Exception as e:
        print(f"✗ Kết nối cơ sở dữ liệu thất bại: {e}")
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
        print("✓ Performance Insights API có thể truy cập")
    except Exception as e:
        print(f"✗ Performance Insights API thất bại: {e}")
        return False
    
    print("\n🎉 Xác thực môi trường thành công!")
    return True

if __name__ == "__main__":
    if not validate_environment():
        sys.exit(1)
```

---

## 📋 Checklist môi trường

### Checklist trước khi thiết lập
- [ ] **AWS CLI đã cài đặt và cấu hình**
- [ ] **Công cụ database client đã cài đặt**
- [ ] **Môi trường Python đã thiết lập với các packages cần thiết**
- [ ] **IAM roles và policies đã tạo**
- [ ] **Parameter groups đã cấu hình**
- [ ] **Security groups đã cấu hình**

### Xác thực sau khi thiết lập
- [ ] **Test RDS instance đã tạo thành công**
- [ ] **Performance Insights đã kích hoạt và thu thập dữ liệu**
- [ ] **Kết nối cơ sở dữ liệu đã xác minh**
- [ ] **CloudWatch dashboard đã tạo**
- [ ] **SNS alerts đã cấu hình**
- [ ] **Dữ liệu mẫu đã tải**
- [ ] **Script xác thực đã pass tất cả tests**

### Tài liệu
- [ ] **Cấu hình môi trường đã được tài liệu hóa**
- [ ] **Access credentials đã lưu trữ an toàn**
- [ ] **Connection strings đã được tài liệu hóa**
- [ ] **Quy trình khắc phục sự cố đã được tài liệu hóa**
- [ ] **Quyền truy cập nhóm đã xác minh**

---

## 🔗 Bước tiếp theo

Với môi trường đã được thiết lập đúng cách, bạn đã sẵn sàng để:

1. **[Thiết lập Performance Insights](../../performance-insights/)** - Kích hoạt giám sát trên cơ sở dữ liệu production
2. **[Tối ưu hóa truy vấn](../../query-optimization/)** - Bắt đầu tối ưu hóa hiệu suất cơ sở dữ liệu
3. **[Giám sát & Cảnh báo](../../monitoring/)** - Triển khai giám sát toàn diện
4. **[Thực hành tốt nhất](../../best-practices/)** - Tuân theo các phương pháp đã được chứng minh

💡 **Tip:** 
Giữ môi trường test chạy trong suốt quá trình triển khai - nó rất có giá trị để test các thay đổi trước khi áp dụng vào production.

