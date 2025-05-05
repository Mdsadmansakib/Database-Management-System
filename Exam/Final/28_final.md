# Database Management System Exam Solutions
**University of Dhaka**  
**Department of Computer Science and Engineering**  
**2nd Year 2nd Semester Final Examination, 2023**  
**CSE-2203: Database Management System-I (3 Credits)**  
**Total Marks: 70**  
**Time: 3 Hours**

## Image 1 Questions

### Q1. Now solve SQL queries and Relational Algebra Expressions for the following questions.

**(a) Find all the animation movies released in 2023 and 2024 by Marvel.**
```sql
SELECT *
FROM movies
WHERE production_company = 'Marvel' 
  AND release_year IN (2023, 2024)
  AND genre = 'animation';
```

**(b) Find all the exclusive movies which have produced any action movies in the total number of different movie time in those movies.**
```sql
SELECT DISTINCT m1.production_company
FROM movies m1
WHERE EXISTS (
    SELECT *
    FROM movies m2
    WHERE m2.production_company = m1.production_company
    AND m2.genre = 'action'
)
GROUP BY m1.production_company
HAVING COUNT(DISTINCT m1.movie_time) > 0;
```

**(c) List the number of movies produced by Sony. List with the total number of different movie time in those movies, different formats, and different make stars for each year.**
```sql
SELECT release_year, 
       COUNT(*) AS total_movies,
       COUNT(DISTINCT movie_time) AS distinct_times,
       COUNT(DISTINCT format) AS distinct_formats,
       COUNT(DISTINCT star) AS distinct_stars
FROM movies
WHERE production_company = 'Sony'
GROUP BY release_year;
```

**(d) Make a statistical report with the number of movies, different formats, different make stars for each year.**
```sql
SELECT release_year,
       COUNT(*) AS total_movies,
       COUNT(DISTINCT format) AS distinct_formats,
       COUNT(DISTINCT star) AS distinct_stars
FROM movies
GROUP BY release_year;
```

**(e) For each movie, find the number showing the total number of the income. Show those for which the non-decreasing order is observed.**
```sql
SELECT movie_title, SUM(income) AS total_income
FROM movie_income
GROUP BY movie_title
ORDER BY total_income ASC;
```

**(f) Draw the ER diagram for the database mentioned below (entity primary and foreign key):**
- book(ISBN, title, year, price)
- author(author_id, name, address, url)
- written_by(author_id, ISBN)
- stock(stock_id, ISBN, copy)

ER Diagram would include:
- Entities: book, author, stock
- Relationship: written_by (many-to-many between author and book)
- Primary keys: ISBN for book, author_id for author, stock_id for stock
- Foreign keys: author_id and ISBN in written_by, ISBN in stock

### Q2. (a) Briefly defined, descriptive, and family-valued distributed with examples.

A descriptive, family-valued distributed database system has the following characteristics:

1. **Descriptive**: A database design approach where data is described with its entity and attributes, represented by a well-structured schema.

2. **Family-valued**: Refers to the organization of data in related groups or "families" where data is stored together based on relationship and access patterns.

3. **Distributed**: A database system where data is stored across multiple physical locations but can be accessed as if it were in a single location. This provides benefits like improved reliability, performance, and scalability.

Example: A multinational retail company might have a distributed database where customer data is stored in regional servers closest to each customer population, product information is replicated across all sites, and transaction data is partitioned geographically yet accessible through a unified interface.

### Q3. (a) What will be the schema representation of the following ER diagram, where there is a strong entity-set pointed out by the cases?

Based on the ER diagram shown in the image (which shows entities including loan, payment, borrower, and icon with various relationships between them), the schema representation would be:

```
loan(loan_id, amount, type, payment_schedule)
borrower(borrower_id, name)
payment(payment_id, payment_date, amount)
icon(icon_id, name)
loan_borrower(loan_id, borrower_id)  // Relationship table
loan_payment(loan_id, payment_id)    // Relationship table
borrower_icon(borrower_id, icon_id)  // Relationship table
```

### Q4. Explain mapping entities and participation constraints in ER model using appropriate figures.

Mapping entities and participation constraints in ER modeling:

1. **Entity Mapping**: Entities are mapped to tables in the relational model. Each entity becomes a table, and each attribute becomes a column.

