$ErrorActionPreference = "Stop"

$setupRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$payloadZip = Join-Path $setupRoot "payload.zip"
$workDir = Join-Path $env:TEMP ("UniFetchSetup_" + [Guid]::NewGuid().ToString("N"))

try {
    New-Item -ItemType Directory -Force -Path $workDir | Out-Null
    Expand-Archive -LiteralPath $payloadZip -DestinationPath $workDir -Force
    & (Join-Path $workDir "Install-UniFetch.ps1")
    if ($LASTEXITCODE -ne $null -and $LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
} finally {
    Remove-Item -LiteralPath $workDir -Recurse -Force -ErrorAction SilentlyContinue
}
