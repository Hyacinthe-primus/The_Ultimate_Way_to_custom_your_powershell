#Requires -Version 5.1
<#
.SYNOPSIS
    Installs the Catppuccin Mocha PowerShell setup for the current user.

.DESCRIPTION
    Copies the PowerShell profile to $PROFILE (for the shell running this script) and the
    fastfetch files (config, launcher script, ASCII art) to ~/.config/fastfetch.
    Existing files that differ from the new ones are backed up first
    (<name>.bak-<yyyyMMdd-HHmmss>). Nothing is deleted.

    Run it once in each shell you use (Windows PowerShell 5.1 and PowerShell 7), because
    each one has its own profile location.

.PARAMETER IncludeTerminalSettings
    Also replace the Windows Terminal settings.json with the one from this repository.
    Off by default because it overwrites your current Windows Terminal configuration
    (a backup is created first).

.EXAMPLE
    .\install.ps1

.EXAMPLE
    .\install.ps1 -WhatIf

.EXAMPLE
    .\install.ps1 -IncludeTerminalSettings
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$IncludeTerminalSettings
)

$ErrorActionPreference = 'Stop'

$repoRoot     = $PSScriptRoot
$profileDest  = $PROFILE.CurrentUserCurrentHost
$fastfetchDir = Join-Path $HOME '.config/fastfetch'

function Install-File {
    <#
    .SYNOPSIS
        Copies one file, backing up the destination first when its content differs.
    #>
    param(
        [Parameter(Mandatory)][string]$Source,
        [Parameter(Mandatory)][string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Source file not found: $Source"
    }

    $destinationDir = Split-Path -Parent $Destination
    if (-not (Test-Path -LiteralPath $destinationDir)) {
        if ($PSCmdlet.ShouldProcess($destinationDir, 'Create directory')) {
            New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
        }
    }

    if (Test-Path -LiteralPath $Destination) {
        $sourceHash      = (Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash
        $destinationHash = (Get-FileHash -LiteralPath $Destination -Algorithm SHA256).Hash
        if ($sourceHash -eq $destinationHash) {
            Write-Host "  unchanged  $Destination"
            return
        }

        $backup = '{0}.bak-{1}' -f $Destination, (Get-Date -Format 'yyyyMMdd-HHmmss')
        if ($PSCmdlet.ShouldProcess($Destination, "Back up to $backup")) {
            Copy-Item -LiteralPath $Destination -Destination $backup
            Write-Host "  backup     $backup"
        }
    }

    if ($PSCmdlet.ShouldProcess($Destination, 'Install file')) {
        Copy-Item -LiteralPath $Source -Destination $Destination -Force
        # Files downloaded from the internet carry a "blocked" flag that RemoteSigned rejects.
        try {
            Unblock-File -LiteralPath $Destination -ErrorAction Stop
        }
        catch {
            # Not supported on this platform, or the file is not blocked. Nothing to do.
            Write-Verbose "Unblock-File skipped for ${Destination}: $($_.Exception.Message)"
        }
        Write-Host "  installed  $Destination"
    }
}

Write-Host ''
Write-Host "Installing for PowerShell $($PSVersionTable.PSVersion) ($($Host.Name))"
Write-Host ''

# 1. PowerShell profile
Write-Host 'PowerShell profile'
Install-File -Source (Join-Path $repoRoot 'profile/Microsoft.PowerShell_profile.ps1') -Destination $profileDest

# 2. fastfetch config, launcher and ASCII art
Write-Host ''
Write-Host 'fastfetch files'
Install-File -Source (Join-Path $repoRoot 'fastfetch/config.jsonc')            -Destination (Join-Path $fastfetchDir 'config.jsonc')
Install-File -Source (Join-Path $repoRoot 'fastfetch/fastfetch-random.ps1')    -Destination (Join-Path $fastfetchDir 'fastfetch-random.ps1')
foreach ($art in Get-ChildItem -LiteralPath (Join-Path $repoRoot 'fastfetch/ascii') -Filter '*.txt' -File) {
    Install-File -Source $art.FullName -Destination (Join-Path $fastfetchDir "ascii/$($art.Name)")
}

# 3. Windows Terminal settings (opt-in)
if ($IncludeTerminalSettings) {
    Write-Host ''
    Write-Host 'Windows Terminal settings'

    $terminalDirs = @(
        (Join-Path $env:LOCALAPPDATA 'Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState')
        (Join-Path $env:LOCALAPPDATA 'Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState')
        (Join-Path $env:LOCALAPPDATA 'Microsoft/Windows Terminal')
    )
    $terminalDir = $terminalDirs | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

    if ($terminalDir) {
        Install-File -Source (Join-Path $repoRoot 'windows-terminal/settings.json') -Destination (Join-Path $terminalDir 'settings.json')
    }
    else {
        Write-Warning 'Windows Terminal settings folder not found. Copy windows-terminal/settings.json manually.'
    }
}

# 4. Dependency hints (informational only)
Write-Host ''
if (-not (Get-Command fastfetch -ErrorAction SilentlyContinue)) {
    Write-Warning 'fastfetch is not installed or not in PATH. Install it with: winget install fastfetch'
}
Write-Host 'Done. Install "JetBrainsMono Nerd Font" if needed, then restart your terminal.'
Write-Host ''
