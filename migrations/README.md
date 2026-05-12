# Database Migrations

This folder documents the intended migration organization for RematePos-bd.

Current active migration paths remain unchanged in HU-094:

- PostgreSQL Liquibase changelogs: `src/main/resources/db/changelog/`
- Legacy SQL scripts: `00_extensions/`, `01_tables/`, `02_views/`, `03_functions/`, `04_procedures/`, `05_triggers/`, `06_indexes/`, `07_materialized_views/`, `08_types/`, `09_inserts/`, `10_updates/`, `11_schema/`, `12_rollbacks/`
- Mongo migration scripts: `mongo/`

Moving these paths requires updating Liquibase, Docker Compose, helper scripts, and documentation together. That is intentionally outside HU-094.
