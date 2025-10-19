# ==========================================
# Canton Hackathon Backend Startup Script
# Clean Version (No Emoji)
# ==========================================

Write-Host ""
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "  Starting Canton Hackathon Backend..." -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Yellow

# --- Check if Daml SDK is installed ---
if (-not (Get-Command daml -ErrorAction SilentlyContinue)) {
    Write-Host "DAML SDK not found. Please install it first." -ForegroundColor Red
    exit
}

# --- Paths ---
$backendPath = "D:\CantonHackathon\backend\canton-lend"
$jsonApiPort = 7575
$ledgerPort = 6865

Write-Host ""
Write-Host "Checking backend path..."
if (Test-Path $backendPath) {
    Write-Host "Backend found at $backendPath" -ForegroundColor Green
} else {
    Write-Host "Backend folder not found: $backendPath" -ForegroundColor Red
    exit
}

# --- Start Canton Sandbox ---
Write-Host ""
Write-Host "Starting Canton Sandbox on port $ledgerPort..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "cd `"$backendPath`"; daml start" -WindowStyle Normal

# Wait a bit to allow sandbox to start
Start-Sleep -Seconds 10

# --- Start Daml JSON API ---
Write-Host ""
Write-Host "Starting Daml JSON API on port $jsonApiPort..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "daml json-api --ledger-host localhost --ledger-port $ledgerPort --http-port $jsonApiPort" -WindowStyle Normal

Write-Host ""
Write-Host "Ledger port (sandbox): $ledgerPort" -ForegroundColor Gray
Write-Host "JSON API port: $jsonApiPort" -ForegroundColor Gray
Write-Host ""
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "Backend services are starting up..." -ForegroundColor Green
Write-Host "You can check:"
Write-Host "  - Ledger: http://localhost:$ledgerPort"
Write-Host "  - JSON API: http://localhost:$jsonApiPort/v1/query"
Write-Host "==========================================" -ForegroundColor Yellow
