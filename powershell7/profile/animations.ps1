# ─────────────────────────────────────────
#  Animations — train, hack, matrix
# ─────────────────────────────────────────
# ─────────────────────────────────────────
#  train / loco — braille train animation
# ─────────────────────────────────────────

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
param()

function Invoke-TrainAnimation {
    $trainArt = @(
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡴⠋⠑⠉⠉⠑⣆⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⡇⠀⠀⠀⠀⠀⠀⠀⠹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠤⣀⠀⠀⠀⠀⠀⣈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠑⠒⠉⠉⠀⠀⢀⡤⠶⠒⢦⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣯⠀⠀⠀⠀⠀⠹⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣤⡀⠀⠀⠀⣸⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⣀⡤⠶⠒⠒⠉⠉⠉⣝⠝⣩⠋⣀⡼⠛⢋⣉⣉⣉⣵⣶⣦⠀⠀⠀⠀⠀⠉⠙⢒⣋⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⢠⡞⠛⠒⠒⠚⠛⠛⠛⠋⠉⠉⢉⣻⣉⣉⡉⠩⠭⠤⠤⣴⠶⠞⠀⠀⠀⠀⠀⠀⢠⣏⣉⣝⣉⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠈⠋⠉⡏⣉⣉⣩⡭⠭⠥⠤⠤⢤⢸⢠⠄⠐⠒⠒⠒⢲⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⣭⣁⣤⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⡇⡇⠉⠉⠉⠉⠉⠉⠙⢸⢸⣼⠀⠀⠀⠀⠀⢸⢸⣤⠤⣤⡀⣰⠋⢹⢷⡄⢸⢹⠁⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⡇⡇⣇⣀⣀⣀⣀⣀⣀⢸⠘⡿⠦⠤⢤⡴⠶⢾⡼⣏⡀⠈⣧⣿⠀⠀⠼⡷⢾⣾⠀⠀⡷⢶⡶⠶⢶⡶⠶⢤⡀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⡇⡧⠿⠶⠆⠀⠀⠀⠀⢸⠀⡇⢀⡔⠁⠀⡴⠋⠀⠿⠷⠾⠟⢿⣒⣐⣲⠿⢸⣿⣥⣶⡿⠎⠀⢠⠏⢀⡔⠢⣻⡀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⣿⣧⣠⣤⣤⣄⣀⠀⠀⠈⠀⡇⡸⠀⠀⢰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⣼⠀⠘⠀⢰⢻⢷⡀⠀⠀⠀",
        "⠀⠀⠀⣠⣿⡞⠛⢉⠙⠟⣿⢿⣷⣄⣿⣷⣇⠀⠀⢸⢀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠀⠀⢿⡀⢀⠀⢸⣄⣩⠇⠀⠀⠀",
        "⠀⣠⢾⣡⡶⠟⠉⠉⠉⠻⢷⣿⡹⢿⣿⣿⣿⡄⠀⠈⣿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⣆⠀⠘⡿⢿⣄⢈⣿⡏⠀⠀⠀⠀",
        "⢰⠋⣾⠟⠀⠀⠀⡀⡀⠀⠀⠙⢿⣄⠻⣿⣿⣿⣦⣄⣈⣢⣴⣤⣤⣤⣤⣤⣤⣤⣦⣤⣴⣶⣶⣶⣶⣾⣦⣀⣘⣾⣿⡿⣿⣦⠀⠀⠀⠀",
        "⡇⢱⣿⣤⣤⣤⡞⠉⠙⢷⣤⣤⣼⣿⡘⣿⣿⣿⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣱⣱⣀⣨⠞⣫⣿⠀⠀",
        "⣷⢼⣿⣿⣿⣿⣧⣀⣀⣼⣿⣿⣿⣿⢻⣿⣿⣿⣿⠛⠚⠻⣿⣿⣿⣿⡿⠛⠁⠻⣯⣿⣿⣿⡿⠛⠛⢻⣿⣿⣿⣿⣿⣽⡶⣺⣿⣿⣷⣄",
        "⠸⣷⠻⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⠛⣼⠿⢿⣿⣷⣶⠒⣶⣾⣿⣻⣿⣧⣶⠒⣶⣿⣷⢿⣿⣤⣴⠚⣟⠙⣷⣯⠙⣿⣿⣿⣿⣿⣿⣿⣿",
        "⠀⠙⣿⣽⠿⣿⣿⣿⣿⣿⣿⠟⣡⡴⠃⠀⢸⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣶⣭⣴⣯⡏⠀⢿⣿⣿⣿⣿⣿⣯⡏",
        "⠀⠀⠀⠙⠿⠷⣯⣭⣽⣿⠶⠟⠋⠀⠀⠀⠀⠙⠿⣿⣿⣿⠿⠋⠀⠙⠿⣿⣿⣿⠿⠋⠀⠙⢿⣿⣿⣿⠿⠋⠀⠀⠀⠀⠉⠙⠛⠿⠿⠇"
    )

    $trainWidth = 50
    $screenWidth = [Console]::WindowWidth
    $trainHeight = $trainArt.Count

    $ESC = [char]27
    $colors = @(
        "$ESC[38;2;203;166;247m"  # Mauve
        "$ESC[38;2;137;180;250m"  # Blue
        "$ESC[38;2;116;199;236m"  # Sapphire
        "$ESC[38;2;137;220;235m"  # Sky
        "$ESC[38;2;148;226;213m"  # Teal
    )
    $reset = "$ESC[0m"

    [Console]::CursorVisible = $false

    for ($i = 0; $i -lt $trainHeight + 1; $i++) { Write-Host "" }
    $startRow = [Console]::CursorTop - $trainHeight - 1

    try {
        for ($x = -$trainWidth; $x -lt $screenWidth; $x += 2) {
            $colorIdx = [Math]::Abs($x) % $colors.Count
            $color = $colors[$colorIdx]

            for ($row = 0; $row -lt $trainHeight; $row++) {
                [Console]::SetCursorPosition(0, $startRow + $row)
                $line = $trainArt[$row]

                if ($x -lt 0) {
                    $cut = [Math]::Min(-$x, $line.Length)
                    $visible = $line.Substring($cut)
                    $full = $visible.PadRight($screenWidth)
                } else {
                    $padding = " " * $x
                    $full = ($padding + $line)
                    if ($full.Length -gt $screenWidth) {
                        $full = $full.Substring(0, $screenWidth)
                    } else {
                        $full = $full.PadRight($screenWidth)
                    }
                }

                Write-Host "$color$full$reset" -NoNewline
            }

            Start-Sleep -Milliseconds 18
        }
    } finally {
        for ($row = 0; $row -lt $trainHeight; $row++) {
            [Console]::SetCursorPosition(0, $startRow + $row)
            Write-Host (" " * $screenWidth) -NoNewline
        }
        [Console]::SetCursorPosition(0, $startRow)
        [Console]::CursorVisible = $true
    }
}

