---
title: "Query Optimization with Performance Insights"
date: 2024-07-14
weight: 40
description: "Learn how to use Performance Insights to identify and optimize slow queries"
---

## Query Optimization Process

Using Performance Insights for query optimization follows a systematic approach:

1. **Identify problematic queries** using Top SQL
2. **Analyze query execution patterns** and wait events
3. **Investigate query execution plans**
4. **Apply optimization techniques**
5. **Monitor optimization results**

## Identifying Problematic Queries

### Using Top SQL Panel

The Top SQL panel shows queries ranked by their contribution to database load:

```
Top SQL (by Load)
┌─────────────────────────────────────────────────────────┐
│ SQL ID: 0x1A2B3C4D5E6F | Load: 3.2 AAS (40%)          │
│ SELECT * FROM orders WHERE order_date > ?               │
│ Executions: 150/min | Avg Latency: 1.8s                │
├─────────────────────────────────────────────────────────┤
│ SQL ID: 0x2B3C4D5E6F7A | Load: 2.1 AAS (26%)          │
│ UPDATE inventory SET quantity = ? WHERE product_id = ?  │
│ Executions: 80/min | Avg Latency: 2.3s                 │
└─────────────────────────────────────────────────────────┘
```

### Key Metrics to Focus On

1. **High Load Contribution:** Queries contributing >10% of total load
2. **High Execution Frequency:** Queries running >100 times/minute
3. **High Average Latency:** Queries taking >1 second on average
4. **Trending Upward:** Queries with increasing load over time

## Query Analysis Techniques

### 1. Execution Statistics Analysis

For each problematic query, analyze:

```sql
-- Example problematic query
SELECT o.*, c.name, c.email 
FROM orders o 
JOIN customers c ON o.customer_id = c.id 
WHERE o.order_date >= '2024-01-01' 
ORDER BY o.order_date DESC 
LIMIT 100;

Performance Insights Metrics:
- Load: 2.5 AAS (31% of total)
- Executions: 200/min
- Avg Latency: 1.2s
- Rows Examined: 500K
- Rows Returned: 100
```

**Analysis:**
- High rows examined vs returned ratio (5000:1)
- Suggests missing or inefficient indexes
- ORDER BY without index causing filesort

### 2. Wait Event Analysis

Check what the query is waiting for:

```
Wait Events for SQL ID 0x1A2B3C4D5E6F:
├── io/table/sql/handler: 60% (I/O operations)
├── filesort: 25% (Sorting without index)
├── CPU: 10% (Processing)
└── synch/mutex/innodb: 5% (Lock contention)
```

**Interpretation:**
- High I/O waits suggest missing indexes
- Filesort waits indicate ORDER BY optimization needed
- Low CPU suggests not computation-bound

## Common Optimization Techniques

### 1. Index Optimization

#### Missing Index Detection
```sql
-- Before optimization
SELECT * FROM orders 
WHERE order_date >= '2024-01-01' 
  AND status = 'pending';

-- Performance Insights shows:
-- - High io/table/sql/handler waits
-- - Rows examined: 1M, Rows returned: 1K

-- Add composite index
CREATE INDEX idx_orders_date_status 
ON orders(order_date, status);

-- After optimization:
-- - Rows examined: 1K, Rows returned: 1K
-- - Latency reduced from 2.1s to 0.05s
```

#### Covering Index Implementation
```sql
-- Frequently accessed columns
SELECT order_id, customer_id, order_date, total_amount 
FROM orders 
WHERE status = 'completed' 
  AND order_date >= '2024-01-01';

-- Create covering index
CREATE INDEX idx_orders_covering 
ON orders(status, order_date, order_id, customer_id, total_amount);

-- Benefits:
-- - Eliminates table lookups
-- - Reduces I/O operations
-- - Improves query performance by 70%
```

### 2. Query Rewriting

#### Avoiding SELECT *
```sql
-- Problematic query
SELECT * FROM products p 
JOIN categories c ON p.category_id = c.id 
WHERE p.price > 100;

-- Optimized query
SELECT p.id, p.name, p.price, c.name as category_name 
FROM products p 
JOIN categories c ON p.category_id = c.id 
WHERE p.price > 100;

-- Performance improvement:
-- - Reduced data transfer
-- - Lower memory usage
-- - Faster network transmission
```

#### Optimizing JOINs
```sql
-- Inefficient JOIN order
SELECT o.order_id, c.name, p.product_name 
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
JOIN customers c ON o.customer_id = c.customer_id 
WHERE o.order_date >= '2024-01-01';

-- Optimized with proper JOIN order and conditions
SELECT o.order_id, c.name, p.product_name 
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id 
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
WHERE o.order_date >= '2024-01-01' 
  AND o.status = 'completed';
```

### 3. Pagination Optimization

#### Inefficient OFFSET Pagination
```sql
-- Problematic for large offsets
SELECT * FROM orders 
ORDER BY order_date DESC 
LIMIT 20 OFFSET 10000;

-- Performance Insights shows:
-- - High filesort waits
-- - Increasing latency with larger offsets
```

