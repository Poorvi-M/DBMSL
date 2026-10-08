CREATE DATABASE IF NOT EXISTS company_db;
USE company_db;
 
CREATE TABLE Employee (
    SSN       VARCHAR(10)   NOT NULL,
    Name      VARCHAR(40)   NOT NULL,
    Address   VARCHAR(100),
    Sex       CHAR(1),
    Salary    DECIMAL(10,2),
    SuperSSN  VARCHAR(10),
    DNo       INT,
    CONSTRAINT pk_employee PRIMARY KEY (SSN),
    CONSTRAINT chk_sex    CHECK (Sex IN ('M','F','O')),
    CONSTRAINT chk_salary CHECK (Salary > 0),
    CONSTRAINT fk_emp_super FOREIGN KEY (SuperSSN) REFERENCES Employee(SSN) ON DELETE SET NULL
);
 
CREATE TABLE Department (
    DNo           INT         NOT NULL,
    DName         VARCHAR(30) NOT NULL,
    MgrSSN        VARCHAR(10),
    MgrStartDate  DATE,
    CONSTRAINT pk_dept PRIMARY KEY (DNo),
    CONSTRAINT uq_dname UNIQUE (DName),
    CONSTRAINT fk_dept_mgr FOREIGN KEY (MgrSSN) REFERENCES Employee(SSN) ON DELETE SET NULL
);
 
ALTER TABLE Employee ADD CONSTRAINT fk_emp_dept
      FOREIGN KEY (DNo) REFERENCES Department(DNo) ON DELETE SET NULL;
 
CREATE TABLE DLocation (
    DNo   INT         NOT NULL,
    DLoc  VARCHAR(30) NOT NULL,
    CONSTRAINT pk_dloc PRIMARY KEY (DNo, DLoc),
    CONSTRAINT fk_dloc_dept FOREIGN KEY (DNo) REFERENCES Department(DNo) ON DELETE CASCADE
);
 
CREATE TABLE Project (
    PNo        INT         NOT NULL,
    PName      VARCHAR(30) NOT NULL,
    PLocation  VARCHAR(30),
    DNo        INT         NOT NULL,
    CONSTRAINT pk_project PRIMARY KEY (PNo),
    CONSTRAINT fk_proj_dept FOREIGN KEY (DNo) REFERENCES Department(DNo) ON DELETE CASCADE
);
 
CREATE TABLE Works_on (
    SSN    VARCHAR(10) NOT NULL,
    PNo    INT         NOT NULL,
    Hours  DECIMAL(4,1),
    CONSTRAINT pk_works PRIMARY KEY (SSN, PNo),
    CONSTRAINT fk_wo_emp  FOREIGN KEY (SSN) REFERENCES Employee(SSN) ON DELETE CASCADE,
    CONSTRAINT fk_wo_proj FOREIGN KEY (PNo) REFERENCES Project(PNo)  ON DELETE CASCADE,
    CONSTRAINT chk_hours CHECK (Hours >= 0)
);
 
-- Employees first (DNo left NULL), then departments, then fix DNo
INSERT INTO Employee (SSN,Name,Address,Sex,Salary,SuperSSN,DNo) VALUES
 ('E001','Rajesh','Mysuru','M',90000,NULL,NULL);
INSERT INTO Employee (SSN,Name,Address,Sex,Salary,SuperSSN,DNo) VALUES
 ('E002','Priya','Bengaluru','F',75000,'E001',NULL),
 ('E003','Suresh','Mysuru','M',60000,'E001',NULL),
 ('E004','Anjali','Mandya','F',55000,'E002',NULL),
 ('E005','Vikram','Hassan','M',50000,'E002',NULL);
 
INSERT INTO Department VALUES
 (1,'Admin','E001','2020-01-01'),(2,'Research','E002','2021-04-15'),
 (3,'Accounts','E003','2019-07-01'),(4,'Marketing','E004','2022-09-10'),
 (5,'IT','E005','2023-02-20');
 
UPDATE Employee SET DNo = 1 WHERE SSN = 'E001';
UPDATE Employee SET DNo = 2 WHERE SSN = 'E002';
UPDATE Employee SET DNo = 3 WHERE SSN = 'E003';
UPDATE Employee SET DNo = 4 WHERE SSN = 'E004';
UPDATE Employee SET DNo = 5 WHERE SSN = 'E005';
 
INSERT INTO DLocation VALUES
 (1,'Mysuru'),(2,'Bengaluru'),(3,'Mysuru'),(4,'Chennai'),(5,'Bengaluru');
 
INSERT INTO Project VALUES
 (1,'Payroll','Mysuru',1),(2,'Genomics','Bengaluru',2),(3,'Audit','Mysuru',3),
 (4,'Campaign','Chennai',4),(5,'Portal','Bengaluru',5);
 
INSERT INTO Works_on VALUES
 ('E001',1,20),('E002',2,30),('E003',3,25),('E004',4,35),('E005',5,40),('E001',2,10);
 
-- ---- ALTER ----
ALTER TABLE Employee ADD COLUMN Email VARCHAR(50);
ALTER TABLE Project  ADD COLUMN Budget INT;
ALTER TABLE Project  DROP COLUMN Budget;
 
ALTER TABLE Employee ADD CONSTRAINT uq_emp_email UNIQUE (Email);
ALTER TABLE Employee DROP INDEX uq_emp_email;
 
ALTER TABLE Employee DROP CHECK chk_salary;
ALTER TABLE Employee ADD CONSTRAINT chk_salary CHECK (Salary > 0);
 
ALTER TABLE Works_on DROP FOREIGN KEY fk_wo_proj;
ALTER TABLE Works_on ADD CONSTRAINT fk_wo_proj
      FOREIGN KEY (PNo) REFERENCES Project(PNo) ON DELETE CASCADE;
 
-- ---- UPDATE / DELETE ----
UPDATE Employee SET Salary = Salary * 1.10 WHERE DNo = 2;
UPDATE Works_on SET Hours = 45 WHERE SSN = 'E005' AND PNo = 5;
UPDATE Department SET MgrStartDate = '2024-01-01' WHERE DNo = 4;
 
DELETE FROM Works_on WHERE SSN = 'E001' AND PNo = 2;
DELETE FROM DLocation WHERE DNo = 5 AND DLoc = 'Bengaluru';
DELETE FROM Employee WHERE SSN = 'E005';   -- cascades Works_on; Department 5 MgrSSN set NULL
