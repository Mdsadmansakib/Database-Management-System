-- Creating the 'classroom' table to store information about classrooms in buildings
CREATE TABLE classroom (
    building      VARCHAR2(15), -- Name of the building
    room_number   VARCHAR2(7),  -- Room number in the building
    capacity      NUMBER(4,0),  -- Capacity (number of students the room can accommodate)
    CONSTRAINT pk_classroom PRIMARY KEY (building, room_number) -- Primary Key = (building + room_number)
);

-- Creating the 'department' table to store departments
CREATE TABLE department (
    dept_name     VARCHAR2(20), -- Name of the department
    building      VARCHAR2(15), -- Building where the department is located
    budget        NUMBER(12,2) CHECK (budget > 0), -- Department budget (must be positive)
    CONSTRAINT pk_department PRIMARY KEY (dept_name) -- Primary Key = dept_name
);

-- Creating the 'course' table to store courses
CREATE TABLE course (
    course_id     VARCHAR2(8),  -- Unique ID for the course
    title         VARCHAR2(50), -- Course title
    dept_name     VARCHAR2(20), -- Department offering the course
    credits       NUMBER(2,0) CHECK (credits > 0), -- Number of credits (must be positive)
    CONSTRAINT pk_course PRIMARY KEY (course_id), -- Primary Key = course_id
    CONSTRAINT fk_course_dept FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON DELETE SET NULL -- If department is deleted, set dept_name in course as NULL
);

-- Creating the 'instructor' table to store instructors
CREATE TABLE instructor (
    ID            VARCHAR2(5),  -- Unique instructor ID
    name          VARCHAR2(20) NOT NULL, -- Instructor name (cannot be NULL)
    dept_name     VARCHAR2(20), -- Department name
    salary        NUMBER(8,2) CHECK (salary > 29000), -- Salary (must be above 29000)
    CONSTRAINT pk_instructor PRIMARY KEY (ID), -- Primary Key = ID
    CONSTRAINT fk_instructor_dept FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON DELETE SET NULL -- If department deleted, set dept_name to NULL
);

-- Creating the 'section' table to store course offerings
CREATE TABLE section (
    course_id     VARCHAR2(8),  -- ID of the course
    sec_id        VARCHAR2(8),  -- Section ID
    semester      VARCHAR2(6) CHECK (semester IN ('Fall', 'Winter', 'Spring', 'Summer')), -- Semester offered
    year          NUMBER(4,0) CHECK (year > 1701 AND year < 2100), -- Year offered
    building      VARCHAR2(15), -- Building where section is held
    room_number   VARCHAR2(7),  -- Room number
    time_slot_id  VARCHAR2(4),  -- Time slot ID
    CONSTRAINT pk_section PRIMARY KEY (course_id, sec_id, semester, year), -- Composite Primary Key
    CONSTRAINT fk_section_course FOREIGN KEY (course_id) REFERENCES course (course_id)
        ON DELETE CASCADE, -- If course deleted, delete section too
    CONSTRAINT fk_section_classroom FOREIGN KEY (building, room_number) REFERENCES classroom (building, room_number)
        ON DELETE SET NULL -- If classroom deleted, set building and room_number to NULL
);

-- Creating the 'teaches' table to record which instructor teaches which section
CREATE TABLE teaches (
    ID            VARCHAR2(5),  -- Instructor ID
    course_id     VARCHAR2(8),  -- Course ID
    sec_id        VARCHAR2(8),  -- Section ID
    semester      VARCHAR2(6),  -- Semester
    year          NUMBER(4,0),  -- Year
    CONSTRAINT pk_teaches PRIMARY KEY (ID, course_id, sec_id, semester, year), -- Composite Primary Key
    CONSTRAINT fk_teaches_section FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section (course_id, sec_id, semester, year)
        ON DELETE CASCADE, -- If section deleted, delete corresponding teaches
    CONSTRAINT fk_teaches_instructor FOREIGN KEY (ID) REFERENCES instructor (ID)
        ON DELETE CASCADE -- If instructor deleted, delete corresponding teaches
);

