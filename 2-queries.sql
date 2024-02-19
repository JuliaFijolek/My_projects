/*
VIEW WITH JOIN
*/

#Display product name instead of product id, show discounted - if discount was applied or not.
#are discount and discounted and price per unit the same - not - limitation of the dataset

#DROP VIEW Order_details_with_products;

CREATE VIEW Order_details_with_products AS
SELECT od.orderID, od.unitPrice, od.quantity, od.discount, od.productID, p.productName, p.discontinued
FROM Order_details od
LEFT JOIN
products p
ON
od.productID = p.productID;

SELECT * FROM northwind_traders.Order_details_with_products;

#JOIN WITH 4 TABLES

#Join that gives us crequiredDate, ontact name of the customer, shipping company name, 
#employee name for each order ID

SELECT
o.orderID, o.requiredDate,
c.contactname, s.companyname, e.employeeName
FROM orders o
LEFT JOIN customers c
ON
c.customerID = o.customerID
LEFT JOIN  shippers s
ON
s.shipperID = o.shipperID
LEFT JOIN employees e
ON
e.employeeID = o.employeeID;

#show all orders with discountinued products

SELECT o.orderID, o.orderDate, p.discontinued 
FROM orders as o 
JOIN
    order_details AS od ON o.orderID = od.orderID
JOIN
    products as p ON od.productID = p.productID
WHERE p.discontinued = 0;

/*
STORED FUNCTION
*/

#want to create a function which would calculate the price of an order
SELECT orderID,
 unitPrice*quantity*(1-discount)  AS order_price
FROM order_details;

#I will call it Order_price

DELIMITER //
CREATE FUNCTION
Order_price( p FLOAT(2), q FLOAT(2), d FLOAT(2)) RETURNS FLOAT(2)
DETERMINISTIC
BEGIN
DECLARE price FLOAT(2);
SET price = p * q * (1-d);
RETURN price;
END//
DELIMITER ;

#example of use

SELECT orderID, Order_price(unitPrice,quantity,discount)
FROM order_details;

/*
STORED FUNCTION 2
*/

#what I want to do now is to do the same but 
#with a check from products table if product is discountined or not 

DELIMITER //
CREATE FUNCTION
Order_price_with_check( p FLOAT(2), q FLOAT(2), d FLOAT(2), disc INT) RETURNS FLOAT(2)
DETERMINISTIC
BEGIN
DECLARE price FLOAT(2);
IF disc = 1 THEN
SET price = p * q * (1-d);
ELSEIF disc = 0 THEN
SET price = 0;
END IF;
RETURN price;
END//
DELIMITER ;


SELECT orderID, Order_price_with_check(od.unitPrice,od.quantity,od.discount,p.discontinued), p.discontinued
FROM order_details as od
JOIN products as p
ON p.productID = od.productID
ORDER BY p.discontinued DESC;

/*
QUERIES
*/

#How many tofu's we sold, tofu's ID is 14
SELECT SUM(quantity) FROM Order_details WHERE ProductID = 14;

#group by
#Number of orders by shipper
SELECT ShipperID, COUNT(OrderID) FROM Orders GROUP BY ShipperID ORDER BY COUNT(OrderID) desc;

#having
#customer count by country, only countires with more than 5 customers
SELECT country, COUNT(CustomerID)
FROM Customers
GROUP BY country
HAVING COUNT(CustomerID) > 5
ORDER BY COUNT(CustomerID);

#SUBQUERY

#see what countries we have in customers table
SELECT Count(customerID), country FROM northwind_traders.customers group by country;

#check customers from Germany 
SELECT customerID, country FROM customers WHERE country = 'Germany\r';


#show order IDs along with the dates for German customers
SELECT orderID, orderdate FROM orders WHERE
    customerID IN (SELECT customerID FROM customers WHERE country = 'Germany\r')
ORDER BY orderdate;
