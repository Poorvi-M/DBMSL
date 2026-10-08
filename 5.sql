CREATE DATABASE IF NOT EXISTS order_db;
USE order_db;
 
CREATE TABLE Customer (
    cust_no  INT         NOT NULL,
    cname    VARCHAR(40) NOT NULL,
    city     VARCHAR(30),
    CONSTRAINT pk_customer PRIMARY KEY (cust_no)
);
 
CREATE TABLE Orders (
    order_no   INT  NOT NULL,
    odate      DATE NOT NULL,
    cust_no    INT  NOT NULL,
    order_amt  INT,
    CONSTRAINT pk_orders PRIMARY KEY (order_no),
    CONSTRAINT fk_ord_cust FOREIGN KEY (cust_no) REFERENCES Customer(cust_no) ON DELETE CASCADE,
    CONSTRAINT chk_amt CHECK (order_amt >= 0)
);
 
CREATE TABLE Item (
    item_no    INT NOT NULL,
    unitprice  INT NOT NULL,
    CONSTRAINT pk_item PRIMARY KEY (item_no),
    CONSTRAINT chk_price CHECK (unitprice > 0)
);
 
CREATE TABLE Order_item (
    order_no  INT NOT NULL,
    item_no   INT NOT NULL,
    qty       INT NOT NULL,
    CONSTRAINT pk_order_item PRIMARY KEY (order_no, item_no),
    CONSTRAINT fk_oi_order FOREIGN KEY (order_no) REFERENCES Orders(order_no) ON DELETE CASCADE,
    CONSTRAINT fk_oi_item  FOREIGN KEY (item_no)  REFERENCES Item(item_no)    ON DELETE CASCADE,
    CONSTRAINT chk_qty CHECK (qty > 0)
);
 
CREATE TABLE Warehouse (
    warehouse_no  INT NOT NULL,
    city          VARCHAR(30),
    CONSTRAINT pk_warehouse PRIMARY KEY (warehouse_no)
);
 
CREATE TABLE Shipment (
    order_no      INT  NOT NULL,
    warehouse_no  INT  NOT NULL,
    ship_date     DATE,
    CONSTRAINT pk_shipment PRIMARY KEY (order_no, warehouse_no),
    CONSTRAINT fk_ship_order FOREIGN KEY (order_no)     REFERENCES Orders(order_no)       ON DELETE CASCADE,
    CONSTRAINT fk_ship_wh    FOREIGN KEY (warehouse_no) REFERENCES Warehouse(warehouse_no) ON DELETE CASCADE
);
 
INSERT INTO Customer VALUES
 (1,'Kumar','Mysuru'),(2,'Anand','Bengaluru'),(3,'Divya','Chennai'),
 (4,'Farah','Mysuru'),(5,'Gopal','Hyderabad');
 
INSERT INTO Orders VALUES
 (1,'2026-01-05',1,2500),(2,'2026-01-18',2,4800),(3,'2026-02-02',3,1200),
 (4,'2026-02-20',4,3600),(5,'2026-03-11',5,900);
 
INSERT INTO Item VALUES (1,100),(2,250),(3,400),(4,50),(5,600);
 
INSERT INTO Order_item VALUES
 (1,1,10),(1,2,6),(2,3,12),(3,4,24),(4,5,6),(5,4,18);
 
INSERT INTO Warehouse VALUES
 (1,'Mysuru'),(2,'Bengaluru'),(3,'Chennai'),(4,'Hyderabad'),(5,'Pune');
 
INSERT INTO Shipment VALUES
 (1,1,'2026-01-07'),(2,2,'2026-01-20'),(3,3,'2026-02-04'),
 (4,1,'2026-02-22'),(5,4,'2026-03-13');
 
-- ---- ALTER ----
ALTER TABLE Customer ADD COLUMN email VARCHAR(50);
ALTER TABLE Item     ADD COLUMN idesc VARCHAR(40);
ALTER TABLE Item     DROP COLUMN idesc;
 
ALTER TABLE Customer ADD CONSTRAINT uq_email UNIQUE (email);
ALTER TABLE Customer DROP INDEX uq_email;
 
ALTER TABLE Orders DROP CHECK chk_amt;
ALTER TABLE Orders ADD CONSTRAINT chk_amt CHECK (order_amt >= 0);
 
ALTER TABLE Shipment DROP FOREIGN KEY fk_ship_wh;
ALTER TABLE Shipment ADD CONSTRAINT fk_ship_wh
      FOREIGN KEY (warehouse_no) REFERENCES Warehouse(warehouse_no) ON DELETE CASCADE;
 
-- ---- UPDATE / DELETE ----
UPDATE Item     SET unitprice = unitprice * 1.10 WHERE item_no = 3;
UPDATE Orders   SET order_amt = 5000 WHERE order_no = 2;
UPDATE Customer SET city = 'Bengaluru' WHERE cust_no = 4;
 
DELETE FROM Shipment WHERE order_no = 5;
DELETE FROM Orders   WHERE order_no = 5;      -- cascades to Order_item
DELETE FROM Warehouse WHERE warehouse_no = 5; -- no shipments
