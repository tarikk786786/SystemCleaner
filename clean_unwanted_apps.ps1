<#
.SYNOPSIS
    SystemCleaner — Automated uninstaller and debloating engine for Windows.
.DESCRIPTION
    Scans, audits, and removes unwanted third-party scrapers, crack tools,
    obsolete Apple/iOS runtimes, adware, and pre-installed Windows UWP bloatware.
.PARAMETER AuditOnly
    Runs in dry-run mode, printing detected software without making modifications.
.PARAMETER Execute
    Executes full removal of detected target packages.
.PARAMETER SkipUWP
    Skips removal of Windows Store / UWP packages.
.PARAMETER SkipApple
    Skips removal of Apple iOS ecosystem packages.
#>

[CmdletBinding()]
param(
    [switch]$AuditOnly,
    [switch]$Execute,
    [switch]$SkipUWP,
    [switch]$SkipApple
)

$ErrorActionPreference = "Continue"

# Configure Logging
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$logDir = Join-Path $scriptDir "logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}
$logFile = Join-Path $logDir "cleanup_report.log"

function Log-Message {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $line = "[$timestamp] [$Level] $Message"
    Add-Content -Path $logFile -Value $line -Encoding utf8
    
    switch ($Level) {
        "SUCCESS" { Write-Host " [OK] $Message" -ForegroundColor Green }
        "WARN"    { Write-Host " [!]  $Message" -ForegroundColor Yellow }
        "ERROR"   { Write-Host " [X]  $Message" -ForegroundColor Red }
        "INFO"    { Write-Host " [+]  $Message" -ForegroundColor Cyan }
        default   { Write-Host "      $Message" -ForegroundColor Gray }
    }
}

Clear-Host
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "     SystemCleaner - Automated Software Removal Suite           " -ForegroundColor White
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Log-Message "Running as Administrator: $isAdmin" "INFO"

if (-not $isAdmin -and $Execute) {
    Log-Message "Administrative privileges are required for system-wide software removal." "WARN"
    Log-Message "Please right-click RunAsAdmin.bat and select Run as Administrator." "WARN"
}

# Default to Audit mode if neither is specified
if (-not $AuditOnly -and -not $Execute) {
    $AuditOnly = $true
    Log-Message "No mode specified. Running in Audit Only mode (Dry Run)." "INFO"
}

# Target Catalogs
$msiTargets = @(
    @{ Name = "Google Maps Blaster"; Guid = "{BB4EA525-948F-43D4-B1D7-979C94506B46}"; Category = "Scraper / Crack Tool" },
    @{ Name = "SMS Blaster"; Guid = "{BB3810C9-1239-4278-B61F-78676AE1853A}"; Category = "Scraper / Crack Tool" },
    @{ Name = "TotalExtractor"; Guid = "{E484B35A-44E3-4342-B4DA-DAF3A1E23E6B}"; Category = "Scraper / Crack Tool" },
    @{ Name = "WhatBotPlus"; Guid = "{98F41A27-7D8A-4879-9F56-AFA33EA4C045}"; Category = "Scraper / Crack Tool" },
    @{ Name = "LetsExtract"; Guid = "{BACA254D-3F01-4334-96C9-23B3BD7AE877}"; Category = "Scraper / Crack Tool" },
    @{ Name = "NetSpeedMonitor 2.5.4.0 x64"; Guid = "{88F41EE2-949B-4B52-933D-C7F8F67BC1D2}"; Category = "Obsolete Utility" }
)

$appleTargets = @(
    @{ Name = "iCloud"; Guid = "{8808B208-87D1-4725-8192-76D257E9DEAE}"; Order = 1 },
    @{ Name = "Apple Software Update"; Guid = "{A3985C05-7386-411F-A4BF-32A73F37EB44}"; Order = 2 },
    @{ Name = "Bonjour"; Guid = "{6E3610B2-430D-4EB0-81E3-2B57E8B9DE8D}"; Order = 3 },
    @{ Name = "Apple Application Support (32-bit)"; Guid = "{CCA8C50D-785B-4896-8675-FFE0C4ECCBC3}"; Order = 4 },
    @{ Name = "Apple Application Support (64-bit)"; Guid = "{75BEF7E8-4370-4D42-94F3-B5AA77057965}"; Order = 5 }
)

