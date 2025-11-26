/* ===========================================================
   🧠 SQL DATA ANALYSIS GUIDE
   Nivel: Básico → Intermedio → Avanzado
   Autor: Pablo
   ===========================================================
*/


/* ===========================================================
   🔹 CONCEPTOS CLAVE
   ===========================================================

   SELECT, FROM, WHERE, ORDER BY, GROUP BY, HAVING
   JOIN → INNER, LEFT, RIGHT, FULL
   Funciones de agregación → COUNT, SUM, AVG, MIN, MAX
   Subconsultas, subconsultas anidadas y CTE (WITH)
*/


/* ===========================================================
   🔸 1. ESTRUCTURA BÁSICA DE UNA CONSULTA
   =========================================================== */
SELECT columnas
FROM tabla
WHERE condición
GROUP BY columna
HAVING condición_agregada
ORDER BY columna ASC;


/* ===========================================================
   🔸 2. GROUP BY – AGRUPAR Y AGREGAR
   ===========================================================

   Reglas:
   1️⃣ Columnas reales del SELECT → deben ir en GROUP BY.
   2️⃣ Columnas calculadas (ej. CONCAT) → agrupa por las bases.
   3️⃣ Funciones de agregación (SUM, AVG…) → no van en GROUP BY.
   4️⃣ Alias de agregación → nunca se usan en GROUP BY.
*/

SELECT genre, SUM(total_sales) AS sales
FROM videogames
GROUP BY genre
ORDER BY sales DESC;


/* ===========================================================
   🔸 3. WHERE vs HAVING
   ===========================================================

   WHERE  → filtra filas antes de agrupar.
   HAVING → filtra grupos después de agrupar.
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
   🔸 4. FUNCIONES Y OPERADORES COMUNES
   =========================================================== */

-- Filtrar por valor distinto
WHERE columna <> 'valor';

-- Resto de una división
SELECT 10 % 3 AS remainder;  -- Devuelve 1

-- Condicional simple
SELECT product_name,
       price,
       IF(price > 100, 'Expensive', 'Cheap') AS price_category
FROM products;

-- Buscar por texto parcial
SELECT *
FROM customers
WHERE name LIKE 'J%';   -- Empieza por “J”

-- Reemplazar valores nulos
SELECT COALESCE(primary_col, backup_col) AS filled_col
FROM table_name;


/* ===========================================================
   🔸 5. FORMATO, NOMBRADO Y COMENTARIOS
   ===========================================================

   🧩 Estilo:
   - Palabras clave en MAYÚSCULAS
   - Tablas en CamelCase (CustomerData)
   - Columnas en snake_case (total_sales)
   - Alias con AS → SELECT SUM(sales) AS total_sales
   - Comentarios:  -- una línea   |   /* varias líneas */
*/


/* ===========================================================
   🔸 6. MANIPULACIÓN DE TABLAS
   =========================================================== */

-- Crear tabla
CREATE TABLE IF NOT EXISTS employees (
    id INT,
    name TEXT,
    department TEXT
);

-- Eliminar tabla
DROP TABLE IF EXISTS old_table;

-- Actualizar valores
UPDATE employees
SET department = 'Finance'
WHERE id = 10;

-- Insertar datos manualmente
INSERT INTO employees (id, name, department)
VALUES (1, 'John', 'Sales');


/* ===========================================================
   🔸 7. CAST y CONVERSIÓN DE FORMATOS
   =========================================================== */

-- Cambiar tipo de una columna
ALTER TABLE car_info
ALTER COLUMN price TYPE numeric USING price::numeric;

-- Usar formato temporalmente
SELECT CAST(date AS DATE) AS date_only
FROM orders;


/* ===========================================================
   🔸 8. LIMPIEZA DE DATOS
   =========================================================== */

-- Eliminar duplicados
SELECT DISTINCT column_name
FROM table_name;

-- Longitud de texto
SELECT LENGTH(name) AS name_length
FROM customers;

-- Quitar espacios
SELECT TRIM(state) AS state_clean
FROM customer_table;


/* ===========================================================
   🔸 9. CONCATENAR TEXTO
   =========================================================== */

-- Concatenar columnas
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers;

-- Concatenar con separador
SELECT CONCAT_WS('.', 'www', 'company', 'com') AS website;


/* ===========================================================
   🔸 10. JOINS – COMBINAR TABLAS
   =========================================================== */

-- INNER JOIN (solo coincidencias)
SELECT e.name, d.department_name
FROM employees AS e
INNER JOIN departments AS d
ON e.department_id = d.id;

-- LEFT JOIN (todo de la izquierda + coincidencias)
SELECT e.name, d.department_name
FROM employees AS e
LEFT JOIN departments AS d
ON e.department_id = d.id;

-- RIGHT JOIN (todo de la derecha)
SELECT e.name, d.department_name
FROM employees AS e
RIGHT JOIN departments AS d
ON e.department_id = d.id;

-- FULL OUTER JOIN (todo de ambas)
SELECT e.name, d.department_name
FROM employees AS e
FULL OUTER JOIN departments AS d
ON e.department_id = d.id;


/* ===========================================================
   🔸 11. CONDICIONALES CON CASE
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
   🔸 12. SUBCONSULTAS Y CTEs
   =========================================================== */

-- Subconsulta anidada
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
   🔸 13. TABLAS TEMPORALES
   =========================================================== */

CREATE TEMP TABLE temp_orders AS
SELECT *
FROM orders
WHERE order_date >= '2025-01-01';


/* ===========================================================
   🔸 14. FUNCIONES WINDOW
   =========================================================== */

-- Calcular promedios por grupo
SELECT
    department,
    employee_name,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS avg_salary_by_dept
FROM employees;

-- Ranking de ventas
WITH SalesCTE AS (
    SELECT customer_id, SUM(amount) AS total_sales
    FROM sales
    GROUP BY customer_id
)
SELECT *,
       ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS ranking
FROM SalesCTE;


/* ===========================================================
   🏁 FIN DE LA GUÍA
   ===========================================================
*/
