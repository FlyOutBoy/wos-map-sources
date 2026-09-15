param(
    [Parameter(Mandatory = $true)]
    [string]$ActiveFile
)

$ErrorActionPreference = "Stop"

if (!(Test-Path -LiteralPath $ActiveFile)) {
    throw "File not found: $ActiveFile"
}

# Читаем исходник
$Text = [System.IO.File]::ReadAllText($ActiveFile)

# World Editor любит обычные Windows-переносы
$Text = $Text -replace "`r?`n", "`r`n"

# ANSI Cyrillic / Windows-1251
$Encoding = [System.Text.Encoding]::GetEncoding(1251)
$Bytes = $Encoding.GetBytes($Text)

# Нулевой байт в конце CF_TEXT
$Buffer = New-Object byte[] ($Bytes.Length + 1)
[Array]::Copy($Bytes, $Buffer, $Bytes.Length)

Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class WinClipboard
{
    [DllImport("user32.dll")]
    public static extern bool OpenClipboard(IntPtr hWndNewOwner);

    [DllImport("user32.dll")]
    public static extern bool CloseClipboard();

    [DllImport("user32.dll")]
    public static extern bool EmptyClipboard();

    [DllImport("user32.dll")]
    public static extern IntPtr SetClipboardData(uint uFormat, IntPtr hMem);

    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern IntPtr GlobalAlloc(uint uFlags, UIntPtr dwBytes);

    [DllImport("kernel32.dll")]
    public static extern IntPtr GlobalLock(IntPtr hMem);

    [DllImport("kernel32.dll")]
    public static extern bool GlobalUnlock(IntPtr hMem);
}
"@

$CF_TEXT = 1
$GMEM_MOVEABLE = 0x0002

$Memory = [WinClipboard]::GlobalAlloc(
    $GMEM_MOVEABLE,
    [UIntPtr]::new($Buffer.Length)
)

if ($Memory -eq [IntPtr]::Zero) {
    throw "GlobalAlloc failed"
}

$Pointer = [WinClipboard]::GlobalLock($Memory)

if ($Pointer -eq [IntPtr]::Zero) {
    throw "GlobalLock failed"
}

[Runtime.InteropServices.Marshal]::Copy(
    $Buffer,
    0,
    $Pointer,
    $Buffer.Length
)

[WinClipboard]::GlobalUnlock($Memory) | Out-Null

# Иногда clipboard занят другим приложением — делаем несколько попыток
$Opened = $false

for ($i = 0; $i -lt 10; $i++) {
    if ([WinClipboard]::OpenClipboard([IntPtr]::Zero)) {
        $Opened = $true
        break
    }

    Start-Sleep -Milliseconds 50
}

if (!$Opened) {
    throw "Could not open Windows clipboard"
}

try {
    [WinClipboard]::EmptyClipboard() | Out-Null

    $Result = [WinClipboard]::SetClipboardData(
        $CF_TEXT,
        $Memory
    )

    if ($Result -eq [IntPtr]::Zero) {
        throw "SetClipboardData failed"
    }
}
finally {
    [WinClipboard]::CloseClipboard() | Out-Null
}

Write-Host ""
Write-Host "COPIED FOR WORLD EDITOR" -ForegroundColor Green
Write-Host $ActiveFile -ForegroundColor DarkGray
Write-Host "Encoding: Windows-1251 / ANSI CF_TEXT"