function train { Invoke-TrainAnimation }
function loco  { Invoke-TrainAnimation }

# ─────────────────────────────────────────
#  hack — fake hacking animation
#
#  Usage: hack
# ─────────────────────────────────────────
function hack {
    $ESC     = [char]27
    $red     = "$ESC[38;2;243;139;168m"
    $green   = "$ESC[38;2;166;227;161m"
    $yellow  = "$ESC[38;2;249;226;175m"
    $mauve   = "$ESC[38;2;203;166;247m"
    $peach   = "$ESC[38;2;250;179;135m"
    $teal    = "$ESC[38;2;148;226;213m"
    $blue    = "$ESC[38;2;137;180;250m"
    $overlay = "$ESC[38;2;108;112;134m"
    $bold    = "$ESC[1m"
    $reset   = "$ESC[0m"

    function Type-Line {
        param([string]$text, [string]$color = $reset, [int]$delay = 18, [string]$prefix = "  ")
        Write-Host -NoNewline "$prefix$color"
        foreach ($char in $text.ToCharArray()) {
            Write-Host -NoNewline $char
            Start-Sleep -Milliseconds $delay
        }
        Write-Host $reset
    }

    function Fake-Progress {
        param([string]$label, [string]$color, [int]$steps = 30, [int]$minMs = 20, [int]$maxMs = 80)
        for ($i = 0; $i -le $steps; $i++) {
            $pct    = [math]::Round(($i / $steps) * 100)
            $filled = [math]::Round($i / $steps * 24)
            $bar    = "█" * $filled
            $empty  = "░" * (24 - $filled)
            $pctStr = "$pct%".PadLeft(4)
            Write-Host -NoNewline "`r  $color$label$reset  [${green}$bar${overlay}$empty${reset}] ${peach}${bold}$pctStr${reset}  "
            Start-Sleep -Milliseconds (Get-Random -Minimum $minMs -Maximum $maxMs)
        }
        Write-Host ""
    }

    function Glitch-Line {
        param([string]$text, [string]$color)
        $glitchChars = "!@#%^&*?/<>|\\~".ToCharArray()
        $glitched = -join ($text.ToCharArray() | ForEach-Object {
            if ((Get-Random -Minimum 0 -Maximum 5) -eq 0) { $glitchChars | Get-Random } else { $_ }
        })
        Write-Host -NoNewline "`r  $color$glitched$reset"
        Start-Sleep -Milliseconds 80
        Write-Host -NoNewline "`r  $color$text$reset          "
        Write-Host ""
    }

    function Scan-Animation {
        param([string]$label, [string]$color, [int]$width = 40)
        $scanChars = @("▌","▍","▎","▏","▎","▍","▌","▋","▊","▉","█")
        for ($i = 0; $i -lt $width; $i++) {
            $bar  = "─" * $i
            $head = $scanChars | Get-Random
            $rest = " " * ($width - $i - 1)
            Write-Host -NoNewline "`r  $color$label$reset  [$teal$bar$head$overlay$rest${reset}]"
            Start-Sleep -Milliseconds (Get-Random -Minimum 15 -Maximum 50)
        }
        Write-Host -NoNewline "`r  $color$label$reset  [${green}$("─" * $width)${reset}]"
        Write-Host ""
    }

    function Burst-Text {
        param([string]$text, [string]$color)
        $chars = "0123456789ABCDEF!@#$%".ToCharArray()
        for ($r = 0; $r -lt 8; $r++) {
            $noise = -join (1..$text.Length | ForEach-Object { $chars | Get-Random })
            Write-Host -NoNewline "`r  $overlay$noise$reset"
            Start-Sleep -Milliseconds 40
        }
        Write-Host -NoNewline "`r  $color${bold}$text$reset          "
        Write-Host ""
    }

    Clear-Host
    Write-Host ""

    $banner = "[ INITIATING BREACH SEQUENCE ]"
    Write-Host -NoNewline "  $red$bold"
    foreach ($c in $banner.ToCharArray()) {
        Write-Host -NoNewline $c
        Start-Sleep -Milliseconds (Get-Random -Minimum 10 -Maximum 40)
    }
    Write-Host $reset
    Start-Sleep -Milliseconds 300

    Write-Host ""
    for ($b = 0; $b -lt 4; $b++) {
        Write-Host -NoNewline "`r  ${overlay}> _${reset}"
        Start-Sleep -Milliseconds 200
        Write-Host -NoNewline "`r  ${overlay}>  ${reset}"
        Start-Sleep -Milliseconds 200
    }
    Write-Host ""

    # Phase 1: recon
    Type-Line "PHASE 1 — RECONNAISSANCE" $overlay 12
    Write-Host ""
    Scan-Animation "Scanning network       " $overlay 36
    Start-Sleep -Milliseconds 100
    Type-Line "✦ Target IP resolved:  192.168.1.1 → 10.0.0.47" $teal 8
    Start-Sleep -Milliseconds 200
    Scan-Animation "Mapping open ports     " $overlay 36
    Type-Line "✦ Open:  22 (SSH)   80 (HTTP)   443 (HTTPS)   8080 (API)" $yellow 6
    Start-Sleep -Milliseconds 200
    Fake-Progress "Fingerprinting OS      " $overlay 24 15 60
    Glitch-Line "✦ Target OS: Ubuntu 22.04 LTS  [KERNEL 5.15.0]" $peach
    Start-Sleep -Milliseconds 400

    # Phase 2: intrusion
    Write-Host ""
    Type-Line "PHASE 2 — INTRUSION" $overlay 12
    Write-Host ""
    Fake-Progress "Bypassing firewall     " $yellow 30 10 70
    Glitch-Line "✦ Firewall nullified — rule table overwritten" $green
    Start-Sleep -Milliseconds 200
    Type-Line "  ⚡  Brute-force on SSH → 14,882 attempts..." $overlay 5
    Start-Sleep -Milliseconds 500
    Burst-Text "✦ ACCESS GRANTED — user: root" $green
    Start-Sleep -Milliseconds 300
    Fake-Progress "Injecting shellcode    " $mauve 28 20 65
    Glitch-Line "✦ Reverse shell spawned  ←  10.0.0.47:4444" $green
    Start-Sleep -Milliseconds 300

    # Phase 3: exfiltration
    Write-Host ""
    Type-Line "PHASE 3 — EXFILTRATION" $overlay 12
    Write-Host ""
    Fake-Progress "Dumping /etc/shadow    " $peach 32 15 55
    Type-Line "✦ 2,048 password hashes extracted" $green 6
    Fake-Progress "Cloning database       " $blue 35 10 50
    Glitch-Line "✦ 4.2 GB transferred → /tmp/.h1dd3n/db.tar.gz" $green
    Start-Sleep -Milliseconds 300
    Type-Line "  ⚠   ALERT: Anomaly detector triggered!" $red 15
    Start-Sleep -Milliseconds 200
    Type-Line "      → Spinning up 9 decoy sessions..." $overlay 8
    Start-Sleep -Milliseconds 600
    Glitch-Line "      → Detector neutralised. Resuming." $teal
    Start-Sleep -Milliseconds 300
    Fake-Progress "Exfiltrating secrets   " $peach 30 20 70
    Type-Line "✦ API keys, SSH certs, 1,337 credentials: DUMPED" $green 6
    Start-Sleep -Milliseconds 300

    # Phase 4: cleanup
    Write-Host ""
    Type-Line "PHASE 4 — CLEANUP" $overlay 12
    Write-Host ""
    Fake-Progress "Wiping bash history    " $overlay 18 10 40
    Fake-Progress "Rotating log files     " $overlay 18 10 40
    Fake-Progress "Destroying artefacts   " $overlay 18 10 40
    Glitch-Line "✦ No trace. Ghost protocol: ACTIVE" $green
    Start-Sleep -Milliseconds 600

    Write-Host ""
    Burst-Text "[ OPERATION COMPLETE — ROOT ACCESS MAINTAINED ]" $mauve
    Start-Sleep -Milliseconds 800

    Write-Host ""
    Write-Host "  ${red}${bold}lol you just hacked yourself 💀${reset}"
    Write-Host ""
}

