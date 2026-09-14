param(
    [string]$ActiveFile,

    [string]$SourceRoot,

    [switch]$ResolveOnly
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$JassHelper = "E:\WAR3REF\Warcraft III\_retail_\x86_64\JassHelper\jasshelper.exe"
$Common = Join-Path $Root "libs\common.j"
$Blizzard = Join-Path $Root "libs\Blizzard.j"
$MapScript = Join-Path $Root "war3map.j"
$BuildDir = Join-Path $PSScriptRoot "build"
$InputFile = Join-Path $BuildDir "wos_compile_input.j"
$OutputFile = Join-Path $BuildDir "wos_compiled.j"
$MapGlobalsFile = Join-Path $BuildDir "wos_map_globals.j"

function Get-FullPath([string]$Path) {
    return [System.IO.Path]::GetFullPath($Path)
}

function Get-RelativeProjectPath([string]$Path) {
    $FullPath = Get-FullPath $Path
    if ($FullPath.StartsWith($Root, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $FullPath.Substring($Root.Length).TrimStart('\', '/')
    }
    return $FullPath
}

function Get-SourceFamily([string]$Path) {
    $Relative = Get-RelativeProjectPath $Path
    $Separator = $Relative.IndexOfAny(@([char]'\', [char]'/'))
    if ($Separator -lt 0) {
        return ""
    }
    return $Relative.Substring(0, $Separator)
}

function Read-SourceInfo([string]$Path) {
    $Text = [System.IO.File]::ReadAllText($Path)
    $WithoutBlockComments = [regex]::Replace(
        $Text,
        '/\*.*?\*/',
        '',
        [System.Text.RegularExpressions.RegexOptions]::Singleline
    )
    $WithoutComments = [regex]::Replace(
        $WithoutBlockComments,
        '(?m)//.*$',
        ''
    )

    $Providers = New-Object System.Collections.Generic.List[string]
    $ProviderPattern = '(?im)^\s*(?:library(?:_once)?|scope)\s+([A-Za-z_]\w*)'
    foreach ($Match in [regex]::Matches($WithoutComments, $ProviderPattern)) {
        $Providers.Add($Match.Groups[1].Value)
    }

    $DeclaredDependencies = New-Object System.Collections.Generic.List[object]
    $DependencyPattern = '(?im)^\s*(?:library(?:_once)?|scope)\s+[A-Za-z_]\w*(?:\s+initializer\s+[A-Za-z_]\w*)?\s+(requires|uses|needs)\s+([^\r\n]+)'
    foreach ($Match in [regex]::Matches($WithoutComments, $DependencyPattern)) {
        foreach ($RawItem in $Match.Groups[2].Value.Split(',')) {
            $Item = $RawItem.Trim()
            $Optional = $Item -match '^(?i:optional)\s+'
            $Name = [regex]::Replace($Item, '^(?i:optional)\s+', '')
            $NameMatch = [regex]::Match($Name, '^[A-Za-z_]\w*')
            if ($NameMatch.Success) {
                $DeclaredDependencies.Add([pscustomobject]@{
                    Name = $NameMatch.Value
                    Optional = $Optional
                })
            }
        }
    }

    return [pscustomobject]@{
        Path = Get-FullPath $Path
        Providers = $Providers
        Dependencies = $DeclaredDependencies
    }
}

function Select-Provider([string]$Name, [string]$PreferredFamily) {
    if (!$ProviderFiles.ContainsKey($Name)) {
        return $null
    }

    $Candidates = @($ProviderFiles[$Name])
    if ($Candidates.Count -eq 1) {
        return $Candidates[0]
    }

    $Preferred = @($Candidates | Where-Object {
        (Get-SourceFamily $_) -eq $PreferredFamily
    })
    if ($Preferred.Count -eq 1) {
        return $Preferred[0]
    }

    $Display = ($Candidates | ForEach-Object { Get-RelativeProjectPath $_ }) -join ', '
    throw "Multiple source files provide '$Name': $Display"
}

function Visit-Source([string]$Path) {
    $FullPath = Get-FullPath $Path
    if ($VisitState.ContainsKey($FullPath)) {
        if ($VisitState[$FullPath] -eq 1) {
            throw "Dependency cycle encountered while visiting $(Get-RelativeProjectPath $FullPath)"
        }
        return
    }

    $VisitState[$FullPath] = 1
    $Info = $SourceInfo[$FullPath]
    foreach ($Dependency in $Info.Dependencies) {
        $Provider = Select-Provider $Dependency.Name $ActiveFamily
        if ($null -eq $Provider) {
            if ($Dependency.Optional) {
                Write-Host "Optional dependency not found: $($Dependency.Name)" -ForegroundColor DarkGray
                continue
            }
            throw "Required dependency '$($Dependency.Name)' was not found for $(Get-RelativeProjectPath $FullPath)"
        }
        Visit-Source $Provider
    }

    $VisitState[$FullPath] = 2
    $ResolvedFiles.Add($FullPath)
}

function Write-GeneratedMapGlobals([string]$SourcePath, [string]$TargetPath) {
    if (!(Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
        return 0
    }

    $Lines = [System.IO.File]::ReadAllLines($SourcePath)
    $InsideGlobals = $false
    $Declarations = New-Object System.Collections.Generic.List[string]
    foreach ($Line in $Lines) {
        if (!$InsideGlobals) {
            if ($Line -match '^\s*globals\s*$') {
                $InsideGlobals = $true
            }
            continue
        }
        if ($Line -match '^\s*endglobals\s*$') {
            break
        }
        if ($Line -match '^\s*(?:constant\s+)?[A-Za-z_]\w*\s+(?:array\s+)?gg_[A-Za-z0-9_]+(?:\s*=.*)?$') {
            $Declarations.Add($Line)
        }
    }

    $Output = New-Object System.Collections.Generic.List[string]
    $Output.Add('// AUTO GENERATED FROM war3map.j - World Editor gg_* declarations only')
    $Output.Add('globals')
    foreach ($Declaration in $Declarations) {
        $Output.Add($Declaration)
    }
    $Output.Add('endglobals')
    $UTF8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllLines($TargetPath, $Output, $UTF8)
    return $Declarations.Count
}

foreach ($RequiredPath in @($JassHelper, $Common, $Blizzard)) {
    if (!(Test-Path -LiteralPath $RequiredPath -PathType Leaf)) {
        throw "Required file not found: $RequiredPath"
    }
}

if ([string]::IsNullOrWhiteSpace($ActiveFile) -and [string]::IsNullOrWhiteSpace($SourceRoot)) {
    throw 'Specify either -ActiveFile or -SourceRoot'
}

$ActiveFullPath = $null
$SourceRootFullPath = $null
if (![string]::IsNullOrWhiteSpace($SourceRoot)) {
    if (!(Test-Path -LiteralPath $SourceRoot -PathType Container)) {
        throw "Source root not found: $SourceRoot"
    }
    $SourceRootFullPath = (Get-FullPath $SourceRoot).TrimEnd('\', '/')
    $ActiveFamily = Get-SourceFamily (Join-Path $SourceRootFullPath '_source.j')
    $TargetDescription = Get-RelativeProjectPath $SourceRootFullPath
}
else {
    if (!(Test-Path -LiteralPath $ActiveFile -PathType Leaf)) {
        throw "Active file not found: $ActiveFile"
    }
    $ActiveFullPath = Get-FullPath $ActiveFile
    $ActiveFamily = Get-SourceFamily $ActiveFullPath
    $TargetDescription = Get-RelativeProjectPath $ActiveFullPath
}

# Discover every project JASS source. Generated output, Warcraft API stubs, and the
# compiled map script are excluded; no dependency filename list is maintained here.
$CandidateFiles = Get-ChildItem -LiteralPath $Root -Recurse -File | Where-Object {
    $_.Extension -in @('.j', '.jass')
} | ForEach-Object {
    $_.FullName
} | Where-Object {
    $Relative = Get-RelativeProjectPath $_
    $Relative -notmatch '^(?i)(libs|\.vscode|\.git)[\\/]' -and
    $Relative -notmatch '^(?i)war3map\.j$'
}

if (($null -ne $ActiveFullPath) -and ($CandidateFiles -notcontains $ActiveFullPath)) {
    $CandidateFiles = @($CandidateFiles) + $ActiveFullPath
}

$SourceInfo = @{}
$ProviderFiles = @{}
foreach ($File in $CandidateFiles) {
    $Info = Read-SourceInfo $File
    $SourceInfo[$Info.Path] = $Info
    foreach ($Provider in $Info.Providers) {
        if (!$ProviderFiles.ContainsKey($Provider)) {
            $ProviderFiles[$Provider] = New-Object System.Collections.Generic.List[string]
        }
        $ProviderFiles[$Provider].Add($Info.Path)
    }
}

$VisitState = @{}
$ResolvedFiles = New-Object System.Collections.Generic.List[string]

# Preserve WTG order as the stable tie-breaker for sources which have no declared
# relationship. Visit-Source still places every declared dependency first.
$SourceOrder = @{}
$TriggerManifest = Join-Path $Root 'triggers\trigger-manifest.json'
if (Test-Path -LiteralPath $TriggerManifest -PathType Leaf) {
    $Manifest = Get-Content -LiteralPath $TriggerManifest -Raw | ConvertFrom-Json
    foreach ($Entry in $Manifest.sources) {
        $ManifestPath = Get-FullPath (Join-Path (Join-Path $Root 'triggers') $Entry.path)
        $SourceOrder[$ManifestPath] = [int]$Entry.order
    }
}

$FamilyFiles = @($CandidateFiles | Where-Object {
    if ($null -ne $SourceRootFullPath) {
        $FullPath = Get-FullPath $_
        $FullPath.StartsWith($SourceRootFullPath + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)
    }
    else {
        (Get-SourceFamily $_) -eq $ActiveFamily
    }
} | Sort-Object `
    @{ Expression = {
        $FullPath = Get-FullPath $_
        if ($SourceOrder.ContainsKey($FullPath)) { $SourceOrder[$FullPath] } else { [int]::MaxValue }
    } }, `
    @{ Expression = { Get-RelativeProjectPath $_ } })

if ($FamilyFiles.Count -eq 0) {
    throw "No JASS source files found for $TargetDescription"
}

# Compile the complete source family, not only the active library's explicit
# dependency chain. World Editor does the same; many legacy triggers share globals
# without declaring a vJASS requires/uses/needs edge.
foreach ($File in $FamilyFiles) {
    Visit-Source $File
}

if (!(Test-Path -LiteralPath $BuildDir)) {
    New-Item -ItemType Directory -Path $BuildDir | Out-Null
}
if (Test-Path -LiteralPath $OutputFile) {
    Remove-Item -LiteralPath $OutputFile -Force
}

$Lines = New-Object System.Collections.Generic.List[string]
$Lines.Add('// AUTO GENERATED - WOS VS CODE COMPILER')
$Lines.Add('// Complete source tree; dependencies first, WTG order as stable fallback.')
$Lines.Add('')
$GeneratedGlobalCount = Write-GeneratedMapGlobals $MapScript $MapGlobalsFile
if ($GeneratedGlobalCount -gt 0) {
    $Lines.Add('//! import "' + $MapGlobalsFile + '"')
    Write-Host "Import: .vscode\build\wos_map_globals.j ($GeneratedGlobalCount World Editor globals)" -ForegroundColor DarkGray
}
foreach ($File in $ResolvedFiles) {
    $Lines.Add('//! import "' + $File + '"')
    Write-Host "Import: $(Get-RelativeProjectPath $File)" -ForegroundColor DarkGray
}
$Lines.Add('')
$Lines.Add('function config takes nothing returns nothing')
$Lines.Add('endfunction')
$Lines.Add('')
$Lines.Add('function main takes nothing returns nothing')
$Lines.Add('endfunction')

$UTF8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($InputFile, $Lines, $UTF8)

Write-Host ""
Write-Host "WOS vJASS compile (automatic dependencies)" -ForegroundColor Cyan
Write-Host "Source tree: $TargetDescription"
Write-Host "Resolved sources: $($ResolvedFiles.Count)"
Write-Host ""

if ($ResolveOnly) {
    Write-Host "DEPENDENCY RESOLUTION OK" -ForegroundColor Green
    Write-Host $InputFile -ForegroundColor Green
    exit 0
}

$Arguments = @(
    '--scriptonly',
    "`"$Common`"",
    "`"$Blizzard`"",
    "`"$InputFile`"",
    "`"$OutputFile`""
)
$Process = Start-Process `
    -FilePath $JassHelper `
    -ArgumentList $Arguments `
    -WorkingDirectory (Split-Path -Parent $JassHelper) `
    -Wait `
    -PassThru

Write-Host ""
if ((Test-Path -LiteralPath $OutputFile) -and $Process.ExitCode -eq 0) {
    Write-Host "COMPILE OK" -ForegroundColor Green
    Write-Host $OutputFile -ForegroundColor Green
    exit 0
}

Write-Host "COMPILE FAILED (JassHelper exit code $($Process.ExitCode))" -ForegroundColor Red
exit 1
