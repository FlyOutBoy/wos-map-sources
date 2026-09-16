[CmdletBinding()]
param(
    [string]$MapDirectory
)

$ErrorActionPreference = "Stop"

$workspaceRoot = Split-Path -Parent $PSScriptRoot
$objectDataDirectory = [System.IO.Path]::GetFullPath((Join-Path $workspaceRoot "object-data"))
$rawDataDirectory = [System.IO.Path]::GetFullPath((Join-Path $workspaceRoot ".object-data-raw"))
$backupRoot = [System.IO.Path]::GetFullPath((Join-Path $workspaceRoot "object-data-backups"))
$commonJ = [System.IO.Path]::GetFullPath((Join-Path $workspaceRoot "libs\common.j"))
$converter = [System.IO.Path]::GetFullPath((Join-Path $workspaceRoot "tools\war3_object_workspace.py"))
$buildRoot = [System.IO.Path]::GetFullPath((Join-Path $workspaceRoot "_build\object-data-import"))

function Require-File {
    param([string]$Path, [string]$Description)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "$Description not found: $Path"
    }
}

function Select-UnpackedMapDirectory {
    Add-Type -AssemblyName System.Windows.Forms

    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Select an unpacked Warcraft III map folder containing war3map.w3u / war3map.w3a / other object files"
    $dialog.ShowNewFolderButton = $false

    if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
        return $null
    }
    return $dialog.SelectedPath
}

try {
    Require-File -Path $commonJ -Description "common.j"
    Require-File -Path $converter -Description "Object-data converter"

    if ([string]::IsNullOrWhiteSpace($MapDirectory)) {
        $MapDirectory = Select-UnpackedMapDirectory
        if ([string]::IsNullOrWhiteSpace($MapDirectory)) {
            Write-Host "Object-data import cancelled." -ForegroundColor Yellow
            exit 0
        }
    }

    $sourceMap = [System.IO.Path]::GetFullPath($MapDirectory)
    if (-not (Test-Path -LiteralPath $sourceMap -PathType Container)) {
        throw "Unpacked map folder not found: $sourceMap"
    }

    $supportedNames = @(
        "war3map.w3u", "war3mapSkin.w3u",
        "war3map.w3t", "war3mapSkin.w3t",
        "war3map.w3b", "war3mapSkin.w3b",
        "war3map.w3d", "war3mapSkin.w3d",
        "war3map.w3a", "war3mapSkin.w3a",
        "war3map.w3h", "war3mapSkin.w3h",
        "war3map.w3q", "war3mapSkin.w3q"
    )
    $foundObjectFiles = @($supportedNames | Where-Object {
        Test-Path -LiteralPath (Join-Path $sourceMap $_) -PathType Leaf
    })
    if ($foundObjectFiles.Count -eq 0) {
        throw "The selected folder contains no supported Warcraft III object-data files: $sourceMap"
    }

    $python = Get-Command "python" -ErrorAction Stop
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss-fff"
    $temporaryRoot = Join-Path $buildRoot $stamp
    $temporaryObjects = Join-Path $temporaryRoot "object-data"
    $temporaryRaw = Join-Path $temporaryRoot ".object-data-raw"
    $temporaryBackups = Join-Path $temporaryRoot "unused-backups"
    $temporaryConfig = Join-Path $temporaryRoot "import.config.json"
    New-Item -ItemType Directory -Path $temporaryRoot -Force | Out-Null

    $temporaryConfiguration = [ordered]@{
        map_directory = $sourceMap
        json_directory = $temporaryObjects
        raw_json_directory = $temporaryRaw
        common_j = $commonJ
        backup_directory = $temporaryBackups
    } | ConvertTo-Json
    [System.IO.File]::WriteAllText(
        $temporaryConfig,
        $temporaryConfiguration + [Environment]::NewLine,
        [System.Text.UTF8Encoding]::new($false)
    )

    Write-Host ""
    Write-Host "OBJECT DATA IMPORT" -ForegroundColor Cyan
    Write-Host "Source unpacked map: $sourceMap"
    Write-Host "Object files found:   $($foundObjectFiles.Count)"
    Write-Host "Reading into temporary workspace..." -ForegroundColor DarkGray

    & $python.Source $converter --config $temporaryConfig export --force
    if ($LASTEXITCODE -ne 0) {
        throw "Object-data converter failed with exit code $LASTEXITCODE. Current project data was not changed."
    }

    $expectedOutputs = @(
        "abilities.json", "units.json", "items.json", "buffs.json",
        "upgrades.json", "destructables.json", "doodads.json"
    )
    foreach ($expectedOutput in $expectedOutputs) {
        Require-File -Path (Join-Path $temporaryObjects $expectedOutput) -Description "Converted $expectedOutput"
    }
    Require-File -Path (Join-Path $temporaryRaw "workspace-meta\manifest.json") -Description "Converted object metadata"

    $backupDirectory = Join-Path $backupRoot "import-$stamp"
    New-Item -ItemType Directory -Path $backupDirectory -Force | Out-Null
    if (Test-Path -LiteralPath $objectDataDirectory -PathType Container) {
        Copy-Item -LiteralPath $objectDataDirectory -Destination (Join-Path $backupDirectory "object-data") -Recurse
    }
    if (Test-Path -LiteralPath $rawDataDirectory -PathType Container) {
        Copy-Item -LiteralPath $rawDataDirectory -Destination (Join-Path $backupDirectory ".object-data-raw") -Recurse
    }

    if (Test-Path -LiteralPath $objectDataDirectory) {
        Remove-Item -LiteralPath $objectDataDirectory -Recurse -Force
    }
    if (Test-Path -LiteralPath $rawDataDirectory) {
        Remove-Item -LiteralPath $rawDataDirectory -Recurse -Force
    }
    Move-Item -LiteralPath $temporaryObjects -Destination $objectDataDirectory
    Move-Item -LiteralPath $temporaryRaw -Destination $rawDataDirectory

    Write-Host ""
    Write-Host "OBJECT DATA IMPORT OK" -ForegroundColor Green
    Write-Host "Project JSON: $objectDataDirectory"
    Write-Host "Raw metadata: $rawDataDirectory"
    Write-Host "Backup:       $backupDirectory"
    Write-Host "Source map was not modified." -ForegroundColor DarkGray
} catch {
    Write-Host "OBJECT DATA IMPORT FAILED" -ForegroundColor Red
    Write-Error $_.Exception.Message
    exit 1
}
