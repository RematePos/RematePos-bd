# RematePos DB - Templates para Nuevos ChangeSets

## 📋 Template: Crear Nueva Tabla

**Ubicación:** `src/main/resources/db/changelog/01_tables/00X_create_table_name.yaml`

```yaml
databaseChangeLog:
  - changeSet:
      id: create-table-nombre_tabla
      author: tu_nombre
      comment: Descripción clara de qué tabla creas y para qué
      changes:
        - createTable:
            tableName: nombre_tabla
            columns:
              - column:
                  name: id
                  type: UUID
                  defaultValueComputed: uuid_generate_v4()
                  constraints:
                    primaryKey: true
                    nullable: false
                    comment: Identificador único
              
              - column:
                  name: nombre_columna_1
                  type: VARCHAR(100)
                  constraints:
                    nullable: false
                    comment: Descripción
              
              - column:
                  name: nombre_columna_2
                  type: INTEGER
                  defaultValue: 0
                  constraints:
                    nullable: false
              
              - column:
                  name: created_at
                  type: TIMESTAMP
                  defaultValueComputed: CURRENT_TIMESTAMP
                  constraints:
                    nullable: false
              
              - column:
                  name: updated_at
                  type: TIMESTAMP
                  defaultValueComputed: CURRENT_TIMESTAMP
                  constraints:
                    nullable: false
      
      rollback:
        - dropTable:
            tableName: nombre_tabla
```

---

## 📋 Template: Agregar Columna

**Ubicación:** `src/main/resources/db/changelog/01_tables/00X_add_column_to_table.yaml`

```yaml
databaseChangeLog:
  - changeSet:
      id: add-column-nombre_columna-to-nombre_tabla
      author: tu_nombre
      comment: Agregar columna 'nombre_columna' a tabla 'nombre_tabla'
      changes:
        - addColumn:
            tableName: nombre_tabla
            columns:
              - column:
                  name: nombre_columna
                  type: VARCHAR(100)
                  defaultValue: 'VALOR_POR_DEFECTO'
                  constraints:
                    nullable: false
      
      rollback:
        - dropColumn:
            tableName: nombre_tabla
            columnName: nombre_columna
```

---

## 📋 Template: Crear Índice

**Ubicación:** `src/main/resources/db/changelog/06_indexes/00X_create_index_name.yaml`

```yaml
databaseChangeLog:
  - changeSet:
      id: create-index-nombre_tabla-columna
      author: tu_nombre
      comment: Crear índice en columna 'nombre_columna' de tabla 'nombre_tabla'
      changes:
        - createIndex:
            indexName: idx_nombre_tabla_nombre_columna
            tableName: nombre_tabla
            columns:
              - column:
                  name: nombre_columna
      
      rollback:
        - dropIndex:
            indexName: idx_nombre_tabla_nombre_columna
            tableName: nombre_tabla
```

---

## 📋 Template: Crear Foreign Key

**Ubicación:** `src/main/resources/db/changelog/01_tables/00X_add_foreign_key.yaml`

```yaml
databaseChangeLog:
  - changeSet:
      id: add-foreign-key-tabla1-tabla2
      author: tu_nombre
      comment: Agregar foreign key entre tabla1 y tabla2
      changes:
        - addForeignKeyConstraint:
            baseTableName: tabla1
            baseColumnNames: tabla2_id
            constraintName: fk_tabla1_tabla2
            referencedTableName: tabla2
            referencedColumnNames: id
            onDelete: CASCADE
            onUpdate: CASCADE
      
      rollback:
        - dropForeignKeyConstraint:
            baseTableName: tabla1
            constraintName: fk_tabla1_tabla2
```

---

## 📋 Template: Insertar Datos (Seeds)

**Ubicación:** `src/main/resources/db/changelog/09_inserts/00X_seed_data.yaml`

```yaml
databaseChangeLog:
  - changeSet:
      id: seed-tabla-initial-data
      author: tu_nombre
      comment: Insertar datos iniciales en tabla
      changes:
        - insert:
            tableName: nombre_tabla
            columns:
              - column:
                  name: id
                  value: 'uuid-aqui'
              - column:
                  name: nombre_columna
                  value: 'valor'
              - column:
                  name: numero
                  valueNumeric: 100
        
        - insert:
            tableName: nombre_tabla
            columns:
              - column:
                  name: id
                  value: 'otro-uuid'
              - column:
                  name: nombre_columna
                  value: 'otro-valor'
              - column:
                  name: numero
                  valueNumeric: 200
      
      rollback:
        - delete:
            tableName: nombre_tabla
            where: id IN ('uuid-aqui', 'otro-uuid')
```

---

## 📋 Template: Modificar Columna

**Ubicación:** `src/main/resources/db/changelog/11_schema/00X_modify_column.yaml`

```yaml
databaseChangeLog:
  - changeSet:
      id: modify-column-nombre-in-tabla
      author: tu_nombre
      comment: Cambiar tipo de 'nombre_columna' de VARCHAR a TEXT
      changes:
        - modifyDataType:
            tableName: nombre_tabla
            columnName: nombre_columna
            newDataType: TEXT
      
      rollback:
        - modifyDataType:
            tableName: nombre_tabla
            columnName: nombre_columna
            newDataType: VARCHAR(100)
```

