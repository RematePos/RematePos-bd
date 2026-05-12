# HU-096 Database Sensitive Files Audit

## Purpose

This document records the HU-096 security review for the RematePOS database repository.

The goal is to remove or replace sensitive database configuration values from versioned files, document the risk, and define the safe follow-up actions without changing functional database migrations, SQL scripts, Docker Compose behavior, or repository structure.

## Scope

Repository: RematePos-bd

Branch: feature/HU-096-CAVY-sensitive-files-audit-database

Reviewed files:

- .env.example
- liquibase-properties
- docker-compose/.env.example
- src/main/resources/liquibase.properties
- src/main/resources/liquibase-dev.properties
- src/main/resources/liquibase-qa.properties
- src/main/resources/liquibase-main.properties
- src/main/resources/liquibase-release.properties
- docker-compose/.env*
- .env*

## Findings

The audit found versioned Liquibase configuration files with literal database connection metadata. Some files contained fixed database URLs and usernames. One legacy Liquibase CLI configuration also contained a literal database password value.

No full secret values are documented in this file.

The audit also confirmed that environment-specific local files such as real .env files must remain unversioned. Example files are allowed only when they contain placeholders and no real credentials.

## Changes Applied

- Replaced Liquibase database URLs with environment variable placeholders.
- Replaced Liquibase usernames with environment variable placeholders.
- Replaced Liquibase passwords with environment variable placeholders.
- Strengthened .env.example and docker-compose/.env.example so they only contain placeholder values.
- Strengthened .gitignore rules for environment files, generated files, logs, dumps, backups, temporary files, and compressed archives.

## Files Protected By Gitignore

The repository now ignores these sensitive or generated patterns:

- .env
- .env.*
- docker-compose/.env
- docker-compose/.env.dev
- docker-compose/.env.qa
- docker-compose/.env.main
- docker-compose/.env.release
- target/
- logs/
- *.log
- hs_err_pid*.log
- *.dump
- *.backup
- *.bak
- *.tmp
- *.zip
- *.rar

Allowed examples:

- .env.example
- docker-compose/.env.example

## Validation

Validation focus:

- Real .env files must not be staged.
- Generated files must not be staged.
- Liquibase properties must use placeholders instead of literal credentials.
- SQL scripts and migrations must remain unchanged.
- Docker Compose runtime files must remain unchanged.

## Relation With Other User Stories

HU-095 prepared the database repository to avoid committing local secrets and generated files.

HU-096 applies the security audit to versioned database configuration files and documents the sensitive file risk.

HU-094 remains a future structural cleanup task. No folder reorganization is performed in this HU.

## Pending Work

- Review whether any historical values were real credentials or local placeholders.
- Rotate credentials if any historical value was real.
- Plan Git history cleanup only after explicit team approval.
- Continue structural repository cleanup later under HU-094.

## Secret Rotation Recommendations

If any previously versioned database value was used outside a local development environment, treat it as exposed.

Recommended actions:

- Rotate the affected PostgreSQL user password.
- Rotate any Liquibase execution credentials that reused the same value.
- Update local .env files after rotation.
- Update GitHub Actions secrets or deployment secrets if those credentials were ever copied there.
- Confirm that old credentials no longer work.

Do not commit the rotated values. Store them only in local .env files, GitHub secrets, or the future secret manager selected for deployment.

## Git History Cleanup Recommendation

This PR removes sensitive literals from the current versioned files, but it does not rewrite Git history.

If the team confirms that historical values were real credentials, plan a separate approved cleanup using a tool such as git filter-repo or BFG Repo-Cleaner.

Important constraints:

- Do not run history cleanup without team approval.
- Do not force push without team approval.
- Coordinate credential rotation before rewriting history.
- Inform all contributors that they may need to reclone or resynchronize after a future history rewrite.
