# Testing Strategy — SystemCleaner

## 1. Test Goals
- Ensure zero syntax errors in PowerShell scripts and batch wrappers.
- Verify that every targeted software GUID and package pattern matches verified Windows Registry entries.
- Ensure the protected developer tool list is comprehensive and never matches removal patterns.

## 2. Test Suites
- **Unit Tests (`tests/test_cleaner.py`)**:
  - Validates script file existence and syntax.
  - Validates GUID regex formatting.
  - Validates that safe tools (Git, Python, Antigravity, VS Code) are never included in target lists.
- **Pester Tests (`tests/cleaner.tests.ps1`)**:
  - Validates PowerShell cmdlet syntax using the PowerShell AST parser.

## 3. Test Command
```powershell
python -m pytest apps/SystemCleaner/tests/test_cleaner.py -v
```