2. **Participation Constraints**:
   - **Total Participation**: An entity must participate in a relationship (shown with a double line in ER diagrams). This is implemented using NOT NULL constraints in the relational schema.
   - **Partial Participation**: An entity may or may not participate in a relationship (shown with a single line). This allows NULL values in the relational schema.

3. **Cardinality Constraints**:
   - One-to-One: Foreign key in either table with a unique constraint
   - One-to-Many: Foreign key in the "many" side table
   - Many-to-Many: Requires a junction/associative table with foreign keys to both entities

The appropriate figures would show different relationship types with single/double lines indicating partial/total participation.

## Image 2 Questions

### Q1. Consider the following instance database, where the primary key are underlined.

**person(driver_id, name, address)**
**car(license_plate, model, year)**
**accident(report_id, date, location)**
**owns(driver_id, license_plate)**
**participated(driver_id, license_plate, report_id, damage_amount)**

**(a) Find all the total number of people who crash license plate "dhaka-da-dumage-amount".**
```sql
SELECT COUNT(DISTINCT p.driver_id)
FROM person p
JOIN participated part ON p.driver_id = part.driver_id
WHERE part.license_plate = 'dhaka-da-dumage-amount';
```

**(b) Write SQL and Relational Algebra expressions for the following queries:**

**i. Find the total number of people who owned license plate "AB-METU" in the accident with report number "1234".**
```sql
SELECT COUNT(DISTINCT o.driver_id)
FROM owns o
JOIN participated p ON o.driver_id = p.driver_id AND o.license_plate = p.license_plate
WHERE o.license_plate = 'AB-METU' AND p.report_id = '1234';
```

Relational Algebra:
```
π_driver_id(σ_license_plate='AB-METU' ∧ report_id='1234'(owns ⋈ participated))
```

**ii. Update the damage amount for the damage amount for the car with license plate "AJK2010" in the accident with report number "ID-12345".**
```sql
UPDATE participated
SET damage_amount = [new_value]
WHERE license_plate = 'AJK2010' AND report_id = 'ID-12345';
```

**iii. Delete all years 2010 cars belonging to a person whose name is "happerson".**
```sql
DELETE FROM car
WHERE license_plate IN (
    SELECT o.license_plate
    FROM owns o
    JOIN person p ON o.driver_id = p.driver_id
    WHERE p.name = 'happerson' AND car.year = 2010
);
```

### Q2.
**(a) What are the reasons behind accessing SQL from general purpose languages such as C, Java or Python?**

Reasons for accessing SQL from general-purpose languages:
1. Integration of database functionality with application logic
2. Dynamic SQL query generation based on user input or runtime conditions
3. Processing and manipulation of query results in application-specific ways
4. Transaction management across multiple database operations
5. Better error handling and exception management
6. Building scalable applications with connection pooling and resource management
7. Implementing business logic that requires both computational capabilities and data persistence

**(b) "Laz is difference between embedded SQL and dynamic SQL." Explain with examples.**

**Embedded SQL vs Dynamic SQL:**

Embedded SQL:
- SQL statements are hardcoded in the application at compile time
- Precompiler processes these statements before compilation
- Better performance due to precompilation
- Less flexible as queries cannot be modified at runtime

Example:
```c
EXEC SQL SELECT salary INTO :emp_salary
FROM employees
WHERE emp_id = :emp_id;
```

Dynamic SQL:
- SQL statements are generated or modified at runtime
- Provides flexibility to create queries based on conditions
- Can handle user input to construct queries
- May have performance overhead compared to embedded SQL

Example:
```c
sprintf(query, "SELECT salary FROM employees WHERE emp_id = %d", emp_id);
EXEC SQL PREPARE stmt FROM :query;
EXEC SQL EXECUTE stmt INTO :emp_salary;
```

### Q3.
**(a) Give an example of a query operation on a view where the user need to have select authorization on as well?**

Example:
```sql
-- First, create a view
CREATE VIEW high_salary_employees AS
SELECT emp_id, name, department, salary
FROM employees
WHERE salary > 100000;

-- Query that requires select authorization on the base table
SELECT name, department 
FROM high_salary_employees
WHERE department = 'Finance';
```

For this query to work, the user needs SELECT authorization on both the "high_salary_employees" view and the underlying "employees" table, especially if the database system doesn't implement view materialization.

**(b) Why should we be cautious while using material in Relational Algebra to find unary and binary operations? Explain with examples.**

When using material in Relational Algebra for unary and binary operations, caution is needed because:

