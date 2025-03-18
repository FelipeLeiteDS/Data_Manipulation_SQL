-- Duplicate values, Inconsistency, Joins, and Updates

-- Identifying duplicate values - Count'em!
SELECT product_name, COUNT(*)
FROM product
GROUP BY product_name;

-- Join to get information for a fact table from a dimension table
SELECT
    o.id, o.id_customer, o.order_date, o.id_product
    , c.name, c.last_name
    , p.product_name
    , COUNT(*) AS duplicated
FROM orders o
LEFT JOIN customer c
    ON o.id_customer = c.id_customer
LEFT JOIN product p
    ON o.id_product = p.id_product
GROUP BY o.id_order, o.id_customer, o.order_date, o.id_product, c.name, c.last_name, p.product_name;

-- Command to update information in the tables
UPDATE <table>
SET column = 'new_value'
WHERE key = 'condition_value';

-- Handy functions
START TRANSACTION;
ROLLBACK;
TRUNCATE TABLE table_name;

-- Deleting row
DELETE FROM product
WHERE id_product = 10;

-- Dealing with duplicated values (subquery approach)
SELECT a.product_name, a.brand, a.category, a.duplicated,
    CASE WHEN a.duplicated > 1 THEN 'Yes'
        WHEN a.duplicated = 1 THEN 'No'
    END AS is_duplicated
FROM
(
    SELECT
        product_name, brand, category,
        COUNT(*) AS duplicated
    FROM product
    GROUP BY product_name, brand, category
) a
WHERE a.duplicated > 1;

-- Another way to consult duplicated items
SELECT
    product_name
    , brand
    , category
    , COUNT(*) AS duplicated
FROM products
GROUP BY product_name, brand, category
HAVING COUNT(*) > 1;

-- Getting distinct prices for each product
SELECT
    product_name
    , COUNT(DISTINCT unit_price) AS total_distinct_prices
FROM products
GROUP BY product_name;
