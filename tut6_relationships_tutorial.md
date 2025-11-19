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
CREATE TABLE Teachers (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    subject VARCHAR(255)
);

-- Child table with shared PK = FK
CREATE TABLE TeacherContracts (
    teacher_id INT PRIMARY KEY,       -- PK and FK
    start_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(id)
);
```

**Key Point:** The foreign key is also the primary key, ensuring strict 1:1.

### Approach 2: Flexible 1:1 — Separate PK with UNIQUE Foreign Key

The child table has its own primary key, but the foreign key is UNIQUE to enforce 1:1.

```sql
-- Parent table
CREATE TABLE Teachers (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    subject VARCHAR(255)
);

-- Child table with its own PK
CREATE TABLE TeacherContracts (
    id INT PRIMARY KEY,              -- independent PK
    teacher_id INT UNIQUE,           -- FK + UNIQUE → 1:1 enforced
    start_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(id)
);
```

**Key Point:** The `UNIQUE` constraint on `teacher_id` prevents multiple contracts for the same teacher.

---

## 2. One-to-Many (1:N) Relationships

A one-to-many relationship means one record in the parent table can relate to many records in the child table.

**Example:** A class has many students, but each student belongs to one class.

```sql
CREATE TABLE Classes (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Students (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    class_id INT,
    FOREIGN KEY (class_id) REFERENCES Classes(id)
);
```

**Key Point:** The foreign key (`class_id`) is in the "many" side (Students table) and references the "one" side (Classes table).

---

## 3. Many-to-Many (N:M) Relationships

A many-to-many relationship means records in both tables can relate to multiple records in the other table.

**Example:** A student can have many assignments, and an assignment can be given to many students.

This requires a **junction table** (also called a bridge or linking table):

```sql
CREATE TABLE Students (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Assignments (
    id INT PRIMARY KEY,
    title VARCHAR(100)
);

-- Junction table
CREATE TABLE StudentAssignments (
    student_id INT,
    assignment_id INT,
    PRIMARY KEY (student_id, assignment_id),
    FOREIGN KEY (student_id) REFERENCES Students(id),
    FOREIGN KEY (assignment_id) REFERENCES Assignments(id)
);
```

**Key Points:**
- The junction table contains foreign keys to both parent tables
- The composite primary key (`student_id, assignment_id`) prevents duplicate relationships
- This table stores the relationships between students and assignments

---

## Summary

| Relationship Type | Implementation | Example |
|-------------------|----------------|---------|
| **1:1** | Shared PK or UNIQUE FK | Teacher ↔ Contract |
| **1:N** | FK in the "many" table | Class → Students |
| **N:M** | Junction table with composite PK | Students ↔ Assignments |

