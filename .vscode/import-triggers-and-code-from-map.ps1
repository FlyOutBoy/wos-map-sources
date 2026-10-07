[CmdletBinding()]
param(
    [string]$MapDirectory,
    [switch]$ValidateOnly,
    [ValidateSet('Main', 'Test')][string]$Target = 'Main',
    [switch]$PreferMapSources,
    [switch]$RefreshArchive
)

$ErrorActionPreference = "Stop"

$workspaceRoot = Split-Path -Parent $PSScriptRoot
$extractor = Join-Path $workspaceRoot "tools\extract_war3_triggers.py"
$mainSourceBuilder = Join-Path $workspaceRoot "tools\create-main-mapscript.ps1"
$triggerSettingsApplier = Join-Path $PSScriptRoot "apply-trigger-settings.ps1"
$projectTriggers = Join-Path $workspaceRoot "triggers"
$projectMainSource = Join-Path $workspaceRoot "map_source\Main.vj"
$backupRoot = Join-Path $workspaceRoot "backups\source-import"
$temporaryBase = Join-Path $workspaceRoot "_build\source-import"

function Require-File {
    param([string]$Path, [string]$Description)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "$Description not found: $Path"
    }
}

function Select-UnpackedMapDirectory {
    Add-Type -AssemblyName System.Windows.Forms

    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Select an unpacked Warcraft III map folder containing war3map.wtg, war3map.wct and war3map.j"
    $dialog.ShowNewFolderButton = $false
    if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
        return $null
    }
    return $dialog.SelectedPath
}