-- Creating the 'student' table to store student information
CREATE TABLE student (
    ID            VARCHAR2(5),  -- Student ID
    name          VARCHAR2(20) NOT NULL, -- Student name
    dept_name     VARCHAR2(20), -- Department name
    tot_cred      NUMBER(3,0) CHECK (tot_cred >= 0), -- Total credits earned (non-negative)
    CONSTRAINT pk_student PRIMARY KEY (ID), -- Primary Key = ID
    CONSTRAINT fk_student_dept FOREIGN KEY (dept_name) REFERENCES department (dept_name)
        ON DELETE SET NULL -- If department deleted, set dept_name to NULL
);

-- Creating the 'takes' table to record which student takes which section
CREATE TABLE takes (
    ID            VARCHAR2(5),  -- Student ID
    course_id     VARCHAR2(8),  -- Course ID
    sec_id        VARCHAR2(8),  -- Section ID
    semester      VARCHAR2(6),  -- Semester
    year          NUMBER(4,0),  -- Year
    grade         VARCHAR2(2),  -- Grade obtained
    CONSTRAINT pk_takes PRIMARY KEY (ID, course_id, sec_id, semester, year), -- Composite Primary Key
    CONSTRAINT fk_takes_section FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section (course_id, sec_id, semester, year)
        ON DELETE CASCADE, -- If section deleted, delete corresponding takes
    CONSTRAINT fk_takes_student FOREIGN KEY (ID) REFERENCES student (ID)
        ON DELETE CASCADE -- If student deleted, delete corresponding takes
);

-- Creating the 'advisor' table to store student advisors
CREATE TABLE advisor (
    s_ID          VARCHAR2(5),  -- Student ID
    i_ID          VARCHAR2(5),  -- Instructor ID (Advisor)
    CONSTRAINT pk_advisor PRIMARY KEY (s_ID), -- Each student has at most one advisor
    CONSTRAINT fk_advisor_instructor FOREIGN KEY (i_ID) REFERENCES instructor (ID)
        ON DELETE SET NULL, -- If instructor deleted, set i_ID to NULL
    CONSTRAINT fk_advisor_student FOREIGN KEY (s_ID) REFERENCES student (ID)
        ON DELETE CASCADE -- If student deleted, delete advisor record
);

-- Creating the 'time_slot' table to store class timing slots
CREATE TABLE time_slot (
    time_slot_id  VARCHAR2(4),  -- Time slot ID
    day           VARCHAR2(1),  -- Day of the week (e.g., M, T, W, R, F)
    start_hr      NUMBER(2) CHECK (start_hr >= 0 AND start_hr < 24), -- Start hour (24-hour format)
    start_min     NUMBER(2) CHECK (start_min >= 0 AND start_min < 60), -- Start minute
    end_hr        NUMBER(2) CHECK (end_hr >= 0 AND end_hr < 24), -- End hour
    end_min       NUMBER(2) CHECK (end_min >= 0 AND end_min < 60), -- End minute
    CONSTRAINT pk_time_slot PRIMARY KEY (time_slot_id, day, start_hr, start_min) -- Composite Primary Key
);

-- Creating the 'prereq' table to store prerequisites for courses
CREATE TABLE prereq (
    course_id     VARCHAR2(8),  -- Course ID
    prereq_id     VARCHAR2(8),  -- Prerequisite course ID
    CONSTRAINT pk_prereq PRIMARY KEY (course_id, prereq_id), -- Composite Primary Key
    CONSTRAINT fk_prereq_course FOREIGN KEY (course_id) REFERENCES course (course_id)
        ON DELETE CASCADE, -- If course deleted, delete prereq record
    CONSTRAINT fk_prereq_prereq FOREIGN KEY (prereq_id) REFERENCES course (course_id)
        -- No action on delete for prerequisite course
);

--------------------------------------------------------------------------------
-- Inserting data into tables
--------------------------------------------------------------------------------

