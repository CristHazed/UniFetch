$ErrorActionPreference = "Stop"

$sourceRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$installRoot = Join-Path $env:LOCALAPPDATA "UniFetch"
$desktopShortcut = Join-Path ([Environment]::GetFolderPath("Desktop")) "UniFetch.lnk"

Write-Host "Installing UniFetch Desktop..."

New-Item -ItemType Directory -Force -Path $installRoot | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $installRoot "app") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $installRoot "lib") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $installRoot "assets") | Out-Null

Copy-Item -LiteralPath (Join-Path $sourceRoot "app\UniFetch.jar") -Destination (Join-Path $installRoot "app\UniFetch.jar") -Force
Copy-Item -LiteralPath (Join-Path $sourceRoot "lib\mysql-connector-j-9.7.0.jar") -Destination (Join-Path $installRoot "lib\mysql-connector-j-9.7.0.jar") -Force
Copy-Item -LiteralPath (Join-Path $sourceRoot "assets\UniFetch.ico") -Destination (Join-Path $installRoot "assets\UniFetch.ico") -Force
Copy-Item -LiteralPath (Join-Path $sourceRoot "Launch-UniFetch.ps1") -Destination (Join-Path $installRoot "Launch-UniFetch.ps1") -Force
Copy-Item -LiteralPath (Join-Path $sourceRoot "Uninstall-UniFetch.bat") -Destination (Join-Path $installRoot "Uninstall-UniFetch.bat") -Force
Copy-Item -LiteralPath (Join-Path $sourceRoot "Uninstall-UniFetch.ps1") -Destination (Join-Path $installRoot "Uninstall-UniFetch.ps1") -Force

$java = Get-Command "java.exe" -ErrorAction SilentlyContinue
if (-not $java) {
    Write-Host ""
    Write-Host "Java was not found on this computer."
    Write-Host "Install Java 17 or newer before opening UniFetch."
}

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($desktopShortcut)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$installRoot\Launch-UniFetch.ps1`""
$shortcut.WorkingDirectory = $installRoot
$shortcut.IconLocation = Join-Path $installRoot "assets\UniFetch.ico"
$shortcut.Description = "Open UniFetch Desktop"
$shortcut.Save()

Write-Host ""
Write-Host "UniFetch was installed successfully."
Write-Host "A UniFetch shortcut was added to your Desktop."
Write-Host "Installed to: $installRoot"
