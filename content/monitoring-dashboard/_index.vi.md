---
title: "4. Bảng điều khiển Giám sát"
date: 2025-07-14T14:00:00+07:00
weight: 40
chapter: true
pre: "<b>4. </b>"
draft: false
---

### Chương 4

# Bảng điều khiển Giám sát

Cung cấp cái nhìn trực quan, tập trung về hiệu suất cơ sở dữ liệu theo thời gian thực.

## Mục tiêu

Hiển thị các chỉ số quan trọng, phát hiện xu hướng và bất thường.

## Các công cụ

### Amazon CloudWatch Dashboards
Tùy chỉnh các widget hiển thị biểu đồ từ:
- CloudWatch Metrics
- Log Groups (bao gồm Slow Query Logs)

### Amazon RDS Performance Insights Dashboard
Cung cấp biểu đồ trực quan về:
- Tải cơ sở dữ liệu
- Phân tích các truy vấn SQL
- Sự kiện chờ
- Người dùng và máy chủ hàng đầu

Đây là công cụ chính để drill-down vào các vấn đề hiệu suất cấp độ DB.

### Grafana (tùy chọn)
Nếu bạn muốn một dashboard tùy chỉnh hơn và tích hợp dữ liệu từ nhiều nguồn:
- CloudWatch
- Prometheus
- Các nguồn dữ liệu khác

## Nội dung hiển thị

- **Tổng quan sức khỏe DB**: CPU, RAM, IOPS, Network
- **Tải DB**: Average Active Sessions (AAS) và phân tích các wait event, SQL hàng đầu
- **Số lượng kết nối** cơ sở dữ liệu
- **Tỷ lệ bộ nhớ đệm** (buffer cache hit ratio)
- **Trạng thái Replication** (nếu có Read Replicas)
