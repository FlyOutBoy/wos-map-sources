[CmdletBinding()]
param([string]$OutputDirectory, [string]$StageDirectory)
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Config = & (Join-Path $PSScriptRoot 'ensure-test-profile.ps1')
. (Join-Path $PSScriptRoot 'jass-source-resolver.ps1')
function Project-Path([string]$Path) {
    if ([IO.Path]::IsPathRooted($Path)) { return [IO.Path]::GetFullPath($Path) }
    return [IO.Path]::GetFullPath((Join-Path $Root $Path))
}
if (-not $OutputDirectory) { $OutputDirectory = Project-Path ([string]$Config.buildDir) }
$stage = Join-Path $OutputDirectory 'test-sources'
if ($StageDirectory) { $stage = Project-Path $StageDirectory }
& python (Join-Path $Root 'tools/test_map_sources.py') stage --output $stage --base ([string]$Config.base) | Out-Host
if ($LASTEXITCODE -ne 0) { throw 'TEST source staging failed' }
$Manifest = Get-Content (Join-Path ([string]$Config.base) 'test-source-manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$SourceInfo = @{}
$ProviderFiles = @{}
$VisitState = @{}
$ResolvedFiles = New-Object 'System.Collections.Generic.List[string]'
$ActiveFamily = Get-SourceFamily (Join-Path $stage '_source.j')
$shadowed = @{}
$mappedSources = @{}
foreach ($entry in $Manifest.sources) {
    if ($entry.origin.kind -eq 'shared' -and $entry.path -in $Manifest.enabledImports) {
        $shadowed[(Project-Path ('triggers/' + $entry.origin.path))] = $true
        $mappedSources[(Project-Path ('triggers/' + $entry.origin.path))] = Join-Path $stage $entry.path
    }
    if ($entry.origin.overrideOf) { $shadowed[(Project-Path ('triggers/' + $entry.origin.overrideOf))] = $true }
}
# A mapped disabled TEST source must not reappear from MAIN dependency discovery.
$settings = Get-Content (Join-Path ([string]$Config.base) 'trigger-settings.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$enabledImports = @($Manifest.enabledImports | Where-Object {
    $setting = $settings.triggers.PSObject.Properties[$_]
    if ($setting -and $setting.Value -isnot [bool]) { throw "Invalid TEST trigger setting: $_" }
    -not $setting -or $setting.Value
})
$candidates = @($enabledImports | ForEach-Object { Join-Path $stage $_ })
$candidates += @(Get-ChildItem (Join-Path $Root 'triggers') -Recurse -File -Filter '*.j' | Where-Object { -not $shadowed.ContainsKey($_.FullName) } | ForEach-Object { $_.FullName })
$hero = [string]$Config.testHero
if ([string]::IsNullOrWhiteSpace($hero) -or [IO.Path]::GetFileName($hero) -ne $hero) { throw 'Invalid testHero' }
$heroFiles = @()
foreach ($configuredDirectory in $Config.testHeroSourceDirs) {
    $directory = Project-Path ([string]$configuredDirectory)
    $single = Join-Path $directory "$hero.j"
    if (Test-Path $single -PathType Leaf) { $heroFiles += $single }
    $folder = Join-Path $directory $hero
    if (Test-Path $folder -PathType Container) { $heroFiles += @(Get-ChildItem $folder -Recurse -File -Filter '*.j' | ForEach-Object { $_.FullName }) }
    if ($heroFiles.Count -gt 0) { break }
}
$heroFiles = @($heroFiles | Sort-Object -Unique)
if ($heroFiles.Count -eq 0) { throw "TEST DEPENDENCY MISSING: hero source '$hero' (run CROCODILE source import)" }
# The first hero source directory wins, allowing a TEST-only hero override.
$mainHero = Join-Path $Root "triggers/Heroes/$hero.j"
$mainHeroFolder = Join-Path $Root "triggers/Heroes/$hero"
$candidates = @($candidates | Where-Object {
    $_ -in $heroFiles -or ($_ -ine $mainHero -and -not $_.StartsWith($mainHeroFolder + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase))
})
$candidates += $heroFiles
$testOnly = @($Config.testOnlySources | ForEach-Object { Project-Path ([string]$_) })
$candidates += $testOnly
# Imported gameplay implementations are snapshots; companion heroes come from MAIN.
$candidates = @($candidates | Where-Object {
    -not ($_.StartsWith($stage, [StringComparison]::OrdinalIgnoreCase) -and
        (($_.Substring($stage.Length) -split '[\\/]') | Where-Object { $_ -in $Manifest.excludedGameplayCategories }))
} | Sort-Object -Unique)
foreach ($path in $candidates) {
    $info = Read-SourceInfo $path
    $SourceInfo[$info.Path] = $info
    foreach ($provider in $info.Providers) {
        if (-not $ProviderFiles.ContainsKey($provider)) { $ProviderFiles[$provider] = New-Object 'System.Collections.Generic.List[string]' }
        $ProviderFiles[$provider].Add($info.Path)
    }
}
$seeds = @($enabledImports | ForEach-Object { Join-Path $stage $_ }) + $heroFiles + $testOnly
foreach ($shared in $Config.sharedSources) {
    $sharedPath = Project-Path ([string]$shared)
    if ($mappedSources.ContainsKey($sharedPath)) { $seeds += $mappedSources[$sharedPath] }
    else { $seeds += $sharedPath }
}
# Legacy Systems call other heroes via plain functions/globals without requires.
# Preserve the existing companion family until those contracts are declared.
foreach ($family in $Config.testCompanionSourceDirs) {
    $seeds += @(Get-ChildItem (Project-Path ([string]$family)) -Recurse -File -Filter '*.j' | Where-Object {
        $_.FullName -in $candidates
    } | ForEach-Object { $_.FullName })
}
foreach ($path in ($seeds | Select-Object -Unique)) { Visit-Source $path }
$source = Join-Path $OutputDirectory 'TestCurrent.vj'
$resolutionPath = Join-Path $OutputDirectory 'test-resolution.json'
$report = [ordered]@{ hero = $hero; source = $source; resolvedSources = @($ResolvedFiles); stage = $stage } | ConvertTo-Json -Depth 5
[IO.File]::WriteAllText($resolutionPath, $report, [Text.UTF8Encoding]::new($false))
& python (Join-Path $Root 'tools/test_map_sources.py') include-resolved --workspace $Root --output $stage --resolution $resolutionPath | Out-Host
if ($LASTEXITCODE -ne 0) { throw 'TEST editor closure staging failed' }
$ResolvedFiles = @((Get-Content $resolutionPath -Raw -Encoding UTF8 | ConvertFrom-Json).resolvedSources)
$imports = @($ResolvedFiles | ForEach-Object { '//! import "' + $_ + '"' }) -join "`r`n"
$base = [IO.File]::ReadAllText((Project-Path ([string]$Config.testBaseSource)))
$marker = '// __TEST_SOURCE_IMPORTS__'
if ([regex]::Matches($base, [regex]::Escape($marker)).Count -ne 1) { throw "TEST template must contain exactly one $marker" }
$text = $base.Replace($marker, $imports)
[IO.File]::WriteAllText($source, $text, [Text.UTF8Encoding]::new($false))
Write-Host "TEST / $hero dependencies resolved: $($ResolvedFiles.Count)"
return $source
