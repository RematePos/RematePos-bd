.PHONY: help build test clean migrate-dev migrate-qa migrate-release migrate-main validate docker-up docker-down docker-logs

help:
	@echo "RematePos DB - Liquibase Migration Commands"
	@echo "==========================================="
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  help              - Mostrar esta ayuda"
	@echo "  migrate-dev       - Ejecutar migraciones en desarrollo"
	@echo "  migrate-qa        - Ejecutar migraciones en QA"
	@echo "  migrate-release   - Ejecutar migraciones en release"
	@echo "  migrate-main      - Ejecutar migraciones en producción"
	@echo "  validate          - Validar changeLog"
	@echo "  status-dev        - Ver estado en desarrollo"
	@echo "  status-qa         - Ver estado en QA"
	@echo "  docker-up         - Levantar servicios con Docker Compose"
	@echo "  docker-down       - Detener servicios"
	@echo "  docker-logs       - Ver logs de servicios"
	@echo "  clean             - Limpiar directorios de build"
	@echo ""

migrate-dev:
	mvn liquibase:update

migrate-qa:
	mvn -P qa liquibase:update

migrate-release:
	mvn -P release liquibase:update

migrate-main:
	mvn -P main liquibase:update

validate:
	mvn liquibase:validate

status-dev:
	mvn liquibase:status

status-qa:
	mvn -P qa liquibase:status

docker-up:
	docker compose -f docker-compose.migration.yml up -d

docker-down:
	docker compose -f docker-compose.migration.yml down

docker-logs:
	docker compose -f docker-compose.migration.yml logs -f

clean:
	mvn clean

build:
	mvn clean package

.DEFAULT_GOAL := help

