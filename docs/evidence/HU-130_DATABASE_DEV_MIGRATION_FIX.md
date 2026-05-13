# HU-130 - Database DEV Migration Fix

## Purpose

This document records the HU-130 fix for running the RematePOS database DEV environment from a clean clone.

The target command is:

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml up -d
```

## Original Errors

### Liquibase

Liquibase failed with an `UnknownHostException` because the JDBC URL received the placeholder literally:

```text
${POSTGRESQL_HOST}
```

The expected host inside Docker Compose is the PostgreSQL service name:

```text
postgresql
```

### Mongo Migration

`mongo-migrate` failed with:

```text
/usr/bin/env: 'sh\r': No such file or directory
```

This was caused by CRLF line endings in the shell script mounted into the Linux container.

## Root Cause

- `liquibase-properties` used `${POSTGRESQL_HOST}` and `${PRODUCT_DB_NAME}` placeholders inside the defaults file.
- Liquibase did not interpolate those placeholders when loading the defaults file, so the JDBC URL kept `${POSTGRESQL_HOST}` as a literal hostname.
- `mongo/run-migrations.sh` had CRLF line endings.
- The repository did not have `.gitattributes` rules to force LF for shell scripts.

## Files Corrected

- `docker-compose/docker-compose.yml`
- `docker-compose/.env.example`
- `mongo/run-migrations.sh`
- `migrate.sh`
- `.gitattributes`

## Fix Applied

- The Liquibase Docker Compose service now passes `--url`, `--username`, `--password`, `--changeLogFile`, `--driver`, and `--logLevel` directly as Compose-resolved command arguments.
- The JDBC URL now uses the Docker Compose service hostname `postgresql`.
- `docker-compose/.env.example` now contains safe example defaults instead of angle-bracket placeholders.
- Shell scripts were normalized to LF line endings.
- `.gitattributes` was added to keep `.sh`, `.sql`, `.yaml`, and `.yml` files stable across operating systems.

## Commands Executed

Compose syntax validation:

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml config --quiet
```

Restart database DEV stack:

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml down
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml up -d
```

Status validation:

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml ps -a
```

## Validation Result

```text
NAME                      SERVICE         STATUS
rematepos-postgresql      postgresql      Up / healthy
rematepos-mongodb         mongodb         Up
rematepos-liquibase       liquibase       Exited (0)
rematepos-mongo-migrate   mongo-migrate   Exited (0)
```

## Security

No real environment files were committed.

The fix does not include:

- real `.env` files;
- secrets;
- real passwords;
- logs;
- dumps;
- backups;
- generated artifacts;
- private customer data.

Only safe example values and configuration changes were versioned.
