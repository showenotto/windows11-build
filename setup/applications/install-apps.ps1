Write-Host "Installing applications..." -ForegroundColor Cyan
Write-Host ""

# ────────────────────────────────────────────────
# Array of Winget package IDs (GUI-focused / heavier apps)
# ────────────────────────────────────────────────

$guiApps = @(
    # Core Productivity & Development
    "ZedIndustries.Zed"            # Zed - lightweight but powerful code editor
    "Brave.Brave"
    "Discord.Discord"

    # Network Engineering & Diagnostics GUI Tools
    "WiresharkFoundation.Wireshark"         # Full Wireshark GUI + tshark CLI

    # Remote Access & Virtualization
    "Oracle.VirtualBox"                     # VirtualBox – VMs for testing network setups

    # Other Heavy/Useful GUI Apps
    "7zip.7zip"                             # 7-Zip – powerful archive manager GUI

)

# ────────────────────────────────────────────────
# Install loop with status & skip if already installed
# ────────────────────────────────────────────────

$installed = 0
$skipped   = 0
$total     = $guiApps.Count

foreach ($id in $guiApps) {
    Write-Host "-> $id" -ForegroundColor Cyan -NoNewline

    # Quick check if already installed
    $check = winget list --id $id --exact --source winget 2>$null
    if ($LASTEXITCODE -eq 0 -and $check -match $id) {
        Write-Host "  [Already installed]" -ForegroundColor DarkGreen
        $skipped++
        continue
    }

    Write-Host "  Installing..." -ForegroundColor Yellow -NoNewline

    # Install silently
    winget install --id $id --source winget --silent --accept-package-agreements --accept-source-agreements 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "  OK" -ForegroundColor Green
        $installed++
    } else {
        Write-Host "  FAILED (code: $LASTEXITCODE)" -ForegroundColor Red
    }
}

Write-Host "`nDone!" -ForegroundColor Green