# ─────────────────────────────────────────
#  matrix — matrix rain animation
#
#  Usage:
#    matrix            → full terminal, 25s
#    matrix -half      → half terminal, 15s
#    matrix -infinite  → full terminal, infinite (Ctrl+C to quit)
#    matrix -seconds 60 → full terminal, custom duration
# ─────────────────────────────────────────
function matrix {
    param(
        [switch]$infinite,
        [switch]$half,
        [int]$seconds = 25
    )

    $ESC     = [char]27
    $green   = "$ESC[38;2;166;227;161m"
    $teal    = "$ESC[38;2;148;226;213m"
    $overlay = "$ESC[38;2;108;112;134m"
    $mauve   = "$ESC[38;2;203;166;247m"
    $bold    = "$ESC[1m"
    $reset   = "$ESC[0m"

    $halfMode    = $half.IsPresent
    $durationSec = if ($infinite) { [int]::MaxValue } elseif ($half) { 15 } else { $seconds }

    $chars = "ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ0123456789ABCDEF".ToCharArray()

    $fullWidth  = [Console]::WindowWidth
    $fullHeight = [Console]::WindowHeight - 1

    # Intro animation
    Clear-Host
    Write-Host ""
    $title = "[ MATRIX PROTOCOL INITIALISING ]"
    Write-Host -NoNewline "  $green$bold"
    foreach ($c in $title.ToCharArray()) {
        Write-Host -NoNewline $c
        Start-Sleep -Milliseconds (Get-Random -Minimum 5 -Maximum 30)
    }
    Write-Host $reset
    Start-Sleep -Milliseconds 200

    Write-Host -NoNewline "  $overlay"
    for ($i = 0; $i -lt ($fullWidth - 4); $i++) {
        Write-Host -NoNewline "─"
        Start-Sleep -Milliseconds 3
    }
    Write-Host $reset
    Start-Sleep -Milliseconds 300

    if ($halfMode) {
        Write-Host "  ${teal}MODE${reset}  ${overlay}half-terminal · 15s${reset}"
    } elseif ($infinite) {
        Write-Host "  ${mauve}MODE${reset}  ${overlay}full-terminal · infinite  [Ctrl+C to exit]${reset}"
    } else {
        Write-Host "  ${green}MODE${reset}  ${overlay}full-terminal · ${durationSec}s${reset}"
    }
    Start-Sleep -Milliseconds 600

    if ($halfMode) {
        $colStart = 0
        $colEnd   = [math]::Floor($fullWidth / 2)
    } else {
        $colStart = 0
        $colEnd   = $fullWidth
    }

    $matrixHeight = $fullHeight
    $cols = $colStart..($colEnd - 1) | ForEach-Object {
        @{
            pos    = Get-Random -Minimum 0 -Maximum $matrixHeight
            speed  = Get-Random -Minimum 1 -Maximum 4
            active = (Get-Random -Minimum 0 -Maximum 2)
        }
    }

    [Console]::CursorVisible = $false
    Clear-Host

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    try {
        while ($true) {
            if (-not $infinite -and $stopwatch.Elapsed.TotalSeconds -ge $durationSec) { break }

            for ($ci = 0; $ci -lt $cols.Count; $ci++) {
                $col = $cols[$ci]
                $c   = $colStart + $ci

                if (-not $col.active) {
                    if ((Get-Random -Minimum 0 -Maximum 30) -eq 0) { $col.active = $true }
                    continue
                }

                $r = $col.pos
                if ($r -ge 0 -and $r -lt $matrixHeight) {
                    [Console]::SetCursorPosition($c, $r)
                    Write-Host -NoNewline "${green}$($chars | Get-Random)${reset}"
                }

                $trail = $col.pos - 1
                if ($trail -ge 0 -and $trail -lt $matrixHeight) {
                    [Console]::SetCursorPosition($c, $trail)
                    Write-Host -NoNewline "${teal}$($chars | Get-Random)${reset}"
                }

                $tail = $col.pos - (Get-Random -Minimum 6 -Maximum 14)
                if ($tail -ge 0 -and $tail -lt $matrixHeight) {
                    [Console]::SetCursorPosition($c, $tail)
                    Write-Host -NoNewline " "
                }

                $col.pos += $col.speed
                if ($col.pos -gt $matrixHeight + 10) {
                    $col.pos    = Get-Random -Minimum -10 -Maximum 0
                    $col.speed  = Get-Random -Minimum 1 -Maximum 4
                    $col.active = (Get-Random -Minimum 0 -Maximum 3) -ne 0
                }
            }
            Start-Sleep -Milliseconds 40
        }
    } finally {
        [Console]::CursorVisible = $true
        Clear-Host
    }
}
