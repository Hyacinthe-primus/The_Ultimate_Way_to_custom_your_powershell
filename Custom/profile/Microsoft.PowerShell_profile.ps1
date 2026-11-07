#Requires -Version 5.1
<#
.SYNOPSIS
    Catppuccin Mocha PowerShell profile for Windows PowerShell 5.1 and PowerShell 7+.

.DESCRIPTION
    Provides a colored prompt, a welcome banner, a random fastfetch panel and a set
    of small utility commands (ll, touch, mkcd, show, whereis, cdh, hash, hex,
    weather, help).

    This file is intentionally pure ASCII. Every special character (box drawing,
    icons, emoji, Nerd Font glyphs) is built from its code point at runtime, so the
    file works in Windows PowerShell 5.1 without a UTF-8 BOM.

.NOTES
    Optional dependencies: fastfetch (system info panel), a Nerd Font (prompt icon).
    Project: https://github.com/Hyacinthe-primus
#>

# ----------------------------------------------------------------------------
# User settings: edit these values to customize the profile
# ----------------------------------------------------------------------------
$script:Settings = @{
    WeatherCity  = 'Sydney'
    BookmarkFile = Join-Path $HOME '.config/hyacinthe/bookmarks.json'
    FastfetchDir = Join-Path $HOME '.config/fastfetch'
}

