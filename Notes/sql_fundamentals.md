# SQL Fundamentals Guide

## 1. Table Operations

**DROP TABLE student**  
This command deletes the entire table student along with all of its data.  
*Note: The table structure and data are both removed. It cannot be recovered unless backed up.*

**DELETE FROM student**  
Deletes all rows from the student table but retains the table structure.  
You can still insert new data into it afterward.

**ALTER TABLE r ADD A D**  
Adds a new attribute A of domain D to the relation r.  
Example:  
`ALTER TABLE student ADD age INT;`  
All existing rows will have NULL in the new column.

**ALTER TABLE r DROP A**  
Removes the attribute A from table r.  
Example:  
`ALTER TABLE student DROP COLUMN age;`  
*Note: Not supported in some database systems.*

## 2. SELECT Queries and Basic Operations

**SELECT name FROM instructor**  
Retrieves all values in the name column of the instructor table.

**SELECT DISTINCT dept_name FROM instructor**  
Retrieves a list of unique department names from the instructor table.

**SELECT ALL dept_name FROM instructor**  
Retrieves all department names, including duplicates.  
*Note: ALL is default behavior; usually not necessary to specify.*

**SELECT * FROM instructor**  
Returns all columns and all rows from the instructor table.

**SELECT ID, name, dept_name, salary / 12 FROM instructor**  
Returns all listed columns and additionally calculates monthly salary by dividing salary by 12.

## 3. WHERE Clause and Logical Operators

**SELECT name FROM instructor WHERE dept_name = 'Comp. Sci.' AND salary > 80000**  
Retrieves names of instructors from the Computer Science department who earn more than $80,000.

SQL supports logical operators: AND, OR, NOT  
It also supports comparison operators: <, <=, >, >=, =, <> (not equal)

You can compare strings, dates, and numbers using these operators.

## 4. FROM Clause and Cartesian Product

**SELECT * FROM instructor, teaches**  
Produces a Cartesian product (i.e., every combination) of rows from instructor and teaches.

Typically used in conjunction with a WHERE clause to join related rows meaningfully.

## 5. JOINs and Natural JOINs

**SELECT name, course_id FROM instructor, teaches WHERE instructor.ID = teaches.ID**  
Retrieves instructor names and the courses they taught by joining the two tables on ID.

**SELECT * FROM instructor NATURAL JOIN teaches**  
Performs a natural join, automatically joining on columns with the same name.

⚠️ *Caution: Natural joins can cause unintended results if unrelated columns have matching names.*

## 6. Aliases (Correlation Names)

You can rename tables using AS (optional in most systems):  
`SELECT * FROM instructor AS I, department AS D WHERE I.dept_name = D.dept_name;`

Useful when the same table is used more than once (self-joins), or to shorten table names.

Example of self-join using alias:  
`SELECT T.name FROM instructor T, instructor S WHERE T.salary > S.salary AND S.dept_name = 'Comp. Sci.';`

## 7. String Matching and Operations

**LIKE** operator is used for pattern matching:

- **%** matches any number of characters
- **_** matches a single character

Example:  
`SELECT name FROM instructor WHERE name LIKE '%dar%';` → matches any name containing "dar"

Match literal % symbol:  
`LIKE '100\\%%' ESCAPE '\\'`

SQL supports:
- Concatenation: `name || ' Dept'`
- Case conversion: `UPPER(name)`, `LOWER(name)`
- String functions: `LENGTH(name)`, `SUBSTRING(name FROM 1 FOR 3)`

## 8. Ordering Results

**SELECT name FROM instructor ORDER BY name ASC;**  
Lists instructor names in ascending alphabetical order.

**SELECT name FROM instructor ORDER BY dept_name, name;**  
Sorts first by department name, then by instructor name within each department.

Use DESC for descending order:  
`ORDER BY salary DESC`

## 9. BETWEEN Operator and Tuple Comparison

**SELECT name FROM instructor WHERE salary BETWEEN 90000 AND 100000;**  
Returns instructors earning within the range.

**Tuple Comparison:**  
You can compare a pair of values like:  
`WHERE (instructor.ID, dept_name) = (teaches.ID, 'Biology')`

## 10. Set Operations

SQL supports three primary set operations between query results:

**UNION:** Combines results and removes duplicates.

