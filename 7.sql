
-- ==========================================
-- 1. DATABASE CREATION
-- ==========================================

DROP DATABASE IF EXISTS company_pm105;
CREATE DATABASE company_pm105;
USE company_pm105;


-- ==========================================
-- 2. TABLE CREATION
-- ==========================================

CREATE TABLE IF NOT EXISTS Employee_pm105 (
    ssn VARCHAR(35) PRIMARY KEY,
    name VARCHAR(35) NOT NULL,
    address VARCHAR(255) NOT NULL,
    sex VARCHAR(7) NOT NULL,
    salary INT NOT NULL,
    super_ssn VARCHAR(35),
    d_no INT,
    FOREIGN KEY (super_ssn)
        REFERENCES Employee_pm105(ssn)
        ON DELETE SET NULL
);


CREATE TABLE IF NOT EXISTS Department_pm105 (
    d_no INT PRIMARY KEY,
    dname VARCHAR(100) NOT NULL,
    mgr_ssn VARCHAR(35),
    mgr_start_date DATE,
    FOREIGN KEY (mgr_ssn)
        REFERENCES Employee_pm105(ssn)
        ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS DLocation_pm105 (
    d_no INT NOT NULL,
    d_loc VARCHAR(100) NOT NULL,
    FOREIGN KEY (d_no)
        REFERENCES Department_pm105(d_no)
        ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Project_pm105 (
    p_no INT PRIMARY KEY,
    p_name VARCHAR(25) NOT NULL,
    p_loc VARCHAR(25) NOT NULL,
    d_no INT NOT NULL,
    FOREIGN KEY (d_no)
        REFERENCES Department_pm105(d_no)
        ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS WorksOn_pm105 (
    ssn VARCHAR(35) NOT NULL,
    p_no INT NOT NULL,
    hours INT NOT NULL DEFAULT 0,
    FOREIGN KEY (ssn)
        REFERENCES Employee_pm105(ssn)
        ON DELETE CASCADE,
    FOREIGN KEY (p_no)
        REFERENCES Project_pm105(p_no)
        ON DELETE CASCADE
);


-- ==========================================
-- 3. INSERT RECORDS
-- ==========================================

INSERT INTO Employee_pm105 VALUES
("01NB235", "Chandan_Krishna", "Siddartha Nagar, Mysuru",
 "Male", 1500000, "01NB235", 5),

("01NB354", "Employee_2", "Lakshmipuram, Mysuru",
 "Female", 1200000, "01NB235", 2),

("02NB254", "Employee_3", "Pune, Maharashtra",
 "Male", 1000000, "01NB235", 4),

("03NB653", "Employee_4", "Hyderabad, Telangana",
 "Male", 2500000, "01NB354", 5),

("04NB234", "Employee_5", "JP Nagar, Bengaluru",
 "Female", 1700000, "01NB354", 1);


INSERT INTO Department_pm105 VALUES
(001, "Human Resources", "01NB235", "2020-10-21"),
(002, "Quality Assesment", "03NB653", "2020-10-19"),
(003, "System assesment", "04NB234", "2020-10-27"),
(005, "Production", "02NB254", "2020-08-16"),
(004, "Accounts", "01NB354", "2020-09-04");


INSERT INTO DLocation_pm105 VALUES
(001, "Jaynagar, Bengaluru"),
(002, "Vijaynagar, Mysuru"),
(003, "Chennai, Tamil Nadu"),
(004, "Mumbai, Maharashtra"),
(005, "Kuvempunagar, Mysuru");


INSERT INTO Project_pm105 VALUES
(241563, "System Testing", "Mumbai, Maharashtra", 004),
(532678, "IOT", "JP Nagar, Bengaluru", 001),
(453723, "Product Optimization", "Hyderabad, Telangana", 005),
(278345, "Yeild Increase", "Kuvempunagar, Mysuru", 005),
(426784, "Product Refinement", "Saraswatipuram, Mysuru", 002);


INSERT INTO WorksOn_pm105 VALUES
("01NB235", 278345, 5),
("01NB354", 426784, 6),
("04NB234", 532678, 3),
("02NB254", 241563, 3),
("03NB653", 453723, 6);


-- ==========================================
-- 4. DISPLAY ALL TABLES
-- ==========================================

SELECT * FROM Department_pm105;

SELECT * FROM Employee_pm105;

SELECT * FROM DLocation_pm105;

SELECT * FROM Project_pm105;

SELECT * FROM WorksOn_pm105;


-- ==========================================
-- 5. PROJECTS INVOLVING EMPLOYEES
-- WHOSE LAST NAME IS SCOTT
-- ==========================================

SELECT p.p_no, p.p_name, e.name
FROM Project_pm105 p
JOIN Employee_pm105 e
ON p.d_no = e.d_no
WHERE e.name LIKE "%Krishna";


-- ==========================================
-- 6. SHOW SALARIES AFTER 10% RAISE
-- FOR EMPLOYEES WORKING ON IOT PROJECT
-- ==========================================

SELECT w.ssn, e.name,
       e.salary AS old_salary,
       e.salary * 1.1 AS new_salary
FROM WorksOn_pm105 w
JOIN Employee_pm105 e
ON w.ssn = e.ssn
WHERE w.p_no =
(
    SELECT p_no
    FROM Project_pm105
    WHERE p_name = "IOT"
);


-- ==========================================
-- 7. SALARY AGGREGATES FOR ACCOUNTS DEPARTMENT
-- ==========================================

SELECT
    SUM(salary) AS sal_sum,
    MAX(salary) AS sal_max,
    MIN(salary) AS sal_min,
    AVG(salary) AS sal_avg
FROM Employee_pm105 e
JOIN Department_pm105 d
ON e.d_no = d.d_no
WHERE d.dname = "Accounts";


-- ==========================================
-- 8. EMPLOYEES WORKING ON ALL PROJECTS
-- CONTROLLED BY DEPARTMENT 1
-- USING NOT EXISTS
-- ==========================================

SELECT e.ssn, e.name, e.d_no
FROM Employee_pm105 e
WHERE NOT EXISTS
(
    SELECT p.p_no
    FROM Project_pm105 p
    WHERE p.d_no = 1
    AND p.p_no NOT IN
    (
        SELECT w.p_no
        FROM WorksOn_pm105 w
        WHERE w.ssn = e.ssn
    )
);


-- ==========================================
-- 9. DEPARTMENTS HAVING MORE THAN ONE EMPLOYEE
-- WHO EARN MORE THAN 6,00,000
-- ==========================================

SELECT d.d_no, COUNT(*) AS employee_count
FROM Department_pm105 d
JOIN Employee_pm105 e
ON e.d_no = d.d_no
WHERE e.salary > 600000
GROUP BY d.d_no
HAVING COUNT(*) > 1;


-- ==========================================
-- 10. CREATE VIEW
-- EMPLOYEE NAME, DEPARTMENT NAME AND LOCATION
-- ==========================================

CREATE VIEW emp_details_pm105 AS
SELECT e.name, d.dname, dl.d_loc
FROM Employee_pm105 e
JOIN Department_pm105 d
ON e.d_no = d.d_no
JOIN DLocation_pm105 dl
ON d.d_no = dl.d_no;


-- DISPLAY VIEW

SELECT * FROM emp_details_pm105;


-- ==========================================
-- 11. CREATE TRIGGER
-- PREVENT DELETION OF PROJECTS
-- IF EMPLOYEES ARE WORKING ON THEM
-- ==========================================

DELIMITER //

CREATE TRIGGER PreventDelete_pm105
BEFORE DELETE ON Project_pm105
FOR EACH ROW
BEGIN

    IF EXISTS
    (
        SELECT *
        FROM WorksOn_pm105
        WHERE p_no = OLD.p_no
    )
    THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'This project has an employee assigned';

    END IF;

END//

DELIMITER ;


-- ==========================================
-- 12. TEST THE TRIGGER
-- ==========================================

DELETE FROM Project_pm105
WHERE p_no = 241563;