# ----------------------------------------------------------------------------
# Console encoding
# ----------------------------------------------------------------------------
try {
    [Console]::InputEncoding  = New-Object System.Text.UTF8Encoding($false)
    [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
    $OutputEncoding           = New-Object System.Text.UTF8Encoding($false)
}
catch {
    # No console attached (redirected host, ISE, CI). Encoding is not critical here.
    Write-Verbose "Could not set console encoding: $($_.Exception.Message)"
}

# ----------------------------------------------------------------------------
# Theme: Catppuccin Mocha as 24-bit ANSI escape sequences
# ----------------------------------------------------------------------------
$script:Theme = @{
    Reset = "$([char]27)[0m"
    Bold  = "$([char]27)[1m"
}
$mochaHex = @{
    Pink     = 'F5C2E7'; Mauve    = 'CBA6F7'; Red      = 'F38BA8'
    Peach    = 'FAB387'; Yellow   = 'F9E2AF'; Green    = 'A6E3A1'
    Teal     = '94E2D5'; Sky      = '89DCEB'; Sapphire = '74C7EC'
    Blue     = '89B4FA'; Lavender = 'B4BEFE'; Overlay  = '6C7086'
}
foreach ($name in $mochaHex.Keys) {
    $hex = $mochaHex[$name]
    $r = [Convert]::ToInt32($hex.Substring(0, 2), 16)
    $g = [Convert]::ToInt32($hex.Substring(2, 2), 16)
    $b = [Convert]::ToInt32($hex.Substring(4, 2), 16)
    $script:Theme[$name] = "$([char]27)[38;2;$r;$g;${b}m"
}
Remove-Variable mochaHex, name, hex, r, g, b -ErrorAction SilentlyContinue

# Colors cycled through for path segments in the prompt
$script:PromptPalette = @(
    $script:Theme.Red, $script:Theme.Peach, $script:Theme.Yellow, $script:Theme.Green,
    $script:Theme.Sky, $script:Theme.Sapphire, $script:Theme.Blue, $script:Theme.Mauve,
    $script:Theme.Pink
)

# ----------------------------------------------------------------------------
# Glyphs (built from code points to keep this file ASCII only)
# ----------------------------------------------------------------------------
$script:Glyph = @{
    Diamond    = [string][char]0x25C6
    Star       = [string][char]0x2726
    Arrow      = [string][char]0x2192
    Dot        = [string][char]0x25CF
    Cross      = [string][char]0x2716
    Rule       = [string][char]0x2500
    Pointer    = [string][char]0x25B6
    Up         = [string][char]0x2191
    Down       = [string][char]0x2193
    MiddleDot  = [string][char]0x00B7
    Degree     = [string][char]0x00B0
    Chevron    = [string][char]0x00BB
    PromptIcon = [char]::ConvertFromUtf32(0xF0054)   # Nerd Font: nf-md-chevron_right
}

# ----------------------------------------------------------------------------
# Startup banner (interactive console sessions only)
# ----------------------------------------------------------------------------
$script:Quotes = @(
    "Code is like humor. When you have to explain it, it's bad."
    'First, solve the problem. Then, write the code.'
    'Simplicity is the ultimate sophistication.'
    'Programs must be written for people to read, not machines to execute.'
    'The best code is no code at all.'
    'Debugging is twice as hard as writing the code in the first place.'
    "If it works, don't touch it."
    'There is no place for magic in production code.'
    'Perfection is achieved when there is nothing left to remove.'
    'A good developer looks both ways before crossing a one-way street.'
)

function Show-Welcome {
    $t = $script:Theme
    $g = $script:Glyph
    $green = $t.Green; $yellow = $t.Yellow; $mauve = $t.Mauve
    $pink  = $t.Pink;  $peach  = $t.Peach;  $reset = $t.Reset

    $culture = [System.Globalization.CultureInfo]::GetCultureInfo('en-US')
    $now     = Get-Date
    $date    = $now.ToString('dddd, MMMM dd yyyy', $culture)
    $time    = $now.ToString('HH:mm')
    $quote   = $script:Quotes | Get-Random

    Write-Host ''
    Write-Host "  ${green}$($g.Diamond)${reset}  ${yellow}${date}${reset}  ${mauve}${time}${reset}"
    Write-Host "  ${pink}$($g.Star)${reset}  ${peach}${quote}${reset}"
    Write-Host ''
}

# Skip the banner when the output is redirected or the host is not a plain console
# (for example `pwsh -Command ...` captured by a script, or the VS Code extension host).
$isInteractiveConsole = ($Host.Name -eq 'ConsoleHost') -and
                        [Environment]::UserInteractive -and
                        (-not [Console]::IsOutputRedirected)

if ($isInteractiveConsole) {
    Clear-Host

    $fastfetchScript = Join-Path $script:Settings.FastfetchDir 'fastfetch-random.ps1'
    if ((Get-Command fastfetch -ErrorAction SilentlyContinue) -and (Test-Path -LiteralPath $fastfetchScript)) {
        & $fastfetchScript
    }

    Show-Welcome
}
Remove-Variable isInteractiveConsole, fastfetchScript -ErrorAction SilentlyContinue
Remove-Item Function:\Show-Welcome -ErrorAction SilentlyContinue

# ----------------------------------------------------------------------------
# Command reference (used by `help`)
# ----------------------------------------------------------------------------
$script:CommandReference = @(
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'll';      Description = 'Detailed file listing (includes hidden files)' }
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'touch';   Description = 'Create empty files or update their timestamp' }
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'mkcd';    Description = 'Create a directory and cd into it' }
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'show';    Description = 'Search files (-u user folder, -deep whole drive, -from path)' }
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'cdh';     Description = 'Directory bookmarks (save / jump / del)' }
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'hex';     Description = 'Hex dump of a file' }
    [pscustomobject]@{ Category = 'Tools';       Name = 'whereis'; Description = 'Find commands and installed apps (registry)' }
    [pscustomobject]@{ Category = 'Tools';       Name = 'hash';    Description = 'SHA256 / MD5 / SHA1 hash (-md5 -sha1 -text)' }
    [pscustomobject]@{ Category = 'Tools';       Name = 'weather'; Description = 'Terminal weather forecast (weather <city>)' }
    [pscustomobject]@{ Category = 'Tools';       Name = 'help';    Description = 'This command reference (help <keyword>)' }
)

# ----------------------------------------------------------------------------
# Navigation and files
# ----------------------------------------------------------------------------

# ll: detailed listing including hidden files.
function ll { Get-ChildItem -Force @args }

# touch: create empty files, or update the timestamp of existing ones.
#   touch notes.txt
#   touch a.txt b.txt
function touch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromRemainingArguments)]
        [string[]]$Path
    )

    foreach ($item in $Path) {
        if (Test-Path -LiteralPath $item) {
            (Get-Item -LiteralPath $item).LastWriteTime = Get-Date
        }
        else {
            New-Item -ItemType File -Path $item | Out-Null
        }
    }
}

# mkcd: create a directory (and parents) then move into it.
#   mkcd projects/new-app
function mkcd {
    [CmdletBinding()]
    param([Parameter(Mandatory, Position = 0)][string]$Dir)

    New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    Set-Location -LiteralPath $Dir
}

