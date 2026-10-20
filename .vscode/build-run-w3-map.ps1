[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Test", "Main")]
    [string]$Target,
    [switch]$PrepareOnly,
    [switch]$NoLaunch
)

$ErrorActionPreference = "Stop"

# Some VS Code/plugin environments expose both Path and PATH. Windows
# PowerShell Start-Process treats them as duplicate dictionary keys.
$processPath = $env:Path
Remove-Item Env:Path -ErrorAction SilentlyContinue
Remove-Item Env:PATH -ErrorAction SilentlyContinue
$env:Path = $processPath

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

function Copy-MapToAvailableBuildSlot {
    param(
        [Parameter(Mandatory = $true)][string]$OriginalMap,
        [Parameter(Mandatory = $true)][string]$BuildDirectory,
        [Parameter(Mandatory = $true)][string]$OutputName
    )

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($OutputName)
    $extension = [System.IO.Path]::GetExtension($OutputName)
    $candidateNames = @($OutputName, "${baseName}_2${extension}")
    $lastCopyError = $null

    foreach ($candidateName in $candidateNames) {
        $candidate = [System.IO.Path]::GetFullPath((Join-Path $BuildDirectory $candidateName))
        if ($candidate.Equals($OriginalMap, [System.StringComparison]::OrdinalIgnoreCase)) {
            continue
        }

        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            $stream = $null
            try {
                $stream = [System.IO.File]::Open(
                    $candidate,
                    [System.IO.FileMode]::Open,
                    [System.IO.FileAccess]::ReadWrite,
                    [System.IO.FileShare]::None
                )
            } catch {
                Write-Host "Build slot is still in use: $candidate" -ForegroundColor Yellow
                continue
            } finally {
                if ($null -ne $stream) {
                    $stream.Dispose()
                }
            }
        }

        try {
            if (Test-Path -LiteralPath $OriginalMap -PathType Container) {
                # Keep packing independent of any existing build-slot contents.
                # Pack into a fresh file, then replace the checked slot.
                $freshArchive = Join-Path $BuildDirectory ('.main-pack-' + [guid]::NewGuid().ToString('N') + '.w3x')
                & (Join-Path $PSScriptRoot 'test-map-archive.ps1') -Mode Pack -Map $freshArchive -Directory $OriginalMap -Library (Join-Path (Split-Path -Parent $jassHelper) 'sfmpq.dll') | Out-Host
                Move-Item -LiteralPath $freshArchive -Destination $candidate -Force
            } else {
                Copy-Item -LiteralPath $OriginalMap -Destination $candidate -Force
            }
            return $candidate
        } catch {
            $lastCopyError = $_.Exception.Message
            Write-Host "Build slot became unavailable: $candidate" -ForegroundColor Yellow
        }
    }

    $message = "Both build map slots are in use. Close Warcraft III and try again."
    if (-not [string]::IsNullOrWhiteSpace($lastCopyError)) {
        $message += " Last copy error: $lastCopyError"
    }
    throw $message
}

function Get-MapScriptHash {
    param([Parameter(Mandatory = $true)][string]$Path)

    # Get-FileHash may be unavailable when VS Code inherits a reduced PSModulePath.
    $algorithm = [Security.Cryptography.SHA256]::Create()
    $stream = $null
    try {
        $stream = [IO.File]::OpenRead($Path)
        return [BitConverter]::ToString($algorithm.ComputeHash($stream))
    } finally {
        if ($null -ne $stream) { $stream.Dispose() }
        $algorithm.Dispose()
    }
}

