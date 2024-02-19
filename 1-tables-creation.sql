DROP database Northwind_traders;

CREATE DATABASE Northwind_traders CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE Northwind_traders;


/* In order to allow loading data need to change database server connection setting 
Add OPT_LOCAL_INFILE=1 in Advanced
*/

/* That is the code to check if other setting are ok*/
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SHOW GRANTS FOR 'root'@'localhost';

/* To change it - run that*/
GRANT FILE ON *.* TO 'root'@'localhost';
SET GLOBAL local_infile = true;

/* 
TABLE 1 - ORDERS
*/
#DROP Table Orders;
CREATE Table Orders 
(orderID INT PRIMARY KEY,
customerID VARCHAR(50),
employeeID INT,
orderDate DATE,
requiredDate DATE,
shippedDate DATE,
shipperID INT,
freight FLOAT(2));

#TRUNCATE Orders;

LOAD DATA LOCAL INFILE "C:/Users/JuliaFijolek/SQL Project/Northwind Traders/orders.csv"
INTO TABLE Orders 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES (orderID,customerID,employeeID,orderDate,requiredDate,@shippedDate,shipperID,freight)
SET shippedDate = NULLIF(@shippedDate, "");

/* 
TABLE 2 - ORDER DETAILS
*/
CREATE Table Order_details
(orderID INT PRIMARY KEY,
productID INT,
unitPrice FLOAT(2),
quantity INT,
discount FLOAT (2));

LOAD DATA LOCAL INFILE "C:/Users/JuliaFijolek/SQL Project/Northwind Traders/order_details.csv"
INTO TABLE Order_details 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS (`orderID`,`productID`,`unitPrice`,`quantity`,`discount`);


/* 
TABLE 3 - PRODUCTS
*/

CREATE Table Products
(productID INT PRIMARY KEY,
productName VARCHAR(50),
quantityPerUnit  VARCHAR(50),
unitPrice FLOAT(2),
discontinued FLOAT(2),
categoryID INT
);

LOAD DATA LOCAL INFILE "C:/Users/JuliaFijolek/SQL Project/Northwind Traders/products.csv"
INTO TABLE Products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS (`productID`,`productName`,`quantityPerUnit`,`unitPrice`,`discontinued`,`categoryID`);

/* 
TABLE 4 - CATEGORIES
*/
CREATE Table Categories
(categoryID INT PRIMARY KEY,
categoryName VARCHAR(50),
description VARCHAR(150)
);

TRUNCATE Categories;

LOAD DATA LOCAL INFILE "C:/Users/JuliaFijolek/SQL Project/Northwind Traders/categories.csv"
INTO TABLE Categories
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS (`categoryID`,`categoryName`,`description`);

/* 
TABLE 5 - CUSTOMERS
*/
DROP TABLE Customers;

CREATE Table Customers
(customerID VARCHAR(50) PRIMARY KEY,
companyName VARCHAR(50) ,
contactName VARCHAR(50),
contactTitle VARCHAR(50),
city VARCHAR(50),
country VARCHAR(50)
);

TRUNCATE Customers;

LOAD DATA LOCAL INFILE "C:/Users/JuliaFijolek/SQL Project/Northwind Traders/customers-copy.csv"
INTO TABLE Customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS (`customerID`,`companyName`,`contactName`,`contactTitle`,`city`,`country`);

/* 
TABLE 6 - Employees
*/

CREATE Table Employees
(employeeID INT PRIMARY KEY,
employeeName VARCHAR(50),
title VARCHAR(50),
city VARCHAR(50),
country VARCHAR(50),
reportsTo INT
);

TRUNCATE Employees;

LOAD DATA LOCAL INFILE "C:/Users/JuliaFijolek/SQL Project/Northwind Traders/employees.csv"
INTO TABLE Employees
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS (`employeeID`,`employeeName`,`title`,`city`,`country`,`reportsTo`);


/* 
TABLE 7 - SHIPPERS
*/

CREATE Table Shippers
(shipperID INT PRIMARY KEY,
companyName VARCHAR(50)
);

LOAD DATA LOCAL INFILE "C:/Users/JuliaFijolek/SQL Project/Northwind Traders/shippers.csv"
INTO TABLE shippers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS (`shipperID`,`companyName`);

/* 
ADD FOREIGN KEYS
*/

/* TABLE 1 - ORDERS */
ALTER TABLE Orders
ADD FOREIGN KEY (customerID) REFERENCES customers(customerID),
ADD FOREIGN KEY (orderID) REFERENCES Order_details(orderID),
ADD FOREIGN KEY (employeeID) REFERENCES employees(employeeID),
ADD FOREIGN KEY (shipperID) REFERENCES shippers(shipperID);

/* TABLE 2 - ORDER DETAILS */

ALTER TABLE Order_details
ADD FOREIGN KEY (productID) REFERENCES products(productID);

/* TABLE 3 - PRODUCTS */

ALTER TABLE Products
ADD FOREIGN KEY (categoryID) REFERENCES categories(categoryID);


/*Limitations of the dataset 
1. Contact Name in table customers treated as one not name, surname separately
2. Unit price is both existing in table orders and products and is not matching
*/