# RematePos DB - Deployment Guide

## Scope

This guide defines the minimum safe flow to deploy Liquibase migrations in each environment.

## Preconditions

- Backup completed for target database.
- Environment credentials loaded as variables (never hardcoded).
- `mvn liquibase:validate` executed successfully in CI.
- Approved change ticket for `release` and `main`.

## Environment Variables

Required for local/dev:

```powershell
$env:DB_USER_DEV = "<db-user>"
$env:DB_PASSWORD_DEV = "<db-password>"
```

Required for QA/Release/Main (examples):

```powershell
$env:DB_PASSWORD_QA = "<qa-secret>"
$env:DB_PASSWORD_RELEASE = "<release-secret>"
$env:DB_PASSWORD_MAIN = "<main-secret>"
```

## Deployment Commands

```powershell
mvn liquibase:validate
mvn -P dev liquibase:update
mvn -P qa liquibase:update
mvn -P release liquibase:update
mvn -P main liquibase:update
```

## Verification

```powershell
mvn liquibase:status
mvn liquibase:history
```

- Confirm new changesets in `databasechangelog`.
- Confirm application startup with `ddl-auto=validate`.

## Rollback

Use rollback only under approved incident flow:

```powershell
mvn liquibase:rollback -Dliquibase.rollbackCount=1
```

For production, prefer corrective changeset over direct rollback when data risk exists.

## Security Policy

- Do not commit `.env`.
- Do not commit real passwords in `.properties`, `.md`, `.sql`, or compose files.
- Use placeholders in docs and secret manager in pipelines.

