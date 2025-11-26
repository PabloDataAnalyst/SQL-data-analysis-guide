/* ===========================================================
   🧠 SQL DATA ANALYSIS GUIDE
   Level: Basic → Intermediate → Advanced
   Author: Pablo
   ===========================================================
*/


/* ===========================================================
   🔹 KEY CONCEPTS
   ===========================================================

   SELECT, FROM, WHERE, ORDER BY, GROUP BY, HAVING
   JOIN → INNER, LEFT, RIGHT, FULL
   Aggregation functions → COUNT, SUM, AVG, MIN, MAX
   Subqueries, nested subqueries and CTE (WITH)
*/


/* ===========================================================
   🔸 1. BASIC QUERY STRUCTURE
   =========================================================== */
SELECT columns
FROM table
WHERE condition
GROUP BY column
HAVING aggregated_condition
ORDER BY column ASC;


/* ===========================================================
   🔸 2. GROUP BY – GROUP AND AGGREGATE
   ===========================================================

   Rules:
   1️⃣ Real columns in SELECT → must be in GROUP BY.
   2️⃣ Calculated columns (e.g. CONCAT) → group by their bases.
   3️⃣ Aggregation functions (SUM, AVG…) → do not go in GROUP BY.
   4️⃣ Aggregation aliases → never used in GROUP BY.
*/

SELECT genre, SUM(total_sales) AS sales
FROM videogames
GROUP BY genre
ORDER BY sales DESC;


/* ===========================================================
   🔸 3. WHERE vs HAVING
   ===========================================================

   WHERE  → filters rows before grouping.
   HAVING → filters groups after grouping.
*/

-- WHERE
SELECT *
FROM Orders
WHERE order_date >= '2025-01-01';

-- HAVING
SELECT customer_id, COUNT(*) AS num_orders
FROM Orders
GROUP BY customer_id
HAVING COUNT(*) > 5;


/* ===========================================================
   🔸 4. COMMON FUNCTIONS AND OPERATORS
   =========================================================== */

-- Filter by different value
WHERE column <> 'value';

-- Remainder of a division
SELECT 10 % 3 AS remainder;  -- Returns 1

-- Simple conditional
SELECT product_name,
       price,
       IF(price > 100, 'Expensive', 'Cheap') AS price_category
FROM products;

-- Search by partial text
SELECT *
FROM customers
WHERE name LIKE 'J%';   -- Starts with “J”

-- Replace null values
SELECT COALESCE(primary_col, backup_col) AS filled_col
FROM table_name;


/* ===========================================================
   🔸 5. FORMAT, NAMING AND COMMENTS
   ===========================================================

   🧩 Style:
   - Keywords in UPPERCASE
   - Tables in CamelCase (CustomerData)
   - Columns in snake_case (total_sales)
   - Aliases with AS → SELECT SUM(sales) AS total_sales
   - Comments:  -- one line   |   /* multiple lines */
*/


/* ===========================================================
   🔸 6. TABLE MANIPULATION
   =========================================================== */

-- Create table
CREATE TABLE IF NOT EXISTS employees (
    id INT,
    name TEXT,
    department TEXT
);

-- Drop table
DROP TABLE IF EXISTS old_table;

-- Update values
UPDATE employees
SET department = 'Finance'
WHERE id = 10;

-- Insert data manually
INSERT INTO employees (id, name, department)
VALUES (1, 'John', 'Sales');


/* ===========================================================
   🔸 7. CAST AND FORMAT CONVERSION
   =========================================================== */

-- Change column type
ALTER TABLE car_info
ALTER COLUMN price TYPE numeric USING price::numeric;

-- Use format temporarily
SELECT CAST(date AS DATE) AS date_only
FROM orders;


/* ===========================================================
   🔸 8. DATA CLEANING
   =========================================================== */

-- Remove duplicates
SELECT DISTINCT column_name
FROM table_name;

-- Text length
SELECT LENGTH(name) AS name_length
FROM customers;

-- Remove spaces
SELECT TRIM(state) AS state_clean
FROM customer_table;


/* ===========================================================
   🔸 9. TEXT CONCATENATION
   =========================================================== */

-- Concatenate columns
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- Concatenate with separator
SELECT CONCAT_WS('.', 'www', 'company', 'com') AS website;


/* ===========================================================
   🔸 10. JOINS – COMBINE TABLES
   =========================================================== */

-- INNER JOIN (matches only)
SELECT e.name, d.department_name
FROM employees AS e
INNER JOIN departments AS d
ON e.department_id = d.id;

-- LEFT JOIN (all from left + matches)
SELECT e.name, d.department_name
FROM employees AS e
LEFT JOIN departments AS d
ON e.department_id = d.id;

-- RIGHT JOIN (all from right)
SELECT e.name, d.department_name
FROM employees AS e
RIGHT JOIN departments AS d
ON e.department_id = d.id;

-- FULL OUTER JOIN (all from both sides)
SELECT e.name, d.department_name
FROM employees AS e
FULL OUTER JOIN departments AS d
ON e.department_id = d.id;


/* ===========================================================
   🔸 11. CONDITIONALS WITH CASE
   =========================================================== */

SELECT
    first_name,
    CASE
        WHEN country = 'US' THEN 'United States'
        WHEN country = 'UK' THEN 'United Kingdom'
        ELSE 'Other'
    END AS country_clean
FROM users;


/* ===========================================================
   🔸 12. SUBQUERIES AND CTEs
   =========================================================== */

-- Nested subquery
SELECT name, total_sales
FROM sales
WHERE total_sales > (SELECT AVG(total_sales) FROM sales);

-- CTE (Common Table Expression)
WITH frequent_customers AS (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) > 5
)
SELECT *
FROM customers
WHERE customer_id IN (SELECT customer_id FROM frequent_customers);


/* ===========================================================
   🔸 13. TEMPORARY TABLES
   =========================================================== */

CREATE TEMP TABLE temp_orders AS
SELECT *
FROM orders
WHERE order_date >= '2025-01-01';


/* ===========================================================
   🔸 14. WINDOW FUNCTIONS
   =========================================================== */

-- Calculate averages by group
SELECT
    department,
    employee_name,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS avg_salary_by_dept
FROM employees;

-- Sales ranking
WITH SalesCTE AS (
    SELECT customer_id, SUM(amount) AS total_sales
    FROM sales
    GROUP BY customer_id
)
SELECT *,
       ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS ranking
FROM SalesCTE;


/* ===========================================================
   🏁 END OF GUIDE
   ===========================================================
*/