**INTERSECT:** Returns only common rows between results.

**EXCEPT (or MINUS):** Returns rows from the first query that are not in the second.

Examples:

Courses offered in Fall 2009 or Spring 2010:
```sql
(SELECT course_id FROM section WHERE semester = 'Fall' AND year = 2009)
UNION
(SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010)
```

Courses offered in Fall 2009 but not Spring 2010:
```sql
(SELECT course_id FROM section WHERE semester = 'Fall' AND year = 2009)
EXCEPT
(SELECT course_id FROM section WHERE semester = 'Spring' AND year = 2010)
```

**Multiset Variants:**
- UNION ALL: Keeps duplicates.
- INTERSECT ALL and EXCEPT ALL: Not supported in all DBMSs.

## 11. NULL Values and Three-Valued Logic

NULL represents unknown or missing values.

Any operation with NULL returns NULL.  
Example: 5 + NULL → NULL

Use IS NULL or IS NOT NULL to check for null values:
```sql
SELECT name FROM instructor WHERE salary IS NULL;
```

Comparisons involving NULL result in UNKNOWN, not TRUE or FALSE.

Three-valued logic:
- TRUE, FALSE, and UNKNOWN
- Used in WHERE, AND, OR, NOT evaluations

## 12. Aggregate Functions

SQL provides five aggregate functions:
- AVG()
- MIN()
- MAX()
- SUM()
- COUNT()

Examples:

Average salary in Comp. Sci.:
```sql
SELECT AVG(salary) FROM instructor WHERE dept_name = 'Comp. Sci.';
```

Total unique instructors in Spring 2010:
```sql
SELECT COUNT(DISTINCT ID) FROM teaches WHERE semester = 'Spring' AND year = 2010;
```

Number of tuples in a relation:
```sql
SELECT COUNT(*) FROM course;
```

## 13. GROUP BY and HAVING

GROUP BY groups rows for aggregation.

Only grouped columns can appear in SELECT unless aggregated.

Example:

Average salary per department:
```sql
SELECT dept_name, AVG(salary) AS avg_salary
FROM instructor
GROUP BY dept_name;
```

Count instructors teaching in Spring 2010:
```sql
SELECT dept_name, COUNT(DISTINCT ID) AS instr_count
FROM instructor NATURAL JOIN teaches
WHERE semester = 'Spring' AND year = 2010
GROUP BY dept_name;
```

HAVING clause filters groups after aggregation:
```sql
SELECT dept_name
FROM instructor
GROUP BY dept_name
HAVING AVG(salary) > 42000;
```

## 14. Nested Subqueries and Set Membership

IN / NOT IN: Check for membership in subquery result.
```sql
SELECT name FROM instructor
WHERE salary > ALL (SELECT salary FROM instructor WHERE dept_name = 'Biology');
```

EXISTS: Checks if subquery returns any row.
```sql
SELECT course_id FROM section S
WHERE semester = 'Fall' AND year = 2009 AND
      EXISTS (
        SELECT * FROM section T
        WHERE semester = 'Spring' AND year = 2010 AND S.course_id = T.course_id
      );
```

## 15. Correlated Subqueries

A subquery that references a table from the outer query.

Example: Find students who took all courses offered by Biology:
```sql
SELECT DISTINCT S.ID, S.name
FROM student S
WHERE NOT EXISTS (
  (SELECT course_id FROM course WHERE dept_name = 'Biology')
  EXCEPT
  (SELECT T.course_id FROM takes T WHERE T.ID = S.ID)
);
```

## 16. Subqueries in FROM Clause

You can use subqueries as virtual tables:
```sql
SELECT dept_name, avg_salary
FROM (
  SELECT dept_name, AVG(salary) AS avg_salary
  FROM instructor
  GROUP BY dept_name
) AS dept_avg
WHERE avg_salary > 42000;
```

## 17. WITH Clause (Common Table Expressions - CTE)

Defines a temporary result that can be referenced multiple times.

Example: Departments with max budget:
```sql
WITH max_budget(value) AS (
  SELECT MAX(budget) FROM department
)
SELECT dept_name FROM department, max_budget
WHERE department.budget = max_budget.value;
```

## 18. Scalar Subqueries

Return a single value and can appear anywhere an expression is allowed.

Example:

