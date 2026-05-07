# Database Safe Cleanup Plan

## Purpose

This document prepares the RematePOS database repository for a safe cleanup before the structural reorganization planned in HU-094.

HU-095 does not move folders, delete files, change database logic, or reorganize migrations. Its scope is limited to protecting sensitive/generated files and classifying pending work before any structural cleanup.

## Current Risk Summary

The repository contains environment files, generated folders, logs and many database scripts that must be reviewed before any future reorganization.

## Sensitive Or Generated Files Detected

| Path | Type | Risk | Action |
| --- | --- | --- | --- |
| `.env` | Local environment file | May contain real local credentials | Must stay ignored |
| `.env.*` | Local environment files | May contain real environment-specific credentials | Must stay ignored except examples |
| `docker-compose/.env` | Docker local environment | May contain database credentials | Must stay ignored |
| `docker-compose/.env.dev` | Docker DEV environment | May contain local credentials | Must stay ignored |
| `docker-compose/.env.qa` | Docker QA environment | May contain QA credentials | Must stay ignored |
| `docker-compose/.env.main` | Docker MAIN environment | May contain production-like credentials | Must stay ignored |
| `target/` | Maven build output | Generated files should not be versioned | Must stay ignored |
| `*.log` | Runtime logs | Noise and possible sensitive operational data | Must stay ignored |
| `hs_err_pid*.log` | JVM crash logs | Local machine diagnostics | Must stay ignored |
| `*.dump`, `*.backup`, `*.bak` | Database backups/dumps | Can contain real business data | Must stay ignored |
| `*.tmp`, `*.zip`, `*.rar` | Temporary/archive files | Can include unreviewed or heavy artifacts | Must stay ignored |

## Files That Must Not Be Uploaded

- Real `.env` files.
- Database dumps.
- Backup files.
- Local logs.
- JVM crash reports.
- Maven `target/` output.
- Temporary archives generated during local work.

## Pending For HU-094

HU-094 should only start after the team confirms what files are useful and what files are temporary. The future cleanup should classify documentation, scripts, migrations, seeds, Docker files and environment guides into the final folder structure.

## Scripts Pending Classification

The following groups must be classified before moving anything:

| Area | Candidate Paths | Notes |
| --- | --- | --- |
| PostgreSQL SQL scripts | `00_extensions/` to `12_rollbacks/` | Need mapping to service and migration purpose |
| Liquibase changelog | `driver/`, `src/main/resources/db/changelog/` | Need canonical source decision |
| MongoDB migrations | `mongo/changelog/`, `mongo/run-migrations.sh` | Need service ownership mapping |
| Migration helpers | `migrate.ps1`, `migrate.sh`, `liquibase-properties` | Need environment strategy review |
| Docker support | `docker-compose/`, `docker-compose.migration.yml` | Need DEV/QA/MAIN documentation before restructuring |

## Database Environment Compose Strategy

The database repository currently uses one shared Docker Compose file and different environment files per environment.

| Environment | Docker Project | Compose File | Env File | PostgreSQL Port | MongoDB Port |
| --- | --- | --- | --- | --- | --- |
| DEV | `pos-db-dev` | `docker-compose/docker-compose.yml` | `docker-compose/.env.dev` | `5433` | `27017` |
| QA | `pos-db-qa` | `docker-compose/docker-compose.yml` | `docker-compose/.env.qa` | `6433` | `37017` |
| MAIN | `pos-db-main` | `docker-compose/docker-compose.yml` | `docker-compose/.env.main` | `8433` | `57017` |

The `.env.dev`, `.env.qa` and `.env.main` files are local/runtime files. They must not be committed because they can contain real credentials or machine-specific values.

Only `docker-compose/.env.example` should be versioned as the safe template.

### Commands

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml up -d
docker compose -p pos-db-qa --env-file .\docker-compose\.env.qa -f .\docker-compose\docker-compose.yml up -d
docker compose -p pos-db-main --env-file .\docker-compose\.env.main -f .\docker-compose\docker-compose.yml up -d
```

### Validation

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml ps
docker compose -p pos-db-qa --env-file .\docker-compose\.env.qa -f .\docker-compose\docker-compose.yml ps
docker compose -p pos-db-main --env-file .\docker-compose\.env.main -f .\docker-compose\docker-compose.yml ps
```

## Related User Stories

| HU | Scope |
| --- | --- |
| HU-061 | Payment status schema and payment-related database changes |
| HU-063 | Cash movement schema and cash register persistence |
| HU-082 | Independent DEV, QA and MAIN environment strategy |
| HU-083 | Docker Compose execution strategy |
| HU-094 | Future repository structure cleanup |
| HU-095 | Safe pre-cleanup protection and classification |
