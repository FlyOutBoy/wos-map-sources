[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Test", "Main")]
    [string]$Target
)

$ErrorActionPreference = "Stop"

$configPath = Join-Path $PSScriptRoot "wos-launch.json"
if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
    Write-Error "WOS launcher config not found: $configPath"
    exit 1
}

try {
    $config = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Error "Cannot read WOS launcher config: $configPath`n$($_.Exception.Message)"
    exit 1
}

$mapsRoot = [Environment]::ExpandEnvironmentVariables([string]$config.mapsRoot)
$gameExe = [Environment]::ExpandEnvironmentVariables([string]$config.gameExe)
$selectedMap = if ($Target -eq "Test") { [string]$config.testMap } else { [string]$config.mainMap }

if ([string]::IsNullOrWhiteSpace($selectedMap)) {
    Write-Error "Map is not configured for target '$Target' in: $configPath"
    exit 1
}

$mapPath = [System.IO.Path]::GetFullPath((Join-Path $mapsRoot $selectedMap))

if (-not (Test-Path -LiteralPath $gameExe -PathType Leaf)) {
    Write-Error "Warcraft III executable not found: $gameExe"
    exit 1
}

if (-not (Test-Path -LiteralPath $mapPath -PathType Leaf)) {
    Write-Error "Warcraft III map not found: $mapPath"
    exit 1
}

Write-Host "Launching $Target map: $mapPath"
Start-Process -FilePath $gameExe -ArgumentList "-launch -loadfile `"$mapPath`""