# show: file search.
#   show main.py              exact name in the current folder (names containing a dot)
#   show main                 every name containing "main" in the current folder
#   show .ps1                 every file with the .ps1 extension
#   show -u report.pdf        search the whole user profile
#   show -deep ntdll.dll      search the whole system drive (slow)
#   show -from D:\Projects x  search from a specific folder
function show {
    [CmdletBinding()]
    param(
        [switch]$u,
        [switch]$deep,
        [string]$from,
        [Parameter(Mandatory, Position = 0)]
        [string]$name
    )

    $t = $script:Theme
    $g = $script:Glyph
    $mauve = $t.Mauve; $pink = $t.Pink; $peach = $t.Peach; $yellow = $t.Yellow
    $green = $t.Green; $teal = $t.Teal; $sky = $t.Sky; $sapphire = $t.Sapphire
    $lavender = $t.Lavender; $red = $t.Red; $overlay = $t.Overlay
    $bold = $t.Bold; $reset = $t.Reset

    if ($from)      { $searchPath = $from }
    elseif ($u)     { $searchPath = $HOME }
    elseif ($deep)  { $searchPath = "$($env:SystemDrive)\" }
    else            { $searchPath = $PWD.Path }

    if (-not (Test-Path -LiteralPath $searchPath -PathType Container)) {
        Write-Host ''
        Write-Host "  ${red}$($g.Star)  Folder not found:${reset}  ${peach}$searchPath${reset}"
        Write-Host ''
        return
    }

    if ($name -match '^\.\w+$')  { $pattern = "*$name" }      # extension only
    elseif ($name -match '[.*?]') { $pattern = $name }        # explicit name or wildcard
    else                          { $pattern = "*$name*" }    # substring

    $rule = $g.Rule * 60
    Write-Host ''
    Write-Host "  ${mauve}${bold}$($g.Diamond) SHOW${reset}  ${overlay}searching for${reset} ${peach}${bold}$pattern${reset}  ${overlay}in${reset}  ${sky}$searchPath${reset}"
    Write-Host "  ${overlay}${rule}${reset}"

    $results = @(Get-ChildItem -LiteralPath $searchPath -Filter $pattern -Recurse -Force -ErrorAction SilentlyContinue)

    if ($results.Count -eq 0) {
        Write-Host ''
        Write-Host "  ${red}$($g.Star)${reset}  No files found for ${peach}$pattern${reset}"
        Write-Host ''
        return
    }

    Write-Host ''
    foreach ($file in $results) {
        if ($file.PSIsContainer)          { $size = "${teal}[dir]${reset}" }
        elseif ($file.Length -ge 1MB)     { $size = "${yellow}$([math]::Round($file.Length / 1MB, 2)) MB${reset}" }
        elseif ($file.Length -ge 1KB)     { $size = "${green}$([math]::Round($file.Length / 1KB, 2)) KB${reset}" }
        else                              { $size = "${lavender}$($file.Length) B${reset}" }

        $created  = $file.CreationTime.ToString('yyyy-MM-dd HH:mm')
        $modified = $file.LastWriteTime.ToString('yyyy-MM-dd HH:mm')

        Write-Host "  ${pink}$($g.Pointer)${reset} ${bold}$($file.FullName)${reset}"
        Write-Host "      ${overlay}size${reset}     $size"
        Write-Host "      ${overlay}created${reset}  ${sapphire}$created${reset}   ${overlay}modified${reset}  ${peach}$modified${reset}"
        Write-Host ''
    }

    Write-Host "  ${overlay}${rule}${reset}"
    Write-Host "  ${mauve}$($g.Diamond)${reset}  ${overlay}found${reset} ${peach}${bold}$($results.Count)${reset} ${overlay}result(s)${reset}"
    Write-Host ''
}

# ----------------------------------------------------------------------------
# Directory bookmarks
# ----------------------------------------------------------------------------

function Read-DirBookmark {
    $file      = $script:Settings.BookmarkFile
    $bookmarks = [ordered]@{}

    if (Test-Path -LiteralPath $file) {
        try {
            $raw = Get-Content -LiteralPath $file -Raw -Encoding UTF8 | ConvertFrom-Json
            if ($raw) {
                foreach ($property in $raw.PSObject.Properties) {
                    $bookmarks[$property.Name] = [string]$property.Value
                }
            }
        }
        catch {
            Write-Warning "Bookmark file is unreadable and will be ignored: $file ($($_.Exception.Message))"
        }
    }
    return $bookmarks
}

function Write-DirBookmark {
    param([Parameter(Mandatory)][System.Collections.IDictionary]$Bookmarks)

    $file = $script:Settings.BookmarkFile
    $dir  = Split-Path -Parent $file
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    $json = $Bookmarks | ConvertTo-Json
    [System.IO.File]::WriteAllText($file, $json, (New-Object System.Text.UTF8Encoding($false)))
}

# cdh: directory bookmarks.
#   cdh                  list bookmarks
#   cdh save             bookmark the current folder (named after the folder)
#   cdh save myproject   bookmark with a custom label
#   cdh myproject        jump to a bookmark
#   cdh del myproject    remove a bookmark
function cdh {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)][string]$Action = '',
        [Parameter(Position = 1)][string]$Label  = ''
    )

    $t = $script:Theme
    $g = $script:Glyph
    $mauve = $t.Mauve; $peach = $t.Peach; $green = $t.Green; $yellow = $t.Yellow
    $teal = $t.Teal; $red = $t.Red; $overlay = $t.Overlay
    $bold = $t.Bold; $reset = $t.Reset

    $bookmarks = Read-DirBookmark

    switch ($Action) {
        'save' {
            $key = if ($Label) { $Label } else { Split-Path -Path $PWD.Path -Leaf }
            if (-not $key -or $key -in @('save', 'del')) {
                Write-Host ''
                Write-Host "  ${red}$($g.Star)  Invalid bookmark name:${reset}  ${peach}$key${reset}"
                Write-Host ''
                return
            }
            $bookmarks[$key] = $PWD.Path
            Write-DirBookmark -Bookmarks $bookmarks
            Write-Host ''
            Write-Host "  ${green}$($g.Star)${reset}  ${overlay}Bookmarked:${reset}  ${yellow}${bold}$key${reset}  ${overlay}$($g.Arrow)${reset}  ${teal}$($PWD.Path)${reset}"
            Write-Host ''
            return
        }
        'del' {
            Write-Host ''
            if ($bookmarks.Contains($Label)) {
                $bookmarks.Remove($Label)
                Write-DirBookmark -Bookmarks $bookmarks
                Write-Host "  ${red}$($g.Star)${reset}  ${overlay}Removed:${reset}  ${peach}$Label${reset}"
            }
            else {
                Write-Host "  ${red}$($g.Star)  Bookmark not found:${reset}  ${peach}$Label${reset}"
            }
            Write-Host ''
            return
        }
        default {
            if ($Action -and $bookmarks.Contains($Action)) {
                $target = $bookmarks[$Action]
                Write-Host ''
                if (Test-Path -LiteralPath $target -PathType Container) {
                    Set-Location -LiteralPath $target
                    Write-Host "  ${mauve}$($g.Star)${reset}  ${overlay}Jumped to:${reset}  ${teal}$target${reset}"
                }
                else {
                    Write-Host "  ${red}$($g.Star)  Folder no longer exists:${reset}  ${teal}$target${reset}"
                }
                Write-Host ''
                return
            }
        }
    }

    # Default: list bookmarks
    Write-Host ''
    Write-Host "  ${mauve}${bold}$($g.Diamond) BOOKMARKS${reset}"
    Write-Host "  ${overlay}$($g.Rule * 52)${reset}"
    Write-Host ''
    if ($bookmarks.Count -eq 0) {
        Write-Host "  ${overlay}No bookmarks yet. Use:  ${reset}${peach}cdh save [label]${reset}"
    }
    else {
        foreach ($key in $bookmarks.Keys) {
            Write-Host "  ${yellow}${bold}$($key.PadRight(16))${reset}  ${teal}$($bookmarks[$key])${reset}"
        }
    }
    Write-Host ''
}

