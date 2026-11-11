$ESC = [char]27
$script:Theme = @{
    Reset    = "$ESC[0m"
    Bold     = "$ESC[1m"
    Red      = "$ESC[38;2;243;139;168m"  # #F38BA8
    Peach    = "$ESC[38;2;250;179;135m"  # #FAB387
    Yellow   = "$ESC[38;2;249;226;175m"  # #F9E2AF
    Green    = "$ESC[38;2;166;227;161m"  # #A6E3A1
    Teal     = "$ESC[38;2;148;226;213m"  # #94E2D5
    Sky      = "$ESC[38;2;137;220;235m"  # #89DCEB
    Sapphire = "$ESC[38;2;116;199;236m"  # #74C7EC
    Blue     = "$ESC[38;2;137;180;250m"  # #89B4FA
    Lavender = "$ESC[38;2;180;190;254m"  # #B4BEFE
    Mauve    = "$ESC[38;2;203;166;247m"  # #CBA6F7
    Pink     = "$ESC[38;2;245;194;231m"  # #F5C2E7
    Overlay  = "$ESC[38;2;108;112;134m"  # #6C7086
}
Remove-Variable ESC -ErrorAction SilentlyContinue

$script:Glyph = @{
    TopLeft    = [string][char]0x250C
    BottomLeft = [string][char]0x2514
    Rule       = [string][char]0x2500
    HostSep    = [string][char]0x327F
    Chevron    = [string][char]0x00BB
    Diamond    = [string][char]0x25C6
    Star       = [string][char]0x2726
    Dot        = [string][char]0x25CF
    Cross      = [string][char]0x2716
    Pointer    = [string][char]0x25B6
    MiddleDot  = [string][char]0x00B7
    Arrow      = [string][char]0x2192
}

$script:Settings = @{
    BookmarkFile = Join-Path $HOME ".config/$([Environment]::UserName)/bookmarks.json"
}

function prompt {
    $t = $script:Theme
    $g = $script:Glyph

    $palette = @(
        $t.Red, $t.Peach, $t.Yellow, $t.Green, $t.Sky,
        $t.Sapphire, $t.Blue, $t.Mauve, $t.Pink
    )

    $username = $env:USERNAME
    $hostname = (Get-Culture).TextInfo.ToTitleCase($env:COMPUTERNAME.ToLower())

    $parts   = $PWD.Path -split '[\\/]'
    $colored = for ($i = 0; $i -lt $parts.Count; $i++) {
        $part = $parts[$i]
        if ($part -eq '')                  { '' }
        elseif ($i -eq 0)                  { "$($t.Mauve)$part" }
        elseif ($part -eq 'Users')         { "$($t.Teal)$part" }
        elseif ($part -eq $username)       { "$($t.Lavender)$part" }
        else                               { "$($palette | Get-Random)$part" }
    }
    $path = $colored -join "$($t.Reset)\"

    # A dirty tree turns the branch yellow.
    $gitBranch = ''
    if (Get-Command git -ErrorAction SilentlyContinue) {
        try {
            $branch = @(git rev-parse --abbrev-ref HEAD 2>$null)[0]
            if ($branch -and $LASTEXITCODE -eq 0) {
                $dirty       = @(git status --porcelain 2>$null).Count -gt 0
                $branchColor = if ($dirty) { $t.Yellow } else { $t.Green }
                $gitBranch   = " $($t.Overlay)on$($t.Reset) ${branchColor}$branch$($t.Reset)"
            }
        }
        catch {}
    }

    $symbol      = '$'
    $symbolColor = $t.Peach
    try {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = [Security.Principal.WindowsPrincipal]::new($identity)
        if ($principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
            $symbol      = '#'
            $symbolColor = $t.Red
        }
    }
    catch {}

    # Above the box, so the box never shifts.
    $venvLine = ''
    if ($env:VIRTUAL_ENV) {
        $venvName = Split-Path $env:VIRTUAL_ENV -Leaf
        $venvLine = "$($t.Overlay)($($t.Green)$venvName$($t.Overlay))$($t.Reset)`n"
    }

    $line1 = "$($t.Green)$($g.TopLeft)$($g.Rule)$($t.Reset)($($t.Mauve)$username$($t.Reset)$($t.Pink)$($g.HostSep)$($t.Reset)$($t.Teal)$hostname$($t.Reset))$($t.Green)-$($t.Reset)[$path$($t.Reset)]$gitBranch"
    $line2 = "$($t.Green)$($g.BottomLeft)$($g.Rule)$($t.Reset)${symbolColor}${symbol} $($g.Chevron)$($t.Reset) "

    "$venvLine$line1`n$line2"
}

function cls { Clear-Host }

