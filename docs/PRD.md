# Product Requirements Document (PRD) — SystemCleaner

## 1. Problem Statement
Over time, Windows installations accumulate unwanted software:
- Unused third-party automation tools and crackware scrapers (e.g., CrackFather tools, bulk email/SMS blasters).
- Stale vendor suites and device runtimes that are no longer in use (such as legacy Apple iCloud, Bonjour, Apple Software Update, and Apple Application Support).
- Unwanted adware and bundled security utilities (e.g., McAfee WebAdvisor).
- Pre-installed Windows Store/UWP bloatware (Bing News, Bing Weather, Xbox apps, promotional packages).
- Outdated utilities and obsolete setup assistants (Windows 11 Installation Assistant, old 32-bit taskbar monitors).

Users lack a unified, safe, and transparent tool to audit, select, and cleanly remove these items without breaking developer tools or system integrity.

## 2. Target Personas
- **Developer / Power User**: Needs a lean, clutter-free Windows workstation without background telemetry, memory-hogging background daemons (like `iCloudServices.exe` and `mDNSResponder.exe`), and unneeded scrapers.
- **System Administrator**: Needs an automated, scriptable utility with silent uninstall capabilities and detailed logging.

## 3. Scope & Key Features
- **Comprehensive Software Audit**: Fast registry and Appx scanning of all 32-bit, 64-bit, user-level, and system-level applications.
- **Categorized Remediation**:
  1. *Scrapers & Crack Tools*: Google Maps Blaster, SMS Blaster, TotalExtractor, WhatBotPlus, LetsExtract, ZCode.
  2. *Legacy iOS / Apple Suite*: iCloud, Apple Software Update, Bonjour, Apple Application Support (32-bit and 64-bit).
  3. *Adware & Stale Utilities*: WebAdvisor by McAfee, NetSpeedMonitor, Windows 11 Installation Assistant, Grok Bot.
  4. *Windows UWP Bloatware*: Bing News, Bing Weather, Xbox Gaming App & overlays, Microsoft Family, Unigram Preview.
- **Dependency-Aware Deletion**: Uninstalls complex multi-component suites in the correct order (e.g. Apple uninstallation sequence).
- **Graceful Process Termination**: Shuts down active background locks before uninstallation starts.
- **Audit Mode**: Dry-run preview (`-AuditOnly`) allowing inspection before any changes.
- **Safe Guardrails**: Strictly excludes developer environments (Antigravity IDE, VS Code, Cursor, Git, Docker, Python, Node.js, Go, Rust, .NET, C++ Runtimes).

## 4. Definition of Done (DoD)
1. Complete inventory and removal scripts implemented and verified.
2. Safe execution via one-click administrator launcher (`RunAsAdmin.bat`).
3. Automated test suite passing with 0 errors.
4. All 10 Vibe Coding Blueprint files present in `docs/`.
