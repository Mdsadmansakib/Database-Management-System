-- Branch table creation
CREATE TABLE branch (
    branch_name VARCHAR2(15) PRIMARY KEY,
    branch_city VARCHAR2(12) NOT NULL,
    assets NUMBER(12) CHECK (assets >= 100000)
);

-- Customer table creation
CREATE TABLE customer (
    customer_id VARCHAR2(5),
    customer_name VARCHAR2(15),
    customer_street VARCHAR2(12),
    customer_city VARCHAR2(12) NOT NULL,
    cell VARCHAR2(11) UNIQUE,
    dob DATE NOT NULL,
    PRIMARY KEY (customer_id)
);

-- Account table creation
CREATE TABLE account (
    account_no CHAR(5),
    branch_name VARCHAR2(15),
    balance NUMBER(10,2) NOT NULL,
    CONSTRAINT pk_acc_no PRIMARY KEY (account_no),
    CONSTRAINT fk_acc_br_nm FOREIGN KEY (branch_name) REFERENCES branch(branch_name),
    CONSTRAINT chk_acc_bal CHECK (balance >= 0),
    CONSTRAINT chk_acc_acc_no CHECK (account_no LIKE 'A-%')
);

-- Loan table creation
CREATE TABLE loan (
    loan_no CHAR(5),
    branch_name VARCHAR2(15),
    amount NUMBER(10,2) NOT NULL,
    CONSTRAINT pk_loan_no PRIMARY KEY (loan_no),
    CONSTRAINT fk_loan_br_nm FOREIGN KEY (branch_name) REFERENCES branch(branch_name),
    CONSTRAINT chk_loan_amt CHECK (amount >= 0),
    CONSTRAINT chk_loan_no CHECK (loan_no LIKE 'L-%')
);

-- Depositor table creation
CREATE TABLE depositor (
    customer_id VARCHAR2(5),
    account_no CHAR(5),
    PRIMARY KEY (customer_id, account_no),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (account_no) REFERENCES account(account_no)
);

-- Borrower table creation
CREATE TABLE borrower (
    customer_id VARCHAR2(5),
    loan_no CHAR(5),
    PRIMARY KEY (customer_id, loan_no),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (loan_no) REFERENCES loan(loan_no)
);

-- Insert into branch
INSERT INTO branch (branch_name, branch_city, assets)
VALUES ('Dhanmondi', 'Dhaka', 10000000);

-- Employee table creation
CREATE TABLE employee (
    emp_id VARCHAR2(6),
    emp_name VARCHAR2(25), -- Fixed typo 'vartchar2' to 'varchar2'
    salary NUMBER(6)
);
