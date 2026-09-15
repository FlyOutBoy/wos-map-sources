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

function Get-SourceFiles {
    param([Parameter(Mandatory = $true)][string[]]$ConfiguredPaths)

    $excludedDirectories = @("backups", "backup", "archive", "_build", ".vscode", ".git")
    $files = @()
    foreach ($configuredPath in $ConfiguredPaths) {
        $path = Resolve-WorkspacePath $configuredPath
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            if ([System.IO.Path]::GetExtension($path) -ieq ".j") {
                $files += Get-Item -LiteralPath $path
            }
            continue
        }
        if (-not (Test-Path -LiteralPath $path -PathType Container)) {
            throw "TEST DEPENDENCY MISSING: $path"
        }

        $files += Get-ChildItem -LiteralPath $path -Recurse -File -Filter "*.j" |
            Where-Object {
                $relative = $_.FullName.Substring($path.Length).TrimStart("\")
                -not (($relative -split '[\\/]') | Where-Object { $_ -in $excludedDirectories })
            }
    }

    return @($files | Sort-Object FullName -Unique)
}

function Get-SelectedHeroSources {
    param(
        [Parameter(Mandatory = $true)][string]$Hero,
        [Parameter(Mandatory = $true)][string[]]$SourceDirectories
    )

    $matches = @()
    foreach ($configuredDirectory in $SourceDirectories) {
        $directory = Resolve-WorkspacePath $configuredDirectory
        if (-not (Test-Path -LiteralPath $directory -PathType Container)) {
            throw "TEST DEPENDENCY MISSING: $directory"
        }

        $singleFile = Join-Path $directory "$Hero.j"
        if (Test-Path -LiteralPath $singleFile -PathType Leaf) {
            $matches += Get-Item -LiteralPath $singleFile
        }

        $heroDirectory = Join-Path $directory $Hero
        if (Test-Path -LiteralPath $heroDirectory -PathType Container) {
            $matches += Get-SourceFiles @($heroDirectory)
        }

        if ((Split-Path -Leaf $directory) -ieq $Hero) {
            $matches += Get-SourceFiles @($directory)
        }
    }

    return @($matches | Sort-Object FullName -Unique)
}

