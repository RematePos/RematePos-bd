# Docker Compose

This folder contains the current Docker Compose entrypoint for RematePos database services.

## Versioned Files

- `docker-compose.yml`: main compose file for PostgreSQL, MongoDB, Liquibase, and Mongo migrations.
- `.env.example`: safe template with placeholder values.

## Local Files

Create these files locally when needed:

- `.env.dev`
- `.env.qa`
- `.env.main`

These files are ignored by Git and must not be committed.

## Start DEV

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml up -d
```

## Start QA

```powershell
docker compose -p pos-db-qa --env-file .\docker-compose\.env.qa -f .\docker-compose\docker-compose.yml up -d
```

## Start MAIN

```powershell
docker compose -p pos-db-main --env-file .\docker-compose\.env.main -f .\docker-compose\docker-compose.yml up -d
```

## Notes

- The compose file mounts `liquibase-properties` from the repository root.
- The compose file mounts Mongo migration files from `mongo/`.
- Those runtime paths were not moved in HU-094 to avoid breaking the current compose flow.

For the complete environment strategy, see:

```text
docs/ENVIRONMENT_STRATEGY.md
```
