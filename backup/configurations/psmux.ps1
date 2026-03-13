$ErrorActionPreference = "Stop"

$user = "Showen"
$psmuxBackupFile = "C:\Users\$user\.psmux.conf"
$psmuxTargetPath = "C:\Users\$user\windows11-build\setup\configurations\psmux\psmux.conf"

$pshBackupFile = "C:\Users\Showen\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$pshTargetPath = "C:\Users\$user\windows11-build\setup\configurations\psmux\"

Write-Host "Backing up PSMUX configuration..." -ForegroundColor Cyan

Copy-Item -Path $psmuxBackupFile -Destination $psmuxTargetPath -Recurse -Force
Copy-Item -Path $pshBackupFile -Destination $pshTargetPath -Recurse -Force

Write-Host "`nDone!" -ForegroundColor Green
