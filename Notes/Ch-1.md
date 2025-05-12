# Database System Concepts - Chapter 1 Notes

## 1. Introduction to Database Systems

### 1.1 What is a Database Management System (DBMS)?
- **Definition**: A collection of interrelated data and a set of programs to access that data
- **Components**:
  - The database: Collection of data containing information about an enterprise
  - The DBMS software: System that manages and controls access to the data

### 1.2 Goals of a DBMS
- Provide convenient and efficient data storage and retrieval
- Manage large bodies of information
- Ensure data safety and security despite system crashes or unauthorized access
- Prevent anomalous results when multiple users access data simultaneously

### 1.3 Database System Applications

#### Common Applications Areas:
- **Enterprise Information**:
  - Sales (customers, products, purchases)
  - Accounting (payments, receipts, balances)
  - Human Resources (employee information, salaries, payroll)
- **Manufacturing**: Supply chain management, production tracking, inventory control
- **Banking & Finance**:
  - Customer information and accounts
  - Transaction processing
  - Financial instrument management
- **Universities**: Student information, course registration, grade management
- **Airlines**: Reservations, schedules
- **Telecommunications**: Call records, billing
- **Web-based Services**:
  - Social media user data and connections
  - E-commerce order tracking
  - Online advertisements
- **Document Management**: Articles, patents, research papers
- **Navigation Systems**: Location data, routes

#### Modes of Database Usage:
- **Online Transaction Processing (OLTP)**:
  - Many users retrieving small amounts of data
  - Small, frequent updates
  - Example: Banking transactions, airline reservations
- **Data Analytics**:
  - Processing data to derive conclusions and business rules
  - Often uses data mining techniques
  - Example: Customer behavior analysis, predictive modeling

## 2. Purpose of Database Systems

### 2.1 Problems with File-Based Systems
- **Data Redundancy**: Same data stored in multiple files
- **Data Inconsistency**: Multiple copies of the same data may not match
- **Difficult Data Access**: Each task requires a new program
- **Data Isolation**: Data scattered in different files
- **Integrity Problems**: Constraints buried in program code
- **Atomicity Problems**: System failures can leave data partially updated
- **Concurrent Access Issues**: Uncontrolled access leads to inconsistencies
- **Security Problems**: Difficult to provide selective access to data

### 2.2 Database Systems as Solutions
Database systems provide solutions to all the above problems through:
- Centralized data management
- Concurrency control mechanisms
- Recovery management
- Security and authorization frameworks
- Data integrity enforcement

### 2.3 Popular Database Management Systems
- **Commercial Large-Scale DBMS**:
  - Oracle (8i through 23ai)
  - Microsoft SQL Server
  - IBM DB2/DB2UDB
  - Informix (now owned by IBM)
  - Sybase
- **Open Source DBMS**:
  - MySQL
  - PostgreSQL
  - Ingres
- **Small Scale/Personal DBMS**:
  - Microsoft Access
  - FoxPro
  - dBase
  - Oracle Express Editions

## 3. View of Data

### 3.1 Data Models
A data model is a collection of conceptual tools for describing:
- Data
- Data relationships
- Data semantics
- Data constraints

#### Types of Data Models:
- **Relational Model**: 
  - Uses tables (relations) to represent data and relationships
  - Each table has columns (attributes) and rows (records)
  - Most widely used data model
  
- **Entity-Relationship (E-R) Model**:
  - Higher-level data model
  - Based on entities (objects in real world) and relationships between them
  - Widely used for database design
  
- **Object-Based Models**:
  - Object-oriented data model: Extends E-R model with encapsulation and methods
  - Object-relational data model: Combines features of both relational and object-oriented models
  
- **Semi-structured Data Model**:
  - Allows varying attributes for same data type
  - Examples: XML, JSON
  
- **Historical Models**:
  - Network data model
  - Hierarchical data model

### 3.2 Levels of Abstraction


# 📘 Levels of Abstraction in Database Systems

Understanding the different levels of abstraction is essential for grasping how database systems manage and present data efficiently and securely. This model breaks down the system into three main levels:

---

