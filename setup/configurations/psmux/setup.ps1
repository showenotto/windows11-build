$ErrorActionPreference = "Stop"

$user = "Showen"
$psmuxBackupFile = "C:\Users\$user\windows11-build\setup\configurations\psmux\psmux.conf"  # Your backup file
$psmuxTargetDir = "C:\Users\$user\"

$pshBackupFile = "C:\Users\$user\windows11-build\setup\configurations\psmux\Microsoft.PowerShell_profile.ps1.config"
$pshTargetDir = "C:\Users\Showen\Documents\WindowsPowerShell\"

Write-Host "Restoring PSMUX configuration..." -ForegroundColor Cyan

if (-not (Test-Path $pshTargetDir))
{ New-Item -Path $pshTargetDir -ItemType Directory | Out-Null
}

Copy-Item -Path $psmuxBackupFile -Destination "$psmuxTargetDir\.psmux.conf" -Recurse -Force
Copy-Item -Path $pshBackupFile -Destination "$pshTargetDir\Microsoft.PowerShell_profile.ps1" -Recurse -Force

Write-Host "`nDone!" -ForegroundColor Green
