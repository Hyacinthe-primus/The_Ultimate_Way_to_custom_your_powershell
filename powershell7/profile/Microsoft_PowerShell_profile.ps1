# PowerShell 7 Profile — Catppuccin Mocha Theme
# Requires: fastfetch, Nerd Font (e.g. JetBrainsMono Nerd Font)

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
param()

# ─────────────────────────────────────────
#  UTF-8 Encoding
# ─────────────────────────────────────────
try {
    [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    chcp 65001 > $null
} catch {}

Clear-Host

# ─────────────────────────────────────────
#  Fastfetch
# ─────────────────────────────────────────
# Optional: fastfetch system info display at startup
# If you use fastfetch, place your config at: ~/.config/fastfetch/
# and create a fastfetch-random.ps1 launcher, or replace this block.
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    $ffScript = "$env:USERPROFILE/.config/fastfetch/fastfetch-random.ps1"
    if (Test-Path $ffScript) { & $ffScript }
}

# ─────────────────────────────────────────
#  Load profile modules
# ─────────────────────────────────────────
$profileDir = "$PSScriptRoot\profile"

$modules = @(
    "colors",
    "helpers",
    "session",
    "aliases",
    "prompt",
    "welcome",
    "pokefetch",
    "animations",
    "errors"
)

foreach ($mod in $modules) {
    $path = "$profileDir\$mod.ps1"
    if (Test-Path $path) {
        . $path
    } else {
        Write-Host "  [profile] missing: $mod.ps1" -ForegroundColor DarkGray
    }
}
