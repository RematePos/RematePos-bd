# RematePos DB - Checklist de Validación

## ✅ Validación Pre-Despliegue

### Antes de Hacer Deploy a Cualquier Ambiente

- [ ] **ChangeLog válido**: `mvn liquibase:validate`
- [ ] **Sin cambios duplicados**: Revisar `databasechangelog`
- [ ] **Rollback definido**: Todo changeset tiene rollback
- [ ] **IDs únicos**: No hay IDs duplicados en changelogs
- [ ] **Orden correcto**: Las tablas referenciadas existen antes
- [ ] **Comentarios claros**: Cada changeset tiene descripción
- [ ] **Autor definido**: Cada changeset tiene author
- [ ] **Sin SQL hardcodeado**: Usar YAML/XML de Liquibase
- [ ] **Contraseñas no commitidas**: Revisar .gitignore
- [ ] **Permisos correctos**: Usuario de BD tiene accesos necesarios

### Checklist por Ambiente

#### 🟢 Desarrollo (Local)
- [ ] Base de datos local corriendo
- [ ] Migraciones pasan localmente
- [ ] Todas las tablas creadas correctamente
- [ ] Seeds/datos iniciales insertados
- [ ] Consultas de prueba ejecutadas exitosamente

#### 🟡 QA
- [ ] Solicitud de aprobación creada
- [ ] Revisor ha validado cambios
- [ ] Backup de BD QA realizado
- [ ] Migraciones en script revisadas: `mvn -P qa liquibase:futureRollbackSQL`
- [ ] Ventana de deployment acordada
- [ ] Team notificado de downtime estimado

#### 🟠 Release
- [ ] Cambios testeados en QA sin problemas
- [ ] Aprobación de Release Manager
- [ ] Plan de rollback documentado
- [ ] Backup automático configurado
- [ ] Monitoring/alertas activos
- [ ] Comunicación con ops team

#### 🔴 Main/Producción
- [ ] Aprobación ejecutiva requerida
- [ ] Backup completo de BD main
- [ ] Plan de rollback ensayado
- [ ] Comunicación a usuarios final/internos
- [ ] On-call team disponible
- [ ] Ventana de mantenimiento oficial
- [ ] Rollback script testeado

---

## 🔍 Checklist de Pruebas

### Pruebas Funcionales

- [ ] Crear registro en tabla afectada
- [ ] Leer/actualizar datos correctamente
- [ ] Borrar datos respeta constraints
- [ ] Foreign keys funcionan correctamente
- [ ] Indexes están activos
- [ ] Defaults aplican correctamente
- [ ] Triggers se ejecutan (si existen)
- [ ] Vistas retornan datos correctos (si existen)

### Pruebas de Performance

- [ ] Queries lentas identificadas
- [ ] Índices agregan valor (EXPLAIN ANALYZE)
- [ ] No hay N+1 queries
- [ ] Joins están optimizados
- [ ] Stats de tablas actualizadas

### Pruebas de Integridad

```sql
-- Verificar constraint integridad referencial
SELECT * FROM information_schema.table_constraints 
WHERE constraint_type = 'FOREIGN KEY';

-- Verificar registros huérfanos
SELECT * FROM product_categories 
WHERE product_id NOT IN (SELECT id FROM products);

-- Verificar duplicados en UNIQUE
SELECT category_id, COUNT(*) FROM product_categories 
GROUP BY category_id HAVING COUNT(*) > 1;
```

---

## 📋 Checklist de Documentación

- [ ] README.md actualizado
- [ ] BEST_PRACTICES.md referencia nuevas tablas
- [ ] DATABASE_DESIGN.md incluye diagramas actualizados
- [ ] FAQ.md contiene nuevas preguntas si aplica
- [ ] Comentarios en código SQL
- [ ] Documentación de índices/triggers
- [ ] Plan de rollback documentado

---

## 🚨 Checklist de Seguridad

- [ ] Credenciales no expuestas en logs
- [ ] Variables de entorno usadas correctamente
- [ ] .gitignore protege archivos sensibles
- [ ] Permisos de usuario restringidos (no root/admin)
- [ ] Encryption at rest (si aplica)
- [ ] Encryption in transit (JDBC SSL)
- [ ] Audit logging habilitado
- [ ] Cambios auditables en `databasechangelog`

