@echo off
setlocal
title WOS2 Report Decoder - ADMIN ONLY

if "%~1"=="" (
    echo Drag a Warcraft III WOS2_bot_match_*.txt file onto this BAT file.
    echo.
    echo This decoder is ADMIN ONLY. Never distribute this folder to players.
    pause
    exit /b 2
)

where node.exe >nul 2>nul
if errorlevel 1 (
    echo ERROR: Node.js is not installed or is not available in PATH.
    echo Download Node.js LTS, install it, and try again.
    pause
    exit /b 3
)

node.exe "%~dp0decode-report.js" "%~1"
set "decodeExit=%errorlevel%"
echo.
pause
exit /b %decodeExit%
