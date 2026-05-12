# Database Cleanup Plan

## Purpose

This document records the safe cleanup baseline for RematePos-bd before deeper repository reorganization.

HU-094 focuses on documentation and structure. It does not delete local files, rewrite history, or change functional database migrations.

## Protected Files

Do not commit:

- Real `.env` files.
- Environment-specific `.env.dev`, `.env.qa`, `.env.main`, or `.env.release` files.
- Logs.
- `target/`.
- Dumps.
- Backups.
- Compressed archives.
- Real database credentials.

## Safe Files

The following files can be versioned when they contain placeholders only:

- `.env.example`
- `docker-compose/.env.example`
- Documentation files.
- README files.

## Current Safe Cleanup Status

- HU-095 prepared the safe cleanup direction.
- HU-096 removed sensitive database literals from current versioned configuration files.
- HU-094 organizes documentation indexes and clarifies repository usage.

## Pending Structural Work

The following paths are intentionally not moved in HU-094 because they are used by current runtime commands:

- `liquibase-properties`
- `driver/`
- `mongo/`
- `src/main/resources/db/changelog/`
- `docker-compose/docker-compose.yml`

Those paths can be reorganized later only with a dedicated task that updates Docker, Liquibase, scripts, and documentation together.
