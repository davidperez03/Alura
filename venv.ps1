#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

Write-Host "Activando entorno virtual..." -ForegroundColor Green

# Detectar el sistema operativo
$esWindows = $false
$esLinux = $false
$esMac = $false

if ($IsWindows) {
    $esWindows = $true
} elseif ($IsLinux) {
    $esLinux = $true
} elseif ($IsMacOS) {
    $esMac = $true
}

try {
    # Activar entorno virtual
    if ($esWindows) {
        if (Test-Path ".\.venv\Scripts\Activate.ps1") {
            Write-Host "Usando ruta de Windows..." -ForegroundColor Yellow
            & .\.venv\Scripts\Activate.ps1
        } else {
            throw "No se encontró el entorno virtual en Windows"
        }
    } elseif ($esLinux -or $esMac) {
        if (Test-Path ".\.venv/bin/activate") {
            Write-Host "Usando ruta de Linux/macOS..." -ForegroundColor Yellow
            & .\.venv/bin/activate
        } else {
            throw "No se encontró el entorno virtual en Linux/macOS"
        }
    } else {
        throw "Sistema operativo no soportado"
    }

    Write-Host "Entorno virtual activado correctamente!" -ForegroundColor Green

    # Actualizar pip y gestionar dependencias
    Write-Host "Actualizando pip..." -ForegroundColor Yellow
    python -m pip install --upgrade pip

    if (Test-Path "requirements.txt") {
        Write-Host "Instalando dependencias desde requirements.txt..." -ForegroundColor Cyan
        pip install -r requirements.txt
    } else {
        Write-Host "No se encontró el archivo requirements.txt" -ForegroundColor Yellow
        Write-Host "¿Deseas instalar las dependencias básicas de Django? (S/N)" -ForegroundColor Yellow
        $respuesta = Read-Host
        if ($respuesta -eq 'S' -or $respuesta -eq 's') {
            Write-Host "Instalando Django..." -ForegroundColor Cyan
            pip install django

            Write-Host "¿Deseas generar un nuevo archivo requirements.txt? (S/N)" -ForegroundColor Yellow
            $generar_req = Read-Host
            if ($generar_req -eq 'S' -or $generar_req -eq 's') {
                pip freeze > requirements.txt
                Write-Host "Archivo requirements.txt generado" -ForegroundColor Green
            }
        } else {
            Write-Host "Instalación de dependencias cancelada" -ForegroundColor Yellow
        }
    }

    Write-Host "Proceso completado exitosamente" -ForegroundColor Green
    Write-Host "Listado de paquetes instalados:" -ForegroundColor Yellow
    pip list
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
