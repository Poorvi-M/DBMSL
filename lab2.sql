CREATE TABLE SAILORS (sid INT PRIMARY KEY, sname VARCHAR(30), rating INT, age INT);
CREATE TABLE BOAT (bid INT PRIMARY KEY, bname VARCHAR(30), color VARCHAR(20));
CREATE TABLE RESERVES (
  sid INT, bid INT, rdate DATE,
  PRIMARY KEY (sid, bid, rdate),
  FOREIGN KEY (sid) REFERENCES SAILORS(sid),
  FOREIGN KEY (bid) REFERENCES BOAT(bid)
);

INSERT INTO SAILORS VALUES
(1,'Albert',7,45), (2,'Bob',8,52), (3,'Carol',9,41), (4,'David',6,40), (5,'Eve',10,48);

INSERT INTO BOAT VALUES
(101,'Interlake','blue'), (102,'Stormchaser','red'), (103,'Clipper','green'),
(104,'Marine','red'), (105,'Thunderstorm','blue');

INSERT INTO RESERVES VALUES
(1,101,'2026-01-10'), (1,102,'2026-01-12'), (1,103,'2026-02-01'),
(2,103,'2026-02-03'), (3,103,'2026-02-15'), (4,103,'2026-03-01'),
(5,101,'2026-03-05'), (5,102,'2026-03-06'), (5,103,'2026-03-07'),
(5,104,'2026-03-08'), (5,105,'2026-03-09');

-- 1. Colors of boats reserved by Albert
SELECT b.color FROM SAILORS s, RESERVES r, BOAT b
WHERE s.sid = r.sid AND r.bid = b.bid AND s.sname = 'Albert';

-- 2. Sailors with rating >= 8 or who reserved boat 103
SELECT sid FROM SAILORS WHERE rating >= 8
UNION
SELECT sid FROM RESERVES WHERE bid = 103;

-- 3. Sailors who have not reserved a "storm" boat
SELECT sname FROM SAILORS
WHERE sid NOT IN (SELECT r.sid FROM RESERVES r, BOAT b
                  WHERE r.bid = b.bid AND b.bname LIKE '%storm%')
ORDER BY sname;

-- 4. Sailors who reserved all boats
SELECT s.sname FROM SAILORS s, RESERVES r
WHERE s.sid = r.sid
GROUP BY s.sid, s.sname
HAVING COUNT(DISTINCT r.bid) = (SELECT COUNT(*) FROM BOAT);

-- 5. Oldest sailor
SELECT sname, age FROM SAILORS WHERE age = (SELECT MAX(age) FROM SAILORS);

-- 6. Boats reserved by at least 5 sailors aged 40+, with their average age
SELECT r.bid, AVG(s.age) FROM RESERVES r, SAILORS s
WHERE r.sid = s.sid AND s.age >= 40
GROUP BY r.bid
HAVING COUNT(DISTINCT s.sid) >= 5;

-- 7. View (filter by rating when you use it)
CREATE VIEW boat_view AS
SELECT s.rating, b.bname, b.color
FROM SAILORS s, RESERVES r, BOAT b
WHERE s.sid = r.sid AND r.bid = b.bid;

SELECT bname, color FROM boat_view WHERE rating = 8;

-- 8. Trigger: block deleting a boat that has reservations
DELIMITER //
CREATE TRIGGER no_boat_delete
BEFORE DELETE ON BOAT
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT * FROM RESERVES WHERE bid = OLD.bid) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Boat has reservations';
  END IF;
END//
DELIMITER ;