1. Materialization can consume significant storage resources
2. Materialized results may become outdated as base tables change
3. The cost of maintaining materialized results might outweigh benefits
4. Binary operations like join and union can produce very large intermediate results

Example:
When computing a join between two large tables (Customer and Orders), materializing intermediate results could consume excessive memory. Instead, pipelined execution or careful ordering of operations might be more efficient.

### Q4. Consider the following arbitrary relationship set for the Super Keys, Candidate Keys and Primary Keys.

The image shows a table with columns A, B, C, and D, with various combinations labeled a1-a3, b1-b3, c1-c3, and d1-d4.

**(a) Super Keys:** Any combination of attributes that can uniquely identify a tuple in a relation.  
From the table shown: {A, B}, {A, C}, {A, D}, {A, B, C}, {A, B, D}, etc.

**(b) Candidate Keys:** Minimal super keys (no subset of it can be a super key).  
From the table: {A, B}, {A, C}

**(c) Primary Key:** The chosen candidate key that will be used as the main identifier.  
From the table: {A, B} would be a good choice

**(d) What suggested functions work as simple "keys" for keys? Give an example of scalar subquery.**

Functions that work as simple keys:
- Hash functions
- Concatenation functions
- Auto-increment/sequence generators

Example of a scalar subquery used as a key:
```sql
SELECT employee_id, name,
       (SELECT MAX(order_date) FROM orders WHERE orders.employee_id = employees.employee_id) AS latest_order_date
FROM employees;
```

