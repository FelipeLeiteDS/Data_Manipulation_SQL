# SQL Data Quality Management: Handling Duplicates in E-Commerce Data

## Overview

This repository showcases my expertise in using SQL for data quality management, specifically focusing on identifying and handling duplicate values in an e-commerce database. These techniques are crucial for maintaining data integrity, which is essential for accurate reporting and analysis in real-world business scenarios.

## Key Features

- Identification of duplicate records across various tables
- Join operations to enrich data and identify inconsistencies
- Data update and deletion strategies
- Advanced querying techniques for data quality assessment

## Techniques Demonstrated

### 1. Identifying Duplicate Values

I use aggregation and grouping to quickly identify duplicate entries:

```sql
SELECT product_name, COUNT(*)
FROM product
GROUP BY product_name;
```

This query is vital for initial data quality checks, especially after data imports or updates.

### 2. Enriching Data with Joins

To get a comprehensive view of potential duplicates across related tables:

```sql
SELECT
    s.id, s.id_customer, s.sale_date, s.product_code
    , c.name, c.last_name
    , p.product_name
    , COUNT(*) AS duplicated
FROM sales s
LEFT JOIN customers c
    ON s.id_customer = c.id_customer
LEFT JOIN products p
    ON s.product_code = p.product_code
GROUP BY s.id, s.id_customer, s.sale_date, s.product_code, c.name, c.last_name, p.product_name;
```

This join operation helps in identifying inconsistencies across sales, customer, and product data.

### 3. Data Cleansing Operations

For updating incorrect data:

```sql
UPDATE <table>
SET column = 'new_value'
WHERE key = 'condition_value';
```

And for removing duplicate or erroneous entries:

```sql
DELETE FROM product
WHERE product_code = 10;
```

### 4. Advanced Duplicate Detection

Using subqueries and CASE statements for more nuanced duplicate detection:

```sql
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
```

This query not only identifies duplicates but also labels them, facilitating easier data cleaning processes.

### 5. Data Quality Metrics

Assessing data quality through metrics like distinct price counts:

```sql
SELECT
    product_name
    , COUNT(DISTINCT unit_price) AS total_distinct_prices
FROM products
GROUP BY product_name;
```

This helps in identifying pricing inconsistencies, a common issue in e-commerce data.

## Real-World Application

In my e-commerce data management projects, these SQL techniques have been instrumental in:

- Ensuring data consistency across sales, inventory, and customer databases
- Identifying and resolving product listing duplicates, improving catalog accuracy
- Detecting pricing anomalies, crucial for maintaining competitive and fair pricing
- Streamlining data cleaning processes, reducing manual intervention and error

## Conclusion

This SQL toolkit demonstrates my ability to maintain high data quality standards in complex e-commerce databases. By effectively managing duplicates and inconsistencies, I ensure that downstream analytics and business decisions are based on accurate, reliable data. These skills are essential in today's data-driven business environment, where data quality directly impacts operational efficiency and strategic decision-making.

## Portfolio and Contact
- Explore my work and connect with me:

<div> 
  <a href = "https://linktr.ee/FelipeLeiteDS"><img src="https://img.shields.io/badge/LinkTree-1de9b6?logo=linktree&logoColor=white" target="_blank"></a>
  <a href = "https://www.linkedin.com/in/felipeleiteds/" target="_blank"><img src="https://custom-icon-badges.demolab.com/badge/LinkedIn-0A66C2?logo=linkedin-white&logoColor=fff" target="_blank"></a> 
  <a href = "https://www.felipeleite.ca"><img src="https://img.shields.io/badge/FelipeLeite.ca-%23000000.svg?logo=wix&logoColor=white" target="_blank"></a>
  <a href = "mailto:felipe.nog.leite@gmail.com"><img src="https://img.shields.io/badge/Gmail-D14836?logo=gmail&logoColor=white" target="_blank"></a>
