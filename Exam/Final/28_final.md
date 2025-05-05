# Database Management Systems Exam Solutions

## University of Dhaka
### Department of Computer Science and Engineering
### 2nd Year 2nd Semester Final Examination, 2023
### CSE-2201: Database Management Systems-I (3 Credits)

---

## Page 1 (Question 1)

### Question 1: Consider the following insurance database, where the primary keys are underlined.

- person (driver_id, name, address)
- car (license_plate, model, year)
- accident (report_number, year, location)
- owns (driver_id, license_plate)
- participated (report_number, license_plate, driver_id, damage_amount)

#### (a) Identify the foreign keys for the above mentioned database. [1]

**Answer:**
The foreign keys in this database are:
- In the `owns` table:
  - `driver_id` references `person(driver_id)`
  - `license_plate` references `car(license_plate)`
- In the `participated` table:
  - `report_number` references `accident(report_number)`
  - `license_plate` references `car(license_plate)`
  - `driver_id` references `person(driver_id)`

#### (b) Write SQL and Relational Algebra expressions for the following queries: [9]

##### i. Find the total number of people who owned cars that were involved in accidents in 2017.

**SQL:**
```sql
SELECT COUNT(DISTINCT o.driver_id)
FROM owns o
JOIN participated p ON o.license_plate = p.license_plate
JOIN accident a ON p.report_number = a.report_number
WHERE a.year = 2017;
```

**Relational Algebra:**
```
π_driver_id(σ_year=2017(owns ⋈ participated ⋈ accident)) |COUNT|
```

##### ii. Update the damage amount for the car with license plate "AABB2000" in the accident with report number "AR2197" to TK. 3000.

**SQL:**
```sql
UPDATE participated
SET damage_amount = 3000
WHERE report_number = 'AR2197' AND license_plate = 'AABB2000';
```

**Relational Algebra:**
This is an update operation, which can be represented as:
```
participated ← participated - σ_report_number='AR2197' ∧ license_plate='AABB2000'(participated) ∪ {tuples with updated damage_amount=3000}
```

##### iii. Delete all year-2010 cars belonging to the person whose ID is "12345".

**SQL:**
```sql
DELETE FROM car
WHERE license_plate IN (
    SELECT c.license_plate
    FROM car c
    JOIN owns o ON c.license_plate = o.license_plate
    WHERE c.year = 2010 AND o.driver_id = '12345'
);
```

**Relational Algebra:**
```
car ← car - π_license_plate,model,year(σ_year=2010 ∧ driver_id='12345'(car ⋈ owns))
```

#### (c) Draw the schema diagram for the insurance database. [4]

**Answer:**
The schema diagram would include:
- Entities: person, car, accident
- Relationships: owns (between person and car), participated (between person, car, and accident)
- Primary keys and foreign keys as indicated
- Cardinality shown with appropriate notation (one-to-many relationships)

## Page 1 (Question 2)

### Question 2:

#### (a) What are the reasons behind accessing SQL from general purpose languages such as C, Java or Python? [2]

**Answer:**
The main reasons for accessing SQL from general-purpose programming languages:

1. **Application Integration**: SQL databases need to be integrated with applications written in languages like C, Java, or Python to create complete software systems.

2. **Enhanced Functionality**: General-purpose languages offer features that SQL lacks (complex control structures, rich user interfaces, network capabilities).

3. **Data Processing**: Programming languages can process retrieved data in ways that would be cumbersome in SQL alone.

4. **Transaction Management**: Applications need to control transaction boundaries in a programmatic way.

5. **Dynamic Query Generation**: Applications often need to build SQL queries dynamically based on user input or application state.

6. **Persistence Layer**: Object-Relational Mapping (ORM) frameworks in these languages allow developers to work with database entities as objects.

#### (b) List the differences between embedded and dynamic SQL. Define trigger with an example. [5]

**Answer:**

**Differences between Embedded SQL and Dynamic SQL:**

