[CmdletBinding()]
param(
    [ValidateSet('Extract', 'Update', 'Pack')][string]$Mode,
    [Parameter(Mandatory = $true)][string]$Map,
    [Parameter(Mandatory = $true)][string]$Directory,
    [Parameter(Mandatory = $true)][string]$Library,
    [string]$NamesFile,
    [switch]$Lenient
)
$ErrorActionPreference = 'Stop'
if ($Mode -eq 'Update') {
    foreach ($name in @('war3map.wtg', 'war3map.wct')) {
        if (-not (Test-Path (Join-Path $Directory $name) -PathType Leaf)) { throw "TEST unpacked source missing: $name (run source import)" }
    }
}
# JassHelper already ships the 32-bit SFmpq library. No editor is started.
if ([IntPtr]::Size -ne 4) {
    $arguments = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $PSCommandPath, '-Mode', $Mode, '-Map', $Map, '-Directory', $Directory, '-Library', $Library)
    if ($NamesFile) { $arguments += @('-NamesFile', $NamesFile) }
    if ($Lenient) { $arguments += '-Lenient' }
    & "$env:WINDIR\SysWOW64\WindowsPowerShell\v1.0\powershell.exe" @arguments
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
    [DllImport("$dll")] public static extern bool SFileOpenFileEx(IntPtr archive, byte[] name, uint scope, out IntPtr file);
    [DllImport("$dll")] public static extern uint SFileGetFileSize(IntPtr file, IntPtr high);
    [DllImport("$dll")] public static extern bool SFileReadFile(IntPtr file, byte[] buffer, uint size, out uint read, IntPtr overlapped);
    [DllImport("$dll")] public static extern bool SFileCloseFile(IntPtr file);
    [DllImport("$dll", CharSet=CharSet.Ansi)] public static extern bool MpqAddFileToArchive(IntPtr archive, string source, string name, uint flags);
    [DllImport("$dll")] public static extern bool MpqAddFileFromBuffer(IntPtr archive, byte[] data, uint size, byte[] name, uint flags);
    [DllImport("$dll", CharSet=CharSet.Ansi)] public static extern IntPtr MpqOpenArchiveForUpdate(string name, uint flags, uint capacity);
    [DllImport("$dll")] public static extern uint MpqCloseUpdatedArchive(IntPtr archive, uint flags);
    [DllImport("$dll")] public static extern bool MpqCompactArchive(IntPtr archive);
}
"@
function Get-MpqNameBytes([string]$Name) {
    # Warcraft script/import strings and MPQ listfiles use UTF-8, not the local
    # Windows ANSI code page. Buffer writes also avoid ANSI source-path loss.
    return ,([Text.Encoding]::UTF8.GetBytes($Name + [char]0))
}
if ($Mode -eq 'Pack') {
    $root = [IO.Path]::GetFullPath($Directory).TrimEnd('\') + '\'
    $destination = [IO.Path]::GetFullPath($Map)
    if ($destination.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) { throw 'Archive output must be outside the source scenario folder.' }
    if ($NamesFile) {
        # Explicit repacks use only entries from the saved archive plus authorized
        # additions. Preserve opaque payloads too; never scan a stale unpack cache.
        $explicitNames = Get-Content -LiteralPath $NamesFile -Raw -Encoding UTF8 | ConvertFrom-Json
        $files = @($explicitNames | Sort-Object -Unique | ForEach-Object {
            $resolved = [IO.Path]::GetFullPath((Join-Path $root $_))
            if (-not $resolved.StartsWith($root, [StringComparison]::OrdinalIgnoreCase)) { throw "Unsafe pack entry: $_" }
            if ([IO.Path]::GetFileName($resolved) -in @('(listfile)', '(attributes)', '(signature)')) { throw "Reserved pack entry: $_" }
            if (-not (Test-Path -LiteralPath $resolved -PathType Leaf)) { throw "Missing pack entry: $_" }
            Get-Item -LiteralPath $resolved
        })
    } else {
        $files = @(Get-ChildItem -LiteralPath $Directory -File -Recurse | Where-Object { $_.Name -notin @('conversation.json', '(listfile)', '(attributes)', '(signature)') })
    }
    $capacity = 16
    while ($capacity -lt ($files.Count + 1)*2) { $capacity *= 2 }
    # CREATE_ALWAYS | MAINTAIN_LISTFILE; bundled SFmpq, same as Extract/Update.
    $archive = [TestMpq]::MpqOpenArchiveForUpdate($destination, 9, $capacity)
    if ($archive -eq [IntPtr]::Zero -or $archive -eq [IntPtr](-1)) { throw "Cannot create MPQ: $destination" }
    try {
        foreach ($item in $files) {
            $name = $item.FullName.Substring($root.Length)
            $payload = [IO.File]::ReadAllBytes($item.FullName)
            if (-not [TestMpq]::MpqAddFileFromBuffer($archive, $payload, $payload.Length, (Get-MpqNameBytes $name), 0x201)) { throw "Cannot pack $name" }
        }
        # SFmpq leaves slack after almost every compressed block (~50% of a
        # big map); compacting rewrites the blocks back to back.
        if (-not [TestMpq]::MpqCompactArchive($archive)) { throw "Cannot compact $destination" }
    } finally { [void][TestMpq]::MpqCloseUpdatedArchive($archive, 0) }
    # Warcraft's pre-archive header: use this scenario's W3I/WTS and player
    # count, never the template TEST map's title or metadata.
    $info = [IO.File]::ReadAllBytes((Join-Path $Directory 'war3map.w3i'))
    $version = [BitConverter]::ToInt32($info, 0)
    $offset = if ($version -ge 28) { 28 } else { 12 }
    $mapName = ''
    for ($index = 0; $index -lt 4; $index++) {
        $end = [Array]::IndexOf($info, [byte]0, $offset)
        if ($end -lt $offset) { throw 'Invalid W3I string data.' }
        if ($index -eq 0) { $mapName = [Text.Encoding]::UTF8.GetString($info, $offset, $end-$offset) }
        $offset = $end+1
    }
    $mapFlags = [BitConverter]::ToInt32($info, $offset+56)
    if ($mapName -match '^TRIGSTR_(\d+)$') {
        $number = [int]$Matches[1]
        $wts = Get-Content -LiteralPath (Join-Path $Directory 'war3map.wts') -Raw -Encoding UTF8
        $localized = [regex]::Match($wts, "(?ms)^STRING\s+0*$number\s*\r?\n\{\r?\n(.*?)\r?\n\}")
        if ($localized.Success) { $mapName = $localized.Groups[1].Value }
    }
    $script = Get-Content -LiteralPath (Join-Path $Directory 'war3map.j') -Raw -Encoding UTF8
    $players = [regex]::Match($script, 'call\s+SetPlayers\s*\(\s*(\d+)\s*\)')
    if (-not $players.Success) { throw 'Map script has no SetPlayers count for the archive header.' }
    $memory = [IO.MemoryStream]::new()
    $writer = [IO.BinaryWriter]::new($memory)
    $writer.Write([Text.Encoding]::ASCII.GetBytes('HM3W'))
    $writer.Write([int]0)
    $writer.Write([Text.Encoding]::UTF8.GetBytes($mapName))
    $writer.Write([byte]0)
    $writer.Write([int]$mapFlags)
    $writer.Write([int]$players.Groups[1].Value)
    if ($memory.Length -gt 512) { throw 'Map name exceeds Warcraft header capacity.' }
    $memory.SetLength(512)
    $mpqBytes = [IO.File]::ReadAllBytes($destination)
    $output = [IO.File]::Create($destination)
    try {
        $output.Write($memory.ToArray(), 0, 512)
        $output.Write($mpqBytes, 0, $mpqBytes.Length)
    } finally { $output.Dispose(); $writer.Dispose(); $memory.Dispose() }
    Write-Host "MPQ Pack OK: $($files.Count) files -> $destination"
    return
}
$handle = [IntPtr]::Zero
$flags = if ($Mode -eq 'Update') { 0x8000 } else { 0 }
if (-not [TestMpq]::SFileOpenArchive($Map, 0, $flags, [ref]$handle)) { throw "Cannot open MPQ: $Map" }
try {
    New-Item -ItemType Directory -Path $Directory -Force | Out-Null
    $names = @('war3map.j', 'war3map.wtg', 'war3map.wct')
    foreach ($prefix in @('war3map', 'war3mapSkin')) {
        foreach ($extension in @('w3u','w3t','w3b','w3d','w3a','w3h','w3q')) { $names += "$prefix.$extension" }
    }
    # Automatic updates touch native gameplay data only. Asset/import writes
    # require an explicit NamesFile supplied by a separate, authorized operation.
    if ($Mode -eq 'Extract') { $names += 'war3map.wts' }
    if ($NamesFile) { $names = Get-Content -LiteralPath $NamesFile -Raw -Encoding UTF8 | ConvertFrom-Json }
    foreach ($name in $names) {
        # SFmpq hashes Windows archive paths; JSON lists may use forward slashes.
        $name = ([string]$name).Replace('/', '\')
        $path = Join-Path $Directory $name
        $destinationRoot = [IO.Path]::GetFullPath($Directory).TrimEnd('\') + '\'
        $path = [IO.Path]::GetFullPath($path)
        if (-not $path.StartsWith($destinationRoot, [StringComparison]::OrdinalIgnoreCase)) { throw "Unsafe archive entry: $name" }
        if ($Mode -eq 'Update') {
            # The compiler replaces war3map.j after this step.
            if ($name -ne 'war3map.j' -and (Test-Path -LiteralPath $path -PathType Leaf)) {
                $payload = [IO.File]::ReadAllBytes($path)
                if (-not [TestMpq]::MpqAddFileFromBuffer($handle, $payload, $payload.Length, (Get-MpqNameBytes $name), 1)) { throw "Cannot replace $name in $Map" }
            }
            continue
        }
        $file = [IntPtr]::Zero
        if (-not [TestMpq]::SFileOpenFileEx($handle, (Get-MpqNameBytes $name), 0, [ref]$file)) {
            if ($NamesFile -and -not $Lenient) { throw "Requested archive entry is missing: $name" }
            continue
        }
        try {
            $size = [TestMpq]::SFileGetFileSize($file, [IntPtr]::Zero)
            $bytes = New-Object byte[] $size
            $read = [uint32]0
            if (-not [TestMpq]::SFileReadFile($file, $bytes, $size, [ref]$read, [IntPtr]::Zero) -or $read -ne $size) { throw "Cannot read $name" }
            New-Item -ItemType Directory -Path (Split-Path -Parent $path) -Force | Out-Null
            [IO.File]::WriteAllBytes($path, $bytes)
        } finally { [void][TestMpq]::SFileCloseFile($file) }
    }
} finally { [void][TestMpq]::SFileCloseArchive($handle) }
Write-Host "TEST MPQ $Mode OK: $Map"
