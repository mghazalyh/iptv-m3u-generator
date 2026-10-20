$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$serviceName = 'iptv-m3u-generator'
$scriptPath = Join-Path $repoRoot 'scripts\start.ps1'

if (-not (Get-Command nssm -ErrorAction SilentlyContinue)) {
    Write-Host "NSSM was not found. Installing it with winget..." -ForegroundColor Cyan
    winget install --id NSSM.NSSM --accept-source-agreements --accept-package-agreements
    Write-Host "Please reopen PowerShell and run this script again." -ForegroundColor Yellow
    exit 0
}

$nssmExe = (Get-Command nssm).Source

# Remove existing service if present
$existing = & $nssmExe status $serviceName 2>$null
if ($LASTEXITCODE -eq 0) {
    & $nssmExe remove $serviceName confirm
}

& $nssmExe install $serviceName "$env:ComSpec" "/c" "powershell -NoProfile -ExecutionPolicy Bypass -File \"$scriptPath\""
& $nssmExe set $serviceName AppDirectory $repoRoot
& $nssmExe set $serviceName Start SERVICE_AUTO_START
& $nssmExe set $serviceName ObjectName LocalSystem

Write-Host "" 
Write-Host "Service installed: $serviceName" -ForegroundColor Green
Write-Host "Use these commands to manage it:" -ForegroundColor Yellow
Write-Host "  nssm start $serviceName" -ForegroundColor White
Write-Host "  nssm stop $serviceName" -ForegroundColor White
Write-Host "  sc query $serviceName" -ForegroundColor White
Write-Host "" 
Write-Host "If you want the service to start automatically, the service has been configured for Auto start." -ForegroundColor Green