-- Inserting classroom records
insert into classroom values ('Packard', '101', '500');
insert into classroom values ('Painter', '514', '10');
insert into classroom values ('Taylor', '3128', '70');
insert into classroom values ('Watson', '100', '30');
insert into classroom values ('Watson', '120', '50');

-- Inserting department records
insert into department values ('Biology', 'Watson', '90000');
insert into department values ('Comp. Sci.', 'Taylor', '100000');
insert into department values ('Elec. Eng.', 'Taylor', '85000');
insert into department values ('Finance', 'Painter', '120000');
insert into department values ('History', 'Painter', '50000');
insert into department values ('Music', 'Packard', '80000');
insert into department values ('Physics', 'Watson', '70000');

-- Inserting course records
insert into course values ('BIO-101', 'Intro. to Biology', 'Biology', '4');
insert into course values ('BIO-301', 'Genetics', 'Biology', '4');
insert into course values ('BIO-399', 'Computational Biology', 'Biology', '3');
insert into course values ('CS-101', 'Intro. to Computer Science', 'Comp. Sci.', '4');
insert into course values ('CS-190', 'Game Design', 'Comp. Sci.', '4');
insert into course values ('CS-315', 'Robotics', 'Comp. Sci.', '3');
insert into course values ('CS-319', 'Image Processing', 'Comp. Sci.', '3');
insert into course values ('CS-347', 'Database System Concepts', 'Comp. Sci.', '3');
insert into course values ('EE-181', 'Intro. to Digital Systems', 'Elec. Eng.', '3');
insert into course values ('FIN-201', 'Investment Banking', 'Finance', '3');
insert into course values ('HIS-351', 'World History', 'History', '3');
insert into course values ('MU-199', 'Music Video Production', 'Music', '3');
insert into course values ('PHY-101', 'Physical Principles', 'Physics', '4');

-- Inserting instructor records
insert into instructor values ('10101', 'Srinivasan', 'Comp. Sci.', '65000');
insert into instructor values ('12121', 'Wu', 'Finance', '90000');
insert into instructor values ('15151', 'Mozart', 'Music', '40000');
insert into instructor values ('22222', 'Einstein', 'Physics', '95000');
insert into instructor values ('32343', 'El Said', 'History', '60000');
insert into instructor values ('33456', 'Gold', 'Physics', '87000');
insert into instructor values ('45565', 'Katz', 'Comp. Sci.', '75000');
insert into instructor values ('58583', 'Califieri', 'History', '62000');
insert into instructor values ('76543', 'Singh', 'Finance', '80000');
insert into instructor values ('76766', 'Crick', 'Biology', '72000');
insert into instructor values ('83821', 'Brandt', 'Comp. Sci.', '92000');
insert into instructor values ('98345', 'Kim', 'Elec. Eng.', '80000');

-- Inserting section records
insert into section values ('BIO-101', '1', 'Summer', '2017', 'Painter', '514', 'B');
insert into section values ('BIO-301', '1', 'Summer', '2018', 'Painter', '514', 'A');
insert into section values ('CS-101', '1', 'Fall', '2017', 'Packard', '101', 'H');
insert into section values ('CS-101', '1', 'Spring', '2018', 'Packard', '101', 'F');
insert into section values ('CS-190', '1', 'Spring', '2017', 'Taylor', '3128', 'E');
insert into section values ('CS-190', '2', 'Spring', '2017', 'Taylor', '3128', 'A');
insert into section values ('CS-315', '1', 'Spring', '2018', 'Watson', '120', 'D');
insert into section values ('CS-319', '1', 'Spring', '2018', 'Watson', '100', 'B');
insert into section values ('CS-319', '2', 'Spring', '2018', 'Taylor', '3128', 'C');
insert into section values ('CS-347', '1', 'Fall', '2017', 'Taylor', '3128', 'A');
insert into section values ('EE-181', '1', 'Spring', '2017', 'Taylor', '3128', 'C');
insert into section values ('FIN-201', '1', 'Spring', '2018', 'Packard', '101', 'B');
insert into section values ('HIS-351', '1', 'Spring', '2018', 'Painter', '514', 'C');
insert into section values ('MU-199', '1', 'Spring', '2018', 'Packard', '101', 'D');
insert into section values ('PHY-101', '1', 'Fall', '2017', 'Watson', '100', 'A');
insert into section values ('PHY-101', '1', 'Fall', '2017', 'Watson', '100', 'A');