Departments with instructor count:
```sql
SELECT dept_name,
       (SELECT COUNT(*) FROM instructor I WHERE I.dept_name = D.dept_name)
FROM department D;
```

## 19. Data Modification (INSERT, DELETE, UPDATE)

DELETE:
```sql
DELETE FROM instructor WHERE dept_name = 'Finance';
DELETE FROM instructor WHERE salary BETWEEN 13000 AND 15000;
```

INSERT:
```sql
INSERT INTO student VALUES ('3003', 'Green', 'Finance', NULL);
INSERT INTO instructor
SELECT ID, name, dept_name, 18000
FROM student
WHERE dept_name = 'Music' AND tot_cred > 144;
```

UPDATE:
```sql
UPDATE instructor SET salary = salary * 1.05;
UPDATE instructor
SET salary = salary * 1.05
WHERE salary < (SELECT AVG(salary) FROM instructor);
```

CASE-based conditional UPDATE:
```sql
UPDATE instructor
SET salary = CASE
  WHEN salary <= 100000 THEN salary * 1.05
  ELSE salary * 1.03
END;
```

## Practice Exercises

### 🧱 TABLE OPERATIONS
1. Create a table `books` with columns: id, title, author, price, category.
```sql
CREATE TABLE books (
    id INT PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255),
    price DECIMAL(10, 2),
    category VARCHAR(100)
);
```

2. Add a column `publication_year` to the `books` table.
```sql
ALTER TABLE books
ADD publication_year INT;
```

3. Drop the `category` column from the `books` table.
```sql
ALTER TABLE books
DROP COLUMN category;
```

4. Delete all rows from the `books` table without dropping it.
```sql
DELETE FROM books;
```

### 📄 SELECT, WHERE, AND EXPRESSIONS
5. List the names and departments of all instructors.
```sql
SELECT name, dept_name
FROM instructor;
```

6. Find all instructors in the 'Comp. Sci.' department earning more than $80,000.
```sql
SELECT name, salary
FROM instructor
WHERE dept_name = 'Comp. Sci.' AND salary > 80000;
```

7. Show all columns and compute monthly salary as salary / 12.
```sql
SELECT *, salary / 12 AS monthly_salary
FROM instructor;
```

8. List all departments in the instructor table without duplicates.
```sql
SELECT DISTINCT dept_name
FROM instructor;
```

### 🔁 JOINS AND CARTESIAN PRODUCTS
10. List instructors and the courses they taught, using a join.
```sql
SELECT instructor.name, course.title
FROM instructor
JOIN teaches ON instructor.ID = teaches.ID
JOIN course ON teaches.course_id = course.course_id;
```

11. Find titles of all courses taught by instructors in 'Comp. Sci.'
```sql
SELECT course.title
FROM course
JOIN teaches ON course.course_id = teaches.course_id
JOIN instructor ON teaches.ID = instructor.ID
WHERE instructor.dept_name = 'Comp. Sci.';
```

### 📑 SORTING AND FILTERING
18. List instructors ordered by salary descending.
```sql
SELECT name, salary
FROM instructor
ORDER BY salary DESC;
```

19. Find instructors with salary between 90,000 and 100,000.
```sql
SELECT name, salary
FROM instructor
WHERE salary BETWEEN 90000 AND 100000;
```

### 🧮 AGGREGATES AND GROUPING
20. Find the average salary of all instructors.
```sql
SELECT AVG(salary) AS average_salary
FROM instructor;
```

22. Find average salary for each department.
```sql
SELECT dept_name, AVG(salary) AS average_salary
FROM instructor
GROUP BY dept_name;
```

23. Show departments with average salary > 42,000.
```sql
SELECT dept_name, AVG(salary) AS average_salary
FROM instructor
GROUP BY dept_name
HAVING AVG(salary) > 42000;
```

## Advanced SQL Problems

Here are some complex SQL problems that combine multiple concepts for real-world scenarios:

### 1. Top Customers with Purchase Details
Find the top 3 customers who spent the most money in the past year, along with the products they purchased and the total amount spent.

```sql
SELECT c.customer_id, c.name AS customer_name, 
       p.product_id, p.name AS product_name, 
       SUM(s.total_amount) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN products p ON s.product_id = p.product_id
WHERE s.sale_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY c.customer_id, p.product_id
ORDER BY total_spent DESC
LIMIT 3;
```

