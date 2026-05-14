$ErrorActionPreference = "SilentlyContinue"

$installRoot = Join-Path $env:LOCALAPPDATA "UniFetch"
$desktopShortcut = Join-Path ([Environment]::GetFolderPath("Desktop")) "UniFetch.lnk"

Remove-Item -LiteralPath $desktopShortcut -Force
Remove-Item -LiteralPath $installRoot -Recurse -Force

Write-Host "UniFetch was removed from this computer."
