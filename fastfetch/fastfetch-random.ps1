#Requires -Version 5.1
<#
.SYNOPSIS
    Runs fastfetch with a random ASCII art logo and a random color palette.

.DESCRIPTION
    Picks a random .txt file from the "ascii" folder next to this script and one of the
    built-in palettes, then passes both to fastfetch as command line options. The base
    config.jsonc is never modified, so several terminals can start at the same time.

    Works in Windows PowerShell 5.1 and PowerShell 7+.

.PARAMETER Art
    Optional name (or part of a name) of an ASCII art file, for example "itachi".
    When omitted, a random file is used.

.PARAMETER Palette
    Optional name (or part of a name) of a palette, for example "nord".
    When omitted, a random palette is used.

.PARAMETER ConfigDir
    Folder containing config.jsonc and the "ascii" subfolder.
    Defaults to ~/.config/fastfetch.

.EXAMPLE
    .\fastfetch-random.ps1

.EXAMPLE
    .\fastfetch-random.ps1 -Art itachi -Palette dracula
#>
[CmdletBinding()]
param(
    [string]$Art,
    [string]$Palette,
    [string]$ConfigDir = (Join-Path $HOME '.config/fastfetch')
)

# Look up the real executable: the profile defines a fastfetch function that calls this script.
$fastfetchExe = Get-Command fastfetch -CommandType Application -ErrorAction SilentlyContinue |
    Select-Object -First 1
if (-not $fastfetchExe) {
    Write-Warning 'fastfetch was not found in PATH. Install it with: winget install fastfetch'
    return
}

$baseConfig = Join-Path $ConfigDir 'config.jsonc'
$asciiDir   = Join-Path $ConfigDir 'ascii'

# Each palette maps to the logo color slots $1 to $9 used inside the ASCII art files.
$palettes = @(
    @{ Name = 'Catppuccin Mocha'; Colors = '#F5E0DC', '#F2CDCD', '#F5C2E7', '#FAB387', '#F9E2AF', '#A6E3A1', '#94E2D5', '#89DCEB', '#74C7EC' }
    @{ Name = 'Catppuccin Latte'; Colors = '#DD7878', '#EA76CB', '#8839EF', '#E64553', '#FE640B', '#DF8E1D', '#40A02B', '#179299', '#1E66F5' }
    @{ Name = 'Dracula';          Colors = '#FF79C6', '#BD93F9', '#6272A4', '#FF5555', '#FFB86C', '#F1FA8C', '#50FA7B', '#8BE9FD', '#FF79C6' }
    @{ Name = 'Nord';             Colors = '#BF616A', '#D08770', '#EBCB8B', '#A3BE8C', '#B48EAD', '#88C0D0', '#81A1C1', '#5E81AC', '#8FBCBB' }
    @{ Name = 'Tokyo Night';      Colors = '#F7768E', '#FF9E64', '#E0AF68', '#9ECE6A', '#73DACA', '#2AC3DE', '#7DCFFF', '#BB9AF7', '#C0CAF5' }
    @{ Name = 'Gruvbox';          Colors = '#CC241D', '#98971A', '#D79921', '#458588', '#B16286', '#689D6A', '#D65D0E', '#FB4934', '#FABD2F' }
    @{ Name = 'Everforest';       Colors = '#E67E80', '#E69875', '#DBBC7F', '#A7C080', '#83C092', '#7FBBB3', '#D699B6', '#859289', '#9DA9A0' }
    @{ Name = 'Rose Pine';        Colors = '#EB6F92', '#F6C177', '#EBBCBA', '#31748F', '#9CCFD8', '#C4A7E7', '#E0DEF4', '#6E6A86', '#908CAA' }
)

# fastfetch expects logo colors on the command line as ANSI SGR parameters, not as hex.
function ConvertTo-FastfetchColor {
    param([Parameter(Mandatory)][string]$Hex)

    $value = $Hex.TrimStart('#')
    $r = [Convert]::ToInt32($value.Substring(0, 2), 16)
    $g = [Convert]::ToInt32($value.Substring(2, 2), 16)
    $b = [Convert]::ToInt32($value.Substring(4, 2), 16)
    "38;2;$r;$g;$b"
}