function Get-WorkspaceImport {
    param([Parameter(Mandatory = $true)][string]$SourcePath)

    $workspacePrefix = $workspaceRoot.TrimEnd("\") + "\"
    if (-not $SourcePath.StartsWith($workspacePrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "TEST DEPENDENCY MISSING: source must be inside workspace: $SourcePath"
    }

    $relative = $SourcePath.Substring($workspacePrefix.Length).Replace("\", "/")
    return "//! import `"../$relative`""
}

function Assert-TestLibraryDependencies {
    param([Parameter(Mandatory = $true)][System.IO.FileInfo[]]$SourceFiles)

    $providers = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
    $required = New-Object 'System.Collections.Generic.List[string]'

    foreach ($sourceFile in $SourceFiles) {
        $text = [string](Get-Content -LiteralPath $sourceFile.FullName -Raw -Encoding UTF8)
        foreach ($match in [regex]::Matches($text, '(?im)^\s*(?:library|scope)\s+([A-Za-z_][A-Za-z0-9_]*)\b([^\r\n]*)')) {
            [void]$providers.Add($match.Groups[1].Value)
            $tail = ($match.Groups[2].Value -replace '//.*$', '')
            $dependencyMatch = [regex]::Match($tail, '(?i)\b(?:requires|uses|needs)\b\s+(.+?)(?=\binitializer\b|$)')
            if (-not $dependencyMatch.Success) {
                continue
            }
            foreach ($dependency in ($dependencyMatch.Groups[1].Value -split ',')) {
                $name = $dependency.Trim()
                if ($name -match '(?i)^optional\s+(.+)$') {
                    continue
                }
                if ($name -match '^([A-Za-z_][A-Za-z0-9_]*)$') {
                    $required.Add($Matches[1])
                }
            }
        }
    }

    foreach ($dependency in ($required | Sort-Object -Unique)) {
        if (-not $providers.Contains($dependency)) {
            throw "TEST DEPENDENCY MISSING: $dependency"
        }
    }
}

try {
    Require-File -Path $configPath -Name "Build configuration"
    $config = Get-Content -LiteralPath $configPath -Raw -Encoding UTF8 | ConvertFrom-Json

    $gameExe = Resolve-WorkspacePath ([string]$config.gameExe)
    $jassHelper = Resolve-WorkspacePath ([string]$config.jassHelper)
    $commonJ = Resolve-WorkspacePath ([string]$config.commonJ)
    $blizzardJ = Resolve-WorkspacePath ([string]$config.blizzardJ)
    $buildDir = Resolve-WorkspacePath ([string]$config.buildDir)

    Require-File -Path $gameExe -Name "Warcraft III executable"
    Require-File -Path $jassHelper -Name "JassHelper executable"
    Require-File -Path $commonJ -Name "common.j"
    Require-File -Path $blizzardJ -Name "Blizzard.j"
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null

    if ($Target -eq "Test") {
        $testHero = [string]$config.testHero
        if ([string]::IsNullOrWhiteSpace($testHero) -or [System.IO.Path]::GetFileName($testHero) -ne $testHero) {
            throw "Invalid testHero in: $configPath"
        }

        $testMapsDir = Resolve-WorkspacePath ([string]$config.testMapsDir)
        $testBaseSource = Resolve-WorkspacePath ([string]$config.testBaseSource)
        $originalMap = [System.IO.Path]::GetFullPath((Join-Path $testMapsDir "$testHero.w3x"))
        $outputName = "${testHero}_Test.w3x"
        $source = Join-Path $buildDir "TestCurrent.vj"

        Require-File -Path $originalMap -Name "Original TEST map"
        Require-File -Path $testBaseSource -Name "TEST base source"

        $heroDirectories = @($config.testHeroSourceDirs | ForEach-Object { [string]$_ })
        $selectedHeroSources = @(Get-SelectedHeroSources -Hero $testHero -SourceDirectories $heroDirectories)
        if ($selectedHeroSources.Count -eq 0) {
            throw "TEST DEPENDENCY MISSING: hero source '$testHero'"
        }

        $heroSources = @(Get-SourceFiles -ConfiguredPaths $heroDirectories)
        $sharedConfigured = @($config.sharedSources | ForEach-Object { [string]$_ })
        $sharedSources = if ($sharedConfigured.Count) { @(Get-SourceFiles -ConfiguredPaths $sharedConfigured) } else { @() }
        $dynamicSources = @($heroSources + $sharedSources | Sort-Object FullName -Unique)

        $selectedPaths = @($selectedHeroSources | ForEach-Object { $_.FullName })
        $activeImports = @(
            "// Active hero: $testHero"
            $selectedHeroSources | ForEach-Object { Get-WorkspaceImport $_.FullName }
            "// Other explicitly allowed TEST hero dependencies"
            $dynamicSources | Where-Object { $_.FullName -notin $selectedPaths } | ForEach-Object { Get-WorkspaceImport $_.FullName }
        ) -join "`r`n"

        $baseText = [System.IO.File]::ReadAllText($testBaseSource)
        $marker = "// __ACTIVE_HERO_SOURCE__"
        $firstMarker = $baseText.IndexOf($marker, [System.StringComparison]::Ordinal)
        $lastMarker = $baseText.LastIndexOf($marker, [System.StringComparison]::Ordinal)
        if ($firstMarker -lt 0 -or $firstMarker -ne $lastMarker) {
            throw "TEST base must contain exactly one active hero marker: $marker"
        }
        [System.IO.File]::WriteAllText($source, $baseText.Replace($marker, $activeImports), [System.Text.UTF8Encoding]::new($false))

        $importedFiles = @()
        $generatedText = [System.IO.File]::ReadAllText($source)
        foreach ($match in [regex]::Matches($generatedText, '(?im)^\s*//!\s*import\s+"([^"]+)"')) {
            $importedPath = [System.IO.Path]::GetFullPath((Join-Path $buildDir $match.Groups[1].Value))
            Require-File -Path $importedPath -Name "TEST imported source"
            $importedFiles += Get-Item -LiteralPath $importedPath
        }
        Assert-TestLibraryDependencies -SourceFiles @($importedFiles | Sort-Object FullName -Unique)

        $profileName = "TEST / $testHero"
        Write-Host "Selected hero source:" -ForegroundColor DarkGray
        $selectedHeroSources | ForEach-Object { Write-Host "  $($_.FullName)" -ForegroundColor DarkGray }
        Write-Host "Allowed hero dependency files: $($heroSources.Count)" -ForegroundColor DarkGray
    } else {
        $profileName = "MAIN"
        $originalMap = Resolve-WorkspacePath ([string]$config.mainMap)
        $source = Resolve-WorkspacePath ([string]$config.mainSource)
        $outputName = "WoS_Test.w3x"

        Require-File -Path $originalMap -Name "Original MAIN map"
        if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
            Write-Host "MAIN SOURCE NOT CREATED:" -ForegroundColor Red
            Write-Host $source -ForegroundColor Red
            exit 1
        }
    }

    $builtMap = [System.IO.Path]::GetFullPath((Join-Path $buildDir $outputName))
    if ($builtMap.Equals($originalMap, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Built map path must differ from the original map: $originalMap"
    }

    Write-Host "Selected profile: $profileName"
    Write-Host "Original map:     $originalMap"
    Write-Host "Source mapscript: $source"
    Write-Host "Built map:        $builtMap"

    Require-File -Path $source -Name "Profile mapscript"
    Require-File -Path $originalMap -Name "Original map"

    Copy-Item -LiteralPath $originalMap -Destination $builtMap -Force

    $sourceDirectory = Split-Path -Parent $source
    $jassHelperArguments = @(
        "`"$commonJ`"",
        "`"$blizzardJ`"",
        "`"$source`"",
        "`"$builtMap`""
    )

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
    Write-Host "Launching Warcraft III..." -ForegroundColor Cyan
    Start-Process `
        -FilePath $gameExe `
        -ArgumentList @("-launch", "-loadfile", "`"$builtMap`"") `
        -WorkingDirectory (Split-Path -Parent $gameExe)
    Write-Host "WARCRAFT STARTED" -ForegroundColor Green
} catch {
    Write-Host "BUILD FAILED" -ForegroundColor Red
    Write-Error $_.Exception.Message
    exit 1
}
