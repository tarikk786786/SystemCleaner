# SystemCleaner — Automated Windows Debloater & Software Removal Suite

> Fast, audited, and safe uninstaller for obsolete utilities, third-party scrapers, legacy Apple runtimes, Windows UWP bloatware, and developer disk caches.

---

## 🎯 What It Removes & Cleans

### 1. Software Removal Catalog
- **Scrapers, Crack Tools & Bots**:
  - `Google Maps Blaster` (CrackFather.Com)
  - `SMS Blaster` (CrackFather.Com)
  - `TotalExtractor` (CrackFather.Com)
  - `WhatBotPlus` (CrackFather.Com)
  - `LetsExtract` (Tech Rider)
  - `ZCode 3.3.3`
  - `Grok Bot 0.44.0`
- **Legacy Apple / iOS Ecosystem** (in verified safe dependency order):
  - `iCloud`
  - `Apple Software Update`
  - `Bonjour` (stops `mDNSResponder.exe`)
  - `Apple Application Support (32-bit)`
  - `Apple Application Support (64-bit)`
- **Adware & Stale System Assistants**:
  - `WebAdvisor by McAfee`
  - `NetSpeedMonitor 2.5.4.0` (outdated Windows 7 taskbar monitor)
  - `Windows 11 Installation Assistant`
- **Windows Store (UWP) Bloatware**:
  - `Amazon Alexa`, `Bing News`, `Bing Weather`, `Xbox Gaming App` & overlays, `Microsoft Family Safety`, `Unigram Preview`, `Microsoft People`

### 2. Disk Space & Cache Optimization
- **`npm` Cache**: Automatic `npm cache clean --force`
- **`pip` Cache**: Purges build wheels and downloaded tarballs (`pip cache purge`)
- **`Go` Build Cache**: Purges stale compilation objects (`go clean -cache`)
- **User Temp**: Deletes accumulated temp files (`$env:TEMP`)
- **Crash Dumps**: Purges `.dmp` files (`$env:LOCALAPPDATA\CrashDumps`)

---

## 🛡️ Protected Developer Environments (Never Touched)

SystemCleaner includes strict safeguards preserving:
- **IDEs & Agents**: Antigravity, Cursor, VS Code, Devin, Replit
- **Dev Runtimes**: Python 3.14, Node.js, Go, Rustup, Bun, .NET SDK, C++ Redistributables
- **Containers & Version Control**: Docker Desktop, Git, GitHub Desktop, Tailscale, WireGuard
- **Web Browsers**: Google Chrome, Mozilla Firefox, Microsoft Edge

---

## 🚀 How to Run

### Method 1: Desktop Shortcut (Recommended)
Double-click the **`Run System Cleaner (Admin)`** shortcut on your Windows Desktop.

### Method 2: Command Line Execution
```powershell
# 1. Run disk and developer cache deep cleaner
powershell.exe -ExecutionPolicy Bypass -File .\apps\SystemCleaner\clean_disk_caches.ps1

# 2. Run software removal audit (dry-run)
powershell.exe -ExecutionPolicy Bypass -File .\apps\SystemCleaner\clean_unwanted_apps.ps1 -AuditOnly

# 3. Execute full software uninstallation (Requires Administrator)
powershell.exe -ExecutionPolicy Bypass -File .\apps\SystemCleaner\clean_unwanted_apps.ps1 -Execute
```

---

## 🧪 Testing & Verification
```powershell
python -m pytest apps/SystemCleaner/tests/test_cleaner.py -v
```
