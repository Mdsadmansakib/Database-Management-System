# Introduction to Relational Model

## Key Concepts

### Basic Definition
- The relational model uses tables to represent data and relationships
- Each table has multiple columns with unique names
- Synonyms:
  - Relation = Table
  - Tuple = Row
  - Attribute = Column Header

### Characteristics
1. Primary data model for commercial data processing
2. Simplicity makes it programmer-friendly
3. Describes data at logical and view levels
4. Abstracts away low-level storage details

## Important Terminologies

### Domain
- Set of permitted values for an attribute
- Can be **Atomic** (indivisible)
  - Example: Set of integers (23, 45, 5, 78)
- Can be **Non-Atomic** (divisible)
  - Example: Set of phone numbers, employee IDs

### Null Values
- Represents unknown or non-existent value
- Causes difficulties in database operations
- Should be eliminated if possible

## Keys in Relational Model


# 🔑 Key Concepts in the Relational Model

Understanding keys is essential to relational databases, as they enforce data integrity, enable identification, and define relationships between tables.

---

## 1. 🧷 Superkey

### 📌 Definition:
A **superkey** is a set of one or more attributes that **uniquely identifies each tuple** in a relation.

### ✅ Properties:
- May include extra, unnecessary attributes.
- Any **superset** of a superkey is also a superkey.

### 🔍 Formal Definition:
Let `R` be the set of attributes in the relation schema `r`, and `K ⊆ R`.  
`K` is a superkey if:
> For all tuples `t₁` and `t₂` in `r`, if `t₁ ≠ t₂` then `t₁[K] ≠ t₂[K]`.

### 🧪 Examples:
- In `instructor(ID, name, dept_name, salary)`:
  - `{ID}` ✅
  - `{ID, name}` ✅ (superkey, not minimal)
  - `{name}` ❌ (names may not be unique)

- In `classroom(building, room_number, capacity)`:
  - `{building, room_number}` ✅

---

## 2. 🧷 Candidate Key

### 📌 Definition:
A **candidate key** is a **minimal superkey**. It uniquely identifies tuples, and removing any attribute would make it non-unique.

### ✅ Properties:
- No proper subset is a superkey.
- There may be **multiple** candidate keys.

### 🧪 Examples:
- In `instructor`:
  - `{ID}` ✅
  - `{name, dept_name}` ✅ (if combination is unique)
  - `{ID, name}` ❌ (not minimal)

- In `classroom`:
  - `{building, room_number}` ✅

---

## 3. 🏷️ Primary Key

### 📌 Definition:
A **primary key** is a candidate key selected by the designer to **uniquely identify tuples** in a table.

### ✅ Properties:
- Must be **unique** and **not null**.
- **Only one** primary key per table.
- Should be stable and rarely change.

### 🧪 Examples:
- `instructor(ID, ...)`: `{ID}` is the primary key ✅
- `classroom(building, room_number, ...)`: `{building, room_number}` ✅

### 📘 Note:
- **Primary Key ⊆ Candidate Key ⊆ Superkey**
- Typically **underlined** in schema definitions.
- Choose wisely (e.g., SSN, student ID, not names).

---

## 4. 🔗 Foreign Key

### 📌 Definition:
A **foreign key** is an attribute (or set) in one relation that **references the primary key** of another relation.

### ✅ Properties:
- Enforces **referential integrity**.
- Ensures the value exists in the referenced table.

### 🧪 Example:
- In `instructor(dept_name)`, referencing `department(dept_name)`:
```sql
FOREIGN KEY (dept_name) REFERENCES department(dept_name)
```

If `ta` is a tuple in `instructor`, and `tb` is a tuple in `department`,  
then:
> `ta.dept_name = tb.dept_name`

---

## 🧩 Summary Table

| Concept        | Description                                      | Example                             |
|----------------|--------------------------------------------------|-------------------------------------|
| **Superkey**   | Uniquely identifies tuples (may have extra attrs)| `{ID}`, `{ID, name}`                |
| **Candidate Key** | Minimal superkey                                 | `{ID}`, `{name, dept_name}`         |
| **Primary Key**   | Chosen candidate key                             | `{ID}`                              |
| **Foreign Key**   | Refers to primary key in another relation        | `instructor.dept_name → department` |

---

_Source: Database System Concepts, 7th Ed. by Silberschatz, Korth, Sudarshan_


## Relational Query Languages

### Types of Query Languages
1. **Procedural Languages**
   - Specify both *what* and *how* to retrieve data
   - Example: Relational Algebra

2. **Nonprocedural Languages**
   - Specify *what* to retrieve without describing *how*
   - Example: Tuple Relational Calculus

### Fundamental Relational Algebra Operations
1. Select (unary)
2. Project (unary)
3. Rename (unary)
4. Cartesian Product (binary)
5. Union (binary)
6. Set-Difference (binary)

## Exercises

### Exercise 1: Key Identification
Consider a student relation with attributes:
- student_id (unique identifier)
- name
- email
- department

1. Identify all possible superkeys
2. List the candidate keys
3. Choose an appropriate primary key and explain why

### Exercise 2: Domain Analysis
For each attribute in the student relation, define:
1. The appropriate domain
2. Whether the domain is atomic or non-atomic
3. Potential null value scenarios

### Exercise 3: Foreign Key Relationship
Design a course registration system with two relations:
- Students (student_id, name, email)
- Courses (course_id, course_name, department)
- Registration (student_id, course_id, semester)

1. Identify the primary and foreign keys
2. Draw a schema diagram showing relationships
3. Explain the referential integrity constraints

## Solutions

### Exercise 1 Solution
Superkeys:
- {student_id}
- {student_id, name}
- {student_id, email}
- {student_id, department}

Candidate Keys:
- {student_id} (recommended primary key)
- {email} (if guaranteed unique)

Primary Key: {student_id}
Reasoning: 
- Guaranteed unique
- Unlikely to change
- Short and efficient for indexing

### Exercise 2 Solution
1. student_id: 
   - Domain: Integer or string
   - Atomic domain
   - Null value: Not recommended

2. name:
   - Domain: String
   - Atomic domain
   - Null value possible (rare)

3. email:
   - Domain: String with email format
   - Non-atomic (username@domain)
   - Null value possible

4. department:
   - Domain: String of predefined department names
   - Atomic domain
   - Null value possible

### Exercise 3 Solution
Schema Diagram:
```
Students                 Registration                 Courses
---------------          ------------------           ---------------
student_id (PK)          student_id (FK)              course_id (PK)
name                     course_id (FK)               course_name
email                    semester                     department
department

Foreign Key Constraints:
- student_id in Registration references Students
- course_id in Registration references Courses
```

Referential Integrity:
- Every student_id in Registration must exist in Students
- Every course_id in Registration must exist in Courses
- A student can register for multiple courses
- A course can have multiple student registrations
