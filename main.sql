-- Data Analysis using MySQL queries

-- 1. Total orders

SELECT COUNT(*) AS total_orders
FROM orders;

-- 2. Total sales

SELECT SUM(quantity * item_price) AS total_sales
FROM orders
JOIN item ON orders.item_id = item.item_id;

-- 3. Total items

SELECT SUM(quantity) AS total_items
FROM orders;

-- 4. Average order value

SELECT AVG(quantity * item_price) AS average_order_value
FROM orders
JOIN item ON orders.item_id = item.item_id;

-- 5. Sales by category

SELECT item_cat, SUM(quantity * item_price) AS category_sales
FROM orders
JOIN item ON orders.item_id = item.item_id
GROUP BY item_cat;

-- 6. Top spending customers

SELECT c.cust_id, CONCAT(cust_firstname, ' ', cust_lastname) AS customer_name, SUM(quantity * item_price) AS total_spent
FROM orders o
JOIN customers c ON o.cust_id = c.cust_id
JOIN item i ON o.item_id = i.item_id
GROUP BY c.cust_id
ORDER BY total_spent DESC
LIMIT 5;

-- 7. Orders per customer

SELECT c.cust_id, CONCAT(cust_firstname, ' ', cust_lastname) AS customer_name, COUNT(*) AS total_orders
FROM orders o
JOIN customers c ON o.cust_id = c.cust_id
GROUP BY c.cust_id;
Inventory Insights

-- 8. Top selling items

SELECT item_name, SUM(quantity) AS total_quantity_sold
FROM orders
JOIN item ON orders.item_id = item.item_id
GROUP BY item_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- 9. Most profitable items

SELECT i.item_id, i.item_name, SUM(quantity * item_price) AS total_sales
FROM orders o
JOIN item i ON o.item_id = i.item_id
GROUP BY i.item_id
ORDER BY total_sales DESC
LIMIT 5;

-- 10. Orders by hour

SELECT HOUR(created_at) AS order_hour, COUNT(*) AS total_orders
FROM orders
GROUP BY order_hour;

-- 11. Sales by hour

SELECT HOUR(created_at) AS order_hour, SUM(quantity * item_price) AS sales
FROM orders
JOIN item ON orders.item_id = item.item_id
GROUP BY order_hour;

-- 12. Orders by address

SELECT delivery_address1, delivery_address2, delivery_city, delivery_zipcode, COUNT(*) AS total_orders
FROM orders
JOIN address ON orders.add_id = address.add_id
GROUP BY delivery_address1, delivery_address2, delivery_city, delivery_zipcode;

-- 13. Orders by delivery/pick up

SELECT delivery, COUNT(*) AS total_orders
FROM orders
GROUP BY delivery;
Staff data requirements

-- 14. Ingredients required for each item

SELECT item_id, ing_name, (quantity * int_weight) AS total_weight_required
FROM recipe
JOIN ingridient ON recipe.ing_id = ingridient.ing_id;

-- 15. Existing stock level

SELECT item_id, SUM(quantity) AS total_stock
FROM inventory
GROUP BY item_id;
Customer Insights

-- 16. Inventory items needing restocking

SELECT i.item_id, i.item_name, SUM(quantity) AS total_ordered, inv.quantity AS current_stock
FROM orders o
JOIN item i ON o.item_id = i.item_id
LEFT JOIN inventory inv ON i.item_id = inv.item_id
GROUP BY i.item_id
HAVING total_ordered > current_stock;

-- 17. Inventory turnover rate

SELECT i.item_id, i.item_name, (SUM(quantity) / inv.quantity) AS turnover_rate
FROM orders o
JOIN item i ON o.item_id = i.item_id
JOIN inventory inv ON i.item_id = inv.item_id
GROUP BY i.item_id;
Performance Insights

-- 18. Working staff members and their shifts

SELECT rota.date, rota.shift_id, staff.staff_id, staff.first_name, staff.last_name
FROM rota
JOIN staff ON rota.staff_id = staff.staff_id;

-- 19. Cost of each item based on staff salaries

SELECT item_id, (SUM(quantity * ing_price) + COUNT(*) * hourly_rate) AS item_cost
FROM orders
JOIN recipe ON orders.item_id = recipe.item_id
JOIN ingridient ON recipe.ing_id = ingridient.ing_id
JOIN staff ON orders.add_id = staff.staff_id
GROUP BY item_id;
Stock control requirements

    
-- 20. Busiest hours for orders

SELECT HOUR(created_at) AS order_hour, COUNT(*) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 5;

-- 21. Busiest staff members

SELECT r.staff_id, CONCAT(s.first_name, ' ', s.last_name) AS staff_name, COUNT(*) AS total_orders
FROM rota r
JOIN staff s ON r.staff_id = s.staff_id
GROUP BY r.staff_id
ORDER BY total_orders DESC
LIMIT 5;

