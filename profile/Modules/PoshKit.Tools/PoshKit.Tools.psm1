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
    Diamond = [string][char]0x25C6
    Star    = [string][char]0x2726
    Rule    = [string][char]0x2500
    Dot     = [string][char]0x25CF
    Cross   = [string][char]0x2716
    Arrow   = [string][char]0x2192
}

function whereis {
    [CmdletBinding()]
    param([Parameter(Mandatory, Position = 0)][string]$Name)

    $t = $script:Theme
    $g = $script:Glyph

    $found = $false

    Write-Host ''
    Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) WHEREIS$($t.Reset)  $($t.Overlay)searching for$($t.Reset)  $($t.Peach)$($t.Bold)$Name$($t.Reset)"
    Write-Host ''

    # 1. Commands (applications in PATH, cmdlets, functions, aliases).
    foreach ($cmd in @(Get-Command -Name $Name -ErrorAction SilentlyContinue)) {
        $found = $true
        $type  = $cmd.CommandType
        $src   = if ($cmd.Source) { $cmd.Source } else { "(built-in $type)" }
        Write-Host "  $($t.Green)$($g.Dot)$($t.Reset)  $($t.Bold)Command$($t.Reset)  $($t.Overlay)[$type]$($t.Reset)"
        Write-Host "     $($t.Yellow)$src$($t.Reset)"
        Write-Host ''
    }

    # 2. Installed applications (HKLM + HKCU, 32-bit and 64-bit views).
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
        $ver   = if ($app.DisplayVersion)  { "  $($t.Overlay)v$($app.DisplayVersion)$($t.Reset)" } else { '' }

        Write-Host "  $($t.Green)$($g.Dot)$($t.Reset)  $($t.Bold)Installed App$($t.Reset)$ver"
        Write-Host "     $($t.Overlay)Name    :$($t.Reset) $($app.DisplayName)"
        Write-Host "     $($t.Yellow)Location: $loc$($t.Reset)"

        if ($app.InstallLocation -and (Test-Path -LiteralPath $app.InstallLocation)) {
            $exes = @(Get-ChildItem -LiteralPath $app.InstallLocation -Filter '*.exe' -ErrorAction SilentlyContinue |
                Select-Object -First 5)
            if ($exes.Count -gt 0) {
                Write-Host "     $($t.Overlay)Exe(s)  :$($t.Reset)"
                foreach ($exe in $exes) {
                    Write-Host "       $($t.Peach)$($exe.FullName)$($t.Reset)"
                }
            }
        }
        Write-Host ''
    }

    if (-not $found) {
        Write-Host "  $($t.Red)$($g.Cross)$($t.Reset)  Nothing found for $($t.Bold)$Name$($t.Reset)"
        Write-Host "     $($t.Overlay)Not in PATH, not in the installed apps registry.$($t.Reset)"
        Write-Host ''
    }
}

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

    $algo = if ($md5) { 'MD5' } elseif ($sha1) { 'SHA1' } else { 'SHA256' }

    Write-Host ''
    Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) HASH$($t.Reset)  $($t.Overlay)algorithm$($t.Reset)  $($t.Teal)$algo$($t.Reset)"
    Write-Host "  $($t.Overlay)$($g.Rule * 60)$($t.Reset)"
    Write-Host ''

    $result = $null
    try {
        if ($PSBoundParameters.ContainsKey('text')) {
            $bytes  = [System.Text.Encoding]::UTF8.GetBytes($text)
            $stream = New-Object System.IO.MemoryStream (, $bytes)
            try     { $result = (Get-FileHash -InputStream $stream -Algorithm $algo).Hash.ToLower() }
            finally { $stream.Dispose() }
            Write-Host "  $($t.Overlay)input   $($t.Reset)  $($t.Peach)$text$($t.Reset)"
            Write-Host "  $($t.Overlay)$($algo.PadRight(8))$($t.Reset)  $($t.Green)$($t.Bold)$result$($t.Reset)"
        }
        elseif ($Path -and (Test-Path -LiteralPath $Path -PathType Leaf)) {
            $result = (Get-FileHash -LiteralPath $Path -Algorithm $algo).Hash.ToLower()
            Write-Host "  $($t.Overlay)file    $($t.Reset)  $($t.Peach)$Path$($t.Reset)"
            Write-Host "  $($t.Overlay)$($algo.PadRight(8))$($t.Reset)  $($t.Green)$($t.Bold)$result$($t.Reset)"
        }
        else {
            Write-Host "  $($t.Red)$($g.Star)  Provide a file path or use -text 'string'$($t.Reset)"
        }

        if ($result) {
            try {
                Set-Clipboard -Value $result
                Write-Host ''
                Write-Host "  $($t.Overlay)Copied to clipboard.$($t.Reset)"
            }
            catch {
                Write-Host ''
                Write-Host "  $($t.Overlay)Clipboard unavailable, result not copied.$($t.Reset)"
            }
        }
    }
    catch {
        Write-Host "  $($t.Red)$($g.Star)  Error: $($_.Exception.Message)$($t.Reset)"
    }
    Write-Host ''
}

