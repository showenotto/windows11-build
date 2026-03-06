$ErrorActionPreference = "Stop"

$user = "Showen"
$sourceDir = "$env:LOCALAPPDATA\Microsoft\PowerToys"
$destDir = "C:\Users\$user\windows11-build\setup\configurations\powertoys"                  # ← Change this to your preferred folder
$zipFile = Join-Path $destDir "powertoys-config.zip"
$tempDir = Join-Path "C:\Users\$user\AppData\Local\Temp" "PowerToys"

Write-Host "PowerToys Configuration Backup..." -ForegroundColor Cyan


# Create dest directory if missing
if (-not (Test-Path $destDir)) { New-Item -Path $destDir -ItemType Directory | Out-Null }

# Step 1: Copy to temporary folder (handles locked files better)
Write-Host "Step 1: Copying PowerToysconfiguration to temporary folder..." -ForegroundColor Yellow
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue }
Copy-Item -Path $sourceDir -Destination $tempDir -Recurse -Force -ErrorAction Continue

# Step 2: Create zip archive
Write-Host "Step 2: Creating zip backup..." -ForegroundColor Yellow
Compress-Archive -Path "$tempDir\*" -DestinationPath $zipFile -Force -CompressionLevel Optimal

# Step 3: Clean up temporary folder
Write-Host "Step 3: Cleaning up temporary files..." -ForegroundColor Yellow
Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "`nBackup complete!"  -ForegroundColor Green
