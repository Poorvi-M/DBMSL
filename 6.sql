CREATE DATABASE IF NOT EXISTS student_db;
USE student_db;
 
CREATE TABLE Student (
    regno  VARCHAR(12) NOT NULL,
    name   VARCHAR(40) NOT NULL,
    major  VARCHAR(30),
    bdate  DATE,
    CONSTRAINT pk_student PRIMARY KEY (regno)
);
 
CREATE TABLE Course (
    course_no  INT         NOT NULL,
    cname      VARCHAR(40) NOT NULL,
    dept       VARCHAR(30),
    CONSTRAINT pk_course PRIMARY KEY (course_no)
);
 
CREATE TABLE Textbook (
    book_isbn   INT         NOT NULL,
    book_title  VARCHAR(60) NOT NULL,
    publisher   VARCHAR(40),
    author      VARCHAR(40),
    CONSTRAINT pk_textbook PRIMARY KEY (book_isbn)
);
 
CREATE TABLE Enroll (
    regno      VARCHAR(12) NOT NULL,
    course_no  INT         NOT NULL,
    sem        INT         NOT NULL,
    marks      INT,
    CONSTRAINT pk_enroll PRIMARY KEY (regno, course_no, sem),
    CONSTRAINT fk_enr_stu    FOREIGN KEY (regno)     REFERENCES Student(regno)    ON DELETE CASCADE,
    CONSTRAINT fk_enr_course FOREIGN KEY (course_no) REFERENCES Course(course_no) ON DELETE CASCADE,
    CONSTRAINT chk_marks CHECK (marks BETWEEN 0 AND 100)
);
 
CREATE TABLE Book_adoption (
    course_no  INT NOT NULL,
    sem        INT NOT NULL,
    book_isbn  INT NOT NULL,
    CONSTRAINT pk_book_adopt PRIMARY KEY (course_no, sem, book_isbn),
    CONSTRAINT fk_ba_course FOREIGN KEY (course_no) REFERENCES Course(course_no)   ON DELETE CASCADE,
    CONSTRAINT fk_ba_book   FOREIGN KEY (book_isbn) REFERENCES Textbook(book_isbn) ON DELETE CASCADE
);
 
INSERT INTO Student VALUES
 ('01JST22CS001','Asha','CS','2004-05-12'),('01JST22CS002','Bharath','CS','2004-08-23'),
 ('01JST22EC003','Charan','EC','2003-12-01'),('01JST22IS004','Deepa','IS','2004-02-17'),
 ('01JST22ME005','Esha','ME','2004-11-30');
 
INSERT INTO Course VALUES
 (101,'DBMS','CS'),(102,'Operating Systems','CS'),(103,'Signals','EC'),
 (104,'Thermodynamics','ME'),(105,'Data Structures','IS');
 
INSERT INTO Textbook VALUES
 (1001,'Fundamentals of Database Systems','Pearson','Elmasri'),
 (1002,'Operating System Concepts','Wiley','Silberschatz'),
 (1003,'Signals and Systems','Pearson','Oppenheim'),
 (1004,'Engineering Thermodynamics','McGraw Hill','Nag'),
 (1005,'Data Structures in C','Cengage','Tenenbaum');
 
INSERT INTO Enroll VALUES
 ('01JST22CS001',101,5,88),('01JST22CS001',102,5,92),('01JST22CS002',101,5,76),
 ('01JST22EC003',103,5,81),('01JST22IS004',105,5,69),('01JST22ME005',104,5,73);
 
INSERT INTO Book_adoption VALUES
 (101,5,1001),(102,5,1002),(103,5,1003),(104,5,1004),(105,5,1005);
 
-- ---- ALTER ----
ALTER TABLE Student ADD COLUMN email VARCHAR(50);
ALTER TABLE Course  ADD COLUMN credits INT DEFAULT 3;
ALTER TABLE Course  DROP COLUMN credits;
 
ALTER TABLE Student ADD CONSTRAINT uq_stu_email UNIQUE (email);
ALTER TABLE Student DROP INDEX uq_stu_email;
 
ALTER TABLE Enroll DROP CHECK chk_marks;
ALTER TABLE Enroll ADD CONSTRAINT chk_marks CHECK (marks BETWEEN 0 AND 100);
 
ALTER TABLE Book_adoption DROP FOREIGN KEY fk_ba_book;
ALTER TABLE Book_adoption ADD CONSTRAINT fk_ba_book
      FOREIGN KEY (book_isbn) REFERENCES Textbook(book_isbn) ON DELETE CASCADE;
 
-- ---- UPDATE / DELETE ----
UPDATE Enroll  SET marks = marks + 5 WHERE course_no = 101 AND marks < 80;
UPDATE Student SET major = 'IS' WHERE regno = '01JST22CS002';
UPDATE Textbook SET publisher = 'Pearson Education' WHERE book_isbn = 1001;
 
DELETE FROM Enroll   WHERE regno = '01JST22ME005';
DELETE FROM Student  WHERE regno = '01JST22ME005';
DELETE FROM Book_adoption WHERE course_no = 104;
