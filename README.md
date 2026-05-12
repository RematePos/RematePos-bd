# RematePos-bd

Repository for RematePOS database versioning, environment configuration, migration documentation, and database support scripts.

## Purpose

This repository centralizes database assets used by RematePOS:

- PostgreSQL schema and Liquibase changelogs.
- MongoDB migration scripts.
- Docker Compose setup for local DEV, QA, and MAIN database environments.
- Safe environment templates.
- Database documentation and security notes.

## Repository Structure

```text
README.md
docs/
docker-compose/
scripts/
migrations/
tools/
src/main/resources/db/changelog/
mongo/
driver/
```

## Main Documentation

- [Documentation index](docs/README.md)
- [Environment strategy](docs/ENVIRONMENT_STRATEGY.md)
- [Docker Compose usage](docker-compose/README.md)
- [Scripts notes](scripts/README.md)
- [Migration notes](migrations/README.md)
- [Database sensitive files audit](docs/security/SENSITIVE_FILES_AUDIT_DATABASE.md)

## Current Environment Strategy

The database repository currently uses one compose file:

```text
docker-compose/docker-compose.yml
```

Different environments are started with different local `.env` files:

```text
docker-compose/.env.dev
docker-compose/.env.qa
docker-compose/.env.main
```

Only `docker-compose/.env.example` is versioned.

## Docker Commands

DEV:

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml up -d
```

QA:

```powershell
docker compose -p pos-db-qa --env-file .\docker-compose\.env.qa -f .\docker-compose\docker-compose.yml up -d
```

MAIN:

```powershell
docker compose -p pos-db-main --env-file .\docker-compose\.env.main -f .\docker-compose\docker-compose.yml up -d
```

## Security Rules

Do not commit:

- Real `.env` files.
- `.env.dev`, `.env.qa`, `.env.main`, or `.env.release`.
- `docker-compose/.env`.
- Database dumps.
- Backups.
- Logs.
- `target/`.
- Real credentials, passwords, tokens, or secret keys.

Use example files with placeholders only.

## Notes About Runtime Paths

Some files remain in their current locations because the current Docker Compose and Liquibase flows depend on them:

- `liquibase-properties`
- `driver/`
- `mongo/`
- `src/main/resources/db/changelog/`

Those paths should only be moved in a future dedicated task that updates runtime references safely.
