
-- ==========================================
-- 1. DATABASE CREATION
-- ==========================================

DROP DATABASE IF EXISTS pm105_enrollment;

CREATE DATABASE pm105_enrollment;

USE pm105_enrollment;


-- ==========================================
-- 2. TABLE CREATION
-- ==========================================

CREATE TABLE pm105_Student (
    regno VARCHAR(13) PRIMARY KEY,
    name VARCHAR(25) NOT NULL,
    major VARCHAR(25) NOT NULL,
    bdate DATE NOT NULL
);

CREATE TABLE pm105_Course (
    course INT PRIMARY KEY,
    cname VARCHAR(30) NOT NULL,
    dept VARCHAR(100) NOT NULL
);

CREATE TABLE pm105_Enroll (
    regno VARCHAR(13),
    course INT,
    sem INT NOT NULL,
    marks INT NOT NULL,
    FOREIGN KEY (regno)
        REFERENCES pm105_Student(regno)
        ON DELETE CASCADE,
    FOREIGN KEY (course)
        REFERENCES pm105_Course(course)
        ON DELETE CASCADE
);

CREATE TABLE pm105_TextBook (
    bookIsbn INT NOT NULL,
    book_title VARCHAR(40) NOT NULL,
    publisher VARCHAR(25) NOT NULL,
    author VARCHAR(25) NOT NULL,
    PRIMARY KEY (bookIsbn)
);

CREATE TABLE pm105_BookAdoption (
    course INT NOT NULL,
    sem INT NOT NULL,
    bookIsbn INT NOT NULL,
    FOREIGN KEY (bookIsbn)
        REFERENCES pm105_TextBook(bookIsbn)
        ON DELETE CASCADE,
    FOREIGN KEY (course)
        REFERENCES pm105_Course(course)
        ON DELETE CASCADE
);


-- ==========================================
-- 3. INSERTING RECORDS
-- ==========================================

INSERT INTO pm105_Student VALUES
("01HF235", "Student_1", "CSE", "2001-05-15"),
("01HF354", "Student_2", "Literature", "2002-06-10"),
("01HF254", "Student_3", "Philosophy", "2000-04-04"),
("01HF653", "Student_4", "History", "2003-10-12"),
("01HF234", "Student_5", "Computer Economics", "2001-10-10");


INSERT INTO pm105_Course VALUES
(001, "DBMS", "CS"),
(002, "Literature", "English"),
(003, "Philosophy", "Philosphy"),
(004, "History", "Social Science"),
(005, "Computer Economics", "CS");


INSERT INTO pm105_Enroll VALUES
("01HF235", 001, 5, 85),
("01HF354", 002, 6, 87),
("01HF254", 003, 3, 95),
("01HF653", 004, 3, 80),
("01HF234", 005, 5, 75);


INSERT INTO pm105_TextBook VALUES
(241563, "Operating Systems", "Pearson", "Silberschatz"),
(532678, "Complete Works of Shakesphere", "Oxford", "Shakesphere"),
(453723, "Immanuel Kant", "Delphi Classics", "Immanuel Kant"),
(278345, "History of the world", "The Times", "Richard Overy"),
(426784, "Behavioural Economics", "Pearson", "David Orrel");


INSERT INTO pm105_BookAdoption VALUES
(001, 5, 241563),
(002, 6, 532678),
(003, 3, 453723),
(004, 3, 278345),
(001, 6, 426784);


-- ==========================================
-- 4. DISPLAY ALL TABLES
-- ==========================================

SELECT * FROM pm105_Student;

SELECT * FROM pm105_Course;

SELECT * FROM pm105_Enroll;

SELECT * FROM pm105_BookAdoption;

SELECT * FROM pm105_TextBook;


-- ==========================================
-- 5. ADD A NEW TEXTBOOK
-- AND ADOPT IT FOR A COURSE
-- ==========================================

INSERT INTO pm105_TextBook VALUES
(123456, "Chandan The Autobiography", "Pearson", "Chandan");

SELECT * FROM pm105_TextBook;


INSERT INTO pm105_BookAdoption VALUES
(001, 5, 123456);

SELECT * FROM pm105_BookAdoption;


-- ==========================================
-- 6. BOOKS FOR CS DEPARTMENT COURSES
-- THAT USE MORE THAN TWO BOOKS
-- ==========================================

SELECT c.course, t.bookIsbn, t.book_title
FROM pm105_Course c,
     pm105_BookAdoption ba,
     pm105_TextBook t
WHERE c.course = ba.course
AND ba.bookIsbn = t.bookIsbn
AND c.dept = 'CS'
AND 2 < (
    SELECT COUNT(bookIsbn)
    FROM pm105_BookAdoption b
    WHERE c.course = b.course
)
ORDER BY t.book_title;


-- ==========================================
-- 7. DEPARTMENTS HAVING ALL ADOPTED BOOKS
-- PUBLISHED BY A SPECIFIC PUBLISHER
-- ==========================================

SELECT DISTINCT c.dept
FROM pm105_Course c
WHERE c.dept IN
(
    SELECT c.dept
    FROM pm105_Course c,
         pm105_BookAdoption b,
         pm105_TextBook t
    WHERE c.course = b.course
    AND t.bookIsbn = b.bookIsbn
    AND t.publisher = 'PEARSON'
)
AND c.dept NOT IN
(
    SELECT c.dept
    FROM pm105_Course c,
         pm105_BookAdoption b,
         pm105_TextBook t
    WHERE c.course = b.course
    AND t.bookIsbn = b.bookIsbn
    AND t.publisher != 'PEARSON'
);


-- ==========================================
-- 8. STUDENTS WHO SCORED MAXIMUM MARKS
-- IN DBMS COURSE
-- ==========================================

SELECT name
FROM pm105_Student s,
     pm105_Enroll e,
     pm105_Course c
WHERE s.regno = e.regno
AND e.course = c.course
AND c.cname = "DBMS"
AND e.marks IN
(
    SELECT MAX(marks)
    FROM pm105_Enroll e1,
         pm105_Course c1
    WHERE c1.cname = "DBMS"
    AND c1.course = e1.course
);


-- ==========================================
-- 9. CREATE VIEW
-- DISPLAY COURSES OPTED BY A STUDENT
-- ALONG WITH MARKS OBTAINED
-- ==========================================

CREATE VIEW pm105_CoursesOptedByStudent AS
SELECT c.cname, e.marks
FROM pm105_Course c,
     pm105_Enroll e
WHERE e.course = c.course
AND e.regno = "01HF235";


-- DISPLAY VIEW

SELECT * FROM pm105_CoursesOptedByStudent;


-- ==========================================
-- 10. CREATE TRIGGER
-- PREVENT ENROLLMENT IF MARKS ARE BELOW 40
-- ==========================================

DELIMITER //

CREATE TRIGGER pm105_PreventEnrollment
BEFORE INSERT ON pm105_Enroll
FOR EACH ROW
BEGIN

    IF (NEW.marks < 40) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Marks below threshold';

    END IF;

END//

DELIMITER ;


-- ==========================================
-- 11. TEST THE TRIGGER
-- ==========================================

INSERT INTO pm105_Enroll VALUES
("01HF235", 002, 5, 5);


-- DISPLAY ENROLLMENT RECORDS

SELECT * FROM pm105_Enroll;
