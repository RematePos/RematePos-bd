# RematePos DB - Mejores Prácticas

## 📋 Guía de Creación de ChangeLog

### 1. Estructura de un ChangeSet

```yaml
databaseChangeLog:
  - changeSet:
      id: identificador-unico       # Debe ser único en toda la aplicación
      author: nombre-del-desarrollador
      comment: Descripción de qué hace este changeset
      changes:
        - createTable:
            # Cambios aquí
      rollback:
        - dropTable:
            # Cómo deshacer los cambios
```

### 2. Reglas Importantes

✅ **DO:**
- IDs de changeset único y descriptivo: `create-table-users`, `add-column-email-to-users`
- Incluir siempre rollback
- Un cambio por changeset cuando sea posible
- Usar convenciones de nombrado consistentes
- Comentar cambios complejos
- Incluir constraints (PK, FK, NOT NULL)

❌ **DON'T:**
- Modificar un changeset ya ejecutado
- Cambios directos a la BD sin changeset
- Nombres genéricos como `change1`, `update2`
- Olvidar rollbacks en cambios destructivos
- Ejecutar dos changesets simultáneamente

## 🎯 Nomenclatura de Carpetas

| Carpeta | Contenido | Ejemplo |
|---------|-----------|---------|
| `00_extensions` | Extensiones de BD | UUID, PostGIS |
| `01_tables` | Creación de tablas | productos, usuarios |
| `02_views` | Vistas | v_productos_activos |
| `03_functions` | Funciones PL/pgSQL | calc_total_price |
| `04_procedures` | Stored procedures | sp_backup_data |
| `05_triggers` | Triggers | tr_update_timestamp |
| `06_indexes` | Índices | idx_email_unique |
| `07_materialized_views` | Vistas materializadas | mv_sales_summary |
| `08_types` | Tipos de datos | enum_status |
| `09_inserts` | Datos iniciales | seed_categories |
| `10_updates` | Updates de datos | update_prices |
| `11_schema` | Cambios de esquema | alter_constraints |
| `12_rollbacks` | Rollbacks específicos | rollback_users |

## 📝 Ejemplo de un Nuevo ChangeSet

```yaml
databaseChangeLog:
  - changeSet:
      id: add-column-status-to-products
      author: developer_name
      comment: Agregar columna status a tabla products para rastrear estado
      changes:
        - addColumn:
            tableName: products
            columns:
              - column:
                  name: status
                  type: VARCHAR(20)
                  defaultValue: 'ACTIVE'
                  constraints:
                    nullable: false
              - column:
                  name: status_updated_at
                  type: TIMESTAMP
                  defaultValueComputed: CURRENT_TIMESTAMP
      rollback:
        - dropColumn:
            tableName: products
            columnName: status
        - dropColumn:
            tableName: products
            columnName: status_updated_at
```

## 🔄 Flujo de Desarrollo

### 1. Crear ChangeLog Local
```bash
# En src/main/resources/db/changelog/01_tables/004_add_new_table.yaml
```

### 2. Validar Localmente
```bash
mvn liquibase:validate
```

### 3. Testear en Desarrollo
```bash
mvn liquibase:update
# Verificar cambios
mvn liquibase:status
```

### 4. Commit a Git
```bash
git add src/main/resources/db/changelog/01_tables/004_add_new_table.yaml
git commit -m "chore: add new table for feature X"
```

### 5. Pull Request y Revisión

### 6. Desplegar a QA
```bash
mvn -P qa liquibase:update
```

### 7. Desplegar a Release
```bash
mvn -P release liquibase:update
```

### 8. Desplegar a Main
```bash
mvn -P main liquibase:update
```

## ⚠️ Manejo de Errores

### Cambio Fallido en Desarrollo

```bash
# Ver cambios pendientes
mvn liquibase:futureRollbackSQL

# Rollback del último cambio
mvn liquibase:rollback -Dliquibase.rollbackCount=1

# Arreglar el changeset y reintentar
mvn liquibase:update
```

### Cambio Fallido en Producción

1. **NO hacer rollback automático**
2. Identificar el problema
3. Crear un nuevo changeset con corrección
4. Aplicar la corrección
5. Documentar el incidente

## 📚 Recursos

- [Documentación Oficial Liquibase](https://docs.liquibase.com)
- [Cambios Soportados](https://docs.liquibase.com/change-types/home.html)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)

## 🤝 Colaboración

- Todos los changesets deben tener un author definido
- Comentar cambios complejos
- Usar names descriptivos
- Revisar cambios en Pull Request antes de mergear

---

**Última actualización:** 2024
**Mantener este documento actualizado**

