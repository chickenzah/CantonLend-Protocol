# ==============================================
# start-daml.ps1
# Môi trường khởi động Daml Sandbox + JSON API + Navigator + Seed data (Main:setup)
# Tương thích với DAML SDK 2.10.2 (Canton)
# ==============================================

# --- Config ---
$ledgerPort = 6865
$jsonApiPort = 7575
$projectDir = "D:\CantonHackathon\backend\canton-lend"
$darPath = "$projectDir\.daml\dist\canton-lend-0.0.1.dar"

Write-Host ""
Write-Host "============================"
Write-Host "Starting Daml Application..."
Write-Host "============================"
Write-Host ""

# --- Stop old processes ---
Write-Host "Stopping old Daml processes..."
Get-Process | Where-Object { $_.ProcessName -like "*daml*" -or $_.ProcessName -like "*java*" } | Stop-Process -Force -ErrorAction SilentlyContinue

# --- Clean old build ---
Write-Host "Cleaning old .daml directory..."
Remove-Item -Recurse -Force "$projectDir\.daml" -ErrorAction SilentlyContinue

# --- Build DAR ---
Write-Host "Building Daml project..."
daml build
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed! Please fix errors in your Daml code." -ForegroundColor Red
    exit 1
}

# --- Start Sandbox (classic mode for Daml SDK 2.10.x) ---
Write-Host ""
Write-Host "Starting Sandbox (classic) on port $ledgerPort..."
Start-Process -NoNewWindow -FilePath "daml" -ArgumentList "sandbox-classic", "--port", "$ledgerPort", "$darPath"

# Wait a bit for sandbox to boot
Start-Sleep -Seconds 5

# --- Start JSON API ---
Write-Host ""
Write-Host "Starting JSON API on port $jsonApiPort..."
Start-Process -NoNewWindow -FilePath "daml" -ArgumentList "json-api", "--ledger-host", "localhost", "--ledger-port", "$ledgerPort", "--http-port", "$jsonApiPort"

# --- Start Navigator ---
Write-Host ""
Write-Host "Starting Navigator..."
Start-Process -NoNewWindow -FilePath "daml" -ArgumentList "navigator", "server", "localhost", "$ledgerPort"

# --- Wait for Ledger ---
Write-Host ""
Write-Host "Waiting for Ledger to stabilize (10s)..."
Start-Sleep -Seconds 10

# --- Run Daml Script to seed data ---
Write-Host ""
Write-Host "Running Daml Script (Main:setup)..."
& daml script --ledger-host localhost --ledger-port $ledgerPort --dar $darPath --script-name Main:setup

if ($LASTEXITCODE -eq 0) {
    Write-Host "Data seeding script (Main:setup) completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Warning: Could not run seed data script. You can try running it manually:" -ForegroundColor Yellow
    Write-Host "   daml script --ledger-host localhost --ledger-port $ledgerPort --dar $darPath --script-name Main:setup"
}

# --- Summary ---
Write-Host ""
Write-Host "All services are up and running!" -ForegroundColor Green
Write-Host "----------------------------------------"
Write-Host "   Ledger API:   localhost:$ledgerPort"
Write-Host "   JSON API:     http://localhost:$jsonApiPort/"
Write-Host "   Navigator:    http://localhost:4000/"
Write-Host "----------------------------------------"
Write-Host ""
Write-Host "You can open Navigator in your browser to explore demo contracts." -ForegroundColor Cyan
