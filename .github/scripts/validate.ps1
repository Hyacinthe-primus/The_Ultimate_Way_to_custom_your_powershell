#Requires -Version 5.1
<#
.SYNOPSIS
    Static checks run by CI (and runnable locally): syntax, encoding, JSON validity.
#>
$ErrorActionPreference = 'Stop'
$root   = Resolve-Path (Join-Path $PSScriptRoot '../..')
$failed = $false

function Write-Failure {
    param([string]$Message)
    Write-Host "FAIL: $Message"
    $script:failed = $true
}

# 1. Every PowerShell script must parse without errors
$scripts = Get-ChildItem -Path $root -Recurse -Force -Filter '*.ps1' -File |
    Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' }

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

    # 2. Scripts must stay pure ASCII so Windows PowerShell 5.1 never mis-decodes them
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    if ($bytes | Where-Object { $_ -gt 127 } | Select-Object -First 1) {
        Write-Failure "$($file.Name) contains non-ASCII characters"
    }
}

# 3. JSON files must be valid (JSONC comment lines are stripped before parsing)
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

# 4. ASCII art files must use lowercase kebab-case names
foreach ($art in Get-ChildItem -Path (Join-Path $root 'fastfetch/ascii') -Filter '*.txt' -File) {
    if ($art.Name -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*\.txt$') {
        Write-Failure "ASCII art file name must be lowercase kebab-case: $($art.Name)"
    }
}

if ($failed) { exit 1 }
Write-Host 'All checks passed.'
