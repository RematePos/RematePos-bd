-- Rollback examples
DROP TRIGGER IF EXISTS trg_products_touch_updated_at ON products;
DROP TRIGGER IF EXISTS trg_categories_touch_updated_at ON categories;
DROP FUNCTION IF EXISTS fn_touch_updated_at();
DROP PROCEDURE IF EXISTS sp_refresh_product_metrics();
DROP FUNCTION IF EXISTS fn_adjust_product_stock(INT, INT);
DROP MATERIALIZED VIEW IF EXISTS mv_category_price_stats;
DROP VIEW IF EXISTS v_products_catalog;
DROP VIEW IF EXISTS v_categories_with_product_count;
DROP INDEX IF EXISTS idx_products_price;
DROP INDEX IF EXISTS idx_products_category_id;
DROP INDEX IF EXISTS idx_products_name;
DROP INDEX IF EXISTS idx_categories_name;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TYPE IF EXISTS product_status;