---

## 📋 Template: Crear Vista

**Ubicación:** `src/main/resources/db/changelog/02_views/00X_create_view_name.yaml`

```yaml
databaseChangeLog:
  - changeSet:
      id: create-view-nombre_vista
      author: tu_nombre
      comment: Crear vista para mostrar datos consolidados
      changes:
        - createView:
            viewName: nombre_vista
            replaceIfExists: true
            selectQuery: |
              SELECT 
                t1.id,
                t1.nombre,
                COUNT(t2.id) as count
              FROM tabla1 t1
              LEFT JOIN tabla2 t2 ON t1.id = t2.tabla1_id
              GROUP BY t1.id, t1.nombre
      
      rollback:
        - dropView:
            viewName: nombre_vista
```

---

## 📋 Template: Crear Función PL/pgSQL

**Ubicación:** `src/main/resources/db/changelog/03_functions/00X_create_function_name.yaml`

```yaml
databaseChangeLog:
  - changeSet:
      id: create-function-nombre_funcion
      author: tu_nombre
      comment: Crear función que realiza cierta operación
      changes:
        - sql:
            sql: |
              CREATE OR REPLACE FUNCTION nombre_funcion(param1 VARCHAR)
              RETURNS TABLE (
                id UUID,
                nombre VARCHAR,
                resultado INTEGER
              ) AS $$
              BEGIN
                RETURN QUERY
                SELECT t.id, t.nombre, COUNT(*)::INTEGER
                FROM tabla t
                WHERE t.nombre LIKE param1
                GROUP BY t.id, t.nombre;
              END;
              $$ LANGUAGE plpgsql;
      
      rollback:
        - sql:
            sql: DROP FUNCTION IF EXISTS nombre_funcion(VARCHAR);
```

---

## 📋 Template: Crear Trigger

**Ubicación:** `src/main/resources/db/changelog/05_triggers/00X_create_trigger_name.yaml`

```yaml
databaseChangeLog:
  - changeSet:
      id: create-trigger-tabla-update
      author: tu_nombre
      comment: Crear trigger para actualizar updated_at automáticamente
      changes:
        - sql:
            sql: |
              CREATE OR REPLACE FUNCTION update_updated_at()
              RETURNS TRIGGER AS $$
              BEGIN
                NEW.updated_at = CURRENT_TIMESTAMP;
                RETURN NEW;
              END;
              $$ LANGUAGE plpgsql;
              
              CREATE TRIGGER tr_nombre_tabla_update
              BEFORE UPDATE ON nombre_tabla
              FOR EACH ROW
              EXECUTE FUNCTION update_updated_at();
      
      rollback:
        - sql:
            sql: |
              DROP TRIGGER IF EXISTS tr_nombre_tabla_update ON nombre_tabla;
              DROP FUNCTION IF EXISTS update_updated_at();
```

---

## 📋 Template: Constraint Único

**Ubicación:** `src/main/resources/db/changelog/11_schema/00X_add_unique_constraint.yaml`

```yaml
databaseChangeLog:
  - changeSet:
      id: add-unique-constraint-tabla-columna
      author: tu_nombre
      comment: Agregar restricción única en columna 'nombre_columna'
      changes:
        - addUniqueConstraint:
            tableName: nombre_tabla
            columnNames: nombre_columna
            constraintName: uk_nombre_tabla_nombre_columna
      
      rollback:
        - dropUniqueConstraint:
            tableName: nombre_tabla
            constraintName: uk_nombre_tabla_nombre_columna
```

---

## 🎯 Tipos de Datos Comunes

| Tipo | Uso |
|------|-----|
| `UUID` | Identificadores únicos |
| `VARCHAR(n)` | Texto limitado |
| `TEXT` | Texto sin límite |
| `INTEGER` | Números enteros |
| `DECIMAL(10,2)` | Dinero |
| `BOOLEAN` | Verdadero/Falso |
| `TIMESTAMP` | Fecha y hora |
| `DATE` | Solo fecha |
| `TIME` | Solo hora |
| `JSON` | Datos JSON |
| `JSONB` | JSON optimizado |
| `BYTEA` | Datos binarios |

---

## 📋 Checklist para Cada ChangeSet

Antes de hacer commit:

- [ ] ID es único y descriptivo
- [ ] Author está definido
- [ ] Comment explica qué se hace
- [ ] Rollback está definido
- [ ] Orden correcto (tablas antes de FK)
- [ ] No hay SQL directo (usar YAML)
- [ ] Probado localmente
- [ ] Sin credenciales hardcodeadas
- [ ] Validado: `mvn liquibase:validate`

---

## 🚀 Pasos para Crear un Nuevo ChangeSet

1. **Selecciona la carpeta** según tipo (01_tables, 06_indexes, etc.)
2. **Copia el template** correspondiente
3. **Reemplaza placeholders** (nombre_tabla, tu_nombre, etc.)
4. **Agrega rollback** complementario
5. **Valida** con `mvn liquibase:validate`
6. **Prueba** con `mvn liquibase:update`
7. **Commit** con mensaje descriptivo
8. **Pushea** para review

---

**¡Listo para crear tus primeros changesets! 🚀**

