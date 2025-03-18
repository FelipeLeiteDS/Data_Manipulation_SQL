-- Make sure you avoid conflicts, specially on version-controllled databases
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS orders;

-- Create the customers table
CREATE TABLE customer (
    id_customer INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
);

-- Create the products table
CREATE TABLE product (
    id_product INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2) NOT NULL
);

-- Create the orders table
CREATE TABLE orders (
    id_order INT PRIMARY KEY,
    id_customer INT NOT NULL,
    order_date DATE NOT NULL,
    id_product INT NOT NULL,
    FOREIGN KEY (id_customer) REFERENCES customers(id_customer),
    FOREIGN KEY (id_product) REFERENCES products(id_product)
);

-- Create indexes for better performance
CREATE INDEX idx_customer_name ON customer(name, last_name);
CREATE INDEX idx_product_name ON product(product_name);
CREATE INDEX idx_order_date ON orders(order_date);

-- Insert sample data
INSERT INTO customer (id_customer, name, last_name) VALUES
(1, 'John', 'Doe'),
(2, 'Jane', 'Smith');

INSERT INTO product (id_product, product_name, brand, category, unit_price) VALUES
(1, 'Laptop', 'TechBrand', 'Electronics', 999.99),
(2, 'Smartphone', 'MobileCo', 'Electronics', 599.99);

INSERT INTO orders (id_order, id_customer, order_date, id_product, quantity) VALUES
(1, 1, '2023-01-01', 1, 1),
(2, 2, '2023-01-02', 2, 2);
