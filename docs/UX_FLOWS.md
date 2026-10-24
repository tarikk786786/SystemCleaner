# User Experience Flows — SystemCleaner

## 1. Flow Overview
SystemCleaner provides two primary user journeys:
1. **Interactive Elevated One-Click Cleanup** (Via `RunAsAdmin.bat`)
2. **CLI Audit & Automation** (Via PowerShell `-AuditOnly` or `-Execute`)

## 2. Interactive Flow Details

```mermaid
sequenceDiagram
    autonumber
    actor User as User
    participant Bat as RunAsAdmin.bat
    participant UAC as Windows UAC
    participant Script as clean_unwanted_apps.ps1
    participant System as Windows System

    User->>Bat: Double-clicks RunAsAdmin.bat
    Bat->>UAC: Request administrative elevation
    UAC-->>User: "Do you want to allow this app to make changes?"
    User->>UAC: Clicks "Yes"
    UAC->>Script: Launches with Administrator token
    Script->>System: Stops blocking daemons (iCloud, Bonjour, etc.)
    Script->>System: Removes UWP store bloatware
    Script->>System: Uninstalls scrapers and crackware via MSI
    Script->>System: Uninstalls legacy Apple suite in order
    Script->>System: Cleans orphaned shortcuts
    Script-->>User: Displays green summary & prompt to press any key
```

## 3. Edge Cases Handled
- **Process Lock**: Automatically terminates daemons before calling MSI uninstaller.
- **Application Already Removed**: Gracefully skips without error.
- **Non-Elevated Invocation**: Warns user and directs them to run `RunAsAdmin.bat`.