try {
    Require-File -Path $extractor -Description "WTG/WCT extractor"
    Require-File -Path $mainSourceBuilder -Description "Main.vj builder"
    Require-File -Path $triggerSettingsApplier -Description "Trigger settings applier"

    if ($Target -eq 'Test') {
        $config = & (Join-Path $PSScriptRoot 'ensure-test-profile.ps1')
        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
        $temporaryRoot = Join-Path $workspaceRoot "_build\test-source-import\$stamp"
        $sourceArchive = [string]$config.testMap
        $extractArchive = $RefreshArchive -or [string]::IsNullOrWhiteSpace($MapDirectory)
        if ($MapDirectory -and (Test-Path -LiteralPath $MapDirectory -PathType Leaf)) {
            if ([IO.Path]::GetExtension($MapDirectory) -ine '.w3x') { throw 'TEST source must be a .w3x archive or an extracted folder' }
            $sourceArchive = [IO.Path]::GetFullPath($MapDirectory)
            $extractArchive = $true
        }
        if ($extractArchive) {
            $MapDirectory = Join-Path $temporaryRoot 'archive'
            $helper = [string]$config.jassHelper
            if (-not [IO.Path]::IsPathRooted($helper)) { $helper = Join-Path $workspaceRoot $helper }
            Write-Host "Reading saved TEST archive: $sourceArchive"
            & (Join-Path $PSScriptRoot 'test-map-archive.ps1') -Mode Extract -Map $sourceArchive -Directory $MapDirectory -Library (Join-Path (Split-Path -Parent $helper) 'sfmpq.dll')
            if ($LASTEXITCODE -ne 0) { throw 'Cannot extract saved TEST archive' }
        }
        $temporaryTriggers = Join-Path $temporaryRoot 'triggers'
        $temporaryTemplate = Join-Path $temporaryRoot 'TestBase.vj'
        $sourceMap = [IO.Path]::GetFullPath($MapDirectory)
        & python $extractor --wtg (Join-Path $sourceMap 'war3map.wtg') --wct (Join-Path $sourceMap 'war3map.wct') --output $temporaryTriggers --allow-stale-counts
        if ($LASTEXITCODE -ne 0) { throw 'TEST WTG/WCT extraction failed' }
        $base = [string]$config.base
        # Local overrides survive subsequent imports. MAIN sources are never written.
        $policy = Get-Content (Join-Path $base 'test-source-manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($property in $policy.overrides.PSObject.Properties) {
            if ($PreferMapSources) { continue }
            $local = Join-Path $base $property.Name
            if (Test-Path $local -PathType Leaf) { Copy-Item -LiteralPath $local -Destination (Join-Path $temporaryTriggers $property.Name) -Force }
        }
        & python (Join-Path $workspaceRoot 'tools/test_map_sources.py') configure-import --output $temporaryTriggers --map-directory $sourceMap --archive $sourceArchive
        if ($LASTEXITCODE -ne 0) { throw 'TEST source origin configuration failed' }
        $manifest = Get-Content (Join-Path $temporaryTriggers 'test-source-manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
        $testHeroSource = Join-Path $workspaceRoot "test_map/heroes/$($config.testHero).j"
        if ($PreferMapSources) {
            foreach ($entry in $manifest.sources) {
                if ([IO.Path]::GetFileName($entry.path) -ieq "$($config.testHero).j") {
                    $entry.origin = @{ kind = 'testHero'; path = "$($config.testHero).j"; overrideOf = "Heroes/$($config.testHero).j" }
                }
                if ($entry.origin.kind -eq 'shared' -and [IO.Path]::GetFileName($entry.path) -ine "$($config.testHero).j") {
                    $canonical = Join-Path $projectTriggers $entry.origin.path
                    $imported = Join-Path $temporaryTriggers $entry.path
                    $currentText = (Get-Content $canonical -Raw -Encoding UTF8).Replace("`r`n","`n").TrimEnd()
                    $mapText = (Get-Content $imported -Raw -Encoding UTF8).Replace("`r`n","`n").TrimEnd()
                    if ($mapText -ne $currentText) {
                        $origin = @{ kind = 'test'; reason = 'Imported current TEST map code; MAIN is unchanged.' }
                        $entry.origin = $origin
                        $manifest.overrides | Add-Member -NotePropertyName $entry.path -NotePropertyValue @{ reason = $origin.reason } -Force
                    }
                }
            }
            $manifest | ConvertTo-Json -Depth 100 | Set-Content (Join-Path $temporaryTriggers 'test-source-manifest.json') -Encoding UTF8
        }
        $heroSources = @($manifest.sources | Where-Object { [IO.Path]::GetFileName($_.path) -ieq "$($config.testHero).j" })
        if ($heroSources.Count -gt 1) { throw "Ambiguous imported source for TEST hero $($config.testHero)" }
        if ($PreferMapSources -and $heroSources.Count -eq 0) {
            throw "Saved TEST map has no $($config.testHero).j source in WTG/WCT. Local hero code was not replaced. Save that hero's code in the selected map first."
        }
        $compileInput = Join-Path $temporaryRoot 'imports.j'
        $templateImports = @($manifest.enabledImports | ForEach-Object { '//! import "' + (Join-Path $temporaryTriggers $_) + '"' })
        $templateImports += @($config.testOnlySources | ForEach-Object {
            $p = [string]$_
            if (-not [IO.Path]::IsPathRooted($p)) { $p = Join-Path $workspaceRoot $p }
            '//! import "' + $p + '"'
        })
        [IO.File]::WriteAllLines($compileInput, [string[]]$templateImports, [Text.UTF8Encoding]::new($false))
        & $mainSourceBuilder -War3MapJ (Join-Path $sourceMap 'war3map.j') -CompileInput $compileInput -Output $temporaryTemplate -Profile 'TEST' -TestTemplate
        if ($LASTEXITCODE -ne 0) { throw 'TEST template generation failed' }
        if ($ValidateOnly) { Write-Host "TEST IMPORT VALIDATION OK: $temporaryRoot"; exit 0 }
        $backup = Join-Path $workspaceRoot "backups/test-source-import/$stamp"
        New-Item -ItemType Directory -Path $backup -Force | Out-Null
        foreach ($name in @('base','map_source')) {
            $current = Join-Path (Split-Path -Parent $base) $name
            if (Test-Path $current) { Copy-Item $current -Destination (Join-Path $backup $name) -Recurse }
        }
        if ($PreferMapSources -and (Test-Path -LiteralPath $testHeroSource -PathType Leaf)) {
            Copy-Item -LiteralPath $testHeroSource -Destination (Join-Path $backup "$($config.testHero).j")
        }
        # Copy files individually; retain unrecognized local TEST files for review.
        foreach ($file in (Get-ChildItem $temporaryTriggers -Recurse -File)) {
            $relative = $file.FullName.Substring($temporaryTriggers.Length + 1)
            $destination = Join-Path $base $relative
            New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
            Copy-Item $file.FullName -Destination $destination -Force
        }
        $template = [string]$config.testBaseSource
        Copy-Item $temporaryTemplate -Destination $template -Force
        $heroDirectory = Join-Path $workspaceRoot 'test_map/heroes'
        New-Item -ItemType Directory -Path $heroDirectory -Force | Out-Null
        if ($heroSources.Count -eq 1 -and ($PreferMapSources -or (Get-Item ([string]$config.heroSource)).Length -eq 0)) {
            $heroDestination = if ($PreferMapSources) { $testHeroSource } else { [string]$config.heroSource }
            New-Item -ItemType Directory -Path (Split-Path -Parent $heroDestination) -Force | Out-Null
            Copy-Item (Join-Path $temporaryTriggers $heroSources[0].path) -Destination $heroDestination -Force
            $selected = & (Join-Path $PSScriptRoot 'ensure-test-profile.ps1')
            Write-Host "TEST hero code imported: $heroDestination"
            Write-Host "Active TEST build source: $($selected.heroSource)"
        }
        Write-Host "TEST IMPORT OK: $($config.testHero); backup: $backup"
        exit 0
    }

    if ([string]::IsNullOrWhiteSpace($MapDirectory)) {
        $MapDirectory = Select-UnpackedMapDirectory
        if ([string]::IsNullOrWhiteSpace($MapDirectory)) {
            Write-Host "Trigger/code import cancelled." -ForegroundColor Yellow
            exit 0
        }
    }

    $sourceMap = [System.IO.Path]::GetFullPath($MapDirectory)
    if (-not (Test-Path -LiteralPath $sourceMap -PathType Container)) {
        throw "Unpacked map folder not found: $sourceMap"
    }

    $sourceWtg = Join-Path $sourceMap "war3map.wtg"
    $sourceWct = Join-Path $sourceMap "war3map.wct"
    $sourceJ = Join-Path $sourceMap "war3map.j"
    Require-File -Path $sourceWtg -Description "Source war3map.wtg"
    Require-File -Path $sourceWct -Description "Source war3map.wct"
    Require-File -Path $sourceJ -Description "Source war3map.j"

    $python = Get-Command "python" -ErrorAction Stop
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss-fff"
    $temporaryRoot = Join-Path $temporaryBase $stamp
    $temporaryTriggers = Join-Path $temporaryRoot "triggers"
    $temporaryCompileInput = Join-Path $temporaryRoot "trigger-imports.j"
    $temporaryMainSource = Join-Path $temporaryRoot "map_source\Main.vj"
    New-Item -ItemType Directory -Path $temporaryRoot -Force | Out-Null

    Write-Host ""
    Write-Host "TRIGGER AND CODE IMPORT" -ForegroundColor Cyan
    Write-Host "Source unpacked map: $sourceMap"
    Write-Host "Extracting original WTG/WCT sources into a temporary workspace..." -ForegroundColor DarkGray

    & $python.Source $extractor --wtg $sourceWtg --wct $sourceWct --output $temporaryTriggers
    if ($LASTEXITCODE -ne 0) {
        throw "WTG/WCT extraction failed with exit code $LASTEXITCODE. Current project sources were not changed."
    }

    $manifestPath = Join-Path $temporaryTriggers "trigger-manifest.json"
    Require-File -Path $manifestPath -Description "Extracted trigger manifest"
    $manifest = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $orderedSources = @($manifest.sources | Sort-Object { [int]$_.order })
    if ($orderedSources.Count -eq 0) {
        throw "The selected map produced no trigger sources."
    }

    $importLines = @($orderedSources | ForEach-Object {
        $sourcePath = [System.IO.Path]::GetFullPath((Join-Path $temporaryTriggers ([string]$_.path)))
        Require-File -Path $sourcePath -Description "Extracted trigger source"
        "//! import `"$sourcePath`""
    })
    [System.IO.File]::WriteAllLines(
        $temporaryCompileInput,
        [string[]]$importLines,
        [System.Text.UTF8Encoding]::new($false)
    )

    & $mainSourceBuilder `
        -War3MapJ $sourceJ `
        -CompileInput $temporaryCompileInput `
        -Output $temporaryMainSource
    if ($LASTEXITCODE -ne 0) {
        throw "Main.vj generation failed with exit code $LASTEXITCODE. Current project sources were not changed."
    }
    Require-File -Path $temporaryMainSource -Description "Generated Main.vj"
    & $triggerSettingsApplier -TriggerDirectory $temporaryTriggers -MainSource $temporaryMainSource

    if ($ValidateOnly) {
        Write-Host ""
        Write-Host "TRIGGER AND CODE IMPORT VALIDATION OK" -ForegroundColor Green
        Write-Host "Extracted sources: $($orderedSources.Count)"
        Write-Host "Generated Main.vj: $temporaryMainSource"
        Write-Host "Current project sources were not changed." -ForegroundColor DarkGray
        exit 0
    }

    $backupDirectory = Join-Path $backupRoot "import-$stamp"
    New-Item -ItemType Directory -Path $backupDirectory -Force | Out-Null
    if (Test-Path -LiteralPath $projectTriggers -PathType Container) {
        Copy-Item -LiteralPath $projectTriggers -Destination (Join-Path $backupDirectory "triggers") -Recurse
    }
    if (Test-Path -LiteralPath $projectMainSource -PathType Leaf) {
        $backupMapSource = Join-Path $backupDirectory "map_source"
        New-Item -ItemType Directory -Path $backupMapSource -Force | Out-Null
        Copy-Item -LiteralPath $projectMainSource -Destination (Join-Path $backupMapSource "Main.vj")
    }
    foreach ($name in @("war3map.j", "war3map.wtg", "war3map.wct")) {
        $current = Join-Path $workspaceRoot $name
        if (Test-Path -LiteralPath $current -PathType Leaf) {
            Copy-Item -LiteralPath $current -Destination (Join-Path $backupDirectory $name)
        }
    }

    if (Test-Path -LiteralPath $projectTriggers) {
        Remove-Item -LiteralPath $projectTriggers -Recurse -Force
    }
    Move-Item -LiteralPath $temporaryTriggers -Destination $projectTriggers
    New-Item -ItemType Directory -Path (Split-Path -Parent $projectMainSource) -Force | Out-Null
    Copy-Item -LiteralPath $temporaryMainSource -Destination $projectMainSource -Force
    Copy-Item -LiteralPath $sourceJ -Destination (Join-Path $workspaceRoot "war3map.j") -Force
    Copy-Item -LiteralPath $sourceWtg -Destination (Join-Path $workspaceRoot "war3map.wtg") -Force
    Copy-Item -LiteralPath $sourceWct -Destination (Join-Path $workspaceRoot "war3map.wct") -Force

    Write-Host ""
    Write-Host "TRIGGER AND CODE IMPORT OK" -ForegroundColor Green
    Write-Host "Triggers:   $projectTriggers"
    Write-Host "Main source: $projectMainSource"
    Write-Host "Backup:      $backupDirectory"
    Write-Host "Imported sources: $($orderedSources.Count)"
    Write-Host "Source map was not modified." -ForegroundColor DarkGray
} catch {
    Write-Host "TRIGGER AND CODE IMPORT FAILED" -ForegroundColor Red
    Write-Error $_.Exception.Message
    exit 1
}