-- Inserting teaches records: which instructor teaches which section
insert into teaches values ('10101', 'CS-101', '1', 'Fall', '2017');
insert into teaches values ('10101', 'CS-101', '1', 'Spring', '2018');
insert into teaches values ('10101', 'CS-347', '1', 'Fall', '2017');
insert into teaches values ('12121', 'FIN-201', '1', 'Spring', '2018');
insert into teaches values ('15151', 'MU-199', '1', 'Spring', '2018');
insert into teaches values ('22222', 'PHY-101', '1', 'Fall', '2017');
insert into teaches values ('32343', 'HIS-351', '1', 'Spring', '2018');
insert into teaches values ('45565', 'CS-101', '1', 'Fall', '2017');
insert into teaches values ('45565', 'CS-319', '1', 'Spring', '2018');
insert into teaches values ('76766', 'BIO-101', '1', 'Summer', '2017');
insert into teaches values ('76766', 'BIO-301', '1', 'Summer', '2018');
insert into teaches values ('83821', 'CS-190', '1', 'Spring', '2017');
insert into teaches values ('83821', 'CS-190', '2', 'Spring', '2017');
insert into teaches values ('83821', 'CS-319', '2', 'Spring', '2018');
insert into teaches values ('98345', 'EE-181', '1', 'Spring', '2017');

-- Inserting student records
insert into student values ('00128', 'Zhang', 'Comp. Sci.', '102');
insert into student values ('12345', 'Shankar', 'Comp. Sci.', '32');
insert into student values ('19991', 'Brandt', 'History', '80');
insert into student values ('23121', 'Chavez', 'Finance', '110');
insert into student values ('44553', 'Peltier', 'Physics', '56');
insert into student values ('45678', 'Levy', 'Physics', '46');
insert into student values ('54321', 'Williams', 'Comp. Sci.', '54');
insert into student values ('55739', 'Sanchez', 'Music', '38');
insert into student values ('70557', 'Snow', 'Physics', '0');
insert into student values ('76543', 'Brown', 'Comp. Sci.', '58');
insert into student values ('76653', 'Aoi', 'Elec. Eng.', '60');
insert into student values ('98765', 'Bourikas', 'Elec. Eng.', '98');
insert into student values ('98988', 'Tanaka', 'Biology', '120');

-- Inserting takes records: which student takes which section
insert into takes values ('00128', 'CS-101', '1', 'Fall', '2017', 'A');
insert into takes values ('00128', 'CS-347', '1', 'Fall', '2017', 'A');
insert into takes values ('12345', 'CS-101', '1', 'Fall', '2017', 'C');
insert into takes values ('12345', 'CS-190', '2', 'Spring', '2017', 'A');
insert into takes values ('12345', 'CS-315', '1', 'Spring', '2018', 'A');
insert into takes values ('19991', 'HIS-351', '1', 'Spring', '2018', 'B');
insert into takes values ('23121', 'FIN-201', '1', 'Spring', '2018', 'C+');
insert into takes values ('44553', 'PHY-101', '1', 'Fall', '2017', 'B-');
insert into takes values ('45678', 'PHY-101', '1', 'Fall', '2017', 'C');
insert into takes values ('45678', 'CS-101', '1', 'Spring', '2018', 'F');
insert into takes values ('54321', 'CS-101', '1', 'Fall', '2017', 'B+');
insert into takes values ('54321', 'CS-190', '2', 'Spring', '2017', 'A');
insert into takes values ('55739', 'MU-199', '1', 'Spring', '2018', 'A-');
insert into takes values ('76543', 'CS-101', '1', 'Fall', '2017', 'A');
insert into takes values ('76543', 'CS-319', '1', 'Spring', '2018', 'A');
insert into takes values ('76653', 'EE-181', '1', 'Spring', '2017', 'C');
insert into takes values ('98765', 'CS-101', '1', 'Fall', '2017', 'C-');
insert into takes values ('98765', 'CS-315', '1', 'Spring', '2018', 'B');
insert into takes values ('98988', 'BIO-101', '1', 'Summer', '2017', 'A');
insert into takes values ('98988', 'BIO-301', '1', 'Summer', '2018', NULL);

