
# Chapter 3: Introduction to SQL

## Overview of the SQL Query Language
- Data Definition
- Basic Query Structure
- Additional Basic Operations
- Set Operations
- Null Values
- Aggregate Functions
- Nested Subqueries
- Modification of the Database

## SQL History
- Developed as SEQUEL at IBM
- Standardized as SQL by ANSI/ISO: SQL-86, SQL-89, SQL-92, SQL:1999, etc.

## SQL Language Parts
1. Data-definition Language (DDL)
2. Data-manipulation Language (DML)
3. Integrity Constraints
4. View Definition
5. Transaction Control
6. Embedded and Dynamic SQL
7. Authorization

## Data Definition
- Defining relation schemas and attributes
- Domain types: `char`, `varchar`, `int`, `numeric`, `float`, etc.
- `create table`, `drop table`, `alter table`

## Integrity Constraints
- `not null`, `primary key`, `foreign key`, `check`
- Example:
```sql
create table instructor (
  ID char(5),
  name varchar(20) not null,
  dept_name varchar(20),
  salary numeric(8,2),
  primary key (ID),
  foreign key (dept_name) references department
);
```

## Query Basics
- Query format:
```sql
select A1, A2
from R1, R2
where P;
```
- `select`, `from`, `where` clauses
- Arithmetic expressions, string matching, sorting

## Joins
- Cartesian product
- Natural join
- Join using `on` and `using`

## String Operations
- `like`, `%`, `_`, `||`, `upper()`, `lower()`

## Set Operations
- `union`, `intersect`, `except`
- `all` to retain duplicates

## Null Values
- `is null`, three-valued logic
- Aggregate behavior with nulls

## Aggregate Functions
- `avg`, `min`, `max`, `sum`, `count`
- `group by`, `having`

## Subqueries
- Scalar, nested, correlated
- `in`, `not in`, `exists`, `unique`

## With Clause and Subqueries in FROM
- Temporary views
- Example:
```sql
with max_budget (value) as (
  select max(budget) from department
)
select budget from department, max_budget
where department.budget = max_budget.value;
```

## Database Modifications
- `delete from`, `insert into`, `update`
- `case` statements
- Bulk loading and conditional updates

## Exercises
### Basic Queries
1. Retrieve all instructor names.
```sql
select name from instructor;
```
2. List all course titles in the Biology department.
```sql
select title from course where dept_name = 'Biology';
```

### Intermediate
1. List names and average salary of departments.
2. Find instructors earning more than any in 'Physics'.

### Advanced
1. List students who have taken all courses from 'Biology'.
2. Find departments with total salary > average of all departments.

## Solutions to Exercises
Solutions are embedded as SQL examples above. Practice modifying and running these queries in your DBMS.

---

Source: Database System Concepts, 6th Ed. by Silberschatz, Korth and Sudarshan.

---

# 🌟 SQL Topic-Wise Explanation with Exercises and Solutions

## 🔹 Overview of SQL Components

### 1. Data Definition Language (DDL)
- Used to define database schema (tables, data types, constraints)
- Commands: `CREATE`, `ALTER`, `DROP`

**Example:**
```sql
CREATE TABLE student (
  ID VARCHAR(5),
  name VARCHAR(20) NOT NULL,
  dept_name VARCHAR(20),
  tot_cred NUMERIC(3,0),
  PRIMARY KEY (ID),
  FOREIGN KEY (dept_name) REFERENCES department
);
```

### 2. Data Manipulation Language (DML)
- Commands to retrieve and manipulate data
- Commands: `SELECT`, `INSERT`, `UPDATE`, `DELETE`

### 3. Constraints
- `NOT NULL`, `UNIQUE`, `PRIMARY KEY`, `FOREIGN KEY`, `CHECK`

**Example:**
```sql
ALTER TABLE student ADD CONSTRAINT check_credit CHECK (tot_cred >= 0);
```

### 4. Views and Transactions
- `CREATE VIEW`, `BEGIN`, `COMMIT`, `ROLLBACK`

---

## 🔹 SQL Queries and Operations with Examples

