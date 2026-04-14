-- ============================================================
-- DATA QUALITY: Duplicates, Inconsistencies, Joins & Updates
-- ============================================================


-- ------------------------------------------------------------
-- 1. QUICK DUPLICATE CHECK
-- Count occurrences of each product name to spot duplicates.
-- ------------------------------------------------------------
SELECT product_name, COUNT(*) AS occurrences
FROM products
GROUP BY product_name;


-- ------------------------------------------------------------
-- 2. ENRICHED ORDERS VIEW (fact + dimension join)
-- LEFT JOINs preserve all orders even when the customer or product
-- data is missing — useful for spotting referential integrity issues.
-- COALESCE replaces NULLs with a fallback so reports stay clean.
-- ------------------------------------------------------------
SELECT
    o.id_order,
    o.id_customer,
    o.order_date,
    o.id_product,
    COALESCE(c.name, 'Unknown')      AS customer_name,
    COALESCE(c.last_name, 'Unknown') AS customer_last_name,
    COALESCE(p.product_name, 'N/A')  AS product_name
FROM orders o
LEFT JOIN customers c
    ON o.id_customer = c.id_customer
LEFT JOIN products p
    ON o.id_product = p.id_product;


-- ------------------------------------------------------------
-- 3. SAFE UPDATE PATTERN
-- Always wrap destructive changes in a transaction so you can
-- roll back if the WHERE clause targets the wrong rows.
-- ------------------------------------------------------------
START TRANSACTION;

UPDATE products
SET column_name = 'new_value'
WHERE id_product = 'condition_value';

-- Verify the change before committing:
-- SELECT * FROM products WHERE id_product = 'condition_value';
ROLLBACK; -- swap for COMMIT; once you've confirmed the result


-- ------------------------------------------------------------
-- 4. OTHER HANDY MAINTENANCE COMMANDS
-- TRUNCATE removes all rows but keeps the table structure.
-- DELETE targets specific rows by condition.
-- ------------------------------------------------------------

-- Remove all rows (faster than DELETE with no WHERE):
TRUNCATE TABLE table_name;

-- Remove a single row by primary key:
DELETE FROM products
WHERE id_product = 10;


-- ------------------------------------------------------------
-- 5A. FIND DUPLICATES — subquery approach
-- Returns only duplicated products along with an is_duplicated flag.
-- Useful when you need the extra label column for exports or dashboards.
-- ------------------------------------------------------------
SELECT
    a.product_name,
    a.brand,
    a.category,
    a.occurrences,
    CASE
        WHEN a.occurrences > 1 THEN 'Yes'
        ELSE 'No'
    END AS is_duplicated
FROM (
    SELECT
        product_name,
        brand,
        category,
        COUNT(*) AS occurrences
    FROM products
    GROUP BY product_name, brand, category
) a
WHERE a.occurrences > 1;


-- ------------------------------------------------------------
-- 5B. FIND DUPLICATES — HAVING approach (cleaner for quick checks)
-- Prefer this when you only need to list the duplicated groups.
-- ------------------------------------------------------------
SELECT
    product_name,
    brand,
    category,
    COUNT(*) AS occurrences
FROM products
GROUP BY product_name, brand, category
HAVING COUNT(*) > 1;


-- ------------------------------------------------------------
-- 5C. FIND DUPLICATES — ROW_NUMBER() approach (modern, interview-ready)
-- Assigns a row number within each duplicate group. Rows where
-- row_num > 1 are the duplicates — easy to DELETE or inspect.
-- ------------------------------------------------------------
WITH ranked_products AS (
    SELECT
        id_product,
        product_name,
        brand,
        category,
        ROW_NUMBER() OVER (
            PARTITION BY product_name, brand, category
            ORDER BY id_product
        ) AS row_num
    FROM products
)
SELECT *
FROM ranked_products
WHERE row_num > 1;

-- To delete the duplicates, swap the final SELECT for:
-- DELETE FROM products WHERE id_product IN (
--     SELECT id_product FROM ranked_products WHERE row_num > 1
-- );


-- ------------------------------------------------------------
-- 6. COUNT DISTINCT PRICES PER PRODUCT
-- Flags products with inconsistent pricing across orders.
-- More than 1 distinct price may indicate a data entry error.
-- ------------------------------------------------------------
SELECT
    product_name,
    COUNT(DISTINCT unit_price) AS distinct_price_count
FROM products
GROUP BY product_name
HAVING COUNT(DISTINCT unit_price) > 1;
