# Plantilla para crear vistas (views)
# Descomenta y modifica según sea necesario

# databaseChangeLog:
#   - changeSet:
#       id: create-view-products-summary
#       author: system
#       changes:
#         - createView:
#             viewName: v_products_summary
#             selectQuery: |
#               SELECT 
#                 p.id,
#                 p.name,
#                 p.price,
#                 p.stock,
#                 COUNT(pc.category_id) as category_count
#               FROM products p
#               LEFT JOIN product_categories pc ON p.id = pc.product_id
#               GROUP BY p.id
#       rollback:
#         - dropView:
#             viewName: v_products_summary

