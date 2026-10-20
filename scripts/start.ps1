$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$upstreamDir = Join-Path $repoRoot 'vendor\iptv-api'

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker was not found. Run .\scripts\install.ps1 first." -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Force -Path (Split-Path $upstreamDir -Parent) | Out-Null

if (-not (Test-Path (Join-Path $upstreamDir '.git'))) {
    Write-Host "Cloning Guovin/iptv-api..." -ForegroundColor Cyan
    git clone https://github.com/Guovin/iptv-api.git $upstreamDir
} else {
    Write-Host "Updating Guovin/iptv-api..." -ForegroundColor Cyan
    git -C $upstreamDir pull --ff-only
}

Set-Location $upstreamDir

docker compose up -d --build

Write-Host "" 
Write-Host "IPTV project started successfully." -ForegroundColor Green
Write-Host "Useful commands:" -ForegroundColor Yellow
Write-Host "  docker compose ps" -ForegroundColor White
Write-Host "  docker compose logs -f" -ForegroundColor White
Write-Host "  Explore the upstream project at: $upstreamDir" -ForegroundColor White
Write-Host "" 
Write-Host "If the app has started, open the local port shown by Docker Desktop or the upstream project docs." -ForegroundColor Green
