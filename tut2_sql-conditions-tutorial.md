# SQL Conditions Tutorial

A comprehensive guide to SQL conditions, filtering, and conditional logic using the `classicmodels` database.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Basic WHERE Clause](#basic-where-clause)
3. [Comparison Operators](#comparison-operators)
4. [Logical Operators](#logical-operators)
5. [IN and NOT IN](#in-and-not-in)
6. [BETWEEN Operator](#between-operator)
7. [LIKE and Pattern Matching](#like-and-pattern-matching)
8. [NULL Conditions](#null-conditions)
9. [Multiple Conditions](#multiple-conditions)
10. [CASE Statements](#case-statements)
11. [Subqueries in Conditions](#subqueries-in-conditions)
12. [Best Practices](#best-practices)
13. [Summary](#summary)

---

## Introduction

**Conditions** in SQL allow you to filter data and control which rows are returned or affected by your queries. The `WHERE` clause is the primary way to apply conditions in SQL.

### Setup

```sql
USE classicmodels;
```

---

## Basic WHERE Clause

The `WHERE` clause filters rows based on specified conditions.

**Basic Syntax:**
```sql
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

### Simple Example

**Select all customers from USA:**
```sql
SELECT
  customerNumber,
  customerName,
  country
FROM
  customers
WHERE
  country = 'USA';
```

**Select products with price above $50:**
```sql
SELECT
  productCode,
  productName,
  buyPrice
FROM
  products
WHERE
  buyPrice > 50;
```

---

## Comparison Operators

SQL supports various comparison operators to compare values.

### Equality Operators

**Equal to (=):**
```sql
SELECT *
FROM products
WHERE productLine = 'Classic Cars';
```

**Not equal to (!= or <>):**
```sql
-- Using !=
SELECT *
FROM products
WHERE productLine != 'Classic Cars';

-- Using <> (alternative syntax)
SELECT *
FROM products
WHERE productLine <> 'Classic Cars';
```

### Comparison Operators

**Greater than (>):**
```sql
SELECT *
FROM products
WHERE buyPrice > 50;
```

**Greater than or equal to (>=):**
```sql
SELECT *
FROM products
WHERE buyPrice >= 50;
```

**Less than (<):**
```sql
SELECT *
FROM products
WHERE buyPrice < 30;
```

**Less than or equal to (<=):**
```sql
SELECT *
FROM products
WHERE buyPrice <= 30;
```

### Examples

**Products priced between $30 and $50:**
```sql
SELECT
  productName,
  buyPrice
FROM
  products
WHERE
  buyPrice >= 30
  AND buyPrice <= 50;
```

**Orders placed after 2005:**
```sql
SELECT
  orderNumber,
  orderDate,
  status
FROM
  orders
WHERE
  orderDate >= '2005-01-01';
```

**Payments above $10,000:**
```sql
SELECT
  customerNumber,
  amount,
  paymentDate
FROM
  payments
WHERE
  amount > 10000;
```

---

## Logical Operators

Logical operators combine multiple conditions.

### AND Operator

Returns rows where **all** conditions are true.

**Products in 'Classic Cars' line with price above $50:**
```sql
SELECT
  productName,
  productLine,
  buyPrice
FROM
  products
WHERE
  productLine = 'Classic Cars'
  AND buyPrice > 50;
```

**Customers from USA with credit limit above $50,000:**
```sql
SELECT
  customerName,
  country,
  creditLimit
FROM
  customers
WHERE
  country = 'USA'
  AND creditLimit > 50000;
```

### OR Operator

Returns rows where **at least one** condition is true.

**Products in 'Classic Cars' OR 'Vintage Cars' lines:**
```sql
SELECT
  productName,
  productLine,
  buyPrice
FROM
  products
WHERE
  productLine = 'Classic Cars'
  OR productLine = 'Vintage Cars';
```

**Customers from USA or France:**
```sql
SELECT
  customerName,
  country
FROM
  customers
WHERE
  country = 'USA'
  OR country = 'France';
```

### NOT Operator

Negates a condition - returns rows where the condition is **false**.

**Products NOT in 'Classic Cars' line:**
```sql
SELECT
  productName,
  productLine
FROM
  products
WHERE
  NOT productLine = 'Classic Cars';
```

**Orders that are NOT shipped:**
```sql
SELECT
  orderNumber,
  status
FROM
  orders
WHERE
  NOT status = 'Shipped';
```

### Combining AND, OR, NOT

**Use parentheses to control evaluation order:**

**Products in 'Classic Cars' with price > $50 OR products in 'Vintage Cars' with price > $40:**
```sql
SELECT
  productName,
  productLine,
  buyPrice
FROM
  products
WHERE
  (productLine = 'Classic Cars' AND buyPrice > 50)
  OR (productLine = 'Vintage Cars' AND buyPrice > 40);
```

**Customers from USA or France with credit limit above $50,000:**
```sql
SELECT
  customerName,
  country,
  creditLimit
FROM
  customers
WHERE
  (country = 'USA' OR country = 'France')
  AND creditLimit > 50000;
```

---

## IN and NOT IN

The `IN` operator allows you to specify multiple values in a WHERE clause.

### IN Operator

**Products in specific product lines:**
```sql
SELECT
  productName,
  productLine
FROM
  products
WHERE
  productLine IN ('Classic Cars', 'Vintage Cars', 'Motorcycles');
```

**Customers from specific countries:**
```sql
SELECT
  customerName,
  country
FROM
  customers
WHERE
  country IN ('USA', 'France', 'Germany', 'UK');
```

**Orders with specific statuses:**
```sql
SELECT
  orderNumber,
  status
FROM
  orders
WHERE
  status IN ('Shipped', 'In Process');
```

### NOT IN Operator

**Products NOT in specific product lines:**
```sql
SELECT
  productName,
  productLine
FROM
  products
WHERE
  productLine NOT IN ('Classic Cars', 'Vintage Cars');
```

**Customers NOT from specific countries:**
```sql
SELECT
  customerName,
  country
FROM
  customers
WHERE
  country NOT IN ('USA', 'France');
```

### IN vs Multiple OR Conditions

These are equivalent:

```sql
-- Using IN
WHERE country IN ('USA', 'France', 'Germany');

-- Using OR
WHERE country = 'USA' OR country = 'France' OR country = 'Germany';
```

**`IN` is more readable and efficient for multiple values.**

---

## BETWEEN Operator

`BETWEEN` selects values within a range (inclusive).

### Basic BETWEEN

**Products with price between $30 and $50:**
```sql
SELECT
  productName,
  buyPrice
FROM
  products
WHERE
  buyPrice BETWEEN 30 AND 50;
```

**Orders placed between two dates:**
```sql
SELECT
  orderNumber,
  orderDate
FROM
  orders
WHERE
  orderDate BETWEEN '2004-01-01' AND '2004-12-31';
```

**Payments between $5,000 and $10,000:**
```sql
SELECT
  customerNumber,
  amount,
  paymentDate
FROM
  payments
WHERE
  amount BETWEEN 5000 AND 10000;
```

### NOT BETWEEN

**Products with price NOT between $30 and $50:**
```sql
SELECT
  productName,
  buyPrice
FROM
  products
WHERE
  buyPrice NOT BETWEEN 30 AND 50;
```

### BETWEEN with Dates

**Orders in 2004:**
```sql
SELECT
  orderNumber,
  orderDate,
  status
FROM
  orders
WHERE
  orderDate BETWEEN '2004-01-01' AND '2004-12-31';
```

**Payments in the last quarter:**
```sql
SELECT
  customerNumber,
  amount,
  paymentDate
FROM
  payments
WHERE
  paymentDate BETWEEN '2004-10-01' AND '2004-12-31';
```

---

## LIKE and Pattern Matching

`LIKE` is used for pattern matching with wildcards.

### Wildcards

- `%` - Matches any sequence of characters (zero or more)
- `_` - Matches exactly one character

### LIKE Examples

**Products with name starting with '196':**
```sql
SELECT
  productName,
  productLine
FROM
  products
WHERE
  productName LIKE '196%';
```

**Products with name containing 'Ford':**
```sql
SELECT
  productName,
  productLine
FROM
  products
WHERE
  productName LIKE '%Ford%';
```

**Products with name ending with 'Car':**
```sql
SELECT
  productName
FROM
  products
WHERE
  productName LIKE '%Car';
```

**Customers with name exactly 5 characters:**
```sql
SELECT
  customerName
FROM
  customers
WHERE
  customerName LIKE '_____';  -- 5 underscores
```

**Products with name pattern: starts with '19', any 2 characters, then 'Ford':**
```sql
SELECT
  productName
FROM
  products
WHERE
  productName LIKE '19__Ford%';
```

### NOT LIKE

**Products NOT containing 'Ford':**
```sql
SELECT
  productName
FROM
  products
WHERE
  productName NOT LIKE '%Ford%';
```

### Case Sensitivity

**Note:** `LIKE` is case-insensitive in MySQL by default, but case-sensitive in some databases.

**Case-sensitive search (MySQL):**
```sql
SELECT
  productName
FROM
  products
WHERE
  productName LIKE BINARY '%Ford%';
```

---

## NULL Conditions

NULL represents missing or unknown data. Special operators are needed to check for NULL.

### IS NULL

**Customers without a sales representative:**
```sql
SELECT
  customerNumber,
  customerName,
  salesRepEmployeeNumber
FROM
  customers
WHERE
  salesRepEmployeeNumber IS NULL;
```

**Orders not yet shipped:**
```sql
SELECT
  orderNumber,
  orderDate,
  shippedDate
FROM
  orders
WHERE
  shippedDate IS NULL;
```

### IS NOT NULL

**Customers with a sales representative:**
```sql
SELECT
  customerNumber,
  customerName,
  salesRepEmployeeNumber
FROM
  customers
WHERE
  salesRepEmployeeNumber IS NOT NULL;
```

**Orders that have been shipped:**
```sql
SELECT
  orderNumber,
  orderDate,
  shippedDate
FROM
  orders
WHERE
  shippedDate IS NOT NULL;
```

### Common Mistake

❌ **Incorrect - This will NOT work:**
```sql
WHERE salesRepEmployeeNumber = NULL;  -- Wrong!
WHERE salesRepEmployeeNumber != NULL;  -- Wrong!
```

✅ **Correct:**
```sql
WHERE salesRepEmployeeNumber IS NULL;  -- Correct
WHERE salesRepEmployeeNumber IS NOT NULL;  -- Correct
```

---

## Multiple Conditions

Combine multiple conditions using logical operators.

### Complex Conditions

**Products in 'Classic Cars' with price between $30 and $100, in stock:**
```sql
SELECT
  productName,
  productLine,
  buyPrice,
  quantityInStock
FROM
  products
WHERE
  productLine = 'Classic Cars'
  AND buyPrice BETWEEN 30 AND 100
  AND quantityInStock > 0;
```

**Customers from USA or France with credit limit above $50,000:**
```sql
SELECT
  customerName,
  country,
  creditLimit
FROM
  customers
WHERE
  (country = 'USA' OR country = 'France')
  AND creditLimit > 50000;
```

**Orders shipped in 2004 or 2005:**
```sql
SELECT
  orderNumber,
  orderDate,
  shippedDate,
  status
FROM
  orders
WHERE
  status = 'Shipped'
  AND (YEAR(shippedDate) = 2004 OR YEAR(shippedDate) = 2005);
```

**Products with low stock or high price:**
```sql
SELECT
  productName,
  quantityInStock,
  buyPrice
FROM
  products
WHERE
  quantityInStock < 1000
  OR buyPrice > 100;
```

---

## CASE Statements

`CASE` allows conditional logic in SELECT statements.

### Simple CASE

**Categorize products by price:**
```sql
SELECT
  productName,
  buyPrice,
  CASE
    WHEN buyPrice < 30 THEN 'Low'
    WHEN buyPrice BETWEEN 30 AND 70 THEN 'Medium'
    WHEN buyPrice > 70 THEN 'High'
    ELSE 'Unknown'
  END AS price_category
FROM
  products;
```

**Categorize order status:**
```sql
SELECT
  orderNumber,
  status,
  CASE status
    WHEN 'Shipped' THEN 'Completed'
    WHEN 'In Process' THEN 'Processing'
    WHEN 'Cancelled' THEN 'Cancelled'
    ELSE 'Other'
  END AS status_category
FROM
  orders;
```

### CASE in WHERE Clause

**Products in 'High' price category:**
```sql
SELECT
  productName,
  buyPrice
FROM
  (
    SELECT
      productName,
      buyPrice,
      CASE
        WHEN buyPrice < 30 THEN 'Low'
        WHEN buyPrice BETWEEN 30 AND 70 THEN 'Medium'
        ELSE 'High'
      END AS price_category
    FROM
      products
  ) AS categorized_products
WHERE
  price_category = 'High';
```

### CASE with Aggregations

**Count products by price category:**
```sql
SELECT
  CASE
    WHEN buyPrice < 30 THEN 'Low'
    WHEN buyPrice BETWEEN 30 AND 70 THEN 'Medium'
    ELSE 'High'
  END AS price_category,
  COUNT(*) AS product_count
FROM
  products
GROUP BY
  price_category;
```

---

## Subqueries in Conditions

Use subqueries to create dynamic conditions.

### Subquery with IN

**Customers who have placed orders:**
```sql
SELECT
  customerNumber,
  customerName
FROM
  customers
WHERE
  customerNumber IN (
    SELECT DISTINCT customerNumber
    FROM orders
  );
```

**Products that have been ordered:**
```sql
SELECT
  productCode,
  productName
FROM
  products
WHERE
  productCode IN (
    SELECT DISTINCT productCode
    FROM orderdetails
  );
```

### Subquery with Comparison Operators

**Products with price above average:**
```sql
SELECT
  productName,
  buyPrice
FROM
  products
WHERE
  buyPrice > (
    SELECT AVG(buyPrice)
    FROM products
  );
```

**Customers with credit limit above the average:**
```sql
SELECT
  customerName,
  creditLimit
FROM
  customers
WHERE
  creditLimit > (
    SELECT AVG(creditLimit)
    FROM customers
    WHERE creditLimit IS NOT NULL
  );
```

### Subquery with EXISTS

**Customers who have made payments:**
```sql
SELECT
  customerNumber,
  customerName
FROM
  customers c
WHERE
  EXISTS (
    SELECT 1
    FROM payments p
    WHERE p.customerNumber = c.customerNumber
  );
```

**Products that have never been ordered:**
```sql
SELECT
  productCode,
  productName
FROM
  products p
WHERE
  NOT EXISTS (
    SELECT 1
    FROM orderdetails od
    WHERE od.productCode = p.productCode
  );
```

---

## Best Practices

### 1. Use Indexed Columns in WHERE

**Good:** Filtering on indexed columns (primary keys, foreign keys)
```sql
WHERE customerNumber = 103;
```

**Less efficient:** Filtering on non-indexed columns
```sql
WHERE customerName = 'Atelier graphique';
```

### 2. Avoid Functions in WHERE Clauses

❌ **Inefficient:**
```sql
WHERE YEAR(orderDate) = 2004;
```

✅ **Better:**
```sql
WHERE orderDate BETWEEN '2004-01-01' AND '2004-12-31';
```

### 3. Use Appropriate Operators

- Use `IN` instead of multiple `OR` conditions
- Use `BETWEEN` for ranges instead of `>= AND <=`
- Use `IS NULL` / `IS NOT NULL` for NULL checks

### 4. Parentheses for Clarity

Always use parentheses when combining `AND` and `OR`:

```sql
WHERE (country = 'USA' OR country = 'France')
  AND creditLimit > 50000;
```

### 5. NULL Handling

Always use `IS NULL` or `IS NOT NULL` - never use `= NULL` or `!= NULL`.

---

## Summary

### Key Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `=` | Equal to | `WHERE country = 'USA'` |
| `!=` or `<>` | Not equal to | `WHERE status != 'Shipped'` |
| `>` | Greater than | `WHERE price > 50` |
| `>=` | Greater than or equal | `WHERE price >= 50` |
| `<` | Less than | `WHERE price < 30` |
| `<=` | Less than or equal | `WHERE price <= 30` |
| `AND` | Logical AND | `WHERE A AND B` |
| `OR` | Logical OR | `WHERE A OR B` |
| `NOT` | Logical NOT | `WHERE NOT A` |
| `IN` | Match any value in list | `WHERE country IN ('USA', 'France')` |
| `NOT IN` | Not match any value | `WHERE country NOT IN ('USA')` |
| `BETWEEN` | Range (inclusive) | `WHERE price BETWEEN 30 AND 50` |
| `LIKE` | Pattern matching | `WHERE name LIKE '%Ford%'` |
| `IS NULL` | Check for NULL | `WHERE column IS NULL` |
| `IS NOT NULL` | Check for NOT NULL | `WHERE column IS NOT NULL` |

### Execution Order

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

### Common Patterns

**Range check:**
```sql
WHERE price BETWEEN 30 AND 50;
-- Equivalent to:
WHERE price >= 30 AND price <= 50;
```

**Multiple values:**
```sql
WHERE country IN ('USA', 'France', 'Germany');
-- Equivalent to:
WHERE country = 'USA' OR country = 'France' OR country = 'Germany';
```

**Pattern matching:**
```sql
WHERE name LIKE '%Ford%';  -- Contains 'Ford'
WHERE name LIKE 'Ford%';   -- Starts with 'Ford'
WHERE name LIKE '%Ford';   -- Ends with 'Ford'
```

---

## Practice Exercises

Try these on your own:

1. Find all products in 'Classic Cars' line with price above $50
2. List customers from USA or France with credit limit above $75,000
3. Find orders placed in 2004 that have been shipped
4. List products with names containing 'Ford' or 'Chevy'
5. Find customers who have never placed an order
6. List products with stock below 1000 or price above $100
7. Find employees who report to someone (reportsTo IS NOT NULL)
8. List payments between $5,000 and $10,000 made in 2004

---

*Happy querying! 🚀*

