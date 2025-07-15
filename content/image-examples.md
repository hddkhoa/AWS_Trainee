---
title: "Image Usage Examples in Hugo"
date: 2025-07-14
draft: false
---

# Examples of Adding Images

## 1. Basic Image
```markdown
![Image description](/images/image-name.jpg)
```

Result:
![CloudWatch Dashboard](/images/dashboard-example.png)

## 2. Image with Custom Size
```html
<img src="/images/image-name.jpg" alt="Description" width="600" height="400">
```

Result:
<img src="/images/alarm-setup.png" alt="Alarm Setup" width="600">

## 3. Image with Caption
```markdown
![RDS Performance](/images/rds-performance.png)
*Figure 1: RDS Performance Dashboard*
```

Result:
![RDS Performance](/images/rds-performance.png)
*Figure 1: RDS Performance Dashboard*

## 4. Multiple Images in One Section

### Step 1: Create Dashboard
![Step 1](/images/step1-create-dashboard.png)

### Step 2: Add Widget
![Step 2](/images/step2-add-widget.png)

### Step 3: Configure Metric
![Step 3](/images/step3-configure-metric.png)

## 5. Image with Link
```markdown
[![Click to view full size](/images/thumbnail.png)](/images/full-size.png)
```

## 6. Image with Border and Center Alignment
```html
<div align="center">
<img src="/images/architecture-diagram.png" alt="Architecture Diagram" style="border: 1px solid #ddd; border-radius: 4px; padding: 5px;">
</div>
```

## 7. Image Gallery
```html
<div style="display: flex; justify-content: space-around; flex-wrap: wrap;">
<img src="/images/before.png" alt="Before" width="300">
<img src="/images/after.png" alt="After" width="300">
</div>
```

## List of Images to Add:
- `/images/cloudwatch-console.png` - CloudWatch Interface
- `/images/create-dashboard.png` - Create New Dashboard  
- `/images/cpu-widget.png` - CPU Widget
- `/images/database-connections.png` - Database Connection Widget
- `/images/memory-widget.png` - Memory Widget
- `/images/create-alarm.png` - Create Alarm
- `/images/alarm-conditions.png` - Alarm Conditions
- `/images/performance-insights.png` - Performance Insights
- `/images/query-optimization.png` - Query Optimization
- `/images/monitoring-setup.png` - Monitoring Setup

## Notes for Using Images:
1. **Size Optimization:** Compress images for faster loading
2. **Alt Text:** Always add descriptions for accessibility
3. **Responsive:** Use CSS for good mobile display
4. **Lazy Loading:** Use loading="lazy" for large images
5. **Appropriate Format:** PNG for screenshots, JPG for photos
