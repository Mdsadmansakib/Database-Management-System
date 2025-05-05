# Database Management Systems Exam Solutions
**University of Dhaka, Department of Computer Science and Engineering**  
**Course: CSE 2201 - Database Management Systems**  
**In-course Examination, September 2023**

## Question 1
### 1(a) One of the primary purposes of Database Management Systems (DBMS) is to keep data consistent. Explain with proper examples when data becomes inconsistent. [3]

Data becomes inconsistent when the same information is stored redundantly in multiple places and gets updated in one location but not in others. This creates contradictory values for the same data entity.

**Examples of data inconsistency:**
1. **Customer records:** If a customer's address is stored in both a customer table and an order table, updating it in only one table creates inconsistency.
2. **Product inventory:** If product stock is tracked in both a warehouse table and a store inventory table, and a sale reduces the count in one table but not the other, inventory becomes inconsistent.
3. **Employee data:** If an employee's salary is stored in both payroll and HR department tables, and only one gets updated after a raise, the database contains contradictory salary information.

### 1(b) "A database management system provides tools for avoiding data inconsistency; however, a bad design may invite inconsistent data even in an ideal DBMS" Justify the statement. [4]

This statement is accurate because DBMS provides mechanisms to maintain consistency, but poor database design can undermine these mechanisms.

**DBMS tools for avoiding inconsistency:**
1. **Normalization:** Reduces redundancy by organizing data into separate tables with defined relationships.
2. **Constraints:** Primary keys, foreign keys, and check constraints enforce data integrity.
3. **Transactions:** ACID properties ensure consistency across operations.
4. **Triggers:** Automatically update related data when changes occur.

**How bad design invites inconsistency despite DBMS tools:**
1. **Redundant data storage:** If the same data is deliberately stored in multiple tables without proper constraints or triggers, updates in one location won't propagate to others.
2. **Missing constraints:** Failure to implement foreign key constraints can lead to orphaned records.
3. **Improper normalization:** Inadequate normalization results in update anomalies.
4. **Poor transaction management:** Not grouping related operations into transactions can leave data in an inconsistent state if operations fail.

## Question 2
### Hospital Patient Management System Case

Consider a hospital where patients come for treatments when they feel sick or get injured. The hospital has a set of doctors and a set of enlisted external consultants for the patients. The doctors and consultants examine the patients physically, recommends different types of medical test based on their sickness (eg. General disease, cardiology, neurology, urology, etc.), and prescribe medicines accordingly. Except for emergency cases, the patients can select their doctors from the panel of doctors and consultants.

Suppose the hospital wants to develop a database application to keep track of patients, their treatments based on their sickness, and the prescribed medicines. The hospital authority has no idea about DBMS or how it works. They can explain the information they would like to store in the database. Some of such requirements are:

i) The most prescribed medicine by doctors and consultants  
ii) The medicine names that are prescribed for how many different sickness types  
iii) The patients' preference in selecting the doctor/consultant for a sickness type  
iv) The medicine that a doctor/consultant recommends for each sickness type  
v) The list of patients and doctors that have appointment tomorrow (or, on a particular date)  

### 2(a) For the hospital described above, design a database with the required tables and attributes. Just write down the table schema for a table and mention the primary/unique key of the tables. You have the full freedom in choosing the tables and attributes; however, your design must comply to the requirements (i) to (v) above. [4]

**Patient Table:**
```
Patient(PatientID, Name, Age, PhoneNumber, Address)
Primary Key: PatientID
```

**Doctor Table:**
```
Doctor(DoctorID, Name, Specialization, PhoneNumber)
Primary Key: DoctorID
```

**Sickness Table:**
```
Sickness(SicknessID, SicknessName, Category)
Primary Key: SicknessID
```

**Medicine Table:**
```
Medicine(MedicineID, MedicineName, Manufacturer, Dosage)
Primary Key: MedicineID
```

**Appointment Table:**
```
Appointment(AppointmentID, PatientID, DoctorID, AppointmentDate, Status)
Primary Key: AppointmentID
Foreign Keys: PatientID references Patient, DoctorID references Doctor
```

