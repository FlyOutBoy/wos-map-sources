[CmdletBinding()]
param(
    [ValidateSet('All','Code','Data')][string]$Mode = 'All',
    [switch]$ValidateOnly
)
$ErrorActionPreference = 'Stop'
$workspace = Split-Path -Parent $PSScriptRoot
$config = & (Join-Path $PSScriptRoot 'ensure-test-profile.ps1')
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
$temporary = Join-Path $workspace "_build/test-map-import/$stamp"
$archive = Join-Path $temporary 'archive'
$helper = [string]$config.jassHelper
if (-not [IO.Path]::IsPathRooted($helper)) { $helper = Join-Path $workspace $helper }
Write-Host "Reading saved TEST map: $($config.testMap) ($Mode)"
& (Join-Path $PSScriptRoot 'test-map-archive.ps1') -Mode Extract -Map ([string]$config.testMap) -Directory $archive -Library (Join-Path (Split-Path -Parent $helper) 'sfmpq.dll')
if ($LASTEXITCODE -ne 0) { throw 'Cannot read selected TEST map' }
$backup = Join-Path $workspace "backups/test-map-import/$($config.testHero)/$stamp"
if (-not $ValidateOnly) {
    New-Item -ItemType Directory -Path $backup -Force | Out-Null
    foreach ($key in @('testMapDirectory','json_directory','raw_json_directory')) {
        $path = [string]$config.$key
        if (Test-Path $path) { Copy-Item -LiteralPath $path -Destination (Join-Path $backup $key) -Recurse }
    }
}
if ($Mode -in @('All','Data')) {
    $json = Join-Path $temporary 'object-data'
    $raw = Join-Path $temporary '.object-data-raw'
    $objectConfig = Join-Path $temporary 'objects.json'
    $common = [string]$config.commonJ
    if (-not [IO.Path]::IsPathRooted($common)) { $common = Join-Path $workspace $common }
    @{ map_directory=$archive; json_directory=$json; raw_json_directory=$raw; common_j=$common } | ConvertTo-Json | Set-Content $objectConfig -Encoding UTF8
    & python (Join-Path $workspace 'tools/war3_object_workspace.py') --config $objectConfig export --force
    if ($LASTEXITCODE -ne 0) { throw 'TEST object export failed' }
}
if ($Mode -in @('All','Code')) {
    & (Join-Path $PSScriptRoot 'import-triggers-and-code-from-map.ps1') -Target Test -MapDirectory $archive -PreferMapSources -ValidateOnly:$ValidateOnly
    if ($LASTEXITCODE -ne 0) { throw 'TEST code import failed' }
}
if (-not $ValidateOnly) {
    if ($Mode -in @('All','Data')) {
        foreach ($pair in @(@($json,[string]$config.json_directory),@($raw,[string]$config.raw_json_directory))) {
            $destination = [IO.Path]::GetFullPath($pair[1])
            $workspacePrefix = [IO.Path]::GetFullPath($workspace).TrimEnd('\') + '\'
            if (-not $destination.StartsWith($workspacePrefix,[StringComparison]::OrdinalIgnoreCase)) { throw 'TEST object directory must be within this workspace' }
            if (Test-Path $destination) {
                $saved = Join-Path $backup ('replaced-' + [IO.Path]::GetFileName($destination))
                if (-not ([IO.Path]::GetFullPath($saved)).StartsWith($workspacePrefix,[StringComparison]::OrdinalIgnoreCase)) { throw 'Invalid backup directory' }
                Move-Item -LiteralPath $destination -Destination $saved
            }
            Move-Item -LiteralPath $pair[0] -Destination $destination
        }
    }
    foreach ($file in (Get-ChildItem -LiteralPath $archive -File)) {
        $isCode = $file.Extension -in @('.j','.wtg','.wct')
        if ($Mode -eq 'All' -or ($Mode -eq 'Code' -and $isCode) -or ($Mode -eq 'Data' -and -not $isCode)) {
            Copy-Item -LiteralPath $file.FullName -Destination ([string]$config.testMapDirectory) -Force
        }
    }
}
Write-Host "TEST $Mode import OK. Backup: $backup"
