@echo off
title Install GenieACS as Windows Background Services
color 0E

echo ==============================================================================
echo             Install GenieACS as Windows Background Services (NSSM)
echo ==============================================================================
echo.
echo NOTE: Ensure nssm.exe is available in C:\Windows\System32 or in your PATH.
echo.

:: Check for administrative rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please right-click this script and select 'Run as administrator'.
    pause
    exit /b 1
)

:: Verify nssm exists
where nssm >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] nssm.exe was not found in PATH!
    echo Please download NSSM from https://nssm.cc/download and place nssm.exe inside C:\Windows\System32.
    pause
    exit /b 1
)

:: Locate global npm directory
for /f "tokens=*" %%i in ('npm root -g') do set NPM_DIR=%%i
set GENIEACS_BIN=%NPM_DIR%\genieacs\bin

if not exist "%GENIEACS_BIN%\genieacs-cwmp" (
    echo [ERROR] GenieACS binaries were not found at: %GENIEACS_BIN%
    echo Make sure you ran 'npm install -g genieacs' first.
    pause
    exit /b 1
)

echo Registering genieacs-cwmp service...
nssm install genieacs-cwmp "%GENIEACS_BIN%\genieacs-cwmp"
nssm set genieacs-cwmp AppParameters "--env C:\genieacs\genieacs.env"
nssm set genieacs-cwmp Start SERVICE_AUTO_START
nssm start genieacs-cwmp

echo Registering genieacs-nbi service...
nssm install genieacs-nbi "%GENIEACS_BIN%\genieacs-nbi"
nssm set genieacs-nbi AppParameters "--env C:\genieacs\genieacs.env"
nssm set genieacs-nbi Start SERVICE_AUTO_START
nssm start genieacs-nbi

echo Registering genieacs-fs service...
nssm install genieacs-fs "%GENIEACS_BIN%\genieacs-fs"
nssm set genieacs-fs AppParameters "--env C:\genieacs\genieacs.env"
nssm set genieacs-fs Start SERVICE_AUTO_START
nssm start genieacs-fs

echo Registering genieacs-ui service...
nssm install genieacs-ui "%GENIEACS_BIN%\genieacs-ui"
nssm set genieacs-ui AppParameters "--env C:\genieacs\genieacs.env"
nssm set genieacs-ui Start SERVICE_AUTO_START
nssm start genieacs-ui

echo.
echo [SUCCESS] All four GenieACS services installed and started as Windows Services!
echo They will now start automatically whenever Windows boots.
echo.
pause