### Q5. Consider the following schemas:
**MovieTitle(title, year, length, genre, studioName, producerName)**
**StarsIn(movieTitle, movieYear, starName)**
**MovieStar(name, address, gender, birthDate)**
**MovieExec(name, address, gender, cert#, netWorth)**
**Studio(name, address, presC#)**

**(a) Find the names of all female stars who have appeared in a movie with "Tom Cruise".**
```sql
SELECT DISTINCT m.name
FROM MovieStar m
JOIN StarsIn s1 ON m.name = s1.starName
WHERE m.gender = 'female'
AND EXISTS (
    SELECT *
    FROM StarsIn s2
    WHERE s2.starName = 'Tom Cruise'
    AND s2.movieTitle = s1.movieTitle
    AND s2.movieYear = s1.movieYear
);
```

**(b) What is the name of the producer of "Trading Places"?**
```sql
SELECT producerName
FROM MovieTitle
WHERE title = 'Trading Places';
```

**(c) Find all comedies that are used in Relational Algebra (give two examples).**

Relational Algebra expression to find all comedies:

```
σ_genre='comedy'(MovieTitle)
```

Two examples of comedies that could be found:
1. "Trading Places" (1983)
2. "The Hangover" (2009)

**(d) What suggested functions work as simple "data" Give an example of scalar subquery.**

Functions that work as simple data operations:
- Aggregate functions (SUM, AVG, COUNT)
- String functions (CONCAT, SUBSTRING)
- Date functions (DATEADD, DATEDIFF)

Example of a scalar subquery:
```sql
SELECT m.title, m.year,
       (SELECT COUNT(*) FROM StarsIn s WHERE s.movieTitle = m.title AND s.movieYear = m.year) AS star_count
FROM MovieTitle m
WHERE m.genre = 'comedy';
```

### Q6. Consider the following schemas:
**Movies(title, release_year, genre, producer_name, producer_birth)**
**Stars(name, gender, date_of_birth)**
**StarsIn(movie_title, release_year, star_name, role)**

**(a) Give an example of an insert operation on a table that would cause a foreign key constraint to be violated.**

Example of a violation:
```sql
-- This would violate a foreign key constraint if StarsIn references Movies
INSERT INTO StarsIn(movie_title, release_year, star_name, role)
VALUES ('Avatar 3', 2025, 'Sam Worthington', 'Jake Sully');
```

This violates the constraint if 'Avatar 3' with release_year 2025 does not exist in the Movies table.

**(b) Why should we be cautious while using material in Relational Algebra to find unary and binary operations? Explain with examples.**

When using materialization in Relational Algebra:
1. Storage overhead: Materializing intermediate results consumes memory/disk space
2. Maintenance: Materialized views need updates when base data changes
3. Query optimization: The optimizer might not choose the best execution plan with materialized views
4. Performance impact: For large datasets, materialization can be costly

Example:
```
R = σ_genre='Action'(Movies) // First operation materialized
S = π_title,release_year(R)  // Second operation on materialized result
```

If 'Movies' has millions of rows but only hundreds of action movies, materializing R is efficient. However, if most movies are action movies, materializing creates unnecessary overhead.

### Q7. Consider the following schemas:
**Movie(title, release_year, length, genre, studioName, producerName)**
**Star(star_name, address, gender, date_of_birth)**
**StarsIn(movie_title, movie_year, star_name)**

**(a) Convert the following arbitrary table for the Super Keys, Candidate Keys and Primary Keys:**

From the table shown in the image:

- **Super Keys:** {A, B, C}, {A, B, D}, {A, B, C, D}, etc. (Any combination of attributes that can uniquely identify a tuple)
- **Candidate Keys:** {A, B}, {B, C} (Minimal super keys)
- **Primary Key:** {A, B} (The chosen candidate key)

**(b) Explain why not?**

The question asks why we cannot use certain attribute combinations as keys:

We cannot use {A} alone as a key because it doesn't uniquely identify tuples by itself - multiple rows can have the same value for A. Similarly, {B} alone is not sufficient.

Using {A, B} is minimal and sufficient to uniquely identify each tuple in the relation. While {A, B, C} would also work as a super key, it's not minimal and therefore not a candidate key.

**(c) With examples:**

Example showing why {A} is not a candidate key:
```
A | B | C | D
-----------
1 | 2 | 3 | 4
1 | 3 | 5 | 6
```

Here, A=1 appears twice, so it cannot uniquely identify rows.

Example showing why {A, B} is a candidate key:
```
A | B | C | D
-----------
1 | 2 | 3 | 4
1 | 3 | 5 | 6
2 | 2 | 7 | 8
```

No two rows have the same combination of A and B values, making it a valid candidate key.

**(d) Consider the following schemas:**

I don't see additional schemas in the image beyond what's already been addressed.

### Q8. Constraints:
**(a) Explain briefly why we need constraints in database design.**

Constraints are essential in database design for:
1. **Data integrity:** Ensuring data meets defined rules and relationships
2. **Consistency:** Preventing contradictory or invalid data
3. **Domain constraints:** Limiting values to valid ranges or patterns
4. **Business rules enforcement:** Implementing organizational policies
5. **Error prevention:** Catching issues at the database level rather than application level
6. **Security:** Restricting data modifications to maintain data quality
7. **Referential integrity:** Ensuring related tables maintain proper relationships

**(b) Consider the following definitions for the foreign key relationship rule:**
1. **Restrict/No Action:** Prevents deletion/update if referenced records exist
2. **Cascade:** When a record is deleted/updated, related records are automatically deleted/updated
3. **Set Null:** When a record is deleted/updated, the foreign key in related records is set to NULL
4. **Set Default:** When a record is deleted/updated, the foreign key in related records is set to a default value

Example of ON DELETE CASCADE:
```sql
CREATE TABLE Orders (
    OrderID int PRIMARY KEY,
    CustomerID int,
    OrderDate date,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    ON DELETE CASCADE
);
```

When a customer is deleted, all their orders are automatically deleted.

**(c) What is the difference between referential integrity constraint and domain constraint?**

**Referential Integrity Constraint:**
- Ensures relationships between tables remain consistent
- Prevents foreign keys from referencing non-existent primary keys
- Maintains the consistency of relationships across tables
- Example: An order must reference an existing customer

**Domain Constraint:**
- Restricts the values that attributes can take
- Defines valid data types, ranges, formats, or sets of values
- Operates at the column level
- Example: Age must be a positive integer between 0 and 120

**(d) Consider the following schemas:**
**Movie(title, year, length, genre, studioName, producerName)**
**MovieStar(name, address, gender, birthDate)**
**StarsIn(movieTitle, movieYear, starName)**

**What suggested functions work as "simple keys" for keys? Give an example of scalar subquery.**

Functions that work as simple keys:
- Hash functions: MD5(), SHA1()
- Concatenation: CONCAT(title, year)
- Auto-increment/sequence generators

Example of a scalar subquery:
```sql
SELECT m.title, m.year,
       (SELECT COUNT(*) FROM StarsIn s 
        WHERE s.movieTitle = m.title AND s.movieYear = m.year) AS star_count
FROM Movie m
WHERE m.genre = 'Action';
```