# The width of the box depends on the user and host names, so it cannot live in config.jsonc.
# This writes a copy of the config where the title module is replaced by a rounded box, and
# returns its path. Any failure returns $null and the caller falls back to the plain title.
# Box characters are built from code points so the script stays safe in Windows PowerShell 5.1,
# which reads a BOM-less file as ANSI.
function New-BoxedTitleConfig {
    param([Parameter(Mandatory)][string]$Path)

    try {
        $text   = (Get-Content -LiteralPath $Path -Raw -Encoding UTF8) -replace '(?m)^\s*//.*$', ''
        $config = $text | ConvertFrom-Json

        $title = $config.modules | Where-Object { $_ -isnot [string] -and $_.type -eq 'title' } |
            Select-Object -First 1
        if (-not $title) { return $null }

        $userColor = '38;2;245;194;231'
        $atColor   = '38;2;205;214;244'
        $hostColor = '38;2;137;220;235'
        if ($title.color) {
            if ($title.color.user) { $userColor = $title.color.user }
            if ($title.color.at)   { $atColor   = $title.color.at }
            if ($title.color.host) { $hostColor = $title.color.host }
        }

        $esc      = [char]27
        $reset    = "$esc[0m"
        $border   = "$esc[${userColor}m"
        $userName = [Environment]::UserName
        $hostName = [System.Net.Dns]::GetHostName()

        $h = [string][char]0x2500
        $v = [char]0x2502
        $pad = '  '
        $bar = $h * ($userName.Length + 1 + $hostName.Length + (2 * $pad.Length))

        $top = "$border$([char]0x256D)$bar$([char]0x256E)$reset"
        $mid = "$border$v$reset$pad$esc[${userColor}m$userName$esc[${atColor}m@$esc[${hostColor}m$hostName$reset$pad$border$v$reset"
        $bot = "$border$([char]0x2570)$bar$([char]0x256F)$reset"

        $modules = foreach ($module in $config.modules) {
            if ($module -is [string] -or $module.type -ne 'title') {
                $module
                continue
            }
            foreach ($line in $top, $mid, $bot) {
                [pscustomobject]@{ type = 'custom'; format = $line }
            }
        }
        $config.modules = @($modules)

        $tempPath = Join-Path ([IO.Path]::GetTempPath()) ("fastfetch-$([guid]::NewGuid().ToString('N')).jsonc")
        [IO.File]::WriteAllText($tempPath, ($config | ConvertTo-Json -Depth 10), [Text.UTF8Encoding]::new($false))
        $tempPath
    }
    catch {
        $null
    }
}

$fastfetchArgs = @()
$tempConfig = $null
if (Test-Path -LiteralPath $baseConfig) {
    $tempConfig = New-BoxedTitleConfig -Path $baseConfig
    $fastfetchArgs += @('--config', $(if ($tempConfig) { $tempConfig } else { $baseConfig }))
}
else {
    Write-Warning "Config not found: $baseConfig (using fastfetch defaults)"
}

$artFiles = @()
if (Test-Path -LiteralPath $asciiDir) {
    $artFiles = @(Get-ChildItem -LiteralPath $asciiDir -Filter '*.txt' -File)
}
if ($Art) {
    $matched = @($artFiles | Where-Object { $_.BaseName -like "*$Art*" })
    if ($matched.Count -eq 0) {
        Write-Warning "No ASCII art matches '$Art'. Using a random one."
    }
    else {
        $artFiles = $matched
    }
}

if ($artFiles.Count -eq 0) {
    Write-Warning "No .txt files found in $asciiDir (using the default fastfetch logo)"
}
else {
    $selectedArt = $artFiles | Get-Random

    $selectedPalette = $null
    if ($Palette) {
        $selectedPalette = $palettes | Where-Object { $_.Name -like "*$Palette*" } | Select-Object -First 1
        if (-not $selectedPalette) {
            Write-Warning "No palette matches '$Palette'. Using a random one."
        }
    }
    if (-not $selectedPalette) {
        $selectedPalette = $palettes | Get-Random
    }

    $fastfetchArgs += @('--logo', $selectedArt.FullName, '--logo-type', 'file')
    for ($i = 0; $i -lt 9; $i++) {
        $fastfetchArgs += @("--logo-color-$($i + 1)", (ConvertTo-FastfetchColor -Hex $selectedPalette.Colors[$i]))
    }
}

try {
    & $fastfetchExe.Source @fastfetchArgs
}
finally {
    if ($tempConfig) { Remove-Item -LiteralPath $tempConfig -Force -ErrorAction SilentlyContinue }
}
