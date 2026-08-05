-- ===================================================================
-- SUBMISSION COMPONENT: 01_schema.sql
-- PURPOSE: Database initialization, normalized tables, and index paths
-- ===================================================================

-- 1. Create the physical database engine instance from scratch
CREATE DATABASE IF NOT EXISTS enterprise_bi_system;
USE enterprise_bi_system;

-- Clear previous tables to ensure clean, repetitive grading deployments
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;


-- 2. NORMALIZED TABLES STRUCTURE (3NF Relational Architecture)

-- Customer Profiles Ledger
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    region VARCHAR(50),
    join_date DATE NOT NULL
);

-- Master Inventory Product Catalog
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    cost_price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
);

-- Operational Order Headers
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(20) DEFAULT 'Pending',
    -- Relational Integrity Constraints
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE RESTRICT
);

-- Granular Transactional Line Items (Resolves Many-to-Many Relationships)
CREATE TABLE order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price_at_sale DECIMAL(10, 2) NOT NULL,
    -- Cascading Deletions and Relational Links
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
);


-- 3. QUERY PERFORMANCE OPTIMIZATION LAYER (B-Tree Custom Index Paths)

-- Accelerates table joins linking transaction records back to customer accounts
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Accelerates historical period filtering and chronological sorting pipelines
CREATE INDEX idx_orders_order_date ON orders(order_date);

-- Accelerates low-level line-item searches checking product catalogs
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Accelerates global categorical filtering and business unit aggregations
CREATE INDEX idx_products_category ON products(category);
