# SQL Joins & Union Tutorial

A comprehensive guide to joining tables and combining result sets in SQL.

---

## Table of Contents

1. [Database Setup](#database-setup)
2. [Understanding Relationships](#understanding-relationships)
3. [INNER JOIN](#inner-join)
4. [LEFT JOIN](#left-join)
5. [RIGHT JOIN](#right-join)
6. [FULL OUTER JOIN](#full-outer-join)
7. [CROSS JOIN](#cross-join)
8. [SELF JOIN](#self-join)
9. [UNION](#union)
10. [Summary](#summary)

---

## Database Setup

### Creating the Database

```sql
CREATE DATABASE IF NOT EXISTS school_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE school_db;
```

### Creating Tables with All Relationship Types

#### 1. One-to-Many Relationships

**Courses Table (Parent)**
```sql
CREATE TABLE courses (
    id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);
```

**Classes Table (Child - Many classes belong to one course)**
```sql
CREATE TABLE classes (
    id INT PRIMARY KEY,
    class_name VARCHAR(10) NOT NULL,
    building VARCHAR(50),
    course_id INT,
    status VARCHAR(50),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);
```

**Students Table (Child - Many students belong to one class)**
```sql
CREATE TABLE students (
    id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    identity_number VARCHAR(50),
    birth_date DATE,
    class_id INT,
    personal_id VARCHAR(50),
    FOREIGN KEY (class_id) REFERENCES classes(id)
);
```

#### 2. One-to-One Relationship

**Lecturers Table (Parent)**
```sql
CREATE TABLE lecturers (
    id INT PRIMARY KEY,
    lecturer_name VARCHAR(255) NOT NULL
);
```

**LecturerContracts Table (Child - One contract per lecturer)**
```sql
CREATE TABLE lecturer_contracts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    lecturer_id INT UNIQUE NOT NULL,
    start_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    end_date DATE,
    FOREIGN KEY (lecturer_id) REFERENCES lecturers(id)
);
```

#### 3. Many-to-Many Relationship

**Assignments Table**
```sql
CREATE TABLE assignments (
    id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE,
    course_id INT,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);
```

**StudentAssignments Junction Table**
```sql
CREATE TABLE student_assignments (
    student_id INT,
    assignment_id INT,
    submitted_date DATE,
    grade DECIMAL(5,2),
    status VARCHAR(50) DEFAULT 'Pending',
    PRIMARY KEY (student_id, assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(id)
);
```

#### 4. Additional Tables

**StudyHours Table (Many-to-Many: Classes ↔ Lecturers)**
```sql
CREATE TABLE study_hours (
    id INT PRIMARY KEY,
    class_id INT,
    morning_lecturer_id INT,
    afternoon_lecturer_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(id),
    FOREIGN KEY (morning_lecturer_id) REFERENCES lecturers(id),
    FOREIGN KEY (afternoon_lecturer_id) REFERENCES lecturers(id)
);
```

### Inserting Data

#### Insert Courses
```sql
INSERT INTO courses (id, course_name) VALUES
(1, 'FullStack'),
(2, 'Data'),
(3, 'DevOps'),
(4, 'Product'),
(5, 'Cybersecurity');
```

**Note:** Course 'Cybersecurity' has no classes assigned. This will help demonstrate RIGHT JOIN and FULL OUTER JOIN.

#### Insert Classes
```sql
INSERT INTO classes (id, class_name, building, course_id, status) VALUES
(1, 'A', 'North', 4, 'Active'),
(2, 'B', 'South', 3, 'Active'),
(3, 'C', 'South', 2, 'Active'),
(4, 'D', 'North', 1, 'Active'),
(5, 'E', 'East', 1, 'Active');
```

**Note:** Class E is an empty class with no students assigned. This will help demonstrate RIGHT JOIN and FULL OUTER JOIN.

#### Insert Lecturers
```sql
INSERT INTO lecturers (id, lecturer_name) VALUES
(1, 'Michael Jackson'),
(2, 'Linda Robinson'),
(3, 'John Smith'),
(4, 'Michael Clark'),
(5, 'James Anderson'),
(6, 'David Martin'),
(7, 'Michael Thompson'),
(8, 'Robert Robinson'),
(9, 'Sarah Williams');
```

**Note:** Lecturer 9 (Sarah Williams) has no contract assigned. This will help demonstrate LEFT JOIN and FULL OUTER JOIN.

#### Insert Lecturer Contracts (1:1 Relationship)
```sql
INSERT INTO lecturer_contracts (lecturer_id, start_date, salary, contract_type, end_date) VALUES
(1, '2023-01-15', 25000.00, 'Full-Time', NULL),
(2, '2023-02-01', 22000.00, 'Full-Time', NULL),
(3, '2023-03-01', 23000.00, 'Part-Time', '2024-12-31'),
(4, '2023-01-20', 24000.00, 'Full-Time', NULL),
(5, '2023-02-15', 21000.00, 'Part-Time', NULL),
(6, '2023-03-10', 22500.00, 'Full-Time', NULL),
(7, '2023-01-05', 23500.00, 'Full-Time', NULL),
(8, '2023-02-20', 21500.00, 'Part-Time', NULL);
```

#### Insert Students (Sample - 1:N Relationship)
```sql
INSERT INTO students (id, full_name, identity_number, birth_date, class_id, personal_id) VALUES
(1, 'Jennifer Thomas', '999411611691', '2000-07-04', 2, NULL),
(2, 'Linda Martinez', '999289350116', '1990-12-30', 2, NULL),
(3, 'James Thomas', '999448720308', '1991-07-28', 2, NULL),
(4, 'Barbara Rodriguez', '999646429005', '1992-08-21', 2, NULL),
(5, 'Michael Clark', '999494918151', '1992-09-18', 4, NULL),
(6, 'Laura Martinez', '999772986850', '1995-10-13', 4, NULL),
(7, 'Michael Martin', '999946092255', '1990-10-16', 1, NULL),
(8, 'William Smith', '999561834985', '1992-12-06', 1, NULL),
(9, 'Michael Jackson', '999211401204', '1998-08-11', 2, NULL),
(10, 'Jennifer Thompson', '999239978839', '1996-12-16', 2, NULL),
(11, 'Sarah Johnson', '999123456789', '1999-01-15', NULL, NULL),
(12, 'David Wilson', '999987654321', '2000-03-22', NULL, NULL),
(13, 'Emily Davis', '999555123456', '1998-06-10', NULL, NULL);
```

**Note:** Students 11, 12, and 13 have `NULL` for `class_id`, meaning they are not yet assigned to any class. This will help demonstrate the difference between INNER JOIN and LEFT JOIN.

#### Insert Assignments
```sql
INSERT INTO assignments (id, title, description, due_date, course_id) VALUES
(1, 'Database Design Project', 'Design a normalized database schema', '2024-12-15', 1),
(2, 'SQL Queries Practice', 'Write complex JOIN queries', '2024-12-20', 1),
(3, 'Data Analysis Report', 'Analyze sales data using SQL', '2024-12-18', 2),
(4, 'DevOps Pipeline Setup', 'Create CI/CD pipeline', '2024-12-22', 3),
(5, 'Product Requirements Document', 'Write PRD for new feature', '2024-12-25', 4),
(6, 'Security Audit Report', 'Conduct security assessment', '2024-12-30', 5);
```

**Note:** Assignment 6 (Security Audit Report) has no student submissions. This will help demonstrate RIGHT JOIN and FULL OUTER JOIN.

#### Insert Student Assignments (N:M Relationship)
```sql
INSERT INTO student_assignments (student_id, assignment_id, submitted_date, grade, status) VALUES
(1, 1, '2024-12-14', 85.5, 'Graded'),
(1, 2, '2024-12-19', 90.0, 'Graded'),
(2, 1, '2024-12-15', 78.0, 'Graded'),
(2, 3, NULL, NULL, 'Pending'),
(3, 1, '2024-12-13', 92.5, 'Graded'),
(3, 2, NULL, NULL, 'Pending'),
(5, 4, '2024-12-21', 88.0, 'Graded'),
(7, 5, NULL, NULL, 'Pending'),
(8, 5, '2024-12-24', 95.0, 'Graded');
```

#### Insert Study Hours
```sql
INSERT INTO study_hours (id, class_id, morning_lecturer_id, afternoon_lecturer_id) VALUES
(1, 1, 1, 1),
(2, 2, 8, 2),
(3, 3, 7, 4),
(4, 4, 2, 7);
```

---

## Understanding Relationships

Before diving into JOINs, it's crucial to understand the relationships between tables:

- **One-to-Many (1:N)**: One course has many classes, one class has many students
- **One-to-One (1:1)**: One lecturer has exactly one contract
- **Many-to-Many (N:M)**: Students can have many assignments, assignments can be given to many students

---

## INNER JOIN

**INNER JOIN** returns only rows where there's a match in both tables.

### Syntax
```sql
SELECT columns
FROM table1
INNER JOIN table2 ON table1.column = table2.column;
```

### Example 1: Students with Their Classes
```sql
SELECT 
    s.id,
    s.full_name,
    c.class_name,
    c.building
FROM students s
INNER JOIN classes c ON s.class_id = c.id;
```

**Result:** Only students who are assigned to a class (no NULL class_id). Students 11, 12, and 13 (with NULL class_id) will **NOT** appear in the results.

### Example 2: Classes with Their Courses
```sql
SELECT 
    cl.class_name,
    cl.building,
    co.course_name
FROM classes cl
INNER JOIN courses co ON cl.course_id = co.id;
```

### Example 3: Multiple JOINs - Students, Classes, and Courses
```sql
SELECT 
    s.full_name AS student_name,
    cl.class_name,
    co.course_name
FROM students s
INNER JOIN classes cl ON s.class_id = cl.id
INNER JOIN courses co ON cl.course_id = co.id;
```

### Example 4: Lecturers with Contracts (1:1)
```sql
SELECT 
    l.lecturer_name,
    lc.start_date,
    lc.salary,
    lc.contract_type
FROM lecturers l
INNER JOIN lecturer_contracts lc ON l.id = lc.lecturer_id;
```

### Example 5: Students with Submitted Assignments (N:M)
```sql
SELECT 
    s.full_name AS student_name,
    a.title AS assignment_title,
    sa.submitted_date,
    sa.grade
FROM students s
INNER JOIN student_assignments sa ON s.id = sa.student_id
INNER JOIN assignments a ON sa.assignment_id = a.id
WHERE sa.status = 'Graded';
```

---

## LEFT JOIN

**LEFT JOIN** returns all rows from the left table and matching rows from the right table. If no match, NULL values are returned.

### Syntax
```sql
SELECT columns
FROM table1
LEFT JOIN table2 ON table1.column = table2.column;
```

### Example 1: All Students (Including Those Without Classes)
```sql
SELECT 
    s.id,
    s.full_name,
    c.class_name,
    c.building
FROM students s
LEFT JOIN classes c ON s.class_id = c.id;
```

**Result:** All students, with NULL for class_name and building if student has no class. Students 11, 12, and 13 (with NULL class_id) **WILL** appear in the results with NULL values for class_name and building.

**Key Difference from INNER JOIN:** This query returns 13 rows (all students), while the INNER JOIN example above returns only 10 rows (excluding unassigned students).

### Example 2: All Lecturers (Including Those Without Contracts)
```sql
SELECT 
    l.lecturer_name,
    lc.start_date,
    lc.contract_type
FROM lecturers l
LEFT JOIN lecturer_contracts lc ON l.id = lc.lecturer_id;
```

### Example 3: All Classes and Their Students (Including Empty Classes)
```sql
SELECT 
    c.class_name,
    c.building,
    s.full_name AS student_name
FROM classes c
LEFT JOIN students s ON c.id = s.class_id
ORDER BY c.class_name, s.full_name;
```

### Example 4: Find Students Without Classes
```sql
SELECT 
    s.id,
    s.full_name
FROM students s
LEFT JOIN classes c ON s.class_id = c.id
WHERE c.id IS NULL;
```

**Result:** Returns students 11, 12, and 13 (the students with NULL class_id). This is a common pattern to find records in the left table that don't have a matching record in the right table.

### Example 5: All Assignments and Student Submissions
```sql
SELECT 
    a.title AS assignment_title,
    s.full_name AS student_name,
    sa.grade,
    sa.status
FROM assignments a
LEFT JOIN student_assignments sa ON a.id = sa.assignment_id
LEFT JOIN students s ON sa.student_id = s.id
ORDER BY a.title, s.full_name;
```

**Result:** Returns all assignments, including assignment 6 (Security Audit Report) with NULL for student_name, grade, and status since no students have submitted it yet.

### Example 6: Side-by-Side Comparison - INNER JOIN vs LEFT JOIN

**INNER JOIN - Only Students with Classes:**
```sql
SELECT 
    s.id,
    s.full_name,
    c.class_name
FROM students s
INNER JOIN classes c ON s.class_id = c.id
ORDER BY s.id;
```
**Returns:** 10 rows (excludes students 11, 12, 13 who have NULL class_id)

**LEFT JOIN - All Students:**
```sql
SELECT 
    s.id,
    s.full_name,
    c.class_name
FROM students s
LEFT JOIN classes c ON s.class_id = c.id
ORDER BY s.id;
```
**Returns:** 13 rows (includes all students, with NULL class_name for students 11, 12, 13)

**Visual Comparison:**
- **INNER JOIN:** Only shows students who have a class assignment
- **LEFT JOIN:** Shows ALL students, with NULL values for class information when no class is assigned

---

## RIGHT JOIN

**RIGHT JOIN** returns all rows from the right table and matching rows from the left table. If no match, NULL values are returned.

### Syntax
```sql
SELECT columns
FROM table1
RIGHT JOIN table2 ON table1.column = table2.column;
```

### Example 1: All Classes (Including Those Without Students)
```sql
SELECT 
    s.full_name AS student_name,
    c.class_name,
    c.building
FROM students s
RIGHT JOIN classes c ON s.class_id = c.id;
```

**Result:** All classes, with NULL for student_name if class has no students. Class E (with no students) **WILL** appear in the results with NULL for student_name.

### Example 2: All Courses and Their Classes
```sql
SELECT 
    co.course_name,
    cl.class_name,
    cl.building
FROM classes cl
RIGHT JOIN courses co ON cl.course_id = co.id;
```

**Result:** All courses, with NULL for class_name and building if course has no classes. Course 'Cybersecurity' (with no classes) **WILL** appear in the results with NULL values.

### Example 3: Find Classes Without Students
```sql
SELECT 
    c.class_name,
    c.building
FROM students s
RIGHT JOIN classes c ON s.class_id = c.id
WHERE s.id IS NULL;
```

**Result:** Returns class E (the empty class with no students). This demonstrates how RIGHT JOIN can find records in the right table that don't have matches in the left table.

**Note:** RIGHT JOIN is less commonly used. You can achieve the same result by swapping tables and using LEFT JOIN.

---

## FULL OUTER JOIN

**FULL OUTER JOIN** returns all rows from both tables. If there's no match, NULL values are returned.

**Note:** MySQL doesn't support FULL OUTER JOIN directly. Use UNION of LEFT and RIGHT JOINs.

### Syntax (MySQL Workaround)
```sql
SELECT columns FROM table1 LEFT JOIN table2 ON condition
UNION
SELECT columns FROM table1 RIGHT JOIN table2 ON condition;
```

### Example: All Students and All Classes
```sql
SELECT 
    s.full_name AS student_name,
    c.class_name
FROM students s
LEFT JOIN classes c ON s.class_id = c.id

UNION

SELECT 
    s.full_name AS student_name,
    c.class_name
FROM students s
RIGHT JOIN classes c ON s.class_id = c.id;
```

**Result:** Returns all students (including unassigned students 11, 12, 13 with NULL class_name) AND all classes (including empty class E with NULL student_name). This demonstrates FULL OUTER JOIN behavior.

### Example: All Lecturers and All Contracts
```sql
SELECT 
    l.lecturer_name,
    lc.contract_type,
    lc.salary
FROM lecturers l
LEFT JOIN lecturer_contracts lc ON l.id = lc.lecturer_id

UNION

SELECT 
    l.lecturer_name,
    lc.contract_type,
    lc.salary
FROM lecturers l
RIGHT JOIN lecturer_contracts lc ON l.id = lc.lecturer_id;
```

**Result:** Returns all lecturers (including Sarah Williams with NULL contract info) AND all contracts. This demonstrates FULL OUTER JOIN behavior, showing both lecturers without contracts and contracts (though in this 1:1 relationship, all contracts have lecturers).

---

## CROSS JOIN

**CROSS JOIN** returns the Cartesian product of two tables (every row from table1 combined with every row from table2).

### Syntax
```sql
SELECT columns
FROM table1
CROSS JOIN table2;
```

### Example 1: All Possible Student-Class Combinations
```sql
SELECT 
    s.full_name AS student_name,
    c.class_name
FROM students s
CROSS JOIN classes c;
```

**Result:** If you have 13 students and 5 classes, you get 65 rows (13 × 5 = 65).

### Example 2: All Possible Lecturer-Course Combinations
```sql
SELECT 
    l.lecturer_name,
    co.course_name
FROM lecturers l
CROSS JOIN courses co;
```

### Practical Use Case: Generate All Possible Student-Assignment Pairs
```sql
SELECT 
    s.full_name AS student_name,
    a.title AS assignment_title
FROM students s
CROSS JOIN assignments a
WHERE a.course_id = (
    SELECT course_id 
    FROM classes 
    WHERE id = s.class_id
);
```

---

## SELF JOIN

**SELF JOIN** joins a table to itself. Useful for hierarchical data or comparing rows within the same table.

### Syntax
```sql
SELECT columns
FROM table1 alias1
JOIN table1 alias2 ON alias1.column = alias2.column;
```

### Example 1: Find Students in the Same Class
```sql
SELECT 
    s1.full_name AS student1,
    s2.full_name AS student2,
    c.class_name
FROM students s1
INNER JOIN students s2 ON s1.class_id = s2.class_id
INNER JOIN classes c ON s1.class_id = c.id
WHERE s1.id < s2.id  -- Avoid duplicates and self-pairs
ORDER BY c.class_name, s1.full_name;
```

### Example 2: Find Lecturers Teaching Both Morning and Afternoon
```sql
SELECT 
    l.lecturer_name,
    sh.class_id,
    cl.class_name
FROM study_hours sh
INNER JOIN lecturers l ON sh.morning_lecturer_id = l.id
INNER JOIN lecturers l2 ON sh.afternoon_lecturer_id = l2.id
INNER JOIN classes cl ON sh.class_id = cl.id
WHERE sh.morning_lecturer_id = sh.afternoon_lecturer_id;
```

### Example 3: Compare Contract Salaries (Find Lecturers with Similar Salaries)
```sql
SELECT 
    l1.lecturer_name AS lecturer1,
    lc1.salary AS salary1,
    l2.lecturer_name AS lecturer2,
    lc2.salary AS salary2,
    ABS(lc1.salary - lc2.salary) AS salary_difference
FROM lecturer_contracts lc1
INNER JOIN lecturers l1 ON lc1.lecturer_id = l1.id
INNER JOIN lecturer_contracts lc2 ON lc1.lecturer_id < lc2.lecturer_id
INNER JOIN lecturers l2 ON lc2.lecturer_id = l2.id
WHERE ABS(lc1.salary - lc2.salary) < 1000
ORDER BY salary_difference;
```

---

## UNION

**UNION** combines results from multiple SELECT statements, removing duplicates.

**UNION ALL** combines results but keeps duplicates.

### Syntax
```sql
SELECT columns FROM table1
UNION
SELECT columns FROM table2;
```

### Rules:
1. All SELECT statements must have the same number of columns
2. Corresponding columns must have compatible data types
3. Column names from the first SELECT are used

### Example 1: Combine Students and Lecturers Names
```sql
SELECT full_name AS person_name, 'Student' AS person_type
FROM students

UNION

SELECT lecturer_name AS person_name, 'Lecturer' AS person_type
FROM lecturers
ORDER BY person_name;
```

### Example 2: All Active Contracts (Full-Time and Part-Time)
```sql
SELECT 
    l.lecturer_name,
    lc.contract_type,
    lc.salary,
    'Active' AS status
FROM lecturers l
INNER JOIN lecturer_contracts lc ON l.id = lc.lecturer_id
WHERE lc.end_date IS NULL

UNION

SELECT 
    l.lecturer_name,
    lc.contract_type,
    lc.salary,
    'Expiring Soon' AS status
FROM lecturers l
INNER JOIN lecturer_contracts lc ON l.id = lc.lecturer_id
WHERE lc.end_date IS NOT NULL AND lc.end_date <= '2024-12-31';
```

### Example 3: UNION ALL (Keep Duplicates)
```sql
-- Get all names from students and lecturers, including duplicates
SELECT full_name AS name FROM students
UNION ALL
SELECT lecturer_name AS name FROM lecturers
ORDER BY name;
```

### Example 4: Combine Different Data Sources
```sql
SELECT 
    class_name AS name,
    'Class' AS type,
    building AS location
FROM classes

UNION

SELECT 
    course_name AS name,
    'Course' AS type,
    NULL AS location
FROM courses

ORDER BY type, name;
```

---

## Advanced JOIN Examples

### Example 1: Complex Multi-Table JOIN
```sql
-- Get complete student information with class, course, and assignments
SELECT 
    s.full_name AS student_name,
    cl.class_name,
    co.course_name,
    a.title AS assignment_title,
    sa.grade,
    sa.status
FROM students s
LEFT JOIN classes cl ON s.class_id = cl.id
LEFT JOIN courses co ON cl.course_id = co.id
LEFT JOIN student_assignments sa ON s.id = sa.student_id
LEFT JOIN assignments a ON sa.assignment_id = a.id
ORDER BY s.full_name, a.title;
```

### Example 2: Study Hours with All Related Information
```sql
SELECT 
    cl.class_name,
    co.course_name,
    ml.lecturer_name AS morning_lecturer,
    al.lecturer_name AS afternoon_lecturer
FROM study_hours sh
INNER JOIN classes cl ON sh.class_id = cl.id
INNER JOIN courses co ON cl.course_id = co.id
LEFT JOIN lecturers ml ON sh.morning_lecturer_id = ml.id
LEFT JOIN lecturers al ON sh.afternoon_lecturer_id = al.id;
```

### Example 3: Aggregations with JOINs
```sql
-- Count students per class with course information
SELECT 
    cl.class_name,
    co.course_name,
    COUNT(s.id) AS student_count
FROM classes cl
LEFT JOIN courses co ON cl.course_id = co.id
LEFT JOIN students s ON cl.id = s.class_id
GROUP BY cl.id, cl.class_name, co.course_name
ORDER BY student_count DESC;
```

### Example 4: Conditional JOINs
```sql
-- Find students with high grades on assignments
SELECT 
    s.full_name AS student_name,
    a.title AS assignment_title,
    sa.grade,
    CASE 
        WHEN sa.grade >= 90 THEN 'Excellent'
        WHEN sa.grade >= 80 THEN 'Good'
        WHEN sa.grade >= 70 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS performance
FROM students s
INNER JOIN student_assignments sa ON s.id = sa.student_id
INNER JOIN assignments a ON sa.assignment_id = a.id
WHERE sa.grade IS NOT NULL
ORDER BY sa.grade DESC;
```

---

## Summary

### JOIN Types Comparison

| JOIN Type | Description | Use Case |
|-----------|-------------|----------|
| **INNER JOIN** | Returns matching rows only | When you need data that exists in both tables |
| **LEFT JOIN** | Returns all left table rows + matches | When you need all records from the left table |
| **RIGHT JOIN** | Returns all right table rows + matches | When you need all records from the right table |
| **FULL OUTER JOIN** | Returns all rows from both tables | When you need all records from both tables (MySQL: use UNION) |
| **CROSS JOIN** | Cartesian product | When you need all possible combinations |
| **SELF JOIN** | Join table to itself | For hierarchical data or comparing rows within same table |

### UNION vs UNION ALL

| Operation | Duplicates | Performance |
|-----------|------------|-------------|
| **UNION** | Removes duplicates | Slower (needs sorting) |
| **UNION ALL** | Keeps duplicates | Faster (no sorting) |

### Best Practices

1. **Always use table aliases** for readability
2. **Use INNER JOIN** when you only need matching records
3. **Use LEFT JOIN** when you need all records from the left table
4. **Specify JOIN conditions explicitly** (avoid implicit joins)
5. **Use WHERE clauses** to filter results after joining
6. **Index foreign keys** for better JOIN performance
7. **Use UNION ALL** instead of UNION when duplicates don't matter

### Common Patterns

```sql
-- Pattern 1: Find records without relationships
SELECT * FROM table1
LEFT JOIN table2 ON condition
WHERE table2.id IS NULL;

-- Pattern 2: Combine multiple data sources
SELECT columns FROM table1
UNION
SELECT columns FROM table2;

-- Pattern 3: Hierarchical data with SELF JOIN
SELECT t1.*, t2.*
FROM table t1
JOIN table t2 ON t1.parent_id = t2.id;
```

---

## Exercises

1. Write a query to find all students who haven't submitted any assignments.
2. List all lecturers with their contract details, including those without contracts.
3. Find all classes that have no students enrolled.
4. Get a list of all assignments with the number of students who submitted each.
5. Create a report showing each student's class, course, and all their assignment grades.
6. Find lecturers who teach both morning and afternoon classes for the same class.
7. Combine a list of all course names and class names using UNION.

---

**End of Tutorial**

