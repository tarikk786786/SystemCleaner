# API & Interface Contracts — SystemCleaner

## 1. PowerShell CLI Interface
`clean_unwanted_apps.ps1` exposes the following parameters:

```powershell
param(
    [switch]$AuditOnly,   # Runs scan and prints detected unwanted items without making changes
    [switch]$Execute,     # Executes full removal of all detected unwanted packages
    [switch]$SkipUWP,     # Skips UWP bloatware removal
    [switch]$SkipApple    # Skips Apple suite removal
)
```

## 2. Exit Codes
- `0`: Success (all targeted packages processed cleanly)
- `1`: General execution error
- `2`: Insufficient privileges (elevation required)
- `3010`: Success, system restart recommended by Windows Installer

## 3. Log Output Contract
All outputs are mirrored to `logs/cleanup_report.log` with formatted timestamps:
```
[YYYY-MM-DD HH:MM:SS] [LEVEL] Message
```
Where `LEVEL` is one of `INFO`, `SUCCESS`, `WARN`, `ERROR`.
