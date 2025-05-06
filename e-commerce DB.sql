-- E-commerce Database Schema Queries 

-- Retrieve all details of the customers
SELECT * FROM customers;

-- Retrieve all details of the orders
SELECT * FROM orders;

-- Retrieve all details of the products
SELECT * FROM products;

-- 1. Retrieve all customers who have placed an order in the last 30 days.
SELECT DISTINCT c.* FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
WHERE o.order_date >= DATE_SUB(CURDATE(),INTERVAL 30 DAY);

-- 2. Get the total amount of all orders placed by each customer.
SELECT c.customer_name, SUM(o.total_amount) as total_spent FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id , c.customer_name;

-- 3. Update the price of Product C to 45.00.
UPDATE products
SET products_price = 45.00
WHERE product_id = 3;

-- 4. Add a new column discount to the products table
ALTER TABLE products
ADD COLUMN discount DECIMAL(10,2) DEFAULT 0.00;

-- 5. Retrieve the top 3 products with the highest price.
SELECT * FROM products 
ORDER BY products_price DESC
LIMIT 3;

-- 6. Get the names of customers who have ordered Product A.
SELECT DISTINCT c.* FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
JOIN products p
ON o.order_id = p.product_id
WHERE p.products_name = 'Product A';

-- 7. Join the orders and customers tables to retrieve the customer's name and order date for each order. 
SELECT c.customer_name , o.order_date FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id;

-- 8. Retrieve the orders with a total amount greater than 150.00.
SELECT * FROM orders
WHERE total_amount > 150.00;

-- 9. Normalize the database by creating a separate table for order items and updating the orders table to reference the order_items table.
CREATE TABLE order_items
(item_id INT NOT NULL auto_increment PRIMARY KEY,
order_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
price_at_order DECIMAL(10,2) NOT NULL,
CONSTRAINT FK_order_id  FOREIGN KEY (order_id) REFERENCES orders(order_id),
CONSTRAINT FK_product_id  FOREIGN KEY (product_id) REFERENCES products(product_id)
)
ENGINE = InnoDB;
INSERT INTO order_items (order_id, product_id, quantity, price_at_order ) 
VALUES
(1, 1, 2, 19.96),  
(1, 2, 1, 29.97), 
(2, 3, 1, 29.97),  
(3, 1, 3, 19.99),  
(4, 2, 2, 29.97),  
(5, 3, 1, 29.97);  

-- Retrieve all details of the order_items
SELECT * FROM order_items;

--  updating the orders table to reference the order_items table.
SELECT o.order_id, SUM(oi.quantity * oi.price_at_order) as total_amount FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY o.order_id;


-- 10. Retrieve the average total of all orders.
SELECT AVG(total_amount) as average_total_order FROM orders;