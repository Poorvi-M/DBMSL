CREATE DATABASE IF NOT EXISTS student;
USE student;

CREATE TABLE IF NOT EXISTS student (
    SID INT PRIMARY KEY,
    Name VARCHAR(50),
    Branch VARCHAR(10),
    Semester INT,
    Address VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(50)
);

INSERT INTO student (SID, Name, Branch, Semester, Address, Phone, Email)
VALUES
(1, 'John Doe', 'CSE', 3, 'Kuvempunagar', '1234567890', 'john@example.com'),
(2, 'Jane Smith', 'ECE', 2, 'Saraswathipuram', '0986321490', 'jane@example.com'),
(3, 'Sam William', 'CSE', 4, 'Vijayanagar', '1234567890', 'sam@example.com'),
(4, 'Lisa Ray', 'EEE', 2, 'Kuvempunagar', '8329687712', 'lisa@example.com'),
(5, 'Anna Brown', 'MECH', 1, 'Hebbal', '5678901234', 'anna@example.com'),
(6, 'Mark Taylor', 'CSE', 4, 'Saraswathipuram', '7890123456', 'mark@example.com'),
(7, 'Tom Lee', 'CSE', 3, 'Kuvempunagar', '4758632019', 'tom@example.com'),
(8, 'Emily Clark', 'CSE', 3, 'Kuvempunagar', '6789012345', 'emily@example.com'),
(9, 'James Bond', 'CIVIL', 1, 'Tayalakshmipuram', '8901234567', 'james@example.com'),
(10, 'Sarah Connor', 'CSE', 2, 'Hebbal', '9012345678', 'sarah@example.com');

INSERT INTO student (SID, Name, Branch, Semester, Address, Phone, Email)
VALUES (11, 'New Student', 'CSE', 2, 'Kuvempunagar', '9412345678', 'newstudent@example.com');

UPDATE student
SET Address = 'Vijayanagar'
WHERE SID = 11;

DELETE FROM student
WHERE SID = 11;

SELECT * FROM student;

SELECT *
FROM student
WHERE Branch = 'CSE';

SELECT *
FROM student
WHERE Branch = 'CSE'
AND Address = 'Kuvempunagar';
