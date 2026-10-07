[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$workspace = Split-Path -Parent $PSScriptRoot
$log = Join-Path $workspace '_build/test-profile-selection.log'
New-Item -ItemType Directory -Path (Split-Path -Parent $log) -Force | Out-Null
$result = Join-Path $workspace '_build/test-profile-selection.txt'
$selector = Join-Path $workspace 'tools/test_map_profile.py'
$process = Start-Process -FilePath 'python' -ArgumentList ('"' + $selector + '"') -WindowStyle Hidden -Wait -PassThru -RedirectStandardOutput $result -RedirectStandardError $log
$selectionExitCode = $process.ExitCode
if ((Get-Item $log).Length -gt 0) { Get-Content $log | Out-Host }
if ($selectionExitCode -ne 0) { throw 'TEST profile selection failed' }
$profilePath = (Get-Content $result -Raw -Encoding UTF8).Trim()
return (Get-Content -LiteralPath $profilePath -Raw -Encoding UTF8 | ConvertFrom-Json)