#### Cursor-based Pagination
```sql
-- Efficient cursor-based approach
SELECT * FROM orders 
WHERE order_date < '2024-01-15 10:30:00' 
ORDER BY order_date DESC 
LIMIT 20;

-- Benefits:
-- - Consistent performance regardless of page
-- - Uses index efficiently
-- - Eliminates filesort operations
```

## Database-Specific Optimizations

### MySQL Optimizations

#### InnoDB Configuration
```sql
-- Check current settings
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'innodb_log_file_size';

-- Optimize for your workload
SET GLOBAL innodb_buffer_pool_size = 1073741824; -- 1GB
SET GLOBAL innodb_log_buffer_size = 16777216;    -- 16MB
```

#### Query Cache (MySQL 5.7 and earlier)
```sql
-- Enable query cache for read-heavy workloads
SET GLOBAL query_cache_type = ON;
SET GLOBAL query_cache_size = 268435456; -- 256MB

-- Monitor cache effectiveness
SHOW STATUS LIKE 'Qcache%';
```

### PostgreSQL Optimizations

#### Configuration Tuning
```sql
-- Optimize shared_buffers
ALTER SYSTEM SET shared_buffers = '256MB';

-- Optimize work_mem for sorting/hashing
ALTER SYSTEM SET work_mem = '4MB';

-- Optimize effective_cache_size
ALTER SYSTEM SET effective_cache_size = '1GB';

-- Reload configuration
SELECT pg_reload_conf();
```

#### Statistics and Vacuum
```sql
-- Update table statistics
ANALYZE orders;

-- Vacuum to reclaim space
VACUUM ANALYZE orders;

-- Auto-vacuum configuration
ALTER SYSTEM SET autovacuum = on;
ALTER SYSTEM SET autovacuum_vacuum_scale_factor = 0.1;
```

## Monitoring Optimization Results

### Before and After Comparison

Track these metrics in Performance Insights:

```
Query Optimization Results:
┌─────────────────────────────────────────────────────────┐
│                    BEFORE    │    AFTER    │ IMPROVEMENT │
├─────────────────────────────────────────────────────────┤
│ Load (AAS)         │  2.5    │    0.3     │    -88%     │
│ Avg Latency        │  1.8s   │    0.2s    │    -89%     │
│ Executions/min     │  150    │    150     │     0%      │
│ Rows Examined      │  500K   │    1K      │    -99.8%   │
│ CPU Wait %         │  15%    │    60%     │   Changed   │
│ I/O Wait %         │  70%    │    25%     │   Reduced   │
└─────────────────────────────────────────────────────────┘
```

### Long-term Monitoring

Set up monitoring for:

1. **Query Performance Trends**
   - Track latency over time
   - Monitor execution frequency changes
   - Watch for performance regressions

2. **Resource Utilization**
   - CPU usage patterns
   - I/O operation trends
   - Memory utilization

3. **Wait Event Changes**
   - Shift from I/O to CPU waits (good)
   - Emergence of new wait events
   - Lock contention patterns

## Optimization Workflow

### 1. Identification Phase
```bash
# Use Performance Insights to identify top queries
# Focus on queries with:
# - Load > 10% of total
# - Latency > 1 second
# - High execution frequency
```

### 2. Analysis Phase
```sql
-- Get query execution plan
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM orders WHERE order_date > '2024-01-01';

-- Check index usage
SHOW INDEX FROM orders;

-- Analyze table statistics
SHOW TABLE STATUS LIKE 'orders';
```

### 3. Optimization Phase
```sql
-- Apply optimizations
CREATE INDEX idx_orders_date ON orders(order_date);

-- Rewrite query if needed
SELECT order_id, customer_id, total_amount 
FROM orders 
WHERE order_date > '2024-01-01';
```

### 4. Validation Phase
```bash
# Monitor in Performance Insights for:
# - Reduced query load
# - Improved latency
# - Changed wait event patterns
# - Overall database performance
```

## Best Practices

### 1. Systematic Approach
- Always measure before optimizing
- Focus on highest-impact queries first
- Test optimizations in staging environment
- Monitor results over time

### 2. Index Strategy
- Create indexes based on query patterns
- Avoid over-indexing (impacts writes)
- Use composite indexes effectively
- Regular index maintenance

### 3. Query Design
- Select only needed columns
- Use appropriate WHERE clauses
- Optimize JOIN conditions
- Consider query caching

### 4. Continuous Monitoring
- Regular Performance Insights reviews
- Set up alerts for performance degradation
- Track optimization results
- Plan for capacity growth

## Common Pitfalls

### 1. Over-Optimization
- Adding too many indexes
- Premature optimization
- Ignoring write performance impact

### 2. Incomplete Analysis
- Focusing only on individual queries
- Ignoring overall system impact
- Not considering concurrent workloads

### 3. Lack of Monitoring
- Not tracking optimization results
- Missing performance regressions
- Inadequate alerting setup

## Next Steps

1. **[Performance Alerting](../alerting/)** - Set up performance alerts
2. **[Capacity Planning](../capacity-planning/)** - Plan for future growth
3. **[Best Practices](../best-practices/)** - Follow optimization best practices