| Embedded SQL | Dynamic SQL |
|-------------|-------------|
| SQL statements are directly embedded in the host language code | SQL statements are constructed at runtime |
| Statements are precompiled and syntax-checked at compile time | Statements are parsed and validated at runtime |
| Cannot handle variable queries determined at runtime | Can handle variable queries constructed during execution |
| Better performance due to precompilation | May have lower performance due to runtime compilation |
| Limited flexibility | Higher flexibility as queries can be built dynamically |
| Used for static, predetermined operations | Used for ad-hoc queries or when query structure is not known in advance |

**Trigger Definition:**
A trigger is a stored procedure that automatically executes when a specified event (INSERT, UPDATE, DELETE) occurs on a particular table in a database. Triggers can be used to maintain data integrity, audit changes, or implement business rules.

**Example of a Trigger:**
```sql
CREATE TRIGGER update_total_income
AFTER INSERT ON MovieStar
FOR EACH ROW
BEGIN
    UPDATE Movies
    SET totalIncome = totalIncome + 1000000
    WHERE movieTitle = NEW.movieTitle;
END;
```
This trigger automatically updates the `totalIncome` of a movie by adding 1,000,000 whenever a new star is added to that movie in the MovieStar table.

#### (c) Suppose a user creates a new relation r₁ with a foreign key referencing another relation r₂. What authorization privilege does the user need on r₂? Why should this not simply be allowed without any such authorization? [3]

**Answer:**
The user needs the REFERENCES privilege on relation r₂ (or the specific columns of r₂ being referenced) to create a foreign key constraint referencing r₂.

This restriction is necessary because:

1. **Data Dependencies**: Creating a foreign key creates a dependency between tables. Without proper authorization, users could create unwanted dependencies in the database schema.

2. **Security and Access Control**: Foreign keys implicitly allow a form of access to the referenced table. Without the REFERENCES privilege, users could gain information about the existence of certain values in tables they might not otherwise have access to.

3. **Impact on Operations**: Foreign keys restrict operations on the referenced table (e.g., preventing deletion of referenced rows). The user of r₂ should have control over who can impose such restrictions on their table.

#### (d) Consider a view v whose definition references only relation r: [4]

##### i. If a user is granted select authorization on v, does that user need to have select authorization on r as well? Why or why not?

**Answer:**
No, the user does not need to have select authorization directly on relation r.

Reasons:
- Views provide a mechanism for controlling access to the underlying data
- The creator of the view (who must have select privileges on r) can grant others access to the view without giving them direct access to r
- This is a key security feature of views, allowing data access through a controlled interface
- The database system will execute the view query using the privileges of the view's creator (privilege escalation), not the privileges of the user querying the view

##### ii. If a user is granted update authorization on v, does that user need to have update authorization on r as well? Why or why not?

**Answer:**
No, the user does not need to have direct update authorization on relation r, but there are limitations.

Reasons:
- Similar to select privilege, update operations on views are executed with the privileges of the view definer
- However, there are practical limitations on which views can be updated (e.g., views involving joins may not be updatable)
- The database system maps the updates on the view to updates on the underlying relation r
- This allows administrators to provide controlled update capabilities without granting direct update access to base tables

##### iii. Give an example of an insert operation on a view v to add a tuple t that is not visible in the result of "select * from v". Explain your answer.

**Answer:**
Consider this view definition:
```sql
CREATE VIEW HighValueAccidents AS
SELECT report_number, license_plate, driver_id, damage_amount
FROM participated
WHERE damage_amount > 5000;
```

If we insert:
```sql
INSERT INTO HighValueAccidents VALUES ('AR1234', 'XYZ789', '56789', 2000);
```

This tuple will be inserted into the underlying `participated` table, but since the damage_amount (2000) is less than 5000, it won't appear when querying the view with "SELECT * FROM HighValueAccidents".

This demonstrates how inserting into a view doesn't guarantee visibility in that view if the tuple doesn't meet the view's selection criteria.

## Page 1 (Question 3)

### Question 3:

#### (a) Consider the following arbitrary relation below and find the Super Keys, Candidate Keys and Primary Keys. [5]

| A | B | C | D |
|---|---|---|---|
| a1 | b1 | c1 | d1 |
| a2 | b1 | c2 | d2 |
| a2 | b2 | c2 | d2 |
| a3 | b3 | c2 | d4 |

**Answer:**

First, I'll analyze the relation to determine which attributes or combinations can uniquely identify tuples:

