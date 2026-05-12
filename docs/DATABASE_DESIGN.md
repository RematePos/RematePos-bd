# RematePos DB - Arquitectura y Diseño

## 🏗️ Diagrama General de la BD

```
┌─────────────────────────────────────┐
│         Products Table              │
├─────────────────────────────────────┤
│ id (UUID) - PK                      │
│ name (VARCHAR)                      │
│ description (TEXT)                  │
│ price (DECIMAL)                     │
│ stock (INTEGER)                     │
│ status (VARCHAR)                    │
│ created_at (TIMESTAMP)              │
│ updated_at (TIMESTAMP)              │
└──────────────────┬──────────────────┘
                   │
                   │ N:M
                   │
        ┌──────────────────────┐
        │ Product_Categories   │
        │ (Tabla Intermedia)   │
        ├──────────────────────┤
        │ id (UUID) - PK       │
        │ product_id (UUID)-FK │
        │ category_id (UUID)-FK│
        │ created_at           │
        └──────────────────────┘
                   │
                   │ N:M
                   │
┌─────────────────────────────────────┐
│      Categories Table               │
├─────────────────────────────────────┤
│ id (UUID) - PK                      │
│ name (VARCHAR) - UNIQUE             │
│ description (TEXT)                  │
│ status (VARCHAR)                    │
│ created_at (TIMESTAMP)              │
│ updated_at (TIMESTAMP)              │
└─────────────────────────────────────┘
```

## 📋 Tablas Principales

### 1. **products**
Almacena la información de productos del sistema.

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | UUID | PK, NOT NULL | Identificador único |
| name | VARCHAR(255) | NOT NULL | Nombre del producto |
| description | TEXT | - | Descripción del producto |
| price | DECIMAL(10,2) | NOT NULL | Precio del producto |
| stock | INTEGER | NOT NULL | Cantidad en inventario |
| status | VARCHAR(50) | DEFAULT: 'ACTIVE' | Estado del producto |
| created_at | TIMESTAMP | DEFAULT: CURRENT | Fecha de creación |
| updated_at | TIMESTAMP | DEFAULT: CURRENT | Fecha de actualización |

**Índices Recomendados:**
- `idx_products_status` (status)
- `idx_products_name` (name)

### 2. **categories**
Almacena las categorías de productos.

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | UUID | PK, NOT NULL | Identificador único |
| name | VARCHAR(255) | NOT NULL, UNIQUE | Nombre de categoría |
| description | TEXT | - | Descripción |
| status | VARCHAR(50) | DEFAULT: 'ACTIVE' | Estado |
| created_at | TIMESTAMP | DEFAULT: CURRENT | Fecha de creación |
| updated_at | TIMESTAMP | DEFAULT: CURRENT | Fecha de actualización |

**Índices Recomendados:**
- `idx_categories_status` (status)
- `idx_categories_name` (name)

### 3. **product_categories**
Tabla intermedia para relación muchos-a-muchos.

| Columna | Tipo | Constraints | Descripción |
|---------|------|-------------|-------------|
| id | UUID | PK, NOT NULL | Identificador único |
| product_id | UUID | FK, NOT NULL | Referencia a products |
| category_id | UUID | FK, NOT NULL | Referencia a categories |
| created_at | TIMESTAMP | DEFAULT: CURRENT | Fecha de creación |

**Constraints Únicos:**
- `uk_product_category_unique` (product_id, category_id)

**Índices Recomendados:**
- `idx_product_categories_product_id` (product_id)
- `idx_product_categories_category_id` (category_id)

## 🔑 Relaciones

### Producto - Categoría (N:M)
- Un producto puede tener múltiples categorías
- Una categoría puede tener múltiples productos
- La relación se maneja a través de `product_categories`

**Consulta Ejemplo:**
```sql
SELECT p.*, c.name as category_name
FROM products p
JOIN product_categories pc ON p.id = pc.product_id
JOIN categories c ON pc.category_id = c.id
WHERE c.name = 'Electrónica';
```

## 📊 Consultas Comunes

### Obtener productos de una categoría
```sql
SELECT p.* FROM products p
JOIN product_categories pc ON p.id = pc.product_id
WHERE pc.category_id = 'UUID_HERE'
AND p.status = 'ACTIVE';
```

### Productos sin categoría
```sql
SELECT p.* FROM products p
LEFT JOIN product_categories pc ON p.id = pc.product_id
WHERE pc.product_id IS NULL;
```

### Contar productos por categoría
```sql
SELECT c.name, COUNT(p.id) as product_count
FROM categories c
LEFT JOIN product_categories pc ON c.id = pc.category_id
LEFT JOIN products p ON pc.product_id = p.id
GROUP BY c.id, c.name;
```

## 🔐 Seguridad

### Controles de Acceso
- Usuario de aplicación: `rematepos_user`
- Permisos básicos: SELECT, INSERT, UPDATE, DELETE
- Sin permisos DDL (ALTER, DROP)

### Foreign Keys
Activos para mantener integridad referencial:
- `fk_product_categories_product` → products(id)
- `fk_product_categories_category` → categories(id)

Ambos con ON DELETE CASCADE para limpiar datos.

## 🚀 Optimización

### Índices Recomendados (futuros)

```yaml
- changeSet:
    id: create-indexes-for-performance
    author: system
    changes:
      - createIndex:
          indexName: idx_products_status
          tableName: products
          columns:
            - column:
                name: status
      - createIndex:
          indexName: idx_product_categories_product_id
          tableName: product_categories
          columns:
            - column:
                name: product_id
```

## 📈 Escalabilidad

### Futuras Consideraciones

1. **Particionamiento**: Si la tabla `products` crece >10M registros
2. **Sharding**: Si es necesario distribuir datos
3. **Replicación**: Para alta disponibilidad
4. **Caché**: Redis para consultas frecuentes

## 🔄 Versionamiento

Todas las tablas incluyen:
- `created_at` - Auditoría
- `updated_at` - Rastreo de cambios
- `status` - Control de ciclo de vida

## 📝 Convenciones

- **Timestamps**: UTC siempre
- **UUIDs**: uuid_generate_v4()
- **Status**: Enums (ACTIVE, INACTIVE, ARCHIVED)
- **Naming**: snake_case para columnas y tablas

---

**Próximo**: Agregaremos más tablas según los microservicios lo requieran (usuarios, órdenes, etc.)

