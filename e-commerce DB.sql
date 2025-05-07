-- E-commerce Database Schema Queries 
-- Create the ecommerce database
CREATE DATABASE ecommerce;

-- Use the ecommerce database
use ecommerce;

-- Create the customers table
CREATE TABLE customers (
    customer_id INT NOT NULL auto_increment PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL
) ENGINE = InnoDB;

-- Create the orders table
CREATE TABLE orders (
    order_id INT NOT NULL auto_increment PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_customer_id FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) ENGINE = InnoDB;

-- Create the products table
CREATE TABLE products (
    product_id INT NOT NULL auto_increment PRIMARY KEY,
    products_name VARCHAR(50) NOT NULL,
    products_price DECIMAL(10, 2) NOT NULL,
    products_description VARCHAR(200) NOT NULL
) ENGINE = InnoDB;

-- Insert customers details
INSERT INTO customers (customer_id, customer_name, email, address)
VALUES (NULL, 'Alice', 'alice@example.com', '123 Elm St'),
    (NULL, 'Bob', 'bob@example.com', '456 Oak Ave'),
    (
        NULL,
        'Charlie',
        'charlie@example.com',
        '789 Pine Rd'
    ),
    (
        NULL,
        'John Doe',
        'john@example.com',
        '123 Main St, Anytown'
    ),
    (
        NULL,
        'Jane Smith',
        'jane@example.com',
        '456 Oak Ave, Somewhere'
    );
    
-- Insert orders details
INSERT INTO orders (order_id, customer_id, order_date, total_amount)
VALUES (NULL, 1, '2025-05-05', 39.97),
    (NULL, 5, '2025-04-20', 29.97),
    (NULL, 4, '2025-04-07', 49.99),
    (NULL, 3, '2025-05-06', 59.96),
    (NULL, 2, '2025-04-10', 19.96),
    (NULL, 1, '2025-03-05', 39.97),
    (NULL, 5, '2025-02-20', 29.97);
    
-- Insert products details
INSERT INTO products (
        product_id,
        products_name,
        products_price,
        products_description
    )
VALUES (NULL, 'Product A', 29.97, 'High-quality widget'),
    (NULL, 'Product B', 39.97, 'Premium gadget'),
    (NULL, 'Product C', 49.99, 'Deluxe item'),
    (NULL, 'Product D', 19.96, 'Basic component'),
    (NULL, 'Product E', 59.96, 'Advanced tool');
-- Queries 

-- Retrieve all details of the customers
SELECT *
FROM customers;

-- Retrieve all details of the orders
SELECT *
FROM orders;

-- Retrieve all details of the products
SELECT *
FROM products;

-- 1. Retrieve all customers who have placed an order in the last 30 days.
SELECT DISTINCT c.*
FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 2. Get the total amount of all orders placed by each customer.
SELECT c.customer_name,
    SUM(o.total_amount) as total_spent
FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id,
    c.customer_name;

-- 3. Update the price of Product C to 45.00.
UPDATE products
SET products_price = 45.00
WHERE product_id = 3;

-- 4. Add a new column discount to the products table
ALTER TABLE products
ADD COLUMN discount DECIMAL(10, 2) DEFAULT 0.00;

-- 5. Retrieve the top 3 products with the highest price.
SELECT *
FROM products
ORDER BY products_price DESC
LIMIT 3;

-- 6. Get the names of customers who have ordered Product A.
SELECT DISTINCT c.*
FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN products p ON o.order_id = p.product_id
WHERE p.products_name = 'Product A';

-- 7. Join the orders and customers tables to retrieve the customer's name and order date for each order. 
SELECT c.customer_name,
    o.order_date
FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id;

-- 8. Retrieve the orders with a total amount greater than 150.00.
SELECT *
FROM orders
WHERE total_amount > 150.00;

-- 9. Normalize the database by creating a separate table for order items and updating the orders table to reference the order_items table.
CREATE TABLE order_items (
    item_id INT NOT NULL auto_increment PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price_at_order DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_order_id FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT FK_product_id FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE = InnoDB;

INSERT INTO order_items (order_id, product_id, quantity, price_at_order)
VALUES (1, 1, 2, 19.96),
    (1, 2, 1, 29.97),
    (2, 3, 1, 29.97),
    (3, 1, 3, 19.99),
    (4, 2, 2, 29.97),
    (5, 3, 1, 29.97);

-- Retrieve all details of the order_items
SELECT * FROM order_items;

--  updating the orders table to reference the order_items table.
SELECT o.order_id,
    SUM(oi.quantity * oi.price_at_order) as total_amount
FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;


-- 10. Retrieve the average total of all orders.
SELECT AVG(total_amount) as average_total_order
FROM orders;