-- Inserting advisor records: assigning advisors to students
insert into advisor values ('00128', '45565');
insert into advisor values ('12345', '10101');
insert into advisor values ('23121', '76543');
insert into advisor values ('44553', '22222');
insert into advisor values ('45678', '22222');
insert into advisor values ('76543', '45565');
insert into advisor values ('76653', '98345');
insert into advisor values ('98765', '98345');
insert into advisor values ('98988', '76766');

-- Inserting time slot records (class schedules)
insert into time_slot values ('A', 'M', 8, 0, 8, 50);
insert into time_slot values ('A', 'W', 8, 0, 8, 50);
insert into time_slot values ('A', 'F', 8, 0, 8, 50);
insert into time_slot values ('B', 'M', 9, 0, 9, 50);
insert into time_slot values ('B', 'W', 9, 0, 9, 50);
insert into time_slot values ('B', 'F', 9, 0, 9, 50);
insert into time_slot values ('C', 'M', 11, 0, 11, 50);
insert into time_slot values ('C', 'W', 11, 0, 11, 50);
insert into time_slot values ('C', 'F', 11, 0, 11, 50);
insert into time_slot values ('D', 'M', 13, 0, 13, 50);
insert into time_slot values ('D', 'W', 13, 0, 13, 50);
insert into time_slot values ('D', 'F', 13, 0, 13, 50);
insert into time_slot values ('E', 'T', 10, 30, 11, 45);
insert into time_slot values ('E', 'R', 10, 30, 11, 45);
insert into time_slot values ('F', 'T', 14, 30, 15, 45);
insert into time_slot values ('F', 'R', 14, 30, 15, 45);
insert into time_slot values ('G', 'M', 16, 0, 16, 50);
insert into time_slot values ('G', 'W', 16, 0, 16, 50);
insert into time_slot values ('G', 'F', 16, 0, 16, 50);
insert into time_slot values ('H', 'W', 10, 0, 12, 30);

-- Inserting prereq records (course prerequisites)
insert into prereq values ('BIO-301', 'BIO-101');
insert into prereq values ('BIO-399', 'BIO-101');
insert into prereq values ('CS-190', 'CS-101');
insert into prereq values ('CS-315', 'CS-101');
insert into prereq values ('CS-319', 'CS-101');
insert into prereq values ('CS-347', 'CS-101');

--------------------------------------------------------------------------------
-- Now the Query Commands (with full comments)
--------------------------------------------------------------------------------

SELECT * FROM department;

select all dept_name from instructor;

select distinct dept_name from instructor;

select ID, name, dept_name, salary/12 from instructor;

SELECT name
FROM instructor
WHERE dept_name = 'Comp. Sci.'
  AND salary > 80000;

select * from instructor, teaches;

SELECT instructor.name, teaches.course_id
FROM instructor
JOIN teaches ON instructor.ID = teaches.ID;

SELECT instructor.name, teaches.course_id
FROM instructor, teaches
WHERE instructor.ID = teaches.ID;

 

SELECT section.course_id, semester, year, title
FROM section, course
WHERE section.course_id = course.course_id
  AND course.dept_name = 'Comp. Sci.';

SELECT SUBSTR(title, 1, 3)
FROM course;

SELECT *
FROM course
WHERE course_id LIKE '____101%';

select id,substr(dept_name,4,3),salary,salary+200 sa_with_bonus,salary/12 as monthly_salary from instructor;

select * from teaches;

select count(*) from teaches;

select * from instructor;

select count(*) from instructor;

select * from instructor,teaches;


select count(*) from instructor,teaches;

select * from instructor,teaches
where instructor.id = teaches.id;

select count(*) from instructor,teaches
where instructor.id = teaches.id;

