CREATE DATABASE IF NOT EXISTS sailors_db;
USE sailors_db;
 
CREATE TABLE Sailors (
    sid     INT          NOT NULL,
    sname   VARCHAR(30)  NOT NULL,
    rating  INT,
    age     INT,
    CONSTRAINT pk_sailors PRIMARY KEY (sid),
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 10)
);
 
CREATE TABLE Boat (
    bid    INT         NOT NULL,
    bname  VARCHAR(30) NOT NULL,
    color  VARCHAR(15),
    CONSTRAINT pk_boat PRIMARY KEY (bid)
);
 
CREATE TABLE Reserves (
    sid    INT  NOT NULL,
    bid    INT  NOT NULL,
    rdate  DATE NOT NULL,
    CONSTRAINT pk_reserves PRIMARY KEY (sid, bid, rdate),
    CONSTRAINT fk_res_sailor FOREIGN KEY (sid) REFERENCES Sailors(sid) ON DELETE CASCADE,
    CONSTRAINT fk_res_boat   FOREIGN KEY (bid) REFERENCES Boat(bid)    ON DELETE CASCADE
);
 
INSERT INTO Sailors VALUES
 (22,'Dustin',7,45),(29,'Brutus',1,33),(31,'Lubber',8,55),
 (58,'Rusty',10,35),(64,'Horatio',7,35);
 
INSERT INTO Boat VALUES
 (101,'Interlake','blue'),(102,'Interlake','red'),(103,'Clipper','green'),
 (104,'Marine','red'),(105,'Marine','blue');
 
INSERT INTO Reserves VALUES
 (22,101,'2026-01-10'),(22,102,'2026-01-12'),(29,101,'2026-02-05'),
 (31,103,'2026-02-18'),(58,104,'2026-03-01');
 
-- ---- ALTER: add / drop columns ----
ALTER TABLE Sailors ADD COLUMN city VARCHAR(30);
ALTER TABLE Boat    ADD COLUMN capacity INT DEFAULT 4;
ALTER TABLE Boat    DROP COLUMN capacity;
ALTER TABLE Sailors MODIFY sname VARCHAR(50) NOT NULL;      -- change data type/size
 
-- ---- ALTER: add / drop constraints ----
ALTER TABLE Sailors ADD CONSTRAINT chk_age CHECK (age >= 18);
ALTER TABLE Sailors DROP CHECK chk_age;
 
ALTER TABLE Sailors ADD CONSTRAINT uq_sname UNIQUE (sname);
ALTER TABLE Sailors DROP INDEX uq_sname;
 
ALTER TABLE Boat MODIFY color VARCHAR(15) NOT NULL;          -- add NOT NULL
ALTER TABLE Boat MODIFY color VARCHAR(15) NULL;              -- drop NOT NULL
 
ALTER TABLE Reserves DROP FOREIGN KEY fk_res_boat;           -- drop FK
ALTER TABLE Reserves ADD CONSTRAINT fk_res_boat
      FOREIGN KEY (bid) REFERENCES Boat(bid) ON DELETE CASCADE;  -- add FK back
 
-- ---- UPDATE / DELETE ----
UPDATE Sailors SET rating = rating + 1 WHERE sname = 'Dustin';
UPDATE Sailors SET city = 'Mysuru' WHERE sid IN (22, 29);
UPDATE Boat    SET color = 'yellow' WHERE bid = 103;
 
DELETE FROM Reserves WHERE bid = 104;
DELETE FROM Sailors  WHERE sid = 64;     -- no reservations
DELETE FROM Boat     WHERE bid = 105;