---

## 🔄 Checklist de Reversibilidad

Para cada changeset:

- [ ] Rollback reversa el cambio exactamente
- [ ] Rollback no causa dependencias rotas
- [ ] Rollback testeado en desarrollo
- [ ] Datos recuperables si hay rollback
- [ ] No hay data loss en rollback

### Comando para testear:
```bash
# Aplicar cambio
mvn liquibase:update

# Ver SQL de rollback
mvn liquibase:rollbackSQL -Dliquibase.rollbackCount=1

# Hacer rollback
mvn liquibase:rollback -Dliquibase.rollbackCount=1

# Verificar que estamos en estado anterior
mvn liquibase:status
```

---

## 📊 Checklist Post-Despliegue

Después de ejecutar migraciones:

- [ ] ¿Todas las migraciones marcadas como exitosas?
  ```sql
  SELECT * FROM databasechangelog 
  WHERE dateexecuted > NOW() - INTERVAL '1 hour'
  ORDER BY dateexecuted DESC;
  ```

- [ ] ¿Todas las tablas creadas correctamente?
  ```sql
  SELECT table_name FROM information_schema.tables 
  WHERE table_schema = 'public'
  ORDER BY table_name;
  ```

- [ ] ¿Todas las columnas existen?
  ```sql
  SELECT * FROM information_schema.columns 
  WHERE table_schema = 'public' AND table_name = 'products';
  ```

- [ ] ¿Los índices están creados?
  ```sql
  SELECT * FROM pg_indexes 
  WHERE schemaname = 'public';
  ```

- [ ] ¿Las secuencias/IDs funcionan?
  ```sql
  INSERT INTO products (name, price, stock, status) 
  VALUES ('Test Product', 99.99, 10, 'ACTIVE')
  RETURNING id;
  ```

- [ ] ¿Microservicios iniciaron correctamente?
  - Revisar logs de errores Liquibase
  - Verificar endpoints respondiendo
  - Revisar dashboards de aplicación

- [ ] ¿Alertas activadas si hay problemas?
  - CPU usage
  - Disk space
  - Connection pool
  - Query performance

---

## 🎯 Checklist de Comunicación

- [ ] Ticket creado en Jira/Azure DevOps
- [ ] Team channel notificado del cambio
- [ ] Stakeholders informados
- [ ] Timeline acordado con equipo
- [ ] Responsable de rollback designado
- [ ] Punto de contacto durante deployment
- [ ] Reporte post-deployment realizado

---

## 🛠️ Troubleshooting Checklist

Si algo falla:

- [ ] ¿Revisar logs de aplicación?
  ```bash
  docker logs rematepos-postgres
  docker logs rematepos-liquibase
  ```

- [ ] ¿Ver estado del changelog?
  ```sql
  SELECT * FROM databasechangeloglock;
  SELECT * FROM databasechangelog;
  ```

- [ ] ¿Hay lock en la BD?
  ```bash
  # En desarrollo: limpiar lock
  DELETE FROM databasechangeloglock;
  ```

- [ ] ¿Revisar constraints?
  ```sql
  SELECT * FROM information_schema.table_constraints 
  WHERE is_deferrable = 'YES';
  ```

- [ ] ¿Validar integridad?
  ```bash
  mvn liquibase:validate
  mvn liquibase:dbDoc -Dliquibase.outputDirectory=./docs
  ```

- [ ] ¿Ejecutar diagnóstico?
  ```sql
  -- Archivos más grandes
  SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) as size
  FROM pg_tables ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
  ```

---

## 📞 Escalation Contacts

| Rol | Nombre | Teléfono | Email |
|-----|--------|----------|-------|
| DB Admin | - | - | - |
| DevOps Lead | - | - | - |
| Backend Lead | - | - | - |
| Release Manager | - | - | - |

---

**Usar este checklist antes de CADA despliegue de cambios de BD**

**Última actualización:** 2024