## 🔸 1. Physical Level (Lowest Level of Abstraction)

- Describes **how data is physically stored** in the database system.
- Includes **file structures**, **indexing**, **block storage**, and **pointer organization**.
- Only system developers or database engineers interact at this level.
- Users and database administrators are unaware of these details.

**Example**:
> Data for the `instructor` table is stored in binary files using B+ trees to index the `ID` attribute for faster retrieval. This level controls disk storage and optimization.

---

## 🔸 2. Logical Level (Intermediate Level of Abstraction)

- Describes **what data is stored** and **how the data is interrelated**.
- Uses **tables**, **attributes**, **data types**, and **relationships**.
- Ensures **physical data independence** — changes at the physical level do not affect logical design.
- **Database administrators** primarily work at this level.

**Example**:
> Creating a table to store instructor information:

```sql
CREATE TABLE instructor (
  ID         VARCHAR(5),
  name       VARCHAR(20),
  dept_name  VARCHAR(20),
  salary     NUMERIC(8,2)
);
```

> This defines *what* data exists, not how it's stored on disk.

---

## 🔸 3. View Level (Highest Level of Abstraction)

- Provides **user-specific views** of the database.
- Simplifies interaction by showing only **relevant data** to different users.
- Enables **data hiding** and **security** by limiting access to certain columns or rows.
- Multiple views can be created for a single database.

**Example**:
> A university clerk should see only student names and departments, not grades or financial info:

```sql
CREATE VIEW student_view AS
SELECT name, dept_name FROM student;
```

> This view hides sensitive information like grades, enforcing **access control**.

---

## 🧩 Summary

| Level         | Description                              | Example                     | User Type            |
|---------------|------------------------------------------|-----------------------------|----------------------|
| **Physical**  | How data is stored in files, indexes      | B+ tree for indexing        | System developer     |
| **Logical**   | What data is stored and relationships     | `CREATE TABLE` statements   | DBA, designer        |
| **View**      | Subset of data for specific user groups   | `CREATE VIEW student_view`  | End users            |

---

## 🔐 Use of Views for Security

- Views help restrict access to certain parts of the database.
- Example for access control:
```sql
-- View for clerks
CREATE VIEW clerk_view AS
SELECT ID, name FROM student;

-- View for admin
CREATE VIEW admin_view AS
SELECT * FROM instructor;
```

Only users granted access to a view can query the data within it.

---

_Source: Database System Concepts, 7th Ed. by Silberschatz, Korth, Sudarshan_


### 3.3 Instances and Schemas
- **Instance**: The collection of information in the database at a particular moment
- **Schema**: The overall design of the database

Types of schemas:
- **Physical Schema**: Overall physical structure
- **Logical Schema**: Overall logical structure (most important for applications)
- **View Schema (Subschema)**: Describes different views of the database

### 3.4 Physical Data Independence
- The ability to modify the physical schema without changing the logical schema
- Applications depend on logical schema, not physical implementation
- Well-defined interfaces between levels allow changes in one part without affecting others

## 4. Database Languages

### 4.1 Data Definition Language (DDL)
- Used to specify database schema
- Creates and modifies structure and constraints
- Examples: CREATE, ALTER, DROP statements

Components:
- **Data Storage and Definition Language**: Specifies storage structures and access methods
- **Consistency Constraints Specification**:
  - Domain constraints: Valid values for attributes
  - Referential integrity: Ensures relationships between tables are consistent
  - Authorization: Specifies access permissions

### 4.2 Data Dictionary
- Special set of tables containing metadata (data about data)
- Updated when DDL statements are processed
- Contains:
  - Relation metadata (table names, attributes, storage details)
  - Attribute metadata (names, types, positions)
  - User metadata (credentials, groups)
  - Index metadata
  - View metadata

### 4.3 Data Manipulation Language (DML)
- Language for accessing and manipulating data
- Operations:
  - Insert: Add new data
  - Delete: Remove data
  - Update: Modify existing data
  - Query: Retrieve data

Types:
- **Procedural DML**: Requires specifying both what data is needed and how to get it
- **Declarative DML**: Requires only specifying what data is needed (easier to learn)

