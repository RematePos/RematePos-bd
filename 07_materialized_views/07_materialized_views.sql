DROP MATERIALIZED VIEW IF EXISTS mv_category_price_stats;

CREATE MATERIALIZED VIEW mv_category_price_stats AS
SELECT
  c.id AS category_id,
  c.name AS category_name,
  COUNT(p.id) AS total_products,
  COALESCE(AVG(p.price), 0) AS avg_price,
  COALESCE(MIN(p.price), 0) AS min_price,
  COALESCE(MAX(p.price), 0) AS max_price
FROM categories c
LEFT JOIN products p ON p.category_id = c.id
GROUP BY c.id, c.name;