function mkcd {
    [CmdletBinding()]
    param([Parameter(Mandatory, Position = 0)][string]$Dir)

    New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    Set-Location -LiteralPath $Dir
}

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

function cdh {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)][string]$Action = '',
        [Parameter(Position = 1)][string]$Label  = ''
    )

    $t = $script:Theme
    $g = $script:Glyph

    $bookmarks = Read-DirBookmark

    switch ($Action) {
        'save' {
            $key = if ($Label) { $Label } else { Split-Path -Path $PWD.Path -Leaf }
            if (-not $key -or $key -in @('save', 'del')) {
                Write-Host ''
                Write-Host "  $($t.Red)$($g.Star)  Invalid bookmark name:$($t.Reset)  $($t.Peach)$key$($t.Reset)"
                Write-Host ''
                return
            }
            $bookmarks[$key] = $PWD.Path
            Write-DirBookmark -Bookmarks $bookmarks
            Write-Host ''
            Write-Host "  $($t.Green)$($g.Star)$($t.Reset)  $($t.Overlay)Bookmarked:$($t.Reset)  $($t.Yellow)$($t.Bold)$key$($t.Reset)  $($t.Overlay)$($g.Arrow)$($t.Reset)  $($t.Teal)$($PWD.Path)$($t.Reset)"
            Write-Host ''
            return
        }
        'del' {
            Write-Host ''
            if ($bookmarks.Contains($Label)) {
                $bookmarks.Remove($Label)
                Write-DirBookmark -Bookmarks $bookmarks
                Write-Host "  $($t.Red)$($g.Star)$($t.Reset)  $($t.Overlay)Removed:$($t.Reset)  $($t.Peach)$Label$($t.Reset)"
            }
            else {
                Write-Host "  $($t.Red)$($g.Star)  Bookmark not found:$($t.Reset)  $($t.Peach)$Label$($t.Reset)"
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
                    Write-Host "  $($t.Mauve)$($g.Star)$($t.Reset)  $($t.Overlay)Jumped to:$($t.Reset)  $($t.Teal)$target$($t.Reset)"
                }
                else {
                    Write-Host "  $($t.Red)$($g.Star)  Folder no longer exists:$($t.Reset)  $($t.Teal)$target$($t.Reset)"
                }
                Write-Host ''
                return
            }
        }
    }

    Write-Host ''
    Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) BOOKMARKS$($t.Reset)"
    Write-Host "  $($t.Overlay)$($g.Rule * 52)$($t.Reset)"
    Write-Host ''
    if ($bookmarks.Count -eq 0) {
        Write-Host "  $($t.Overlay)No bookmarks yet. Use:  $($t.Reset)$($t.Peach)cdh save [label]$($t.Reset)"
    }
    else {
        foreach ($key in $bookmarks.Keys) {
            Write-Host "  $($t.Yellow)$($t.Bold)$($key.PadRight(16))$($t.Reset)  $($t.Teal)$($bookmarks[$key])$($t.Reset)"
        }
    }
    Write-Host ''
}

function env {
    [CmdletBinding()]
    param([Parameter(Position = 0)][string]$Filter = '')

    $t = $script:Theme
    $g = $script:Glyph

    Write-Host ''
    if ($Filter) {
        Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) ENV$($t.Reset)  $($t.Overlay)matching$($t.Reset)  $($t.Peach)$($t.Bold)$Filter$($t.Reset)"
    }
    else {
        Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) ENV$($t.Reset)  $($t.Overlay)all variables$($t.Reset)"
    }
    Write-Host "  $($t.Overlay)$($g.Rule * 60)$($t.Reset)"
    Write-Host ''

    $vars = [System.Environment]::GetEnvironmentVariables().GetEnumerator() | Sort-Object Key
    if ($Filter) {
        $vars = $vars | Where-Object { $_.Key -like "*$Filter*" }
    }

    if (-not $vars) {
        Write-Host "  $($t.Overlay)No variables match.$($t.Reset)"
        Write-Host ''
        return
    }

    foreach ($item in $vars) {
        $value = if ($null -eq $item.Value) { '' } else { [string]$item.Value }
        if ($value.Length -gt 80) { $value = $value.Substring(0, 77) + '...' }
        Write-Host "  $($t.Teal)$($t.Bold)$($item.Key.PadRight(20))$($t.Reset)  $($t.Overlay)$value$($t.Reset)"
    }
    Write-Host ''
}