# ----------------------------------------------------------------------------
# Inspection tools
# ----------------------------------------------------------------------------

# hash: hash a file or a string (SHA256 by default) and copy the result to the clipboard.
#   hash file.exe
#   hash file.exe -md5
#   hash -text "hello"
function hash {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)][string]$Path = '',
        [switch]$md5,
        [switch]$sha1,
        [string]$text
    )

    $t = $script:Theme
    $g = $script:Glyph
    $mauve = $t.Mauve; $green = $t.Green; $teal = $t.Teal; $peach = $t.Peach
    $red = $t.Red; $overlay = $t.Overlay; $bold = $t.Bold; $reset = $t.Reset

    $algo = if ($md5) { 'MD5' } elseif ($sha1) { 'SHA1' } else { 'SHA256' }

    Write-Host ''
    Write-Host "  ${mauve}${bold}$($g.Diamond) HASH${reset}  ${overlay}algorithm${reset}  ${teal}$algo${reset}"
    Write-Host "  ${overlay}$($g.Rule * 60)${reset}"
    Write-Host ''

    $result = $null
    try {
        if ($PSBoundParameters.ContainsKey('text')) {
            $bytes  = [System.Text.Encoding]::UTF8.GetBytes($text)
            $stream = New-Object System.IO.MemoryStream (, $bytes)
            try     { $result = (Get-FileHash -InputStream $stream -Algorithm $algo).Hash.ToLower() }
            finally { $stream.Dispose() }
            Write-Host "  ${overlay}input   ${reset}  ${peach}$text${reset}"
            Write-Host "  ${overlay}$($algo.PadRight(8))${reset}  ${green}${bold}$result${reset}"
        }
        elseif ($Path -and (Test-Path -LiteralPath $Path -PathType Leaf)) {
            $result = (Get-FileHash -LiteralPath $Path -Algorithm $algo).Hash.ToLower()
            Write-Host "  ${overlay}file    ${reset}  ${peach}$Path${reset}"
            Write-Host "  ${overlay}$($algo.PadRight(8))${reset}  ${green}${bold}$result${reset}"
        }
        else {
            Write-Host "  ${red}$($g.Star)  Provide a file path or use -text 'string'${reset}"
        }

        if ($result) {
            try {
                Set-Clipboard -Value $result
                Write-Host ''
                Write-Host "  ${overlay}Copied to clipboard.${reset}"
            }
            catch {
                Write-Host ''
                Write-Host "  ${overlay}Clipboard unavailable, result not copied.${reset}"
            }
        }
    }
    catch {
        Write-Host "  ${red}$($g.Star)  Error: $($_.Exception.Message)${reset}"
    }
    Write-Host ''
}

