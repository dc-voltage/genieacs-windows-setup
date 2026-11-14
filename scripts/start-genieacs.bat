@echo off
title GenieACS All-in-One Launcher
color 0A

echo ==============================================================================
echo                      GenieACS Windows Launcher
echo ==============================================================================
echo.

:: Ensure directory structure exists
if not exist C:\genieacs\log (
    mkdir C:\genieacs\log
)

if not exist C:\genieacs\ext (
    mkdir C:\genieacs\ext
)

if not exist C:\genieacs\genieacs.env (
    echo [WARNING] Configuration file not found at C:\genieacs\genieacs.env!
    echo Please copy config\genieacs.env.example to C:\genieacs\genieacs.env first.
    echo.
    pause
    exit /b 1
)

echo [1/4] Starting CWMP Server (Port 7547)...
start "GenieACS CWMP [Port 7547]" cmd /k "genieacs-cwmp --env C:\genieacs\genieacs.env"

echo [2/4] Starting NBI Server (Port 7557)...
start "GenieACS NBI [Port 7557]" cmd /k "genieacs-nbi --env C:\genieacs\genieacs.env"

echo [3/4] Starting File Server (Port 7567)...
start "GenieACS FS [Port 7567]" cmd /k "genieacs-fs --env C:\genieacs\genieacs.env"

echo [4/4] Starting Web UI Dashboard (Port 3000)...
start "GenieACS UI [Port 3000]" cmd /k "genieacs-ui --env C:\genieacs\genieacs.env"

echo.
echo ==============================================================================
echo All GenieACS services have been launched!
echo.
echo   Web UI Dashboard:  http://localhost:3000
echo   Default Username:  admin
echo   Default Password:  admin
echo   CWMP URL for ONTs: http://YOUR_PC_IP:7547/
echo ==============================================================================
echo Keep the launched command prompt windows open while using GenieACS.
echo.
pause
