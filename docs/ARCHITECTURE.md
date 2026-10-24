# Technical Architecture — SystemCleaner

## 1. System Overview
SystemCleaner operates as a modular PowerShell automation engine with a native Windows batch wrapper for administrative privilege elevation:

```mermaid
graph TD
    User([User]) -->|Double-Click| Bat[RunAsAdmin.bat]
    Bat -->|UAC Elevation| PS[clean_unwanted_apps.ps1]
    
    subgraph Execution Pipeline
        PS --> Step1[Phase 1: Process Terminator]
        PS --> Step2[Phase 2: UWP Bloatware Removal]
        PS --> Step3[Phase 3: MSI Scrapers & Crackware]
        PS --> Step4[Phase 4: Executable Uninstalls]
        PS --> Step5[Phase 5: Ordered Apple/iOS Suite]
        PS --> Step6[Phase 6: Residual File & Shortcut Cleanup]
    end
    
    Step1 --> Log[(logs/cleanup_report.log)]
    Step2 --> Log
    Step3 --> Log
    Step4 --> Log
    Step5 --> Log
    Step6 --> Log
```

## 2. Component Structure
- `clean_unwanted_apps.ps1`: Primary PowerShell orchestration script.
- `RunAsAdmin.bat`: Bootstrap batch file requesting UAC `RunAs` elevation.
- `tests/test_cleaner.py`: Python syntax and schema verification test suite.
- `tests/cleaner.tests.ps1`: Pester test definitions.
- `logs/cleanup_report.log`: Execution audit trail with ISO timestamps.

## 3. Data Flow & Security Boundaries
- **Query Phase**: Queries `HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall` (both 64-bit and Wow6432Node), `HKCU`, and `Get-AppxPackage`.
- **Termination Phase**: Gracefully stops blocking daemons (`iCloudServices`, `mDNSResponder`, etc.) to prevent file-lock conflicts.
- **Uninstallation Phase**: Executes silent `msiexec.exe /x {GUID} /qn /norestart` and silent uninstaller flags.
- **Verification Phase**: Re-queries uninstall registry keys to confirm zero leftover registrations.
