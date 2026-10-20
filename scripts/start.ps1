$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$upstreamDir = Join-Path $repoRoot 'vendor\iptv-api'
$composeFile = Join-Path $upstreamDir 'docker-compose.yml'

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

if (-not (Test-Path $composeFile)) {
    Write-Host "docker-compose.yml was not found in: $upstreamDir" -ForegroundColor Red
    exit 1
}

Write-Host "Checking Docker Compose config..." -ForegroundColor Cyan
$content = Get-Content -Path $composeFile -Raw
if ($content.Contains('image: guovern/iptv-api:latest')) {
    Write-Host "Switching Docker Compose to a local build to avoid the broken image pull path." -ForegroundColor Yellow
    $updated = $content -replace 'image:\s*guovern/iptv-api:latest', 'build: .'
    Set-Content -Path $composeFile -Value $updated -Encoding UTF8
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
