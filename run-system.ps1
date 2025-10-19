# --------------------------------------------------
# CantonLend: Run system (Backend + Frontend)
# Author: chickenza
# --------------------------------------------------

# 1. Khởi động Backend (Canton Sandbox + JSON API)
Write-Host "Starting backend..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd `"$PSScriptRoot`"; .\run-backend.ps1"

# 2. Đợi 5 giây để backend khởi động
Start-Sleep -Seconds 5

# 3. Khởi động Frontend
Write-Host "Starting frontend..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd `"$PSScriptRoot\frontend`"; npm install; npm start"

Write-Host "All services are starting. Wait a few seconds for the app to be ready." -ForegroundColor Green
Write-Host "Frontend URL: http://localhost:3000" -ForegroundColor Yellow
Write-Host "JSON API URL: http://localhost:7575" -ForegroundColor Yellow
