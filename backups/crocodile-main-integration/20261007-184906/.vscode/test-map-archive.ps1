[CmdletBinding()]
param(
    [ValidateSet('Extract', 'Update')][string]$Mode,
    [Parameter(Mandatory = $true)][string]$Map,
    [Parameter(Mandatory = $true)][string]$Directory,
    [Parameter(Mandatory = $true)][string]$Library
)
$ErrorActionPreference = 'Stop'
if ($Mode -eq 'Update') {
    foreach ($name in @('war3map.wtg', 'war3map.wct')) {
        if (-not (Test-Path (Join-Path $Directory $name) -PathType Leaf)) { throw "TEST unpacked source missing: $name (run source import)" }
    }
}
# JassHelper already ships the 32-bit SFmpq library. No editor is started.
if ([IntPtr]::Size -ne 4) {
    & "$env:WINDIR\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath -Mode $Mode -Map $Map -Directory $Directory -Library $Library
    if ($LASTEXITCODE -ne 0) { throw "MPQ $Mode failed ($LASTEXITCODE)" }
    return
}
$dll = [IO.Path]::GetFullPath($Library).Replace('\', '\\')
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class TestMpq {
    [DllImport("$dll", CharSet=CharSet.Ansi, SetLastError=true)] public static extern bool SFileOpenArchive(string name, uint priority, uint flags, out IntPtr handle);
    [DllImport("$dll")] public static extern bool SFileCloseArchive(IntPtr handle);
    [DllImport("$dll", CharSet=CharSet.Ansi)] public static extern bool SFileOpenFileEx(IntPtr archive, string name, uint scope, out IntPtr file);
    [DllImport("$dll")] public static extern uint SFileGetFileSize(IntPtr file, IntPtr high);
    [DllImport("$dll")] public static extern bool SFileReadFile(IntPtr file, byte[] buffer, uint size, out uint read, IntPtr overlapped);
    [DllImport("$dll")] public static extern bool SFileCloseFile(IntPtr file);
    [DllImport("$dll", CharSet=CharSet.Ansi)] public static extern bool MpqAddFileToArchive(IntPtr archive, string source, string name, uint flags);
}
"@
$handle = [IntPtr]::Zero
$flags = if ($Mode -eq 'Update') { 0x8000 } else { 0 }
if (-not [TestMpq]::SFileOpenArchive($Map, 0, $flags, [ref]$handle)) { throw "Cannot open MPQ: $Map" }
try {
    New-Item -ItemType Directory -Path $Directory -Force | Out-Null
    $names = @('war3map.j', 'war3map.wtg', 'war3map.wct')
    foreach ($prefix in @('war3map', 'war3mapSkin')) {
        foreach ($extension in @('w3u','w3t','w3b','w3d','w3a','w3h','w3q')) { $names += "$prefix.$extension" }
    }
    foreach ($name in $names) {
        $path = Join-Path $Directory $name
        if ($Mode -eq 'Update') {
            # The compiler replaces war3map.j after this step.
            if ($name -ne 'war3map.j' -and (Test-Path -LiteralPath $path -PathType Leaf)) {
                if (-not [TestMpq]::MpqAddFileToArchive($handle, $path, $name, 1)) { throw "Cannot replace $name in $Map" }
            }
            continue
        }
        $file = [IntPtr]::Zero
        if (-not [TestMpq]::SFileOpenFileEx($handle, $name, 0, [ref]$file)) { continue }
        try {
            $size = [TestMpq]::SFileGetFileSize($file, [IntPtr]::Zero)
            $bytes = New-Object byte[] $size
            $read = [uint32]0
            if (-not [TestMpq]::SFileReadFile($file, $bytes, $size, [ref]$read, [IntPtr]::Zero) -or $read -ne $size) { throw "Cannot read $name" }
            [IO.File]::WriteAllBytes($path, $bytes)
        } finally { [void][TestMpq]::SFileCloseFile($file) }
    }
} finally { [void][TestMpq]::SFileCloseArchive($handle) }
Write-Host "TEST MPQ $Mode OK: $Map"
