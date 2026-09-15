param(
    [Parameter(Mandatory = $true)]
    [string]$War3MapJ,

    [Parameter(Mandatory = $true)]
    [string]$CompileInput,

    [Parameter(Mandatory = $true)]
    [string]$Output
)

$ErrorActionPreference = "Stop"
$utf8 = New-Object System.Text.UTF8Encoding($false)
$lines = [System.IO.File]::ReadAllLines($War3MapJ, $utf8)

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
$firstTrigger = Find-Line '^// Trigger:' $mapScriptStart
$initCustom = Find-Line '^function InitCustomTriggers takes nothing returns nothing\s*$' $firstTrigger
$configStart = Find-Line '^function config takes nothing returns nothing\s*$' $initCustom
$configEnd = Find-EndFunction $configStart

$generatedGlobals = @($lines[0..($globalEnd - 1)] | Where-Object {
    $_ -match '^\s*[A-Za-z_][A-Za-z0-9_]*\s+(?:array\s+)?gg_[A-Za-z0-9_]+(?:\s*=.*)?\s*$'
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

if ($imports.Count -eq 0) {
    throw "No trigger imports found in $CompileInput"
}

$outputLines = New-Object System.Collections.Generic.List[string]
$outputLines.Add('// Main.vj - complete MAIN map source based on Anime_WOS2_0.31c6.w3x')
$outputLines.Add('// World Editor initialization comes from the original c6 war3map.j.')
$outputLines.Add('// Current external files under triggers are the source of truth.')
$outputLines.Add('')
$outputLines.AddRange([string[]]$imports)
$outputLines.Add('')
$outputLines.Add('globals')
$outputLines.Add('    // World Editor generated handles from c6')
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

Write-Host "MAIN MAPSCRIPT CREATED" -ForegroundColor Green
Write-Host "Imports: $($imports.Count)"
Write-Host "Generated map globals: $($generatedGlobals.Count)"
Write-Host $Output
