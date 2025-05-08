
# DBMS Previous Year Questions – Full Answer Set
Credit: https://github.com/Abs-Futy7/Database-Management-System/blob/main/pyq/incourse/DBMS_Questions_Full_README.md
---

## **Q1 (a)**

**Question:**  
Explain the distinctions among the terms primary key, candidate key, and superkey using a real-life example.  
In a relation schema R = (A, B, C, D); AC as well as BCD can minimally identify each tuple in the relation.  
Find the number of different keys and what are those keys?

**Answer:**  
- **Primary Key**: Chosen candidate key to uniquely identify records.  
- **Candidate Key**: Minimal set of attributes that can uniquely identify a tuple.  
- **Superkey**: Any superset of a candidate key that can uniquely identify tuples.

In R(A, B, C, D):
- Candidate Keys: AC and BCD
- Superkeys:
  - From AC: AC, ABC, ACD, ABCD
  - From BCD: BCD, ABCD
- **Total Superkeys**: 5
- **Total Candidate Keys**: 2

---

## **Q1 (b)**

**Question:**  
Consider the following relational schema:
- employee(ID, person_name, street, city)
- works(ID, branch_name, salary)
- company(branch_name, city)
- manages(ID, manager_id)

Write SQL expressions for the following:
i. Modify the database so that the employee whose ID is ‘12345’ now works in a branch located in ‘Newtown’.  
ii. Give each manager of “First Bank Corporation” a 10% raise unless the salary becomes greater than Tk 100000; in such cases give only a 3% raise.  
iii. Draw an E–R diagram for the above relational schema and indicate the key and participation constraints.

**Answer:**

i.
```sql
-- First find a branch in Newtown (assuming branch_name is unique)
-- Then update both the branch_name in works and ensure referential integrity
UPDATE works
SET branch_name = (
    SELECT branch_name 
    FROM company 
    WHERE city = 'Newtown'
    LIMIT 1
)
WHERE ID = '12345';
```

ii.
```sql
UPDATE works
SET salary = 
    CASE 
        WHEN salary * 1.10 > 100000 THEN salary * 1.03
        ELSE salary * 1.10
    END
WHERE ID IN (
    SELECT m.ID
    FROM manages m, works w, company c
    WHERE m.ID = w.ID
      AND w.branch_name = c.branch_name
      AND c.branch_name = 'First Bank Corporation'
);
```

iii. Entities:
- Employee(ID, person_name, street, city)
- Company(branch_name, city)

Relationships:
- Works (Employee → Company), attributes: salary
- Manages (Employee → Employee), attributes: manager_id

---

## **Q1 (c)**

**Question:**  
Convert the following query using lateral into a query using the with clause and a query using a scalar subquery:  
```sql
SELECT name, salary, avg_salary
FROM instructor i1,
LATERAL (
  SELECT AVG(salary) AS avg_salary
  FROM instructor i2
  WHERE i2.dept_name = i1.dept_name
);
```

**Answer:**

Using `WITH`:
```sql
WITH dept_avg AS (
  SELECT dept_name, AVG(salary) AS avg_salary
  FROM instructor
  GROUP BY dept_name
)
SELECT i.name, i.salary, d.avg_salary
FROM instructor i
JOIN dept_avg d ON i.dept_name = d.dept_name;
```

Using Scalar Subquery:
```sql
SELECT name, salary,
  (SELECT AVG(salary)
   FROM instructor i2
   WHERE i2.dept_name = i1.dept_name) AS avg_salary
FROM instructor i1;
```

---

## **Q1 (d)**

**Question:**  
Why might null values be introduced into a database?

**Answer:**
- Missing or unknown information
- Not applicable field
- Entry not yet available
- Optional relationship or attribute
- Future computation or update

---

## **Q1 (e)**

**Question:**  
Write a query to find student IDs who never took a course using outer join.

**Answer:**
```sql
SELECT s.ID
FROM student s
LEFT OUTER JOIN takes t ON s.ID = t.ID
WHERE t.course_id IS NULL;
```

---

## **Q2 (a)**

**Question:**  
What is the difference between a weak and a strong entity set? How are they related?

**Answer:**  
- **Strong Entity**: Has its own primary key, can exist independently.
- **Weak Entity**: Lacks a primary key, needs a strong entity for identification.
- Relationship: Weak entity depends on strong entity and uses total participation.

---

## **Q2 (b)**

**Question:**  
Construct a schema diagram for the E–R diagram given below. (Schema provided with Customer, Car, Policy, etc.)

**Answer:**  
```sql
Customer(customer_id PRIMARY KEY, name, address)

Car(license_no PRIMARY KEY, model)

Policy(policy_id PRIMARY KEY)

Owns(customer_id, license_no,
     PRIMARY KEY (customer_id, license_no),
     FOREIGN KEY (customer_id) REFERENCES Customer,
     FOREIGN KEY (license_no) REFERENCES Car)

Covers(license_no, policy_id,
       PRIMARY KEY (license_no, policy_id),
       FOREIGN KEY (license_no) REFERENCES Car,
       FOREIGN KEY (policy_id) REFERENCES Policy)

Accident(report_id PRIMARY KEY, date, place)

Participated(license_no, report_id,
             PRIMARY KEY (license_no, report_id),
             FOREIGN KEY (license_no) REFERENCES Car,
             FOREIGN KEY (report_id) REFERENCES Accident)

Premium_Payment(payment_no PRIMARY KEY, due_date, amount, received_on, policy_id,
                FOREIGN KEY (policy_id) REFERENCES Policy)
```

---

## **Q2 (c)**

**Question:**  
How can we force total participation in a many-to-one relationship set R from A to B using NOT NULL?

**Answer:**
```sql
CREATE TABLE A (
    id INT PRIMARY KEY,
    b_id INT NOT NULL,
    FOREIGN KEY (b_id) REFERENCES B(id)
);
```

---

## **Q2 (d)**

**Question:**  
Consider a vehicle-sales company. A vehicle is uniquely identified by a vehicle id, and is described by a model, year of manufacture and engine capacity. We have two types of vehicles: Passenger Vehicles and Commercial Vehicles. Passenger Vehicles may be motorcycles or cars; motorcycles are of type scooter or normal. Commercial vehicles may be buses or vans.

Design a generalization–specialization hierarchy for the above scenario. Justify the attribute placement.

**Answer:**

**Superclass: Vehicle**
- vehicle_id, model, year_of_manufacture, engine_capacity

**Subclasses:**
- PassengerVehicle
  - Motorcycle: type (scooter/normal)
  - Car: (additional attributes if any)
- CommercialVehicle
  - Bus: passenger_capacity, route_number
  - Van: cargo_volume, has_partition

**Justification:** Attributes are placed in subclasses only if not shared with others to avoid NULLs and maintain normalization.
