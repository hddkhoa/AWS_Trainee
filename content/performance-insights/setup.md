---
title: "Setting up RDS Instance with Performance Insights"
date: 2024-07-14
weight: 20
description: "Detailed guide on creating RDS Instance and enabling Performance Insights"
---

## 1. Creating RDS Instance with Performance Insights

### Step 1: Access RDS Console


1. Log in to AWS Console
2. Search for "RDS" in the search bar
3. Click on "Amazon RDS"



### Step 2: Create Database
<img src="/images/2025-07-14_15-55-30.png" alt="2025-07-14_15-55-30" width="800">

1. Click the orange "Create database" button
2. Select "Standard create" (not Easy create)
3. Engine options:
   • Choose MySQL (or PostgreSQL as needed)
   • Version: Select the latest version (e.g., MySQL 8.0.35)



### Step 3: Templates and Settings
<img src="/images/2025-07-14_15-58-04.png" alt="2025-07-14_15-58-04" width="800">

1. Templates: Choose "Free tier" (if eligible) or "Dev/Test"
2. Settings:
   • **DB instance identifier:** mydb-performance-test
   • **Master username:** admin
   • **Master password:** Create a strong password or select "Auto generate"



### Step 4: Instance Configuration
<img src="/images/2025-07-14_16-02-05.png" alt="2025-07-14_16-02-05" width="800">

1. DB instance class:
   • Select "Burstable classes (includes t classes)"
   • Choose db.t3.micro (Free tier) or db.t3.small
2. Storage:
   • **Storage type:** General Purpose SSD (gp2)
   • **Allocated storage:** 20 GB
   • Uncheck "Enable storage autoscaling" (to save costs)



### Step 5: Connectivity
<img src="/images/2025-07-14_16-03-40.png" alt="2025-07-14_16-03-40" width="800">

1. Virtual private cloud (VPC): Select Default VPC
2. Subnet group: default
3. Public access: Select "Yes" (for external testing)
4. VPC security group: 
   • Select "Create new"
   • **New VPC security group name:** rds-performance-sg


### Step 6: Database Authentication
1. Database authentication: Select "Password authentication"



### Step 7: Monitoring 
⚠️ **Warning:** 
(Important!)



<img src="/images/2025-07-14_16-08-09.png" alt="2025-07-14_16-08-09" width="800">

1. Enable Enhanced monitoring: Check the box
   • **Granularity:** 60 seconds
   • **Monitoring Role:** Select "Default" or create new
2. **Enable Performance Insights: CHECK THIS ✅**
   • **Retention period:** Select "7 days (free)"
   • **Master key:** Select "Default"



### Step 8: Additional Configuration
<img src="/images/2025-07-14_16-10-09.png" alt="2025-07-14_16-10-09" width="800">

1. Initial database name: testdb
2. DB parameter group: default
3. Backup:
   • **Backup retention period:** 7 days
   • **Backup window:** Choose low-usage time
4. Maintenance:
   • **Enable auto minor version upgrade:** Check
   • **Maintenance window:** Choose low-usage time



### Step 9: Create Database
<img src="/images/2025-07-14_16-11-19.png" alt="2025-07-14_16-11-19" width="800">
<img src="/images/2025-07-14_16-45-15.png" alt="2025-07-14_16-45-15" width="800">

1. Click "Create database"
2. Wait 10-15 minutes for database creation
3. Status will change from "Creating" → "Available"





## 2. Enabling Performance Insights on Existing RDS

If you already have an RDS instance and want to enable Performance Insights:

### Step 1: Select Database
<img src="/images/22.png" alt="22" width="800">

1. Go to RDS Console
2. Click "Databases" in the sidebar
3. Select the database instance to enable

### Step 2: Modify Database
<img src="/images/33.png" alt="33" width="800">

1. Click the "Modify" button
2. Scroll down to "Monitoring" section
3. Find "Performance Insights"
4. Check "Enable Performance Insights"
5. Select retention period (7 days free)
6. Click "Continue"

### Step 3: Apply Changes
1. Choose "Apply immediately" or "Apply during maintenance window"
2. Click "Modify DB instance"

## 3. Verify Performance Insights is Working

### Check Status:
1. Go to RDS Console
2. Select database instance
3. "Configuration" tab → check "Performance Insights" = Enabled
4. "Monitoring" tab → should have "View in Performance Insights" link

### Access Performance Insights Dashboard:
1. Click "View in Performance Insights"
2. Or go to "Performance Insights" menu in RDS sidebar
3. Select database from dropdown

## 4. Configure Security Group

To connect from outside, configure Security Group:

```bash
# Find Security Group ID
aws ec2 describe-security-groups --group-names rds-performance-sg

# Add rule for MySQL (port 3306)
aws ec2 authorize-security-group-ingress \
    --group-id sg-xxxxxxxxx \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0
```

⚠️ **Security Note:** Only open 0.0.0.0/0 for test environments. In production, restrict to specific IPs.

## 5. Test Connection

```bash
# Install MySQL client
sudo apt-get install mysql-client

# Connect to RDS
mysql -h mydb-performance-test.xxxxxxxxx.us-east-1.rds.amazonaws.com \
      -u admin -p testdb
```

## 6. Using AWS CLI to Create RDS with Performance Insights

You can also create the RDS instance using AWS CLI:

```bash
# Create RDS instance with Performance Insights enabled
aws rds create-db-instance \
    --db-instance-identifier mydb-performance-test \
    --db-instance-class db.t3.micro \
    --engine mysql \
    --engine-version 8.0.35 \
    --master-username admin \
    --master-user-password YourStrongPassword123! \
    --allocated-storage 20 \
    --storage-type gp2 \
    --vpc-security-group-ids sg-xxxxxxxxx \
    --db-name testdb \
    --backup-retention-period 7 \
    --monitoring-interval 60 \
    --monitoring-role-arn arn:aws:iam::123456789012:role/rds-monitoring-role \
    --enable-performance-insights \
    --performance-insights-retention-period 7 \
    --publicly-accessible \
    --region us-east-1
```

## Troubleshooting

### Common Issues:
1. **Performance Insights not showing data:**
   - Wait 5-10 minutes after enabling
   - Check if there's traffic to the database

2. **Cannot connect to database:**
   - Check Security Group rules
   - Verify Public accessibility = Yes
   - Check VPC and Subnet configuration

3. **Enhanced Monitoring not working:**
   - Check IAM role permissions
   - Recreate monitoring role if needed

4. **Performance Insights dashboard empty:**
   - Ensure database has some query activity
   - Check retention period settings
   - Verify Performance Insights is enabled

## Cost Estimation

- **RDS db.t3.micro:** ~$12.41/month (Free tier: 750 hours/month)
- **Performance Insights:** Free for 7 days retention
- **Enhanced Monitoring:** ~$2.50/month for 60-second granularity
- **Storage 20GB:** ~$2.30/month

**Total:** ~$17/month (or free if within Free tier limits)

## Next Steps

Once your RDS instance is running with Performance Insights enabled:

1. Generate some database load for testing
2. Explore the Performance Insights dashboard
3. Learn to interpret the metrics and wait events
4. Set up CloudWatch alarms for key metrics
5. Practice query optimization techniques
