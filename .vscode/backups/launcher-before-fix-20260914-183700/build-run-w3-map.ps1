[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Test", "Main")]
    [string]$Target
)

$ErrorActionPreference = "Stop"
$workspaceRoot = Split-Path -Parent $PSScriptRoot
$configPath = Join-Path $PSScriptRoot "wos-build.json"

function Resolve-WorkspacePath {
    param([Parameter(Mandatory = $true)][string]$Path)

    $expanded = [Environment]::ExpandEnvironmentVariables($Path)
    if ([System.IO.Path]::IsPathRooted($expanded)) {
        return [System.IO.Path]::GetFullPath($expanded)
    }
    return [System.IO.Path]::GetFullPath((Join-Path $workspaceRoot $expanded))
}

function Require-File {
    param([Parameter(Mandatory = $true)][string]$Path, [Parameter(Mandatory = $true)][string]$Name)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "$Name not found: $Path"
    }
}

try {
    Require-File -Path $configPath -Name "Build configuration"
    $config = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8 | ConvertFrom-Json

    $profileName = if ($Target -eq "Test") { [string]$config.testProfile } else { [string]$config.mainProfile }
    if ([string]::IsNullOrWhiteSpace($profileName)) {
        throw "$Target profile is not configured in: $configPath"
    }

    $profileProperty = $config.profiles.PSObject.Properties[$profileName]
    if ($null -eq $profileProperty) {
        throw "Profile '$profileName' not found in: $configPath"
    }
    $profile = $profileProperty.Value

    $gameExe = Resolve-WorkspacePath ([string]$config.gameExe)
    $jassHelper = Resolve-WorkspacePath ([string]$config.jassHelper)
    $commonJ = Resolve-WorkspacePath ([string]$config.commonJ)
    $blizzardJ = Resolve-WorkspacePath ([string]$config.blizzardJ)
    $source = Resolve-WorkspacePath ([string]$profile.source)
    $originalMap = Resolve-WorkspacePath ([string]$profile.map)
    $buildDir = Resolve-WorkspacePath ([string]$config.buildDir)
    $outputName = [string]$profile.output

    if ([string]::IsNullOrWhiteSpace($outputName) -or [System.IO.Path]::GetFileName($outputName) -ne $outputName) {
        throw "Profile '$profileName' output must be a filename: $outputName"
    }

    $builtMap = [System.IO.Path]::GetFullPath((Join-Path $buildDir $outputName))
    if ($builtMap.Equals($originalMap, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Built map path must differ from the original map: $originalMap"
    }

    Write-Host "Selected profile: $profileName"
    Write-Host "Original map:     $originalMap"
    Write-Host "Source mapscript: $source"
    Write-Host "Built map:        $builtMap"

    Require-File -Path $gameExe -Name "Warcraft III executable"
    Require-File -Path $jassHelper -Name "JassHelper executable"
    Require-File -Path $commonJ -Name "common.j"
    Require-File -Path $blizzardJ -Name "Blizzard.j"
    Require-File -Path $source -Name "Profile mapscript"
    Require-File -Path $originalMap -Name "Original map"

    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
    Copy-Item -LiteralPath $originalMap -Destination $builtMap -Force

    $sourceDirectory = Split-Path -Parent $source
    $jassHelperExitCode = -1
    Push-Location $sourceDirectory
    try {
        & $jassHelper $commonJ $blizzardJ $source $builtMap
        $jassHelperExitCode = $LASTEXITCODE
    } finally {
        Pop-Location
    }

    if ($jassHelperExitCode -ne 0) {
        Write-Host "BUILD FAILED" -ForegroundColor Red
        Write-Host "JassHelper exit code: $jassHelperExitCode" -ForegroundColor Red
        exit $jassHelperExitCode
    }

    Write-Host "BUILD OK" -ForegroundColor Green
    Start-Process -FilePath $gameExe -ArgumentList "-launch -loadfile `"$builtMap`""
} catch {
    Write-Host "BUILD FAILED" -ForegroundColor Red
    Write-Error $_.Exception.Message
    exit 1
}
