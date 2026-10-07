$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
. (Join-Path $Root '.vscode/jass-source-resolver.ps1')
$fixture = Join-Path $Root '_build/resolver-fixture'
New-Item -ItemType Directory -Path $fixture -Force | Out-Null
function Reset-Resolver {
    $script:SourceInfo = @{}
    $script:ProviderFiles = @{}
    $script:VisitState = @{}
    $script:ResolvedFiles = New-Object 'System.Collections.Generic.List[string]'
    $script:ActiveFamily = '_build'
    foreach ($file in (Get-ChildItem $fixture -Filter '*.j')) {
        $info = Read-SourceInfo $file.FullName
        $script:SourceInfo[$info.Path] = $info
        foreach ($provider in $info.Providers) { $script:ProviderFiles[$provider] = @($info.Path) }
    }
}
Set-Content (Join-Path $fixture 'Hero.j') "library Hero uses A`nendlibrary"
Set-Content (Join-Path $fixture 'A.j') "library A requires B`nendlibrary"
Set-Content (Join-Path $fixture 'B.j') "library B uses DmgSys`nendlibrary"
Set-Content (Join-Path $fixture 'DmgSys.j') "library DmgSys`nendlibrary"
Reset-Resolver
Visit-Source (Join-Path $fixture 'Hero.j')
$names = @($ResolvedFiles | ForEach-Object { [IO.Path]::GetFileNameWithoutExtension($_) }) -join ','
if ($names -ne 'DmgSys,B,A,Hero') { throw "Unexpected dependency closure: $names" }
Set-Content (Join-Path $fixture 'B.j') "library B uses Missing`nendlibrary"
Reset-Resolver
$failed = $false
try { Visit-Source (Join-Path $fixture 'Hero.j') } catch { $failed = $_.Exception.Message -like "Required dependency 'Missing'*" }
if (-not $failed) { throw 'Missing required dependency was accepted' }
Set-Content (Join-Path $fixture 'B.j') "library B uses Hero`nendlibrary"
Reset-Resolver
$failed = $false
try { Visit-Source (Join-Path $fixture 'Hero.j') } catch { $failed = $_.Exception.Message -like 'Dependency cycle*' }
if (-not $failed) { throw 'Dependency cycle was accepted' }
Reset-Resolver
$failed = $false
try { Visit-Source (Join-Path $fixture 'Unindexed.j') } catch { $failed = $_.Exception.Message -like 'Source was not indexed*' }
if (-not $failed) { throw 'Unindexed seed was accepted' }
Write-Host 'RESOLVER TESTS OK: transitive closure, missing dependency, cycle, unindexed seed'
