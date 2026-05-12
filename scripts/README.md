# Database Scripts

This folder documents the intended script organization for RematePos-bd.

Current executable scripts remain in their original repository-root locations to avoid breaking existing commands during HU-094:

- `migrate.ps1`
- `migrate.sh`
- `init-db.sql`
- `liquibase-properties`

## Target Areas

- `init/`: initialization scripts.
- `migration/`: helper scripts for Liquibase execution.
- `liquibase/`: Liquibase helper configuration and notes.

Moving executable scripts requires a separate task because current scripts and Docker Compose references assume their existing paths.
