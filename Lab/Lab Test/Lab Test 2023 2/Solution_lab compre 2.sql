use labtest2;
-- Ques 1

SELECT p.name, p.product_id, SUM(oi.quantity) as total_quantity_sold
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY total_quantity_sold DESC
LIMIT 5;


-- Ques 2 a
SELECT p.name, c.name AS category, p.price, COUNT(r.review_id) as rCount
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY r.product_id
ORDER BY rCount DESC
LIMIT 1;


-- Ques 2 b
SELECT COUNT(review_id)
FROM Reviews
WHERE product_id = (
  SELECT product_id
  FROM Reviews
  GROUP BY product_id
  ORDER BY COUNT(review_id) DESC
  LIMIT 1
);


-- Ques 2 c
select u.user_id, u.first_name, u.last_name, u.email from users u
where user_id in
(select r.user_id from reviews r
where r.rating = 5);


-- Ques 2 d

SELECT u.first_name, u.last_name, u.user_id, c.name as category, oi.quantity
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
WHERE o.total_amount = (
  SELECT MAX(total_amount)
  FROM Orders
)
LIMIT 1;

-- Ques 2 e

SELECT u.first_name, u.last_name
FROM Users u
WHERE NOT EXISTS (
  SELECT * FROM Categories c
  WHERE NOT EXISTS (
    SELECT * FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    WHERE o.user_id = u.user_id AND p.category_id = c.category_id
  )
);


-- Ques 3 a
DELIMITER //
CREATE PROCEDURE Get_User_Order_Details(IN user_id_input INT)
BEGIN
  SELECT *
  FROM Orders
  WHERE user_id = user_id_input;
END //
DELIMITER ;

-- Test query
CALL Get_User_Order_Details(1);

-- Ques 3 b

DELIMITER //
CREATE DEFINER=`root`@`localhost`
FUNCTION get_order_total(order_id_input INT) RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
  DECLARE total_amount DECIMAL(10,2);
  
select sum(oi.price) into total_amount from order_items oi
where oi.order_id = order_id_input;
  
  RETURN total_amount;
END //
DELIMITER ;


-- Test query
SELECT order_id, get_order_total(order_id) as order_total
FROM Orders;

-- Ques 4 a

-- Create table
CREATE TABLE stock_log (
  product_id INT,
  old_stock INT,
  new_stock INT,
  update_time DATETIME
);


-- Create trigger
DELIMITER //
CREATE TRIGGER stock_log
BEFORE UPDATE ON Products
FOR EACH ROW
BEGIN
  INSERT INTO stock_log (product_id, old_stock, new_stock, update_time)
  VALUES (OLD.product_id, OLD.stock, NEW.stock, NOW());
END //
DELIMITER ;

-- Test query
UPDATE Products SET stock = stock - 1 WHERE product_id = 1;
SELECT * FROM stock_log;


-- Ques 4 b

-- Create table
CREATE TABLE category_order_details (
  order_id INT,
  product_id INT,
  category_id INT,
quantity_ordered INT,
price DECIMAL(10, 2)
);



-- Create stored procedure
DELIMITER //
CREATE PROCEDURE fetch_category_order_details(IN category_id_input INT)
BEGIN
INSERT INTO category_order_details (order_id, product_id, category_id, quantity_ordered, price)
SELECT o.order_id, p.product_id, p.category_id, oi.quantity, oi.price
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE p.category_id = category_id_input;
END //
DELIMITER ;

-- Test query
CALL fetch_category_order_details(3);
SELECT * FROM category_order_details;

-- Ques 4 c
DELIMITER //
CREATE DEFINER=`root`@`localhost`
FUNCTION quantity_total(product_id_input INT) RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
  DECLARE total_qty DECIMAL(10,2);
  
select SUM(oi.quantity) into total_qty from order_items oi
where oi.product_id = product_id_input;
  
  RETURN total_qty;
END //
DELIMITER ;

SELECT p.name, p.product_id, quantity_total(p.product_id) as total_quantity_sold
FROM Products p;
/*

SELECT p.name, p.product_id, AVG(r.rating) as average_rating
FROM Products p
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.product_id
ORDER BY average_rating DESC
LIMIT 5;


SELECT u.first_name, u.last_name, u.email
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE p.price = (SELECT MAX(price) FROM Products)
GROUP BY u.user_id;

-- Q2b
SELECT COUNT(*) as total_orders
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
WHERE oi.product_id = (SELECT product_id FROM Products ORDER BY price DESC LIMIT 1);

-- Q2c
SELECT u.first_name, u.last_name, u.email
FROM Users u
JOIN Reviews r ON u.user_id = r.user_id
WHERE r.product_id = (SELECT product_id FROM Products ORDER BY price DESC LIMIT 1)
GROUP BY u.user_id;

-- Q2d
SELECT u.first_name, u.last_name, u.email, COUNT(o.order_id) as total_orders
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id
ORDER BY total_orders DESC
LIMIT 1;

-- Q2e
SELECT c.name
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY c.category_id
ORDER BY AVG(r.rating) DESC
LIMIT 1;

-- Q3a
DELIMITER //
CREATE PROCEDURE Get_User_Order_Details2(IN input_user_id INT)
BEGIN
SELECT o.order_id, oi.product_id, oi.quantity, oi.price
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
WHERE o.user_id = input_user_id;
END //
DELIMITER ;

-- Test query to call Get_User_Order_Details
CALL Get_User_Order_Details2(1);

-- Q3b
DELIMITER //
CREATE FUNCTION get_total_spent(input_order_id INT) RETURNS DECIMAL(10,2)
BEGIN
DECLARE total DECIMAL(10,2);
SELECT SUM(oi.price * oi.quantity) INTO total
FROM Order_Items oi
WHERE oi.order_id = input_order_id;
RETURN total;
END //
DELIMITER ;

-- Test query to call get_total_spent
SELECT order_id, get_total_spent(order_id) as total_spent
FROM Orders;

-- Q4a
-- Create table
CREATE TABLE order_status_log (
order_id INT,
old_status ENUM('processing', 'shipped', 'delivered', 'canceled'),
new_status ENUM('processing', 'shipped', 'delivered', 'canceled'),
update_time DATETIME
);

-- Create trigger
DELIMITER //
CREATE TRIGGER order_status_log
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
IF NEW.status != OLD.status THEN
INSERT INTO order_status_log (order_id, old_status, new_status, update_time)
VALUES (NEW.order_id, OLD.status, NEW.status, NOW());
END IF;
END //
DELIMITER ;

-- Test query to check the trigger's functionality
UPDATE Orders SET status = 'shipped' WHERE order_id = 1;

-- Q4b
-- Create table
CREATE TABLE category_order_details2 (
order_id INT,
product_id INT,
category_id INT,
quantity_ordered INT,
price DECIMAL(10, 2)
);
*/
/*
-- Create stored procedure
DELIMITER //
CREATE PROCEDURE fetch_category_order_details2(IN input_category_id INT)
BEGIN
INSERT INTO category_order_details2 (order_id, product_id, category_id, quantity_ordered, price)
SELECT o.order_id, p.product_id, p.category_id, oi.quantity, oi.price
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE p.category_id = input_category_id;
END //
DELIMITER ;

-- Call the procedure
CALL fetch_category_order_details2(1);
*/
