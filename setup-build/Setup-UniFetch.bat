@echo off
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0InstallFromPayload.ps1"
if errorlevel 1 (
  echo.
  echo UniFetch setup did not finish successfully.
  pause
)
