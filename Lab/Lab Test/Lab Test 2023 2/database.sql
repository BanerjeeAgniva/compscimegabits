create database labtest2;
use labtest2;

CREATE TABLE Users (
  user_id INT  PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  password VARCHAR(255) NOT NULL,
  registration_date DATETIME NOT NULL
);

CREATE TABLE Categories (
  category_id INT  PRIMARY KEY,
  name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT
);

CREATE TABLE Products (
  product_id INT  PRIMARY KEY,
  category_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  stock INT NOT NULL
  -- FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Addresses (
    address_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL
    -- FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATETIME NOT NULL,
    status ENUM('processing', 'shipped', 'delivered', 'canceled') NOT NULL
    -- FOREIGN KEY (user_id) REFERENCES Users(user_id),
    -- FOREIGN KEY (address_id) REFERENCES Addresses(address_id)
);

CREATE TABLE Order_Items (
  order_item_id INT   PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  price DECIMAL(10, 2) NOT NULL
  -- FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  -- FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Cart_Items (
  cart_item_id INT   PRIMARY KEY,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL
  -- FOREIGN KEY (user_id) REFERENCES Users(user_id),
  -- FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Reviews (
  review_id INT   PRIMARY KEY,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  rating INT NOT NULL,
  review TEXT,
  review_date DATETIME NOT NULL
  -- FOREIGN KEY (user_id) REFERENCES Users(user_id),
  -- FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Shipping (
  shipping_id INT PRIMARY KEY,
  order_id INT NOT NULL,
  carrier VARCHAR(50) NOT NULL,
  tracking_number VARCHAR(50) UNIQUE NOT NULL,
  estimated_delivery_date DATETIME NOT NULL,
  actual_delivery_date DATETIME
  -- FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


CREATE TABLE Payments (
    payment_id INT PRIMARY KEY NOT NULL,
    order_id INT NOT NULL,
    payment_method ENUM('credit_card', 'debit_card', 'paypal', 'bank_transfer') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') NOT NULL,
    transaction_id VARCHAR(100) UNIQUE NOT NULL
    -- FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
-- Users
INSERT INTO Users (user_id, first_name, last_name, email, password, registration_date)
VALUES
(1, 'John', 'Doe', 'john.doe@example.com', 'password1', '2022-01-01 12:00:00'),
(2, 'Jane', 'Doe', 'jane.doe@example.com', 'password2', '2022-01-02 12:00:00'),
(3, 'Alice', 'Smith', 'alice.smith@example.com', 'password3', '2022-01-03 12:00:00'),
(4, 'Bob', 'Johnson', 'bob.johnson@example.com', 'password4', '2022-01-04 12:00:00'),
(5, 'Charlie', 'Brown', 'charlie.brown@example.com', 'password5', '2022-01-05 12:00:00');


-- Categories
INSERT INTO Categories (category_id, name, description)
VALUES
(1, 'Electronics', 'Gadgets and devices'),
(2, 'Books', 'All kinds of books'),
(3, 'Clothing', 'Fashionable and comfortable clothes');

-- Products
INSERT INTO Products (product_id, category_id, name, description, price, stock)
VALUES
(1, 1, 'iPhone 13', 'Latest iPhone model', 999.99, 10),
(2, 1, 'Samsung Galaxy S22', 'Latest Samsung model', 899.99, 8),
(3, 2, 'Database Management', 'Learn database systems', 45.99, 30),
(4, 2, 'Python Programming', 'Master Python language', 39.99, 25),
(5, 3, 'Levi''s Jeans', 'Classic Levi''s jeans', 79.99, 20);

-- Addresses
INSERT INTO Addresses (address_id, user_id, street, city, state, country, zip_code)
VALUES
(1, 1, '123 Main St', 'Pittsburgh', 'PA', 'USA', '15213'),
(2, 2, '456 Market St', 'Pittsburgh', 'PA', 'USA', '15219'),
(3, 3, '789 Elm St', 'Pittsburgh', 'PA', 'USA', '15212');

-- Orders
INSERT INTO Orders (order_id, user_id, address_id, total_amount, order_date, status)
VALUES
(1, 1, 1, 1045.98, '2022-01-10 14:00:00', 'delivered'),
(2, 2, 2, 45.99, '2022-01-11 16:00:00', 'delivered'),
(3, 3, 3, 79.99, '2022-01-12 18:00:00', 'processing');

INSERT INTO Orders (`order_id`, `user_id`, `address_id`, `total_amount`, `order_date`, `status`) VALUES ('4', '1', '1', '77.99', '2022-01-12 18:00:00', 'processing');
INSERT INTO Orders (`order_id`, `user_id`, `address_id`, `total_amount`, `order_date`, `status`) VALUES ('5', '1', '1', '45.99', '2022-01-12 18:00:00', 'processing');

-- Order_Items
INSERT INTO Order_Items (order_item_id, order_id, product_id, quantity, price)
VALUES
(1, 1, 1, 1, 999.99),
(2, 1, 2, 1, 899.99),
(3, 2, 3, 1, 45.99),
(4, 3, 5, 1, 79.99);
INSERT INTO Order_Items (`order_item_id`, `order_id`, `product_id`, `quantity`, `price`) VALUES ('5', '4', '5', '1', '79.99');
INSERT INTO Order_Items (`order_item_id`, `order_id`, `product_id`, `quantity`, `price`) VALUES ('6', '5', '3', '1', '45.99');

-- Cart_Items
INSERT INTO Cart_Items (cart_item_id, user_id, product_id, quantity)
VALUES
(1, 1, 3, 1),
(2, 2, 4, 1),
(3, 3, 1, 1),
(4, 4, 2, 1),
(5, 5, 5, 1);

-- Reviews
INSERT INTO Reviews (review_id, user_id, product_id, rating, review, review_date)
VALUES
(1, 1, 1, 5, 'Great phone!', '2022-01-15 12:00:00'),
(2, 2, 2, 4, 'Good device, but could be better.', '2022-01-16 12:00:00'),
(3, 3, 3, 5, 'Excellent book on databases.', '2022-01-17 12:00:00'),
(4, 4, 4, 4, 'Good Python resource.', '2022-01-18 12:00:00'),
(5, 5, 5, 5, 'Love these jeans!', '2022-01-19 12:00:00');
INSERT INTO Reviews (`review_id`, `user_id`, `product_id`, `rating`, `review`, `review_date`) VALUES ('6', '2', '4', '5', 'Good Python resource.', '2022-01-19 12:00:00');


-- Shipping
INSERT INTO Shipping (shipping_id, order_id, carrier, tracking_number, estimated_delivery_date, actual_delivery_date)
VALUES
(1, 1, 'FedEx', '123456789', '2022-01-12 12:00:00', '2022-01-12 10:00:00'),
(2, 2, 'UPS', '987654321', '2022-01-13 12:00:00', '2022-01-13 14:00:00'),
(3, 3, 'USPS', '246813579', '2022-01-14 12:00:00', NULL);

-- Payments
INSERT INTO Payments (payment_id, order_id, payment_method, payment_status, transaction_id)
VALUES
(1, 1, 'credit_card', 'completed', 'txn0001'),
(2, 2, 'debit_card', 'completed', 'txn0002'),
(3, 3, 'paypal', 'pending', 'txn0003');





