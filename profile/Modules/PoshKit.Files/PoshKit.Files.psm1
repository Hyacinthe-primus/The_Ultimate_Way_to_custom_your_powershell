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
    Diamond   = [string][char]0x25C6
    Star      = [string][char]0x2726
    Rule      = [string][char]0x2500
    Pointer   = [string][char]0x25B6
    MiddleDot = [string][char]0x00B7
}

function ll {
    param([string]$Path = '.')

    $t = $script:Theme
    $g = $script:Glyph

    $items    = @(Get-ChildItem -Force $Path)
    $resolved = (Resolve-Path $Path).Path

    Write-Host ''
    Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) DIRECTORY$($t.Reset)  $($t.Overlay)$resolved$($t.Reset)"
    Write-Host "  $($t.Overlay)$($g.Rule * 40)$($t.Reset)"
    Write-Host ''

    $ul   = "$([char]27)[4m"
    $noul = "$([char]27)[24m"

    $col1 = "${ul}Mode${noul}".PadRight(10 + $ul.Length + $noul.Length)
    $col2 = "${ul}Modified${noul}".PadRight(19 + $ul.Length + $noul.Length)
    $col3 = "${ul}Size${noul}".PadLeft(10 + $ul.Length + $noul.Length)
    $col4 = "${ul}Name${noul}"
    Write-Host "  $($t.Mauve)$col1$($t.Reset)  $($t.Peach)$col2$($t.Reset)  $($t.Yellow)$col3$($t.Reset)  $($t.Teal)$col4$($t.Reset)"
    Write-Host ''

    foreach ($item in $items) {
        $mode     = $item.Mode.PadRight(10)
        $date     = $item.LastWriteTime.ToString('dd/MM/yyyy HH:mm').PadRight(19)
        $isHidden = $item.Attributes -band [System.IO.FileAttributes]::Hidden

        if ($item.PSIsContainer) {
            $size    = ' '.PadLeft(10)
            $nameCol = "$($t.Teal)$($t.Bold)$($item.Name)/$($t.Reset)"
            $modeCol = "$($t.Overlay)$mode$($t.Reset)"
        }
        elseif ($item.Extension -in @('.lnk')) {
            $size    = ('~' + [math]::Round($item.Length / 1KB, 0).ToString() + ' KB').PadLeft(10)
            $nameCol = "$($t.Overlay)$($item.Name)$($t.Reset)"
            $modeCol = "$($t.Overlay)$mode$($t.Reset)"
        }
        elseif ($item.Extension -in @('.ps1', '.py', '.js', '.ts', '.sh', '.bat', '.cmd', '.c', '.cpp', '.h', '.hpp', '.java', '.cs', '.rb', '.go', '.rs')) {
            $size    = ([math]::Round($item.Length / 1KB, 1).ToString() + ' KB').PadLeft(10)
            $nameCol = "$($t.Green)$($t.Bold)$($item.Name)$($t.Reset)"
            $modeCol = "$($t.Green)$mode$($t.Reset)"
        }
        elseif ($item.Extension -in @('.zip', '.rar', '.7z', '.tar', '.gz')) {
            $size    = ([math]::Round($item.Length / 1MB, 2).ToString() + ' MB').PadLeft(10)
            $nameCol = "$($t.Peach)$($t.Bold)$($item.Name)$($t.Reset)"
            $modeCol = "$($t.Peach)$mode$($t.Reset)"
        }
        elseif ($item.Extension -in @('.png', '.jpg', '.jpeg', '.gif', '.webp', '.svg')) {
            $size    = ([math]::Round($item.Length / 1MB, 2).ToString() + ' MB').PadLeft(10)
            $nameCol = "$($t.Pink)$($item.Name)$($t.Reset)"
            $modeCol = "$($t.Pink)$mode$($t.Reset)"
        }
        elseif ($item.Extension -in @('.pdf', '.docx', '.doc', '.xlsx', '.pptx')) {
            $size    = ([math]::Round($item.Length / 1MB, 2).ToString() + ' MB').PadLeft(10)
            $nameCol = "$($t.Yellow)$($item.Name)$($t.Reset)"
            $modeCol = "$($t.Yellow)$mode$($t.Reset)"
        }
        elseif ($item.Extension -in @('.txt', '.md', '.json', '.yaml', '.yml', '.ini', '.cfg', '.log')) {
            $size    = ($item.Length.ToString() + ' B').PadLeft(10)
            $nameCol = "$($t.Mauve)$($item.Name)$($t.Reset)"
            $modeCol = "$($t.Mauve)$mode$($t.Reset)"
        }
        else {
            $size    = ($item.Length.ToString() + ' B').PadLeft(10)
            $nameCol = "$($t.Reset)$($item.Name)"
            $modeCol = "$($t.Overlay)$mode$($t.Reset)"
        }

        if ($isHidden) { $nameCol = "$($t.Overlay)$($item.Name)$($t.Reset)" }

        Write-Host "  $modeCol  $($t.Overlay)$date$($t.Reset)  $($t.Overlay)$size$($t.Reset)  $nameCol"
    }

    Write-Host ''

    $fileCount   = @($items | Where-Object { -not $_.PSIsContainer }).Count
    $folderCount = @($items | Where-Object { $_.PSIsContainer }).Count
    $totalSize   = ($items | Where-Object { -not $_.PSIsContainer } | Measure-Object -Property Length -Sum).Sum
    $totalMB     = [math]::Round($totalSize / 1MB, 2)

    Write-Host "  $($t.Overlay)$($g.Rule * 60)$($t.Reset)"
    Write-Host "  $($t.Overlay)$folderCount dirs  $($g.MiddleDot)  $fileCount files  $($g.MiddleDot)  $($t.Reset)$($t.Teal)$($t.Bold)$totalMB MB (top-level files)$($t.Reset)"
    Write-Host ''
}

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

    if ($from)      { $searchPath = $from }
    elseif ($u)     { $searchPath = $HOME }
    elseif ($deep)  { $searchPath = "$($env:SystemDrive)\" }
    else            { $searchPath = $PWD.Path }

    if (-not (Test-Path -LiteralPath $searchPath -PathType Container)) {
        Write-Host ''
        Write-Host "  $($t.Red)$($g.Star)  Folder not found:$($t.Reset)  $($t.Peach)$searchPath$($t.Reset)"
        Write-Host ''
        return
    }

    if ($name -match '^\.\w+$')   { $pattern = "*$name" }      # extension only
    elseif ($name -match '[.*?]') { $pattern = $name }         # explicit name or wildcard
    else                          { $pattern = "*$name*" }     # substring

    $rule = $g.Rule * 60
    Write-Host ''
    Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) SHOW$($t.Reset)  $($t.Overlay)searching for$($t.Reset) $($t.Peach)$($t.Bold)$pattern$($t.Reset)  $($t.Overlay)in$($t.Reset)  $($t.Sky)$searchPath$($t.Reset)"
    Write-Host "  $($t.Overlay)${rule}$($t.Reset)"

    $results = @(Get-ChildItem -LiteralPath $searchPath -Filter $pattern -Recurse -Force -ErrorAction SilentlyContinue)

    if ($results.Count -eq 0) {
        Write-Host ''
        Write-Host "  $($t.Red)$($g.Star)$($t.Reset)  No files found for $($t.Peach)$pattern$($t.Reset)"
        Write-Host ''
        return
    }

    Write-Host ''
    foreach ($file in $results) {
        if ($file.PSIsContainer)      { $size = "$($t.Teal)[dir]$($t.Reset)" }
        elseif ($file.Length -ge 1MB) { $size = "$($t.Yellow)$([math]::Round($file.Length / 1MB, 2)) MB$($t.Reset)" }
        elseif ($file.Length -ge 1KB) { $size = "$($t.Green)$([math]::Round($file.Length / 1KB, 2)) KB$($t.Reset)" }
        else                          { $size = "$($t.Lavender)$($file.Length) B$($t.Reset)" }

        $created  = $file.CreationTime.ToString('yyyy-MM-dd HH:mm')
        $modified = $file.LastWriteTime.ToString('yyyy-MM-dd HH:mm')

        Write-Host "  $($t.Pink)$($g.Pointer)$($t.Reset) $($t.Bold)$($file.FullName)$($t.Reset)"
        Write-Host "      $($t.Overlay)size$($t.Reset)     $size"
        Write-Host "      $($t.Overlay)created$($t.Reset)  $($t.Sapphire)$created$($t.Reset)   $($t.Overlay)modified$($t.Reset)  $($t.Peach)$modified$($t.Reset)"
        Write-Host ''
    }

    Write-Host "  $($t.Overlay)${rule}$($t.Reset)"
    Write-Host "  $($t.Mauve)$($g.Diamond)$($t.Reset)  $($t.Overlay)found$($t.Reset) $($t.Peach)$($t.Bold)$($results.Count)$($t.Reset) $($t.Overlay)result(s)$($t.Reset)"
    Write-Host ''
}

