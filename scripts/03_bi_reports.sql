-- ===================================================================
-- SUBMISSION COMPONENT: 03_bi_reports.sql
-- PURPOSE: Business Intelligence KPI Views & Advanced Analytical Metrics
-- ===================================================================
USE enterprise_bi_system;

-- VIEW 1: Core Sales Performance & Profit Metrics Matrix
-- Purpose: Pulls transaction data to feed your Chartle Category Bar Chart visual.
CREATE OR REPLACE VIEW vw_bi_sales_performance_kpis AS
SELECT 
    p.category AS product_category,
    COUNT(DISTINCT o.order_id) AS total_orders_processed,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.unit_price_at_sale) AS gross_revenue,
    SUM(oi.quantity * (oi.unit_price_at_sale - p.cost_price)) AS net_profit
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status <> 'Cancelled'
GROUP BY p.category;


-- VIEW 2: Global Corporate Health Scorecard Metrics
-- Purpose: Aggregates enterprise totals into single fields for KPI Callout Cards.
CREATE OR REPLACE VIEW vw_bi_global_scorecard_kpis AS
SELECT 
    SUM(gross_revenue) AS global_gross_revenue,
    SUM(net_profit) AS global_net_profit,
    SUM(total_units_sold) AS global_total_units_sold
FROM vw_bi_sales_performance_kpis;


-- VIEW 3: Customer Lifetime Value (CLV) Cohorts & Regional Rankings
-- Purpose: Uses window functions to rank clients dynamically within geographic zones.
CREATE OR REPLACE VIEW vw_bi_customer_clv_analytics AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_fullname,
    c.region,
    COUNT(DISTINCT o.order_id) AS purchase_frequency,
    SUM(oi.quantity * oi.unit_price_at_sale) AS customer_lifetime_value,
    -- Advanced Window Function to rank customer spend within their specific region
    RANK() OVER (PARTITION BY c.region ORDER BY SUM(oi.quantity * oi.unit_price_at_sale) DESC) AS regional_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.region;


-- ===================================================================
-- EXECUTIVE VERIFICATION CHECK CALLS
-- ===================================================================
SELECT * FROM vw_bi_sales_performance_kpis ORDER BY net_profit DESC;
SELECT * FROM vw_bi_global_scorecard_kpis;
SELECT * FROM vw_bi_customer_clv_analytics WHERE regional_rank = 1;