- A alone: Not a key (a2 appears twice)
- B alone: Not a key (b1 appears twice)
- C alone: Not a key (c2 appears three times)
- D alone: Not a key (d2 appears twice)

For combinations:
- {A,B}: Is a key (no duplicate pairs)
- {A,C}: Not a key (a2,c2 appears twice)
- {A,D}: Not a key (a2,d2 appears twice)
- {B,C}: Not a key (b1,c2 appears twice)
- {B,D}: Not a key (b1,d2 appears twice)
- {C,D}: Not a key (c2,d2 appears twice)

For three attributes:
- {A,B,C}, {A,B,D}, {A,C,D}, {B,C,D}: All are keys

For all attributes:
- {A,B,C,D}: Is a key

Therefore:
- **Super Keys**: {A,B}, {A,B,C}, {A,B,D}, {A,C,D}, {B,C,D}, {A,B,C,D}
- **Candidate Keys**: {A,B} (minimal super key)
- **Primary Key**: {A,B} (chosen from candidate keys)

#### (b) Why should we be cautious while using natural join instead of Cartesian product? [2]

**Answer:**
We should be cautious while using natural join instead of Cartesian product for the following reasons:

1. **Hidden Join Conditions**: Natural joins automatically join tables on columns with the same name, which might lead to unintended joins if column names coincidentally match but don't have a logical relationship.

2. **Schema Changes**: If the schema changes and new columns with matching names are added, the natural join behavior will change without explicit updates to the query.

3. **Readability and Maintainability**: Natural joins don't explicitly state the join conditions, making queries less self-documenting and potentially harder to maintain.

4. **Column Elimination**: Natural joins eliminate duplicate columns, which might lead to unexpected result schemas if you're not aware of the matching columns.

5. **Portability Issues**: Implementation of natural joins can vary slightly between database systems, potentially causing portability problems.

In contrast, explicit joins (with JOIN...ON) or Cartesian products with WHERE clauses make the join conditions explicit and clear.

#### (c) Among the fundamental operations that are used in Relational Algebra, find unary and binary operations. Explain with examples. [4]

**Answer:**

**Unary Operations** in Relational Algebra operate on a single relation:

1. **Selection (σ)**: Filters rows based on a condition.
   - Example: σ_year>2000(Movies)
   - This selects all movies released after the year 2000.

2. **Projection (π)**: Selects specific columns from a relation.
   - Example: π_movieTitle,releaseYear(Movies)
   - This retrieves only the movie title and release year columns.

3. **Rename (ρ)**: Renames a relation or its attributes.
   - Example: ρ_Film(movieTitle,year)←Movies(movieTitle,releaseYear)
   - This renames the Movies relation to Film and the releaseYear attribute to year.

**Binary Operations** in Relational Algebra operate on two relations:

1. **Union (∪)**: Combines all tuples from two compatible relations.
   - Example: ActionMovies ∪ ComedyMovies
   - This combines all action and comedy movies into one result set.

2. **Intersection (∩)**: Returns tuples common to both relations.
   - Example: ActionMovies ∩ ComedyMovies
   - This returns movies that are both action and comedy.

3. **Difference (-)**: Returns tuples in the first relation but not in the second.
   - Example: AllMovies - AnimationMovies
   - This returns all movies except animation movies.

4. **Cartesian Product (×)**: Creates all possible tuple combinations.
   - Example: Directors × Movies
   - This creates pairs of all directors with all movies.

5. **Join (⋈)**: Combines related tuples from two relations.
   - Example: Movies ⋈ Producers
   - This joins movies with their producers based on matching attributes.

6. **Division (÷)**: Returns values from one relation that match all values in another relation.
   - Example: Actors ÷ GenreExperts
   - This could find actors who have played in all genres that the experts specialize in.

#### (d) What aggregate functions work on string data? Give an example of scalar subquery. [1+2]

**Answer:**

**Aggregate Functions on String Data:**

1. **COUNT()**: Counts the number of string values (or rows).
2. **MAX()**: Returns the lexicographically maximum string value.
3. **MIN()**: Returns the lexicographically minimum string value.
4. **GROUP_CONCAT()** (in MySQL) or **STRING_AGG()** (in SQL Server/PostgreSQL): Concatenates strings from multiple rows.
5. **LISTAGG()** (in Oracle): Similar to GROUP_CONCAT, concatenates strings.

