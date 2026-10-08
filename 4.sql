CREATE DATABASE IF NOT EXISTS insurance_db;
USE insurance_db;
 
CREATE TABLE Person (
    driver_id  VARCHAR(10)  NOT NULL,
    name       VARCHAR(40)  NOT NULL,
    address    VARCHAR(100),
    CONSTRAINT pk_person PRIMARY KEY (driver_id)
);
 
CREATE TABLE Car (
    regno  VARCHAR(15) NOT NULL,
    model  VARCHAR(30) NOT NULL,
    year   INT,
    CONSTRAINT pk_car PRIMARY KEY (regno),
    CONSTRAINT chk_car_year CHECK (year >= 1990)
);
 
CREATE TABLE Accident (
    report_number  INT          NOT NULL,
    acc_date       DATE         NOT NULL,
    location       VARCHAR(60),
    CONSTRAINT pk_accident PRIMARY KEY (report_number)
);
 
CREATE TABLE Owns (
    driver_id  VARCHAR(10) NOT NULL,
    regno      VARCHAR(15) NOT NULL,
    CONSTRAINT pk_owns PRIMARY KEY (driver_id, regno),
    CONSTRAINT fk_owns_person FOREIGN KEY (driver_id) REFERENCES Person(driver_id) ON DELETE CASCADE,
    CONSTRAINT fk_owns_car    FOREIGN KEY (regno)     REFERENCES Car(regno)        ON DELETE CASCADE
);
 
CREATE TABLE Participated (
    driver_id       VARCHAR(10) NOT NULL,
    regno           VARCHAR(15) NOT NULL,
    report_number   INT         NOT NULL,
    damage_amount   INT,
    CONSTRAINT pk_part PRIMARY KEY (driver_id, regno, report_number),
    CONSTRAINT fk_part_owns FOREIGN KEY (driver_id, regno) REFERENCES Owns(driver_id, regno) ON DELETE CASCADE,
    CONSTRAINT fk_part_acc  FOREIGN KEY (report_number)    REFERENCES Accident(report_number) ON DELETE CASCADE,
    CONSTRAINT chk_damage CHECK (damage_amount >= 0)
);
 
INSERT INTO Person VALUES
 ('D01','Smith','Kuvempunagar, Mysuru'),('D02','Ravi','Vijayanagar, Mysuru'),
 ('D03','Anita','Jayanagar, Bengaluru'),('D04','Kiran','Hebbal, Mysuru'),
 ('D05','Meera','Indiranagar, Bengaluru');
 
INSERT INTO Car VALUES
 ('KA09AB1111','Swift',2018),('KA09CD2222','Creta',2020),('KA01EF3333','i20',2017),
 ('KA09GH4444','Nexon',2022),('KA05IJ5555','Baleno',2019);
 
INSERT INTO Accident VALUES
 (11,'2025-03-14','Mysuru Ring Road'),(12,'2025-06-02','Hunsur Road'),
 (13,'2025-09-21','MG Road, Bengaluru'),(14,'2026-01-09','Nanjangud Road'),
 (15,'2026-02-27','Outer Ring Road, Bengaluru');
 
INSERT INTO Owns VALUES
 ('D01','KA09AB1111'),('D02','KA09CD2222'),('D03','KA01EF3333'),
 ('D04','KA09GH4444'),('D05','KA05IJ5555');
 
INSERT INTO Participated VALUES
 ('D01','KA09AB1111',11,25000),('D02','KA09CD2222',12,40000),
 ('D03','KA01EF3333',13,15000),('D04','KA09GH4444',14,60000),
 ('D05','KA05IJ5555',15,10000);
 
-- ---- ALTER ----
ALTER TABLE Person ADD COLUMN phone VARCHAR(15);
ALTER TABLE Car    ADD COLUMN color VARCHAR(15);
ALTER TABLE Car    DROP COLUMN color;
 
ALTER TABLE Person ADD CONSTRAINT uq_phone UNIQUE (phone);
ALTER TABLE Person DROP INDEX uq_phone;
 
ALTER TABLE Participated DROP CHECK chk_damage;
ALTER TABLE Participated ADD CONSTRAINT chk_damage CHECK (damage_amount >= 0);
 
ALTER TABLE Participated DROP FOREIGN KEY fk_part_acc;
ALTER TABLE Participated ADD CONSTRAINT fk_part_acc
      FOREIGN KEY (report_number) REFERENCES Accident(report_number) ON DELETE CASCADE;
 
-- ---- UPDATE / DELETE ----
UPDATE Participated SET damage_amount = 25000
 WHERE regno = 'KA09CD2222' AND report_number = 12;
UPDATE Accident SET location = 'Bannur Road' WHERE report_number = 14;
UPDATE Person   SET phone = '9876500001' WHERE driver_id = 'D01';
 
DELETE FROM Participated WHERE report_number = 15;
DELETE FROM Accident     WHERE report_number = 15;
DELETE FROM Car           WHERE regno = 'KA05IJ5555';   -- cascades to Owns