function b64 {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$Target,
        [switch]$d,
        [switch]$File,
        [switch]$String,
        [string]$Out
    )

    $t = $script:Theme
    $g = $script:Glyph

    $isFile = (-not $String) -and ($File -or (Test-Path -LiteralPath $Target -PathType Leaf))

    Write-Host ''
    try {
        if ($d) {
            $raw     = if ($isFile) { Get-Content -LiteralPath $Target -Raw } else { $Target }
            $clean   = ($raw -replace '\s', '')
            $bytes   = [System.Convert]::FromBase64String($clean)

            if ($Out) {
                [System.IO.File]::WriteAllBytes($Out, $bytes)
                Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) BASE64 DECODE$($t.Reset)  $($t.Overlay)written to$($t.Reset)  $($t.Teal)$Out$($t.Reset)"
                Write-Host ''
                return
            }

            $result = [System.Text.Encoding]::UTF8.GetString($bytes)
            Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) BASE64 DECODE$($t.Reset)"
            Write-Host "  $($t.Overlay)$($g.Rule * 52)$($t.Reset)"
            Write-Host ''
            Write-Host "  $($t.Green)$($t.Bold)$(Format-B64Preview $result)$($t.Reset)"
        }
        else {
            $bytes  = if ($isFile) {
                [System.IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $Target).Path)
            }
            else {
                [System.Text.Encoding]::UTF8.GetBytes($Target)
            }
            $result = [System.Convert]::ToBase64String($bytes)

            if ($Out) {
                [System.IO.File]::WriteAllText($Out, $result, [System.Text.Encoding]::ASCII)
                Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) BASE64 ENCODE$($t.Reset)  $($t.Overlay)written to$($t.Reset)  $($t.Teal)$Out$($t.Reset)"
                Write-Host ''
                return
            }

            Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) BASE64 ENCODE$($t.Reset)"
            Write-Host "  $($t.Overlay)$($g.Rule * 52)$($t.Reset)"
            Write-Host ''
            Write-Host "  $($t.Teal)$($t.Bold)$(Format-B64Preview $result)$($t.Reset)"
        }

        Write-Host ''
        try {
            Set-Clipboard -Value $result
            Write-Host "  $($t.Overlay)Copied to clipboard.$($t.Reset)"
        }
        catch {
            Write-Host "  $($t.Overlay)Clipboard unavailable, result not copied.$($t.Reset)"
        }
    }
    catch {
        Write-Host "  $($t.Red)$($g.Cross)  Error: $($_.Exception.Message)$($t.Reset)"
    }
    Write-Host ''
}

# Keep the screen output short; the clipboard gets the full value.
function Format-B64Preview {
    param([string]$Value)

    if ($Value.Length -gt 4096) {
        return $Value.Substring(0, 4096) + ' ... (truncated, use -Out to save the full value)'
    }
    return $Value
}

Export-ModuleMember -Function whereis, hash, b64