**Example of a Scalar Subquery:**

```sql
SELECT movieTitle, releaseYear,
       (SELECT AVG(netWorth) 
        FROM Producers 
        WHERE Producers.producerName = Movies.producerName) AS AvgProducerNetWorth
FROM Movies
WHERE releaseYear > 2020;
```

This query retrieves movie titles and release years for movies released after 2020, along with the average net worth of each movie's producer. The scalar subquery returns a single value (the average net worth) for each row in the outer query.

## Page 1 (Question 4)

### Question 4: Consider the following schemas.

- Movies(movieTitle, releaseYear, length, genre, studioName, producerName, totalIncome)
- Stars(movieTitle, releaseYear, starName)
- MovieStar(starName, address, gender, dateOfBirth)
- Producers(producerName, address, netWorth)

## Page 2

### Now, write SQL queries and Relational Algebra Expression for the following questions.

#### (a) Find all the animation movies released in 2023 and 2024 by Marvel. [2]

**SQL:**
```sql
SELECT *
FROM Movies
WHERE genre = 'animation' 
  AND releaseYear IN (2023, 2024)
  AND studioName = 'Marvel';
```

**Relational Algebra:**
```
σ_genre='animation' ∧ (releaseYear=2023 ∨ releaseYear=2024) ∧ studioName='Marvel'(Movies)
```

#### (b) Find all the producers who have produced any action movies acted by Nicolas Cage. Show the total length of all the movies produced by the producer. [3]

**SQL:**
```sql
SELECT p.producerName, SUM(m.length) AS totalLength
FROM Producers p
JOIN Movies m ON p.producerName = m.producerName
JOIN Stars s ON m.movieTitle = s.movieTitle AND m.releaseYear = s.releaseYear
JOIN MovieStar ms ON s.starName = ms.starName
WHERE m.genre = 'action' AND ms.starName = 'Nicolas Cage'
GROUP BY p.producerName;
```

**Relational Algebra:**
```
γ_producerName, SUM(length)->totalLength(
  σ_genre='action' ∧ starName='Nicolas Cage'(
    Movies ⋈ Stars ⋈ MovieStar
  )
)
```

#### (c) List the number of movies produced by Stan Lee with the total number of different movie stars in those movies. [3]

**SQL:**
```sql
SELECT COUNT(DISTINCT m.movieTitle) AS movieCount,
       COUNT(DISTINCT s.starName) AS starCount
FROM Movies m
JOIN Stars s ON m.movieTitle = s.movieTitle AND m.releaseYear = s.releaseYear
WHERE m.producerName = 'Stan Lee';
```

**Relational Algebra:**
```
γ_COUNT(DISTINCT movieTitle)->movieCount, COUNT(DISTINCT starName)->starCount(
  σ_producerName='Stan Lee'(Movies ⋈ Stars)
)
```

#### (d) Make a statistical report with the number of movies, different female stars and different male stars for each year. [3]

**SQL:**
```sql
SELECT m.releaseYear,
       COUNT(DISTINCT m.movieTitle) AS movieCount,
       COUNT(DISTINCT CASE WHEN ms.gender = 'Female' THEN s.starName END) AS femaleStarCount,
       COUNT(DISTINCT CASE WHEN ms.gender = 'Male' THEN s.starName END) AS maleStarCount
FROM Movies m
JOIN Stars s ON m.movieTitle = s.movieTitle AND m.releaseYear = s.releaseYear
JOIN MovieStar ms ON s.starName = ms.starName
GROUP BY m.releaseYear
ORDER BY m.releaseYear;
```

**Relational Algebra:**
This is complex to represent in pure relational algebra but would involve:
```
γ_releaseYear, COUNT(DISTINCT movieTitle)->movieCount, COUNT(DISTINCT σ_gender='Female'(starName))->femaleStarCount, COUNT(DISTINCT σ_gender='Male'(starName))->maleStarCount(
  Movies ⋈ Stars ⋈ MovieStar
)
```

