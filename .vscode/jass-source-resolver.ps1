# Shared by the editor compiler and TEST build.
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
    if (-not $SourceInfo.ContainsKey($FullPath)) {
        throw "Source was not indexed for dependency resolution: $(Get-RelativeProjectPath $FullPath)"
    }
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

