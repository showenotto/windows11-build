$ErrorActionPreference = "Stop"

$user = "Showen"
$sourceZip = "C:\Users\$user\windows11-build\setup\configurations\powertoys\powertoys-config.zip"  # Your backup file
$targetDir = "$env:LOCALAPPDATA\Microsoft\PowerToys"
$tempExtract = Join-Path "C:\Users\$user\AppData\Local\Temp" "powertoys-restore"

Write-Host "Restoring PowerToys configuration..." -ForegroundColor Cyan

if (-not (Test-Path $sourceZip)) {
    Write-Error "Backup zip not found: $sourceZip"
    exit 1
}

Write-Host "`nStep 1: Stopping PowerToys..." -ForegroundColor Yellow
Get-Process | Where-Object { $_.ProcessName -like "*PowerToys*" -or $_.ProcessName -like "*CmdPal*" } | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 10  # Give time for handles to release

# Check if anything is still running
$stillRunning = Get-Process | Where-Object { $_.ProcessName -like "*PowerToys*" }
if ($stillRunning) {
    Write-Warning "Some processes may still be running: $($stillRunning.ProcessName -join ', ')"
    $manualConfirm = Read-Host "Continue anyway? (YES/no)"
    if ($manualConfirm -ne "YES") { exit 0 }
}

Write-Host "`nStep 2: Extracting zip to temp folder..." -ForegroundColor Yellow
if (Test-Path $tempExtract) { Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue }
Expand-Archive -Path $sourceZip -DestinationPath $tempExtract -Force

Write-Host "`nStep 3: Overwriting PowerToys config..." -ForegroundColor Yellow
Copy-Item -Path "$tempExtract\*" -Destination $targetDir -Recurse -Force

Write-Host "`nStep 4: Cleaning up temp files..." -ForegroundColor Yellow
Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "`nStep 5: Restarting PowerToys..." -ForegroundColor Yellow
Start-Process "$env:LOCALAPPDATA\PowerToys\PowerToys.exe"

Write-Host "`nDone!" -ForegroundColor Green