#### (e) List the movies that contributed more than 30% of the income. Show the list according to the non-decreasing release year. In case of the same release year show them according to the increasing order of its title. [3]

**SQL:**
```sql
SELECT m.movieTitle, m.releaseYear, m.totalIncome
FROM Movies m
WHERE m.totalIncome > (SELECT SUM(totalIncome) * 0.3 FROM Movies)
ORDER BY m.releaseYear ASC, m.movieTitle ASC;
```

**Relational Algebra:**
Let total = π_SUM(totalIncome)*0.3(Movies)
```
σ_totalIncome>total(Movies) ORDER BY releaseYear ASC, movieTitle ASC
```

### Question 6:

#### (a) Draw the ER diagram for the database mentioned below identifying primary and foreign keys. [4]
- book(ISBN, title, year, price)
- author(author_id, name, address, url)
- warehouse(w_code, address, phone)
- written_by(author_id, ISBN)
- stock(w_code, ISBN, copy)

**Answer:**
The ER diagram would show:
- Entities: book, author, warehouse
- Relationships: written_by (M:N between author and book), stock (M:N between warehouse and book)
- Primary Keys: ISBN for book, author_id for author, w_code for warehouse
- Foreign Keys: author_id and ISBN in written_by, w_code and ISBN in stock

#### (b) Define derived, descriptive, and multi-valued attributed with examples. [3]

**Answer:**

**1. Derived Attributes:**
Derived attributes are attributes whose values can be calculated from other attributes.

Examples:
- Age (derived from Date of Birth and current date)
- Total Price (derived from Quantity × Unit Price)
- BMI (derived from Weight and Height)
- Average Grade (derived from individual grades)

**2. Descriptive Attributes:**
Descriptive attributes provide additional information about relationships between entities rather than about the entities themselves.

Examples:
- Date (in a Purchase relationship between Customer and Product)
- Role (in an Employment relationship between Person and Company)
- Grade (in an Enrollment relationship between Student and Course)

**3. Multi-valued Attributes:**
Multi-valued attributes can have multiple values for a single entity.

Examples:
- Phone Numbers (a person may have multiple phone numbers)
- Email Addresses (a person may have multiple email addresses)
- Skills (an employee may have multiple skills)
- Hobbies (a person may have multiple hobbies)

#### (c) What will be the schema representation of the following E-R diagram, where loan is a strong entity set, payment is a weak entity set and loan-payment is a descriptive relationship set? Explain the causes. [3]

**Answer:**

The schema representation would be:

```
Loan(loan-number, amount, ...)
Payment(payment-number, payment-date, payment-amount, loan-number)
Loan-Payment(loan-number, payment-number, ...)
```

Explanation:
1. `Loan` is represented as an independent table since it's a strong entity. The primary key is `loan-number`.

2. `Payment` is represented as a table with its own attributes plus the primary key of the `Loan` table (`loan-number`) because it's a weak entity dependent on `Loan`. The primary key is the combination of `payment-number` and `loan-number`.

3. `Loan-Payment` is represented as a relationship table containing the primary keys of both `Loan` and `Payment` tables, plus any descriptive attributes of the relationship. However, since `Payment` is already dependent on `Loan`, this separate relationship table might be redundant in a real implementation, and the descriptive attributes could be included in the `Payment` table.

The causes for this structure:
- Strong entities get their own tables with their own primary keys
- Weak entities get tables that include the primary key of their identifying strong entity
- Descriptive relationship sets typically become attributes in the weak entity table or a separate relationship table (depending on the cardinality)

#### (d) Explain mapping cardinalities and participation constraints in E-R model using appropriate figures. [4]

**Answer:**

**Mapping Cardinalities** in E-R model represent the number of entities to which another entity can be associated via a relationship.

1. **One-to-One (1:1)**: Each entity in set A is associated with at most one entity in set B, and vice versa.
   - Example: One person has one passport, and one passport belongs to one person.
   - Notation: Typically shown with "1" at both ends of the relationship line.

