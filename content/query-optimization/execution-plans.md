---
title: "Execution Plans"
date: 2025-07-15T11:00:00+07:00
weight: 30
draft: false
---

# Execution Plans - Understanding and Analyzing Query Plans

An execution plan is the "roadmap" that the database will follow to execute a query. Understanding it is the key to diagnosing and fixing query performance issues.

## How to Get Execution Plans

### Using EXPLAIN
Use the `EXPLAIN` command before any SQL query:
```sql
EXPLAIN SELECT * FROM users WHERE id = 1;
```

### Using EXPLAIN ANALYZE
Available in recent MySQL versions and PostgreSQL to actually run the query and collect real-time statistics about the execution plan, including time and actual number of rows processed:
```sql
EXPLAIN ANALYZE SELECT * FROM users WHERE id = 1;
```

## Key Elements to Analyze in an Execution Plan

### type
Indicates the table access method:
- `ALL` - Bad (full table scan)
- `ref`, `eq_ref`, `const` - Good (using indexes effectively)

### key
Which index is being used. If `NULL`, no index is being used.

### rows
Estimated number of rows that MySQL must examine. The smaller this number, the better. A large number indicates inefficient table or index scanning.

### filtered
Estimated percentage of rows remaining after applying table conditions. A low value indicates many rows were read but then discarded.

### Extra
Provides important information about additional operations the optimizer must perform:

#### Using filesort
Sorting data using an expensive algorithm. Try to use index for sorting (add ORDER BY columns to index).

#### Using temporary
MySQL needs to create a temporary table on disk or in memory to process the query (e.g., for GROUP BY or DISTINCT that can't use index). Try to optimize the query to avoid this.

#### Using where
WHERE clause is applied to filter rows. If combined with ALL, it indicates inefficient table scanning.

#### Using index
Very good! The query is satisfied entirely by using the index (covering index), no need to access table data.

#### Using join buffer
Data is being stored in buffer for joins, which may indicate an inefficient join.

## Common Performance Issues and Solutions

### Full Table Scans (type = ALL)
**Problem**: Database reads every row in the table
**Solution**: Add appropriate indexes on WHERE clause columns

### Large Row Counts
**Problem**: High number in `rows` column
**Solution**: 
- Add more selective indexes
- Rewrite query to be more specific
- Consider query optimization

### Using filesort
**Problem**: Expensive sorting operation
**Solution**: Create composite index including ORDER BY columns

### Using temporary
**Problem**: Temporary table creation overhead
**Solution**: 
- Optimize GROUP BY clauses
- Add appropriate indexes
- Rewrite query structure

## Best Practices for Execution Plan Analysis

1. **Always check the `type` column first** - Avoid `ALL` scans
2. **Look for `NULL` in the `key` column** - Indicates missing indexes
3. **Monitor the `rows` column** - High numbers suggest optimization opportunities
4. **Pay attention to `Extra` information** - Provides crucial optimization hints
5. **Use EXPLAIN ANALYZE when possible** - Get actual vs estimated statistics

## Tools and Techniques

- **MySQL Workbench**: Visual execution plan display
- **Performance Schema**: Advanced query analysis
- **Slow Query Log**: Identify problematic queries
- **Performance Insights**: AWS RDS specific analysis tools

---

*Previous: [Query Rewriting](../query-rewriting/) | Next: Return to [Query Optimization Overview](../)*
