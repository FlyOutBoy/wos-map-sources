[CmdletBinding()]
param(
    [string]$MapDirectory,
    [switch]$ValidateOnly
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
