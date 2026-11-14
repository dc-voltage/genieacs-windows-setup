@echo off
title Stop GenieACS Services
color 0C

echo ==============================================================================
echo                      Stopping GenieACS Services
echo ==============================================================================
echo.

echo Terminating GenieACS CLI windows...
taskkill /F /FI "WINDOWTITLE eq GenieACS CWMP*" 2>nul
taskkill /F /FI "WINDOWTITLE eq GenieACS NBI*" 2>nul
taskkill /F /FI "WINDOWTITLE eq GenieACS FS*" 2>nul
taskkill /F /FI "WINDOWTITLE eq GenieACS UI*" 2>nul

echo All active GenieACS console processes have been stopped.
echo.
pause
