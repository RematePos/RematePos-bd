# RematePos DB - Guía de Uso Rápida

## 🚀 Inicio Rápido

### Opción 1: Docker Compose (local)

```powershell
Copy-Item .env.example .env -Force
docker compose --env-file .env -f docker-compose.migration.yml up -d
docker compose --env-file .env -f docker-compose.migration.yml ps
```

### Opción 2: Maven (recomendado)

```powershell
mvn liquibase:validate
mvn liquibase:update
mvn liquibase:status

# QA
mvn -P qa liquibase:update

# Release
mvn -P release liquibase:update

# Main (Producción)
mvn -P main liquibase:update
```

### Opción 3: Scripts Automáticos

```powershell
# Windows PowerShell
.\migrate.ps1 -Environment dev -Command update
.\migrate.ps1 -Environment qa -Command update
.\migrate.ps1 -Environment release -Command update
.\migrate.ps1 -Environment main -Command update

# Linux/Mac
./migrate.sh dev update
./migrate.sh qa update
./migrate.sh release update
./migrate.sh main update
```

## 📊 Comandos Comunes

### Verificar Estado
```bash
mvn liquibase:status
```

### Ver Historial
```bash
mvn liquibase:history
```

### Validar Cambios
```bash
mvn liquibase:validate
```

### Ver SQL a Ejecutar
```bash
mvn liquibase:futureRollbackSQL
```

## ⚠️ Precauciones

- **Desarrollo**: puedes hacer rollback controlado.
- **QA/Release/Main**: ejecutar con aprobacion y respaldo.
- **Seguridad**: no guardar secretos reales en markdown o `.properties` versionados.

## 📝 Estructura de Directorios

```
RematePos-db/
├── src/main/resources/db/changelog/
│   ├── db.changelog-master.yaml
│   ├── 00_extensions/
│   ├── 01_tables/
│   ├── 02_views/
│   ├── 03_functions/
│   ├── 04_procedures/
│   ├── 05_triggers/
│   ├── 06_indexes/
│   ├── 07_materialized_views/
│   ├── 08_types/
│   ├── 09_inserts/
│   ├── 10_updates/
│   ├── 11_schema/
│   └── 12_rollbacks/
├── docker-compose.migration.yml
├── pom.xml
├── migrate.ps1
└── migrate.sh
```

## 🔗 Integración con Microservicios

Cada microservicio debe incluir:

**pom.xml:**
```xml
<dependency>
    <groupId>org.liquibase</groupId>
    <artifactId>liquibase-spring-boot-starter</artifactId>
    <version>4.23.1</version>
</dependency>
```

**application.yml:**
```yaml
spring:
  liquibase:
    enabled: true
    change-log: classpath:db/changelog/db.changelog-master.yaml
```

Y para JPA:

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: validate
```

## 🆘 Solución de Problemas

### "Connection refused"
- Verificar que PostgreSQL está corriendo
- Revisar propiedades de conexión (URL, usuario, contraseña)

### "databasechangelog is locked"
- Ejecutar: `DELETE FROM databasechangeloglock;`
- En desarrollo solamente

### "foreign key constraint violated"
- Revisar orden de ejecución de changesets
- Verificar que las tablas referenciadas existen

---

**Contacto:** Equipo de Backend/DevOps RematePos