$exeTargets = @(
    @{ Name = "ZCode"; Path = "C:\Program Files\ZCode\Uninstall ZCode.exe"; Args = @("/allusers", "/S"); Category = "Scraper / Crack Tool" },
    @{ Name = "Grok Bot"; Path = "C:\Program Files\Grok Bot\Uninstall Grok Bot.exe"; Args = @("/allusers", "/S"); Category = "Scraper / Crack Tool" },
    @{ Name = "Windows 11 Installation Assistant"; Path = "C:\Program Files (x86)\WindowsInstallationAssistant\Windows10UpgraderApp.exe"; Args = @("/SunValley", "/ForceUninstall"); Category = "Stale Installer" },
    @{ Name = "WebAdvisor by McAfee"; Path = "C:\Program Files\McAfee\WebAdvisor\Uninstaller.exe"; Args = @("/s"); Category = "Adware / Bundleware" }
)

$uwpTargets = @(
    "*AmazonAlexa*",
    "*BingNews*",
    "*BingWeather*",
    "*GamingApp*",
    "*XboxIdentityProvider*",
    "*XboxSpeechToTextOverlay*",
    "*MicrosoftFamily*",
    "*UnigramPreview*",
    "*Microsoft.People*"
)

Write-Host ""
Write-Host "--- Phase 1: Software Audit ---" -ForegroundColor Yellow

$detectedCount = 0

# Check MSI
$installedMSIs = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue

foreach ($target in $msiTargets) {
    $match = $installedMSIs | Where-Object { $_.PSChildName -eq $target.Guid -or $_.DisplayName -eq $target.Name }
    if ($match) {
        $detectedCount++
        Log-Message "Detected: $($target.Name) [$($target.Category)]" "INFO"
    }
}

# Check Apple
if (-not $SkipApple) {
    foreach ($target in $appleTargets) {
        $match = $installedMSIs | Where-Object { $_.PSChildName -eq $target.Guid -or $_.DisplayName -eq $target.Name }
        if ($match) {
            $detectedCount++
            Log-Message "Detected: $($target.Name) [Apple/iOS Ecosystem]" "INFO"
        }
    }
}

# Check Exe
foreach ($target in $exeTargets) {
    if (Test-Path $target.Path) {
        $detectedCount++
        Log-Message "Detected: $($target.Name) [$($target.Category)] at $($target.Path)" "INFO"
    }
}

# Check UWP
if (-not $SkipUWP) {
    foreach ($pattern in $uwpTargets) {
        $apps = Get-AppxPackage -Name $pattern -ErrorAction SilentlyContinue
        if ($apps) {
            foreach ($app in $apps) {
                $detectedCount++
                Log-Message "Detected UWP App: $($app.Name)" "INFO"
            }
        }
    }
}

Log-Message "Audit Complete. Total items requiring remediation: $detectedCount" "INFO"

if ($AuditOnly) {
    Write-Host ""
    Write-Host "Audit complete. To remove these items, run with -Execute or launch RunAsAdmin.bat." -ForegroundColor Yellow
    exit 0
}

# Execution Phase
Write-Host ""
Write-Host "--- Phase 2: Terminating Blocking Processes ---" -ForegroundColor Yellow
$blockingProcs = @(
    "iCloudServices", "mDNSResponder", "AppleMobileDeviceProcess",
    "WhatBotPlus", "SMS Blaster", "Google Maps Blaster", "TotalExtractor", "LetsExtract",
    "ZCode", "Grok Bot", "BrowserHost"
)

foreach ($proc in $blockingProcs) {
    $running = Get-Process -Name $proc -ErrorAction SilentlyContinue
    if ($running) {
        Log-Message "Terminating background process: $proc" "INFO"
        Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
    }
}

