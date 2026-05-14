$ErrorActionPreference = "Stop"

$installRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$appJar = Join-Path $installRoot "app\UniFetch.jar"
$mysqlJar = Join-Path $installRoot "lib\mysql-connector-j-9.7.0.jar"
$classpath = "$appJar;$mysqlJar"

$javaw = Get-Command "javaw.exe" -ErrorAction SilentlyContinue
$java = Get-Command "java.exe" -ErrorAction SilentlyContinue

if (-not $javaw -and -not $java) {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show(
        "Java 17 or newer is required to open UniFetch. Please install Java, then open UniFetch again.",
        "UniFetch",
        "OK",
        "Warning"
    ) | Out-Null
    exit 1
}

$runner = if ($javaw) { $javaw.Source } else { $java.Source }
Start-Process -FilePath $runner -ArgumentList @("-cp", $classpath, "unifetch.UniFetch") -WorkingDirectory $installRoot