**Prescription Table:**
```
Prescription(PrescriptionID, AppointmentID, SicknessID, Date)
Primary Key: PrescriptionID
Foreign Keys: AppointmentID references Appointment, SicknessID references Sickness
```

**PrescriptionDetail Table:**
```
PrescriptionDetail(PrescriptionID, MedicineID, Instruction, Duration)
Primary Key: (PrescriptionID, MedicineID)
Foreign Keys: PrescriptionID references Prescription, MedicineID references Medicine
```

**PatientPreference Table:**
```
PatientPreference(PatientID, SicknessID, DoctorID, PreferenceRank)
Primary Key: (PatientID, SicknessID, DoctorID)
Foreign Keys: PatientID references Patient, SicknessID references Sickness, DoctorID references Doctor
```

### 2(b) Do you like to use any foreign key in your design? If yes, list the table and column names with the referring table and column and justify why you use that key. [2]

Yes, foreign keys are essential in this design to maintain referential integrity:

1. **Appointment Table:**
   - PatientID references Patient.PatientID - Ensures appointments are only created for existing patients
   - DoctorID references Doctor.DoctorID - Ensures appointments are only assigned to existing doctors

2. **Prescription Table:**
   - AppointmentID references Appointment.AppointmentID - Links prescriptions to specific appointments
   - SicknessID references Sickness.SicknessID - Ensures prescriptions are for valid sickness types

3. **PrescriptionDetail Table:**
   - PrescriptionID references Prescription.PrescriptionID - Links medicine details to prescriptions
   - MedicineID references Medicine.MedicineID - Ensures only valid medicines are prescribed

4. **PatientPreference Table:**
   - PatientID references Patient.PatientID - Links preferences to existing patients
   - SicknessID references Sickness.SicknessID - Links preferences to valid sickness types
   - DoctorID references Doctor.DoctorID - Links preferences to existing doctors

These foreign keys prevent orphaned records and maintain data consistency across related tables.

### 2(c) Write down the SQL statements to create the tables in your design. [3]

```sql
CREATE TABLE Patient (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Age INT,
    PhoneNumber VARCHAR(20),
    Address VARCHAR(200)
);

CREATE TABLE Doctor (
    DoctorID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Specialization VARCHAR(50),
    PhoneNumber VARCHAR(20)
);

CREATE TABLE Sickness (
    SicknessID INT PRIMARY KEY,
    SicknessName VARCHAR(100) NOT NULL,
    Category VARCHAR(50)
);

CREATE TABLE Medicine (
    MedicineID INT PRIMARY KEY,
    MedicineName VARCHAR(100) NOT NULL,
    Manufacturer VARCHAR(100),
    Dosage VARCHAR(50)
);

CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    Status VARCHAR(20),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);

CREATE TABLE Prescription (
    PrescriptionID INT PRIMARY KEY,
    AppointmentID INT NOT NULL,
    SicknessID INT NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID),
    FOREIGN KEY (SicknessID) REFERENCES Sickness(SicknessID)
);

CREATE TABLE PrescriptionDetail (
    PrescriptionID INT,
    MedicineID INT,
    Instruction VARCHAR(200),
    Duration VARCHAR(50),
    PRIMARY KEY (PrescriptionID, MedicineID),
    FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID),
    FOREIGN KEY (MedicineID) REFERENCES Medicine(MedicineID)
);

CREATE TABLE PatientPreference (
    PatientID INT,
    SicknessID INT,
    DoctorID INT,
    PreferenceRank INT,
    PRIMARY KEY (PatientID, SicknessID, DoctorID),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    FOREIGN KEY (SicknessID) REFERENCES Sickness(SicknessID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);
```

## Question 3
### 3(a) For your database design in answering the question 2(a), write relational algebra expressions and SQL statements to find the following:

#### i. List the doctor's name, patient name, patient age, and patient telephone number of each patient that have an appointment tomorrow (12-SEP-2023). [2]

