---
title: "Query Rewriting"
date: 2025-07-15T11:00:00+07:00
weight: 20
draft: false
---

# Query Rewriting - Master Query Optimization Patterns

Rewriting or adjusting the structure of SQL queries can greatly impact how the database executes them. The goal is to help the database's Query Optimizer choose a more efficient execution plan.

## Basic Principles

### Avoid SELECT *
Only select the columns you actually need. This reduces the amount of data read from disk and transmitted over the network.

### Use JOIN instead of Subqueries (for some cases)

Sometimes, subqueries can be rewritten as JOINs to improve performance, especially IN subqueries.

**Example:**

Less optimal:
```sql
SELECT * FROM orders 
WHERE customer_id IN (SELECT id FROM customers WHERE region = 'Asia');
```

More optimal:
```sql
SELECT o.* FROM orders o 
JOIN customers c ON o.customer_id = c.id 
WHERE c.region = 'Asia';
```

### Avoid operations or functions on indexed columns in WHERE

If you apply a function to an indexed column in the WHERE clause, that index will not be used.

**Example:**

Less optimal:
```sql
SELECT * FROM users WHERE YEAR(registration_date) = 2023;
-- (will not use index on registration_date)
```

More optimal:
```sql
SELECT * FROM users 
WHERE registration_date BETWEEN '2023-01-01' AND '2023-12-31';
-- (can use index)
```

## Advanced Optimization Techniques

### Use LIMIT and OFFSET efficiently

When paginating, large OFFSET can be very slow because MySQL still has to read and discard many rows before returning results.

**Pagination optimization technique**: Use index and subquery to get PRIMARY KEY of needed rows first, then JOIN with main table.

### Optimize LIKE clauses

- If `LIKE '%value'`, index will not be used
- If `LIKE 'value%'`, index can be used
- Consider using Full-Text Search or specialized search solutions for complex string searches

### Use UNION ALL instead of UNION

UNION ALL doesn't remove duplicate records, so it's faster than UNION (unless you really need to remove duplicates).

### Avoid ORDER BY RAND()

Very slow on large datasets. Use other methods to get random samples (e.g., get a random ID in a range then query that ID).

## Optimization for Read and Write Operations

### Read (SELECT)
Focus on indexes, optimizing JOIN and WHERE clauses.

### Write (INSERT/UPDATE/DELETE)
Less likely to optimize by rewriting queries, but optimizing WHERE clauses is still important to find rows to update/delete quickly. For bulk INSERT, consider using `LOAD DATA INFILE` or `INSERT INTO ... VALUES (),(),()...`.

## Tools

**EXPLAIN** is the primary tool to see whether query rewriting produces a better execution plan.

---

*Next: Learn how to analyze [Execution Plans](../execution-plans/) to understand query performance.*
