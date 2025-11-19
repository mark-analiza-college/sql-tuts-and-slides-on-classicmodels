-- ============================================
-- School Database Setup Script
-- Complete database creation and data insertion
-- Copy and paste this entire file to set up the database
-- ============================================

-- Create Database
CREATE DATABASE IF NOT EXISTS school_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE school_db;

-- ============================================
-- CREATE TABLES
-- ============================================

-- Courses Table (Parent - One-to-Many)
CREATE TABLE courses (
    id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);

-- Classes Table (Child - Many classes belong to one course)
CREATE TABLE classes (
    id INT PRIMARY KEY,
    class_name VARCHAR(10) NOT NULL,
    building VARCHAR(50),
    course_id INT,
    status VARCHAR(50),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Students Table (Child - Many students belong to one class)
CREATE TABLE students (
    id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    identity_number VARCHAR(50),
    birth_date DATE,
    class_id INT,
    personal_id VARCHAR(50),
    FOREIGN KEY (class_id) REFERENCES classes(id)
);

-- Lecturers Table (Parent - One-to-One)
CREATE TABLE lecturers (
    id INT PRIMARY KEY,
    lecturer_name VARCHAR(255) NOT NULL
);

-- Lecturer Contracts Table (Child - One contract per lecturer)
CREATE TABLE lecturer_contracts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    lecturer_id INT UNIQUE NOT NULL,
    start_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    end_date DATE,
    FOREIGN KEY (lecturer_id) REFERENCES lecturers(id)
);

-- Assignments Table (Many-to-Many)
CREATE TABLE assignments (
    id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE,
    course_id INT,
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Student Assignments Junction Table (Many-to-Many)
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

-- Study Hours Table (Many-to-Many: Classes ↔ Lecturers)
CREATE TABLE study_hours (
    id INT PRIMARY KEY,
    class_id INT,
    morning_lecturer_id INT,
    afternoon_lecturer_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(id),
    FOREIGN KEY (morning_lecturer_id) REFERENCES lecturers(id),
    FOREIGN KEY (afternoon_lecturer_id) REFERENCES lecturers(id)
);

-- ============================================
-- INSERT DATA
-- ============================================

-- Insert Courses
INSERT INTO courses (id, course_name) VALUES
(1, 'FullStack'),
(2, 'Data'),
(3, 'DevOps'),
(4, 'Product'),
(5, 'Cybersecurity');

-- Insert Classes
INSERT INTO classes (id, class_name, building, course_id, status) VALUES
(1, 'A', 'North', 4, 'Active'),
(2, 'B', 'South', 3, 'Active'),
(3, 'C', 'South', 2, 'Active'),
(4, 'D', 'North', 1, 'Active'),
(5, 'E', 'East', 1, 'Active');

-- Insert Lecturers
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

-- Insert Lecturer Contracts (1:1 Relationship)
INSERT INTO lecturer_contracts (lecturer_id, start_date, salary, contract_type, end_date) VALUES
(1, '2023-01-15', 25000.00, 'Full-Time', NULL),
(2, '2023-02-01', 22000.00, 'Full-Time', NULL),
(3, '2023-03-01', 23000.00, 'Part-Time', '2024-12-31'),
(4, '2023-01-20', 24000.00, 'Full-Time', NULL),
(5, '2023-02-15', 21000.00, 'Part-Time', NULL),
(6, '2023-03-10', 22500.00, 'Full-Time', NULL),
(7, '2023-01-05', 23500.00, 'Full-Time', NULL),
(8, '2023-02-20', 21500.00, 'Part-Time', NULL);

-- Insert Students (1:N Relationship)
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

-- Insert Assignments
INSERT INTO assignments (id, title, description, due_date, course_id) VALUES
(1, 'Database Design Project', 'Design a normalized database schema', '2024-12-15', 1),
(2, 'SQL Queries Practice', 'Write complex JOIN queries', '2024-12-20', 1),
(3, 'Data Analysis Report', 'Analyze sales data using SQL', '2024-12-18', 2),
(4, 'DevOps Pipeline Setup', 'Create CI/CD pipeline', '2024-12-22', 3),
(5, 'Product Requirements Document', 'Write PRD for new feature', '2024-12-25', 4),
(6, 'Security Audit Report', 'Conduct security assessment', '2024-12-30', 5);

-- Insert Student Assignments (N:M Relationship)
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

-- Insert Study Hours
INSERT INTO study_hours (id, class_id, morning_lecturer_id, afternoon_lecturer_id) VALUES
(1, 1, 1, 1),
(2, 2, 8, 2),
(3, 3, 7, 4),
(4, 4, 2, 7);

-- ============================================
-- Setup Complete!
-- ============================================
-- The database is now ready for JOIN and UNION examples.
-- 
-- Key data points for demonstrating JOINs:
-- - Students 11, 12, 13 have NULL class_id (LEFT JOIN demo)
-- - Class E has no students (RIGHT JOIN demo)
-- - Course 'Cybersecurity' has no classes (RIGHT JOIN demo)
-- - Lecturer 9 (Sarah Williams) has no contract (LEFT JOIN demo)
-- - Assignment 6 has no student submissions (LEFT JOIN demo)
-- ============================================

