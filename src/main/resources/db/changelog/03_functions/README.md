# Plantilla para crear funciones (functions)
# Descomenta y modifica según sea necesario

# databaseChangeLog:
#   - changeSet:
#       id: create-function-get-product-count
#       author: system
#       changes:
#         - sql:
#             sql: |
#               CREATE OR REPLACE FUNCTION get_product_count()
#               RETURNS INTEGER AS $$
#               BEGIN
#                 RETURN (SELECT COUNT(*) FROM products);
#               END;
#               $$ LANGUAGE plpgsql;
#       rollback:
#         - sql:
#             sql: DROP FUNCTION IF EXISTS get_product_count();

