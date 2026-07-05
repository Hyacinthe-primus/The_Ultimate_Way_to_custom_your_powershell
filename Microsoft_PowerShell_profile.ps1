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

function cls { Clear-Host }

#  whereis — find anything: commands, apps, exes
#
#  Usage:
#    whereis git                  → path in $env:PATH
#    whereis "File Converter Pro" → installed app location
#    whereis ffmpeg               → searches both

function whereis {
    param([Parameter(Mandatory=$true)][string]$name)

    $ESC     = [char]27
    $mauve   = "$ESC[38;2;203;166;247m"
    $green   = "$ESC[38;2;166;227;161m"
    $peach   = "$ESC[38;2;250;179;135m"
    $yellow  = "$ESC[38;2;249;226;175m"
    $overlay = "$ESC[38;2;108;112;134m"
    $red     = "$ESC[38;2;243;139;168m"
    $bold    = "$ESC[1m"
    $reset   = "$ESC[0m"

    $found = $false

    Write-Host ""
    Write-Host "  ${mauve}${bold}◆ WHEREIS${reset}  ${overlay}searching for${reset}  ${peach}${bold}$name${reset}"
    Write-Host ""

    # 1 — Command in PATH (exe, cmdlet, function, alias)
    $cmd = Get-Command $name -ErrorAction SilentlyContinue
    if ($cmd) {
        $found = $true
        $type  = $cmd.CommandType
        $src   = if ($cmd.Source) { $cmd.Source } else { "(built-in $type)" }
        Write-Host "  ${green}●${reset}  ${bold}Command${reset}  ${overlay}[$type]${reset}"
        Write-Host "     ${yellow}$src${reset}"
        Write-Host ""
    }

    # 2 — Installed apps in registry (HKLM + HKCU, 32 & 64-bit)
    $regPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    $apps = foreach ($rp in $regPaths) {
        Get-ItemProperty $rp -ErrorAction SilentlyContinue |
            Where-Object { $_.DisplayName -like "*$name*" }
    }
    if ($apps) {
        $found = $true
        foreach ($app in $apps) {
            $loc = if ($app.InstallLocation) { $app.InstallLocation.TrimEnd('\') } else { "(location not set)" }
            $ver = if ($app.DisplayVersion)  { "  ${overlay}v$($app.DisplayVersion)${reset}" } else { "" }
            Write-Host "  ${green}●${reset}  ${bold}Installed App${reset}$ver"
            Write-Host "     ${overlay}Name   :${reset} $($app.DisplayName)"
            Write-Host "     ${yellow}Location: $loc${reset}"
            if ($app.InstallLocation -and (Test-Path $app.InstallLocation)) {
                $exes = Get-ChildItem $app.InstallLocation -Filter "*.exe" -ErrorAction SilentlyContinue |
                    Select-Object -First 5
                if ($exes) {
                    Write-Host "     ${overlay}Exe(s)  :${reset}"
                    foreach ($exe in $exes) {
                        Write-Host "       ${peach}$($exe.FullName)${reset}"
                    }
                }
            }
            Write-Host ""
        }
    }

    if (-not $found) {
        Write-Host "  ${red}✖${reset}  Nothing found for ${bold}$name${reset}"
        Write-Host "     ${overlay}Not in PATH, not in installed apps registry.${reset}"
        Write-Host ""
    }
}

#  mkcd — create folder and cd into it
function mkcd {
    param([Parameter(Mandatory=$true)][string]$dir)
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    Set-Location $dir
}

#  show — file search
#
#  Usage:
#    show filename.txt           → current folder only
#    show filename               → current folder, all "*filename*"
#    show -u filename.txt        → user folder (C:\Users\<you>)
#    show -deep filename.txt     → entire system (C:\)
#    show -from "C:\path" name   → from a specific folder

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

    if ($name -match "^\.\w+$") {
        $pattern = "*$name"
    } elseif ($name -match "\.") {
        $pattern = $name
    } else {
        $pattern = "*$name*"
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

#  weather — terminal weather forecast
#  Usage:
#    weather           → forecast for default city (Sydney)
#    weather Paris     → forecast for a given city

function weather {
    param([string]$city = "Sydney")

    $ESC      = [char]27
    $mauve    = "$ESC[38;2;203;166;247m"
    $peach    = "$ESC[38;2;250;179;135m"
    $green    = "$ESC[38;2;166;227;161m"
    $yellow   = "$ESC[38;2;249;226;175m"
    $teal     = "$ESC[38;2;148;226;213m"
    $sapphire = "$ESC[38;2;116;199;236m"
    $pink     = "$ESC[38;2;245;194;231m"
    $red      = "$ESC[38;2;243;139;168m"
    $overlay  = "$ESC[38;2;108;112;134m"
    $bold     = "$ESC[1m"
    $reset    = "$ESC[0m"

    Write-Host ""
    [Console]::WriteLine("  ${mauve}${bold}◆ WEATHER${reset}  ${overlay}fetching for${reset} ${peach}${bold}$city${reset}")
    [Console]::WriteLine("  ${overlay}$("─" * 52)${reset}")
    Write-Host ""

    try {
        $encoded  = [System.Uri]::EscapeDataString($city)
        $geoUrl   = "https://geocoding-api.open-meteo.com/v1/search?name=$encoded&count=1&language=en&format=json"
        $geo      = Invoke-RestMethod -Uri $geoUrl -TimeoutSec 8 -ErrorAction Stop

        if (-not $geo.results -or $geo.results.Count -eq 0) {
            [Console]::WriteLine("  ${red}✦  City not found:${reset}  ${peach}$city${reset}")
            Write-Host ""
            return
        }

        $lat      = $geo.results[0].latitude
        $lon      = $geo.results[0].longitude
        $name     = $geo.results[0].name
        $country  = $geo.results[0].country

        $wxUrl = "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon" +
                 "&current=temperature_2m,apparent_temperature,relative_humidity_2m," +
                 "wind_speed_10m,weather_code,visibility" +
                 "&daily=weather_code,temperature_2m_max,temperature_2m_min" +
                 "&wind_speed_unit=kmh&timezone=auto&forecast_days=3"

        $wx = Invoke-RestMethod -Uri $wxUrl -TimeoutSec 8 -ErrorAction Stop

        $cur      = $wx.current
        $tempC    = $cur.temperature_2m
        $feelsC   = $cur.apparent_temperature
        $humidity = $cur.relative_humidity_2m
        $windKmph = $cur.wind_speed_10m
        $wCode    = $cur.weather_code
        $vis      = [math]::Round($cur.visibility / 1000, 1)

        function Get-WeatherDesc {
            param([int]$code)
            switch ($code) {
                0       { return @("Clear sky",           "☀️ ") }
                1       { return @("Mainly clear",        "🌤️ ") }
                2       { return @("Partly cloudy",       "⛅ ") }
                3       { return @("Overcast",            "☁️ ") }
                {$_ -in 45,48} { return @("Fog",         "🌫️ ") }
                {$_ -in 51,53,55} { return @("Drizzle",  "🌦️ ") }
                {$_ -in 61,63,65} { return @("Rain",     "🌧️ ") }
                {$_ -in 71,73,75} { return @("Snow",     "❄️ ") }
                {$_ -in 80,81,82} { return @("Showers",  "🌧️ ") }
                {$_ -in 95,96,99} { return @("Thunderstorm", "⛈️ ") }
                default { return @("Unknown", "🌡️ ") }
            }
        }

        $descIcon = Get-WeatherDesc $wCode
        $desc     = $descIcon[0]
        $icon     = $descIcon[1]

        [Console]::WriteLine("  ${overlay}location   ${reset}  ${yellow}${bold}$name${reset}${overlay}, $country${reset}")
        [Console]::WriteLine("  ${overlay}condition  ${reset}  $icon  ${yellow}${bold}$desc${reset}")
        [Console]::WriteLine("  ${overlay}temp       ${reset}  ${peach}${bold}$tempC °C${reset}  ${overlay}feels like${reset}  ${sapphire}$feelsC °C${reset}")
        [Console]::WriteLine("  ${overlay}humidity   ${reset}  ${teal}${bold}$humidity%${reset}")
        [Console]::WriteLine("  ${overlay}wind       ${reset}  ${green}${bold}$windKmph km/h${reset}")
        [Console]::WriteLine("  ${overlay}visibility ${reset}  ${pink}${bold}$vis km${reset}")

        Write-Host ""
        [Console]::WriteLine("  ${mauve}${bold}  3-DAY FORECAST${reset}")
        [Console]::WriteLine("  ${overlay}  $("─" * 44)${reset}")
        $culture = [System.Globalization.CultureInfo]::GetCultureInfo("en-US")
        for ($i = 0; $i -lt $wx.daily.time.Count; $i++) {
            $date    = [datetime]::ParseExact($wx.daily.time[$i], "yyyy-MM-dd", $culture)
            $dayName = $date.ToString("ddd dd MMM", $culture).PadRight(12)
            $maxC    = $wx.daily.temperature_2m_max[$i]
            $minC    = $wx.daily.temperature_2m_min[$i]
            $dCode   = $wx.daily.weather_code[$i]
            $dDesc   = (Get-WeatherDesc $dCode)[0]
            [Console]::WriteLine("  ${overlay}  $dayName${reset}  ${peach}↑$maxC°${reset}  ${sapphire}↓$minC°${reset}  ${overlay}$dDesc${reset}")
        }

    } catch {
        [Console]::WriteLine("  ${red}✦  Could not fetch weather.${reset}  ${overlay}$($_.Exception.Message)${reset}")
    }
    Write-Host ""
}

#  cdh — directory bookmarks
#  Usage:
#    cdh                  → list saved bookmarks
#    cdh save             → bookmark current directory
#    cdh save myproject   → bookmark with a custom label
#    cdh myproject        → jump to bookmark
#    cdh del myproject    → remove bookmark

function cdh {
    param(
        [Parameter(Position=0)][string]$action = "",
        [Parameter(Position=1)][string]$label  = ""
    )

    $ESC      = [char]27
    $mauve    = "$ESC[38;2;203;166;247m"
    $peach    = "$ESC[38;2;250;179;135m"
    $green    = "$ESC[38;2;166;227;161m"
    $yellow   = "$ESC[38;2;249;226;175m"
    $teal     = "$ESC[38;2;148;226;213m"
    $pink     = "$ESC[38;2;245;194;231m"
    $red      = "$ESC[38;2;243;139;168m"
    $overlay  = "$ESC[38;2;108;112;134m"
    $bold     = "$ESC[1m"
    $reset    = "$ESC[0m"

    $bookmarkDir  = "$env:USERPROFILE\.config\hyacinthe"
    $bookmarkFile = "$bookmarkDir\bookmarks.json"

    if (-not (Test-Path $bookmarkDir)) { New-Item -ItemType Directory -Path $bookmarkDir -Force | Out-Null }

    $bookmarks = @{}
    if (Test-Path $bookmarkFile) {
        try {
            $raw = Get-Content $bookmarkFile -Raw | ConvertFrom-Json
            $raw.PSObject.Properties | ForEach-Object { $bookmarks[$_.Name] = $_.Value }
        } catch {}
    }

    function Save-Bookmarks {
        $obj = [PSCustomObject]$bookmarks
        $obj | ConvertTo-Json | Set-Content $bookmarkFile -Encoding UTF8
    }

    if ($action -eq "save") {
        $key = if ($label -ne "") { $label } else { Split-Path $PWD -Leaf }
        $bookmarks[$key] = $PWD.Path
        Save-Bookmarks
        Write-Host ""
        [Console]::WriteLine("  ${green}✦${reset}  ${overlay}Bookmarked:${reset}  ${yellow}${bold}$key${reset}  ${overlay}→${reset}  ${teal}$($PWD.Path)${reset}")
        Write-Host ""
        return
    }

    if ($action -eq "del") {
        if ($bookmarks.ContainsKey($label)) {
            $bookmarks.Remove($label)
            Save-Bookmarks
            Write-Host ""
            [Console]::WriteLine("  ${red}✦${reset}  ${overlay}Removed:${reset}  ${peach}$label${reset}")
            Write-Host ""
        } else {
            Write-Host ""
            [Console]::WriteLine("  ${red}✦  Bookmark not found:${reset}  ${peach}$label${reset}")
            Write-Host ""
        }
        return
    }

    if ($action -ne "" -and $bookmarks.ContainsKey($action)) {
        Set-Location $bookmarks[$action]
        Write-Host ""
        [Console]::WriteLine("  ${mauve}✦${reset}  ${overlay}Jumped to:${reset}  ${teal}$($bookmarks[$action])${reset}")
        Write-Host ""
        return
    }

    Write-Host ""
    [Console]::WriteLine("  ${mauve}${bold}◆ BOOKMARKS${reset}")
    [Console]::WriteLine("  ${overlay}$("─" * 52)${reset}")
    Write-Host ""
    if ($bookmarks.Count -eq 0) {
        [Console]::WriteLine("  ${overlay}No bookmarks yet. Use:  ${reset}${peach}cdh save [label]${reset}")
    } else {
        foreach ($key in $bookmarks.Keys) {
            [Console]::WriteLine("  ${yellow}${bold}$($key.PadRight(16))${reset}  ${teal}$($bookmarks[$key])${reset}")
        }
    }
    Write-Host ""
}

#  hash — compute file/string hash (SHA256 / MD5 / SHA1)
#  Usage:
#    hash file.exe            → SHA256
#    hash file.exe -md5       → MD5
#    hash -text "hello"       → hash a string

function hash {
    param(
        [Parameter(Position=0)][string]$target = "",
        [switch]$md5,
        [switch]$sha1,
        [string]$text = ""
    )

    $ESC     = [char]27
    $mauve   = "$ESC[38;2;203;166;247m"
    $green   = "$ESC[38;2;166;227;161m"
    $teal    = "$ESC[38;2;148;226;213m"
    $peach   = "$ESC[38;2;250;179;135m"
    $red     = "$ESC[38;2;243;139;168m"
    $overlay = "$ESC[38;2;108;112;134m"
    $bold    = "$ESC[1m"
    $reset   = "$ESC[0m"

    $algo = if ($md5) { "MD5" } elseif ($sha1) { "SHA1" } else { "SHA256" }

    Write-Host ""
    [Console]::WriteLine("  ${mauve}${bold}◆ HASH${reset}  ${overlay}algorithm${reset}  ${teal}$algo${reset}")
    [Console]::WriteLine("  ${overlay}$("─" * 60)${reset}")
    Write-Host ""

    try {
        if ($text -ne "") {
            $bytes  = [System.Text.Encoding]::UTF8.GetBytes($text)
            $hasher = [System.Security.Cryptography.HashAlgorithm]::Create($algo)
            $result = ($hasher.ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") }) -join ""
            [Console]::WriteLine("  ${overlay}input   ${reset}  ${peach}$text${reset}")
            [Console]::WriteLine("  ${overlay}$algo  ${reset}  ${green}${bold}$result${reset}")
        } elseif ($target -ne "" -and (Test-Path $target)) {
            [Console]::Write("  ${overlay}Computing...${reset}")
            $result = (Get-FileHash -Path $target -Algorithm $algo).Hash.ToLower()
            [Console]::WriteLine("`r  ${overlay}file    ${reset}  ${peach}$target${reset}")
            [Console]::WriteLine("  ${overlay}$algo  ${reset}  ${green}${bold}$result${reset}")
        } else {
            [Console]::WriteLine("  ${red}✦  Provide a file path or use -text 'string'${reset}")
        }
        if ($result) {
            $result | Set-Clipboard
            [Console]::WriteLine("")
            [Console]::WriteLine("  ${overlay}Copied to clipboard.${reset}")
        }
    } catch {
        [Console]::WriteLine("  ${red}✦  Error: $($_.Exception.Message)${reset}")
    }
    Write-Host ""
}

#  hex — hex dump of a file
#  Usage:
#    hex file.bin       → first 256 bytes
#    hex file.bin 512    → first N bytes

function hex {
    param(
        [Parameter(Mandatory=$true)][string]$file,
        [int]$bytes = 256
    )

    $file = [System.IO.Path]::GetFullPath($file, $PWD.ProviderPath)

    $ESC     = [char]27
    $mauve   = "$ESC[38;2;203;166;247m"
    $green   = "$ESC[38;2;166;227;161m"
    $teal    = "$ESC[38;2;148;226;213m"
    $peach   = "$ESC[38;2;250;179;135m"
    $yellow  = "$ESC[38;2;249;226;175m"
    $red     = "$ESC[38;2;243;139;168m"
    $overlay = "$ESC[38;2;108;112;134m"
    $bold    = "$ESC[1m"
    $reset   = "$ESC[0m"

    if (-not (Test-Path $file)) {
        Write-Host ""
        [Console]::WriteLine("  ${red}✦  File not found: $file${reset}")
        Write-Host ""
        return
    }

    Write-Host ""
    [Console]::WriteLine("  ${mauve}${bold}◆ HEX DUMP${reset}  ${overlay}$file  (first $bytes bytes)${reset}")
    [Console]::WriteLine("  ${overlay}$("─" * 70)${reset}")
    Write-Host ""

    $data   = [System.IO.File]::ReadAllBytes($file)
    $count  = [math]::Min($bytes, $data.Count)
    $offset = 0

    while ($offset -lt $count) {
        $chunk  = $data[$offset..([math]::Min($offset + 15, $count - 1))]
        $addr   = "0x{0:X4}" -f $offset
        $hexStr = ($chunk | ForEach-Object { "{0:X2}" -f $_ }) -join " "
        $hexStr = $hexStr.PadRight(47)
        $ascii  = -join ($chunk | ForEach-Object {
            $c = [char]$_
            if ([char]::IsControl($c) -or $_ -gt 126) { "." } else { "$c" }
        })

        [Console]::WriteLine("  ${overlay}$addr${reset}  ${teal}$hexStr${reset}  ${yellow}$ascii${reset}")
        $offset += 16
    }

    Write-Host ""
    [Console]::WriteLine("  ${overlay}$($data.Count) bytes total · showing $count${reset}")
    Write-Host ""
}

#  help — custom command reference
#  Usage:
#    help          → show all commands
#    help [keyword] → filter by keyword

function help {
    param([string]$filter = "")

    $ESC      = [char]27
    $mauve    = "$ESC[38;2;203;166;247m"
    $yellow   = "$ESC[38;2;249;226;175m"
    $teal     = "$ESC[38;2;148;226;213m"
    $pink     = "$ESC[38;2;245;194;231m"
    $overlay  = "$ESC[38;2;108;112;134m"
    $bold     = "$ESC[1m"
    $reset    = "$ESC[0m"

    $cmds = @(
        [PSCustomObject]@{ cat="Nav & Files"; name="ll";      desc="Detailed file listing (all files)" }
        [PSCustomObject]@{ cat="Nav & Files"; name="touch";   desc="Create empty file or update timestamp" }
        [PSCustomObject]@{ cat="Nav & Files"; name="mkcd";    desc="Create directory and cd into it" }
        [PSCustomObject]@{ cat="Nav & Files"; name="show";    desc="Search files (-u user, -deep system, -from path)" }
        [PSCustomObject]@{ cat="Nav & Files"; name="cdh";     desc="Directory bookmarks (save / jump / del)" }
        [PSCustomObject]@{ cat="Nav & Files"; name="hex";     desc="Hex dump of a file" }
        [PSCustomObject]@{ cat="Nav & Files"; name="cls";     desc="Clear the terminal" }
        [PSCustomObject]@{ cat="Tools";       name="whereis"; desc="Find commands + installed apps (registry)" }
        [PSCustomObject]@{ cat="Tools";       name="hash";    desc="SHA256 / MD5 / SHA1 hash (-md5 -sha1 -text)" }
        [PSCustomObject]@{ cat="Tools";       name="weather"; desc="Terminal weather (weather city)" }
        [PSCustomObject]@{ cat="Tools";       name="help";    desc="This command reference (help [keyword])" }
    )

    if ($filter) { $cmds = $cmds | Where-Object { $_.name -like "*$filter*" -or $_.desc -like "*$filter*" -or $_.cat -like "*$filter*" } }

    Write-Host ""
    [Console]::WriteLine("  ${mauve}${bold}◆ COMMAND REFERENCE${reset}")
    [Console]::WriteLine("  ${overlay}$("─" * 40)${reset}")

    $grouped = $cmds | Group-Object cat
    foreach ($g in $grouped) {
        Write-Host ""
        [Console]::WriteLine("  ${pink}${bold}$($g.Name.ToUpper())${reset}")
        foreach ($c in $g.Group) {
            $name = "${yellow}${bold}$($c.name.PadRight(14))${reset}"
            [Console]::WriteLine("  $name  ${overlay}$($c.desc)${reset}")
        }
    }

    Write-Host ""
    [Console]::WriteLine("  ${overlay}Usage: ${reset}${teal}help [keyword]${reset}  ${overlay}to filter commands${reset}")
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
