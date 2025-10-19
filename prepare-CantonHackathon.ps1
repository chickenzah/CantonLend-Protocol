# ------------------------------
# Script PowerShell dọn dẹp & nén dự án CantonHackathon
# ------------------------------

# 1️⃣ Đặt đường dẫn thư mục dự án
$projectPath = "D:\CantonHackathon"

# Kiểm tra xem thư mục có tồn tại không
if (-Not (Test-Path $projectPath)) {
    Write-Host "Không tìm thấy thư mục dự án: $projectPath"
    exit
}

# 2️⃣ Chuyển vào thư mục dự án
Set-Location $projectPath
Write-Host "Đã chuyển vào thư mục dự án: $projectPath"

# 3️⃣ Xóa node_modules của frontend & backend
Get-ChildItem -Path . -Directory -Recurse -Filter "node_modules" | Remove-Item -Recurse -Force

# 4️⃣ Xóa tất cả file .log, .tmp, .bak
Get-ChildItem -Path . -Recurse -Include *.log, *.tmp, *.bak | Remove-Item -Force

# 5️⃣ Xóa folder build cũ của frontend
Remove-Item -Recurse -Force .\frontend\build -ErrorAction SilentlyContinue

Write-Host "Đã dọn dẹp xong!"

# 6️⃣ Tạo file zip backup dự án
$date = Get-Date -Format "yyyyMMdd_HHmmss"
$zipName = "CantonHackathon_backup_$date.zip"
Compress-Archive -Path * -DestinationPath $zipName -Force

Write-Host "Đã tạo file zip sẵn sàng nộp: $zipName"
