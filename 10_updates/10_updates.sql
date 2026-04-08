UPDATE products
SET description = COALESCE(description, 'Sin descripcion')
WHERE description IS NULL;

UPDATE products
SET stock = 0
WHERE stock < 0;

