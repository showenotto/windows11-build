$moduleName = "VirtualDesktop"

if (-not (Get-Module -ListAvailable -Name $moduleName)) {
    $originalProgress = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'

    try {
        Install-Module -Name $moduleName -Scope CurrentUser -Force -AllowClobber -SkipPublisherCheck -ErrorAction Stop | Out-Null
    }
    catch {
        Write-Error "Critical: Could not install $moduleName → $($_.Exception.Message)"
        exit 1
    }
    finally {
        $ProgressPreference = $originalProgress
    }
}

Import-Module $moduleName -DisableNameChecking -ErrorAction Stop -Verbose:$false

Write-Host "Creating virtual desktops..." -ForegroundColor Cyan

# ────────────────────────────────────────────────
# Goal: exactly these 4 desktops in this order
# 1. Home         (index 0)
# 2. Productivity (index 1)
# 3. Research     (index 2)
# 4. Communications (index 3)
# ────────────────────────────────────────────────

$desiredNames = @("Home", "Productivity", "Research", "Communications")
$desiredCount = $desiredNames.Count  # 4

$currentCount = Get-DesktopCount
# Remove extras (from the end — safer)
while ($currentCount -gt $desiredCount) {
    Write-Host "Removing extra desktop (#$currentCount)..." -ForegroundColor DarkYellow
    Remove-Desktop -All -Keep 1..$desiredCount   # keeps first $desiredCount (indices 0..3)
    Start-Sleep -Milliseconds 800
    $currentCount = Get-DesktopCount
}

# Create missing (appended to the right)
while ($currentCount -lt $desiredCount) {
    New-Desktop | Out-Null
    Start-Sleep -Milliseconds 600
    $currentCount = Get-DesktopCount
}

# Rename — now using 0-based indexing !!!
for ($i = 0; $i -lt $desiredCount; $i++) {
    $index = $i                   # ← 0,1,2,3
    $name  = $desiredNames[$i]
    $desktop = Get-Desktop -Index $index
    Set-DesktopName -Desktop $desktop -Name $name
    Start-Sleep -Milliseconds 400   # slightly longer delay helps reliability
}

# Switch to first desktop (Home → index 0)
Switch-Desktop 0

Write-Host "`nDone!" -ForegroundColor Green