# Execution Phase 3: UWP Bloatware Removal
if (-not $SkipUWP) {
    Write-Host ""
    Write-Host "--- Phase 3: Removing Windows UWP Bloatware ---" -ForegroundColor Yellow
    foreach ($pattern in $uwpTargets) {
        $apps = Get-AppxPackage -Name $pattern -ErrorAction SilentlyContinue
        if ($apps) {
            foreach ($app in $apps) {
                Log-Message "Removing UWP package: $($app.Name)..." "INFO"
                Remove-AppxPackage -Package $app.PackageFullName -ErrorAction SilentlyContinue
                Log-Message "Removed UWP package: $($app.Name)" "SUCCESS"
            }
        }
    }
}

# Execution Phase 4: Scrapers & Crackware MSI Removal
Write-Host ""
Write-Host "--- Phase 4: Removing Scraper and Crack Tools ---" -ForegroundColor Yellow
foreach ($target in $msiTargets) {
    $match = $installedMSIs | Where-Object { $_.PSChildName -eq $target.Guid -or $_.DisplayName -eq $target.Name }
    if ($match) {
        Log-Message "Uninstalling $($target.Name)..." "INFO"
        $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList "/x", "$($target.Guid)", "/qn", "/norestart" -Wait -PassThru
        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) {
            Log-Message "Successfully uninstalled $($target.Name) (ExitCode: $($proc.ExitCode))" "SUCCESS"
        } else {
            Log-Message "Failed to uninstall $($target.Name). ExitCode: $($proc.ExitCode)" "ERROR"
        }
    }
}

# Execution Phase 5: Executable Uninstaller Invocation
Write-Host ""
Write-Host "--- Phase 5: Removing Custom Executable Packages ---" -ForegroundColor Yellow
foreach ($target in $exeTargets) {
    if (Test-Path $target.Path) {
        Log-Message "Executing uninstaller for $($target.Name)..." "INFO"
        $proc = Start-Process -FilePath $target.Path -ArgumentList $target.Args -Wait -PassThru
        if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) {
            Log-Message "Successfully removed $($target.Name)" "SUCCESS"
        } else {
            Log-Message "Uninstaller finished with exit code: $($proc.ExitCode)" "WARN"
        }
    }
}

# Execution Phase 6: Ordered Apple/iOS Ecosystem Removal
if (-not $SkipApple) {
    Write-Host ""
    Write-Host "--- Phase 6: Removing Legacy Apple / iOS Suite ---" -ForegroundColor Yellow
    foreach ($target in ($appleTargets | Sort-Object Order)) {
        $match = $installedMSIs | Where-Object { $_.PSChildName -eq $target.Guid -or $_.DisplayName -eq $target.Name }
        if ($match) {
            Log-Message "Uninstalling Apple component: $($target.Name)..." "INFO"
            $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList "/x", "$($target.Guid)", "/qn", "/norestart" -Wait -PassThru
            if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) {
                Log-Message "Successfully uninstalled $($target.Name) (ExitCode: $($proc.ExitCode))" "SUCCESS"
            } else {
                Log-Message "Failed to uninstall $($target.Name). ExitCode: $($proc.ExitCode)" "ERROR"
            }
        }
    }
}

# Execution Phase 7: Orphaned Shortcuts and Residue
Write-Host ""
Write-Host "--- Phase 7: Cleaning Leftover Shortcuts ---" -ForegroundColor Yellow
$shortcutPaths = @(
    "$env:Public\Desktop",
    "$env:USERPROFILE\Desktop",
    "$env:ProgramData\Microsoft\Windows\Start Menu\Programs",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
)

$targetPatterns = @("*CrackFather*", "*Google Maps Blaster*", "*SMS Blaster*", "*TotalExtractor*", "*WhatBot*", "*LetsExtract*", "*ZCode*", "*Grok Bot*")

foreach ($sDir in $shortcutPaths) {
    if (Test-Path $sDir) {
        foreach ($pat in $targetPatterns) {
            Get-ChildItem -Path $sDir -Filter $pat -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
                Log-Message "Removing orphaned shortcut: $($_.FullName)" "INFO"
                Remove-Item -Path $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
            }
        }
    }
}

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "     SystemCleaner - Remediation Completed Successfully        " -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "Review detailed execution logs at:" -ForegroundColor White
Write-Host "  $logFile" -ForegroundColor Cyan
Write-Host ""
