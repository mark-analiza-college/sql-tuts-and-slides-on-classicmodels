# SQL Relationships Tutorial

## Overview

Database relationships define how tables connect to each other. There are three main types: **One-to-One (1:1)**, **One-to-Many (1:N)**, and **Many-to-Many (N:M)**.

---

## 1. One-to-One (1:1) Relationships

A one-to-one relationship means each record in one table relates to exactly one record in another table.

### Approach 1: Strict 1:1 — Shared Primary Key

The child table uses the same primary key as the parent table.

```sql
-- Parent table
CREATE TABLE teachers (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    subject VARCHAR(255)
);

-- Child table with shared PK = FK
CREATE TABLE teacher_contracts (
    teacher_id INT PRIMARY KEY,       -- PK and FK
    start_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);
```

**Key Point:** The foreign key is also the primary key, ensuring strict 1:1.

#### Example: Inserting Data (Strict 1:1)
```sql
INSERT INTO teachers (id, name, subject)
VALUES (10, 'David Levi', 'Mathematics');

INSERT INTO teacher_contracts (teacher_id, start_date, salary, contract_type)
VALUES (10, '2024-09-01', 21000.00, 'Full-Time');
```

**Note:** Notice that the `teacher_id` in `teacher_contracts` uses the same value (10) as the `id` in `teachers`, since they share the same primary key.

### Approach 2: Flexible 1:1 — Separate PK with UNIQUE Foreign Key

The child table has its own primary key, but the foreign key is UNIQUE to enforce 1:1.

```sql
-- Parent table
CREATE TABLE teachers (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    subject VARCHAR(255)
);

-- Child table with its own PK
CREATE TABLE teacher_contracts (
    id INT PRIMARY KEY,              -- independent PK
    teacher_id INT UNIQUE,           -- FK + UNIQUE → 1:1 enforced
    start_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);
```

**Key Point:** The `UNIQUE` constraint on `teacher_id` prevents multiple contracts for the same teacher.

#### Example: Inserting Data (Flexible 1:1)
```sql
INSERT INTO teachers (id, name, subject)
VALUES (20, 'Rina Cohen', 'History');

INSERT INTO teacher_contracts (id, teacher_id, start_date, salary, contract_type)
VALUES (1, 20, '2024-09-01', 19500.00, 'Part-Time');
```

**Note:** The contract has its own `id` (1), but the `teacher_id` (20) references the teacher and is UNIQUE.

#### Demonstrating the UNIQUE Constraint
If you try to add a second contract for the same teacher:
```sql
INSERT INTO teacher_contracts (id, teacher_id, start_date, salary, contract_type)
VALUES (2, 20, '2025-01-01', 20000.00, 'Full-Time');
```

**Result:** This will fail with an error: `duplicate key value violates unique constraint "teacher_id"` - proving that the UNIQUE constraint enforces the 1:1 relationship.

---

## 2. One-to-Many (1:N) Relationships

A one-to-many relationship means one record in the parent table can relate to many records in the child table.

**Example:** A class has many students, but each student belongs to one class.

```sql
CREATE TABLE classes (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(id)
);
```

**Key Point:** The foreign key (`class_id`) is in the "many" side (students table) and references the "one" side (classes table).

#### Example: Inserting Data (1:N)
```sql
INSERT INTO classes (id, name)
VALUES (1, 'Math 101');

INSERT INTO students (id, name, class_id)
VALUES 
    (101, 'Alice', 1),
    (102, 'Ben', 1),
    (103, 'Dana', 1);
```

**Result:** This creates:
- One class: Math 101
- Three students assigned to that class (all with `class_id = 1`)

---

## 3. Many-to-Many (N:M) Relationships

A many-to-many relationship means records in both tables can relate to multiple records in the other table.

**Example:** A student can have many assignments, and an assignment can be given to many students.

This requires a **junction table** (also called a bridge or linking table):

```sql
CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE assignments (
    id INT PRIMARY KEY,
    title VARCHAR(100)
);

-- Junction table
CREATE TABLE student_assignments (
    student_id INT,
    assignment_id INT,
    PRIMARY KEY (student_id, assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(id)
);
```

**Key Points:**
- The junction table contains foreign keys to both parent tables
- The composite primary key (`student_id, assignment_id`) prevents duplicate relationships
- This table stores the relationships between students and assignments

#### Example: Inserting Data (N:M)
```sql
INSERT INTO students (id, name)
VALUES (1, 'Alice'), (2, 'Ben');

INSERT INTO assignments (id, title)
VALUES (10, 'Math HW'), (11, 'Science HW');

INSERT INTO student_assignments (student_id, assignment_id)
VALUES
    (1, 10),  -- Alice → Math HW
    (1, 11),  -- Alice → Science HW
    (2, 10);  -- Ben → Math HW
```

**Result:** This creates:
- Two students: Alice and Ben
- Two assignments: Math HW and Science HW
- Three relationships:
  - Alice has both Math HW and Science HW
  - Ben has Math HW

---

## Summary

| Relationship Type | Implementation | Example |
|-------------------|----------------|---------|
| **1:1** | Shared PK or UNIQUE FK | Teacher ↔ Contract |
| **1:N** | FK in the "many" table | Class → Students |
| **N:M** | Junction table with composite PK | Students ↔ Assignments |

