# ─────────────────────────────────────────
#  Aliases & utility functions
#  ll, touch, which, cls, mkcd, hs, show, uptime
# ─────────────────────────────────────────
# ─────────────────────────────────────────
#  Aliases
# ─────────────────────────────────────────

# ll — detailed file listing
function ll { Get-ChildItem -Force @args }

# touch — create empty file or update timestamp
function touch {
    param([string]$path)
    if (Test-Path $path) {
        (Get-Item $path).LastWriteTime = Get-Date
    } else {
        New-Item -ItemType File -Path $path | Out-Null
    }
}

# which — find executable location
function which {
    param([string]$cmd)
    Get-Command $cmd -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
}

# cls — clear screen
function cls { Clear-Host }

# ─────────────────────────────────────────
#  mkcd — create folder and cd into it
# ─────────────────────────────────────────
function mkcd {
    param([Parameter(Mandatory=$true)][string]$dir)
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Set-Location $dir
}

# ─────────────────────────────────────────
#  hs — history search
#
#  Usage:
#    hs           → show full history
#    hs git       → filter history by keyword
# ─────────────────────────────────────────
function hs {
    param([string]$query = "")

    $ESC     = [char]27
    $mauve   = "$ESC[38;2;203;166;247m"
    $peach   = "$ESC[38;2;250;179;135m"
    $overlay = "$ESC[38;2;108;112;134m"
    $green   = "$ESC[38;2;166;227;161m"
    $bold    = "$ESC[1m"
    $reset   = "$ESC[0m"

    $history = Get-History

    if ($query) {
        $history = $history | Where-Object { $_.CommandLine -like "*$query*" }
    }

    Write-Host ""
    if ($query) {
        Write-Host "  ${mauve}${bold}◆ HISTORY${reset}  ${overlay}matching${reset}  ${peach}${bold}$query${reset}"
    } else {
        Write-Host "  ${mauve}${bold}◆ HISTORY${reset}  ${overlay}all commands${reset}"
    }
    Write-Host "  ${overlay}$("─" * 60)${reset}"
    Write-Host ""

    if ($history) {
        $history | ForEach-Object {
            $id   = "${overlay}$("{0,4}" -f $_.Id)${reset}"
            $time = "${peach}$($_.StartExecutionTime.ToString("yyyy-MM-dd HH:mm"))${reset}"
            $cmd  = "${green}$($_.CommandLine)${reset}"
            Write-Host "  $id  $time  $cmd"
        }
    } else {
        Write-Host "  ${overlay}No matching commands found.${reset}"
    }
    Write-Host ""
}

function history-search { hs @args }

# ─────────────────────────────────────────
#  show — file search
#
#  Usage:
#    show filename.txt           → current folder only
#    show filename               → current folder, all "filename.*"
#    show -u filename.txt        → user folder (C:\Users\<you>)
#    show -deep filename.txt     → entire system (C:\)
#    show -from "C:\path" name   → from a specific folder
# ─────────────────────────────────────────
function show {
    param(
        [switch]$u,
        [switch]$deep,
        [string]$from,
        [Parameter(Mandatory=$true, Position=0)]
        [string]$name
    )

    $ESC      = [char]27
    $mauve    = "$ESC[38;2;203;166;247m"  # #CBA6F7
    $pink     = "$ESC[38;2;245;194;231m"  # #F5C2E7
    $peach    = "$ESC[38;2;250;179;135m"  # #FAB387
    $yellow   = "$ESC[38;2;249;226;175m"  # #F9E2AF
    $green    = "$ESC[38;2;166;227;161m"  # #A6E3A1
    $teal     = "$ESC[38;2;148;226;213m"  # #94E2D5
    $sky      = "$ESC[38;2;137;220;235m"  # #89DCEB
    $sapphire = "$ESC[38;2;116;199;236m"  # #74C7EC
    $lavender = "$ESC[38;2;180;190;254m"  # #B4BEFE
    $red      = "$ESC[38;2;243;139;168m"  # #F38BA8
    $overlay  = "$ESC[38;2;108;112;134m"  # #6C7086
    $bold     = "$ESC[1m"
    $reset    = "$ESC[0m"

    if ($from) {
        $searchPath = $from
    } elseif ($u) {
        $searchPath = $env:USERPROFILE
    } elseif ($deep) {
        $searchPath = "C:\"
    } else {
        $searchPath = $PWD.Path
    }

    if ($name -match "\.") {
        $pattern = $name
    } else {
        $pattern = "$name.*"
    }

    Write-Host ""
    Write-Host "  ${mauve}${bold}◆ SHOW${reset}  ${overlay}searching for${reset} ${peach}${bold}$pattern${reset}  ${overlay}in${reset}  ${sky}$searchPath${reset}"
    Write-Host "  ${overlay}$("─" * 60)${reset}"

    $results = Get-ChildItem -Path $searchPath -Filter $pattern -Recurse -ErrorAction SilentlyContinue

    if ($results) {
        Write-Host ""
        $results | ForEach-Object {
            $file = $_
            if ($file.PSIsContainer) {
                $size = "${teal}[dir]${reset}"
            } elseif ($file.Length -ge 1MB) {
                $size = "${yellow}$([math]::Round($file.Length / 1MB, 2)) MB${reset}"
            } elseif ($file.Length -ge 1KB) {
                $size = "${green}$([math]::Round($file.Length / 1KB, 2)) KB${reset}"
            } else {
                $size = "${lavender}$($file.Length) B${reset}"
            }

            $created  = $file.CreationTime.ToString("yyyy-MM-dd HH:mm")
            $modified = $file.LastWriteTime.ToString("yyyy-MM-dd HH:mm")

            Write-Host "  ${pink}▶${reset} ${bold}$($file.FullName)${reset}"
            Write-Host "      ${overlay}size${reset}     $size"
            Write-Host "      ${overlay}created${reset}  ${sapphire}$created${reset}   ${overlay}modified${reset}  ${peach}$modified${reset}"
            Write-Host ""
        }

        Write-Host "  ${overlay}$("─" * 60)${reset}"
        Write-Host "  ${mauve}◆${reset}  ${overlay}found${reset} ${peach}${bold}$($results.Count)${reset} ${overlay}result(s)${reset}"
    } else {
        Write-Host ""
        Write-Host "  ${red}✦${reset}  No files found for ${peach}$pattern${reset}"
    }
    Write-Host ""
}

