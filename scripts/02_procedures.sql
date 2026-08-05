-- ===================================================================
-- SUBMISSION COMPONENT: 02_procedures.sql
-- PURPOSE: Event-driven triggers, automation logging tables, and procedures
-- ===================================================================
USE enterprise_bi_system;

-- 1. Create the dedicated tracking table for your automation logs
CREATE TABLE IF NOT EXISTS inventory_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    old_stock INT,
    new_stock INT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. AUTOMATION: Trigger that fires automatically on stock adjustments
DROP TRIGGER IF EXISTS trg_track_inventory;

DELIMITER //
CREATE TRIGGER trg_track_inventory
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    -- Captures original stock state vs updated stock state dynamically
    IF OLD.stock_quantity <> NEW.stock_quantity THEN
        INSERT INTO inventory_logs (product_id, old_stock, new_stock)
        VALUES (OLD.product_id, OLD.stock_quantity, NEW.stock_quantity);
    END IF;
END //
DELIMITER ;

-- 3. ADMINISTRATIVE LAYER: Stored Procedure to safely update prices in bulk
DROP PROCEDURE IF EXISTS prc_adjust_category_prices;

DELIMITER //
CREATE PROCEDURE prc_adjust_category_prices(
    IN target_category VARCHAR(50),
    IN percentage_increase DECIMAL(5,2)
)
BEGIN
    -- Updates pricing catalog logic using structured safe decimal scaling
    UPDATE products
    SET unit_price = unit_price * (1 + (percentage_increase / 100))
    WHERE category = target_category;
END //
DELIMITER ;
