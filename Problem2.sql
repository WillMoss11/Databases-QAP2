--************************************************--
-- PROBLEM TWO: Store Inventory and Orders System --
--************************************************--

-- Created by: William Moss --
-- Date: 10-13-2024 --

----------------------------------------
--    SETTING UP THE DATABASE          --
----------------------------------------

-- Let's create a table for our products.
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,              -- Each product will have a unique ID
    product_name VARCHAR(100) NOT NULL, -- The name of the product
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0), -- Price must be a positive number
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0) -- Stock must be non-negative
);

-- Now, let's set up a table for our customers.
CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,              -- Each customer will have a unique ID
    first_name VARCHAR(50) NOT NULL,   -- Customer's first name
    last_name VARCHAR(50) NOT NULL,    -- Customer's last name
    email VARCHAR(100) NOT NULL UNIQUE  -- Each customer will have a unique email
);

-- Next, we need a table for orders.
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,              -- Each order will have a unique ID
    customer_id INTEGER NOT NULL,       -- This links the order to a customer
    order_date DATE NOT NULL DEFAULT CURRENT_DATE, -- The date the order was placed
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE -- Links to the customers table
);

-- Finally, let's create a table for the items in each order.
CREATE TABLE IF NOT EXISTS order_items (
    order_id INTEGER NOT NULL,          -- This links to the order
    product_id INTEGER NOT NULL,        -- This links to the product
    quantity INTEGER NOT NULL CHECK (quantity > 0), -- The number of each product in the order
    PRIMARY KEY (order_id, product_id), -- This ensures each item is unique within an order
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE, -- Links to orders table
    FOREIGN KEY (product_id) REFERENCES products(id) -- Links to products table
);

----------------------------------------
--    ADDING SOME DATA                --
----------------------------------------

-- Let's fill our products table with some cool items.
INSERT INTO products (product_name, price, stock_quantity) VALUES
    ('Wireless Extension Cord', 25.99, 50),
    ('Blind Mice', 12.99, 3),
    ('HotDog Water (12pk)', 19.99, 100),
    ('Fat-Free Lard', 29.49, 40),
    ('Live Teddy Bear', 399.99, 5);

-- Now, let's add some customers.
INSERT INTO customers (first_name, last_name, email) VALUES
    ('Cash', 'Money', 'CashMoney@doshmail.com'),
    ('Rob', 'DeStore', 'MasterThief@kleptomail.com'),
    ('Adelle', 'EsandWhich', 'hamcheesebread@yahoo.ca'),
    ('Penny', 'Pinscher', 'Frugal.PennyP@doshmail.com');

-- Next, we'll add some orders.
INSERT INTO orders (customer_id, order_date) VALUES
    (1, '2024-10-13'), -- Order by Cash Money
    (2, '2024-10-12'), -- Order by Rob DeStore
    (3, '2024-10-11'), -- Order by Adelle EsandWhich
    (4, '2024-10-10'), -- Order by Penny Pinscher
    (1, '2024-10-09'); -- Another order by Cash Money

-- And now, let's add the items for each order.
INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (1, 1, 2), -- Cash Money ordered 2 Wireless Extension Cords
    (1, 3, 1), -- Cash Money also ordered 1 HotDog Water (12pk)

-- For Rob's order...
INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (2, 2, 1), -- Rob ordered 1 Blind Mice
    (2, 4, 1); -- ...and 1 Fat-Free Lard

-- For Adelle's order...
INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (3, 3, 3), -- Adelle went big with 3 HotDog Water (12pk)
    (3, 5, 1); -- ...and a Live Teddy Bear

-- For Penny's order...
INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (4, 1, 1), -- Penny got 1 Wireless Extension Cord
    (4, 2, 1); -- ...and 1 Blind Mice

-- Last but not least, Cash Money's second order...
INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (5, 4, 2), -- Cash ordered 2 Fat-Free Lard
    (5, 5, 1); -- ...and another Live Teddy Bear

----------------------------------------
--    QUERYING DATA                   --
----------------------------------------

-- 1. Let's see all products and their stock levels.
SELECT product_name, stock_quantity
FROM products;

-- 2. Want to know what was in Order 1? Here you go!
SELECT p.product_name, oi.quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE oi.order_id = 1;

-- 3. What did Cash Money order? Let’s find out!
SELECT o.id AS order_id, o.order_date, p.product_name, oi.quantity
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE c.email = 'CashMoney@doshmail.com'
ORDER BY o.order_date DESC, o.id, p.product_name;

----------------------------------------
--    UPDATING DATA                   --
----------------------------------------

-- 1. Let's check what products were in Order 1.
SELECT oi.product_id, p.product_name, oi.quantity, p.stock_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.id
WHERE oi.order_id = 1;

-- 2. Time to update stock based on Order 1!
UPDATE products
SET stock_quantity = stock_quantity - CASE
    WHEN id = 1 THEN 2    -- Reduce stock for Wireless Extension Cord
    WHEN id = 3 THEN 1    -- Reduce stock for HotDog Water
END
WHERE id IN (1, 3); -- Only update these two products

-- 3. Let’s see how the stock looks now.
SELECT id, product_name, stock_quantity
FROM products
WHERE id IN (1, 3);

----------------------------------------
--    DELETING DATA                   --
----------------------------------------

-- 1. Let’s confirm the details for Order 3.
SELECT o.id AS order_id, o.order_date, 
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       p.product_name, oi.quantity
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.id = 3;

-- 2. Time to delete the items from Order 3.
DELETE FROM order_items
WHERE order_id = 3;

-- 3. Now let's delete the entire Order 3.
DELETE FROM orders
WHERE id = 3;

-- 4. Let’s check to see if Order 3 is really gone.
SELECT o.id AS order_id, o.order_date, 
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       p.product_name, oi.quantity
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.id = 3;

-- Verify no items exist for Order 3.
SELECT *
FROM order_items
WHERE order_id = 3;