2. **One-to-Many (1:N)**: Each entity in set A can be associated with many entities in set B, but each entity in B is associated with at most one entity in A.
   - Example: One department has many employees, but each employee belongs to one department.
   - Notation: "1" at the A side and "N" (or a crow's foot) at the B side.

3. **Many-to-One (N:1)**: The inverse of one-to-many.
   - Example: Many students enroll in one course.
   - Notation: "N" at the A side and "1" at the B side.

4. **Many-to-Many (M:N)**: Entities in set A can be associated with any number of entities in set B, and vice versa.
   - Example: Students can enroll in multiple courses, and courses can have multiple students.
   - Notation: "M" at the A side and "N" at the B side (or crow's feet at both ends).

**Participation Constraints** specify whether the existence of an entity depends on its being related to another entity via the relationship.

1. **Total Participation (Double Line)**: Every entity in the set must participate in the relationship.
   - Example: Every employee must belong to a department.
   - Notation: Double line connecting the entity set to the relationship.

2. **Partial Participation (Single Line)**: Some entities in the set may not participate in the relationship.
   - Example: Not every person has a driver's license.
   - Notation: Single line connecting the entity set to the relationship.

[Note: In a complete solution, I would include figures showing these different cardinalities and participation constraints with appropriate ER diagram notation.]

### Question 7:

#### (a) Point out the features of a good relational database design? [2]

**Answer:**

Features of a good relational database design include:

1. **Minimal Redundancy**: Data is stored in only one place to avoid inconsistencies and reduce storage requirements.

2. **Data Integrity**: The database enforces integrity constraints (entity, domain, referential) to ensure accurate and valid data.

3. **Normalization**: The database is properly normalized (typically to 3NF or BCNF) to eliminate anomalies.

4. **Efficient Queries**: The design supports efficient execution of common queries.

5. **Scalability**: The design can accommodate growth in data volume and complexity.

6. **Flexibility**: The design can adapt to changing requirements with minimal restructuring.

7. **Security**: The design supports appropriate access controls and permissions.

8. **Documentation**: The design is well-documented with clear entity-relationship diagrams and data dictionaries.

9. **Meaningful Naming**: Tables and columns have clear, consistent, and meaningful names.

10. **Proper Key Definition**: Primary and foreign keys are properly defined to maintain relationships.

#### (b) Define functional dependency. What do you understand by item closure and closure of a set of functional dependencies? Explain with suitable example. [4]

**Answer:**

**Functional Dependency (FD)**: A functional dependency X → Y means that the values of attribute set Y are determined by the values of attribute set X. In other words, if two tuples have the same values for X, they must have the same values for Y.

**Attribute Closure (Item Closure)**: The attribute closure of a set of attributes X under a set of functional dependencies F, denoted as X⁺, is the set of all attributes that can be functionally determined from X using F. It's calculated by repeatedly adding attributes to the result set until no more can be added.

**Closure of a Set of Functional Dependencies (F⁺)**: The closure F⁺ of a set F of functional dependencies is the set of all functional dependencies that can be derived from F using Armstrong's axioms.

**Example:**
Consider a relation R(A, B, C, D, E, F) with functional dependencies F = {A → B, B → C, CD → E, D → F}.

1. **Attribute Closure Example**:
   - To find A⁺:
     - Start with A⁺ = {A}
     - Using A → B, add B: A⁺ = {A, B}
     - Using B → C, add C: A⁺ = {A, B, C}
     - No more attributes can be added, so A⁺ = {A, B, C}

2. **Functional Dependency Closure Example**:
   - F⁺ would include:
     - All original FDs in F
     - A → C (from transitivity of A → B and B → C)
     - AD → E (from augmentation of CD → E with A)
     - AD → F (from augmentation of D → F with A)
     - And many others derived using Armstrong's axioms

#### (c) Find the canonical cover (Fc) of the given set of functional dependencies (F). F = {A → CDE, B → EF, AC → F, E → C, DE → BFC} [4]

**Answer:**

To find the canonical cover (Fc), I'll follow these steps:
1. Split right-hand sides to get one attribute per FD
2. Remove redundant attributes on the left-hand sides
3. Remove redundant FDs

Step 1: Split right-hand sides
- A → C
- A → D
- A → E
- B → E
- B → F
- AC → F
- E → C
- DE → B
- DE → F
- DE → C

Step 2: Check and remove any redundant attributes on LHS
- In AC → F, check if A → F or C → F. We can't derive either, so AC → F remains.
- In DE → B, check if D → B or E → B. We can't derive either, so DE → B remains.
- In DE → F, check if D → F or E → F. We can't derive either, so DE → F remains.
- In DE → C, we have E → C already, so DE → C can be simplified to E → C.

Step 3: Check and remove redundant FDs
- DE → C is redundant since we have E → C
- A → C is redundant because E → C and A → E (transitivity)
- DE → F is potentially redundant if we can derive it from other FDs

After these steps, the canonical cover would be:
Fc = {A → D, A → E, B → E, B → F, AC → F, E → C, DE → B}

Note: A more detailed analysis might further reduce this set, but this represents the main steps in finding the canonical cover.

#### (d) Let a prime attribute be one that appears in at least one candidate keys. Let α and β be sets of attributes such that α → β holds, but β → α does not hold. Let A be an attribute that is not in α, is not in β, and for which β → A holds. We say that A is transitively dependent on α if there are no nontrivial attributes X in R for which A is transitively dependent on a key for R. A relation schema R is in 3NF with respect to a set F of functional dependencies if there are no nontrivial attributes X in R for which X is transitively dependent on a key for R. Show that this new definition is equivalent to the original one. [4]

**Answer:**

# ✅ Equivalence of Original and New Definitions of 3NF

In relational database design, the **Third Normal Form (3NF)** can be defined in two ways:

---

### 📘 Original Definition of 3NF

A relation `R` is in **3NF** if, for every **nontrivial functional dependency** `X → A` in `R⁺`, **either**:

1. `X` is a **superkey**, or  
2. `A` is a **prime attribute** (i.e., part of some candidate key).

---

### 📗 New Definition of 3NF

A relation `R` is in **3NF** if **no nontrivial attribute A** is **transitively dependent** on a key.

A **transitive dependency** is defined as:

> A is transitively dependent on α if:  
> - α → β  
> - β → A  
> - β ↛ α  
> - and A ∉ α ∪ β

---

## ✅ Proof of Equivalence

We will prove **both directions**:

---

### 🔁 Part 1: Original ⇒ New

**Assume:** R satisfies the **original definition**.  
**Goal:** Show that it also satisfies the **new definition**.

**Contradiction Setup:** Suppose R violates the **new definition**.  
Then there exists a transitive dependency:  
- A key `K → β`,  
- `β → A`,  
- `β ↛ K`,  
- and `A ∉ K ∪ β`.

Now, consider `β → A`:

- `β` is **not a superkey** (`β ↛ K`)  
- `A` must be a **prime attribute** by the **original 3NF definition**.

But if `A` is a prime attribute, it must be in some **candidate key**.

Two possibilities:
1. `A ∈ K` → Contradicts `A ∉ K`
2. `A` is in another candidate key → Then `β` determines part of a key, which makes `β` a superkey → Contradiction (`β ↛ K`)

🚫 Therefore, contradiction arises — the assumption that R violates the new definition is **false**.  
✅ So, R must satisfy the **new definition**.

---

### 🔁 Part 2: New ⇒ Original

**Assume:** R satisfies the **new definition**.  
**Goal:** Show that it also satisfies the **original definition**.

**Contradiction Setup:** Suppose R violates the **original definition**.

Then there exists a **nontrivial FD**:  
- `X → A`,  
- `X` is **not a superkey**,  
- `A` is **not a prime attribute**.

Since `X` is not a superkey, a **key K** must exist such that:  
- `K → X`

Now:  
- `K → X`  
- `X → A`  
- Therefore: `K → A`

Also, since:
- `X ↛ K` (because `X` is not a superkey),  
- and `A ∉ X ∪ K`,  
→ this forms a **transitive dependency** of `A` on `K`.

But this **violates the new 3NF definition**, which we assumed is satisfied.

🚫 Contradiction!  
✅ So, R must satisfy the **original definition**.

---

## 🎉 Conclusion

The two definitions of **Third Normal Form (3NF)** are **logically equivalent**:

- If a relation satisfies the **original definition**, it satisfies the **new one**.
- If it satisfies the **new definition**, it satisfies the **original one**.