# hex: hex dump of the first bytes of a file (only that part is read from disk).
#   hex file.bin
#   hex file.bin 512
function hex {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$File,
        [Parameter(Position = 1)][ValidateRange(1, [int]::MaxValue)][int]$Bytes = 256
    )

    $t = $script:Theme
    $g = $script:Glyph
    $mauve = $t.Mauve; $teal = $t.Teal; $yellow = $t.Yellow; $red = $t.Red
    $overlay = $t.Overlay; $bold = $t.Bold; $reset = $t.Reset

    # .NET APIs resolve relative paths against the process directory, not $PWD.
    $fullPath = $PSCmdlet.GetUnresolvedProviderPathFromPSPath($File)

    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        Write-Host ''
        Write-Host "  ${red}$($g.Star)  File not found: $fullPath${reset}"
        Write-Host ''
        return
    }

    $length = (Get-Item -LiteralPath $fullPath).Length
    $count  = [int][math]::Min([long]$Bytes, $length)
    $buffer = New-Object byte[] $count

    if ($count -gt 0) {
        $stream = [System.IO.File]::Open($fullPath, 'Open', 'Read', 'ReadWrite')
        try {
            $read = 0
            while ($read -lt $count) {
                $n = $stream.Read($buffer, $read, $count - $read)
                if ($n -le 0) { break }
                $read += $n
            }
        }
        finally { $stream.Dispose() }
    }

    Write-Host ''
    Write-Host "  ${mauve}${bold}$($g.Diamond) HEX DUMP${reset}  ${overlay}$fullPath  (first $count bytes)${reset}"
    Write-Host "  ${overlay}$($g.Rule * 70)${reset}"
    Write-Host ''

    for ($offset = 0; $offset -lt $count; $offset += 16) {
        $end    = [math]::Min($offset + 15, $count - 1)
        $chunk  = $buffer[$offset..$end]
        $addr   = '0x{0:X4}' -f $offset
        $hexStr = (($chunk | ForEach-Object { '{0:X2}' -f $_ }) -join ' ').PadRight(47)
        $ascii  = -join ($chunk | ForEach-Object { if ($_ -ge 32 -and $_ -le 126) { [char]$_ } else { '.' } })

        Write-Host "  ${overlay}$addr${reset}  ${teal}$hexStr${reset}  ${yellow}$ascii${reset}"
    }

    Write-Host ''
    Write-Host "  ${overlay}$length bytes total $($g.MiddleDot) showing $count${reset}"
    Write-Host ''
}

