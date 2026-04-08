# RematePos Database Migration Script
# Ejecuta migraciones de Liquibase según el ambiente

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("dev", "qa", "release", "main")]
    [string]$Environment,

    [Parameter(Mandatory = $false)]
    [ValidateSet("update", "status", "validate", "history")]
    [string]$Command = "update"
)

# Colores para output
$Colors = @{
    Green  = 32
    Yellow = 33
    Red    = 31
    Blue   = 34
}

function Write-ColorOutput([string]$message, [int]$color) {
    Write-Host -ForegroundColor ($Colors[$([string]$color)] / 10) $message
}

Write-ColorOutput "=== RematePos Database Migration ===" "Blue"
Write-ColorOutput "Environment: $Environment" "Blue"
Write-ColorOutput "Command: $Command" "Blue"
Write-ColorOutput "" "Blue"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# Validar que estamos en el directorio correcto
if (-not (Test-Path "$projectRoot\pom.xml")) {
    Write-ColorOutput "Error: pom.xml no encontrado en $projectRoot" "Red"
    exit 1
}

# Ejecutar Maven
try {
    Write-ColorOutput "Ejecutando liquibase:$Command..." "Yellow"

    if ($Environment -eq "dev") {
        mvn -f "$projectRoot\pom.xml" liquibase:$Command
    }
    else {
        mvn -f "$projectRoot\pom.xml" -P $Environment liquibase:$Command
    }

    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "✓ Migraciones completadas exitosamente" "Green"
    }
    else {
        Write-ColorOutput "✗ Error durante la ejecución" "Red"
        exit $LASTEXITCODE
    }
}
catch {
    Write-ColorOutput "Error: $_" "Red"
    exit 1
}

