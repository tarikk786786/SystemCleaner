# Code Conventions — SystemCleaner

## 1. Core Principles
- **Defensive Execution**: Always verify target paths, running processes, and exit codes.
- **Fail-Safe**: If an uninstaller fails, log the specific error code and continue to other packages rather than crashing mid-routine.
- **Idempotency**: Running the cleanup script multiple times must be harmless and result in a clean state.

## 2. PowerShell Standards
- Use explicit parameter declarations (`[CmdletBinding()]`).
- Always specify `-ErrorAction SilentlyContinue` or `-ErrorAction Stop` intentionally.
- Standard variable naming in `camelCase` or `PascalCase`.
- Use `Out-File -Encoding utf8` or `Add-Content` to prevent character corruption.
- Quote all paths and GUID parameters.

## 3. Python Standards
- PEP 8 compliant, type-annotated where applicable.
- Clean pytest fixtures.