# whereis: locate commands in PATH and applications in the uninstall registry keys.
#   whereis git
#   whereis "Visual Studio Code"
function whereis {
    [CmdletBinding()]
    param([Parameter(Mandatory, Position = 0)][string]$Name)

    $t = $script:Theme
    $g = $script:Glyph
    $mauve = $t.Mauve; $green = $t.Green; $peach = $t.Peach; $yellow = $t.Yellow
    $overlay = $t.Overlay; $red = $t.Red; $bold = $t.Bold; $reset = $t.Reset

    $found = $false

    Write-Host ''
    Write-Host "  ${mauve}${bold}$($g.Diamond) WHEREIS${reset}  ${overlay}searching for${reset}  ${peach}${bold}$Name${reset}"
    Write-Host ''

    # 1. Commands (applications in PATH, cmdlets, functions, aliases)
    foreach ($cmd in @(Get-Command -Name $Name -ErrorAction SilentlyContinue)) {
        $found = $true
        $type  = $cmd.CommandType
        $src   = if ($cmd.Source) { $cmd.Source } else { "(built-in $type)" }
        Write-Host "  ${green}$($g.Dot)${reset}  ${bold}Command${reset}  ${overlay}[$type]${reset}"
        Write-Host "     ${yellow}$src${reset}"
        Write-Host ''
    }

    # 2. Installed applications (HKLM + HKCU, 32-bit and 64-bit views)
    $regPaths = @(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
        'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    $needle = '*' + [System.Management.Automation.WildcardPattern]::Escape($Name) + '*'
    $apps = @(
        foreach ($regPath in $regPaths) {
            Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue |
                Where-Object { $_.DisplayName -like $needle }
        }
    ) | Sort-Object DisplayName, DisplayVersion -Unique

    foreach ($app in $apps) {
        $found = $true
        $loc   = if ($app.InstallLocation) { $app.InstallLocation.TrimEnd('\') } else { '(location not set)' }
        $ver   = if ($app.DisplayVersion)  { "  ${overlay}v$($app.DisplayVersion)${reset}" } else { '' }

        Write-Host "  ${green}$($g.Dot)${reset}  ${bold}Installed App${reset}$ver"
        Write-Host "     ${overlay}Name    :${reset} $($app.DisplayName)"
        Write-Host "     ${yellow}Location: $loc${reset}"

        if ($app.InstallLocation -and (Test-Path -LiteralPath $app.InstallLocation)) {
            $exes = @(Get-ChildItem -LiteralPath $app.InstallLocation -Filter '*.exe' -ErrorAction SilentlyContinue |
                Select-Object -First 5)
            if ($exes.Count -gt 0) {
                Write-Host "     ${overlay}Exe(s)  :${reset}"
                foreach ($exe in $exes) {
                    Write-Host "       ${peach}$($exe.FullName)${reset}"
                }
            }
        }
        Write-Host ''
    }

    if (-not $found) {
        Write-Host "  ${red}$($g.Cross)${reset}  Nothing found for ${bold}$Name${reset}"
        Write-Host "     ${overlay}Not in PATH, not in the installed apps registry.${reset}"
        Write-Host ''
    }
}

# ----------------------------------------------------------------------------
# Weather (Open-Meteo, no API key required)
# ----------------------------------------------------------------------------

# Maps a WMO weather code to a description and an emoji.
function Get-WeatherCondition {
    param([int]$Code)

    $vs = [string][char]0xFE0F   # variation selector 16: forces emoji presentation
    $icon = @{
        Sun         = [string][char]0x2600 + $vs
        SunCloud    = [char]::ConvertFromUtf32(0x1F324) + $vs
        PartlyCloud = [string][char]0x26C5
        Cloud       = [string][char]0x2601 + $vs
        Fog         = [char]::ConvertFromUtf32(0x1F32B) + $vs
        Drizzle     = [char]::ConvertFromUtf32(0x1F326) + $vs
        Rain        = [char]::ConvertFromUtf32(0x1F327) + $vs
        Snow        = [string][char]0x2744 + $vs
        Storm       = [string][char]0x26C8 + $vs
        Unknown     = [char]::ConvertFromUtf32(0x1F321) + $vs
    }

    switch ($Code) {
        0                    { return [pscustomobject]@{ Description = 'Clear sky';          Icon = $icon.Sun } }
        1                    { return [pscustomobject]@{ Description = 'Mainly clear';       Icon = $icon.SunCloud } }
        2                    { return [pscustomobject]@{ Description = 'Partly cloudy';      Icon = $icon.PartlyCloud } }
        3                    { return [pscustomobject]@{ Description = 'Overcast';           Icon = $icon.Cloud } }
        { $_ -in 45, 48 }    { return [pscustomobject]@{ Description = 'Fog';                Icon = $icon.Fog } }
        { $_ -in 51, 53, 55 }{ return [pscustomobject]@{ Description = 'Drizzle';           Icon = $icon.Drizzle } }
        { $_ -in 56, 57 }    { return [pscustomobject]@{ Description = 'Freezing drizzle';  Icon = $icon.Drizzle } }
        { $_ -in 61, 63, 65 }{ return [pscustomobject]@{ Description = 'Rain';              Icon = $icon.Rain } }
        { $_ -in 66, 67 }    { return [pscustomobject]@{ Description = 'Freezing rain';     Icon = $icon.Rain } }
        { $_ -in 71, 73, 75 }{ return [pscustomobject]@{ Description = 'Snow';              Icon = $icon.Snow } }
        77                   { return [pscustomobject]@{ Description = 'Snow grains';       Icon = $icon.Snow } }
        { $_ -in 80, 81, 82 }{ return [pscustomobject]@{ Description = 'Rain showers';      Icon = $icon.Rain } }
        { $_ -in 85, 86 }    { return [pscustomobject]@{ Description = 'Snow showers';      Icon = $icon.Snow } }
        { $_ -in 95, 96, 99 }{ return [pscustomobject]@{ Description = 'Thunderstorm';      Icon = $icon.Storm } }
        default              { return [pscustomobject]@{ Description = 'Unknown';           Icon = $icon.Unknown } }
    }
}

# weather: current conditions and a 3-day forecast.
#   weather            default city (see $script:Settings.WeatherCity)
#   weather Paris
function weather {
    [CmdletBinding()]
    param([Parameter(Position = 0)][string]$City = $script:Settings.WeatherCity)

    $t = $script:Theme
    $g = $script:Glyph
    $mauve = $t.Mauve; $peach = $t.Peach; $green = $t.Green; $yellow = $t.Yellow
    $teal = $t.Teal; $sapphire = $t.Sapphire; $pink = $t.Pink; $red = $t.Red
    $overlay = $t.Overlay; $bold = $t.Bold; $reset = $t.Reset
    $deg = $g.Degree

    Write-Host ''
    Write-Host "  ${mauve}${bold}$($g.Diamond) WEATHER${reset}  ${overlay}fetching for${reset} ${peach}${bold}$City${reset}"
    Write-Host "  ${overlay}$($g.Rule * 52)${reset}"
    Write-Host ''

    # Windows PowerShell 5.1 may not negotiate TLS 1.2 by default.
    if ($PSVersionTable.PSVersion.Major -lt 6) {
        [Net.ServicePointManager]::SecurityProtocol =
            [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }

    try {
        $encoded = [System.Uri]::EscapeDataString($City)
        $geoUrl  = "https://geocoding-api.open-meteo.com/v1/search?name=$encoded&count=1&language=en&format=json"
        $geo     = Invoke-RestMethod -Uri $geoUrl -TimeoutSec 8 -ErrorAction Stop

        if (-not $geo.results -or @($geo.results).Count -eq 0) {
            Write-Host "  ${red}$($g.Star)  City not found:${reset}  ${peach}$City${reset}"
            Write-Host ''
            return
        }

        $place   = @($geo.results)[0]
        $lat     = $place.latitude
        $lon     = $place.longitude

        $wxUrl = "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon" +
                 '&current=temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code,visibility' +
                 '&daily=weather_code,temperature_2m_max,temperature_2m_min' +
                 '&wind_speed_unit=kmh&timezone=auto&forecast_days=3'
        $wx = Invoke-RestMethod -Uri $wxUrl -TimeoutSec 8 -ErrorAction Stop

        $cur       = $wx.current
        $condition = Get-WeatherCondition -Code ([int]$cur.weather_code)
        $visibilityText = if ($null -ne $cur.visibility) { "$([math]::Round($cur.visibility / 1000, 1)) km" } else { 'n/a' }

        Write-Host "  ${overlay}location   ${reset}  ${yellow}${bold}$($place.name)${reset}${overlay}, $($place.country)${reset}"
        Write-Host "  ${overlay}condition  ${reset}  $($condition.Icon)  ${yellow}${bold}$($condition.Description)${reset}"
        Write-Host "  ${overlay}temp       ${reset}  ${peach}${bold}$($cur.temperature_2m) ${deg}C${reset}  ${overlay}feels like${reset}  ${sapphire}$($cur.apparent_temperature) ${deg}C${reset}"
        Write-Host "  ${overlay}humidity   ${reset}  ${teal}${bold}$($cur.relative_humidity_2m)%${reset}"
        Write-Host "  ${overlay}wind       ${reset}  ${green}${bold}$($cur.wind_speed_10m) km/h${reset}"
        Write-Host "  ${overlay}visibility ${reset}  ${pink}${bold}$visibilityText${reset}"

        Write-Host ''
        Write-Host "  ${mauve}${bold}  3-DAY FORECAST${reset}"
        Write-Host "  ${overlay}  $($g.Rule * 44)${reset}"

        $culture = [System.Globalization.CultureInfo]::GetCultureInfo('en-US')
        $days    = @($wx.daily.time)
        for ($i = 0; $i -lt $days.Count; $i++) {
            $date    = [datetime]::ParseExact($days[$i], 'yyyy-MM-dd', $culture)
            $dayName = $date.ToString('ddd dd MMM', $culture).PadRight(12)
            $maxC    = @($wx.daily.temperature_2m_max)[$i]
            $minC    = @($wx.daily.temperature_2m_min)[$i]
            $dayDesc = (Get-WeatherCondition -Code ([int]@($wx.daily.weather_code)[$i])).Description
            Write-Host "  ${overlay}  $dayName${reset}  ${peach}$($g.Up)${maxC}${deg}${reset}  ${sapphire}$($g.Down)${minC}${deg}${reset}  ${overlay}$dayDesc${reset}"
        }
    }
    catch {
        Write-Host "  ${red}$($g.Star)  Could not fetch weather.${reset}  ${overlay}$($_.Exception.Message)${reset}"
    }
    Write-Host ''
}

# ----------------------------------------------------------------------------
# help: custom command reference. Falls back to the built-in Get-Help when the
# keyword does not match any custom command (for example `help Get-Process`).
# ----------------------------------------------------------------------------
function help {
    param([Parameter(Position = 0)][string]$Filter = '')

    $t = $script:Theme
    $g = $script:Glyph
    $mauve = $t.Mauve; $yellow = $t.Yellow; $teal = $t.Teal; $pink = $t.Pink
    $overlay = $t.Overlay; $bold = $t.Bold; $reset = $t.Reset

    $commands = $script:CommandReference
    if ($Filter) {
        $commands = @($commands | Where-Object {
            $_.Name -like "*$Filter*" -or $_.Description -like "*$Filter*" -or $_.Category -like "*$Filter*"
        })
        if ($commands.Count -eq 0) {
            Get-Help $Filter
            return
        }
    }

    Write-Host ''
    Write-Host "  ${mauve}${bold}$($g.Diamond) COMMAND REFERENCE${reset}"
    Write-Host "  ${overlay}$($g.Rule * 40)${reset}"

    foreach ($group in ($commands | Group-Object Category)) {
        Write-Host ''
        Write-Host "  ${pink}${bold}$($group.Name.ToUpper())${reset}"
        foreach ($command in $group.Group) {
            Write-Host "  ${yellow}${bold}$($command.Name.PadRight(14))${reset}  ${overlay}$($command.Description)${reset}"
        }
    }

    Write-Host ''
    Write-Host "  ${overlay}Usage: ${reset}${teal}help [keyword]${reset}  ${overlay}to filter commands${reset}"
    Write-Host ''
}

# ----------------------------------------------------------------------------
# Prompt: every path segment gets its own Catppuccin Mocha color
# ----------------------------------------------------------------------------
function prompt {
    $t = $script:Theme
    $g = $script:Glyph
    $mauve = $t.Mauve; $teal = $t.Teal; $lavender = $t.Lavender
    $pink  = $t.Pink;  $reset = $t.Reset

    $username = $env:USERNAME
    $parts    = $PWD.Path -split '[\\/]'

    $colored = for ($i = 0; $i -lt $parts.Count; $i++) {
        $part = $parts[$i]
        if     ($part -eq '')                 { '' }
        elseif ($i -eq 0)                     { "$mauve$part" }
        elseif ($part -eq 'Users')            { "$teal$part" }
        elseif ($part -eq $username)          { "$lavender$part" }
        else                                  { "$($script:PromptPalette | Get-Random)$part" }
    }
    $path = $colored -join "$reset\"

    "${mauve}$($g.PromptIcon) ${path}${pink} `$ $($g.Chevron)${reset} "
}
