-- ============================================================
-- DATABASE DESIGN: Customers, Products & Orders
-- ============================================================
-- DROP order matters: child tables (orders) must be dropped
-- before parent tables (customers, products) to avoid
-- foreign key constraint violations.
-- ============================================================

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;


-- ------------------------------------------------------------
-- 1. CUSTOMERS TABLE
-- email is UNIQUE to prevent duplicate accounts.
-- created_at provides an audit trail automatically.
-- ------------------------------------------------------------
CREATE TABLE customers (
    id_customer  INT PRIMARY KEY AUTO_INCREMENT,
    name         VARCHAR(100)  NOT NULL,
    last_name    VARCHAR(100)  NOT NULL,
    email        VARCHAR(150)  NOT NULL UNIQUE,
    created_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);


-- ------------------------------------------------------------
-- 2. PRODUCTS TABLE
-- unit_price uses DECIMAL (never FLOAT) to avoid rounding
-- errors in financial calculations.
-- ------------------------------------------------------------
CREATE TABLE products (
    id_product   INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100)  NOT NULL,
    brand        VARCHAR(100),
    category     VARCHAR(50),
    unit_price   DECIMAL(10, 2) NOT NULL
);


-- ------------------------------------------------------------
-- 3. ORDERS TABLE
-- quantity is defined here so the INSERT data is valid.
-- Foreign keys enforce referential integrity: an order cannot
-- reference a customer or product that doesn't exist.
-- ------------------------------------------------------------
CREATE TABLE orders (
    id_order     INT PRIMARY KEY AUTO_INCREMENT,
    id_customer  INT           NOT NULL,
    id_product   INT           NOT NULL,
    order_date   DATE          NOT NULL,
    quantity     INT           NOT NULL DEFAULT 1,
    created_at   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_customer) REFERENCES customers(id_customer),
    FOREIGN KEY (id_product)  REFERENCES products(id_product)
);


-- ------------------------------------------------------------
-- 4. INDEXES
-- Speeds up common lookups: searching customers by name,
-- filtering products by name, and querying orders by date.
-- ------------------------------------------------------------
CREATE INDEX idx_customer_name ON customers(name, last_name);
CREATE INDEX idx_product_name  ON products(product_name);
CREATE INDEX idx_order_date    ON orders(order_date);


-- ------------------------------------------------------------
-- 5. SAMPLE DATA
-- AUTO_INCREMENT handles IDs automatically — no manual values
-- needed, which avoids primary key conflicts on re-runs.
-- ------------------------------------------------------------
INSERT INTO customers (name, last_name, email) VALUES
    ('John', 'Doe',   'john.doe@email.com'),
    ('Jane', 'Smith', 'jane.smith@email.com');

INSERT INTO products (product_name, brand, category, unit_price) VALUES
    ('Laptop',      'BrandX', 'Electronics', 999.99),
    ('Smartphone',  'BrandY',  'Electronics', 599.99);

INSERT INTO orders (id_customer, id_product, order_date, quantity) VALUES
    (1, 1, '2026-01-01', 1),
    (2, 2, '2026-01-02', 2);
