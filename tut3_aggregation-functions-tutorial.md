# SQL Aggregation Functions Tutorial

A comprehensive guide to SQL aggregation functions using the `classicmodels` database.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Basic Aggregation Functions](#basic-aggregation-functions)
3. [GROUP BY - Grouping Data](#group-by---grouping-data)
4. [ORDER BY - Sorting Results](#order-by---sorting-results)
5. [HAVING - Filtering Groups](#having---filtering-groups)
6. [Advanced Examples](#advanced-examples)
7. [Best Practices](#best-practices)
8. [Summary](#summary)

---

## Introduction

**Aggregation functions** perform calculations on a set of rows and return a single value. They are essential for summarizing and analyzing data in SQL.

### Setup

```sql
USE classicmodels;
```

---

## Basic Aggregation Functions

### COUNT() - Counting Rows

`COUNT()` returns the number of rows in a result set.

- `COUNT(*)` - counts all rows, including NULLs
- `COUNT(column)` - counts only non-NULL values in a specific column
- `COUNT(DISTINCT column)` - counts unique non-NULL values

#### Examples

**Count total number of products:**
```sql
SELECT
  COUNT(*) AS total_products
FROM
  products;
```

**Count customers with a sales representative assigned:**
```sql
SELECT
  COUNT(salesRepEmployeeNumber) AS customers_with_sales_rep
FROM
  customers;
```
*Note: This only counts non-NULL values*

**Count distinct product lines:**
```sql
SELECT
  COUNT(DISTINCT productLine) AS unique_product_lines
FROM
  products;
```

**Count distinct countries:**
```sql
SELECT
  COUNT(DISTINCT country) AS unique_countries
FROM
  customers;
```

---

### SUM() - Summing Values

`SUM()` adds up all values in a numeric column.

#### Examples

**Calculate total revenue from all payments:**
```sql
SELECT
  SUM(amount) AS total_revenue
FROM
  payments;
```

**Calculate total value of all products in stock:**
```sql
SELECT
  SUM(quantityInStock * buyPrice) AS total_inventory_value
FROM
  products;
```
*This multiplies quantity by price for each product, then sums them*

**Calculate total quantity ordered for a specific order:**
```sql
SELECT
  SUM(quantityOrdered) AS total_items_ordered
FROM
  orderdetails
WHERE
  orderNumber = 10100;
```

---

### AVG() - Calculating Averages

`AVG()` calculates the average (mean) of numeric values. NULL values are automatically excluded.

#### Examples

**Calculate average payment amount:**
```sql
SELECT
  AVG(amount) AS average_payment
FROM
  payments;
```

**Calculate average buy price of products:**
```sql
SELECT
  AVG(buyPrice) AS average_buy_price
FROM
  products;
```

**Calculate average credit limit (excluding NULLs):**
```sql
SELECT
  AVG(creditLimit) AS average_credit_limit
FROM
  customers
WHERE
  creditLimit IS NOT NULL;
```

---

### MIN() - Finding Minimum Values

`MIN()` returns the smallest value in a column.

#### Examples

**Find the smallest payment amount:**
```sql
SELECT
  MIN(amount) AS smallest_payment
FROM
  payments;
```

**Find the earliest order date:**
```sql
SELECT
  MIN(orderDate) AS earliest_order
FROM
  orders;
```

**Find the lowest product buy price:**
```sql
SELECT
  MIN(buyPrice) AS lowest_price
FROM
  products;
```

---

### MAX() - Finding Maximum Values

`MAX()` returns the largest value in a column.

#### Examples

**Find the largest payment amount:**
```sql
SELECT
  MAX(amount) AS largest_payment
FROM
  payments;
```

**Find the most recent order date:**
```sql
SELECT
  MAX(orderDate) AS most_recent_order
FROM
  orders;
```

**Find the highest product buy price:**
```sql
SELECT
  MAX(buyPrice) AS highest_price
FROM
  products;
```

---

## GROUP BY - Grouping Data

`GROUP BY` divides rows into groups based on one or more columns. Aggregation functions then calculate values for each group.

### Basic GROUP BY

**Count orders per customer:**
```sql
SELECT
  customerNumber,
  COUNT(*) AS total_orders
FROM
  orders
GROUP BY
  customerNumber;
```

**Count products per product line:**
```sql
SELECT
  productLine,
  COUNT(*) AS number_of_products
FROM
  products
GROUP BY
  productLine;
```

**Count employees per office:**
```sql
SELECT
  officeCode,
  COUNT(*) AS number_of_employees
FROM
  employees
GROUP BY
  officeCode;
```

**Count customers per country:**
```sql
SELECT
  country,
  COUNT(*) AS number_of_customers
FROM
  customers
GROUP BY
  country;
```

---

### GROUP BY with Multiple Aggregations

You can use multiple aggregation functions in a single query.

**Total revenue per customer:**
```sql
SELECT
  customerNumber,
  COUNT(*) AS number_of_payments,
  SUM(amount) AS total_revenue,
  AVG(amount) AS average_payment,
  MIN(amount) AS smallest_payment,
  MAX(amount) AS largest_payment
FROM
  payments
GROUP BY
  customerNumber;
```

**Product statistics by product line:**
```sql
SELECT
  productLine,
  COUNT(*) AS product_count,
  AVG(buyPrice) AS average_price,
  MIN(buyPrice) AS lowest_price,
  MAX(buyPrice) AS highest_price,
  SUM(quantityInStock) AS total_stock
FROM
  products
GROUP BY
  productLine;
```

**Order statistics by status:**
```sql
SELECT
  status,
  COUNT(*) AS order_count,
  MIN(orderDate) AS earliest_order,
  MAX(orderDate) AS latest_order
FROM
  orders
GROUP BY
  status;
```

---

### GROUP BY with Multiple Columns

Group by multiple columns for more detailed analysis.

**Count customers by country and state:**
```sql
SELECT
  country,
  state,
  COUNT(*) AS customer_count
FROM
  customers
WHERE
  state IS NOT NULL
GROUP BY
  country, state
ORDER BY
  country, state;
```

**Product count by product line and vendor:**
```sql
SELECT
  productLine,
  productVendor,
  COUNT(*) AS product_count
FROM
  products
GROUP BY
  productLine, productVendor
ORDER BY
  productLine, productVendor;
```

---

## ORDER BY - Sorting Results

`ORDER BY` sorts the result set. Use it with `GROUP BY` to organize your grouped data.

**Orders per customer, sorted by order count (descending):**
```sql
SELECT
  customerNumber,
  COUNT(*) AS total_orders
FROM
  orders
GROUP BY
  customerNumber
ORDER BY
  total_orders DESC;
```

**Revenue per customer, sorted by highest revenue first:**
```sql
SELECT
  customerNumber,
  SUM(amount) AS total_revenue
FROM
  payments
GROUP BY
  customerNumber
ORDER BY
  total_revenue DESC;
```

**Average price by product line, sorted by price:**
```sql
SELECT
  productLine,
  AVG(buyPrice) AS average_price
FROM
  products
GROUP BY
  productLine
ORDER BY
  average_price DESC;
```

---

## HAVING - Filtering Groups

`HAVING` filters groups created by `GROUP BY`.

**Key Difference:**
- `WHERE` filters rows **BEFORE** grouping
- `HAVING` filters groups **AFTER** grouping

### Basic HAVING

**Customers with more than 5 orders:**
```sql
SELECT
  customerNumber,
  COUNT(*) AS total_orders
FROM
  orders
GROUP BY
  customerNumber
HAVING
  COUNT(*) > 5
ORDER BY
  total_orders DESC;
```

**Product lines with more than 10 products:**
```sql
SELECT
  productLine,
  COUNT(*) AS product_count
FROM
  products
GROUP BY
  productLine
HAVING
  COUNT(*) > 10;
```

**Customers with total payments exceeding $100,000:**
```sql
SELECT
  customerNumber,
  SUM(amount) AS total_revenue
FROM
  payments
GROUP BY
  customerNumber
HAVING
  SUM(amount) > 100000
ORDER BY
  total_revenue DESC;
```

---

### HAVING with Multiple Conditions

**Customers with more than 3 orders AND total revenue > $50,000:**
```sql
SELECT
  customerNumber,
  COUNT(*) AS total_orders,
  SUM(amount) AS total_revenue
FROM
  payments
GROUP BY
  customerNumber
HAVING
  COUNT(*) > 3
  AND SUM(amount) > 50000
ORDER BY
  total_revenue DESC;
```

**Product lines with average price between $50 and $100:**
```sql
SELECT
  productLine,
  COUNT(*) AS product_count,
  AVG(buyPrice) AS average_price
FROM
  products
GROUP BY
  productLine
HAVING
  AVG(buyPrice) >= 50
  AND AVG(buyPrice) <= 100
ORDER BY
  average_price;
```

---

## Advanced Examples

### Top 10 Customers by Revenue

Combines: `GROUP BY`, `SUM`, `ORDER BY`, `LIMIT`

```sql
SELECT
  customerNumber,
  COUNT(*) AS payment_count,
  SUM(amount) AS total_revenue,
  AVG(amount) AS average_payment
FROM
  payments
GROUP BY
  customerNumber
ORDER BY
  total_revenue DESC
LIMIT 10;
```

---

### Product Lines with Low Stock

Combines: `GROUP BY`, `SUM`, `HAVING`, `ORDER BY`

```sql
SELECT
  productLine,
  COUNT(*) AS product_count,
  SUM(quantityInStock) AS total_stock,
  AVG(quantityInStock) AS average_stock
FROM
  products
GROUP BY
  productLine
HAVING
  SUM(quantityInStock) < 1000
ORDER BY
  total_stock ASC;
```

**Alternative:** To find product lines with high stock instead:
```sql
SELECT
  productLine,
  COUNT(*) AS product_count,
  SUM(quantityInStock) AS total_stock,
  AVG(quantityInStock) AS average_stock
FROM
  products
GROUP BY
  productLine
HAVING
  SUM(quantityInStock) > 100000
ORDER BY
  total_stock DESC;
```

---

### Monthly Order Statistics

Groups orders by year and month:

```sql
SELECT
  YEAR(orderDate) AS order_year,
  MONTH(orderDate) AS order_month,
  COUNT(*) AS order_count,
  MIN(orderDate) AS first_order,
  MAX(orderDate) AS last_order
FROM
  orders
GROUP BY
  YEAR(orderDate), MONTH(orderDate)
ORDER BY
  order_year DESC, order_month DESC;
```

---

### Sales Representatives with High-Value Customers

```sql
SELECT
  salesRepEmployeeNumber,
  COUNT(*) AS customer_count,
  AVG(creditLimit) AS average_credit_limit,
  MAX(creditLimit) AS max_credit_limit,
  SUM(creditLimit) AS total_credit_limit
FROM
  customers
WHERE
  salesRepEmployeeNumber IS NOT NULL
GROUP BY
  salesRepEmployeeNumber
HAVING
  AVG(creditLimit) > 50000
ORDER BY
  average_credit_limit DESC;
```

---

### Order Details Summary by Product

Shows which products are ordered most frequently:

```sql
SELECT
  productCode,
  COUNT(*) AS times_ordered,
  SUM(quantityOrdered) AS total_quantity_ordered,
  AVG(quantityOrdered) AS average_quantity,
  SUM(quantityOrdered * priceEach) AS total_revenue
FROM
  orderdetails
GROUP BY
  productCode
ORDER BY
  total_quantity_ordered DESC;
```

---

## Best Practices

### 1. Using Aliases in HAVING

**Important:** You can use column aliases in `ORDER BY`, but **NOT** in `HAVING` (in most SQL dialects).

✅ **Correct:**
```sql
SELECT
  customerNumber,
  COUNT(*) AS total_orders
FROM
  orders
GROUP BY
  customerNumber
HAVING
  COUNT(*) > 5  -- Must use COUNT(*), not total_orders
ORDER BY
  total_orders DESC;  -- Can use alias here
```

❌ **Incorrect:**
```sql
-- This will cause an error in most SQL databases
HAVING
  total_orders > 5  -- Cannot use alias in HAVING
```

---

### 2. NULL Handling in Aggregations

- `COUNT(*)` includes NULLs (counts all rows)
- `COUNT(column)` excludes NULLs (counts only non-NULL values)
- Other aggregations (`SUM`, `AVG`, etc.) ignore NULL values automatically

**Example:**
```sql
SELECT
  COUNT(*) AS total_customers,  -- Counts all rows
  COUNT(salesRepEmployeeNumber) AS customers_with_rep,  -- Excludes NULLs
  COUNT(*) - COUNT(salesRepEmployeeNumber) AS customers_without_rep
FROM
  customers;
```

---

### 3. Combining WHERE and HAVING

Use both `WHERE` and `HAVING` together:

```sql
SELECT
  customerNumber,
  COUNT(*) AS order_count,
  SUM(amount) AS total_revenue
FROM
  payments
WHERE
  paymentDate >= '2004-01-01'  -- Filter payments BEFORE grouping
GROUP BY
  customerNumber
HAVING
  COUNT(*) > 3  -- Filter groups AFTER grouping
ORDER BY
  total_revenue DESC;
```

**Execution order:**
1. `WHERE` filters individual rows
2. `GROUP BY` groups the filtered rows
3. Aggregation functions calculate values
4. `HAVING` filters the groups
5. `ORDER BY` sorts the final result

---

## Summary

### Key Points

1. **Aggregation Functions:**
   - `COUNT()` - Count rows or non-NULL values
   - `SUM()` - Add up numeric values
   - `AVG()` - Calculate average
   - `MIN()` - Find minimum value
   - `MAX()` - Find maximum value

2. **GROUP BY:**
   - Groups rows with the same values in specified columns
   - Must include all non-aggregated columns in `GROUP BY`

3. **HAVING:**
   - Filters groups (use after `GROUP BY`)
   - Can use aggregation functions in conditions
   - Cannot use column aliases in `HAVING` (use the full expression)

4. **ORDER BY:**
   - Sorts the final result set
   - Can use column aliases
   - Can sort by multiple columns

5. **Execution Order:**
   ```
   FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
   ```

### Quick Reference

| Clause | Purpose | When to Use |
|--------|---------|-------------|
| `WHERE` | Filter rows | Before grouping |
| `GROUP BY` | Group rows | When using aggregations |
| `HAVING` | Filter groups | After grouping, when filtering on aggregated values |
| `ORDER BY` | Sort results | To organize output |
| `LIMIT` | Limit rows | To restrict number of results |

---

## Practice Exercises

Try these on your own:

1. Find the average credit limit by country
2. List product lines with average price above $50
3. Show customers who have made more than 5 payments totaling over $75,000
4. Find the month with the most orders
5. List offices with more than 3 employees, sorted by employee count

---

*Happy querying! 🚀*

