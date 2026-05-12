# Database Environment Strategy

## Purpose

RematePos-bd supports independent database environments for DEV, QA, and MAIN using one Docker Compose file and different local environment files.

## Current Strategy

The repository version-controls one compose file:

```text
docker-compose/docker-compose.yml
```

Each environment uses a different local `.env` file:

```text
docker-compose/.env.dev
docker-compose/.env.qa
docker-compose/.env.main
```

These files are not versioned because they can contain ports, database names, users, and credentials.

Only this safe template is versioned:

```text
docker-compose/.env.example
```

## DEV

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml up -d
```

## QA

```powershell
docker compose -p pos-db-qa --env-file .\docker-compose\.env.qa -f .\docker-compose\docker-compose.yml up -d
```

## MAIN

```powershell
docker compose -p pos-db-main --env-file .\docker-compose\.env.main -f .\docker-compose\docker-compose.yml up -d
```

## Verify Running Containers

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml ps
docker compose -p pos-db-qa --env-file .\docker-compose\.env.qa -f .\docker-compose\docker-compose.yml ps
docker compose -p pos-db-main --env-file .\docker-compose\.env.main -f .\docker-compose\docker-compose.yml ps
```

`liquibase` and `mongo-migrate` can finish with `Exited (0)`. That is expected because they are migration jobs.

## Stop An Environment

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml down
```

To remove volumes and reset data for that environment:

```powershell
docker compose -p pos-db-dev --env-file .\docker-compose\.env.dev -f .\docker-compose\docker-compose.yml down -v
```

Use `-v` only when the environment data can be removed.

## Compose Files Not Used Yet

The current repository strategy does not use separate compose files for each environment.

These files do not exist yet:

- `docker-compose.dev.yml`
- `docker-compose.qa.yml`
- `docker-compose.main.yml`

Current strategy:

```text
one docker-compose.yml + different local .env files
```

## Security Rules

- Do not commit `.env.dev`.
- Do not commit `.env.qa`.
- Do not commit `.env.main`.
- Do not commit `docker-compose/.env`.
- Do not commit real passwords, tokens, dumps, backups, logs, or generated files.