**Relational Algebra:**
```
π Doctor.Name, Patient.Name, Patient.Age, Patient.PhoneNumber (
    σ Appointment.AppointmentDate = '2023-09-12' (
        Patient ⋈ Appointment ⋈ Doctor
    )
)
```

**SQL:**
```sql
SELECT d.Name AS DoctorName, p.Name AS PatientName, p.Age, p.PhoneNumber 
FROM Patient p
JOIN Appointment a ON p.PatientID = a.PatientID
JOIN Doctor d ON a.DoctorID = d.DoctorID
WHERE a.AppointmentDate = '2023-09-12';
```

#### ii. List of medicines that have been prescribed for "Dengue fever". [2]

**Relational Algebra:**
```
π Medicine.MedicineName (
    σ Sickness.SicknessName = 'Dengue fever' (
        Medicine ⋈ PrescriptionDetail ⋈ Prescription ⋈ Sickness
    )
)
```

**SQL:**
```sql
SELECT DISTINCT m.MedicineName
FROM Medicine m
JOIN PrescriptionDetail pd ON m.MedicineID = pd.MedicineID
JOIN Prescription p ON pd.PrescriptionID = p.PrescriptionID
JOIN Sickness s ON p.SicknessID = s.SicknessID
WHERE s.SicknessName = 'Dengue fever';
```

#### iii. List of patients who visited the hospital last month and have no appointment this month. [2]

**Relational Algebra:**
```
π Patient.Name (
    σ MONTH(Appointment.AppointmentDate) = MONTH(CURRENT_DATE)-1 AND YEAR(Appointment.AppointmentDate) = YEAR(CURRENT_DATE) (
        Patient ⋈ Appointment
    )
) - π Patient.Name (
    σ MONTH(Appointment.AppointmentDate) = MONTH(CURRENT_DATE) AND YEAR(Appointment.AppointmentDate) = YEAR(CURRENT_DATE) (
        Patient ⋈ Appointment
    )
)
```

**SQL:**
```sql
SELECT DISTINCT p.Name
FROM Patient p
JOIN Appointment a ON p.PatientID = a.PatientID
WHERE MONTH(a.AppointmentDate) = MONTH(CURRENT_DATE)-1 
AND YEAR(a.AppointmentDate) = YEAR(CURRENT_DATE)
AND p.PatientID NOT IN (
    SELECT p2.PatientID
    FROM Patient p2
    JOIN Appointment a2 ON p2.PatientID = a2.PatientID
    WHERE MONTH(a2.AppointmentDate) = MONTH(CURRENT_DATE)
    AND YEAR(a2.AppointmentDate) = YEAR(CURRENT_DATE)
);
```

### 3(b) Write SQL statements to find the following requirements from your designed database:

#### i. Find the most prescribed medicine by doctors and consultants

```sql
SELECT m.MedicineName, COUNT(*) AS PrescriptionCount
FROM Medicine m
JOIN PrescriptionDetail pd ON m.MedicineID = pd.MedicineID
GROUP BY m.MedicineID, m.MedicineName
ORDER BY PrescriptionCount DESC
LIMIT 1;
```

#### ii. Find medicine names that are prescribed for how many different sickness types

```sql
SELECT m.MedicineName, COUNT(DISTINCT s.SicknessID) AS SicknessTypeCount
FROM Medicine m
JOIN PrescriptionDetail pd ON m.MedicineID = pd.MedicineID
JOIN Prescription p ON pd.PrescriptionID = p.PrescriptionID
JOIN Sickness s ON p.SicknessID = s.SicknessID
GROUP BY m.MedicineID, m.MedicineName
ORDER BY SicknessTypeCount DESC;
```

#### iii. Find The patients' preference in selecting the doctor/consultant for a sickness type [6]

```sql
SELECT p.Name AS PatientName, s.SicknessName, d.Name AS DoctorName, pp.PreferenceRank
FROM PatientPreference pp
JOIN Patient p ON pp.PatientID = p.PatientID
JOIN Doctor d ON pp.DoctorID = d.DoctorID
JOIN Sickness s ON pp.SicknessID = s.SicknessID
ORDER BY p.Name, s.SicknessName, pp.PreferenceRank;
```