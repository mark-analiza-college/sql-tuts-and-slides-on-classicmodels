# General SQL Commands - Database Structure

Quick reference for viewing database and table structures in MySQL.

---

## Database Commands

### List all databases
```sql
SHOW DATABASES;
```

### Select/use a database
```sql
USE database_name;
```

### Show current database
```sql
SELECT DATABASE();
```

---

## Table Commands

### List all tables in current database
```sql
SHOW TABLES;
```

### List tables matching a pattern
```sql
SHOW TABLES LIKE 'pattern%';
```

---

## Table Structure Commands

### Describe table structure (short form)
```sql
DESCRIBE table_name;
```
or
```sql
DESC table_name;
```

### Show columns with detailed information
```sql
SHOW COLUMNS FROM table_name;
```

### Show full column information
```sql
SHOW FULL COLUMNS FROM table_name;
```

### Show table creation statement
```sql
SHOW CREATE TABLE table_name;
```

### Show table status
```sql
SHOW TABLE STATUS LIKE 'table_name';
```

---

## Quick Examples

```sql
-- Connect and explore
SHOW DATABASES;
USE classicmodels;
SHOW TABLES;
DESCRIBE customers;
SHOW COLUMNS FROM orders;
SHOW CREATE TABLE products;
```

---

## Information Schema (Alternative Method)

Query the information schema for more detailed metadata:

```sql
-- Get column information
SELECT 
  COLUMN_NAME,
  DATA_TYPE,
  IS_NULLABLE,
  COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'database_name'
  AND TABLE_NAME = 'table_name';
```

---

## Tips

- `DESCRIBE` and `DESC` are aliases - use whichever you prefer
- `SHOW COLUMNS` provides more detail than `DESCRIBE`
- `SHOW CREATE TABLE` shows the exact SQL used to create the table
- Use `INFORMATION_SCHEMA` for programmatic access to metadata

