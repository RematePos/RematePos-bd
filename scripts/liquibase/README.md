# Liquibase Support

Target location for future Liquibase helper configuration.

Current file kept at repository root for Docker Compose compatibility:

- `liquibase-properties`

The current `docker-compose/docker-compose.yml` references `/workspace/liquibase-properties`, so moving this file would break the current compose flow unless the compose command is updated.
