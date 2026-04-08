CREATE OR REPLACE VIEW v_products_catalog AS
SELECT
  p.id,
  p.name,
  p.description,
  p.price,
  p.stock,
  c.name AS category_name
FROM products p
LEFT JOIN categories c ON c.id = p.category_id;

CREATE OR REPLACE VIEW v_categories_with_product_count AS
SELECT
  c.id,
  c.name,
  c.description,
  COUNT(p.id) AS product_count
FROM categories c
LEFT JOIN products p ON p.category_id = c.id
GROUP BY c.id, c.name, c.description;

