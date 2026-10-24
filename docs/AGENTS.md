# Operational Agent Directives — SystemCleaner

## 1. Scope of Operation
This document guides AI agents interacting with or maintaining the `SystemCleaner` utility.

## 2. Planning Protocol
1. Before modifying or adding targeted applications to the removal catalog:
   - Run a read-only registry query to verify the exact `DisplayName` and `UninstallString` or `ProductCode`.
   - Verify whether uninstallation requires administrative elevation or can run in user context.
2. Under no circumstance should AI agents delete root Windows system directories or core SDK dependencies.

## 3. Completion Criteria
- Automated pytest suite passes with 100% success.
- Log outputs verify successful uninstalls with exit code 0 or 3010 (restart required).
- All documentation files remain up to date.
