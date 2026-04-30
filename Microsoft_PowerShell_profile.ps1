# PowerShell 7 — Catppuccin Mocha
# Requires: fastfetch, Nerd Font

try {
    [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    chcp 65001 > $null
} catch {}

Clear-Host

if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    & "$env:USERPROFILE/.config/fastfetch/fastfetch-random.ps1"
}

$green   = "`e[38;2;166;227;161m"
$yellow  = "`e[38;2;249;226;175m"
$mauve   = "`e[38;2;203;166;247m"
$pink    = "`e[38;2;245;194;231m"
$peach   = "`e[38;2;250;179;135m"
$reset   = "`e[0m"

$culture = [System.Globalization.CultureInfo]::GetCultureInfo("en-US")
$date    = (Get-Date).ToString("dddd, MMMM dd yyyy", $culture)
$time    = Get-Date -Format "HH:mm"
Write-Host ""
Write-Host "  $green◆$reset  $yellow$date$reset  $mauve$time$reset"

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
Write-Host "  $pink✦$reset  $peach$quote$reset"
Write-Host ""

function ll { Get-ChildItem -Force @args }

function touch {
    param([string]$path)
    if (Test-Path $path) {
        (Get-Item $path).LastWriteTime = Get-Date
    } else {
        New-Item -ItemType File -Path $path | Out-Null
    }
}

function which {
    param([string]$cmd)
    Get-Command $cmd -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
}

function cls { Clear-Host }

# show — file search
# Usage:
#   show filename.txt           → current folder only
#   show filename               → current folder, all "filename.*"
#   show -u filename.txt        → user folder (C:\Users\<you>)
#   show -deep filename.txt     → entire system (C:\)
#   show -from "C:\path" name   → from a specific folder
function show {
    param(
        [switch]$u,
        [switch]$deep,
        [string]$from,
        [Parameter(Mandatory=$true, Position=0)]
        [string]$name
    )

    $mauve    = "`e[38;2;203;166;247m"
    $pink     = "`e[38;2;245;194;231m"
    $peach    = "`e[38;2;250;179;135m"
    $yellow   = "`e[38;2;249;226;175m"
    $green    = "`e[38;2;166;227;161m"
    $teal     = "`e[38;2;148;226;213m"
    $sky      = "`e[38;2;137;220;235m"
    $sapphire = "`e[38;2;116;199;236m"
    $lavender = "`e[38;2;180;190;254m"
    $red      = "`e[38;2;243;139;168m"
    $overlay  = "`e[38;2;108;112;134m"
    $bold     = "`e[1m"
    $reset    = "`e[0m"

    if ($from)     { $searchPath = $from }
    elseif ($u)    { $searchPath = $env:USERPROFILE }
    elseif ($deep) { $searchPath = "C:\" }
    else           { $searchPath = $PWD.Path }

    $pattern = if ($name -match "\.") { $name } else { "$name.*" }

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

function prompt {
    $mauve    = "`e[38;2;203;166;247m"
    $teal     = "`e[38;2;148;226;213m"
    $lavender = "`e[38;2;180;190;254m"
    $pink     = "`e[38;2;245;194;231m"
    $reset    = "`e[0m"

    $mochaPalette = @(
        "`e[38;2;243;139;168m"
        "`e[38;2;250;179;135m"
        "`e[38;2;249;226;175m"
        "`e[38;2;166;227;161m"
        "`e[38;2;137;220;235m"
        "`e[38;2;116;199;236m"
        "`e[38;2;137;180;250m"
        "`e[38;2;203;166;247m"
        "`e[38;2;245;194;231m"
    )

    $username = $env:USERNAME
    $parts    = $PWD.Path -split "\\"
    $colored  = for ($i = 0; $i -lt $parts.Count; $i++) {
        if ($i -eq 0)                    { "$mauve$($parts[$i])" }
        elseif ($parts[$i] -eq "Users")  { "$teal$($parts[$i])" }
        elseif ($parts[$i] -eq $username){ "$lavender$($parts[$i])" }
        else {
            $randColor = $mochaPalette | Get-Random
            "$randColor$($parts[$i])"
        }
    }
    $path = $colored -join "$reset\"

    "$mauve󰁔 $path$pink $ »$reset "
}
