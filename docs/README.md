# RematePos-bd Documentation

This folder is the documentation index for the RematePos-bd repository.

## Start Here

- [Repository index](INDEX.md)
- [Start here](START_HERE.md)
- [Quickstart](QUICKSTART.md)
- [FAQ](FAQ.md)

## Architecture And Database Design

- [Database design](DATABASE_DESIGN.md)
- [Repository structure](ESTRUCTURA.md)
- [Microservices integration](MICROSERVICES_INTEGRATION.md)
- [Templates](TEMPLATES.md)
- [Best practices](BEST_PRACTICES.md)

## Environments And Deployment

- [Environment strategy](ENVIRONMENT_STRATEGY.md)
- [Deployment guide](DEPLOYMENT.md)
- [Deployment checklist](DEPLOYMENT_CHECKLIST.md)

## Implementation Notes

- [Implementation summary](IMPLEMENTACION.md)
- [Completion summary](COMPLETION_SUMMARY.md)
- [Executive guide](GUIA_EJECUTIVA.md)
- [Database cleanup plan](DATABASE_CLEANUP_PLAN.md)

## Security

- [Database sensitive files audit](security/SENSITIVE_FILES_AUDIT_DATABASE.md)

## Runtime Folders

Some runtime paths remain in their current locations because Docker Compose and Liquibase depend on them:

- `liquibase-properties`
- `driver/`
- `mongo/`
- `src/main/resources/db/changelog/`

Moving those files requires a separate functional migration task and is not part of HU-094.
