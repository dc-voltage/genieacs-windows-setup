@echo off
title Configure Windows Firewall for GenieACS
color 0B

echo ==============================================================================
echo              Configure Windows Defender Firewall for GenieACS
echo ==============================================================================
echo.
echo NOTE: This script must be executed with Administrator privileges!
echo.

:: Check for administrative rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Please right-click this script and select 'Run as administrator'.
    pause
    exit /b 1
)

echo Adding inbound rule for CWMP (Port 7547 TCP)...
netsh advfirewall firewall add rule name="GenieACS CWMP (7547)" dir=in action=allow protocol=TCP localport=7547

echo Adding inbound rule for Web UI (Port 3000 TCP)...
netsh advfirewall firewall add rule name="GenieACS Web UI (3000)" dir=in action=allow protocol=TCP localport=3000

echo Adding inbound rule for File Server (Port 7567 TCP)...
netsh advfirewall firewall add rule name="GenieACS File Server (7567)" dir=in action=allow protocol=TCP localport=7567

echo Adding inbound rule for NBI API (Port 7557 TCP)...
netsh advfirewall firewall add rule name="GenieACS NBI API (7557)" dir=in action=allow protocol=TCP localport=7557

echo.
echo [SUCCESS] All firewall rules have been successfully created!
echo ONTs and TR-069 CPE devices can now connect to your Windows host.
echo.
pause
