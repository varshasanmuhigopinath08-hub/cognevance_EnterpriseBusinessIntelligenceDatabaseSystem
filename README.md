# cognevance_EnterpriseBusinessIntelligenceDatabaseSystem
A normalized MySQL Student Management System featuring advanced database schemas, transactional queries, and aggregate reports for academic analytics.
# Enterprise Business Intelligence Database System

## Project Overview
This repository delivers an end-to-end, enterprise-level SQL analytics and database automation system. It features a fully normalized 3rd Normal Form (3NF) relational schema, automated inventory auditing pipelines via database triggers, optimized B-Tree query indexing paths, and pre-computed analytical reporting views engineered for direct integration with front-end BI visualization platforms like Power BI or Tableau.

---

## Core Project Workflow

![Enterprise Core System Workflow Mapping](docs/Workflow.png)


## Database Normalization Design (3NF)

The schema utilizes a clean relational architecture designed to eliminate data redundancy and block processing anomalies:
*   **`customers`**: Holds client demographic profiles and account timeline registries.
*   **`products`**: Catalog details isolating inventory descriptions, baseline pricing, and margins.
*   **`orders`**: Transaction header tracking invoice event dates and logistical statuses.
*   **`order_items`**: Atomic transaction lines resolving the many-to-many relationship mapping between orders and products.
*   **`inventory_logs`**: System audit table populated entirely via asynchronous database trigger logic.

---

## Performance Optimization Layer
To ensure corporate-level scalability and eliminate sluggish, resource-heavy disk sweeps, high-speed **B-Tree Indexes** are explicitly deployed across high-frequency conditional search paths:
*   `idx_orders_customer_id`: Speeds up deep cross-table transactional joins.
*   `idx_orders_order_date`: Optimizes time-series filtering and chronological groupings.
*   `idx_products_category`: Streamlines bulk inventory category aggregations.

---

## Advanced System Automations

### 1. Event-Driven Audit Trigger (`trg_track_inventory`)
Monitors the master inventory catalog dynamically. The millisecond an item's stock quantity is modified, the trigger captures the product identifier, records the original stock level versus the new stock level, and stamps an entry into the system log ledger automatically.

### 2. Global Pricing Stored Procedure (`prc_adjust_category_prices`)
An administrative utility allowing developers to dynamically execute global price adjustments across entire inventory categories using scalable safe-decimal percentage multipliers.

---

## Executive BI Dashboard Mapping Diagram

The pre-computed database reporting views map directly to front-end visual elements to drive business insights at a single glance:

1.  ** Product Category Performance Matrix**
    *   **SQL View Source**: `vw_bi_sales_performance_kpis`
    *   **Dashboard Visual**: Clustered Column/Bar Chart
    *   **Computed Metrics**: `gross_revenue` vs. `net_profit`
2.  ** Global Revenue Scorecards**
    *   **SQL View Source**: `vw_bi_global_scorecard_kpis`
    *   **Dashboard Visual**: Numeric KPI Callout Cards
    *   **Computed Metrics**: `Global_Gross_Revenue` and `Global_Units_Sold`
3.  ** Regional Customer Spend Distribution Map**
    *   **SQL View Source**: `vw_bi_customer_clv_analytics`
    *   **Dashboard Visual**: Geographic Heat Map
    *   **Computed Metrics**: `customer_lifetime_value` ranked by window functions (`RANK() OVER`)

---

## Deployment Instructions

To spin up this enterprise database project inside your SQL environment, execute the workspace scripts in the exact numerical sequence:

```bash
# 1. Initialize schemas, tables, and performance index paths
mysql -u root -p < scripts/01_schema.sql

# 2. Deploy automation logging triggers and stored procedures
mysql -u root -p < scripts/02_procedures.sql

# 3. Compile executive KPI views and test analytical reports
mysql -u root -p < scrip