### 4.4 SQL Query Language
- Non-procedural language
- Takes tables as input and returns a single table
- Example:
  ```sql
  SELECT name
  FROM instructor
  WHERE dept_name = 'Comp. Sci.'
  ```

### 4.5 Database Access from Application Programs
- Application programs interact with databases through:
  - Embedded SQL
  - Application Programming Interfaces (APIs) like ODBC and JDBC
- Necessary for operations not supported by SQL alone (user input/output, network communication)

## 5. Database Design

Database design occurs in two phases:

### 5.1 Logical Design
- Deciding on the database schema
- Determining what attributes to include
- Distributing attributes among relation schemas
- Mapping conceptual schema to implementation data model

### 5.2 Physical Design
- Deciding on physical layout of the database
- Selecting file organizations and internal storage structures
- Creating indexes for fast data access

## 6. Database Engine Components

### 6.1 Storage Manager
- Provides interface between low-level data and applications
- Responsible for:
  - Interacting with OS file manager
  - Efficient storing, retrieving, and updating of data

Components:
- **Authorization and Integrity Manager**: Tests constraints and checks user authority
- **Transaction Manager**: Ensures consistency despite system failures
- **File Manager**: Manages space allocation and data structures
- **Buffer Manager**: Manages data transfer between disk and memory

Data structures implemented:
- Data files (storing relations)
- Data dictionary (metadata)
- Indices (for fast data access)

### 6.2 Query Processor
Components:
- **DDL Interpreter**: Processes schema definitions
- **DML Compiler**: Translates queries into execution plans
  - Performs query optimization to find lowest-cost plan
- **Query Evaluation Engine**: Executes the plans

Query processing involves:
1. Parsing and translation
2. Optimization
3. Evaluation

### 6.3 Transaction Management
- A transaction is a logical unit of database operations
- ACID Properties:
  - **A**tomicity: All or nothing execution
  - **C**onsistency: Database remains consistent
  - **I**solation: Transactions execute as if they were alone
  - **D**urability: Completed transactions persist

Components:
- **Concurrency Control Manager**: Controls interaction between transactions
- **Recovery Manager**: Ensures database consistency after failures

## 7. Database Architecture

### 7.1 Types of Architectures
- **Centralized Databases**:
  - One to few cores, shared memory
  
- **Client-server**:
  - Server executes work on behalf of multiple clients
  
- **Parallel Databases**:
  - Many-core shared memory
  - Shared disk
  - Shared nothing
  
- **Distributed Databases**:
  - Geographically distributed
  - Schema/data heterogeneity

### 7.2 Application Architectures
- **Two-tier Architecture**:
  - Application at client machine
  - Database at server machine
  - Communication through ODBC/JDBC
  
- **Three-tier Architecture**:
  - Client (front-end)
  - Application server (middle-tier)
  - Database server (back-end)
  - More appropriate for web applications

## 8. Database Users and Administrators

### 8.1 Database Users
- **Naive Users**:
  - Unsophisticated users
  - Interact through forms or reports
  - Example: bank tellers, clerks
  
- **Application Programmers**:
  - Write database applications
  - Use RAD tools for interface development
  
- **Sophisticated Users**:
  - Use query languages directly
  - Example: analysts, data miners

### 8.2 Database Administrator (DBA)
Functions:
- **Schema Definition**: Creating database structure
- **Storage Structure Definition**: Selecting file organizations and access methods
- **Schema and Physical Organization Modification**: Updating as needs change
- **Authorization Management**: Granting access permissions
- **Integrity Constraint Specification**: Implementing business rules
- **Routine Maintenance**:
  - Database backup
  - Disk space management
  - Performance monitoring

## 9. History of Database Systems

### 1950s and early 1960s
- Data processing using magnetic tapes (sequential access)
- Punched cards for input

### Late 1960s and 1970s
- Hard disks allowed direct access
- Network and hierarchical models in use
- Ted Codd defines relational model (later wins Turing Award)
- IBM begins System R prototype
- UC Berkeley begins Ingres
- Oracle releases first commercial relational database

### 1980s
- SQL becomes industry standard
- Parallel and distributed systems emerge
- Object-oriented database systems appear

