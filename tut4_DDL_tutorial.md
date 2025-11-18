# SQL DDL (Data Definition Language) Tutorial

A comprehensive guide to creating, modifying, and managing database structures using SQL DDL commands.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Creating Databases](#creating-databases)
3. [Creating Tables](#creating-tables)
4. [Data Types](#data-types)
5. [Constraints](#constraints)
6. [Modifying Tables (ALTER TABLE)](#modifying-tables-alter-table)
7. [Dropping Tables](#dropping-tables)
8. [Truncating Tables](#truncating-tables)
9. [Indexes](#indexes)
10. [Best Practices](#best-practices)
11. [Summary](#summary)
12. [Exercises](#exercises)

---

## Introduction

**DDL (Data Definition Language)** is used to define and modify database structures. DDL commands include:

- `CREATE` - Create databases, tables, indexes
- `ALTER` - Modify existing database structures
- `DROP` - Delete databases, tables, indexes
- `TRUNCATE` - Remove all data from a table
- `RENAME` - Rename tables or columns

**Important:** DDL commands are typically auto-committed and cannot be rolled back in most databases.

---

## Creating Databases

### CREATE DATABASE

Creates a new database.

**Basic Syntax:**
```sql
CREATE DATABASE database_name;
```

**Example:**
```sql
CREATE DATABASE student_management;
```

**With Character Set:**
```sql
CREATE DATABASE student_management
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

**Explanation:**
- `CHARACTER SET utf8mb4` - Sets the character encoding to UTF-8 with full 4-byte support. This allows storing all Unicode characters, including emojis (😀, 🚀) and international characters (中文, العربية). It's the recommended character set for modern applications.
- `COLLATE utf8mb4_unicode_ci` - Sets the collation (sorting and comparison rules). The `_ci` means "case-insensitive" (treats 'A' and 'a' as the same). `unicode_ci` provides accurate sorting for international characters. Use this for proper text comparison and sorting.

**Check if database exists (avoid error):**
```sql
CREATE DATABASE IF NOT EXISTS student_management;
```

**Use/Select a database:**
```sql
USE student_management;
```

**Show all databases:**
```sql
SHOW DATABASES;
```

**Drop a database:**
```sql
DROP DATABASE IF EXISTS student_management;
```

---

## Creating Tables

### CREATE TABLE - Basic Syntax

**Basic Structure:**
```sql
CREATE TABLE table_name (
  column1 datatype constraint,
  column2 datatype constraint,
  ...
);
```

### Example 1: Simple Table

**Create a students table:**
```sql
CREATE DATABASE IF NOT EXISTS student_management;
USE student_management;

CREATE TABLE students (
  student_id INT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  enrollment_date DATE
);
```

**Verify table creation:**
```sql
SHOW TABLES;
DESCRIBE students;
```

---

## Data Types

### Common MySQL Data Types

#### Numeric Types

- `INT` or `INTEGER` - Whole numbers (-2,147,483,648 to 2,147,483,647)
- `BIGINT` - Large whole numbers
- `SMALLINT` - Small whole numbers
- `TINYINT` - Very small whole numbers (0-255)
- `DECIMAL(M, D)` - Fixed-point numbers (M = total digits, D = decimal places)
- `FLOAT` - Floating-point numbers (approximate)
- `DOUBLE` - Double-precision floating-point

**Examples:**
```sql
CREATE TABLE products (
  product_id INT,
  price DECIMAL(10, 2),  -- 10 total digits, 2 after decimal
  quantity SMALLINT,
  discount_percentage FLOAT
);
```

#### String Types

- `CHAR(N)` - Fixed-length string (0-255 characters)
- `VARCHAR(N)` - Variable-length string (0-65,535 characters)
- `TEXT` - Large text (up to 65,535 characters)
- `MEDIUMTEXT` - Medium text (up to 16MB)
- `LONGTEXT` - Very large text (up to 4GB)

**Examples:**
```sql
CREATE TABLE users (
  username CHAR(20),        -- Always 20 characters
  email VARCHAR(100),       -- Up to 100 characters
  bio TEXT                  -- Large text
);
```

#### Date and Time Types

- `DATE` - Date (YYYY-MM-DD)
- `TIME` - Time (HH:MM:SS)
- `DATETIME` - Date and time (YYYY-MM-DD HH:MM:SS)
- `TIMESTAMP` - Automatic timestamp
- `YEAR` - Year (1901-2155)

**Examples:**
```sql
CREATE TABLE events (
  event_id INT,
  event_name VARCHAR(100),
  event_date DATE,
  start_time TIME,
  created_at DATETIME,
  updated_at TIMESTAMP
);
```

#### Boolean Type

- `BOOLEAN` or `BOOL` - Stored as TINYINT(1) (0 = false, 1 = true)

**Example:**
```sql
CREATE TABLE tasks (
  task_id INT,
  task_name VARCHAR(100),
  is_completed BOOLEAN
);
```

---

## Constraints

Constraints enforce rules on data in tables.

### PRIMARY KEY

Uniquely identifies each row. A table can have only one primary key.

**Example:**
```sql
CREATE TABLE students (
  student_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100)
);
```

**Composite Primary Key (multiple columns):**
```sql
CREATE TABLE enrollments (
  student_id INT,
  course_id INT,
  enrollment_date DATE,
  PRIMARY KEY (student_id, course_id)
);
```

### AUTO_INCREMENT

Automatically generates a unique number for each new row.

**Example:**
```sql
CREATE TABLE students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100)
);
```

### NOT NULL

Ensures a column cannot have NULL values.

**Example:**
```sql
CREATE TABLE students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100),
  phone VARCHAR(20) NOT NULL
);
```

### UNIQUE

Ensures all values in a column are different.

**Example:**
```sql
CREATE TABLE students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(20) UNIQUE NOT NULL
);
```

### DEFAULT

Sets a default value for a column when no value is specified.

**Example:**
```sql
CREATE TABLE students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  enrollment_date DATE DEFAULT (CURRENT_DATE),
  status VARCHAR(20) DEFAULT 'active',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### CHECK

Ensures values meet specific conditions (MySQL 8.0.16+).

**Example:**
```sql
CREATE TABLE students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  age INT CHECK (age >= 18 AND age <= 100),
  gpa DECIMAL(3, 2) CHECK (gpa >= 0.0 AND gpa <= 4.0)
);
```

### FOREIGN KEY

Creates a relationship between two tables. References a PRIMARY KEY in another table.

**Example:**
```sql
-- First, create the referenced table
CREATE TABLE departments (
  department_id INT PRIMARY KEY AUTO_INCREMENT,
  department_name VARCHAR(100) NOT NULL UNIQUE
);

-- Then create the table with foreign key
CREATE TABLE courses (
  course_id INT PRIMARY KEY AUTO_INCREMENT,
  course_name VARCHAR(100) NOT NULL,
  department_id INT,
  credits INT DEFAULT 3,
  FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
```

**Foreign Key with ON DELETE/ON UPDATE:**
```sql
CREATE TABLE enrollments (
  enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT,
  course_id INT,
  enrollment_date DATE DEFAULT (CURRENT_DATE),
  FOREIGN KEY (student_id) REFERENCES students(student_id) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(course_id) 
    ON DELETE RESTRICT 
    ON UPDATE CASCADE
);
```

**Foreign Key Options:**
- `ON DELETE CASCADE` - Delete related rows when parent is deleted
- `ON DELETE RESTRICT` - Prevent deletion if related rows exist
- `ON DELETE SET NULL` - Set foreign key to NULL when parent is deleted
- `ON UPDATE CASCADE` - Update foreign key when parent key changes

---

## Complete Example: Creating Related Tables

Let's create a complete student management system:

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS student_management;
USE student_management;

-- Create departments table
CREATE TABLE departments (
  department_id INT PRIMARY KEY AUTO_INCREMENT,
  department_name VARCHAR(100) NOT NULL UNIQUE,
  building VARCHAR(50),
  budget DECIMAL(12, 2) DEFAULT 0.00
);

-- Create students table
CREATE TABLE students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  date_of_birth DATE,
  enrollment_date DATE DEFAULT (CURRENT_DATE),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'graduated')),
  department_id INT,
  FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

-- Create courses table
CREATE TABLE courses (
  course_id INT PRIMARY KEY AUTO_INCREMENT,
  course_code VARCHAR(10) UNIQUE NOT NULL,
  course_name VARCHAR(100) NOT NULL,
  department_id INT,
  credits INT DEFAULT 3 CHECK (credits > 0 AND credits <= 6),
  max_students INT DEFAULT 30,
  FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE RESTRICT
);

-- Create enrollments table
CREATE TABLE enrollments (
  enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enrollment_date DATE DEFAULT (CURRENT_DATE),
  grade DECIMAL(4, 2) CHECK (grade >= 0.0 AND grade <= 100.0),
  status VARCHAR(20) DEFAULT 'enrolled' CHECK (status IN ('enrolled', 'completed', 'dropped')),
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE RESTRICT,
  UNIQUE (student_id, course_id)  -- Prevent duplicate enrollments
);
```

---

## Modifying Tables (ALTER TABLE)

`ALTER TABLE` is used to modify existing table structures.

### Adding Columns

**Add a single column:**
```sql
ALTER TABLE students
ADD COLUMN middle_name VARCHAR(50);
```

**Add multiple columns:**
```sql
ALTER TABLE students
ADD COLUMN address VARCHAR(200),
ADD COLUMN city VARCHAR(50),
ADD COLUMN postal_code VARCHAR(10);
```

**Add column with constraints:**
```sql
ALTER TABLE students
ADD COLUMN gpa DECIMAL(3, 2) CHECK (gpa >= 0.0 AND gpa <= 4.0);
```

**Add column at specific position:**
```sql
ALTER TABLE students
ADD COLUMN phone VARCHAR(20) AFTER email;
```

**Add column as first:**
```sql
ALTER TABLE students
ADD COLUMN student_number VARCHAR(20) FIRST;
```

### Modifying Columns

**Change column data type:**
```sql
ALTER TABLE students
MODIFY COLUMN phone VARCHAR(30);
```

**Modify column with constraints:**
```sql
ALTER TABLE students
MODIFY COLUMN email VARCHAR(150) NOT NULL UNIQUE;
```

### Renaming Columns

**Rename a column (keep same data type):**
```sql
ALTER TABLE students
CHANGE COLUMN phone phone_number VARCHAR(20);
```
*Note: You must specify the data type even if it's not changing*

**Rename a column and change its type:**
```sql
ALTER TABLE students
CHANGE COLUMN phone_number contact_phone VARCHAR(30);
```

**Rename a column with all constraints preserved:**
```sql
ALTER TABLE students
CHANGE COLUMN email email_address VARCHAR(100) UNIQUE NOT NULL;
```
*All existing constraints (UNIQUE, NOT NULL, etc.) must be re-specified*

### Dropping Columns

**Drop a single column:**
```sql
ALTER TABLE students
DROP COLUMN middle_name;
```

**Drop multiple columns:**
```sql
ALTER TABLE students
DROP COLUMN address,
DROP COLUMN city,
DROP COLUMN postal_code;
```

### Adding Constraints

**Add primary key:**
```sql
ALTER TABLE students
ADD PRIMARY KEY (student_id);
```

**Add foreign key:**
```sql
ALTER TABLE enrollments
ADD CONSTRAINT fk_student
FOREIGN KEY (student_id) REFERENCES students(student_id);
```

**Add unique constraint:**
```sql
ALTER TABLE students
ADD CONSTRAINT uk_email UNIQUE (email);
```

**Add check constraint:**
```sql
ALTER TABLE students
ADD CONSTRAINT chk_gpa CHECK (gpa >= 0.0 AND gpa <= 4.0);
```

### Dropping Constraints

**Drop primary key:**
```sql
ALTER TABLE students
DROP PRIMARY KEY;
```

**Drop foreign key:**
```sql
ALTER TABLE enrollments
DROP FOREIGN KEY fk_student;
```

**Drop unique constraint:**
```sql
ALTER TABLE students
DROP INDEX uk_email;
```

**Drop check constraint (MySQL 8.0.19+):**
```sql
ALTER TABLE students
DROP CHECK chk_gpa;
```

### Renaming Tables

**Rename a table:**
```sql
ALTER TABLE students
RENAME TO learners;
```

**Or use RENAME TABLE:**
```sql
RENAME TABLE learners TO students;
```

---

## Dropping Tables

### DROP TABLE

Permanently deletes a table and all its data.

**Basic syntax:**
```sql
DROP TABLE table_name;
```

**Drop with error prevention:**
```sql
DROP TABLE IF EXISTS students;
```

**Drop multiple tables:**
```sql
DROP TABLE IF EXISTS students, courses, enrollments;
```

**Drop table with foreign key constraints:**
If a table is referenced by foreign keys, you may need to drop those first or use `CASCADE`:

```sql
-- Drop dependent tables first
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS departments;
```

---

## Truncating Tables

`TRUNCATE TABLE` removes all rows from a table but keeps the table structure.

**Basic syntax:**
```sql
TRUNCATE TABLE students;
```

**Differences from DELETE:**
- `TRUNCATE` is faster
- `TRUNCATE` resets AUTO_INCREMENT counters
- `TRUNCATE` cannot be rolled back in some databases
- `TRUNCATE` cannot use WHERE clause

**Example:**
```sql
-- Remove all data but keep table structure
TRUNCATE TABLE enrollments;

-- Reset auto-increment counter
-- Next INSERT will start from 1
```

---

## Indexes

Indexes improve query performance by creating a data structure that allows faster data retrieval.

### CREATE INDEX

**Create a simple index:**
```sql
CREATE INDEX idx_last_name ON students(last_name);
```

**Create unique index:**
```sql
CREATE UNIQUE INDEX idx_email ON students(email);
```

**Create composite index (multiple columns):**
```sql
CREATE INDEX idx_name ON students(last_name, first_name);
```

**Create index with specific name:**
```sql
CREATE INDEX idx_student_name ON students(last_name, first_name);
```

### DROP INDEX

**Drop an index:**
```sql
DROP INDEX idx_last_name ON students;
```

### Show Indexes

**List all indexes on a table:**
```sql
SHOW INDEXES FROM students;
```

---

## Best Practices

### 1. Naming Conventions

- Use descriptive names: `student_id` not `id`
- Use lowercase with underscores: `student_name` not `StudentName`
- Be consistent: `student_id` not `studentId` or `student_ID`
- Use plural for table names: `students` not `student`
- Use singular for column names: `first_name` not `first_names`

### 2. Primary Keys

- Always define a primary key
- Use `AUTO_INCREMENT` for surrogate keys
- Use meaningful names: `student_id` not just `id`

### 3. Foreign Keys

- Always name your foreign keys for easier management
- Use appropriate `ON DELETE` and `ON UPDATE` actions
- Index foreign key columns for better performance

### 4. Data Types

- Choose appropriate data types (don't use VARCHAR(255) for everything)
- Use `DECIMAL` for money, not `FLOAT`
- Use `DATE` for dates, not `VARCHAR`
- Consider storage: `TINYINT` vs `INT` for small numbers

### 5. Constraints

- Use `NOT NULL` for required fields
- Use `UNIQUE` for fields that must be unique
- Use `CHECK` constraints to validate data
- Use `DEFAULT` values when appropriate

### 6. Documentation

- Add comments to complex tables
- Document business rules in constraints
- Keep a schema documentation file

**Example with comments:**
```sql
CREATE TABLE students (
  student_id INT PRIMARY KEY AUTO_INCREMENT COMMENT 'Unique student identifier',
  email VARCHAR(100) UNIQUE NOT NULL COMMENT 'Student email address, must be unique',
  enrollment_date DATE DEFAULT (CURRENT_DATE) COMMENT 'Date when student enrolled'
) COMMENT='Table storing student information';
```

---

## Summary

### Key DDL Commands

| Command | Purpose | Example |
|---------|---------|---------|
| `CREATE DATABASE` | Create a new database | `CREATE DATABASE mydb;` |
| `CREATE TABLE` | Create a new table | `CREATE TABLE users (...);` |
| `ALTER TABLE` | Modify table structure | `ALTER TABLE users ADD COLUMN ...;` |
| `DROP TABLE` | Delete a table | `DROP TABLE users;` |
| `TRUNCATE TABLE` | Remove all data | `TRUNCATE TABLE users;` |
| `RENAME TABLE` | Rename a table | `RENAME TABLE old TO new;` |
| `CREATE INDEX` | Create an index | `CREATE INDEX idx_name ON users(name);` |
| `DROP INDEX` | Delete an index | `DROP INDEX idx_name ON users;` |

### Common Constraints

| Constraint | Purpose |
|------------|---------|
| `PRIMARY KEY` | Uniquely identifies each row |
| `FOREIGN KEY` | Links to another table |
| `UNIQUE` | Ensures all values are different |
| `NOT NULL` | Prevents NULL values |
| `DEFAULT` | Sets default value |
| `CHECK` | Validates data against condition |
| `AUTO_INCREMENT` | Auto-generates unique numbers |

### Execution Order

When creating related tables:
1. Create referenced tables first (tables with PRIMARY KEYs)
2. Create dependent tables second (tables with FOREIGN KEYs)
3. Add indexes after table creation
4. Insert data last

---

## Exercises

### Exercise 1: Library Management System

Create a database and tables for a library management system with the following requirements:

**Database:** `library_db`

**Tables needed:**

1. **books** table:
   - `book_id` (INT, PRIMARY KEY, AUTO_INCREMENT)
   - `isbn` (VARCHAR, UNIQUE, NOT NULL)
   - `title` (VARCHAR(200), NOT NULL)
   - `author` (VARCHAR(100), NOT NULL)
   - `publisher` (VARCHAR(100))
   - `publication_year` (YEAR)
   - `category` (VARCHAR(50))
   - `total_copies` (INT, DEFAULT 1, CHECK >= 0)
   - `available_copies` (INT, DEFAULT 1, CHECK >= 0)

2. **members** table:
   - `member_id` (INT, PRIMARY KEY, AUTO_INCREMENT)
   - `first_name` (VARCHAR(50), NOT NULL)
   - `last_name` (VARCHAR(50), NOT NULL)
   - `email` (VARCHAR(100), UNIQUE, NOT NULL)
   - `phone` (VARCHAR(20))
   - `membership_date` (DATE, DEFAULT CURRENT_DATE)
   - `membership_type` (VARCHAR(20), DEFAULT 'standard', CHECK IN ('standard', 'premium', 'student'))
   - `status` (VARCHAR(20), DEFAULT 'active', CHECK IN ('active', 'inactive', 'suspended'))

3. **loans** table:
   - `loan_id` (INT, PRIMARY KEY, AUTO_INCREMENT)
   - `member_id` (INT, NOT NULL, FOREIGN KEY to members)
   - `book_id` (INT, NOT NULL, FOREIGN KEY to books)
   - `loan_date` (DATE, DEFAULT CURRENT_DATE)
   - `due_date` (DATE, NOT NULL)
   - `return_date` (DATE, NULL)
   - `status` (VARCHAR(20), DEFAULT 'borrowed', CHECK IN ('borrowed', 'returned', 'overdue'))
   - UNIQUE constraint on (member_id, book_id, loan_date) to prevent duplicate loans

**Requirements:**
- Create the database
- Create all three tables with appropriate constraints
- Add indexes on foreign key columns
- Add an index on `books.isbn` for faster lookups
- Add an index on `members.email` for faster lookups

**Hints:**
- Create tables in order: books → members → loans
- Use appropriate data types
- Set up foreign keys with appropriate ON DELETE actions
- Consider what happens if a member is deleted (should loans be deleted too?)

---

### Exercise 2: Employee Management System

Create a database and tables for an employee management system with the following requirements:

**Database:** `company_db`

**Tables needed:**

1. **departments** table:
   - `department_id` (INT, PRIMARY KEY, AUTO_INCREMENT)
   - `department_name` (VARCHAR(100), UNIQUE, NOT NULL)
   - `location` (VARCHAR(100))
   - `budget` (DECIMAL(12, 2), DEFAULT 0.00, CHECK >= 0)
   - `established_date` (DATE)

2. **employees** table:
   - `employee_id` (INT, PRIMARY KEY, AUTO_INCREMENT)
   - `first_name` (VARCHAR(50), NOT NULL)
   - `last_name` (VARCHAR(50), NOT NULL)
   - `email` (VARCHAR(100), UNIQUE, NOT NULL)
   - `phone` (VARCHAR(20))
   - `hire_date` (DATE, NOT NULL, DEFAULT CURRENT_DATE)
   - `salary` (DECIMAL(10, 2), CHECK > 0)
   - `job_title` (VARCHAR(100), NOT NULL)
   - `department_id` (INT, FOREIGN KEY to departments, ON DELETE SET NULL)
   - `manager_id` (INT, FOREIGN KEY to employees.employee_id, ON DELETE SET NULL)
   - `status` (VARCHAR(20), DEFAULT 'active', CHECK IN ('active', 'on_leave', 'terminated'))

3. **projects** table:
   - `project_id` (INT, PRIMARY KEY, AUTO_INCREMENT)
   - `project_name` (VARCHAR(100), NOT NULL)
   - `description` (TEXT)
   - `start_date` (DATE, NOT NULL)
   - `end_date` (DATE)
   - `budget` (DECIMAL(12, 2), CHECK >= 0)
   - `status` (VARCHAR(20), DEFAULT 'planning', CHECK IN ('planning', 'active', 'completed', 'cancelled'))

4. **employee_projects** table (junction table for many-to-many relationship):
   - `assignment_id` (INT, PRIMARY KEY, AUTO_INCREMENT)
   - `employee_id` (INT, NOT NULL, FOREIGN KEY to employees)
   - `project_id` (INT, NOT NULL, FOREIGN KEY to projects)
   - `role` (VARCHAR(50), DEFAULT 'team_member')
   - `hours_allocated` (INT, DEFAULT 0, CHECK >= 0)
   - `assignment_date` (DATE, DEFAULT CURRENT_DATE)
   - UNIQUE constraint on (employee_id, project_id)

**Additional Requirements:**
- Create the database
- Create all four tables with appropriate constraints
- Add indexes on all foreign key columns
- Add an index on `employees.email`
- Add a composite index on `employees(department_id, status)` for common queries
- Add a check constraint to ensure `projects.end_date` is after `start_date` (if both are provided)

**Hints:**
- Create tables in order: departments → employees → projects → employee_projects
- The `employees.manager_id` is a self-referencing foreign key (references the same table)
- Use appropriate ON DELETE actions (what should happen if a department is deleted?)
- Consider adding indexes for columns frequently used in WHERE clauses

---

## Solutions Template

After completing the exercises, you can verify your solutions by:

1. **Checking table structure:**
   ```sql
   DESCRIBE table_name;
   SHOW CREATE TABLE table_name;
   ```

2. **Checking constraints:**
   ```sql
   SELECT * FROM information_schema.TABLE_CONSTRAINTS 
   WHERE TABLE_SCHEMA = 'your_database_name';
   ```

3. **Checking indexes:**
   ```sql
   SHOW INDEXES FROM table_name;
   ```

4. **Testing constraints:**
   Try inserting invalid data to verify constraints work correctly.

---

*Good luck with your exercises! 🚀*

