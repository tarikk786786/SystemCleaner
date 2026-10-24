@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"
title SystemCleaner — Elevated Software Remediation Suite

:: Check if already running as Administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :run_cleaner
) else (
    goto :elevate
)

:elevate
echo.
echo ============================================================================
echo   Requesting Administrator Privileges...
echo   Please click "Yes" on the Windows prompt.
echo ============================================================================
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$script = (Join-Path (Get-Location).Path 'clean_unwanted_apps.ps1'); Start-Process powershell.exe -ArgumentList \"-NoProfile -ExecutionPolicy Bypass -File `\"$script`\" -Execute\" -Verb RunAs"
exit /b

:run_cleaner
echo.
echo ============================================================================
echo   SystemCleaner — Starting Automated Cleanup with Administrator Privileges
echo ============================================================================
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0clean_unwanted_apps.ps1" -Execute

echo.
echo ============================================================================
echo   Cleanup routine finished. Press any key to exit this window.
echo ============================================================================
pause >nul
exit /b
