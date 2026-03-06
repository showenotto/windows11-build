#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Main orchestration script (Ansible-like playbook) for Setup and Backup.

.DESCRIPTION
    Runs ALL sections by default: initializations → configurations → applications

.PARAMETER Mode
    "Setup"   → applies settings / installs
    "Backup"  → exports / saves configurations
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Setup", "Backup")]
    [string]$Mode
)

$ErrorActionPreference = "Continue"
$Root = $PSScriptRoot

function Invoke-ScriptsInFolder {
    param(
        [Parameter(Mandatory)]
        [string]$FolderPath,
        [string]$SectionName
    )

    if (-not (Test-Path $FolderPath -PathType Container)) {
        Write-Host "Folder not found (skipped): $FolderPath" -ForegroundColor DarkGray
        return
    }

    $scripts = Get-ChildItem -Path $FolderPath -File -Recurse -Include "*.ps1" |
        Where-Object {
            $name = $_.Name
            $dir  = $_.DirectoryName
            -not (
                $name -match '^[\s#_\.-]*(disabled|skip|old|backup|test|example)' -or
                $name -like '#*' -or
                $name -like '.*' -or
                $dir -like '*\disabled*'
            )
        } |
        Sort-Object FullName

    if ($scripts.Count -eq 0) {
        Write-Host "No active scripts in $SectionName" -ForegroundColor DarkGray
        return
    }

    Write-Host ("-" * 70) -ForegroundColor DarkMagenta
    Write-Host "$SectionName" -ForegroundColor Magenta
    Write-Host ("-" * 70) -ForegroundColor DarkMagenta
    Write-Host ""

    foreach ($script in $scripts) {
        $relPath = Resolve-Path -Relative -Path $script.FullName
        Write-Host "-> $relPath" -ForegroundColor Cyan

        try {
            & $script.FullName
            Write-Host ""
        }
        catch {
            Write-Host "FAILED  $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

Clear-Host
Write-Host "Windows 11 Build" -ForegroundColor Cyan
Write-Host "Mode   : $Mode" -ForegroundColor White
Write-Host "Root   : $Root" -ForegroundColor DarkGray
Write-Host ""

switch ($Mode.ToLower()) {
    "setup" {
        Invoke-ScriptsInFolder "$Root\setup\initializations"   "INITIALIZATIONS"
        Invoke-ScriptsInFolder "$Root\setup\configurations"   "CONFIGURATIONS"
        Invoke-ScriptsInFolder "$Root\setup\applications"     "APPLICATIONS"
    }

    "backup" {
        Invoke-ScriptsInFolder "$Root\backup\configurations"  "BACKUP - CONFIGURATIONS"
        Invoke-ScriptsInFolder "$Root\backup\applications"    "BACKUP - APPLICATIONS"
    }
}

Write-Host "`n" -NoNewline
Write-Host ("-" * 40) -ForegroundColor Magenta
Write-Host "Finished $Mode operation" -ForegroundColor Green
Write-Host "Completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor DarkGray
