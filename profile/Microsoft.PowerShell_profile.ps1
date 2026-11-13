#Requires -Version 5.1
# PoshKit profile loader.

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
param()

try {
    [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding           = [System.Text.UTF8Encoding]::new($false)
    chcp 65001 > $null
}
catch {}

# The prompt draws the venv tag itself.
$env:VIRTUAL_ENV_DISABLE_PROMPT = '1'

# -Force makes reload pick up edits; -DisableNameChecking allows env and clip.
$moduleCandidates = @(
    (Join-Path $PSScriptRoot 'Modules')
    (Join-Path $HOME 'Documents/PowerShell/Modules')
    (Join-Path $HOME 'Documents/WindowsPowerShell/Modules')
)
$moduleRoot = $moduleCandidates |
    Where-Object { Test-Path -LiteralPath (Join-Path $_ 'PoshKit.Shell') } |
    Select-Object -First 1
if (-not $moduleRoot) { $moduleRoot = $moduleCandidates[0] }

$loadErrors = [System.Collections.Generic.List[string]]::new()
$loadModule = {
    param([string]$Name)

    try {
        Import-Module (Join-Path $moduleRoot "$Name\$Name.psm1") -Global -Force -DisableNameChecking -ErrorAction Stop
    }
    catch {
        $loadErrors.Add("$Name : $($_.Exception.Message)")
    }
}

foreach ($name in 'PoshKit.Welcome', 'PoshKit.Shell', 'PoshKit.Files',
                  'PoshKit.System', 'PoshKit.Tools') {
    & $loadModule $name
}

# Skip the banner when output is redirected or the host is not a console.
$isInteractiveConsole = ($Host.Name -eq 'ConsoleHost') -and
                        [Environment]::UserInteractive -and
                        (-not [Console]::IsOutputRedirected)

if ($isInteractiveConsole) {
    Clear-Host

    $fastfetchScript = Join-Path $HOME '.config/fastfetch/fastfetch-random.ps1'
    if ((Get-Command fastfetch -CommandType Application -ErrorAction SilentlyContinue) -and
        (Test-Path -LiteralPath $fastfetchScript)) {
        & $fastfetchScript
    }

    if (Get-Command Show-Welcome -ErrorAction SilentlyContinue) { Show-Welcome }
}

foreach ($err in $loadErrors) {
    Write-Warning "Profile: module failed to load: $err"
}

Remove-Variable moduleCandidates, moduleRoot, loadErrors, loadModule, name, err,
    isInteractiveConsole, fastfetchScript -ErrorAction SilentlyContinue

Set-Alias -Name vim -Value nvim

# Typing fastfetch runs the custom launcher. Real fastfetch options (--version, -s cpu...)
# still go straight to the executable; -Art and -Palette go to the launcher.
function fastfetch {
    $launcher = Join-Path $HOME '.config/fastfetch/fastfetch-random.ps1'
    $exe = Get-Command fastfetch -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1

    $useLauncher = (Test-Path -LiteralPath $launcher) -and
        ($args.Count -eq 0 -or $args[0] -in '-Art', '-Palette')

    if ($useLauncher) { & $launcher @args }
    elseif ($exe)     { & $exe.Source @args }
    else              { Write-Warning 'fastfetch was not found in PATH. Install it with: winget install fastfetch' }
}

# Re-run the profile; -Force module imports pick up edits.
function reload {
    $ESC     = [char]27
    $mauve   = "$ESC[38;2;203;166;247m"
    $overlay = "$ESC[38;2;108;112;134m"
    $bold    = "$ESC[1m"
    $reset   = "$ESC[0m"
    [Console]::WriteLine("  ${overlay}Reloading profile...${reset}")
    . $PROFILE
    [Console]::WriteLine("  ${mauve}${bold}*${reset}  ${overlay}Profile reloaded.${reset}")
}
