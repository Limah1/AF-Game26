$ErrorActionPreference = 'Stop'

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$errors = New-Object System.Collections.Generic.List[string]
$audioRoot = Join-Path $projectRoot 'src\Assets\Audio'
$audioExtensions = @('.wav', '.ogg', '.mp3')
$audioFiles = Get-ChildItem -LiteralPath $audioRoot -Recurse -File | Where-Object {
    $audioExtensions -contains $_.Extension.ToLowerInvariant()
}

if ($audioFiles.Count -lt 82) {
    $errors.Add("Expected at least 82 audio files, found $($audioFiles.Count).")
}

foreach ($file in $audioFiles) {
    if ($file.BaseName -cnotmatch '^[a-z0-9_]+$') {
        $errors.Add("Non-snake_case audio filename: $($file.FullName)")
    }
    if ($file.Length -eq 0) {
        $errors.Add("Empty audio file: $($file.FullName)")
    }
}

$busLayout = Get-Content -Raw (Join-Path $projectRoot 'default_bus_layout.tres')
foreach ($busName in @('Music', 'SFX', 'Voice')) {
    if ($busLayout -notmatch "name = `"$busName`"") {
        $errors.Add("Missing audio bus: $busName")
    }
}

$textFiles = Get-ChildItem -LiteralPath $projectRoot -Recurse -File -Include *.gd,*.tscn,*.tres,*.json,*.godot,*.import | Where-Object {
    $_.FullName -notlike "$projectRoot\.git\*" -and
    $_.FullName -notlike "$projectRoot\.import\*" -and
    $_.FullName -notlike "$projectRoot\android\build\*" -and
    $_.FullName -notlike "$projectRoot\build\*" -and
    $_.FullName -notlike "$projectRoot\tmp\*"
}

foreach ($file in $textFiles) {
    $content = [IO.File]::ReadAllText($file.FullName)
    if ($content -match 'res://assets/(sounds|hospital/[^/]+/audio|Plataforma/LofiHospital|voices)') {
        $errors.Add("Legacy audio path in $($file.FullName)")
    }
    if ($file.Extension -ne '.import') {
        foreach ($match in [regex]::Matches($content, 'res://[^"''\r\n\)\]]+\.(wav|ogg|mp3)(?=["''\r\n\)])')) {
            $resourcePath = Join-Path $projectRoot $match.Value.Substring(6).Replace('/', '\')
            if (!(Test-Path -LiteralPath $resourcePath)) {
                $errors.Add("Missing audio resource $($match.Value) in $($file.FullName)")
            }
        }
    }
}

$sceneFiles = Get-ChildItem -LiteralPath $projectRoot -Recurse -Filter '*.tscn' | Where-Object {
    $_.FullName -notlike "$projectRoot\build\*" -and $_.FullName -notlike "$projectRoot\tmp\*"
}
foreach ($file in $sceneFiles) {
    $content = [IO.File]::ReadAllText($file.FullName)
    foreach ($node in [regex]::Matches($content, '(?ms)^\[node [^\r\n]*type="AudioStreamPlayer(?:2D)?"[^\r\n]*\]\r?\n.*?(?=^\[|\z)')) {
        if ($node.Value -notmatch '(?m)^bus = "(Music|SFX|Voice)"\r?$') {
            $errors.Add("Audio node without a standard bus in $($file.FullName): $($node.Value.Split("`n")[0])")
        }
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Output "Audio validation passed: $($audioFiles.Count) files, standard buses, no legacy paths."
