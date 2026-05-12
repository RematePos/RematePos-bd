# RematePos DB - Integración con Microservicios

## 🔗 Cómo Conectar RematePos-db con Microservicios

### 1. Agregar Dependencia Liquibase

En el `pom.xml` de cada microservicio:

```xml
<dependency>
    <groupId>org.liquibase</groupId>
    <artifactId>liquibase-spring-boot-starter</artifactId>
    <version>4.23.1</version>
</dependency>

<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
</dependency>
```

### 2. Configurar application.yml

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/rematepos_db
    username: ${DB_USER}
    password: ${DB_PASSWORD}
    driver-class-name: org.postgresql.Driver
  
  jpa:
    hibernate:
      ddl-auto: validate  # IMPORTANTE: no usar create ni update
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQL15Dialect
        format_sql: true
        show_sql: true
  
  liquibase:
    enabled: true
    change-log: classpath:db/changelog/db.changelog-master.yaml
    user: ${DB_USER}
    password: ${DB_PASSWORD}
    liquibase-schema: public
    default-schema: public
```

### 3. Copiar Changelogs

Copia la carpeta `db/changelog` desde RematePos-db a cada microservicio:

```
microservices/
├── product-microservice/
│   └── src/main/resources/
│       └── db/
│           └── changelog/
│               ├── db.changelog-master.yaml
│               ├── 00_extensions/
│               ├── 01_tables/
│               └── ...
├── customer-microservice/
│   └── src/main/resources/
│       └── db/
│           └── changelog/
│               ├── db.changelog-master.yaml
│               ├── 00_extensions/
│               ├── 01_tables/
│               └── ...
└── cart-microservice/
    └── src/main/resources/
        └── db/
            └── changelog/
                ├── db.changelog-master.yaml
                ├── 00_extensions/
                ├── 01_tables/
                └── ...
```

## 📋 Flujo de Trabajo

### Escenario 1: Crear nueva tabla

1. **En RematePos-db**:
   - Crear archivo: `src/main/resources/db/changelog/01_tables/00X_nombre.yaml`
   - Actualizar: `db.changelog-master.yaml`
   - Testear localmente: `mvn liquibase:update`
   - Commit y push

2. **En microservicios**:
   - Pull los cambios de RematePos-db
   - Copiar los nuevos archivos de changelog
   - Actualizar el pom.xml si es necesario
   - Testear en desarrollo: `mvn spring-boot:run`
   - El microservicio ejecutará las migraciones automáticamente

### Escenario 2: Agregar columna a tabla existente

1. **En RematePos-db**:
   ```yaml
   - changeSet:
       id: add-column-discount-to-products
       author: developer
       changes:
         - addColumn:
             tableName: products
             columns:
               - column:
                   name: discount
                   type: DECIMAL(5,2)
                   defaultValue: 0
   ```

2. **En microservicios**:
   - Actualizar entity/model si es necesario
   - Copiar el changelog
   - Reiniciar microservicio

## 🔄 Sincronización Continua

### Script de Sincronización

```powershell
# sync-db-changelog.ps1
# Sincronizar cambios de DB entre todos los microservicios

$dbProjectPath = "..\RematePos-db\src\main\resources\db\changelog"
$microservices = @(
    "product-microservice",
    "customer-microservice",
    "cart-microservice"
)