### 2. Product Sales Statistics
Find the average, minimum, and maximum sale amounts per product for the year 2023.

```sql
SELECT p.product_id, p.name AS product_name, 
       AVG(s.total_amount) AS average_sales, 
       MIN(s.total_amount) AS minimum_sales, 
       MAX(s.total_amount) AS maximum_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE s.sale_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY p.product_id;
```

### 3. Customers Who Purchased All Electronics
Find customers who have purchased all products in the 'Electronics' category.

```sql
SELECT DISTINCT s.customer_id
FROM sales s
JOIN products p ON s.product_id = p.product_id
WHERE p.category = 'Electronics'
GROUP BY s.customer_id
HAVING COUNT(DISTINCT p.product_id) = 
       (SELECT COUNT(*) FROM products WHERE category = 'Electronics');
```

### 4. Best-Selling Products
Find the products that were sold the most in terms of quantity and total sales amount.

```sql
SELECT p.product_id, p.name AS product_name, 
       COUNT(s.sale_id) AS quantity_sold, 
       SUM(s.total_amount) AS total_sales
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_id
ORDER BY quantity_sold DESC, total_sales DESC
LIMIT 1;
```

### 5. Quarterly Top Products
List the top 5 products with the highest sales for each quarter of 2023.

```sql
WITH quarterly_sales AS (
    SELECT p.product_id, p.name AS product_name, 
           EXTRACT(QUARTER FROM s.sale_date) AS quarter, 
           SUM(s.total_amount) AS total_sales
    FROM sales s
    JOIN products p ON s.product_id = p.product_id
    WHERE s.sale_date BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY p.product_id, quarter
)
SELECT product_id, product_name, quarter, total_sales
FROM (
    SELECT product_id, product_name, quarter, total_sales,
           RANK() OVER (PARTITION BY quarter 
                        ORDER BY total_sales DESC) AS rank
    FROM quarterly_sales
) ranked
WHERE rank <= 5
ORDER BY quarter, rank;
```

### 6. Department with Highest Total Salary
Find the department with the highest total salary and list the employees in that department.

```sql
WITH department_salary AS (
    SELECT department_id, SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
),
max_salary_department AS (
    SELECT department_id
    FROM department_salary
    WHERE total_salary = (SELECT MAX(total_salary) FROM department_salary)
)
SELECT e.name, e.department_id, e.salary
FROM employees e
JOIN max_salary_department msd ON e.department_id = msd.department_id
ORDER BY e.salary DESC;
```

### 7. Above-Average Earners Excluding Extremes
Find all employees who earn more than the average salary of their department, excluding the highest and lowest salaries.

```sql
WITH department_avg_salary AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.name, e.salary, e.department_id
FROM employees e
JOIN department_avg_salary das ON e.department_id = das.department_id
WHERE e.salary > das.avg_salary
AND e.salary NOT IN (
    SELECT MAX(salary) FROM employees 
    WHERE department_id = e.department_id
)
AND e.salary NOT IN (
    SELECT MIN(salary) FROM employees 
    WHERE department_id = e.department_id
);
```

### 8. Product Lifecycle Analysis
For each product, find the first and last sale dates, and calculate the number of days it took for the product to sell from the first sale to the last sale.

```sql
SELECT p.product_id, p.name AS product_name,
       MIN(s.sale_date) AS first_sale_date,
       MAX(s.sale_date) AS last_sale_date,
       DATEDIFF(MAX(s.sale_date), MIN(s.sale_date)) AS days_to_sell
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_id;
```

### 9. Multi-Category Customers
Find all customers who have made purchases in more than 3 different product categories.

```sql
SELECT s.customer_id
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY s.customer_id
HAVING COUNT(DISTINCT p.category) > 3;
```

### 10. Department Salary Analysis
Find the employees who have the highest salary in each department, and also show the department's average salary.

```sql
WITH department_max_salary AS (
    SELECT department_id, MAX(salary) AS max_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.name, e.salary, e.department_id, das.avg_salary
FROM employees e
JOIN department_max_salary dms ON e.department_id = dms.department_id
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) das ON e.department_id = das.department_id
WHERE e.salary = dms.max_salary
ORDER BY e.department_id;
```
