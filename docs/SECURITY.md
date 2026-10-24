# Security Guidelines — SystemCleaner

## 1. Privilege Elevation & UAC
- SystemCleaner executes destructive uninstall actions only when invoked with standard Windows Administrator privileges.
- Elevation is explicitly triggered via Windows User Account Control (UAC).
- The script never bypasses UAC or employs unsafe privilege-escalation exploits.

## 2. Whitelisting & Preservation Safeguards
The following core development tools and runtime frameworks are **strictly protected** and will never be modified or removed by SystemCleaner:
- `Antigravity`, `Antigravity IDE`
- `Visual Studio Code`, `Cursor`, `Devin`, `Replit`, `OpenCode`
- `Git`, `GitHub Desktop`, `Docker Desktop`
- `Python`, `Node.js`, `Go`, `Rustup`, `Bun`
- `Microsoft .NET SDK`, `Visual C++ Redistributable`, `Visual Studio Build Tools`, `Windows SDK`
- `Google Chrome`, `Mozilla Firefox`, `Microsoft Edge`

## 3. Secret Management
- SystemCleaner does not collect, read, or transmit user credentials or telemetry.
- All operations are completely offline and local to the workstation.
