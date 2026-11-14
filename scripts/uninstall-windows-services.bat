@echo off
title Uninstall GenieACS Windows Services
color 0C

echo ==============================================================================
echo                 Uninstall GenieACS Windows Background Services
echo ==============================================================================
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please right-click this script and select 'Run as administrator'.
    pause
    exit /b 1
)

echo Stopping and removing services...

nssm stop genieacs-cwmp 2>nul
nssm remove genieacs-cwmp confirm 2>nul

nssm stop genieacs-nbi 2>nul
nssm remove genieacs-nbi confirm 2>nul

nssm stop genieacs-fs 2>nul
nssm remove genieacs-fs confirm 2>nul

nssm stop genieacs-ui 2>nul
nssm remove genieacs-ui confirm 2>nul

echo.
echo [SUCCESS] All GenieACS services have been removed.
pause
