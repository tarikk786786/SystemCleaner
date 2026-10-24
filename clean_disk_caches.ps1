<#
.SYNOPSIS
    SystemCleaner — Disk Space and Developer Cache Optimizer
.DESCRIPTION
    Safely purges stale developer build caches (npm, pip, go), user temp files,
    Windows crash dumps, and obsolete logs to reclaim disk space.
#>

[CmdletBinding()]
param(
    [switch]$WhatIf
)

$ErrorActionPreference = "Continue"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "     SystemCleaner - Disk Space and Cache Optimizer             " -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

$reclaimedTotalBytes = 0

function Clean-DirectoryContents($dirPath, $label) {
    if (-not (Test-Path $dirPath)) {
        Write-Host " [-] $label directory does not exist: $dirPath" -ForegroundColor DarkGray
        return
    }

    Write-Host " [+] Cleaning $label ($dirPath)..." -ForegroundColor Cyan
    $files = Get-ChildItem -Path $dirPath -Recurse -File -Force -ErrorAction SilentlyContinue
    $totalSize = ($files | Measure-Object -Property Length -Sum).Sum

    if (-not $totalSize) {
        Write-Host "     Already clean (0 MB)." -ForegroundColor DarkGray
        return
    }

    $sizeMB = [math]::Round($totalSize / 1MB, 2)
    Write-Host "     Found $sizeMB MB across $($files.Count) files." -ForegroundColor Yellow

    if ($WhatIf) {
        Write-Host "     [WhatIf] Would purge $sizeMB MB." -ForegroundColor DarkYellow
        return
    }

    $deletedBytes = 0
    Get-ChildItem -Path $dirPath -Force -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            $itemSize = (Get-ChildItem -Path $_.FullName -Recurse -File -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction Stop
            $deletedBytes += $itemSize
        } catch {
            # File is locked by an active process, safely skip
        }
    }

    $deletedMB = [math]::Round($deletedBytes / 1MB, 2)
    Write-Host " [OK] Purged $deletedMB MB from $label." -ForegroundColor Green
    $script:reclaimedTotalBytes += $deletedBytes
}

# 1. npm Cache
Write-Host "`n--- Developer Package Caches ---" -ForegroundColor Yellow
$npmCmd = Get-Command npm -ErrorAction SilentlyContinue
if ($npmCmd) {
    Write-Host " [+] Running 'npm cache clean --force'..." -ForegroundColor Cyan
    if (-not $WhatIf) {
        & npm cache clean --force 2>&1 | Out-Null
        Write-Host " [OK] npm cache cleaned." -ForegroundColor Green
    }
} else {
    Clean-DirectoryContents "$env:LOCALAPPDATA\npm-cache" "npm Cache"
}

# 2. pip Cache
$pipCmd = Get-Command pip -ErrorAction SilentlyContinue
if ($pipCmd) {
    Write-Host " [+] Running 'pip cache purge'..." -ForegroundColor Cyan
    if (-not $WhatIf) {
        $pipOut = & pip cache purge 2>&1
        Write-Host " [OK] $pipOut" -ForegroundColor Green
    }
} else {
    Clean-DirectoryContents "$env:LOCALAPPDATA\pip\cache" "pip Cache"
}

# 3. Go Build Cache
$goCmd = Get-Command go -ErrorAction SilentlyContinue
if ($goCmd) {
    Write-Host " [+] Running 'go clean -cache'..." -ForegroundColor Cyan
    if (-not $WhatIf) {
        & go clean -cache 2>&1 | Out-Null
        Write-Host " [OK] Go compile build cache cleaned." -ForegroundColor Green
    }
}

# 4. User Temporary Files (Unlocked files only)
Write-Host "`n--- System & User Temporary Files ---" -ForegroundColor Yellow
Clean-DirectoryContents "$env:TEMP" "User Temp"

# 5. Windows Crash Dumps
Clean-DirectoryContents "$env:LOCALAPPDATA\CrashDumps" "Windows Crash Dumps"

# 6. Windows Error Reporting Queue
Clean-DirectoryContents "$env:LOCALAPPDATA\Microsoft\Windows\WER" "Windows Error Reporting"

Write-Host "`n=================================================================" -ForegroundColor Green
$totalReclaimedMB = [math]::Round($reclaimedTotalBytes / 1MB, 2)
Write-Host "     Deep Clean Completed! Reclaimed: ~$totalReclaimedMB MB     " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""
