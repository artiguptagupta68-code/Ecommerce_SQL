CREATE DATABASE Ecommerce_SQL_Database;
USE Ecommerce_SQL_Database;
SHOW DATABASES;
DROP VIEW IF EXISTS customer_order_summary;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(30),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);



INSERT INTO customers VALUES
(1, 'Amit Sharma', 'Delhi', 'India', 'amit@gmail.com'),
(2, 'Priya Singh', 'Mumbai', 'India', 'priya@gmail.com'),
(3, 'Rahul Verma', 'Kanpur', 'India', 'rahul@gmail.com'),
(4, 'Sneha Gupta', 'Lucknow', 'India', 'sneha@gmail.com'),
(5, 'John Smith', 'New York', 'USA', 'john@gmail.com'),
(6, 'Neha Patel', 'Ahmedabad', 'India', 'neha@gmail.com');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 55000.00, 10),
(102, 'Smartphone', 'Electronics', 25000.00, 20),
(103, 'Headphones', 'Accessories', 2000.00, 50),
(104, 'Keyboard', 'Accessories', 1500.00, 30),
(105, 'Office Chair', 'Furniture', 8000.00, 15),
(106, 'Monitor', 'Electronics', 12000.00, 12);

INSERT INTO orders VALUES
(1001, 1, '2026-01-05', 'Delivered'),
(1002, 2, '2026-01-10', 'Delivered'),
(1003, 1, '2026-02-15', 'Shipped'),
(1004, 3, '2026-02-20', 'Delivered'),
(1005, 4, '2026-03-01', 'Pending'),
(1006, 5, '2026-03-05', 'Delivered');

INSERT INTO order_items VALUES
(1, 1001, 101, 1),
(2, 1001, 103, 2),
(3, 1002, 102, 1),
(4, 1002, 104, 2),
(5, 1003, 106, 1),
(6, 1003, 103, 1),
(7, 1004, 105, 1),
(8, 1004, 104, 1),
(9, 1005, 102, 2),
(10, 1006, 101, 1),
(11, 1006, 106, 2);

SELECT * FROM customers;

SELECT * FROM orders;

SELECT * FROM order_items;

SELECT *
FROM customers
WHERE country = 'India';

SELECT *
FROM products
WHERE price > 10000;

SELECT *
FROM orders
WHERE status = 'Delivered';

SELECT *
FROM products
ORDER BY price DESC;

SELECT *
FROM customers
ORDER BY customer_name ASC;



SELECT COUNT(*) AS total_customers
FROM customers;
SELECT AVG(price) AS average_product_price
FROM products;

SELECT MAX(price) AS highest_price
FROM products;

SELECT MIN(price) AS lowest_price
FROM products;

SELECT country, COUNT(*) AS total_customers
FROM customers
GROUP BY country;

SELECT category, COUNT(*) AS total_products
FROM products
GROUP BY category;

SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status;


SELECT
    SUM(oi.quantity * p.price) AS total_sales
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id;


SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
INNER JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;


SELECT
    c.customer_name,
    o.order_id,
    o.order_date,
    o.status
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;



SELECT
    c.customer_name,
    o.order_id,
    o.status
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;



SELECT
    p.product_name,
    oi.order_id,
    oi.quantity
FROM order_items oi
RIGHT JOIN products p
    ON oi.product_id = p.product_id;




SELECT
    c.customer_name,
    o.order_id,
    p.product_name,
    oi.quantity,
    p.price,
    (oi.quantity * p.price) AS item_total
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
ORDER BY o.order_id;



SELECT *
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
);

SELECT *
FROM products
WHERE product_id NOT IN (
    SELECT product_id
    FROM order_items
);



SELECT
    c.customer_name,
    SUM(oi.quantity * p.price) AS total_spent
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;



CREATE OR REPLACE VIEW customer_order_summary AS
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(oi.quantity * p.price), 0) AS total_spent
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name;



SELECT *
FROM customer_order_summary;


CREATE INDEX idx_customers_country
ON customers(country);

CREATE INDEX idx_products_category
ON products(category);

CREATE INDEX idx_orders_customer
ON orders(customer_id);

CREATE INDEX idx_orders_date
ON orders(order_date);

CREATE INDEX idx_order_items_product
ON order_items(product_id);



EXPLAIN
SELECT *
FROM orders
WHERE customer_id = 1;





SELECT
    SUM(oi.quantity * p.price) AS total_revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT
    SUM(oi.quantity * p.price) /
    COUNT(DISTINCT o.order_id) AS average_order_value
FROM orders o
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.product_id;

SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM products p
INNER JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC
LIMIT 1;


SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;


