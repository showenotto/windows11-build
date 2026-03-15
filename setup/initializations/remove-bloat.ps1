Write-Host "Removing bloat..." -ForegroundColor Cyan
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage
