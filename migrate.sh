#!/bin/bash

# RematePos Database Migration Script
# Ejecuta migraciones de Liquibase según el ambiente

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validar argumentos
if [ $# -lt 1 ]; then
    echo -e "${RED}Uso: $0 {dev|qa|release|main} [comando]${NC}"
    echo "Comandos disponibles: update (default), status, validate, history"
    exit 1
fi

ENVIRONMENT=$1
COMMAND=${2:-update}

# Validar environment
case $ENVIRONMENT in
    dev|qa|release|main)
        ;;
    *)
        echo -e "${RED}Ambiente inválido: $ENVIRONMENT${NC}"
        exit 1
        ;;
esac

# Validar comando
case $COMMAND in
    update|status|validate|history)
        ;;
    *)
        echo -e "${RED}Comando inválido: $COMMAND${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}=== RematePos Database Migration ===${NC}"
echo -e "${BLUE}Environment: $ENVIRONMENT${NC}"
echo -e "${BLUE}Command: $COMMAND${NC}"
echo ""

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validar pom.xml
if [ ! -f "$PROJECT_ROOT/pom.xml" ]; then
    echo -e "${RED}Error: pom.xml no encontrado en $PROJECT_ROOT${NC}"
    exit 1
fi

# Ejecutar Maven
try {
    echo -e "${YELLOW}Ejecutando liquibase:$COMMAND...${NC}"

    if [ "$ENVIRONMENT" = "dev" ]; then
        mvn -f "$PROJECT_ROOT/pom.xml" liquibase:$COMMAND
    else
        mvn -f "$PROJECT_ROOT/pom.xml" -P $ENVIRONMENT liquibase:$COMMAND
    fi

    echo -e "${GREEN}✓ Migraciones completadas exitosamente${NC}"
} || {
    echo -e "${RED}✗ Error durante la ejecución${NC}"
    exit 1
}

