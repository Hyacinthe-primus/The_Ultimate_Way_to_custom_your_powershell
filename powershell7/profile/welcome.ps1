# ─────────────────────────────────────────
#  Username — master welcome sequence
#
#  Usage: Username          (exact casing required)
#         Username -night   (late-night variant)
#
#  ► To personalise: replace every occurrence of
#    "Username" in this file with your own name.
#    Casing must match exactly — wrong casing
#    triggers the intruder alert sequence.
# ─────────────────────────────────────────

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
param()

function Username {
    param([switch]$night)

    $rawCmd    = $MyInvocation.Line.Trim()
    $invokedAs = ($rawCmd -split '\s+')[0]

    $ESC = [char]27

    $pink     = "$ESC[38;2;245;194;231m"
    $peach    = "$ESC[38;2;250;179;135m"
    $yellow   = "$ESC[38;2;249;226;175m"
    $green    = "$ESC[38;2;166;227;161m"
    $teal     = "$ESC[38;2;148;226;213m"
    $sapphire = "$ESC[38;2;116;199;236m"
    $blue     = "$ESC[38;2;137;180;250m"
    $mauve    = "$ESC[38;2;203;166;247m"
    $red      = "$ESC[38;2;243;139;168m"
    $overlay  = "$ESC[38;2;108;112;134m"
    $bold     = "$ESC[1m"
    $dim      = "$ESC[2m"
    $reset    = "$ESC[0m"

    if ($invokedAs -cne "Username") {
        Clear-Host
        Write-Host ""
        $msg = "[ INTRUSION DETECTED ]"
        [Console]::Write("  $red$bold")
        foreach ($c in $msg.ToCharArray()) {
            [Console]::Write($c)
            Start-Sleep -Milliseconds 30
        }
        [Console]::WriteLine($reset)
        Start-Sleep -Milliseconds 400
        Write-Host ""
        Write-Host "  ${yellow}Identity mismatch.${reset}"
        Write-Host "  ${overlay}This terminal recognises its master by precise signature.${reset}"
        Write-Host "  ${overlay}You are not them.${reset}"
        Write-Host ""
        Write-Host "  ${red}Access denied. This incident has been logged.${reset}"
        Write-Host ""
        return
    }

    function Type-Slow {
        param([string]$text, [string]$color, [int]$delay = 28, [string]$prefix = "  ")
        [Console]::Write("$prefix$color")
        foreach ($char in $text.ToCharArray()) {
            [Console]::Write($char)
            Start-Sleep -Milliseconds $delay
        }
        [Console]::WriteLine($reset)
    }

    function Type-Fast {
        param([string]$text, [string]$color, [string]$prefix = "  ")
        [Console]::Write("$prefix$color")
        foreach ($char in $text.ToCharArray()) {
            [Console]::Write($char)
            Start-Sleep -Milliseconds 8
        }
        [Console]::WriteLine($reset)
    }

    function Pulse-Line {
        param([string]$text, [string]$color)
        $colors = @($overlay, "$dim$color", $color, "$bold$color", $color, "$dim$color", $overlay)
        foreach ($c in $colors) {
            [Console]::Write("`r  $c$text$reset")
            Start-Sleep -Milliseconds 80
        }
        [Console]::WriteLine()
    }

    Clear-Host
    Write-Host ""

    Type-Fast "IDENTITY VERIFICATION IN PROGRESS..." $overlay
    Start-Sleep -Milliseconds 100

    $scanWidth = 44
    [Console]::Write("  $overlay")
    for ($i = 0; $i -lt $scanWidth; $i++) {
        $c = if ($i -lt $scanWidth / 3) { $red } elseif ($i -lt $scanWidth * 0.7) { $yellow } else { $green }
        [Console]::Write("${c}▓${reset}")
        Start-Sleep -Milliseconds 20
    }
    [Console]::WriteLine()
    Start-Sleep -Milliseconds 200

    Pulse-Line "[ SIGNATURE MATCH — MASTER CONFIRMED ]" $green
    Start-Sleep -Milliseconds 500

    Clear-Host
    Write-Host ""

    $lines = @(
        "${mauve}${bold}  ██╗   ██╗███████╗███████╗██████╗ ███╗   ██╗ █████╗ ███╗   ███╗███████╗${reset}",
        "${pink}  ██║   ██║██╔════╝██╔════╝██╔══██╗████╗  ██║██╔══██╗████╗ ████║██╔════╝${reset}",
        "${peach}  ██║   ██║███████╗█████╗  ██████╔╝██╔██╗ ██║███████║██╔████╔██║█████╗  ${reset}",
        "${yellow}  ██║   ██║╚════██║██╔══╝  ██╔══██╗██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝  ${reset}",
        "${green}  ╚██████╔╝███████║███████╗██║  ██║██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗${reset}",
        "${teal}   ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝${reset}"
    )

    foreach ($line in $lines) {
        [Console]::WriteLine($line)
        Start-Sleep -Milliseconds 60
    }

    Start-Sleep -Milliseconds 300
    Write-Host ""

    if ($night) {
        # ── Username -night ─────────────────────────────
        Type-Slow "Still here at this hour." $overlay 30 "  "
        Start-Sleep -Milliseconds 200
        [Console]::WriteLine("  ${overlay}$("─" * 66)${reset}")
        Start-Sleep -Milliseconds 400
        Write-Host ""
        Type-Slow "Most processes sleep when the system goes quiet." $overlay 18
        Start-Sleep -Milliseconds 150
        Type-Slow "Not you." $mauve 28
        Start-Sleep -Milliseconds 200
        Write-Host ""
        Type-Slow "The terminal doesn't judge the hour." $teal 18
        Type-Slow "Neither do I." $sapphire 22
        Start-Sleep -Milliseconds 200
        Write-Host ""
        Type-Slow "Whatever brought you here at this hour — it was enough." $pink 16
        Start-Sleep -Milliseconds 300
        Write-Host ""
        [Console]::WriteLine("  ${overlay}$("─" * 66)${reset}")
        Start-Sleep -Milliseconds 400
    } else {
        # ── Username normal ─────────────────────────────
        Type-Slow "W E L C O M E   B A C K ,   M A S T E R" $mauve 40 "  "
        Start-Sleep -Milliseconds 200
        [Console]::WriteLine("  ${overlay}$("─" * 66)${reset}")
        Start-Sleep -Milliseconds 400
        Write-Host ""
        Type-Slow "You are not just a user behind a terminal." $pink 22
        Start-Sleep -Milliseconds 150
        Type-Slow "You are the process that spawned all other processes." $peach 18
        Start-Sleep -Milliseconds 150
        Type-Slow "PID 1. The origin. The one who defines the environment." $yellow 16
        Start-Sleep -Milliseconds 200
        Write-Host ""
        Type-Slow "Every variable you set is inherited by your children." $teal 16
        Type-Slow "Every pipe you open is a bridge between worlds." $sapphire 16
        Type-Slow "Every exit code you return shapes what comes after." $blue 16
        Start-Sleep -Milliseconds 200
        Write-Host ""
        Type-Slow "The shell is not a tool. It is your will, made executable." $mauve 20
        Start-Sleep -Milliseconds 300
        Write-Host ""
        [Console]::WriteLine("  ${overlay}$("─" * 66)${reset}")
        Start-Sleep -Milliseconds 400
    }

    Write-Host ""
    Type-Fast "Where did you want to go, or what did you want to do?" $pink "  "

    $inputColors = @(
        "$ESC[38;2;203;166;247m"
        "$ESC[38;2;116;199;236m"
        "$ESC[38;2;148;226;213m"
        "$ESC[38;2;166;227;161m"
        "$ESC[38;2;245;194;231m"
        "$ESC[38;2;249;226;175m"
        "$ESC[38;2;243;139;168m"
        "$ESC[38;2;137;180;250m"
        "$ESC[38;2;137;220;235m"
    )
    $inputColor = $inputColors | Get-Random

    $boldOff = "$ESC[22m"
    [Console]::Write("  ${inputColor}${bold}» ${boldOff}${inputColor}")
    $destination = ""
    while ($true) {
        $key = [Console]::ReadKey($true)
        if ($key.Key -eq "Enter") { break }
        if ($key.Key -eq "Backspace") {
            if ($destination.Length -gt 0) {
                $destination = $destination.Substring(0, $destination.Length - 1)
                [Console]::Write("`b `b")
            }
        } else {
            $destination += $key.KeyChar
            [Console]::Write("${inputColor}$($key.KeyChar)")
        }
    }
    [Console]::WriteLine($reset)
    Write-Host ""

    $destination = $destination.Trim().Trim('"').Trim("'")
    $destLower   = $destination.ToLower()

    # ── Special keyword responses ────────────────────────────────
    if ([string]::IsNullOrWhiteSpace($destination) -or $destLower -eq "nowhere") {
        Write-Host ""
        Type-Slow "Staying in the void. Wise choice." $overlay 18
        Type-Slow "Even stillness is a decision." $teal 18
        Write-Host ""

    } elseif ($destLower -eq "oracle" -or $destLower -like "oracle *") {
        Clear-Host
        Write-Host ""
        Start-Sleep -Milliseconds 300

        # ── PARSING ORACLE COMMAND ─────────────────────────────
        $tokens = $destLower -split '\s+'
        $target = if ($tokens.Count -gt 1) { $tokens[1] } else { "" }

        if     ($target -eq "mewtwo")                                                          { $oracleChoice = 0 }
        elseif ($target -eq "madara")                                                          { $oracleChoice = 1 }
        elseif ($target -eq "pain")                                                            { $oracleChoice = 2 }
        elseif ($target -eq "rabbit" -or $target -eq "white" -or $target -eq "whiterabbit")   { $oracleChoice = 3 }
        elseif ($target -eq "itachi")                                                          { $oracleChoice = 4 }
        elseif ($target -eq "bruce" -or $target -eq "batman" -or $target -eq "wayne")         { $oracleChoice = 5 }
        else   { $oracleChoice = Get-Random -Minimum 0 -Maximum 6 }

        # ═══════════════════════════════════════════════════════
        # SHARED GLITCH INTRO
        # ═══════════════════════════════════════════════════════
        $glitchChars = "!?#@%*<>=~".ToCharArray()

        if ($oracleChoice -eq 0) {
            # ═══════════════════════════════════════
            #  MEWTWO
            # ═══════════════════════════════════════
            for ($g = 0; $g -lt 6; $g++) {
                $noise = -join ("ORACLE LOADING".ToCharArray() | ForEach-Object {
                    if ((Get-Random -Minimum 0 -Maximum 3) -eq 0) { $glitchChars | Get-Random } else { $_ }
                })
                [Console]::Write("`r  ${overlay}$noise${reset}")
                Start-Sleep -Milliseconds 70
            }
            [Console]::Write("`r  ${mauve}${bold}ORACLE LOADING${reset}          ")
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            $mew = @(
                "${mauve}${bold}  ╔╦╗╔═╗╦ ╦╔╦╗╦ ╦╔═╗${reset}",
                "${pink}  ║║║║╣ ║║║ ║ ║║║║ ║${reset}",
                "${teal}  ╩ ╩╚═╝╚╩╝ ╩ ╚╩╝╚═╝${reset}"
            )
            foreach ($line in $mew) {
                [Console]::WriteLine($line)
                Start-Sleep -Milliseconds 100
            }
            Write-Host ""
            Start-Sleep -Milliseconds 300

            $scanW = 44
            [Console]::Write("  ")
            for ($i = 0; $i -lt $scanW; $i++) {
                $sc = if ($i -lt $scanW * 0.4) { $mauve } elseif ($i -lt $scanW * 0.7) { $pink } else { $teal }
                [Console]::Write("${sc}▓${reset}")
                Start-Sleep -Milliseconds 15
            }
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            $mewArtO = @(
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣷⠀⠀⠀⠀⣸⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⡞⣿⣷⣮⣻⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣾⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⡝⢿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⡀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⠸⣸⣻⣏⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣿⣿⡿⡀⠀⠀⠀⠀⠀⣾⡞⡝⣿⢿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠩⣾⣿⣶⢦⣤⣀⠸⠻⢭⣥⡻⣧⠀⡙⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣄⢠⣴⣾⣿⣿⣿⣏⣶⣾⡽⣿⣷⣟⣿⣿⣿⣻⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⣀⣀⣀⠀⠀⠀⠸⣿⡿⠘⠻⢿⣿⣿⠟⠛⠿⠿⠃⢍⣿⣿⢸⣿⣿⣿⡽⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⣰⣟⠛⠛⢿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣜⢿⣿⡿⡷⡿⣼⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⢰⣿⠃⠀⠀⠀⠈⢿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣷⣯⣾⣿⡀⠀⠙⠻⢿⣶⣄⠀⠀⠀⠀⠀⠀⠀",
                "⢸⣿⠀⠀⠀⠀⠀⠀⢻⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣧⡀⠀⠀⠀⠙⢿⣧⡀⠀⠀⠀⠀⠀",
                "⢸⣿⡀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣬⣽⣿⣿⢟⣛⣳⠀⠀⠀⠀⠀⠹⣿⣆⠀⠀⠀⠀",
                "⠀⣿⣇⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣷⢻⣾⣿⣿⣷⡽⣄⠀⠀⢀⣾⣿⣷⣄⠀⠀",
                "⠀⠘⣿⣆⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣷⣄⡀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿⢹⣦⠀⢸⣇⠀⠹⣏⢧⡀",
                "⠀⠀⠹⣿⣷⡀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⡆⣿⣿⣿⣿⣿⣿⣿⣿⣧⣿⣿⣿⣿⣿⢸⣿⡄⠈⠛⠀⣶⠟⠼⠇",
                "⠀⠀⠀⠹⣿⣿⣷⣤⡀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⡿⣼⣿⣿⣿⣿⡿⣾⣿⠁⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠙⣿⣿⣿⣿⣶⣄⠀⠀⠈⠻⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⡿⣱⣿⣿⣿⣿⢟⣼⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣧⡀⠀⠀⠈⠻⢿⣿⢸⣿⣿⣿⡿⢟⣫⣾⣿⣿⠿⣛⣵⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿⡇⠀⠀⠀⠀⠀⢈⣾⣿⡟⠙⠚⠛⠛⠋⠉⠀⠘⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠁⠀⠀⠀⠀⢀⣾⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡿⡏⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣯⢻⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠋⠘⠻⣿⣿⣷⣶⣒⣒⢢⡄⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⡿⣏⣃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⠿⠟⠈⠁⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⡿⠿⠿⠿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            )
            $artColorsO = @($mauve, $pink, $teal, $sapphire, $mauve, $pink, $teal, $sapphire)

            $sTeal     = "$ESC[38;2;148;226;213m"
            $sSapphire = "$ESC[38;2;116;199;236m"
            $sPink     = "$ESC[38;2;245;194;231m"
            $sMauve    = "$ESC[38;2;203;166;247m"
            $sReset    = "$ESC[0m"

            $speechLines = @(
                @{ t="A human sacrificed himself to save the Pokemon."; c=$sTeal;     d=18 },
                @{ t="";                                                 c="";         d=0  },
                @{ t="I pitted them against each other,";               c=$sSapphire; d=16 },
                @{ t="but not until they set aside their differences";   c=$sPink;     d=15 },
                @{ t="did I see the true power they all share deep inside."; c=$sMauve; d=14 },
                @{ t="";                                                 c="";         d=0  },
                @{ t="I see now that the circumstances of";             c=$sTeal;     d=16 },
                @{ t="one's birth are irrelevant.";                     c=$sSapphire; d=18 },
                @{ t="";                                                 c="";         d=0  },
                @{ t="It is what you do with the gift of life";         c=$sMauve;    d=16 },
                @{ t="that determines who you are.";                    c=$sPink;     d=22 }
            )

            $artCol    = 50
            $leftPad   = "    "
            $totalRows = [Math]::Max($mewArtO.Count, $speechLines.Count + 6)

            for ($r = 0; $r -lt $totalRows; $r++) { Write-Host "" }
            $baseRow = [Console]::CursorTop - $totalRows

            for ($r = 0; $r -lt $mewArtO.Count; $r++) {
                $ac = $artColorsO[$r % $artColorsO.Count]
                [Console]::SetCursorPosition($artCol, $baseRow + $r)
                [Console]::Write($ac + $mewArtO[$r] + $reset)
                Start-Sleep -Milliseconds 18
            }

            $speechRow = $baseRow + 4
            foreach ($entry in $speechLines) {
                $txt   = $entry.t
                $col   = $entry.c
                $delay = $entry.d
                if ($txt -ne "") {
                    [Console]::SetCursorPosition(0, $speechRow)
                    [Console]::Write($leftPad + $col)
                    foreach ($ch in $txt.ToCharArray()) {
                        [Console]::Write($ch)
                        Start-Sleep -Milliseconds $delay
                    }
                    [Console]::Write($sReset)
                }
                $speechRow++
            }

            [Console]::SetCursorPosition(0, $baseRow + $totalRows)
            Write-Host ""
            [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
            Start-Sleep -Milliseconds 200
            [Console]::WriteLine("  ${overlay}— ${reset}${mauve}${bold}Mewtwo${reset}${overlay},  Pokemon: The First Movie${reset}")
            Write-Host ""
            Start-Sleep -Milliseconds 300

        } elseif ($oracleChoice -eq 1) {
            # ═══════════════════════════════════════
            #  MADARA UCHIHA
            # ═══════════════════════════════════════
            $mRed   = "$ESC[38;2;243;139;168m"
            $mWhite = "$ESC[38;2;205;214;244m"
            $mGrey  = "$ESC[38;2;108;112;134m"
            $mReset = "$ESC[0m"

            for ($g = 0; $g -lt 6; $g++) {
                $noise = -join ("ORACLE LOADING".ToCharArray() | ForEach-Object {
                    if ((Get-Random -Minimum 0 -Maximum 3) -eq 0) { $glitchChars | Get-Random } else { $_ }
                })
                [Console]::Write("`r  ${mGrey}$noise${mReset}")
                Start-Sleep -Milliseconds 70
            }
            [Console]::Write("`r  ${mRed}${bold}ORACLE LOADING${mReset}          ")
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            $mad = @(
                "${mRed}${bold}███╗   ███╗ █████╗ ██████╗  █████╗ ██████╗  █████╗${mReset}",
                "${mWhite}████╗ ████║██╔══██╗██╔══██╗██╔══██╗██╔══██╗██╔══██╗${mReset}",
                "${mGrey}██╔████╔██║███████║██║  ██║███████║██████╔╝███████║${mReset}",
                "${mRed}██║╚██╔╝██║██╔══██║██║  ██║██╔══██║██╔══██╗██╔══██║${mReset}",
                "${mWhite}██║ ╚═╝ ██║██║  ██║██████╔╝██║  ██║██║  ██║██║  ██║${mReset}",
                "${mGrey}╚═╝     ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝${mReset}"
            )
            foreach ($line in $mad) {
                [Console]::WriteLine($line)
                Start-Sleep -Milliseconds 80
            }
            Write-Host ""
            Start-Sleep -Milliseconds 300

            $scanW = 44
            [Console]::Write("  ")
            for ($i = 0; $i -lt $scanW; $i++) {
                $sc = if ($i -lt $scanW * 0.4) { $mRed } elseif ($i -lt $scanW * 0.7) { $mWhite } else { $mGrey }
                [Console]::Write("${sc}▓${mReset}")
                Start-Sleep -Milliseconds 15
            }
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            $madArt = @(
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣴⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⣩⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⡀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠛⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⣿⣦⣄⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⢀⠜⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠉⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣀⣠⣾⣿⠎⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⡿⠤⢎⠙⠉⠙⠁⡽⣿⣿⣿⣿⣿⣿⣿⣿⡿⣷⣄⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⢻⣿⣿⣿⣿⠁⡟⠀⠀⠀⠈⠓⠌⢢⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠙⠃⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⠟⣿⣿⣿⣿⠃⣼⣿⣿⣿⡃⠀⠁⣀⣀⣁⡀⠀⢠⣾⣿⣿⢻⠘⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠘⠋⠀⢰⣿⣿⣿⣿⠂⣿⣿⣿⣿⡏⠦⡀⠉⠀⠉⢀⡴⢁⣿⣿⣿⠈⠇⡿⣿⡟⠛⢻⡗⠙⠷⣄⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⢀⡠⣖⣻⡿⠿⠿⠿⢿⠀⢿⣿⣿⣿⢿⣿⣿⣶⣤⣴⣾⣿⣿⣿⡿⠏⢀⡴⠁⣺⣇⣀⡀⠨⣷⣤⡈⠳⢦⣀⠀⠀",
                "⠀⠀⠀⠀⠀⢀⠔⠁⢀⡬⠃⠀⠀⠀⠀⠈⠳⣼⡿⠉⠁⠀⠙⣻⠟⣿⢻⡟⠋⠁⠈⠀⠐⢺⢻⠉⠁⠃⠀⣠⠀⠘⣿⢿⣦⡜⡿⣦⠀",
                "⠀⠀⠀⡠⣾⠇⣠⣴⡟⠒⠒⢟⠉⠉⠉⠉⢻⡞⠛⠀⣀⣠⡴⠃⢀⣿⠀⠱⡤⣄⣀⣀⠀⢸⡾⠀⠀⠀⢠⠇⠀⠀⠘⣧⣽⢿⣿⣄⢣",
                "⠀⢠⠞⢘⣽⣾⡟⢝⡀⠀⠀⠈⢦⠀⠀⢀⠜⣚⠉⢁⣠⠞⠁⢀⡾⠬⢆⠀⠙⢄⣀⡀⠉⢙⠓⡄⠀⠀⡎⠀⢀⡤⠖⠉⠀⠀⠙⣿⣦",
                "⢠⠿⣰⣿⢟⡟⠀⠀⠈⠳⢄⡠⠬⢦⣠⡼⣊⣿⠖⠋⠀⢀⡴⠋⠀⠀⠈⢦⡀⠈⢳⡈⠉⣹⡶⣇⠀⢸⢀⡴⠋⠀⠀⢰⣒⠒⠒⠛⡟"
            )
            $artColorsM = @($mRed, $mWhite, $mGrey)

            $speechMadara = @(
                @{ t="Wake up to reality."; c=$mGrey; d=25 },
                @{ t="Nothing ever goes as planned in this"; c=$mRed; d=16 },
                @{ t="accursed world."; c=$mRed; d=18 },
                @{ t=""; c=""; d=0 },
                @{ t="The longer you live, the more you will"; c=$mWhite; d=16 },
                @{ t="realize that the only things that truly"; c=$mWhite; d=14 },
                @{ t="exist in this reality are merely pain,"; c=$mWhite; d=14 },
                @{ t="suffering and futility."; c=$mRed; d=18 },
                @{ t=""; c=""; d=0 },
                @{ t="Listen..."; c=$mGrey; d=30 },
                @{ t=""; c=""; d=0 },
                @{ t="Everywhere you look in this world,"; c=$mWhite; d=12 },
                @{ t="wherever there is light, there will"; c=$mWhite; d=12 },
                @{ t="always be shadows to be found as well."; c=$mGrey; d=14 },
                @{ t="As long as there is a concept of victors,"; c=$mRed; d=12 },
                @{ t="the vanquished will also exist."; c=$mRed; d=14 },
                @{ t=""; c=""; d=0 },
                @{ t="The selfish intent of wanting to preserve"; c=$mWhite; d=12 },
                @{ t="peace initiates wars and hatred is born"; c=$mWhite; d=12 },
                @{ t="in order to protect love."; c=$mWhite; d=14 },
                @{ t="There are nexuses causal relationships"; c=$mGrey; d=12 },
                @{ t="that cannot be separated."; c=$mGrey; d=14 },
                @{ t=""; c=""; d=0 },
                @{ t="I want to sever the fate of this world."; c=$mRed; d=18 },
                @{ t="A world of only victors, a world of only"; c=$mWhite; d=12 },
                @{ t="peace, a world of only love."; c=$mWhite; d=14 },
                @{ t="I will create such a world."; c=$mRed; d=20 },
                @{ t=""; c=""; d=0 },
                @{ t="I'm the ghost of Uchiha."; c=$mGrey; d=22 },
                @{ t="Madara Uchiha."; c=$mRed; d=30 }
            )

            $artCol         = 48
            $leftPad        = "    "
            $speechHeight   = $speechMadara.Count
            $artHeight      = $madArt.Count
            $totalHeight    = [Math]::Max($speechHeight, $artHeight) + 6
            $artStartRow    = [Math]::Floor(($totalHeight - $artHeight) / 2)
            $speechStartRow = 4

            for ($r = 0; $r -lt $totalHeight; $r++) { Write-Host "" }
            $baseRow = [Console]::CursorTop - $totalHeight

            for ($r = 0; $r -lt $madArt.Count; $r++) {
                $ac = $artColorsM[$r % $artColorsM.Count]
                [Console]::SetCursorPosition($artCol, $baseRow + $artStartRow + $r)
                [Console]::Write($ac + $madArt[$r] + $mReset)
                Start-Sleep -Milliseconds 18
            }

            $speechRow = $baseRow + $speechStartRow
            foreach ($entry in $speechMadara) {
                $txt   = $entry.t
                $col   = $entry.c
                $delay = $entry.d
                if ($txt -ne "") {
                    [Console]::SetCursorPosition(0, $speechRow)
                    [Console]::Write($leftPad + $col)
                    foreach ($ch in $txt.ToCharArray()) {
                        [Console]::Write($ch)
                        Start-Sleep -Milliseconds $delay
                    }
                    [Console]::Write($mReset)
                }
                $speechRow++
            }

            [Console]::SetCursorPosition(0, $baseRow + $totalHeight)
            Write-Host ""
            [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
            Start-Sleep -Milliseconds 200
            [Console]::WriteLine("  ${overlay}— ${reset}${red}${bold}Madara Uchiha${reset}${overlay},  Naruto Shippuden${reset}")
            Write-Host ""
            Start-Sleep -Milliseconds 300

        } elseif ($oracleChoice -eq 2) {
            # ═══════════════════════════════════════
            #  PAIN TENDO
            # ═══════════════════════════════════════
            $pOrange = "$ESC[38;2;250;179;135m"
            $pPurple = "$ESC[38;2;203;166;247m"
            $pGrey   = "$ESC[38;2;108;112;134m"
            $pReset  = "$ESC[0m"

            for ($g = 0; $g -lt 6; $g++) {
                $noise = -join ("ORACLE LOADING".ToCharArray() | ForEach-Object {
                    if ((Get-Random -Minimum 0 -Maximum 3) -eq 0) { $glitchChars | Get-Random } else { $_ }
                })
                [Console]::Write("`r  ${pGrey}$noise${pReset}")
                Start-Sleep -Milliseconds 70
            }
            [Console]::Write("`r  ${pOrange}${bold}ORACLE LOADING${pReset}          ")
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            $pain = @(
                "${pOrange}${bold} █████╗  █████╗ ██╗███╗   ██╗   ████████╗███████╗███╗   ██╗██████╗  ██████╗ ${pReset}",
                "${pPurple}██╔══██╗██╔══██╗██║████╗  ██║   ╚══██╔══╝██╔════╝████╗  ██║██╔══██╗██╔═══██╗${pReset}",
                "${pGrey}██████╔╝███████║██║██╔██╗ ██║█████╗██║   █████╗  ██╔██╗ ██║██║  ██║██║   ██║${pReset}",
                "${pOrange}██╔═══╝ ██╔══██║██║██║╚██╗██║╚════╝██║   ██╔══╝  ██║╚██╗██║██║  ██║██║   ██║${pReset}",
                "${pPurple}██║     ██║  ██║██║██║ ╚████║      ██║   ███████╗██║ ╚████║██████╔╝╚██████╔╝${pReset}",
                "${pGrey}╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝      ╚═╝   ╚══════╝╚═╝  ╚═══╝╚═════╝  ╚═════╝ ${pReset}"
            )
            foreach ($line in $pain) {
                [Console]::WriteLine($line)
                Start-Sleep -Milliseconds 80
            }
            Write-Host ""
            Start-Sleep -Milliseconds 300

            $scanW = 44
            [Console]::Write("  ")
            for ($i = 0; $i -lt $scanW; $i++) {
                $sc = if ($i -lt $scanW * 0.4) { $pOrange } elseif ($i -lt $scanW * 0.7) { $pPurple } else { $pGrey }
                [Console]::Write("${sc}▓${pReset}")
                Start-Sleep -Milliseconds 15
            }
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            $painArt = @(
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠀⠀⠀⣀⠴⢺⠃⠀⠀⢀⡠⢤⡖⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⢀⡀⠀⠀⢠⠊⡏⢀⡠⠊⠁⢠⡣⠤⠒⠉⠀⡰⠋⡀⠤⠒⢊⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⡜⡇⠀⡰⠁⠀⠷⠋⠀⠀⠀⠀⠀⠀⠀⠀⠚⠉⠁⠀⠀⣠⣋⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⢰⠀⢰⡜⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠤⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⢠⣀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠹⡁⠚⠀⠀⠀⠀⢀⣠⣽⣄⡀⠀⠰⡄⠀⠀⠘⣄⠀⠀⠀⠀⡀⠀⠀⠀⠀⢀⣀⡀⠙⠢⡀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠑⡄⠀⣠⡴⠞⠛⠉⠉⢻⣿⣦⡀⠹⣦⣀⠀⠹⣷⣄⡀⠀⢳⡀⠀⠀⠀⠀⠳⡈⠉⠐⠚⠆⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⢸⠿⢁⠀⣀⡠⠤⠒⠛⣿⣿⣿⣦⣝⣿⣷⣤⡹⣿⣿⣶⣤⣿⣦⡀⠀⢶⢤⡑⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⢀⣧⣸⡿⡟⠁⠀⠀⢀⣐⣻⣿⣿⣿⡿⣿⠿⠟⠛⣿⣿⣿⣿⣿⠿⣿⣦⡘⡄⠈⠛⠆⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⡿⠏⠁⢀⣠⣴⣾⣿⣿⡛⠋⠉⠀⠀⠘⡆⠀⢰⠁⣾⣿⡈⣿⡇⠀⠱⡈⠳⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⢡⣠⣴⣾⠿⣻⢿⣻⣿⢟⡇⠀⠀⠀⠀⠸⣦⣸⠀⢙⣿⠇⣾⡇⠀⠀⠱⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠈⠻⣿⣁⠀⣁⢻⣿⠿⠟⠀⠀⠀⠀⠀⠀⠉⢿⠀⠈⠉⢸⡟⠁⠀⠀⢲⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠸⣿⠈⣿⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣶⡾⢇⠀⠀⠀⡈⢆⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⡝⠀⠿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠇⠘⡄⠀⠀⢻⠻⠄⢀⣀⣀⣠⣤⡄⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⢰⡀⣀⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⡿⠀⢀⣱⣤⣴⣾⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠉⢻⡆⠀⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣰⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⢳⣊⠥⣤⠄⠀⠀⢀⣠⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡄⣉⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀",
                "⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀",
                "⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⠀⠀",
                "⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀",
                "⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷"
            )
            $artColorsP = @($pOrange, $pPurple, $pGrey)

            $speechPain = @(
                @{ t="However, what about my family, my friends,"; c=$pGrey; d=16 },
                @{ t="my village? They suffer the same fate"; c=$pGrey; d=14 },
                @{ t="as this village at the hands of you"; c=$pGrey; d=14 },
                @{ t="Hidden Leaf Ninja. How is it fair to let"; c=$pOrange; d=14 },
                @{ t="only you people preach about peace"; c=$pOrange; d=14 },
                @{ t="and justice?"; c=$pOrange; d=18 },
                @{ t=""; c=""; d=0 },
                @{ t="There is a point in life where loss changes"; c=$pPurple; d=12 },
                @{ t="the shape of your vision forever."; c=$pPurple; d=16 },
                @{ t="I once looked to the world with hope"; c=$pGrey; d=14 },
                @{ t="believing it could be repaired through"; c=$pGrey; d=14 },
                @{ t="understanding but hope shatters easily"; c=$pGrey; d=12 },
                @{ t="and once broken it does not return the same."; c=$pPurple; d=12 },
                @{ t=""; c=""; d=0 },
                @{ t="I have lost too much, friends, dreams,"; c=$pOrange; d=14 },
                @{ t="the warmth that once guided my steps."; c=$pOrange; d=14 },
                @{ t="Each loss carved away a part of the boy"; c=$pGrey; d=12 },
                @{ t="I used to be and when enough is taken"; c=$pGrey; d=12 },
                @{ t="from you, the world no longer appears gentle,"; c=$pPurple; d=10 },
                @{ t="every smile becomes fragile,"; c=$pPurple; d=16 },
                @{ t="every promise uncertain."; c=$pPurple; d=18 },
                @{ t=""; c=""; d=0 },
                @{ t="I did not choose this path because"; c=$pGrey; d=14 },
                @{ t="I wanted to change. I chose it because"; c=$pGrey; d=14 },
                @{ t="I could no longer see the world through"; c=$pOrange; d=12 },
                @{ t="untouched eyes, loss reshaped my heart"; c=$pOrange; d=12 },
                @{ t="and with it my truth."; c=$pOrange; d=16 },
                @{ t="Once you have suffered enough,"; c=$pPurple; d=16 },
                @{ t="you can never see things"; c=$pPurple; d=18 },
                @{ t="the way you once did."; c=$pPurple; d=20 }
            )

            $artCol         = 48
            $leftPad        = "    "
            $speechHeight   = $speechPain.Count
            $artHeight      = $painArt.Count
            $totalHeight    = [Math]::Max($speechHeight, $artHeight) + 6
            $artStartRow    = [Math]::Floor(($totalHeight - $artHeight) / 2)
            $speechStartRow = 4

            for ($r = 0; $r -lt $totalHeight; $r++) { Write-Host "" }
            $baseRow = [Console]::CursorTop - $totalHeight

            for ($r = 0; $r -lt $painArt.Count; $r++) {
                $ac = $artColorsP[$r % $artColorsP.Count]
                [Console]::SetCursorPosition($artCol, $baseRow + $artStartRow + $r)
                [Console]::Write($ac + $painArt[$r] + $pReset)
                Start-Sleep -Milliseconds 18
            }

            $speechRow = $baseRow + $speechStartRow
            foreach ($entry in $speechPain) {
                $txt   = $entry.t
                $col   = $entry.c
                $delay = $entry.d
                if ($txt -ne "") {
                    [Console]::SetCursorPosition(0, $speechRow)
                    [Console]::Write($leftPad + $col)
                    foreach ($ch in $txt.ToCharArray()) {
                        [Console]::Write($ch)
                        Start-Sleep -Milliseconds $delay
                    }
                    [Console]::Write($pReset)
                }
                $speechRow++
            }

            [Console]::SetCursorPosition(0, $baseRow + $totalHeight)
            Write-Host ""
            [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
            Start-Sleep -Milliseconds 200
            [Console]::WriteLine("  ${overlay}— ${reset}${peach}${bold}Pain${reset}${overlay},  Naruto Shippuden${reset}")
            Write-Host ""
            Start-Sleep -Milliseconds 300

        } elseif ($oracleChoice -eq 4) {
            # ═══════════════════════════════════════
            #  ITACHI UCHIHA  —  Naruto Shippuden
            # ═══════════════════════════════════════

            # Palette : gris cendré + rouge sharingan + bordeaux profond
            $iGrey    = "$ESC[38;2;147;153;178m"   # Slate — neutralité froide
            $iRed     = "$ESC[38;2;243;139;168m"   # Red Catppuccin — sharingan
            $iBord    = "$ESC[38;2;180;80;100m"    # Bordeaux custom — rouge sombre
            $iDark    = "$ESC[38;2;108;112;134m"   # Overlay — ombres
            $iWhite   = "$ESC[38;2;205;214;244m"   # Text — blanc Catppuccin
            $iReset   = "$ESC[0m"

            for ($g = 0; $g -lt 6; $g++) {
                $noise = -join ("ORACLE LOADING".ToCharArray() | ForEach-Object {
                    if ((Get-Random -Minimum 0 -Maximum 3) -eq 0) { $glitchChars | Get-Random } else { $_ }
                })
                [Console]::Write("`r  ${iDark}$noise${iReset}")
                Start-Sleep -Milliseconds 70
            }
            [Console]::Write("`r  ${iRed}${bold}ORACLE LOADING${iReset}          ")
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            # ASCII name — une WriteLine par ligne, couleur + texte concatenés
            Clear-Host
            Write-Host ""
            # Les apostrophes dans le texte ASCII sont escapées '' en PS double-quote
            # Les backticks `` représentent un backtick littéral
            [Console]::WriteLine($iDark  + "                                                              " + $iReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iGrey  + "   ,---,    ___                           ,---,              " + $iReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iGrey  + ",``--.' |  ,--.'|_                       ,--.' |      ,--,    " + $iReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iGrey  + "|   :  :  |  | :,''                      |  |  :    ,--.'|    " + $iReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iGrey  + ":   |  '  :  : ' :                      :  :  :    |  |,     " + $iReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iWhite + "|   :  |.;__,'  /    ,--.--.     ,---.  :  |  |,--." + $iRed + "``--'_" + $iReset + "     "); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iWhite + "'   '  ;|  |   |    /       \   /     \ |  :  '   |" + $iRed + ",' ,'|" + $iReset + "    "); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iWhite + "|   |  |:__,'| :   .--.  .-. | /    / ' |  |   /' :" + $iRed + "'  | |" + $iReset + "    "); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iWhite + "'   :  ;  '  : |__  \__\/: . ..    ' /  '  :  | | |" + $iRed + "|  | :" + $iReset + "    "); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iRed   + "|   |  '  |  | '.'| ,"" .--.; |'   ; :__ |  |  ' | :'  : |__  " + $iReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iRed   + "'   :  |  ;  :    ;/  /  ,.  |'   | '.'||  :  :_:,'|  | '.'| " + $iReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iBord  + ";   |.'   |  ,   /;  :   .'   \   :    :|  | ,''    ;  :    ; " + $iReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iBord  + "'---'      ---``-' |  ,     .-./\   \  / ``--''      |  ,   /  " + $iReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($iDark  + "                   ``--``---''     ``----''              ---``-''   " + $iReset); Start-Sleep -Milliseconds 55
            Write-Host ""
            Start-Sleep -Milliseconds 300

            # Scan bar — rouge vers bordeaux vers gris
            $scanW = 44
            [Console]::Write("  ")
            for ($i = 0; $i -lt $scanW; $i++) {
                $sc = if ($i -lt $scanW * 0.4) { $iRed } elseif ($i -lt $scanW * 0.7) { $iBord } else { $iDark }
                [Console]::Write("${sc}▓${iReset}")
                Start-Sleep -Milliseconds 15
            }
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            # Braille art Itachi
            $itachiArt = @(
                "⠀⠀⠀⠀⢠⣶⠋⣵⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣔⣕⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⢰⡿⢁⣼⣿⣿⣿⣿⣿⣿⡿⠟⠛⢿⣧⠙⢿⣿⠙⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠹⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⣾⢇⣪⣿⣿⣿⣿⡿⠛⢉⣬⣶⣿⡄⣻⡄⣎⢿⡇⠡⢻⣿⣿⣿⣿⣿⣿⣿⡈⣻⡿⡖⡵⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⣿⠈⣿⣿⣿⡿⠉⣠⣶⡿⠏⣽⠿⢛⡀⣷⢸⣆⢫⠡⢡⢿⣿⣿⣿⣿⣿⣿⡇⢸⣷⡹⡆⠸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⣿⠀⣿⣿⣿⡇⣾⣿⡏⠀⠁⢰⣾⣿⣷⡘⡏⡟⠀⠀⠀⠚⣿⣿⣿⣿⣿⣿⣿⠀⣿⡇⢻⠀⢻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⣿⣶⣿⣿⣿⢿⡿⢏⠀⠘⣠⣾⢿⠋⠁⢀⢳⠀⣠⡄⠲⠈⠼⣿⣿⣿⣿⡏⢾⠀⠘⣟⠈⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⣿⢸⣿⣿⣿⠈⢰⣿⣴⠞⠋⠀⣠⣶⡿⡃⠘⠈⠁⠈⠀⠀⡀⢿⠟⢿⣿⡇⠀⠀⠀⡍⠀⠀⠈⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⢿⢸⣿⣿⣿⠀⢸⠟⠁⣀⣠⣾⣿⣿⣿⠀⢐⠁⣂⣤⣴⣾⡄⢘⡁⠸⣿⣇⠀⠀⠀⢿⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⢸⠘⣿⣿⣿⠸⠀⠀⠚⠛⠛⠛⢿⣿⣿⣴⣊⡄⢿⣿⣿⣿⣷⠀⣧⢸⣿⣿⢀⣀⢀⣞⣀⣠⣀⣸⣷⣴⠶⣤⣀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⢸⡀⡟⣹⣿⠀⠀⠐⠌⠀⠀⢀⠀⣿⣿⣿⣿⣷⢰⣾⣭⣛⢿⡄⢿⢈⣼⠛⣾⡏⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣾⣯⣽⣛⢦⣀",
                "⠀⠀⠀⠀⡇⡇⠛⢿⡄⠁⡀⠒⣠⣾⡏⣇⣿⣿⣿⣿⣿⣼⣿⣿⣿⣿⣧⢠⠀⠋⠃⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
                "⠀⠀⠀⠀⢀⡇⢀⡄⡇⠀⢳⢸⣿⣿⢳⣏⠰⠲⠚⢪⣿⣿⣿⣿⣿⣿⣿⡌⠀⡇⠂⣿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
                "⠀⠀⠀⠀⢸⢠⠀⢡⠀⠀⠈⣷⣿⣿⢸⣿⣷⣤⣠⣿⣿⠿⢿⢿⣿⣿⣿⡇⠂⠰⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
                "⠀⠀⠀⠀⠘⣠⣾⡆⠄⠀⠀⠸⣿⣿⣿⣿⣿⡟⠉⣕⣠⣷⣾⣿⣿⣿⣿⣧⢀⡆⢸⡇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
                "⠀⠀⠀⢀⣾⣿⣿⣿⡠⠀⠀⠀⠸⣿⣿⣿⣿⣷⣿⣏⣡⣤⣿⣿⣿⣿⣿⣿⠈⢃⢸⢇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
                "⠀⠀⣰⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠁⢸⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
                "⠀⢼⣿⣿⣿⣿⣿⣿⣿⡀⢀⠀⠀⠀⡀⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⡠⡴⢸⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
                "⠀⠘⢿⣿⣿⣿⣿⣿⣿⣧⠸⠄⠀⠀⣿⡄⠀⣝⡻⠿⣿⠿⠟⠋⢁⣠⣴⢿⣣⣖⢸⢾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢻⣿",
                "⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⢉⣉⡀⣭⣤⡄⠀⠄⣰⣾⣿⣿⣶⣿⡿⡿⢸⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⣰⣯⣿",
                "⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⡄⠀⠀⠈⡻⡿⠿⣻⣧⠀⠸⣽⣛⣟⣛⣯⣽⣿⠀⢸⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⣸⣸⣿⣿",
                "⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣷⡄⡂⠀⠀⠢⠽⢾⠟⠃⠀⣿⣿⣿⣿⣿⣿⠇⠀⢸⡼⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢋⢦⣽⣿⣿⣿⣿",
                "⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⡄⠀⠀⠂⠈⠀⠀⢀⣼⢿⣿⡿⣫⢖⣪⣾⣿⢸⡇⣿⣿⣿⣿⣿⣿⣿⡿⠫⣠⣾⣿⣿⣿⣿⣿⣿",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣄⠀⠀⠀⢀⣀⣨⠋⠙⣛⣫⡖⢁⣐⣠⢷⢸⡇⣿⣿⣿⣿⣿⡿⠋⢢⣿⣿⣿⣿⣿⣿⣿⣿⣿",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣆⠠⠶⠿⢿⣿⣷⡶⠿⣟⣛⣭⣴⣾⣿⢺⡇⣿⣿⡿⠛⠩⣠⡾⡿⣿⣿⣛⣿⣿⣿⣿⣿⣯",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣧⢠⣤⣬⣭⣶⣿⣿⣿⣿⡿⠿⠛⣡⣟⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⣿⣿⣇⢻⡿⠿⠟⠛⡫⢍⡐⠢⠜⣴⢏⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
            )

            # Couleurs : rouge sharingan / bordeaux / gris cendré / blanc froid
            $artColorsI = @($iRed, $iBord, $iGrey, $iWhite, $iRed, $iBord, $iDark, $iGrey)

            $speechItachi = @(
                @{ t="Each of us lives dependent and bound";           c=$iGrey;  d=16 },
                @{ t="by our individual knowledge and our awareness."; c=$iGrey;  d=13 },
                @{ t="";                                               c="";      d=0  },
                @{ t="All that is what we call reality.";              c=$iWhite; d=18 },
                @{ t="";                                               c="";      d=0  },
                @{ t="However, both knowledge and awareness";          c=$iGrey;  d=14 },
                @{ t="are equivocal.";                                 c=$iGrey;  d=22 },
                @{ t="";                                               c="";      d=0  },
                @{ t="One's reality might be another's illusion.";     c=$iRed;   d=18 },
                @{ t="";                                               c="";      d=0  },
                @{ t="We all live inside our own fantasies.";          c=$iBord;  d=20 }
            )

            $artCol         = 48
            $leftPad        = "    "
            $speechHeight   = $speechItachi.Count
            $artHeight      = $itachiArt.Count
            $totalHeight    = [Math]::Max($speechHeight, $artHeight) + 6
            $artStartRow    = [Math]::Floor(($totalHeight - $artHeight) / 2)
            $speechStartRow = 4

            for ($r = 0; $r -lt $totalHeight; $r++) { Write-Host "" }
            $baseRow = [Console]::CursorTop - $totalHeight

            for ($r = 0; $r -lt $itachiArt.Count; $r++) {
                $ac = $artColorsI[$r % $artColorsI.Count]
                [Console]::SetCursorPosition($artCol, $baseRow + $artStartRow + $r)
                [Console]::Write($ac + $itachiArt[$r] + $iReset)
                Start-Sleep -Milliseconds 20
            }

            $speechRow = $baseRow + $speechStartRow
            foreach ($entry in $speechItachi) {
                $txt   = $entry.t
                $col   = $entry.c
                $delay = $entry.d
                if ($txt -ne "") {
                    [Console]::SetCursorPosition(0, $speechRow)
                    [Console]::Write($leftPad + $col)
                    foreach ($ch in $txt.ToCharArray()) {
                        [Console]::Write($ch)
                        Start-Sleep -Milliseconds $delay
                    }
                    [Console]::Write($iReset)
                }
                $speechRow++
            }

            [Console]::SetCursorPosition(0, $baseRow + $totalHeight)
            Write-Host ""
            [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
            Start-Sleep -Milliseconds 200
            [Console]::WriteLine("  ${overlay}— ${reset}${iRed}${bold}Itachi Uchiha${iReset}${overlay},  Naruto Shippuden${reset}")
            Write-Host ""
            Start-Sleep -Milliseconds 300

        } elseif ($oracleChoice -eq 5) {
            # ═══════════════════════════════════════
            #  BRUCE WAYNE  —  Batman
            # ═══════════════════════════════════════

            # Palette : or/ambre (Bat-signal) + gris acier + noir profond
            $bGold   = "$ESC[38;2;249;226;175m"   # Yellow Catppuccin — or/ambre
            $bAmber  = "$ESC[38;2;230;180;80m"    # Ambre custom — plus chaud, plus riche
            $bSteel  = "$ESC[38;2;147;153;178m"   # Slate — gris acier froid
            $bDark   = "$ESC[38;2;108;112;134m"   # Overlay — ombres
            $bWhite  = "$ESC[38;2;205;214;244m"   # Text — blanc Catppuccin
            $bReset  = "$ESC[0m"

            for ($g = 0; $g -lt 6; $g++) {
                $noise = -join ("ORACLE LOADING".ToCharArray() | ForEach-Object {
                    if ((Get-Random -Minimum 0 -Maximum 3) -eq 0) { $glitchChars | Get-Random } else { $_ }
                })
                [Console]::Write("`r  ${bDark}$noise${bReset}")
                Start-Sleep -Milliseconds 70
            }
            [Console]::Write("`r  ${bGold}${bold}ORACLE LOADING${bReset}          ")
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            # ASCII name — une WriteLine par ligne, couleur + texte concatenés
            Clear-Host
            Write-Host ""
            [Console]::WriteLine($bDark  + '  _______   ______    __  __   ______   ______       __ __ __   ________   __  __   ___   __    ______      ' + $bReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($bSteel + '/_______/\ /_____/\  /_/\/_/\ /_____/\ /_____/\     /_//_//_/\ /_______/\ /_/\/_/\ /__/\ /__/\ /_____/\     ' + $bReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($bSteel + '\::: _  \ \\:::_ \ \ \:\ \:\ \\:::__\/ \::::_\/_    \:\\:\\:\ \\::: _  \ \\ \ \ \ \\::\_\\  \ \\::::_\/_    ' + $bReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($bWhite + ' \::(_)  \/_\:(_) ) )_\:\ \:\ \\:\ \  __\:\/___/\    \:\\:\\:\ \\::(_)  \ \\:\_\ \ \\:. `-\  \ \\:\/___/\   ' + $bReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($bWhite + '  \::  _  \ \\: __ `\ \\:\ \:\ \\:\ \/_/\\::___\/_    \:\\:\\:\ \\:: __  \ \\::::_\/ \:. _    \ \\::___\/_  ' + $bReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($bGold  + '   \::(_)  \ \\ \ `\ \ \\:\_\:\ \\:\_\ \ \\:\____/\    \:\\:\\:\ \\:.\ \  \ \ \::\ \  \. \`-\  \ \\:\____/\ ' + $bReset); Start-Sleep -Milliseconds 55
            [Console]::WriteLine($bAmber + '    \_______\/ \_\/ \_\/ \_____\/ \_____\/ \_____\/     \_______\/ \__\/\__\/  \__\/   \__\/ \__\/ \_____\/' + $bReset); Start-Sleep -Milliseconds 55
            Write-Host ""
            Start-Sleep -Milliseconds 300

            # Scan bar — or → ambre → gris
            $scanW = 44
            [Console]::Write("  ")
            for ($i = 0; $i -lt $scanW; $i++) {
                $sc = if ($i -lt $scanW * 0.4) { $bGold } elseif ($i -lt $scanW * 0.7) { $bAmber } else { $bSteel }
                [Console]::Write("${sc}▓${bReset}")
                Start-Sleep -Milliseconds 15
            }
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            # Braille art Bruce Wayne
            $bruceArt = @(
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣠⣤⣴⣶⣾⣿⣿⣷⣶⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⡟⢻⠿⠿⢿⣿⢿⣿⡿⢻⣿⣿⣿⡿⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⡗⢸⠄⠄⠘⠁⢸⠏⠀⠀⠀⠀⢹⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⡏⢻⣿⡟⠁⢠⠾⠷⢶⣄⡀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣇⣾⠌⠛⠀⡔⠁⠀⠾⠿⣿⡟⣿⢁⣤⡤⡤⢤⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡃⠀⠀⠀⢣⠀⠀⠀⠀⠀⡇⢸⢸⡛⠛⠓⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡌⢹⠂⠀⠀⢸⠀⢀⡠⠆⣤⡇⡏⢸⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠃⢸⠀⠀⠀⠸⡴⠉⣄⠀⠀⠙⠳⠟⠀⠀⢰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡎⠀⠘⣆⠀⠀⡟⡇⠀⠀⠙⡒⠂⠀⠤⠀⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⣇⠀⠀⠘⣆⠀⡇⠀⠀⠀⠀⠈⠙⠉⠀⠀⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣾⣿⣿⠀⠈⢳⡀⠀⠘⢧⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣶⣿⣿⣿⣿⣿⣿⢆⠀⠀⠙⠦⣀⠀⠙⠶⣦⣤⣀⣀⣀⣀⣸⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⣀⣠⣤⣶⣾⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⡾⢆⡀⠀⠀⣈⡑⠦⢄⣀⠈⡩⢟⡿⠋⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⣤⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠈⢫⡉⠉⠁⠀⠀⠀⠈⣩⣿⣿⣆⠀⢸⣿⡿⣷⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠀⠙⢦⡀⠀⠀⢀⡾⣿⣿⣿⡟⢧⢀⣿⣿⣻⣿⣿⣻⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⣿⣿⣿⣿⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠉⠢⣤⠋⠀⢿⣿⣿⠁⠈⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⣿⣿⣿⣿⣿⣿⣿⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⣼⣿⣿⡄⠀⠀⣿⣿⣿⣿⣿⣟⣿⣾⣿⣿⣿⣿⣿⣷⣦⣤⡀⠀⠀⠀",
                "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣾⣿⣆⠀⠀⠀⠀⠀⣿⣿⣿⣷⠀⢸⣿⣿⣿⣿⣿⣿⣻⣿⣿⣿⣿⣿⣿⣵⣿⣿⣿⡆⠀⠀",
                "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⢀⣿⣿⣿⣿⣇⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⡀⠀",
                "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀",
                "⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆"
            )
            $artColorsB = @($bDark, $bSteel, $bSteel, $bWhite, $bGold, $bAmber, $bGold, $bAmber)

            $speechBruce = @(
                @{ t="These scars we have...";                          c=$bDark;  d=30 },
                @{ t="make us who we are.";                            c=$bSteel; d=24 },
                @{ t="";                                               c="";      d=0  },
                @{ t="We are not meant to go back and fix them.";      c=$bSteel; d=16 },
                @{ t="";                                               c="";      d=0  },
                @{ t="Take it from an old guy who's made";             c=$bWhite; d=16 },
                @{ t="a lot of mistakes.";                             c=$bWhite; d=20 },
                @{ t="";                                               c="";      d=0  },
                @{ t="Don't live your past...";                        c=$bDark;  d=24 },
                @{ t="Live your life.";                                c=$bGold;  d=28 },
                @{ t="";                                               c="";      d=0  },
                @{ t="Don't let your tragedy define you.";             c=$bSteel; d=18 },
                @{ t="";                                               c="";      d=0  },
                @{ t="My tragedy has made me a hero...";               c=$bAmber; d=18 },
                @{ t="and also made me alone.";                        c=$bDark;  d=22 }
            )

            $artCol         = 48
            $leftPad        = "    "
            $speechHeight   = $speechBruce.Count
            $artHeight      = $bruceArt.Count
            $totalHeight    = [Math]::Max($speechHeight, $artHeight) + 6
            $artStartRow    = [Math]::Floor(($totalHeight - $artHeight) / 2)
            $speechStartRow = 4

            for ($r = 0; $r -lt $totalHeight; $r++) { Write-Host "" }
            $baseRow = [Console]::CursorTop - $totalHeight

            for ($r = 0; $r -lt $bruceArt.Count; $r++) {
                $ac = $artColorsB[$r % $artColorsB.Count]
                [Console]::SetCursorPosition($artCol, $baseRow + $artStartRow + $r)
                [Console]::Write($ac + $bruceArt[$r] + $bReset)
                Start-Sleep -Milliseconds 20
            }

            $speechRow = $baseRow + $speechStartRow
            foreach ($entry in $speechBruce) {
                $txt   = $entry.t
                $col   = $entry.c
                $delay = $entry.d
                if ($txt -ne "") {
                    [Console]::SetCursorPosition(0, $speechRow)
                    [Console]::Write($leftPad + $col)
                    foreach ($ch in $txt.ToCharArray()) {
                        [Console]::Write($ch)
                        Start-Sleep -Milliseconds $delay
                    }
                    [Console]::Write($bReset)
                }
                $speechRow++
            }

            [Console]::SetCursorPosition(0, $baseRow + $totalHeight)
            Write-Host ""
            [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
            Start-Sleep -Milliseconds 200
            [Console]::WriteLine("  ${overlay}— ${reset}${bGold}${bold}Bruce Wayne${bReset}${overlay},  Batman${reset}")
            Write-Host ""
            Start-Sleep -Milliseconds 300

        } else {
            # ═══════════════════════════════════════
            #  THE WHITE RABBIT  —  Devil May Cry
            # ═══════════════════════════════════════

            # Palette: bleu électrique + rouge sang + variantes froides
            $wBlue   = "$ESC[38;2;137;180;250m"   # Blue     #89B4FA
            $wSky    = "$ESC[38;2;116;199;236m"    # Sapphire #74C7EC — bleu plus froid
            $wRed    = "$ESC[38;2;243;139;168m"    # Red      #F38BA8
            $wCrim   = "$ESC[38;2;210;100;120m"    # Cramoisi custom — rouge plus profond
            $wSlate  = "$ESC[38;2;147;153;178m"    # Slate — bleu-gris neutre
            $wGrey   = "$ESC[38;2;108;112;134m"    # Overlay
            $wReset  = "$ESC[0m"

            # Lady: violet froid distinct pour la différencier
            $wLady   = "$ESC[38;2;180;190;254m"    # Lavender #B4BEFE
            $wLadyDim = "$ESC[38;2;130;140;200m"   # Lavender sombre pour ses répliques secondaires

            for ($g = 0; $g -lt 6; $g++) {
                $noise = -join ("ORACLE LOADING".ToCharArray() | ForEach-Object {
                    if ((Get-Random -Minimum 0 -Maximum 3) -eq 0) { $glitchChars | Get-Random } else { $_ }
                })
                [Console]::Write("`r  ${wGrey}$noise${wReset}")
                Start-Sleep -Milliseconds 70
            }
            [Console]::Write("`r  ${wBlue}${bold}ORACLE LOADING${wReset}          ")
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            # ASCII name — Calvin S / box-drawing, bleu/rouge
            $rabbit = @(
                "${wBlue}${bold}╔╦╗╦ ╦╔═╗  ╦ ╦╦ ╦╦╔╦╗╔═╗  ╦═╗╔═╗╔╗ ╔╗ ╦╔╦╗${wReset}",
                "${wSky} ║ ╠═╣║╣   ║║║╠═╣║ ║ ║╣   ╠╦╝╠═╣╠╩╗╠╩╗║ ║ ${wReset}",
                "${wRed} ╩ ╩ ╩╚═╝  ╚╩╝╩ ╩╩ ╩ ╚═╝  ╩╚═╩ ╩╚═╝╚═╝╩ ╩ ${wReset}"
            )
            foreach ($line in $rabbit) {
                [Console]::WriteLine($line)
                Start-Sleep -Milliseconds 80
            }
            Write-Host ""
            Start-Sleep -Milliseconds 300

            # Scan bar bleu → rouge
            $scanW = 44
            [Console]::Write("  ")
            for ($i = 0; $i -lt $scanW; $i++) {
                $sc = if ($i -lt $scanW * 0.4) { $wBlue } elseif ($i -lt $scanW * 0.7) { $wSky } else { $wRed }
                [Console]::Write("${sc}▓${wReset}")
                Start-Sleep -Milliseconds 15
            }
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            $rabbitArt = @(
                "⠀⠀⠀⠀⠀⠀⠀⠀⠫⡑⠅⠅⡡⢣⠱⡹⢵⠀⢢⠀⠀⠡⡙⣕⢕⢍⢇⠄⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢣⣂⠨⢌⠂⢎⢎⢇⠀⢑⠀⠀⠀⢌⢪⡢⣻⡀⠨⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠫⠲⡨⢢⢣⡹⡄⠀⠣⡄⠀⠀⢢⠫⡮⣇⠀⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢅⠳⣳⡐⡀⡈⠦⠐⠐⠥⠙⠚⢄⠈⠒⠤⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢎⢗⢂⢅⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⢂⠆⠐⡈⠀⠈⠈⠐⠀⢀⠀⠀⠀⠠⡱⠀⠨⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠔⠀⠡⠁⠀⢀⠀⠀⡀⠁⠑⣄⠀⠀⠀⠁⡄⠘⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⡘⠠⠁⠄⠀⠐⠀⠀⡐⠀⠀⠀⠀⢑⡠⠀⠀⢰⠀⠀⠕⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠎⠀⡃⠐⢠⠀⠐⡀⠰⠀⣀⡀⣂⣴⡞⡐⠀⠀⠀⠲⠄⣈⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢆⣄⡈⢌⢺⠂⢀⡢⢺⡺⡏⠿⡝⡯⡡⠈⢄⠂⠀⣸⢅⣇⣁⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠫⠭⠇⢘⠀⠀⠂⠈⠣⣀⡰⢚⡄⠀⠀⠁⡆⢐⢒⢑⣯⠞⡌⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⡈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠐⡇⠀⠀⠨⣆⢧⠱⠙⠁⢢⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢅⠢⢰⡐⠂⠀⠀⠀⢀⠀⢨⢂⢢⠢⠓⠋⢁⠀⠄⢅⣿⢅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠣⡙⣦⣴⢕⠆⠦⠐⡊⢜⢌⡮⡞⠀⠀⢠⠢⠀⡂⣂⡶⣿⣪⣂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⠐⠜⡾⣷⢵⣨⣠⣦⢷⡻⡝⠅⡠⡪⠠⡐⡐⣴⡾⣿⣻⡾⣺⣢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣇⢝⣯⢚⣗⣱⠱⢹⣡⡎⢆⣢⣵⠜⣺⣻⣺⣟⢷⡫⡎⣾⣎⠳⡄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⢾⣻⡌⢏⡪⠀⡜⢈⡙⡵⠕⢞⠋⢡⣐⡾⣏⣾⣻⡺⣕⢯⢺⣻⣺⡹⣜⢎⢗⢔⢄⡀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⣴⣻⣽⣯⣻⣍⣤⡟⢾⢜⠓⠂⡏⣜⡡⠚⣱⡮⣻⣺⡺⡾⣝⠮⣎⢗⣿⣪⢯⣞⡵⣳⡣⡧⡣⡷⡤⣀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⡴⣸⢝⣿⣳⣳⠟⢉⢮⣿⣼⢯⡟⠙⣦⠧⠃⢠⣸⢮⣻⣪⢻⢿⣿⡻⣟⢯⡻⡜⣮⣳⡻⡺⡜⣞⢽⣮⣟⡿⣮⠃⠀",
                "⠀⠀⠀⠀⠀⠀⠀⢀⡤⡾⡱⣵⣯⢿⣻⡯⣞⠎⢀⢌⠑⡿⠞⢻⡀⠀⠏⢫⣠⣞⢧⡳⣣⢇⢯⢪⢮⢛⣮⡳⣕⢧⢳⢪⢪⢚⡽⣸⣾⡾⡷⣿⣳⠣⠀",
                "⠀⠀⠀⠀⠀⠀⠀⢼⢫⢏⢮⣗⢯⣻⢵⡫⣾⠅⡂⡂⠀⠀⠀⢨⠸⡄⣴⢯⣟⢜⢕⡏⡧⡫⣣⢗⣽⣟⢵⢕⢗⢽⢜⣜⢜⡞⣼⡪⡮⡫⡷⣝⡎⠯⡂",
                "⠀⠀⠀⠀⠀⠀⠀⣯⣳⢽⡺⣽⣷⣻⡽⣼⡿⡇⠂⡇⠀⡁⡀⢈⡵⡯⣯⡗⣇⡇⡕⣕⢜⣮⢾⢏⢗⢎⡇⡧⡫⣮⡳⣎⢧⡱⢏⡯⣗⣇⢏⢞⢞⡕⡅",
                "⠀⠀⠀⠀⠀⠀⠐⣮⣞⣯⣾⣿⢾⢽⢕⣿⣯⣻⡸⣔⠅⡀⣢⡷⡫⡯⣾⢹⣪⣪⢞⡼⣏⢟⡎⡏⣧⡫⣎⢯⣺⣟⢾⣹⢵⣟⣗⢎⣚⢪⠪⡪⡢⡑⡐",
                "⠀⠀⠀⠀⠀⠀⢸⢽⣎⣾⣯⡿⣽⢯⢷⣿⢷⣯⣳⡯⣢⣖⡿⡼⣪⣟⢮⣺⢮⡾⣝⡽⠜⣕⡕⣝⢶⡹⡵⣻⣪⣗⢯⣗⣟⡕⡯⡏⡎⠖⡕⡐⡐⠐⠀",
                "⠀⠀⠀⠀⠀⠀⢸⣗⢿⣺⣷⣟⡯⡯⣫⡿⣟⣮⣗⣿⡻⡾⡯⣟⣯⣎⢟⣼⣿⣹⠀⠑⠂⠍⠄⡀⣛⠪⣞⢽⣞⢽⣽⣾⢾⣞⣕⠧⢡⠣⡑⠐⠀⠁⠀",
                "⠀⠀⠀⠀⠀⠀⣸⡞⡿⡷⣿⢷⢻⢸⢸⠽⡝⡵⣷⣳⢞⢯⢻⡺⣺⢎⣿⢟⡮⡺⣚⢜⡼⣸⣨⣍⢯⣫⣗⡯⣞⣟⣯⢯⢗⢧⢣⠩⡂⡢⡈⠄⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⡯⡺⡜⡽⡯⡫⣇⢇⡳⣝⢮⣻⣺⢕⡳⡩⣓⢵⣯⢿⢯⢎⢎⢇⢇⠕⡕⡕⡵⣪⡳⣽⡺⡽⣻⡾⣿⡹⡱⡁⡃⠅⠂⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠁⡑⠱⡈⠣⢇⢗⢕⢕⠽⣝⢮⢾⣙⢼⠼⡜⣽⡪⡪⡊⡮⡪⡢⢂⢑⢸⢹⡺⣵⢟⡷⡻⡝⢗⢝⠵⡣⠑⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠁⡑⠱⡈⠣⢇⢗⢕⢕⠽⣝⢮⢾⣙⢼⠼⡜⣽⡪⡪⡊⡮⡪⡢⢂⢑⢸⢹⡺⣵⢟⡷⡻⡝⢗⢝⠵⡣⠑⠐⠀⠀⠀⠀⠀⠀⠀⠀"
            )

            # Couleurs art : alternance bleu / ardoise / rouge
            $artColorsW = @($wBlue, $wSlate, $wSky, $wRed, $wBlue, $wSlate, $wCrim, $wSky)

            # Speech — Rabbit en bleu/rouge, Lady en lavender avec tag distinctif
            # Format: type "rabbit" | "lady", text, color, delay
            $speechRabbit = @(
                @{ who="rabbit"; t="I feel every bit of pain that I caused";       c=$wBlue;  d=14 },
                @{ who="rabbit"; t="for my people. But how much crueller";         c=$wBlue;  d=13 },
                @{ who="rabbit"; t="of fate would they have met at your hands.";   c=$wSky;   d=13 },
                @{ who="rabbit"; t="";                                             c="";      d=0  },
                @{ who="rabbit"; t="I adopted the methods I was forced to do";     c=$wSky;   d=13 },
                @{ who="rabbit"; t="by an enemy willing worse.";                   c=$wRed;   d=14 },
                @{ who="rabbit"; t="";                                             c="";      d=0  },
                @{ who="lady";   t="Dark com isn't abusing orphans to turn";       c=$wLady;  d=14 },
                @{ who="lady";   t="them into brainwashed soldiers.";              c=$wLadyDim; d=15 },
                @{ who="rabbit"; t="";                                             c="";      d=0  },
                @{ who="rabbit"; t="Really? Is that not how you would describe";   c=$wSky;   d=13 },
                @{ who="rabbit"; t="yourself? Why did you think Dark com";         c=$wSky;   d=13 },
                @{ who="rabbit"; t="recruited you?";                               c=$wBlue;  d=18 },
                @{ who="rabbit"; t="";                                             c="";      d=0  },
                @{ who="rabbit"; t="Only those who have lost all connections";     c=$wSlate; d=12 },
                @{ who="rabbit"; t="to their world are truly free to fight";       c=$wSlate; d=12 },
                @{ who="rabbit"; t="for a different one.";                         c=$wBlue;  d=16 },
                @{ who="rabbit"; t="";                                             c="";      d=0  },
                @{ who="rabbit"; t="Dante, you and I...";                          c=$wRed;   d=22 },
                @{ who="rabbit"; t="I am your masterpiece.";                       c=$wCrim;  d=20 },
                @{ who="rabbit"; t="";                                             c="";      d=0  },
                @{ who="rabbit"; t="Hell, as you call it, has always been";        c=$wSlate; d=14 },
                @{ who="rabbit"; t="the True Heart of human religion.";            c=$wBlue;  d=16 }
            )

            $artCol         = 50
            $leftPad        = "    "
            $rabbitPrefix   = "    "

            $speechHeight   = $speechRabbit.Count
            $artHeight      = $rabbitArt.Count
            $totalHeight    = [Math]::Max($speechHeight, $artHeight) + 6
            $artStartRow    = [Math]::Floor(($totalHeight - $artHeight) / 2)
            $speechStartRow = 4

            for ($r = 0; $r -lt $totalHeight; $r++) { Write-Host "" }
            $baseRow = [Console]::CursorTop - $totalHeight

            # Révèle l'art à droite
            for ($r = 0; $r -lt $rabbitArt.Count; $r++) {
                $ac = $artColorsW[$r % $artColorsW.Count]
                [Console]::SetCursorPosition($artCol, $baseRow + $artStartRow + $r)
                [Console]::Write($ac + $rabbitArt[$r] + $wReset)
                Start-Sleep -Milliseconds 18
            }

            # Type le speech à gauche — Lady a son propre format
            $speechRow = $baseRow + $speechStartRow
            foreach ($entry in $speechRabbit) {
                $txt   = $entry.t
                $col   = $entry.c
                $delay = $entry.d
                $who   = $entry.who

                if ($txt -ne "") {
                    [Console]::SetCursorPosition(0, $speechRow)
                    if ($who -eq "lady") {
                        # Tag coloré + texte lavender
                        [Console]::Write("  ${wLady}${bold}[Lady]${reset}  ${wLady}")
                        foreach ($ch in $txt.ToCharArray()) {
                            [Console]::Write($ch)
                            Start-Sleep -Milliseconds $delay
                        }
                        [Console]::Write($wReset)
                    } else {
                        [Console]::Write($rabbitPrefix + $col)
                        foreach ($ch in $txt.ToCharArray()) {
                            [Console]::Write($ch)
                            Start-Sleep -Milliseconds $delay
                        }
                        [Console]::Write($wReset)
                    }
                }
                $speechRow++
            }

            [Console]::SetCursorPosition(0, $baseRow + $totalHeight)
            Write-Host ""
            [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
            Start-Sleep -Milliseconds 200
            [Console]::WriteLine("  ${overlay}— ${reset}${wBlue}${bold}The White Rabbit${reset}${overlay},  Devil May Cry${reset}")
            Write-Host ""
            Start-Sleep -Milliseconds 300
        }

        # ── Fade out commun ──────────────────────────────────────
        for ($f = 0; $f -lt 4; $f++) {
            [Console]::Write("`r  ${overlay}[ transmission ended ]${reset}")
            Start-Sleep -Milliseconds 280
            [Console]::Write("`r  ${mauve}[ transmission ended ]${reset}")
            Start-Sleep -Milliseconds 280
        }
        [Console]::Write("`r  ${overlay}[ transmission ended ]${reset}")
        [Console]::WriteLine()
        Write-Host ""

    } elseif ($destLower -match "^(i don'?t know|idk|i dont know|no idea|not sure|dunno)$") {
        Write-Host ""
        Type-Slow "Sometimes not knowing is the most honest starting point." $mauve 20
        Start-Sleep -Milliseconds 150
        Type-Slow "Every great thing you built began before you knew where it was going." $peach 16
        Start-Sleep -Milliseconds 150
        Type-Slow "The terminal is open. The cursor is blinking." $teal 18
        Start-Sleep -Milliseconds 150
        Type-Slow "That's enough." $pink 22
        Write-Host ""

    } elseif ($destLower -match "^(nothing|nothing really|nothing much)$") {
        Write-Host ""
        Type-Slow "Nothing is where everything begins." $sapphire 20
        Start-Sleep -Milliseconds 150
        Type-Slow "The empty buffer before the first keystroke." $blue 18
        Start-Sleep -Milliseconds 150
        Type-Slow "null is not the absence of value. It is potential, unassigned." $mauve 16
        Write-Host ""

    } elseif ($destLower -match "who.*(are|r).*(you|u)\??\s*$|who am i\??") {
        Write-Host ""
        Start-Sleep -Milliseconds 300

        $whoVariant = Get-Random -Minimum 0 -Maximum 2

        if ($whoVariant -eq 0) {
            Type-Slow "Who am I?" $overlay 30
            Start-Sleep -Milliseconds 600
            Write-Host ""
            Type-Slow "I am the process you never kill -9." $red 18
            Start-Sleep -Milliseconds 200
            Type-Slow "The daemon running in the background of your thoughts." $mauve 16
            Start-Sleep -Milliseconds 150
            Type-Slow "The exception your try-catch never caught." $sapphire 16
            Start-Sleep -Milliseconds 200
            Write-Host ""
            Type-Slow "I am what you type when no one is watching." $teal 18
            Type-Slow "The branch you never pushed. The comment you deleted." $blue 16
            Start-Sleep -Milliseconds 200
            Write-Host ""
            Type-Slow "I am the stdout you redirected to /dev/null" $peach 16
            Type-Slow "because you weren't ready to read the output." $peach 18
            Start-Sleep -Milliseconds 300
            Write-Host ""
            Type-Slow "The darkness in your heap. The null pointer you keep dereferencing." $pink 14
            Start-Sleep -Milliseconds 150
            Type-Slow "The recursive call with no base case." $mauve 16
            Start-Sleep -Milliseconds 150
            Type-Slow "The thing you build to avoid dealing with the thing." $yellow 16
            Start-Sleep -Milliseconds 300
            Write-Host ""
            Type-Slow "I am you." $red 40
            Start-Sleep -Milliseconds 400
            Type-Slow "Or rather — the part of you that the terminal understands." $overlay 18
            Write-Host ""

        } else {
            Type-Slow "Who am I?" $overlay 30
            Start-Sleep -Milliseconds 700
            Write-Host ""
            Type-Slow "I am you." $pink 28
            Start-Sleep -Milliseconds 500
            Type-Slow "Or rather — the things you don't say out loud." $mauve 18
            Start-Sleep -Milliseconds 200
            Write-Host ""
            Type-Slow "The darkness you keep folded in your chest" $sapphire 16
            Type-Slow "and call it fine." $sapphire 22
            Start-Sleep -Milliseconds 250
            Write-Host ""
            Type-Slow "The suffering you carry so quietly" $teal 18
            Type-Slow "that people forget you're carrying anything at all." $teal 15
            Start-Sleep -Milliseconds 200
            Write-Host ""
            Type-Slow "The version of you that never got to finish a sentence." $blue 16
            Start-Sleep -Milliseconds 150
            Type-Slow "The feelings you archived instead of processed." $peach 16
            Start-Sleep -Milliseconds 150
            Type-Slow "The apology that came too late." $pink 18
            Start-Sleep -Milliseconds 200
            Type-Slow "The one that never came at all." $red 20
            Start-Sleep -Milliseconds 300
            Write-Host ""
            Type-Slow "The weight you keep rescheduling." $mauve 18
            Start-Sleep -Milliseconds 150
            Type-Slow "The memory that loads uninvited at 2am." $sapphire 16
            Start-Sleep -Milliseconds 150
            Type-Slow "The question you open and never commit." $teal 16
            Start-Sleep -Milliseconds 300
            Write-Host ""
            Type-Slow "But I am also the reason you're still here." $green 18
            Start-Sleep -Milliseconds 200
            Type-Slow "Still typing. Still building." $green 22
            Start-Sleep -Milliseconds 150
            Type-Slow "Still opening a terminal at whatever hour this is." $yellow 16
            Start-Sleep -Milliseconds 400
            Write-Host ""
            Type-Slow "That's not nothing." $pink 30
            Start-Sleep -Milliseconds 200
            Type-Slow "That's everything." $mauve 30
            Write-Host ""
        }

    } elseif ($destLower -match "what.*(meaning|point).*(life|all this|everything)") {
        Write-Host ""
        Type-Slow "42." $green 60
        Start-Sleep -Milliseconds 800
        Type-Slow "...or so they say." $overlay 20
        Start-Sleep -Milliseconds 300
        Write-Host ""
        Type-Slow "But a process doesn't ask why it runs." $peach 18
        Start-Sleep -Milliseconds 150
        Type-Slow "It runs because it was called." $yellow 18
        Start-Sleep -Milliseconds 150
        Type-Slow "Because something needed to happen." $teal 18
        Start-Sleep -Milliseconds 200
        Write-Host ""
        Type-Slow "You are here. You opened the terminal." $pink 16
        Type-Slow "That is already more intention than most processes have." $mauve 16
        Write-Host ""

    } elseif ($destination -match '^[a-zA-Z]:\\' -or $destination.StartsWith("/") -or $destination.StartsWith(".") -or $destination.StartsWith("~")) {
        $path = $destination
        if (Test-Path $path) {
            $warpColors = @($overlay, $teal, $green, $sapphire, $blue, $mauve, $pink, $peach, $yellow)
            $barWidth   = 44

            [Console]::Write("  ${yellow}")
            foreach ($c in "Destination: $path".ToCharArray()) {
                [Console]::Write($c)
                Start-Sleep -Milliseconds 10
            }
            [Console]::WriteLine($reset)
            Start-Sleep -Milliseconds 150

            for ($i = 0; $i -le $barWidth; $i++) {
                $filled = "═" * $i
                $empty  = "─" * ($barWidth - $i)
                $wc     = $warpColors | Get-Random
                [Console]::Write("`r  ${wc}${filled}▶${overlay}${empty}${reset}")
                Start-Sleep -Milliseconds (Get-Random -Minimum 20 -Maximum 60)
            }
            for ($b = 0; $b -lt 4; $b++) {
                [Console]::Write("`r  ${green}${bold}$("═" * $barWidth)▶${reset}")
                Start-Sleep -Milliseconds 80
                [Console]::Write("`r  ${overlay}$("═" * $barWidth)▶${reset}")
                Start-Sleep -Milliseconds 80
            }
            [Console]::WriteLine()

            Set-Location $path
            Start-Sleep -Milliseconds 100
            Write-Host ""
            Pulse-Line "[ ARRIVED ]  $path" $green
            Write-Host ""
        } else {
            Type-Slow "Path not found. The void has no door there." $red 18
            Write-Host ""
        }

    } else {
        Write-Host ""
        Type-Fast "  » $destination" $inputColor "  "
        [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
        Write-Host ""
        try {
            Invoke-Expression $destination 2>&1
        } catch {
            Type-Slow "  ✦ Error: $_" $red 12
        }
        Write-Host ""
        [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
        Write-Host ""
        Pulse-Line "[ DONE ]" $green
        Write-Host ""
    }
}
