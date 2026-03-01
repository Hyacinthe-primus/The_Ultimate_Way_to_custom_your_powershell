# Windows PowerShell 5 Profile — Catppuccin Mocha Theme
# Requires: fastfetch, Nerd Font (e.g. JetBrainsMono Nerd Font)
# Save this file as UTF-8 with BOM for special characters to display correctly

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
#  Fastfetch (edit path to match yours)
# ─────────────────────────────────────────
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    & "$env:USERPROFILE\.config\fastfetch\fastfetch-random.ps1"
}

# ─────────────────────────────────────────
#  Welcome message
# ─────────────────────────────────────────
$green   = [char]27 + "[38;2;166;227;161m"  # #A6E3A1
$yellow  = [char]27 + "[38;2;249;226;175m"  # #F9E2AF
$mauve   = [char]27 + "[38;2;203;166;247m"  # #CBA6F7
$pink    = [char]27 + "[38;2;245;194;231m"  # #F5C2E7
$peach   = [char]27 + "[38;2;250;179;135m"  # #FAB387
$reset   = [char]27 + "[0m"

$culture = [System.Globalization.CultureInfo]::GetCultureInfo("en-US")
$date = (Get-Date).ToString("dddd, MMMM dd yyyy", $culture)
$time = Get-Date -Format "HH:mm"
Write-Host ""
Write-Host "  ${green}◆${reset}  ${yellow}${date}${reset}  ${mauve}${time}${reset}"

$quotes = @(
    "Code is like humor. When you have to explain it, it's bad."
    "First, solve the problem. Then, write the code."
    "Simplicity is the ultimate sophistication."
    "Programs must be written for people to read, not machines to execute."
    "The best code is no code at all."
    "Debugging is twice as hard as writing the code in the first place."
    "If it works, don't touch it."
    "There is no place for magic in production code."
    "Perfection is achieved when there is nothing left to remove."
    "A good developer looks both ways before crossing a one-way street."
)
$quote = $quotes | Get-Random
Write-Host "  ${pink}✦${reset}  ${peach}${quote}${reset}"
Write-Host ""

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

    # PS5 uses [char]27 instead of `e for ANSI escape sequences
    $mauve    = [char]27 + "[38;2;203;166;247m"  # #CBA6F7
    $pink     = [char]27 + "[38;2;245;194;231m"  # #F5C2E7
    $peach    = [char]27 + "[38;2;250;179;135m"  # #FAB387
    $yellow   = [char]27 + "[38;2;249;226;175m"  # #F9E2AF
    $green    = [char]27 + "[38;2;166;227;161m"  # #A6E3A1
    $teal     = [char]27 + "[38;2;148;226;213m"  # #94E2D5
    $sky      = [char]27 + "[38;2;137;220;235m"  # #89DCEB
    $sapphire = [char]27 + "[38;2;116;199;236m"  # #74C7EC
    $lavender = [char]27 + "[38;2;180;190;254m"  # #B4BEFE
    $red      = [char]27 + "[38;2;243;139;168m"  # #F38BA8
    $overlay  = [char]27 + "[38;2;108;112;134m"  # #6C7086
    $bold     = [char]27 + "[1m"
    $reset    = [char]27 + "[0m"

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
#  Prompt — Catppuccin Mocha
# ─────────────────────────────────────────
function prompt {
    $mauve    = [char]27 + "[38;2;203;166;247m"  # #CBA6F7
    $teal     = [char]27 + "[38;2;148;226;213m"  # #94E2D5
    $lavender = [char]27 + "[38;2;180;190;254m"  # #B4BEFE
    $pink     = [char]27 + "[38;2;245;194;231m"  # #F5C2E7
    $reset    = [char]27 + "[0m"

    $mochaPalette = @(
        ([char]27 + "[38;2;243;139;168m")  # Red      #F38BA8
        ([char]27 + "[38;2;250;179;135m")  # Peach    #FAB387
        ([char]27 + "[38;2;249;226;175m")  # Yellow   #F9E2AF
        ([char]27 + "[38;2;166;227;161m")  # Green    #A6E3A1
        ([char]27 + "[38;2;137;220;235m")  # Sky      #89DCEB
        ([char]27 + "[38;2;116;199;236m")  # Sapphire #74C7EC
        ([char]27 + "[38;2;137;180;250m")  # Blue     #89B4FA
        ([char]27 + "[38;2;203;166;247m")  # Mauve    #CBA6F7
        ([char]27 + "[38;2;245;194;231m")  # Pink     #F5C2E7
    )

    # Get current username for color mapping
    $username = $env:USERNAME

    $parts = $PWD.Path -split "\\"
    $colored = for ($i = 0; $i -lt $parts.Count; $i++) {
        if ($i -eq 0)                    { "$mauve$($parts[$i])" }
        elseif ($parts[$i] -eq "Users")  { "$teal$($parts[$i])" }
        elseif ($parts[$i] -eq $username){ "$lavender$($parts[$i])" }
        else {
            $randColor = $mochaPalette | Get-Random
            "$randColor$($parts[$i])"
        }
    }
    $path = $colored -join "$reset\"

    "${mauve}󰁔 $path${pink} $ »${reset} "
}
