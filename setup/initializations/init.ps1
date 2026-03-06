# Install essential CLI tools for network engineers & terminal productivity via winget

Write-Host "Installing essential tools..." -ForegroundColor Cyan
Write-Host ""

# ────────────────────────────────────────────────
# Array of Winget package IDs
# ────────────────────────────────────────────────

$tools = @(
    # Essentials
    "Microsoft.PowerToys"
    "Python.Python.3.14"
    "Git.Git"
    "marlocarlo.psmux"
    "Docker.DockerCLI"

    # Networking
    "Insecure.Nmap"                          # Network scanner / port scanner
    "PuTTY.PuTTY"                  # SSH/Telnet client + plink.exe
    "Microsoft.OpenSSH.Preview"             # Modern OpenSSH client

    # Misc
    "jqlang.jq"                          # jq - JSON processor (optional)
    #"BurntSushi.ripgrep.MSVC"            # ripgrep (rg) - fast grep
    "sharkdp.fd"                         # fd - fast find
    "sharkdp.bat"                        # bat - cat with syntax highlighting
    #"junegunn.fzf"                       # fzf - fuzzy finder
    # "helix-editor.helix"               # helix editor (uncomment if wanted)
    # "MikeFarah.yq"                     # yq - YAML processor (optional)
)

# ────────────────────────────────────────────────
# Install loop
# ────────────────────────────────────────────────

$installedCount = 0
$skippedCount   = 0
$total          = $tools.Count

foreach ($id in $tools) {
    Write-Host "-> $id" -ForegroundColor Cyan -NoNewline

    # Check if already installed (winget list returns exit code 0 if found)
    $check = winget list --id $id --exact --source winget 2>$null
    if ($LASTEXITCODE -eq 0 -and $check -match $id) {
        Write-Host "  [Already installed]" -ForegroundColor DarkGreen
        $skippedCount++
        continue
    }

    # Install
    Write-Host "  Installing..." -ForegroundColor Yellow -NoNewline
    $result = winget install --id $id --source winget --silent --accept-package-agreements --accept-source-agreements 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "  OK" -ForegroundColor Green
        $installedCount++
    } else {
        Write-Host "  FAILED" -ForegroundColor Red
        Write-Host "   (exit code: $LASTEXITCODE)" -ForegroundColor DarkRed
    }
}

Write-Host "`nDone!" -ForegroundColor Green
