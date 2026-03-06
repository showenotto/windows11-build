$ErrorActionPreference = "Stop"

$user = "Showen"
$sourceZip = "C:\Users\$user\windows11-build\setup\applications\zed\zed.zip"  # Your backup file
$targetDir = "C:\Users\$user\AppData\Roaming\Zed\"
$tempExtract = Join-Path "C:\Users\$user\AppData\Local\Temp" "zed"


Write-Host "Restoring Zed configuration..." -ForegroundColor Cyan

if (-not (Test-Path $sourceZip)) {
    Write-Error "Backup zip not found: $sourceZip"
    exit 1
}

Write-Host "`nStep 2: Extracting zip to temp folder..." -ForegroundColor Yellow
if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue }
Expand-Archive -Path $sourceZip -DestinationPath $tempExtract -Force

Write-Host "`nStep 3: Overwriting Zed config..." -ForegroundColor Yellow
Copy-Item -Path "$tempExtract\*" -Destination $targetDir -Recurse -Force

Write-Host "`nStep 4: Cleaning up temp files..." -ForegroundColor Yellow
Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "`nDone!" -ForegroundColor Green
