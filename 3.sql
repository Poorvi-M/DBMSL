
-- ==========================================
-- 1. DATABASE CREATION
-- ==========================================

CREATE DATABASE IF NOT EXISTS sailors_db;
USE sailors_db;


-- ==========================================
-- 2. TABLE CREATION
-- ==========================================

CREATE TABLE Sailors (
    sid     INT NOT NULL,
    sname   VARCHAR(30) NOT NULL,
    rating  INT,
    age     INT,
    CONSTRAINT pk_sailors PRIMARY KEY (sid),
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 10)
);

CREATE TABLE Boat (
    bid    INT NOT NULL,
    bname  VARCHAR(30) NOT NULL,
    color  VARCHAR(15),
    CONSTRAINT pk_boat PRIMARY KEY (bid)
);

CREATE TABLE Reserves (
    sid    INT NOT NULL,
    bid    INT NOT NULL,
    rdate  DATE NOT NULL,
    CONSTRAINT pk_reserves PRIMARY KEY (sid, bid, rdate),
    CONSTRAINT fk_res_sailor FOREIGN KEY (sid)
        REFERENCES Sailors(sid) ON DELETE CASCADE,
    CONSTRAINT fk_res_boat FOREIGN KEY (bid)
        REFERENCES Boat(bid) ON DELETE CASCADE
);


-- ==========================================
-- 3. INSERTING RECORDS
-- ==========================================

INSERT INTO Sailors VALUES
(22,'Dustin',7,45),
(29,'Brutus',1,33),
(31,'Lubber',8,55),
(58,'Rusty',10,35),
(64,'Horatio',7,35);

INSERT INTO Boat VALUES
(101,'Interlake','blue'),
(102,'Interlake','red'),
(103,'Clipper','green'),
(104,'Marine','red'),
(105,'Marine','blue');

INSERT INTO Reserves VALUES
(22,101,'2026-01-10'),
(22,102,'2026-01-12'),
(29,101,'2026-02-05'),
(31,103,'2026-02-18'),
(58,104,'2026-03-01');


-- ==========================================
-- 4. ALTER TABLE: ADD / DROP COLUMNS
-- ==========================================

ALTER TABLE Sailors ADD COLUMN city VARCHAR(30);

ALTER TABLE Boat ADD COLUMN capacity INT DEFAULT 4;

ALTER TABLE Boat DROP COLUMN capacity;

ALTER TABLE Sailors MODIFY sname VARCHAR(50) NOT NULL;


-- ==========================================
-- 5. ALTER TABLE: ADD / DROP CONSTRAINTS
-- ==========================================

ALTER TABLE Sailors
ADD CONSTRAINT chk_age CHECK (age >= 18);

ALTER TABLE Sailors DROP CHECK chk_age;

ALTER TABLE Sailors
ADD CONSTRAINT uq_sname UNIQUE (sname);

ALTER TABLE Sailors DROP INDEX uq_sname;

ALTER TABLE Boat MODIFY color VARCHAR(15) NOT NULL;

ALTER TABLE Boat MODIFY color VARCHAR(15) NULL;

ALTER TABLE Reserves DROP FOREIGN KEY fk_res_boat;

ALTER TABLE Reserves
ADD CONSTRAINT fk_res_boat
FOREIGN KEY (bid) REFERENCES Boat(bid) ON DELETE CASCADE;


-- ==========================================
-- 6. UPDATE AND DELETE OPERATIONS
-- ==========================================

UPDATE Sailors
SET rating = rating + 1
WHERE sname = 'Dustin';

UPDATE Sailors
SET city = 'Mysuru'
WHERE sid IN (22, 29);

UPDATE Boat
SET color = 'yellow'
WHERE bid = 103;

DELETE FROM Reserves WHERE bid = 104;

DELETE FROM Sailors WHERE sid = 64;

DELETE FROM Boat WHERE bid = 105;


-- ==========================================
-- 7. DISPLAY TABLE RECORDS
-- ==========================================

SELECT * FROM Sailors;

SELECT * FROM Boat;

SELECT * FROM Reserves;


-- ==========================================
-- 8. JOINS
-- Find the colours of boats reserved by Albert
-- ==========================================

SELECT color
FROM Sailors s, Boat b, Reserves r
WHERE s.sid = r.sid
AND b.bid = r.bid
AND s.sname = 'Albert';


-- ==========================================
-- 9. UNION
-- Find sailor sids who have rating >= 8
-- OR have reserved boat 103
-- ==========================================

(SELECT sid
 FROM Sailors
 WHERE rating >= 8)

UNION

(SELECT sid
 FROM Reserves
 WHERE bid = 103);


-- ==========================================
-- 10. NESTED QUERY WITH NOT IN
-- Find names of sailors who have not reserved
-- a boat whose name contains the string "storm"
-- Order names in ascending order
-- ==========================================

SELECT s.sname
FROM Sailors s
WHERE s.sid NOT IN
(
    SELECT s1.sid
    FROM Sailors s1, Reserves r1
    WHERE r1.sid = s1.sid
    AND s1.sname LIKE '%storm%'
)
AND s.sname LIKE '%storm%'
ORDER BY s.sname ASC;


-- ==========================================
-- 11. NESTED QUERY WITH DOUBLE NOT EXISTS
-- Find names of sailors who have reserved all boats
-- ==========================================

SELECT sname
FROM Sailors s
WHERE NOT EXISTS
(
    SELECT *
    FROM Boat b
    WHERE NOT EXISTS
    (
        SELECT *
        FROM Reserves r
        WHERE r.sid = s.sid
        AND b.bid = r.bid
    )
);


-- ==========================================
-- 12. AGGREGATE FUNCTION WITH SUBQUERY
-- Find the name and age of the oldest sailor
-- ==========================================

SELECT sname, age
FROM Sailors
WHERE age IN
(
    SELECT MAX(age)
    FROM Sailors
);


-- ==========================================
-- 13. GROUP BY AND HAVING
-- For each boat reserved by at least 2 sailors
-- with age >= 40, find bid and average age
-- ==========================================

SELECT b.bid, AVG(s.age) AS average_age
FROM Sailors s, Boat b, Reserves r
WHERE r.sid = s.sid
AND r.bid = b.bid
AND s.age >= 40
GROUP BY b.bid
HAVING COUNT(DISTINCT r.sid) >= 2;


-- ==========================================
-- 14. CREATE VIEW
-- Show names and colours of boats reserved
-- by sailors having a specific rating (5)
-- ==========================================

CREATE VIEW ReservedBoatsWithRatedSailor AS
SELECT DISTINCT b.bname, b.color
FROM Sailors s, Boat b, Reserves r
WHERE s.sid = r.sid
AND b.bid = r.bid
AND s.rating = 5;


-- Display the view

SELECT * FROM ReservedBoatsWithRatedSailor;


-- ==========================================
-- 15. TRIGGER
-- Prevent deletion of boats having active reservations
-- ==========================================

DELIMITER //

CREATE TRIGGER CheckAndDelete
BEFORE DELETE ON Boat
FOR EACH ROW
BEGIN

    IF EXISTS
    (
        SELECT *
        FROM Reserves
        WHERE Reserves.bid = OLD.bid
    )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Boat is reserved and hence cannot be deleted';
    END IF;

END//

DELIMITER ;


-- ==========================================
-- 16. TEST THE TRIGGER
-- This should produce an error if boat 103
-- has an active reservation
-- ==========================================

DELETE FROM Boat WHERE bid = 103;
