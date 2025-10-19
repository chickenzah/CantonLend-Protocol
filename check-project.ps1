# ===============================
# CantonHackathon - Project Checker
# ===============================
Write-Host "🚀 Starting CantonHackathon project check..." -ForegroundColor Cyan

# --- 1. Check backend (Daml Sandbox)
$backendPath = "D:\CantonHackathon\backend\canton-lend"
$frontendPath = "D:\CantonHackathon\frontend"

Write-Host "`n🔍 Checking backend directory..."
if (Test-Path $backendPath) {
    Write-Host "✅ Backend found at $backendPath"
} else {
    Write-Host "❌ Backend not found! Check path." -ForegroundColor Red
    exit
}

# --- 2. Check if Daml Sandbox is running
Write-Host "`n🔍 Checking if Daml Sandbox (port 7575) is running..."
$portCheck = (Get-NetTCPConnection -LocalPort 7575 -ErrorAction SilentlyContinue)
if ($portCheck) {
    Write-Host "✅ Daml JSON API is running on port 7575"
} else {
    Write-Host "❌ Sandbox not running. Starting it now..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "cd '$backendPath'; daml start" -WindowStyle Minimized
    Start-Sleep -Seconds 10
}

# --- 3. Check JSON API response
Write-Host "`n🔍 Checking Daml JSON API connectivity..."
try {
    $response = Invoke-RestMethod -Uri "http://localhost:7575/v1/query" -Method POST -Body '{"templateIds":["Main.User"]}' -ContentType "application/json" -ErrorAction Stop
    Write-Host "✅ JSON API responded successfully!"
} catch {
    Write-Host "⚠️ JSON API not responding. Possibly still starting up..." -ForegroundColor Yellow
}

# --- 4. Check frontend folder
Write-Host "`n🔍 Checking frontend directory..."
if (Test-Path $frontendPath) {
    Write-Host "✅ Frontend found at $frontendPath"
} else {
    Write-Host "❌ Frontend not found! Check path." -ForegroundColor Red
    exit
}

# --- 5. Start frontend (npm start)
Write-Host "`n🌐 Starting frontend React app..."
Start-Process powershell -ArgumentList "cd '$frontendPath'; npm start" -WindowStyle Minimized
Start-Sleep -Seconds 8

# --- 6. Check if frontend is running
try {
    $res = Invoke-WebRequest -Uri "http://localhost:3000" -UseBasicParsing -TimeoutSec 5
    if ($res.StatusCode -eq 200) {
        Write-Host "✅ Frontend is running at http://localhost:3000" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Frontend responded with status $($res.StatusCode)"
    }
} catch {
    Write-Host "❌ Frontend not responding at localhost:3000" -ForegroundColor Red
}

Write-Host "`n============================="
Write-Host "🏁 Check completed!"
Write-Host "Open:"
Write-Host "  • Backend JSON API → http://localhost:7575/v1/query"
Write-Host "  • Frontend React   → http://localhost:3000"
Write-Host "============================="
