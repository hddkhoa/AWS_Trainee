---
title: "10. Cleanup Resources"
date: 2025-07-15T11:00:00+07:00
weight: 100
chapter: true
pre: "<b>10. </b>"
draft: false
---

### Chapter 10

# Cleanup Resources

After completing the RDS Performance Insights workshop, it's important to clean up the AWS resources to avoid unnecessary charges. Follow these steps to properly remove all created resources.

## 🗑️ Resource Cleanup Steps

### 1. Delete RDS Instance

Navigate to the RDS Console and remove your database instance:

1. **Open RDS Console** → Select your instance
2. **Actions** → **Delete**
3. **Create final snapshot:** Select **No** (to save costs)
4. **Type "delete me"** to confirm deletion
5. Click **Delete DB Instance**

> **Warning**: This action is irreversible. Make sure you have backed up any important data before proceeding.

### 2. Delete CloudWatch Alarms

Remove all monitoring alarms created during the workshop:

1. **CloudWatch Console** → **Alarms**
2. **Select all workshop-related alarms**
3. **Actions** → **Delete**
4. **Confirm deletion**

### 3. Delete SNS Topic

Clean up notification topics:

1. **SNS Console** → **Topics**
2. **Select the topic** created for RDS alerts
3. **Delete**
4. **Confirm by typing "delete me"**

### 4. Delete CloudWatch Dashboard

Remove the monitoring dashboard:

1. **CloudWatch Console** → **Dashboards**
2. **Select your RDS dashboard**
3. **Actions** → **Delete**
4. **Confirm deletion**

## 💰 Cost Optimization Tips

- **Always delete unused resources** to avoid ongoing charges
- **Set up billing alerts** to monitor AWS spending
- **Use AWS Cost Explorer** to track resource costs
- **Consider using AWS Budgets** for cost management

## ✅ Verification Checklist

After cleanup, verify that all resources have been removed:

- [ ] RDS Instance deleted
- [ ] CloudWatch Alarms removed
- [ ] SNS Topics deleted
- [ ] CloudWatch Dashboards removed
- [ ] No unexpected charges in billing

## 🎯 Best Practices for Future Projects

1. **Tag resources** for easy identification and cleanup
2. **Document resource dependencies** before deletion
3. **Use Infrastructure as Code** (CloudFormation/Terraform) for easier cleanup
4. **Set up automated cleanup** for development environments
5. **Regular resource audits** to identify unused resources

---

*Congratulations! You have successfully completed the RDS Performance Insights workshop and cleaned up all resources. 🎉*