function hex {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)][string]$File,
        [Parameter(Position = 1)][ValidateRange(1, [int]::MaxValue)][int]$Bytes = 256
    )

    $t = $script:Theme
    $g = $script:Glyph

    # .NET APIs resolve relative paths against the process directory, not $PWD.
    $fullPath = $PSCmdlet.GetUnresolvedProviderPathFromPSPath($File)

    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        Write-Host ''
        Write-Host "  $($t.Red)$($g.Star)  File not found: $fullPath$($t.Reset)"
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
    Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) HEX DUMP$($t.Reset)  $($t.Overlay)$fullPath  (first $count bytes)$($t.Reset)"
    Write-Host "  $($t.Overlay)$($g.Rule * 70)$($t.Reset)"
    Write-Host ''

    for ($offset = 0; $offset -lt $count; $offset += 16) {
        $end    = [math]::Min($offset + 15, $count - 1)
        $chunk  = $buffer[$offset..$end]
        $addr   = '0x{0:X4}' -f $offset
        $hexStr = (($chunk | ForEach-Object { '{0:X2}' -f $_ }) -join ' ').PadRight(47)
        $ascii  = -join ($chunk | ForEach-Object { if ($_ -ge 32 -and $_ -le 126) { [char]$_ } else { '.' } })

        Write-Host "  $($t.Overlay)$addr$($t.Reset)  $($t.Teal)$hexStr$($t.Reset)  $($t.Yellow)$ascii$($t.Reset)"
    }

    Write-Host ''
    Write-Host "  $($t.Overlay)$length bytes total $($g.MiddleDot) showing $count$($t.Reset)"
    Write-Host ''
}

Export-ModuleMember -Function ll, touch, show, hex