# ─────────────────────────────────────────
#  uptime — how long the system has been running
# ─────────────────────────────────────────
function uptime {
    $ESC      = [char]27
    $mauve    = "$ESC[38;2;203;166;247m"
    $peach    = "$ESC[38;2;250;179;135m"
    $green    = "$ESC[38;2;166;227;161m"
    $yellow   = "$ESC[38;2;249;226;175m"
    $teal     = "$ESC[38;2;148;226;213m"
    $sapphire = "$ESC[38;2;116;199;236m"
    $pink     = "$ESC[38;2;245;194;231m"
    $overlay  = "$ESC[38;2;108;112;134m"
    $bold     = "$ESC[1m"
    $reset    = "$ESC[0m"

    $bootTime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    $up       = (Get-Date) - $bootTime

    $days    = $up.Days
    $hours   = $up.Hours
    $minutes = $up.Minutes

    # Animated bar fill
    function Animate-Bar {
        param([string]$label, [string]$color, [int]$value, [int]$maxVal, [int]$width = 24)
        $pct    = if ($maxVal -gt 0) { [math]::Min([math]::Round(($value / $maxVal) * $width), $width) } else { 0 }
        [Console]::Write("  ${overlay}$label${reset}  [${overlay}$("░" * $width)${reset}]  ")
        Start-Sleep -Milliseconds 80
        for ($i = 1; $i -le $pct; $i++) {
            $filled = "█" * $i
            $empty  = "░" * ($width - $i)
            [Console]::Write("`r  ${overlay}$label${reset}  [${color}$filled${overlay}$empty${reset}]  ")
            Start-Sleep -Milliseconds (Get-Random -Minimum 15 -Maximum 50)
        }
        $valStr = "${color}${bold}$value${reset}${overlay} / $maxVal${reset}"
        [Console]::WriteLine("`r  ${overlay}$label${reset}  [${color}$("█" * $pct)${overlay}$("░" * ($width - $pct))${reset}]  $valStr")
    }

    Write-Host ""
    [Console]::WriteLine("  ${mauve}${bold}◆ UPTIME${reset}")
    [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
    Write-Host ""
    $culture = [System.Globalization.CultureInfo]::GetCultureInfo("en-US")
    [Console]::WriteLine("  ${overlay}booted${reset}  ${teal}$($bootTime.ToString("dddd, MMMM dd yyyy", $culture))${reset}  ${overlay}at${reset}  ${sapphire}$($bootTime.ToString("HH:mm"))${reset}")
    Write-Host ""

    Animate-Bar "days   " $yellow  $days    365
    Animate-Bar "hours  " $peach   $hours   23
    Animate-Bar "minutes" $green   $minutes 59

    Write-Host ""
    $totalHours = [math]::Round($up.TotalHours, 1)
    [Console]::WriteLine("  ${overlay}total  ${reset}  ${pink}${bold}$totalHours h${reset}  ${overlay}($([math]::Round($up.TotalMinutes)) minutes)${reset}")
    Write-Host ""
}
