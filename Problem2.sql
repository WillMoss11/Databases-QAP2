--************************************************--
-- PROBLEM TWO: Store Inventory and Orders System --
--************************************************--

-- By: William Moss --
--  10-13-2024   --

----------------------------------------
--    TABLE CREATION                  --
----------------------------------------

-- PRODUCTS TABLE --
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,              -- Unique identifier for each product
    product_name VARCHAR(100) NOT NULL, -- Name of the product
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0), -- Price must be a positive number
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0) -- Stock must be a non-negative integer
);

-- CUSTOMERS TABLE --
CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,              -- Unique identifier for each customer
    first_name VARCHAR(50) NOT NULL,   -- Customer's first name
    last_name VARCHAR(50) NOT NULL,    -- Customer's last name
    email VARCHAR(100) NOT NULL UNIQUE  -- Customer's email, must be unique
);

-- ORDERS TABLE --
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,              -- Unique identifier for each order
    customer_id INTEGER NOT NULL,       -- Reference to the customer who made the order
    order_date DATE NOT NULL DEFAULT CURRENT_DATE, -- Date of the order, default is today
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE -- Link to customers table
);

-- ORDER_ITEMS TABLE --
CREATE TABLE IF NOT EXISTS order_items (
    order_id INTEGER NOT NULL,          -- Reference to the order
    product_id INTEGER NOT NULL,        -- Reference to the product
    quantity INTEGER NOT NULL CHECK (quantity > 0), -- Quantity of the product in the order
    PRIMARY KEY (order_id, product_id), -- Combined primary key
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE, -- Link to orders table
    FOREIGN KEY (product_id) REFERENCES products(id) -- Link to products table
);

----------------------------------------
--    ADD INFO TO TABLES              --
----------------------------------------

-- INSERT data into the PRODUCTS table --
INSERT INTO products (product_name, price, stock_quantity) VALUES
    ('Wireless Extension Cord', 25.99, 50),
    ('Blind Mice', 12.99, 3),
    ('HotDog Water (12pk)', 19.99, 100),
    ('Fat-Free Lard', 29.49, 40),
    ('Live Teddy Bear', 399.99, 5);

-- INSERT data into the CUSTOMERS table --
INSERT INTO customers (first_name, last_name, email) VALUES
    ('Cash', 'Money', 'CashMoney@doshmail.com'),
    ('Rob', 'DeStore', 'MasterThief@kleptomail.com'),
    ('Adelle', 'EsandWhich', 'hamcheesebread@yahoo.ca'),
    ('Penny', 'Pinscher', 'Frugal.PennyP@doshmail.com');

-- INSERT data into the ORDERS table --
INSERT INTO orders (customer_id, order_date) VALUES
    (1, '2024-10-13'), -- Order 1 by Cash Money
    (2, '2024-10-12'), -- Order 2 by Rob DeStore
    (3, '2024-10-11'), -- Order 3 by Adelle EsandWhich
    (4, '2024-10-10'), -- Order 4 by Penny Pinscher
    (1, '2024-10-09'); -- Order 5 by Cash Money

-- INSERT data into the ORDER_ITEMS table --
-- Order 1 Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (1, 1, 2), -- Wireless Extension Cord x2
    (1, 3, 1); -- HotDog Water (12pk) x1

-- Order 2 Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (2, 2, 1), -- Blind Mice x1
    (2, 4, 1); -- Fat-Free Lard x1

-- Order 3 Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (3, 3, 3), -- HotDog Water (12pk) x3
    (3, 5, 1); -- Live Teddy Bear x1

-- Order 4 Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (4, 1, 1), -- Wireless Extension Cord x1
    (4, 2, 1); -- Blind Mice x1

-- Order 5 Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (5, 4, 2), -- Fat-Free Lard x2
    (5, 5, 1); -- Live Teddy Bear x1

----------------------------------------
--    ASSIGNED QUERIES                --
----------------------------------------

-- 1. Retrieve Names and Stock Quantities of All Products
SELECT product_name, stock_quantity
FROM products;

-- 2. Retrieve Product Names and Quantities for a Specific Order
SELECT p.product_name, oi.quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE oi.order_id = 1;

-- 3. Retrieve All Orders Placed by a Specific Customer
SELECT o.id AS order_id, o.order_date, p.product_name, oi.quantity
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE c.email = 'CashMoney@doshmail.com'
ORDER BY o.order_date DESC, o.id, p.product_name;

----------------------------------------
--    Updating Data                   --
----------------------------------------

-- 1. Retrieve Products and Quantities from Order 1
SELECT oi.product_id, p.product_name, oi.quantity, p.stock_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE oi.order_id = 1;

-- 2. Update stock quantities based on Order 1
UPDATE products
SET stock_quantity = stock_quantity - CASE
    WHEN id = 1 THEN 2    -- Update stock for Wireless Extension Cord
    WHEN id = 3 THEN 1    -- Update stock for HotDog Water
END
WHERE id IN (1, 3); -- Only update these products

-- 3. Verify the Updates
SELECT id, product_name, stock_quantity
FROM products
WHERE id IN (1, 3);

----------------------------------------
--    Deleting Data                   --
----------------------------------------

-- 1. Verify the Order and items
SELECT o.id AS order_id, o.order_date, 
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       p.product_name, oi.quantity
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.id = 3;

-- 2. Delete Order Items for Order ID 3
DELETE FROM order_items
WHERE order_id = 3;

-- 3. Delete Order with ID 3
DELETE FROM orders
WHERE id = 3;

-- 4. Verify the Deletion
SELECT o.id AS order_id, o.order_date, 
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       p.product_name, oi.quantity
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.id = 3;

-- Verify no order items exist for Order ID 3
SELECT *
FROM order_items
WHERE order_id = 3;
