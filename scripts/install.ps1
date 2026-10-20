$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$dockerDesktopInstalled = $false

# Check for Docker Desktop / Docker CLI
$dockerCmd = Get-Command docker -ErrorAction SilentlyContinue
if (-not $dockerCmd) {
    Write-Host "Docker is not installed or not on PATH." -ForegroundColor Yellow

    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if ($winget) {
        Write-Host "Attempting to install Docker Desktop with winget..." -ForegroundColor Cyan
        winget install --id Docker.DockerDesktop --accept-source-agreements --accept-package-agreements
        Write-Host "Docker installation started. Please reopen PowerShell after installation finishes." -ForegroundColor Green
    } else {
        Write-Host "Docker Desktop could not be installed automatically." -ForegroundColor Red
        Write-Host "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop/" -ForegroundColor Red
        exit 1
    }
    exit 0
}

Write-Host "Docker Desktop/CLI detected." -ForegroundColor Green
Write-Host "You are ready to run: .\scripts\start.ps1" -ForegroundColor Green