function clip {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [AllowEmptyString()]
        [string[]]$InputObject
    )

    begin {
        $lines = [System.Collections.Generic.List[string]]::new()
    }
    process {
        if ($null -ne $InputObject) {
            foreach ($line in $InputObject) {
                $lines.Add([string]$line)
            }
        }
    }
    end {
        $t = $script:Theme

        if ($lines.Count -eq 0) {
            Write-Host "  $($t.Peach)Usage: Get-Content file.txt | clip$($t.Reset)"
            return
        }

        $text = $lines -join [Environment]::NewLine
        try {
            Set-Clipboard -Value $text
            Write-Host "  $($t.Green)$([string][char]0x2726)$($t.Reset)  $($t.Overlay)Copied $($lines.Count) line(s) to the clipboard.$($t.Reset)"
        }
        catch {
            Write-Host "  $($t.Red)$([string][char]0x2716)  Clipboard unavailable.$($t.Reset)"
        }
    }
}

function paste {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)][string]$Path = '',
        [switch]$Overwrite
    )

    $t = $script:Theme

    try {
        $text = Get-Clipboard -Raw -ErrorAction Stop
    }
    catch {
        Write-Host "  $($t.Red)$([string][char]0x2716)  Clipboard unavailable.$($t.Reset)"
        return
    }

    if ($null -eq $text) { $text = '' }

    if (-not $Path) {
        Write-Output $text
        return
    }

    try {
        if ($Overwrite) {
            Set-Content -LiteralPath $Path -Value $text -Encoding UTF8
        }
        else {
            Add-Content -LiteralPath $Path -Value $text -Encoding UTF8
        }
        Write-Host "  $($t.Green)$([string][char]0x2726)$($t.Reset)  $($t.Overlay)Pasted into$($t.Reset)  $($t.Teal)$Path$($t.Reset)"
    }
    catch {
        Write-Host "  $($t.Red)$([string][char]0x2716)  Could not write ${Path}: $($_.Exception.Message)$($t.Reset)"
    }
}

$script:CommandReference = @(
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'll';      Description = 'Detailed file listing (includes hidden files)' }
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'touch';   Description = 'Create empty files or update their timestamp' }
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'mkcd';    Description = 'Create a directory and cd into it' }
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'show';    Description = 'Search files (-u user folder, -deep whole drive, -from path)' }
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'cdh';     Description = 'Directory bookmarks (save / jump / del)' }
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'hex';     Description = 'Hex dump of a file' }
    [pscustomobject]@{ Category = 'Nav & Files'; Name = 'serve';   Description = 'Quick HTTP file server (serve [port])' }
    [pscustomobject]@{ Category = 'System';       Name = 'proc';    Description = 'Top processes by CPU or memory (proc -ram)' }
    [pscustomobject]@{ Category = 'System';       Name = 'env';     Description = 'List or search environment variables' }
    [pscustomobject]@{ Category = 'Tools';        Name = 'whereis'; Description = 'Find commands and installed apps (registry)' }
    [pscustomobject]@{ Category = 'Tools';        Name = 'hash';    Description = 'SHA256 / MD5 / SHA1 hash (-md5 -sha1 -text)' }
    [pscustomobject]@{ Category = 'Tools';        Name = 'b64';     Description = 'Base64 encode or decode strings and files' }
    [pscustomobject]@{ Category = 'Tools';        Name = 'clip';    Description = 'Pipe output to the clipboard (cmd | clip)' }
    [pscustomobject]@{ Category = 'Tools';        Name = 'paste';   Description = 'Paste clipboard text into a file' }
    [pscustomobject]@{ Category = 'Tools';        Name = 'weather'; Description = 'Terminal weather forecast (weather <city>)' }
    [pscustomobject]@{ Category = 'Tools';        Name = 'help';    Description = 'This command reference (help <keyword>)' }
)

# Falls back to Get-Help when the filter matches no custom command.
function help {
    param([Parameter(Position = 0)][string]$Filter = '')

    $t = $script:Theme
    $g = $script:Glyph

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
    Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) COMMAND REFERENCE$($t.Reset)"
    Write-Host "  $($t.Overlay)$($g.Rule * 40)$($t.Reset)"

    foreach ($group in ($commands | Group-Object Category)) {
        Write-Host ''
        Write-Host "  $($t.Pink)$($t.Bold)$($group.Name.ToUpper())$($t.Reset)"
        foreach ($command in $group.Group) {
            Write-Host "  $($t.Yellow)$($t.Bold)$($command.Name.PadRight(14))$($t.Reset)  $($t.Overlay)$($command.Description)$($t.Reset)"
        }
    }

    Write-Host ''
    Write-Host "  $($t.Overlay)Usage: $($t.Reset)$($t.Teal)help [keyword]$($t.Reset)  $($t.Overlay)to filter commands$($t.Reset)"
    Write-Host ''
}

Export-ModuleMember -Function prompt, cls, mkcd, cdh, env, clip, paste, help
