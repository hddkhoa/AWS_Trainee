---
title: "Index Strategies"
date: 2025-07-15T11:00:00+07:00
weight: 10
draft: false
---

# Index Strategies - Advanced Indexing Techniques

Effective use of indexes is the most important factor in speeding up queries. An index is like a table of contents in a book, helping the database find data faster without having to scan the entire table.

## Importance of Indexes

When a query is executed, if there is no suitable index, the database must perform a full table scan to search for data, which is especially expensive with large tables. Indexes help the database locate the necessary data rows more directly.

## Basic Index Types

### Primary Key Index
- Automatically created when you define a primary key
- Ensures uniqueness and does not allow NULL values

### Unique Index
- Ensures all values in the indexed column are unique
- Allows only one NULL value

### Non-Unique Index
- Regular index that allows duplicate values

## Advanced Index Techniques

### Composite Indexes (Multi-column Indexes)

Create indexes on multiple columns:
```sql
CREATE INDEX idx_name_dob ON users (last_name, first_name, date_of_birth);
```

**Column order is crucial**: The order of columns in the index must match the columns in the WHERE, ORDER BY, and GROUP BY clauses of the query for maximum efficiency.

Example:
- `WHERE last_name = 'Smith' AND first_name = 'John'` will use the index on (last_name, first_name)
- `WHERE first_name = 'John'` will not fully utilize this index (only uses the beginning part of the index if available)

**Leftmost Prefix Optimization**: Composite indexes are only effective when you use columns from left to right of the index in your WHERE clause.

### Covering Indexes

A covering index is an index that contains all the columns that the query needs (in SELECT, WHERE, ORDER BY, GROUP BY clauses).

When there is a covering index, the database doesn't need to access the original table to get additional data, significantly improving speed.

Example:
```sql
SELECT first_name, last_name FROM users WHERE last_name = 'Smith';
```

This can be covered by `idx_name_dob` if `first_name` is also part of the index. EXPLAIN will show "Using index" in the Extra column.

### Functional Indexes
(More common in PostgreSQL, Oracle, but MySQL also has limitations)

Allows indexing on the result of a function or expression. Useful when you frequently query based on calculated values.

### Partial Indexes
(More common in PostgreSQL)

Only indexes a subset of rows in the table based on a certain condition. Helps reduce index size and speed up queries targeting that dataset. (MySQL can simulate using different strategies).

## When to Use and Not Use Indexes

### Should Use:
- Columns frequently appearing in WHERE, JOIN, ORDER BY, GROUP BY
- Columns with many unique values

### Should Not Use:
- Columns with very few unique values (e.g., gender)
- Very small tables
- Tables with very high write frequency (INSERT/UPDATE/DELETE), as each write must update the index, causing I/O overhead

## Tools

- Use **EXPLAIN** to identify queries that don't use indexes or use them inefficiently
- **Database Insights** will show you the slowest queries, which are top candidates for indexing

---

*Next: Learn about [Query Rewriting](../query-rewriting/) techniques to optimize your SQL statements.*