function Ensure-BattleNetSession {
    param([Parameter(Mandatory = $true)]$Config)

    if (Get-Process -Name "Battle.net" -ErrorAction SilentlyContinue) {
        Write-Host "Battle.net session: already running" -ForegroundColor DarkGray
        return
    }

    if ($Config.startBattleNetIfNeeded -ne $true) {
        Write-Host "Battle.net session: not running (automatic start disabled)" -ForegroundColor Yellow
        return
    }

    $configuredExe = [string]$Config.battleNetExe
    if ([string]::IsNullOrWhiteSpace($configuredExe)) {
        throw "Battle.net executable is not configured in: $configPath"
    }

    $battleNetExe = Resolve-WorkspacePath $configuredExe
    Require-File -Path $battleNetExe -Name "Battle.net Launcher"

    $waitSeconds = 6
    if ($null -ne $Config.battleNetWaitSeconds) {
        $waitSeconds = [Math]::Max(0, [Math]::Min(60, [int]$Config.battleNetWaitSeconds))
    }

    Write-Host "Starting Battle.net Launcher..." -ForegroundColor Cyan
    Start-Process `
        -FilePath $battleNetExe `
        -WindowStyle Hidden `
        -WorkingDirectory (Split-Path -Parent $battleNetExe)

    if ($waitSeconds -gt 0) {
        Write-Host "Waiting $waitSeconds seconds for Battle.net Agent/session..." -ForegroundColor DarkGray
        Start-Sleep -Seconds $waitSeconds
    }
}

try {
    if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
        $examplePath = Join-Path $PSScriptRoot "wos-build.example.json"
        throw "Local build configuration not found: $configPath. Copy $examplePath to $configPath and set your Warcraft III, JassHelper and map paths."
    }
    $config = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8 | ConvertFrom-Json
    if ($Target -eq 'Test') { $config = & (Join-Path $PSScriptRoot 'ensure-test-profile.ps1') }

    $gameExe = Resolve-WorkspacePath ([string]$config.gameExe)
    $jassHelper = Resolve-WorkspacePath ([string]$config.jassHelper)
    $commonJ = Resolve-WorkspacePath ([string]$config.commonJ)
    $blizzardJ = Resolve-WorkspacePath ([string]$config.blizzardJ)
    $buildDir = Resolve-WorkspacePath ([string]$config.buildDir)

    if (-not $PrepareOnly -and -not $NoLaunch) { Require-File -Path $gameExe -Name "Warcraft III executable" }
    if (-not $PrepareOnly) { Require-File -Path $jassHelper -Name "JassHelper executable" }
    Require-File -Path $commonJ -Name "common.j"
    Require-File -Path $blizzardJ -Name "Blizzard.j"
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null

    if ($Target -eq "Test") {
        $testHero = [string]$config.testHero
        if ([string]::IsNullOrWhiteSpace($testHero) -or [System.IO.Path]::GetFileName($testHero) -ne $testHero) {
            throw "Invalid testHero in: $configPath"
        }

        $originalMap = if ($config.testMap) {
            Resolve-WorkspacePath ([string]$config.testMap)
        } else {
            Join-Path (Resolve-WorkspacePath ([string]$config.testMapsDir)) "$testHero.w3x"
        }
        $outputName = "${testHero}_Test.w3x"
        Require-File -Path $originalMap -Name "Original TEST map"
        $source = & (Join-Path $PSScriptRoot 'prepare-test-map.ps1') -OutputDirectory $buildDir
        $profileName = "TEST / $testHero"
    } else {
        # Reject before changing MAIN source/imports or packing a stale editor map.
        # Keep the later script guard too, in case the editor opens during compile.
        if (Get-Process -Name 'World Editor','WorldEditorTESH' -ErrorAction SilentlyContinue) {
            throw "World Editor is running. Close the map WITHOUT saving before building MAIN; it can overwrite externally changed WTG/WCT files."
        }
        $profileName = "MAIN"
        $originalMap = Resolve-WorkspacePath ([string]$config.mainMap)
        $source = Resolve-WorkspacePath ([string]$config.mainSource)
        $outputName = "WoS_Test.w3x"

        & python (Join-Path $workspaceRoot 'tools/check_main_source_parity.py') --require-synced
        if ($LASTEXITCODE -ne 0) { throw 'MAIN WCT/source preflight failed; check/save before building.' }

        if (-not (Test-Path -LiteralPath $originalMap)) { throw "Original MAIN map not found: $originalMap" }
        if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
            Write-Host "MAIN SOURCE NOT CREATED:" -ForegroundColor Red
            Write-Host $source -ForegroundColor Red
            exit 1
        }

        $triggerSettingsApplier = Join-Path $PSScriptRoot "apply-trigger-settings.ps1"
        Require-File -Path $triggerSettingsApplier -Name "Trigger settings applier"
        & $triggerSettingsApplier `
            -TriggerDirectory (Join-Path $workspaceRoot "triggers") `
            -MainSource $source

        # Register the versioned wheel textures so later World Editor saves retain them.
        if (Test-Path -LiteralPath $originalMap -PathType Container) {
            $pingAssets = Join-Path $workspaceRoot 'assets\UI\TeamPings'
            if (Test-Path -LiteralPath $pingAssets -PathType Container) {
                & python (Join-Path $workspaceRoot 'tools\install_team_ping_assets.py') --map $originalMap
                if ($LASTEXITCODE -ne 0) { throw 'Command wheel asset installation failed' }
            }
            $sharedUIAssets = Join-Path $workspaceRoot 'assets\UI\WOS'
            if (Test-Path -LiteralPath $sharedUIAssets -PathType Container) {
                & python (Join-Path $workspaceRoot 'tools\install_wos_ui_assets.py') --map $originalMap
                if ($LASTEXITCODE -ne 0) { throw 'Shared UI asset installation failed' }
            }
            # Item icons and effect copies kept prebuilt in assets/ (see tools/install_project_assets.py).
            & python (Join-Path $workspaceRoot 'tools\install_project_assets.py') --map $originalMap
            if ($LASTEXITCODE -ne 0) { throw 'Project asset installation failed' }
        }
    }

    Write-Host "Selected profile: $profileName"
    Write-Host "Original map:     $originalMap"
    Write-Host "Source mapscript: $source"

    Require-File -Path $source -Name "Profile mapscript"
    if (-not (Test-Path -LiteralPath $originalMap)) { throw "Original map not found: $originalMap" }

    if ($PrepareOnly) {
        Write-Host "BUILD PREPARATION OK (no compiler or game launch)" -ForegroundColor Green
        exit 0
    }

    if ($Target -eq 'Test') {
        $builtMap = Copy-MapToAvailableBuildSlot `
            -OriginalMap $originalMap `
            -BuildDirectory $buildDir `
            -OutputName $outputName
        Write-Host "Built map:        $builtMap"
    } else {
        # MAIN: compile the complete external script first, then pack that exact
        # script. Legacy map-mode compilation can silently omit external imports.
        $scriptStage = Join-Path $buildDir 'main-compiled-script'
        New-Item -ItemType Directory -Path $scriptStage -Force | Out-Null
        $compiledMainScript = Join-Path $scriptStage 'war3map.j'
    }

    if ($Target -eq 'Test') {
        $unpacked = Resolve-WorkspacePath ([string]$config.testMapDirectory)
        if (-not (Test-Path -LiteralPath (Join-Path $unpacked 'war3map.imp') -PathType Leaf)) {
            $importNames = Join-Path $buildDir 'test-import-names.json'
            [IO.File]::WriteAllText($importNames, '["war3map.imp"]', [Text.UTF8Encoding]::new($false))
            & (Join-Path $PSScriptRoot 'test-map-archive.ps1') -Mode Extract -Map $originalMap -Directory $unpacked -NamesFile $importNames -Library (Join-Path (Split-Path -Parent $jassHelper) 'sfmpq.dll')
        }
        & python (Join-Path $workspaceRoot 'tools/install_project_assets.py') --map $unpacked
        if ($LASTEXITCODE -ne 0) { throw 'TEST project asset installation failed' }
        & (Join-Path $PSScriptRoot 'test-map-archive.ps1') -Mode Update -Map $builtMap -Directory $unpacked -Library (Join-Path (Split-Path -Parent $jassHelper) 'sfmpq.dll')
        # Materialize the same resolved source set into the copied map's editor
        # payload. Never save into the input map or the original unpacked folder.
        $editorStage = Join-Path $buildDir 'test-editor-triggers'
        New-Item -ItemType Directory -Path $editorStage -Force | Out-Null
        foreach ($name in @('war3map.wtg', 'war3map.wct')) {
            Copy-Item -LiteralPath (Join-Path $unpacked $name) -Destination (Join-Path $editorStage $name) -Force
        }
        $editorBuildConfig = Join-Path $buildDir 'test-editor-build.json'
        $editorSyncConfig = Join-Path $buildDir 'test-editor-sync.json'
        [IO.File]::WriteAllText($editorBuildConfig, (@{ testMapDirectory = $editorStage } | ConvertTo-Json), [Text.UTF8Encoding]::new($false))
        [IO.File]::WriteAllText($editorSyncConfig, (@{ build_config = $editorBuildConfig; map_key = 'testMapDirectory'; allow_stale_wtg_counts = $true } | ConvertTo-Json), [Text.UTF8Encoding]::new($false))
        & python (Join-Path $workspaceRoot 'tools/sync_war3_triggers.py') push --config $editorSyncConfig --triggers (Join-Path $buildDir 'test-sources') --backups (Join-Path $buildDir 'test-editor-backups')
        if ($LASTEXITCODE -ne 0) { throw 'TEST editor trigger synchronization failed' }
        & (Join-Path $PSScriptRoot 'test-map-archive.ps1') -Mode Update -Map $builtMap -Directory $editorStage -Library (Join-Path (Split-Path -Parent $jassHelper) 'sfmpq.dll')
    }
    $sourceDirectory = Split-Path -Parent $source
    $jassHelperArguments = @(
        "`"$commonJ`"",
        "`"$blizzardJ`"",
        "`"$source`"",
        "`"$builtMap`""
    )
    if ($Target -eq 'Main') {
        $jassHelperArguments = @('--scriptonly', "`"$commonJ`"", "`"$blizzardJ`"", "`"$source`"", "`"$compiledMainScript`"")
        $sourceDirectory = Split-Path -Parent $jassHelper
    }

    Write-Host "Running JassHelper..." -ForegroundColor Cyan
    $jassHelperProcess = Start-Process `
        -FilePath $jassHelper `
        -ArgumentList $jassHelperArguments `
        -WorkingDirectory $sourceDirectory `
        -Wait `
        -PassThru `
        -NoNewWindow

    $jassHelperExitCode = $jassHelperProcess.ExitCode

    if ($jassHelperExitCode -ne 0) {
        Write-Host "BUILD FAILED" -ForegroundColor Red
        Write-Host "JassHelper exit code: $jassHelperExitCode" -ForegroundColor Red
        exit $jassHelperExitCode
    }

    Write-Host "BUILD OK" -ForegroundColor Green
    if ($Target -eq 'Main' -and (Test-Path -LiteralPath $originalMap -PathType Container)) {
        if (Get-Process -Name 'World Editor','WorldEditorTESH' -ErrorAction SilentlyContinue) {
            throw "Close World Editor before updating MAIN's compiled script. Compiled copy: $builtMap"
        }
        $compiledScript = $compiledMainScript
        Require-File -Path $compiledScript -Name 'Compiled MAIN mapscript'
        & python (Join-Path $workspaceRoot 'tools/check_main_source_parity.py') `
            --require-synced --candidate-source $source --reference-script $compiledScript `
            --work-directory (Join-Path $buildDir 'main-source-parity')
        if ($LASTEXITCODE -ne 0) { throw 'MAIN source/compiled parity failed; scenario script was not replaced.' }
        $scriptBackup = Join-Path $workspaceRoot ('backups/main-map-build/' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
        New-Item -ItemType Directory -Path $scriptBackup -Force | Out-Null
        $mapScript = Join-Path $originalMap 'war3map.j'
        if (Test-Path -LiteralPath $mapScript -PathType Leaf) { Copy-Item -LiteralPath $mapScript -Destination (Join-Path $scriptBackup 'war3map.j') }
        Copy-Item -LiteralPath $compiledScript -Destination $mapScript -Force
        Write-Host "MAIN scenario compiled script updated: $mapScript"
        Write-Host "Previous script backup: $scriptBackup"
        $builtMap = Copy-MapToAvailableBuildSlot `
            -OriginalMap $originalMap -BuildDirectory $buildDir -OutputName $outputName
        Write-Host "Built map:        $builtMap"
        $packedStage = Join-Path $buildDir 'main-packed-script-verify'
        $scriptNames = Join-Path $buildDir 'main-compiled-script-names.json'
        [IO.File]::WriteAllText($scriptNames, '["war3map.j"]', [Text.UTF8Encoding]::new($false))
        & (Join-Path $PSScriptRoot 'test-map-archive.ps1') -Mode Extract -Map $builtMap -Directory $packedStage -Library (Join-Path (Split-Path -Parent $jassHelper) 'sfmpq.dll') -NamesFile $scriptNames | Out-Host
        if ((Get-MapScriptHash -Path (Join-Path $packedStage 'war3map.j')) -ne (Get-MapScriptHash -Path $compiledScript)) {
            throw 'Packed MAIN script differs from the checked compiled script.'
        }
    }
    if ($Target -eq 'Test') {
        if (Get-Process -Name 'World Editor','WorldEditorTESH' -ErrorAction SilentlyContinue) {
            throw "Close World Editor before updating the selected Heroes map. Compiled copy: $builtMap"
        }
        $backupDirectory = Join-Path $workspaceRoot "backups/test-maps/$testHero"
        New-Item -ItemType Directory -Path $backupDirectory -Force | Out-Null
        $backupMap = Join-Path $backupDirectory ((Get-Date -Format 'yyyyMMdd-HHmmss-fff') + '.w3x')
        Copy-Item -LiteralPath $originalMap -Destination $backupMap
        Copy-Item -LiteralPath $builtMap -Destination $originalMap -Force
        Write-Host "Heroes map updated: $originalMap"
    }
    if ($NoLaunch) { Write-Host "Game launch skipped."; exit 0 }
    Ensure-BattleNetSession -Config $config

    . (Join-Path $PSScriptRoot 'warcraft-launch.ps1')
    $launchMap = if ($Target -eq 'Test') { $originalMap } else { $builtMap }
    $editorLog = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Warcraft III/Logs/War3Log.txt'
    $gameArguments = @(Get-WarcraftLaunchArguments -Config $config -Map $launchMap -EditorLog $editorLog)
    $effectiveCommand = '"' + $gameExe + '" ' + ($gameArguments -join ' ')
    $gameWorkingDirectory = Split-Path -Parent $gameExe
    if ((Split-Path -Leaf $gameWorkingDirectory) -in @('x86_64','x86')) {
        $gameWorkingDirectory = Split-Path -Parent $gameWorkingDirectory
    }

    Write-Host ""
    Write-Host "Launching Warcraft III:" -ForegroundColor Cyan
    Write-Host $effectiveCommand -ForegroundColor DarkGray
    Write-Host ""
    Start-Process `
        -FilePath $gameExe `
        -ArgumentList $gameArguments `
        -WorkingDirectory $gameWorkingDirectory
    Write-Host "WARCRAFT STARTED" -ForegroundColor Green
} catch {
    Write-Host "BUILD FAILED" -ForegroundColor Red
    Write-Error $_.Exception.Message
    exit 1
}