### 1990s
- Decision support and data mining applications grow
- Large data warehouses emerge
- Web commerce begins

### 2000s
- Big data storage systems (Google BigTable, Yahoo PNuts)
- "NoSQL" systems
- Map-reduce for data analysis

### 2010s
- SQL systems regain popularity
- SQL front-ends to Map-reduce
- Massively parallel database systems
- Multi-core main-memory databases

## Exercises

### Exercise 1: Database Applications
**Question**: Identify three specific applications where database systems are essential and explain why file-based systems would be inadequate for them.

**Solution**:
1. **Banking System**:
   - Requires concurrent access by many users
   - Needs transaction support to maintain consistency
   - Requires strong security controls
   - File-based systems would lead to inconsistencies during concurrent updates and lack atomicity for transactions.

2. **E-commerce Platform**:
   - Handles thousands of concurrent orders
   - Needs to maintain inventory accuracy
   - Requires user authentication and authorization
   - File-based systems would struggle with locking, concurrent access, and maintaining referential integrity.

3. **Healthcare Management System**:
   - Stores sensitive patient information
   - Requires complex queries across patient history
   - Needs fine-grained access control
   - File-based systems would lack the security, query capabilities, and integrity constraints needed.

### Exercise 2: Data Models
**Question**: Compare and contrast the relational model with the entity-relationship model. When would you use one over the other?

**Solution**:
- **Relational Model**:
  - Uses tables (relations) with rows and columns
  - Strong mathematical foundation
  - Good for implementation
  - Focuses on data structure and constraints
  
- **Entity-Relationship Model**:
  - Uses entities, attributes, and relationships
  - More intuitive visual representation
  - Better for conceptual modeling
  - Captures real-world semantics more naturally
  
- **Usage**:
  - Use E-R model during initial design phases to capture requirements
  - Convert E-R model to relational model for implementation
  - E-R model is better for communication with non-technical stakeholders
  - Relational model is better for actual database implementation

### Exercise 3: Database Architecture
**Question**: Explain the differences between two-tier and three-tier architecture for database applications. What are the advantages of a three-tier architecture?

**Solution**:
- **Two-tier Architecture**:
  - Client application directly communicates with database server
  - Application logic split between client and database server
  
- **Three-tier Architecture**:
  - Client (presentation layer)
  - Application server (business logic)
  - Database server (data storage)
  
- **Advantages of Three-tier Architecture**:
  1. **Scalability**: Can scale each tier independently
  2. **Security**: Business logic is isolated from both client and database
  3. **Maintenance**: Changes to business logic don't require client updates
  4. **Resource Utilization**: Better distribution of computing resources
  5. **Reusability**: Business logic can be shared across multiple clients

### Exercise 4: Transaction Management
**Question**: Describe the ACID properties of transactions and give an example showing why each property is important.

**Solution**:
- **Atomicity**:
  - All or nothing execution
  - Example: Bank transfer must either fully complete (debit one account, credit another) or not happen at all; partial execution would lose money

- **Consistency**:
  - Database moves from one valid state to another
  - Example: In a university database, if a course has a maximum capacity of 30 students, after any transaction, the enrollment count must not exceed 30

- **Isolation**:
  - Transactions execute as if they were alone
  - Example: Two customers booking the last airplane seat should not both get confirmed; isolation ensures only one succeeds

- **Durability**:
  - Completed transactions persist even after system failure
  - Example: After confirming a payment to a customer, the record should survive even if the system crashes immediately afterward

### Exercise 5: Database Users
**Question**: Identify the type of database user that would be involved in each of the following scenarios:

**Solution**:
1. **A bank teller processing customer deposits and withdrawals**:
   - Naive user (uses predefined forms/applications)

2. **A financial analyst creating custom reports on loan performance**:
   - Sophisticated user (writes custom queries)

3. **A developer creating a new mobile banking application**:
   - Application programmer

4. **An IT professional configuring database backups and security settings**:
   - Database administrator (DBA)

5. **A customer using an ATM to withdraw money**:
   - Naive user (interacts through fixed interface)