foreach ($ms in $microservices) {
    $targetPath = "..\microservices\$ms\src\main\resources\db\changelog"
    
    if (Test-Path $targetPath) {
        Write-Host "Sincronizando $ms..."
        Copy-Item "$dbProjectPath\*" "$targetPath\" -Recurse -Force
        Write-Host "✓ $ms sincronizado"
    } else {
        Write-Host "✗ $ms no encontrado"
    }
}
```

## 🐳 Ejecución Coordinada con Docker

### docker-compose.yml integrado

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: rematepos_db
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  product-service:
    build:
      context: ./microservices/product-microservice
    depends_on:
      - postgres
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/rematepos_db
      SPRING_DATASOURCE_USERNAME: ${DB_USER}
      SPRING_DATASOURCE_PASSWORD: ${DB_PASSWORD}
    ports:
      - "8001:8080"

  customer-service:
    build:
      context: ./microservices/customer-microservice
    depends_on:
      - postgres
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/rematepos_db
      SPRING_DATASOURCE_USERNAME: ${DB_USER}
      SPRING_DATASOURCE_PASSWORD: ${DB_PASSWORD}
    ports:
      - "8002:8080"

  cart-service:
    build:
      context: ./microservices/cart-microservice
    depends_on:
      - postgres
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/rematepos_db
      SPRING_DATASOURCE_USERNAME: ${DB_USER}
      SPRING_DATASOURCE_PASSWORD: ${DB_PASSWORD}
    ports:
      - "8003:8080"

volumes:
  postgres_data:
```

## 🚀 Pipeline CI/CD

### GitHub Actions Ejemplo

```yaml
name: DB Migration and Services

on: [push, pull_request]

jobs:
  database:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Set up JDK 17
        uses: actions/setup-java@v2
        with:
          java-version: '17'
      
      - name: Validate DB Changelog
        run: |
          cd RematePos-db
          mvn liquibase:validate
      
      - name: Run Migrations (Dev)
        run: |
          cd RematePos-db
          mvn liquibase:update

  microservices:
    needs: database
    runs-on: ubuntu-latest
    strategy:
      matrix:
        service: [product-microservice, customer-microservice, cart-microservice]
    steps:
      - uses: actions/checkout@v2
      
      - name: Set up JDK 17
        uses: actions/setup-java@v2
        with:
          java-version: '17'
      
      - name: Build ${{ matrix.service }}
        run: |
          cd microservices/${{ matrix.service }}
          mvn clean package -DskipTests
```

## ⚠️ Consideraciones Importantes

### Versionamiento Único
- Cada changeset debe tener un `id` único en **toda la aplicación**
- Si dos microservicios crean el mismo changeset, habrá conflicto

### Centralización Recomendada
```
RematePos-db/                          # Fuente de verdad
├── src/main/resources/db/changelog/
│   ├── productos/                    # Changesets de productos
│   ├── clientes/                     # Changesets de clientes
│   ├── pedidos/                      # Changesets de pedidos
│   └── compartido/                   # Shared schemas

product-microservice/
├── src/main/resources/db/changelog/  # Copia de RematePos-db
```

### Conflictos de Merging
Si dos desarrolladores crean changesets simultáneamente:

```yaml
# Developer A
- changeSet:
    id: 004_add_column_a
    author: dev_a

# Developer B  
- changeSet:
    id: 004_add_column_b
    author: dev_b
```

**Solución:** Renombrar uno a `005_add_column_b`

## 🔐 Seguridad en CI/CD

```yaml
# Usar secretos para credenciales
- name: Run Migrations
  env:
    DB_PASSWORD: ${{ secrets.DB_PASSWORD_QA }}
  run: |
    mvn -P qa liquibase:update \
      -Ddb.username=${{ secrets.DB_USERNAME }} \
      -Ddb.password=${{ env.DB_PASSWORD }}
```

## 📊 Monitoreo

### Ver changesets ejecutados

```sql
-- En PostgreSQL
SELECT * FROM databasechangelog 
ORDER BY dateexecuted DESC;

-- Contar por microservicio
SELECT author, COUNT(*) 
FROM databasechangelog 
GROUP BY author;
```

---

## 📞 Checklist de Integración

- [ ] Liquibase agregado a pom.xml
- [ ] application.yml configurado
- [ ] ChangeLog copiado a cada microservicio
- [ ] Migraciones testeadas en desarrollo
- [ ] CI/CD configurado
- [ ] Documentación del equipo actualizada
- [ ] Pre-commit hooks configurados

---

**¡Listo para sincronizar cambios de BD con todos los microservicios!**

