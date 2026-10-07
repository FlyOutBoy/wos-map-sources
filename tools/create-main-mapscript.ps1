param(
    [Parameter(Mandatory = $true)]
    [string]$War3MapJ,

    [Parameter(Mandatory = $true)]
    [string]$CompileInput,

    [Parameter(Mandatory = $true)]
    [string]$Output,
    [string]$Profile = "MAIN",
    [switch]$TestTemplate
)

$ErrorActionPreference = "Stop"
$utf8 = New-Object System.Text.UTF8Encoding($false)
$lines = [System.IO.File]::ReadAllLines($War3MapJ, $utf8)
$mapName = Split-Path -Leaf (Split-Path -Parent ([System.IO.Path]::GetFullPath($War3MapJ)))

function Find-Line([string]$Pattern, [int]$Start = 0) {
    for ($i = $Start; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match $Pattern) {
            return $i
        }
    }
    throw "Marker not found in ${War3MapJ}: $Pattern"
}

function Find-EndFunction([int]$Start) {
    for ($i = $Start + 1; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match '^endfunction\s*$') {
            return $i
        }
    }
    throw "endfunction not found after line $($Start + 1)"
}

$globalEnd = Find-Line '^endglobals\s*$'
$mapScriptStart = Find-Line '^//\s+Warcraft III map script\s*$' ($globalEnd + 1)
$initCustom = Find-Line '^function InitCustomTriggers takes nothing returns nothing\s*$' $mapScriptStart
# JassHelper moves custom implementations before the map-script section and
# removes editor Trigger markers. In that layout, the section ends at InitCustomTriggers.
$firstTrigger = $initCustom
for ($i = $mapScriptStart; $i -lt $initCustom; $i++) {
    if ($lines[$i] -match '^// Trigger:') { $firstTrigger = $i; break }
}
$configStart = Find-Line '^function config takes nothing returns nothing\s*$' $initCustom
$configEnd = Find-EndFunction $configStart

$externalGlobals = @{}
foreach ($line in [IO.File]::ReadAllLines($CompileInput, $utf8)) {
    if ($line -match '^\s*//!\s*import\s+"([^"]+)"\s*$') {
        $inputSource = $Matches[1]
        if (-not [IO.Path]::IsPathRooted($inputSource)) { $inputSource = Join-Path (Split-Path -Parent $CompileInput) $inputSource }
        if (Test-Path -LiteralPath $inputSource -PathType Leaf) {
            $inGlobals = $false
            foreach ($declaration in [IO.File]::ReadAllLines($inputSource, $utf8)) {
                if ($declaration -match '^\s*globals\s*$') { $inGlobals = $true; continue }
                if ($declaration -match '^\s*endglobals\s*$') { $inGlobals = $false; continue }
                if ($inGlobals -and $declaration -match '^\s*(?:(?:private|public|constant)\s+)*[A-Za-z_][A-Za-z0-9_]*\s+(?:array\s+)?(gg_[A-Za-z0-9_]+)(?:\s*=.*)?\s*$') {
                    $externalGlobals[$Matches[1]] = $true
                }
            }
        }
    }
}
$generatedGlobals = @($lines[0..($globalEnd - 1)] | Where-Object {
    $_ -match '^\s*[A-Za-z_][A-Za-z0-9_]*\s+(?:array\s+)?gg_[A-Za-z0-9_]+(?:\s*=.*)?\s*$'
} | Where-Object {
    $_ -match '\b(gg_[A-Za-z0-9_]+)\b' -and -not $externalGlobals.ContainsKey($Matches[1])
})

if ($generatedGlobals.Count -eq 0) {
    throw "No generated gg_ globals found in $War3MapJ"
}

$imports = New-Object System.Collections.Generic.List[string]
foreach ($line in [System.IO.File]::ReadAllLines($CompileInput, $utf8)) {
    if ($line -match '^\s*//!\s*import\s+"([^"]+\\triggers\\([^"]+))"\s*$') {
        $relative = $Matches[2]
        $imports.Add('//! import "..\triggers\' + $relative + '"')
    }
}

if ($imports.Count -eq 0 -and -not $TestTemplate) {
    throw "No trigger imports found in $CompileInput"
}

$outputLines = New-Object System.Collections.Generic.List[string]
if ($TestTemplate) { $outputLines.Add("// TestBase.vj - TEST source based on $mapName") }
else { $outputLines.Add("// Main.vj - complete MAIN map source based on $mapName") }
$outputLines.Add("// World Editor initialization comes from $mapName/war3map.j.")
$outputLines.Add('// Current external files under triggers are the source of truth.')
$outputLines.Add('')
if ($TestTemplate) {
    $outputLines.Add('// __TEST_SOURCE_IMPORTS__')
} else {
    $outputLines.AddRange([string[]]$imports)
}
$outputLines.Add('')
$outputLines.Add('globals')
$outputLines.Add("    // World Editor generated handles from $mapName")
$outputLines.AddRange([string[]]$generatedGlobals)
$outputLines.Add('endglobals')
$outputLines.Add('')

for ($i = $mapScriptStart; $i -lt $firstTrigger; $i++) {
    $outputLines.Add($lines[$i])
}

for ($i = $initCustom; $i -le $configEnd; $i++) {
    if ($lines[$i] -notmatch '^\s*call ExecuteFunc\("[^"]+"\)\s*$') {
        $outputLines.Add($lines[$i])
    }
}

$outputDirectory = Split-Path -Parent $Output
if (!(Test-Path -LiteralPath $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}
[System.IO.File]::WriteAllLines($Output, $outputLines, $utf8)

Write-Host "$Profile MAPSCRIPT CREATED" -ForegroundColor Green
Write-Host "Imports: $($imports.Count)"
Write-Host "Generated map globals: $($generatedGlobals.Count)"
Write-Host $Output