### SELECT Clause
```sql
SELECT name, salary FROM instructor;
```

### WHERE Clause with Logical Operators
```sql
SELECT * FROM instructor WHERE salary > 70000 AND dept_name = 'Physics';
```

### DISTINCT, ORDER BY, LIMIT
```sql
SELECT DISTINCT dept_name FROM instructor;
SELECT * FROM instructor ORDER BY salary DESC LIMIT 5;
```

### Aggregate Functions
```sql
SELECT AVG(salary) FROM instructor;
SELECT dept_name, COUNT(*) FROM instructor GROUP BY dept_name;
```

### HAVING Clause
```sql
SELECT dept_name, AVG(salary) 
FROM instructor 
GROUP BY dept_name 
HAVING AVG(salary) > 42000;
```

---

## 🔹 JOINS

### INNER JOIN
```sql
SELECT name, course_id 
FROM instructor 
JOIN teaches ON instructor.ID = teaches.ID;
```

### NATURAL JOIN
```sql
SELECT * 
FROM instructor 
NATURAL JOIN teaches;
```

---

## 🔹 SUBQUERIES

### IN and NOT IN
```sql
SELECT name FROM instructor 
WHERE ID IN (SELECT ID FROM teaches WHERE year = 2010);
```

### EXISTS
```sql
SELECT name 
FROM instructor 
WHERE EXISTS (SELECT * FROM teaches WHERE teaches.ID = instructor.ID);
```

### SCALAR SUBQUERY
```sql
SELECT name, 
       (SELECT COUNT(*) FROM teaches WHERE teaches.ID = instructor.ID) as course_count 
FROM instructor;
```

---

## 🔹 SET OPERATIONS

```sql
(SELECT course_id FROM section WHERE semester = 'Fall') 
UNION 
(SELECT course_id FROM section WHERE semester = 'Spring');
```

```sql
(SELECT course_id FROM section WHERE semester = 'Fall') 
EXCEPT 
(SELECT course_id FROM section WHERE semester = 'Spring');
```

---

## 🔹 String Matching

```sql
SELECT name FROM instructor WHERE name LIKE '%Smith%';
```

---

## 🔹 Insertion

```sql
INSERT INTO student VALUES ('10101', 'John', 'Biology', 15);
```

## 🔹 Deletion

```sql
DELETE FROM student WHERE tot_cred < 10;
```

## 🔹 Update

```sql
UPDATE instructor SET salary = salary * 1.10 WHERE salary < 60000;
```

---

# 📝 Exercises with Solutions

## 1. Find all students in ‘Comp. Sci.’
```sql
SELECT * FROM student WHERE dept_name = 'Comp. Sci.';
```

## 2. Count how many instructors there are
```sql
SELECT COUNT(*) FROM instructor;
```

## 3. Find names of instructors who earn more than all Biology instructors
```sql
SELECT name FROM instructor 
WHERE salary > ALL (SELECT salary FROM instructor WHERE dept_name = 'Biology');
```

## 4. Insert a student
```sql
INSERT INTO student (ID, name, dept_name, tot_cred) VALUES ('5000', 'Alice', 'Math', 30);
```

## 5. Delete instructors with salary < 40000
```sql
DELETE FROM instructor WHERE salary < 40000;
```

## 6. Increase all instructor salaries by 5%
```sql
UPDATE instructor SET salary = salary * 1.05;
```

## 7. Show all departments and average salaries
```sql
SELECT dept_name, AVG(salary) AS avg_salary 
FROM instructor 
GROUP BY dept_name;
```

## 8. List names of instructors who teach at least one course
```sql
SELECT DISTINCT name 
FROM instructor 
JOIN teaches ON instructor.ID = teaches.ID;
```

---

# ✅ Summary
This document explained every major SQL concept in detail including:
- Definitions and syntax
- Real SQL queries
- Comprehensive examples
- All query types (DDL, DML, Joins, Subqueries, Aggregates, Set Ops)
- Exercises with solutions

---

_Source: Silberschatz, Korth, Sudarshan — DB System Concepts 6th Ed._
