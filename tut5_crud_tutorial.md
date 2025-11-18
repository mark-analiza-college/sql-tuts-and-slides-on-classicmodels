# SQL CRUD Operations Tutorial

A comprehensive guide to CRUD (Create, Read, Update, Delete) operations in SQL.

---

## Table of Contents

1. [Introduction](#introduction)
2. [CREATE - INSERT Statement](#create---insert-statement)
3. [READ - SELECT Statement](#read---select-statement)
4. [UPDATE - UPDATE Statement](#update---update-statement)
5. [DELETE - DELETE Statement](#delete---delete-statement)
6. [Best Practices](#best-practices)
7. [Summary](#summary)
8. [Exercises](#exercises)

---

## Introduction

**CRUD** stands for the four basic operations you can perform on data:

- **C**reate - Insert new records
- **R**ead - Retrieve/query records
- **U**pdate - Modify existing records
- **D**elete - Remove records

### Setup

We'll use a sample database for our examples. First, let's create it:

```sql
CREATE DATABASE IF NOT EXISTS bookstore_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE bookstore_db;

-- Create sample tables
CREATE TABLE authors (
  author_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE,
  birth_date DATE,
  nationality VARCHAR(50)
);

CREATE TABLE books (
  book_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(200) NOT NULL,
  author_id INT,
  isbn VARCHAR(20) UNIQUE,
  price DECIMAL(10, 2),
  publication_year YEAR,
  stock_quantity INT DEFAULT 0,
  FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE SET NULL
);

CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  registration_date DATE DEFAULT (CURRENT_DATE)
);
```

---

## CREATE - INSERT Statement

The `INSERT` statement adds new rows to a table.

### Basic INSERT Syntax

```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
```

### Insert Single Row

**Insert into authors table:**
```sql
INSERT INTO authors (first_name, last_name, email, birth_date, nationality)
VALUES ('J.K.', 'Rowling', 'jkrowling@example.com', '1965-07-31', 'British');
```

**Insert with fewer columns (using defaults or NULL):**
```sql
INSERT INTO authors (first_name, last_name, email)
VALUES ('George', 'Orwell', 'gorwell@example.com');
```

**Insert without specifying columns (must provide all values in order):**
```sql
INSERT INTO authors
VALUES (NULL, 'Jane', 'Austen', 'jausten@example.com', '1775-12-16', 'British');
```
*Note: Use NULL for AUTO_INCREMENT columns*

### Insert Multiple Rows

**Insert multiple authors at once:**
```sql
INSERT INTO authors (first_name, last_name, email, nationality)
VALUES
  ('Ernest', 'Hemingway', 'ehemingway@example.com', 'American'),
  ('Virginia', 'Woolf', 'vwoolf@example.com', 'British'),
  ('Gabriel', 'García Márquez', 'ggmarquez@example.com', 'Colombian');
```

**Insert multiple books:**
```sql
INSERT INTO books (title, author_id, isbn, price, publication_year, stock_quantity)
VALUES
  ('Harry Potter and the Philosopher\'s Stone', 1, '978-0747532699', 12.99, 1997, 50),
  ('1984', 2, '978-0451524935', 9.99, 1949, 30),
  ('Pride and Prejudice', 3, '978-0141439518', 8.99, 1813, 25);
```

### Insert with SELECT (Copy Data)

**Copy data from one table to another:**
```sql
-- First, create a backup table
CREATE TABLE authors_backup LIKE authors;

-- Copy all data
INSERT INTO authors_backup
SELECT * FROM authors;
```

**Insert selected data:**
```sql
INSERT INTO customers (first_name, last_name, email)
SELECT first_name, last_name, email
FROM authors
WHERE nationality = 'British';
```

### Insert with DEFAULT Values

**Using DEFAULT keyword:**
```sql
INSERT INTO books (title, author_id, price, stock_quantity)
VALUES ('New Book', 1, 15.99, DEFAULT);
```

**Using CURRENT_DATE:**
```sql
INSERT INTO customers (first_name, last_name, email, registration_date)
VALUES ('John', 'Doe', 'john@example.com', CURRENT_DATE);
```

### Insert with NULL Values

**Explicitly inserting NULL:**
```sql
INSERT INTO authors (first_name, last_name, email, birth_date)
VALUES ('Unknown', 'Author', NULL, NULL);
```

---

## READ - SELECT Statement

The `SELECT` statement retrieves data from tables.

### Basic SELECT

**Select all columns:**
```sql
SELECT * FROM authors;
```

**Select specific columns:**
```sql
SELECT first_name, last_name, email
FROM authors;
```

**Select with column aliases:**
```sql
SELECT 
  first_name AS 'First Name',
  last_name AS 'Last Name',
  email AS 'Email Address'
FROM authors;
```

### SELECT with WHERE Clause

**Filter by single condition:**
```sql
SELECT * FROM books
WHERE price > 10.00;
```

**Filter by multiple conditions:**
```sql
SELECT * FROM books
WHERE price > 10.00 AND stock_quantity > 20;
```

**Filter with LIKE (pattern matching):**
```sql
SELECT * FROM books
WHERE title LIKE '%Potter%';
```

**Filter with IN:**
```sql
SELECT * FROM authors
WHERE nationality IN ('British', 'American');
```

**Filter with BETWEEN:**
```sql
SELECT * FROM books
WHERE price BETWEEN 8.00 AND 12.00;
```

**Filter with NULL:**
```sql
SELECT * FROM authors
WHERE email IS NULL;
```

### SELECT with ORDER BY

**Sort ascending (default):**
```sql
SELECT * FROM books
ORDER BY price;
```

**Sort descending:**
```sql
SELECT * FROM books
ORDER BY price DESC;
```

**Sort by multiple columns:**
```sql
SELECT * FROM authors
ORDER BY last_name, first_name;
```

### SELECT with LIMIT

**Limit number of rows:**
```sql
SELECT * FROM books
ORDER BY price DESC
LIMIT 5;
```

**Limit with offset (pagination):**
```sql
SELECT * FROM books
ORDER BY book_id
LIMIT 10 OFFSET 20;
-- Or use: LIMIT 20, 10
```

### SELECT with DISTINCT

**Get unique values:**
```sql
SELECT DISTINCT nationality
FROM authors;
```

**Get unique combinations:**
```sql
SELECT DISTINCT author_id, publication_year
FROM books;
```

### SELECT with Aggregation

**Count rows:**
```sql
SELECT COUNT(*) AS total_books
FROM books;
```

**Group by:**
```sql
SELECT 
  nationality,
  COUNT(*) AS author_count
FROM authors
GROUP BY nationality;
```

**Aggregate functions:**
```sql
SELECT 
  AVG(price) AS average_price,
  MAX(price) AS max_price,
  MIN(price) AS min_price,
  SUM(stock_quantity) AS total_stock
FROM books;
```

### SELECT with JOIN

**Inner JOIN:**
```sql
SELECT 
  b.title,
  b.price,
  a.first_name,
  a.last_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id;
```

**LEFT JOIN:**
```sql
SELECT 
  a.first_name,
  a.last_name,
  b.title
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id;
```

**Multiple JOINs:**
```sql
SELECT 
  b.title,
  a.first_name,
  a.last_name,
  c.first_name AS customer_first_name
FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
LEFT JOIN customers c ON 1=1;  -- Example join
```

---

## UPDATE - UPDATE Statement

The `UPDATE` statement modifies existing data in a table.

### Basic UPDATE Syntax

```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

**⚠️ Important:** Always use `WHERE` clause with UPDATE to avoid updating all rows!

### Update Single Row

**Update a specific author's email:**
```sql
UPDATE authors
SET email = 'newemail@example.com'
WHERE author_id = 1;
```

**Update multiple columns:**
```sql
UPDATE books
SET price = 14.99, stock_quantity = 100
WHERE book_id = 1;
```

### Update Multiple Rows

**Update all books by a specific author:**
```sql
UPDATE books
SET price = price * 1.10  -- Increase price by 10%
WHERE author_id = 1;
```

**Update based on condition:**
```sql
UPDATE books
SET stock_quantity = stock_quantity + 10
WHERE stock_quantity < 20;
```

**Update with multiple conditions:**
```sql
UPDATE books
SET price = price * 0.90  -- 10% discount
WHERE price > 15.00 AND stock_quantity > 50;
```

### Update with Calculations

**Increase price by percentage:**
```sql
UPDATE books
SET price = price * 1.15  -- 15% increase
WHERE publication_year < 2000;
```

**Decrease stock:**
```sql
UPDATE books
SET stock_quantity = stock_quantity - 1
WHERE book_id = 1;
```

### Update with NULL

**Set column to NULL:**
```sql
UPDATE authors
SET email = NULL
WHERE author_id = 5;
```

**Update to remove NULL (set a value):**
```sql
UPDATE authors
SET email = 'newemail@example.com'
WHERE email IS NULL;
```

### Update with Subquery

**Update based on another table:**
```sql
UPDATE books
SET stock_quantity = 0
WHERE author_id IN (
  SELECT author_id
  FROM authors
  WHERE nationality = 'British'
);
```

**Update with JOIN:**
```sql
UPDATE books b
INNER JOIN authors a ON b.author_id = a.author_id
SET b.price = b.price * 1.20
WHERE a.nationality = 'American';
```

### Update All Rows (Use with Caution!)

**Update all rows (dangerous!):**
```sql
UPDATE books
SET stock_quantity = 0;
-- ⚠️ This updates ALL books!
```

**Always verify before updating:**
```sql
-- First, check what will be updated
SELECT * FROM books WHERE stock_quantity < 10;

-- Then update
UPDATE books
SET stock_quantity = 10
WHERE stock_quantity < 10;
```

---

## DELETE - DELETE Statement

The `DELETE` statement removes rows from a table.

### Basic DELETE Syntax

```sql
DELETE FROM table_name
WHERE condition;
```

**⚠️ Important:** Always use `WHERE` clause with DELETE to avoid deleting all rows!

### Delete Single Row

**Delete a specific author:**
```sql
DELETE FROM authors
WHERE author_id = 5;
```

**Delete based on condition:**
```sql
DELETE FROM books
WHERE stock_quantity = 0 AND price < 5.00;
```

### Delete Multiple Rows

**Delete all books by a specific author:**
```sql
DELETE FROM books
WHERE author_id = 3;
```

**Delete based on date:**
```sql
DELETE FROM customers
WHERE registration_date < '2020-01-01';
```

**Delete with multiple conditions:**
```sql
DELETE FROM books
WHERE stock_quantity = 0 AND publication_year < 2000;
```

### Delete with Subquery

**Delete based on another table:**
```sql
DELETE FROM books
WHERE author_id IN (
  SELECT author_id
  FROM authors
  WHERE nationality = 'Colombian'
);
```

**Delete with JOIN:**
```sql
DELETE b FROM books b
INNER JOIN authors a ON b.author_id = a.author_id
WHERE a.nationality = 'American';
```

### Delete All Rows (Use with Extreme Caution!)

**Delete all rows from a table:**
```sql
DELETE FROM books;
-- ⚠️ This deletes ALL books!
```

**Better alternative - Use TRUNCATE:**
```sql
TRUNCATE TABLE books;
-- Faster and resets AUTO_INCREMENT
```

### DELETE vs TRUNCATE vs DROP

| Operation | What it does | Can rollback? | Resets AUTO_INCREMENT? |
|-----------|--------------|--------------|------------------------|
| `DELETE FROM table` | Removes rows | ✅ Yes | ❌ No |
| `TRUNCATE TABLE` | Removes all rows | ❌ No | ✅ Yes |
| `DROP TABLE` | Removes table entirely | ❌ No | N/A |

---

## Complete CRUD Example

Let's see a complete workflow:

```sql
-- CREATE: Insert new author
INSERT INTO authors (first_name, last_name, email, nationality)
VALUES ('Agatha', 'Christie', 'achristie@example.com', 'British');

-- Get the author_id (assuming it's 6)
SET @new_author_id = LAST_INSERT_ID();

-- CREATE: Insert books by this author
INSERT INTO books (title, author_id, isbn, price, publication_year, stock_quantity)
VALUES
  ('Murder on the Orient Express', @new_author_id, '978-0062693662', 11.99, 1934, 40),
  ('And Then There Were None', @new_author_id, '978-0062073488', 10.99, 1939, 35);

-- READ: View the new author and books
SELECT 
  a.first_name,
  a.last_name,
  b.title,
  b.price
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
WHERE a.author_id = @new_author_id;

-- UPDATE: Increase prices
UPDATE books
SET price = price * 1.05
WHERE author_id = @new_author_id;

-- READ: Verify the update
SELECT title, price
FROM books
WHERE author_id = @new_author_id;

-- DELETE: Remove a book
DELETE FROM books
WHERE title = 'Murder on the Orient Express';

-- READ: Final state
SELECT * FROM books WHERE author_id = @new_author_id;
```

---

## Best Practices

### 1. Always Use WHERE with UPDATE and DELETE

❌ **Dangerous:**
```sql
UPDATE books SET price = 10.00;  -- Updates ALL books!
DELETE FROM authors;  -- Deletes ALL authors!
```

✅ **Safe:**
```sql
UPDATE books SET price = 10.00 WHERE book_id = 1;
DELETE FROM authors WHERE author_id = 5;
```

### 2. Test with SELECT First

Before updating or deleting, always check what will be affected:

```sql
-- Step 1: Check what will be updated
SELECT * FROM books WHERE price > 15.00;

-- Step 2: If correct, then update
UPDATE books SET price = price * 0.90 WHERE price > 15.00;
```

### 3. Use Transactions for Multiple Operations

```sql
START TRANSACTION;

INSERT INTO authors (first_name, last_name) VALUES ('Author', 'One');
INSERT INTO books (title, author_id) VALUES ('Book One', LAST_INSERT_ID());

-- If everything is OK
COMMIT;

-- If something went wrong
-- ROLLBACK;
```

### 4. Backup Before Major Deletes

```sql
-- Create backup
CREATE TABLE books_backup AS SELECT * FROM books;

-- Then delete
DELETE FROM books WHERE stock_quantity = 0;
```

### 5. Use LIMIT with UPDATE/DELETE (MySQL)

```sql
-- Update only first 10 rows
UPDATE books
SET stock_quantity = 0
WHERE stock_quantity < 5
LIMIT 10;
```

### 6. Validate Data Before Insert

```sql
-- Check if author exists before inserting book
INSERT INTO books (title, author_id, price)
SELECT 'New Book', 999, 12.99
WHERE EXISTS (SELECT 1 FROM authors WHERE author_id = 999);
```

### 7. Use Prepared Statements for User Input

When working with applications, always use parameterized queries to prevent SQL injection.

---

## Summary

### CRUD Operations Quick Reference

| Operation | SQL Command | Purpose | Example |
|-----------|-------------|---------|---------|
| **Create** | `INSERT INTO` | Add new rows | `INSERT INTO table VALUES (...);` |
| **Read** | `SELECT` | Retrieve data | `SELECT * FROM table WHERE ...;` |
| **Update** | `UPDATE` | Modify existing rows | `UPDATE table SET col = val WHERE ...;` |
| **Delete** | `DELETE FROM` | Remove rows | `DELETE FROM table WHERE ...;` |

### Key Points

1. **INSERT** - Always specify column names for clarity
2. **SELECT** - Use WHERE to filter, ORDER BY to sort, LIMIT to restrict
3. **UPDATE** - **ALWAYS use WHERE clause** to avoid updating all rows
4. **DELETE** - **ALWAYS use WHERE clause** to avoid deleting all rows
5. **Test first** - Use SELECT to verify before UPDATE/DELETE
6. **Use transactions** - For multiple related operations
7. **Backup important data** - Before major DELETE operations

### Common Patterns

**Insert and get ID:**
```sql
INSERT INTO authors (first_name, last_name) VALUES ('John', 'Doe');
SELECT LAST_INSERT_ID();  -- Get the auto-generated ID
```

**Update with calculation:**
```sql
UPDATE books SET price = price * 1.10 WHERE book_id = 1;
```

**Delete with subquery:**
```sql
DELETE FROM books WHERE author_id IN (SELECT author_id FROM authors WHERE ...);
```

**Safe delete (check first):**
```sql
SELECT * FROM table WHERE condition;  -- Check first
DELETE FROM table WHERE condition;    -- Then delete
```

---

## Exercises

### Exercise 1: Bookstore Management

Using the `bookstore_db` database created at the beginning:

1. **CREATE Operations:**
   - Insert 5 new authors with different nationalities
   - Insert at least 3 books for each author
   - Insert 10 customers

2. **READ Operations:**
   - List all authors sorted by last name
   - Find all books priced above $10
   - Show books with their authors (using JOIN)
   - Count books by each author
   - Find the most expensive book

3. **UPDATE Operations:**
   - Increase prices of all books by 5%
   - Update stock quantity for books with low stock (< 10) to 20
   - Update email for a specific author

4. **DELETE Operations:**
   - Delete all books with zero stock
   - Delete customers registered before 2020
   - Delete an author and observe what happens to their books (due to foreign key)

**Requirements:**
- Use appropriate WHERE clauses
- Test with SELECT before UPDATE/DELETE
- Use transactions for related operations

---

### Exercise 2: Inventory Management System

Create a new database `inventory_db` and perform CRUD operations:

**Database Setup:**
```sql
CREATE DATABASE IF NOT EXISTS inventory_db;
USE inventory_db;

CREATE TABLE categories (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT
);

CREATE TABLE products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(200) NOT NULL,
  category_id INT,
  price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
  stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0),
  reorder_level INT DEFAULT 10,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

CREATE TABLE suppliers (
  supplier_id INT PRIMARY KEY AUTO_INCREMENT,
  supplier_name VARCHAR(100) NOT NULL,
  contact_email VARCHAR(100),
  phone VARCHAR(20),
  address TEXT
);
```

**Tasks:**

1. **CREATE:**
   - Insert 3 categories (Electronics, Clothing, Books)
   - Insert 10 products across different categories
   - Insert 3 suppliers

2. **READ:**
   - List all products with their categories
   - Find products that need reordering (stock_quantity <= reorder_level)
   - Show total value of inventory (sum of price * stock_quantity)
   - Find the most expensive product in each category

3. **UPDATE:**
   - Update stock quantities after a sale (reduce by specific amounts)
   - Increase prices of products in a specific category by 10%
   - Update reorder_level for products with frequent stockouts

4. **DELETE:**
   - Delete products that have been out of stock for a long time (stock_quantity = 0)
   - Delete a category and observe what happens to products (due to foreign key)

**Additional Challenges:**
- Use transactions to simulate a purchase (reduce stock, update multiple products)
- Create a backup table before major DELETE operations
- Use subqueries in UPDATE and DELETE statements

---

## Solutions Template

After completing the exercises, verify your work:

**Check your data:**
```sql
-- Count records
SELECT COUNT(*) FROM authors;
SELECT COUNT(*) FROM books;
SELECT COUNT(*) FROM customers;

-- Verify relationships
SELECT 
  a.first_name,
  a.last_name,
  COUNT(b.book_id) AS book_count
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
GROUP BY a.author_id;

-- Check constraints
SELECT * FROM books WHERE price < 0;  -- Should return nothing if CHECK works
```

**Test your UPDATEs:**
```sql
-- Verify price updates
SELECT 
  book_id,
  title,
  price,
  (price / 1.05) AS old_price  -- If you increased by 5%
FROM books;
```

**Verify DELETEs:**
```sql
-- Check what was deleted
SELECT * FROM books_backup 
WHERE book_id NOT IN (SELECT book_id FROM books);
```

---

*Happy practicing! 🚀*

