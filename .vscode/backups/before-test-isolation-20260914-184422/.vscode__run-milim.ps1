$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot

# =============================
# PATHS
# =============================

$JassHelper = "E:\WAR3REF\Warcraft III\_retail_\x86_64\JassHelper\jasshelper.exe"

$Game = "E:\WAR3REF\Warcraft III\_retail_\x86_64\Warcraft III.exe"

$Common = Join-Path $Root "libs\common.j"
$Blizzard = Join-Path $Root "libs\Blizzard.j"

# Полный внешний исходник карты
$MapScript = Join-Path $Root "map_source\Milim.vj"

# ОРИГИНАЛ КАРТЫ — НЕ ТРОГАЕМ
$OriginalMap = "C:\Users\Gear\Documents\Warcraft III\Maps\WoS\Heroes\Milim.w3x"

# Запускаем всегда отдельную тестовую копию
$TestDir = "C:\Users\Gear\Documents\Warcraft III\Maps\Test"
$TestMap = Join-Path $TestDir "WOS_Milim_Test.w3x"


# =============================
# CHECKS
# =============================

foreach ($File in @(
    $JassHelper,
    $Game,
    $Common,
    $Blizzard,
    $MapScript,
    $OriginalMap
)) {
    if (!(Test-Path -LiteralPath $File -PathType Leaf)) {
        throw "FILE NOT FOUND: $File"
    }
}

if (!(Test-Path -LiteralPath $TestDir)) {
    New-Item `
        -ItemType Directory `
        -Path $TestDir `
        -Force | Out-Null
}


# =============================
# CREATE TEST MAP
# =============================

Write-Host ""
Write-Host "Creating test map..." -ForegroundColor Cyan

Copy-Item `
    -LiteralPath $OriginalMap `
    -Destination $TestMap `
    -Force

Write-Host "Test map:" -ForegroundColor DarkGray
Write-Host $TestMap -ForegroundColor DarkGray


# =============================
# JASSHELPER
# =============================

Write-Host ""
Write-Host "Compiling vJASS into test map..." -ForegroundColor Cyan

$Arguments = @(
    "`"$Common`"",
    "`"$Blizzard`"",
    "`"$MapScript`"",
    "`"$TestMap`""
)

$Process = Start-Process `
    -FilePath $JassHelper `
    -ArgumentList $Arguments `
    -WorkingDirectory (Split-Path -Parent $MapScript) `
    -Wait `
    -PassThru `
    -NoNewWindow

if ($Process.ExitCode -ne 0) {

    Write-Host ""
    Write-Host "COMPILE FAILED" -ForegroundColor Red

    exit $Process.ExitCode
}

Write-Host ""
Write-Host "COMPILE OK" -ForegroundColor Green


# =============================
# RUN WARCRAFT
# =============================

Write-Host ""
Write-Host "Launching Warcraft III..." -ForegroundColor Cyan

Start-Process `
    -FilePath $Game `
    -ArgumentList @(
        "-launch",
        "-loadfile",
        "`"$TestMap`""
    )

Write-Host ""
Write-Host "MILIM STARTED" -ForegroundColor Green