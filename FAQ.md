# RematePos DB - Preguntas Frecuentes (FAQ)

## 🤔 Preguntas Generales

### P: ¿Cómo empiezo?
**R:** Lee el archivo `QUICKSTART.md`. Los pasos básicos son:
1. Tener PostgreSQL corriendo
2. Ejecutar `mvn liquibase:update` en desarrollo
3. Los cambios se aplican automáticamente

### P: ¿Necesito clonar este repositorio?
**R:** Este proyecto debe estar en `C:\Users\carlo\Downloads\microservicios\RematePos-db`. Los microservicios lo utilizarán como referencia.

### P: ¿Qué pasa si la migración falla?
**R:** Los cambios no se aplican y puedes revisar el error. Lee la sección de Troubleshooting en `README.md`.

---

## 🔧 Preguntas Técnicas

### P: ¿Cómo creo un nuevo tabla?
**R:** 
```yaml
# 1. Crea archivo: src/main/resources/db/changelog/01_tables/00X_create_table_name.yaml
# 2. Define el changeSet con createTable
# 3. Ejecuta: mvn liquibase:update
```

Ver `BEST_PRACTICES.md` para ejemplos completos.

### P: ¿Cómo agrego una columna a una tabla existente?
**R:**
```yaml
- changeSet:
    id: add-column-name-to-table
    author: tu_nombre
    changes:
      - addColumn:
          tableName: nombre_tabla
          columns:
            - column:
                name: nombre_columna
                type: VARCHAR(100)
```

### P: ¿Puedo modificar un changeset ya ejecutado?
**R:** **NO**. Nunca modifiques un changeset que ya se ejecutó. Crea uno nuevo para hacer cambios.

### P: ¿Cómo deshago cambios?
**R:** En desarrollo: `mvn liquibase:rollback -Dliquibase.rollbackCount=1`
**IMPORTANTE:** No hagas rollback en QA o Producción sin consultar.

---

## 📊 Integración con Microservicios

### P: ¿Cómo integro esto en mi microservicio?
**R:** En tu `pom.xml`:
```xml
<dependency>
    <groupId>org.liquibase</groupId>
    <artifactId>liquibase-spring-boot-starter</artifactId>
    <version>4.23.1</version>
</dependency>
```

Y en `application.yml`:
```yaml
spring:
  liquibase:
    enabled: true
    change-log: classpath:db/changelog/db.changelog-master.yaml
```

### P: ¿Se ejecutan las migraciones automáticamente?
**R:** Sí, cuando el microservicio inicia, Spring ejecuta automáticamente los changesets pendientes.

### P: ¿Qué pasa si la migración falla en startup?
**R:** El microservicio no inicia. Debes revisar los logs y corregir el changeset.

---

## 🌐 Ambientes

### P: ¿Cómo ejecuto migraciones en QA?
**R:** `mvn -P qa liquibase:update`

### P: ¿Cómo sé qué cambios se van a aplicar?
**R:** `mvn liquibase:futureRollbackSQL`

### P: ¿Necesito credenciales diferentes por ambiente?
**R:** Sí. Edita los archivos:
- `liquibase-dev.properties` (desarrollo)
- `liquibase-qa.properties` (QA)
- `liquibase-release.properties` (release)
- `liquibase-main.properties` (producción)

---

## 🐳 Docker Compose

### P: ¿Cómo levanto los servicios de BD con Docker?
**R:** 
```powershell
docker compose -f docker-compose.migration.yml up
```

### P: ¿Qué puertos usa?
**R:** PostgreSQL en puerto 5432 por defecto.

### P: ¿Cómo borro los datos?
**R:** 
```powershell
docker compose -f docker-compose.migration.yml down -v
```

---

## 🚨 Problemas Comunes

### P: "error: database is locked"
**R:** En desarrollo: 
```sql
DELETE FROM databasechangeloglock;
```
Luego reintentar.

### P: "Connection refused"
**R:** Verifica que PostgreSQL esté corriendo:
```powershell
# Windows
Get-Service | findstr postgres

# Linux/Mac
ps aux | grep postgres
```

### P: "foreign key constraint failed"
**R:** Las tablas referenciadas no existen o el orden es incorrecto. Revisa el orden de creación.

### P: "duplicate key value violates unique constraint"
**R:** Los datos ya existen. Revisa si el changeset ya fue ejecutado en `databasechangelog`.

---

## 📝 Mejores Prácticas

### P: ¿Cuál es el mejor formato para IDs de changeset?
**R:** 
- `create-table-products` ✓
- `add-column-email-to-users` ✓
- `change1` ✗
- `update` ✗

### P: ¿Siempre necesito rollback?
**R:** Sí. Incluso para inserts, debes definir cómo deshacer.

### P: ¿Cuántos cambios por changeset?
**R:** Idealmente uno. Si están relacionados, puede ser más de uno pero mantén coherencia.

---

## 🔐 Seguridad

### P: ¿Cómo manejo contraseñas sensibles?
**R:** Usa variables de entorno:
```powershell
$env:DB_PASSWORD_QA = "contraseña"
$env:DB_PASSWORD_RELEASE = "contraseña"
$env:DB_PASSWORD_MAIN = "contraseña"
```

Luego usa en properties: `${DB_PASSWORD_QA}`

### P: ¿Está seguro commitear properties con contraseñas?
**R:** NO. Usa `.env` local y agrega a `.gitignore`.

---

## 📚 Recursos

- **README.md** - Documentación completa
- **QUICKSTART.md** - Inicio rápido
- **BEST_PRACTICES.md** - Mejores prácticas
- **[Docs Liquibase](https://docs.liquibase.com)** - Documentación oficial

---

**¿No encuentras respuesta?** Contacta al equipo de Backend/DevOps.