select * from instructor natural join teaches;

select * from instructor natural join teaches
where dept_name = 'Comp. Sci.';

select * from instructor,teaches
where instructor.id = teaches.id and dept_name = 'Comp. Sci.';

 



select * from instructor  T, instructor S;
select count(*) from instructor  T, instructor S;

select * from instructor  T, instructor S
where T.salary>S.salary;

select count(*) from instructor  T, instructor S
where T.salary>S.salary;

select * from instructor  T, instructor S
where S.dept_name = 'Comp. Sci.';

select count(*) from instructor  T, instructor S
where S.dept_name = 'Comp. Sci.';

select * from instructor  T, instructor S
where T.salary>S.salary and S.dept_name = 'Comp. Sci.';

select count(*) from instructor  T, instructor S
where T.salary>S.salary and S.dept_name = 'Comp. Sci.';

SELECT DISTINCT T.name
FROM instructor T, instructor S
WHERE T.salary > S.salary
  AND S.dept_name = 'Comp. Sci.';

SELECT name from instructor where name like '%dar%';

SELECT * from instructor where name like '%an%';

SELECT name from instructor where name like '%an%';

SELECT * from instructor where name like '___i%';

SELECT * from instructor where name like '__a%';

SELECT * from instructor where name like '____%';

SELECT * from instructor where name not like '____%';

SELECT * FROM student;

SELECT * from student where name like '____%';

SELECT * from instructor where name like '____';

SELECT * from instructor where name not like '____';

SELECT * from instructor where name like '___a__';

SELECT * from student where name like 'P__%';

SELECT substr(dept_name,3,2),upper(dept_name),lower(dept_name),length(dept_name) from department;

SELECT substr(dept_name,3,2),upper(dept_name),lower(dept_name),length(dept_name), dept_name ||' ' || building from department;

SELECT * from instructor order by name;

SELECT * from instructor order by name desc;

SELECT * from instructor order by dept_name,name desc;

SELECT * from instructor order by dept_name desc,name desc;

SELECT * from instructor order by name,salary desc;


select * from instructor where salary between 90000 and 100000;

select * from instructor where salary >= 90000 and salary <= 100000;

select * from instructor where not(salary >= 90000 and salary <= 100000);

select * from instructor where (salary != 90000 and salary <= 100000);

select * from instructor where not(salary != 90000 and salary <= 100000);

select * from instructor where not(salary <> 90000 and salary <= 100000);

SELECT name,course_id
from instructor,teaches
where instructor.ID = teaches.ID and dept_name = 'Biology';

SELECT name,course_id
from instructor natural join teaches
where dept_name = 'Biology';

select course_id from section where semester = 'Fall' and year = 2017
union
select course_id from section where semester = 'Spring' and year = 2018;

select name,dept_name,salary,salary+100 as Bonus from int_dup where salary is null;

select name,dept_name,salary,salary+100 as Bonus from int_dup where salary is not null;


select name,dept_name,salary,salary+100 as Bonus from int_dup where salary >= null;


select min(salary),max(salary),avg(salary),sum(salary),count(salary) from instructor;

select min(dept_name),max(dept_name) ,count(salary) from instructor;

select dept_name, min(salary),max(salary),avg(salary),sum(salary),count(salary) from instructor group by dept_name;


select name,dept_name,salary,salary+100 as Bonus from int_dup where salary >= null;

select dept_name, min(salary),max(salary),avg(salary),sum(salary),count(salary) from instructor group by dept_name having dept_name in ('Physics','Biology');


select dept_name, min(salary),max(salary),avg(salary),sum(salary),count(salary) from instructor where dept_name = 'Physics' OR dept_name = 'Biology' group by dept_name;


select dept_name, min(salary),max(salary),avg(salary),sum(salary),count(salary) from instructor group by dept_name having dept_name in ('Physics','Biology')
MINUS
select dept_name, min(salary),max(salary),avg(salary),sum(salary),count(salary) from instructor where dept_name = 'Physics' OR dept_name = 'Biology' group by dept_name;



