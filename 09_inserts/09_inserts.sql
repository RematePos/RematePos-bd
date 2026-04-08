INSERT INTO categories(name, description)
VALUES
  ('Electrónica', 'Productos electrónicos en general'),
  ('Ropa', 'Prendas de vestir'),
  ('Alimentos', 'Productos alimenticios')
ON CONFLICT (name) DO NOTHING;

INSERT INTO products(name, description, price, stock, image_url, category_id)
SELECT 'Teclado mecanico', 'Teclado mecanico RGB', 199000, 20, NULL, c.id
FROM categories c
WHERE c.name = 'Electrónica'
ON CONFLICT DO NOTHING;

INSERT INTO products(name, description, price, stock, image_url, category_id)
SELECT 'Camiseta deportiva', 'Camiseta de algodón premium', 49000, 50, NULL, c.id
FROM categories c
WHERE c.name = 'Ropa'
ON CONFLICT DO NOTHING;

INSERT INTO products(name, description, price, stock, image_url, category_id)
SELECT 'Cereal integral', 'Cereal integral de avena', 15000, 100, NULL, c.id
FROM categories c
WHERE c.name = 'Alimentos'
ON CONFLICT DO NOTHING;

