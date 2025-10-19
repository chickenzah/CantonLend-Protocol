Write-Host "🚀 Starting React frontend setup..." -ForegroundColor Cyan

# 1. Xóa thư mục frontend cũ (nếu có)
if (Test-Path "frontend") {
    Write-Host "🧹 Removing old frontend folder..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "frontend"
}

# 2. Tạo React app mới
Write-Host "⚙️ Creating new React app..." -ForegroundColor Yellow
npx create-react-app frontend

# 3. Cài thêm thư viện phụ thuộc (axios để gọi API)
Write-Host "📦 Installing axios..." -ForegroundColor Yellow
cd frontend
npm install axios

# 4. Tạo lại các thư mục và copy code hiện có
Write-Host "🪄 Copying existing source files..." -ForegroundColor Yellow
if (!(Test-Path ".\src\api")) { New-Item -ItemType Directory -Path ".\src\api" | Out-Null }
if (!(Test-Path ".\src\mocks")) { New-Item -ItemType Directory -Path ".\src\mocks" | Out-Null }

$basePath = "D:\CantonHackathon\templates"

if (Test-Path "$basePath\App.js") {
    Copy-Item "$basePath\App.js" ".\src\App.js" -Force
}
if (Test-Path "$basePath\api.js") {
    Copy-Item "$basePath\api.js" ".\src\api\api.js" -Force
}
if (Test-Path "$basePath\mockContracts") {
    Copy-Item "$basePath\mockContracts\*" ".\src\mocks\" -Recurse -Force
}

# 5. Hoàn tất
Write-Host "✅ Frontend setup complete!" -ForegroundColor Green
Write-Host "🌍 You can now run:" -ForegroundColor Cyan
Write-Host "cd D:\CantonHackathon\frontend" -ForegroundColor White
Write-Host "npm start" -ForegroundColor White
