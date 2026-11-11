#Requires -Version 5.1
$ErrorActionPreference = 'Stop'
$root   = Resolve-Path (Join-Path $PSScriptRoot '../..')
$failed = $false

function Write-Failure {
    param([string]$Message)
    Write-Host "FAIL: $Message"
    $script:failed = $true
}

$scripts = Get-ChildItem -Path $root -Recurse -Force -File |
    Where-Object {
        $_.Extension -in '.ps1', '.psm1' -and
        $_.FullName -notmatch '[\\/]\.git[\\/]'
    }

foreach ($file in $scripts) {
    $tokens = $null
    $errors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$errors)
    if ($errors) {
        foreach ($e in $errors) { Write-Failure "$($file.Name):$($e.Extent.StartLineNumber) $($e.Message)" }
    }
    else {
        Write-Host "ok parse  $($file.Name)"
    }

    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    if ($bytes | Where-Object { $_ -gt 127 } | Select-Object -First 1) {
        Write-Failure "$($file.Name) contains non-ASCII characters"
    }
}

# JSONC comment lines are stripped before parsing.
foreach ($path in @('windows-terminal/settings.json', 'fastfetch/config.jsonc')) {
    $full = Join-Path $root $path
    try {
        $text = (Get-Content -LiteralPath $full -Raw -Encoding UTF8) -replace '(?m)^\s*//.*$', ''
        [void]($text | ConvertFrom-Json)
        Write-Host "ok json   $path"
    }
    catch {
        Write-Failure "$path is not valid JSON: $($_.Exception.Message)"
    }
}

foreach ($art in Get-ChildItem -Path (Join-Path $root 'fastfetch/ascii') -Filter '*.txt' -File) {
    if ($art.Name -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*\.txt$') {
        Write-Failure "ASCII art file name must be lowercase kebab-case: $($art.Name)"
    }
}

if ($failed) { exit 1 }
Write-Host 'All checks passed.'
