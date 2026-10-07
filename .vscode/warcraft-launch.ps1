function Get-WarcraftLaunchArguments {
    param($Config, [string]$Map, [string]$EditorLog)
    $arguments = @('-launch')
    $editor = $Config.useEditorLaunch -ne $false
    if ($editor) { $arguments += '-editor' }
    $arguments += @('-loadfile', ('"' + $Map + '"'))
    if ($editor) {
        $profile = [string]$Config.testMapProfile
        $previous = ''
        if ($EditorLog -and (Test-Path -LiteralPath $EditorLog -PathType Leaf)) {
            $previous = [IO.File]::ReadAllText($EditorLog)
        }
        if (-not $profile -and $previous -match '-testmapprofile\s+(?:"([^"]+)"|(\S+))') {
            $profile = if ($Matches[1]) { $Matches[1] } else { $Matches[2] }
        }
        if ($profile) { $arguments += @('-testmapprofile', ('"' + $profile + '"')) }
        $arguments += @('-mapdiff', '0', '-fixedseed', '0')
        if ($previous -match '(?:^|\s)-hd\s+([01])\b') { $arguments += @('-hd', $Matches[1]) }
    }
    return $arguments
}
