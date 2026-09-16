[CmdletBinding()]
param(
    [string]$TriggerDirectory,
    [string]$MainSource,
    [switch]$InitializeFromManifest
)

$ErrorActionPreference = "Stop"
$workspaceRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($TriggerDirectory)) {
    $TriggerDirectory = Join-Path $workspaceRoot "triggers"
}
if ([string]::IsNullOrWhiteSpace($MainSource)) {
    $MainSource = Join-Path $workspaceRoot "map_source\Main.vj"
}
$TriggerDirectory = [System.IO.Path]::GetFullPath($TriggerDirectory)
$MainSource = [System.IO.Path]::GetFullPath($MainSource)
$manifestPath = Join-Path $TriggerDirectory "trigger-manifest.json"
$settingsPath = Join-Path $TriggerDirectory "trigger-settings.json"

if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    throw "Trigger manifest not found: $manifestPath"
}
if (-not (Test-Path -LiteralPath $MainSource -PathType Leaf)) {
    throw "Main source not found: $MainSource"
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
$orderedSources = @($manifest.sources | Sort-Object { [int]$_.order })
$manifestEnabled = @{}
foreach ($source in $orderedSources) {
    if ([string]$source.wct_index -ne "map_header") {
        $manifestEnabled[[string]$source.path] = [bool]$source.enabled
    }
}

if ($InitializeFromManifest -or -not (Test-Path -LiteralPath $settingsPath -PathType Leaf)) {
    $triggerStates = [ordered]@{}
    $mainLines = [System.IO.File]::ReadAllLines($MainSource)
    foreach ($line in $mainLines) {
        if ($line -match '^\s*//!\s*import\s+"\.\.\\triggers\\([^"]+)"') {
            $path = $Matches[1].Replace("\", "/")
            $existingSource = Join-Path $TriggerDirectory $path
            if ($path -ine "Map_Header.j" -and
                    (Test-Path -LiteralPath $existingSource -PathType Leaf) -and
                    -not $triggerStates.Contains($path)) {
                $triggerStates[$path] = if ($manifestEnabled.ContainsKey($path)) {
                    [bool]$manifestEnabled[$path]
                } else {
                    $true
                }
            }
        }
    }
    foreach ($source in $orderedSources) {
        if ([string]$source.wct_index -eq "map_header") {
            continue
        }
        $path = [string]$source.path
        $existingSource = Join-Path $TriggerDirectory $path
        if ((Test-Path -LiteralPath $existingSource -PathType Leaf) -and -not $triggerStates.Contains($path)) {
            $triggerStates[$path] = [bool]$source.enabled
        }
    }
    foreach ($file in (Get-ChildItem -LiteralPath $TriggerDirectory -Recurse -File -Filter "*.j" | Sort-Object FullName)) {
        $path = $file.FullName.Substring($TriggerDirectory.TrimEnd("\").Length + 1).Replace("\", "/")
        if ($path -ine "Map_Header.j" -and -not $triggerStates.Contains($path)) {
            $triggerStates[$path] = $true
        }
    }
    $initialSettings = [ordered]@{
        format = 1
        description = "true = enabled and imported; false = disabled and excluded from Main.vj"
        triggers = $triggerStates
    } | ConvertTo-Json -Depth 5
    [System.IO.File]::WriteAllText(
        $settingsPath,
        $initialSettings + [Environment]::NewLine,
        [System.Text.UTF8Encoding]::new($false)
    )
    Write-Host "Created trigger settings: $settingsPath" -ForegroundColor Green
}

$settings = Get-Content -LiteralPath $settingsPath -Raw -Encoding UTF8 | ConvertFrom-Json
if ($null -eq $settings.triggers) {
    throw "Invalid trigger settings (missing 'triggers'): $settingsPath"
}

$settingsChanged = $false
$sourceFiles = @(Get-ChildItem -LiteralPath $TriggerDirectory -Recurse -File -Filter "*.j" | Sort-Object FullName)
$relativeByFile = @{}
foreach ($file in $sourceFiles) {
    $relativeByFile[$file.FullName] = $file.FullName.Substring($TriggerDirectory.TrimEnd("\").Length + 1).Replace("\", "/")
}
foreach ($property in @($settings.triggers.PSObject.Properties)) {
    $oldPath = [string]$property.Name
    $oldSource = Join-Path $TriggerDirectory $oldPath
    if (Test-Path -LiteralPath $oldSource -PathType Leaf) {
        continue
    }
    $fileName = [System.IO.Path]::GetFileName($oldPath)
    $matches = @($sourceFiles | Where-Object { $_.Name -ieq $fileName })
    if ($matches.Count -eq 1) {
        $newPath = [string]$relativeByFile[$matches[0].FullName]
        if ($null -eq $settings.triggers.PSObject.Properties[$newPath]) {
            $settings.triggers | Add-Member -MemberType NoteProperty -Name $newPath -Value ([bool]$property.Value)
            $settings.triggers.PSObject.Properties.Remove($oldPath)
            $settingsChanged = $true
            Write-Host "Moved trigger setting: $oldPath -> $newPath" -ForegroundColor Cyan
        }
    }
}
foreach ($file in $sourceFiles) {
    $path = [string]$relativeByFile[$file.FullName]
    if ($path -ieq "Map_Header.j") {
        continue
    }
    if ($null -eq $settings.triggers.PSObject.Properties[$path]) {
        $settings.triggers | Add-Member -MemberType NoteProperty -Name $path -Value $true
        $settingsChanged = $true
        Write-Host "New trigger defaults to enabled: $path" -ForegroundColor Green
    }
}
if ($settingsChanged) {
    $updatedSettings = $settings | ConvertTo-Json -Depth 5
    [System.IO.File]::WriteAllText(
        $settingsPath,
        $updatedSettings + [Environment]::NewLine,
        [System.Text.UTF8Encoding]::new($false)
    )
}

$importLines = New-Object System.Collections.Generic.List[string]
$enabledCount = 0
$disabledCount = 0
$mapHeader = Join-Path $TriggerDirectory "Map_Header.j"
if (Test-Path -LiteralPath $mapHeader -PathType Leaf) {
    $importLines.Add('//! import "..\triggers\Map_Header.j"')
}
foreach ($property in $settings.triggers.PSObject.Properties) {
    $path = [string]$property.Name
    if ($property.Value -isnot [bool]) {
        throw "Trigger setting must be true or false: $path"
    }
    $sourcePath = [System.IO.Path]::GetFullPath((Join-Path $TriggerDirectory $path))
    $triggerPrefix = $TriggerDirectory.TrimEnd("\") + "\"
    if (-not $sourcePath.StartsWith($triggerPrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Trigger path escapes the trigger directory: $path"
    }
    if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
        throw "Configured trigger source not found: $sourcePath"
    }
    $enabled = [bool]$property.Value
    if ($enabled) { $enabledCount++ } else { $disabledCount++ }
    if ($enabled) {
        $relative = $path.Replace("/", "\")
        $importLines.Add("//! import `"..\triggers\$relative`"")
    }
}

$beginMarker = "// BEGIN AUTO TRIGGER IMPORTS"
$endMarker = "// END AUTO TRIGGER IMPORTS"
$lines = [System.IO.File]::ReadAllLines($MainSource)
$beginIndex = [Array]::IndexOf($lines, $beginMarker)
$endIndex = [Array]::IndexOf($lines, $endMarker)

if (($beginIndex -ge 0) -xor ($endIndex -ge 0)) {
    throw "Main.vj contains an incomplete automatic trigger import block."
}
if ($beginIndex -ge 0 -and $endIndex -le $beginIndex) {
    throw "Main.vj automatic trigger import markers are in the wrong order."
}

if ($beginIndex -lt 0) {
    $importIndexes = @()
    for ($index = 0; $index -lt $lines.Length; $index++) {
        if ($lines[$index] -match '^\s*//!\s*import\s+"\.\.\\triggers\\') {
            $importIndexes += $index
        }
    }
    if ($importIndexes.Count -eq 0) {
        throw "No existing trigger imports found in Main.vj."
    }
    $beginIndex = $importIndexes[0]
    $endIndex = $importIndexes[-1]
}

$updated = New-Object System.Collections.Generic.List[string]
if ($beginIndex -gt 0) {
    $updated.AddRange([string[]]$lines[0..($beginIndex - 1)])
}
$updated.Add($beginMarker)
$updated.AddRange([string[]]$importLines)
$updated.Add($endMarker)
if ($endIndex + 1 -lt $lines.Length) {
    $updated.AddRange([string[]]$lines[($endIndex + 1)..($lines.Length - 1)])
}

$newText = [string]::Join("`r`n", $updated) + "`r`n"
$oldText = [System.IO.File]::ReadAllText($MainSource)
if ($newText -ne $oldText) {
    [System.IO.File]::WriteAllText($MainSource, $newText, [System.Text.UTF8Encoding]::new($false))
    Write-Host "Updated Main.vj trigger imports." -ForegroundColor Green
} else {
    Write-Host "Main.vj trigger imports already match settings." -ForegroundColor DarkGray
}
Write-Host "Enabled triggers:  $enabledCount" -ForegroundColor Green
Write-Host "Disabled triggers: $disabledCount" -ForegroundColor Yellow
