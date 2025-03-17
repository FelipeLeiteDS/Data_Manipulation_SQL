-- Create and select database
CREATE DATABASE commercial_department;
USE commercial_department;

-- Make sure you avoid conflicts, specially on version-controllled databases
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;

-- Create the customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

-- Create the products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    brand VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10, 2)
);

-- Create the orders table
CREATE TABLE orders (
    orders_id INT PRIMARY KEY,
    customer_is INT,
    order_date DATE,
    product_code INT,
    FOREIGN KEY (id_customer) REFERENCES customers(customer_id),
    FOREIGN KEY (product_code) REFERENCES products(product_code)
);

-- Create indexes for better performance
CREATE INDEX idx_customer_name ON customers(name, last_name);
CREATE INDEX idx_product_name ON products(product_name);
CREATE INDEX idx_order_date ON orders(order_date);
