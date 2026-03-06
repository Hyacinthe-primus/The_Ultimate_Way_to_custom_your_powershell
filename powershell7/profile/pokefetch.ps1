# ─────────────────────────────────────────
#  pokefetch — Pokémon stats fetcher
#  Usage: pokefetch [name|id]
# ─────────────────────────────────────────
# ─────────────────────────────────────────
#  pokefetch — random Pokémon info
# ─────────────────────────────────────────

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
param()

function pokefetch {
    param(
        [Parameter(Position=0)]
        [string]$query = ""
    )

    $ESC      = [char]27
    $mauve    = "$ESC[38;2;203;166;247m"
    $yellow   = "$ESC[38;2;249;226;175m"
    $green    = "$ESC[38;2;166;227;161m"
    $peach    = "$ESC[38;2;250;179;135m"
    $teal     = "$ESC[38;2;148;226;213m"
    $pink     = "$ESC[38;2;245;194;231m"
    $sapphire = "$ESC[38;2;116;199;236m"
    $red      = "$ESC[38;2;243;139;168m"
    $overlay  = "$ESC[38;2;108;112;134m"
    $bold     = "$ESC[1m"
    $reset    = "$ESC[0m"

    function Type-Slow-P {
        param([string]$text, [string]$color, [int]$delay = 20)
        [Console]::Write("  $color")
        foreach ($char in $text.ToCharArray()) {
            [Console]::Write($char)
            Start-Sleep -Milliseconds $delay
        }
        [Console]::WriteLine($reset)
    }

    # Legendary / mythical IDs (Gen 1–8)
    $legendaryIds = @(
        144,145,146,150,151,         # Gen 1
        243,244,245,249,250,251,     # Gen 2
        377,378,379,380,381,382,383,384,385,386, # Gen 3
        480,481,482,483,484,485,486,487,488,489,490,491,492,493, # Gen 4
        494,638,639,640,641,642,643,644,645,646,647,648,649, # Gen 5
        716,717,718,719,720,721,     # Gen 6
        785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,807,808,809, # Gen 7
        888,889,890,891,892,893,894,895,896,897,898 # Gen 8
    )

    # Determine ID or name to fetch
    $isMewtwo = $false
    if ([string]::IsNullOrWhiteSpace($query)) {
        $isMewtwo = (Get-Random -Minimum 1 -Maximum 50) -eq 1
        $target   = if ($isMewtwo) { 150 } else { Get-Random -Minimum 1 -Maximum 1026 }
    } else {
        $target   = $query.ToLower().Trim()
        $isMewtwo = ($target -eq "mewtwo" -or $target -eq "150")
    }

    try {
        $data  = Invoke-RestMethod "https://pokeapi.co/api/v2/pokemon/$target" -ErrorAction Stop
        $id    = $data.id
        $name  = (Get-Culture).TextInfo.ToTitleCase($data.name)
        $types = ($data.types | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_.type.name) }) -join " / "
        $hp    = ($data.stats | Where-Object { $_.stat.name -eq "hp" }).base_stat
        $atk   = ($data.stats | Where-Object { $_.stat.name -eq "attack" }).base_stat
        $def   = ($data.stats | Where-Object { $_.stat.name -eq "defense" }).base_stat
        $speed = ($data.stats | Where-Object { $_.stat.name -eq "speed" }).base_stat
        $height = "$($data.height / 10) m"
        $weight = "$($data.weight / 10) kg"

        $isLegendary = $legendaryIds -contains $id

        if ($isMewtwo) {
            Write-Host ""

            # Header with ⚠ LEGENDARY ENCOUNTER flash
            [Console]::Write("  ${mauve}${bold}◆ POKÉFETCH${reset}  ${overlay}#150${reset}  ")
            Start-Sleep -Milliseconds 200
            $alertText = "⚠ LEGENDARY ENCOUNTER"
            for ($f = 0; $f -lt 6; $f++) {
                $fc = if ($f % 2 -eq 0) { $red } else { $yellow }
                [Console]::Write("`r  ${mauve}${bold}◆ POKÉFETCH${reset}  ${overlay}#150${reset}  ${fc}${bold}$alertText${reset}")
                Start-Sleep -Milliseconds 120
            }
            [Console]::Write("`r  ${mauve}${bold}◆ POKÉFETCH${reset}  ${overlay}#150${reset}  ${red}${bold}$alertText${reset}")
            [Console]::WriteLine()
            [Console]::WriteLine("  ${overlay}$("─" * 50)${reset}")
            Write-Host ""
            Start-Sleep -Milliseconds 300

            # ASCII art braille Mewtwo en couleurs
            $mewArt = @(
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

            # Nom ASCII style oracle compact
            $nameArt = @(
                "${mauve}${bold}  ╔╦╗╔═╗╦ ╦╔╦╗╦ ╦╔═╗${reset}",
                "${pink}  ║║║║╣ ║║║ ║ ║║║║ ║${reset}",
                "${teal}  ╩ ╩╚═╝╚╩╝ ╩ ╚╩╝╚═╝${reset}"
            )
            foreach ($nl in $nameArt) {
                [Console]::WriteLine($nl)
                Start-Sleep -Milliseconds 80
            }
            Write-Host ""

            # Stats on the left, braille art on the right — side-by-side render
            $artColors = @($mauve, $pink, $teal, $sapphire, $mauve, $pink, $teal, $sapphire)
            $statsLines = @(
                "  ${overlay}Type   ${reset}  ${pink}$types${reset}",
                "",
                "  ${overlay}Height ${reset}  ${peach}$height${reset}",
                "  ${overlay}Weight ${reset}  ${peach}$weight${reset}",
                "",
                "  ${overlay}HP     ${reset}  ${red}$hp${reset}",
                "  ${overlay}ATK    ${reset}  ${peach}$atk${reset}",
                "  ${overlay}DEF    ${reset}  ${green}$def${reset}",
                "  ${overlay}SPD    ${reset}  ${mauve}$speed${reset}",
                ""
            )

            $colOffset = 32   # position X de l'art braille
            $totalRows = [Math]::Max($statsLines.Count, $mewArt.Count)

            # Reserve the lines
            for ($r = 0; $r -lt $totalRows; $r++) { Write-Host "" }
            $baseRow = [Console]::CursorTop - $totalRows

            for ($r = 0; $r -lt $totalRows; $r++) {
                [Console]::SetCursorPosition(0, $baseRow + $r)

                # Stats
                if ($r -lt $statsLines.Count) {
                    [Console]::Write($statsLines[$r])
                }

                # Art braille
                if ($r -lt $mewArt.Count) {
                    $ac = $artColors[$r % $artColors.Count]
                    [Console]::SetCursorPosition($colOffset, $baseRow + $r)
                    [Console]::Write("${ac}$($mewArt[$r])${reset}")
                }

                Start-Sleep -Milliseconds 22
            }
            [Console]::SetCursorPosition(0, $baseRow + $totalRows)
            Write-Host ""
            [Console]::WriteLine("  ${overlay}$("─" * 50)${reset}")
            Write-Host ""
            Start-Sleep -Milliseconds 500

            Type-Slow-P "A human sacrificed himself to save the Pokémon." $teal 18
            Start-Sleep -Milliseconds 200
            Type-Slow-P "I pitted them against each other," $sapphire 16
            Type-Slow-P "but not until they set aside their differences" $sapphire 16
            Type-Slow-P "did I see the true power they all share deep inside." $sapphire 16
            Start-Sleep -Milliseconds 200
            Write-Host ""
            Type-Slow-P "I see now that the circumstances of one's birth are irrelevant." $mauve 14
            Type-Slow-P "It is what you do with the gift of life" $pink 16
            Type-Slow-P "that determines who you are." $pink 20
            Write-Host ""
            [Console]::WriteLine("  ${overlay}$("─" * 50)${reset}")
            Write-Host ""
        } else {
            Write-Host ""

            if ($isLegendary) {
                # Flash badge for other legendaries
                [Console]::Write("  ${mauve}${bold}◆ POKÉFETCH${reset}  ${overlay}#$($id.ToString("D3"))${reset}  ")
                $alertText = "⚠ LEGENDARY ENCOUNTER"
                for ($f = 0; $f -lt 6; $f++) {
                    $fc = if ($f % 2 -eq 0) { $red } else { $yellow }
                    [Console]::Write("`r  ${mauve}${bold}◆ POKÉFETCH${reset}  ${overlay}#$($id.ToString("D3"))${reset}  ${fc}${bold}$alertText${reset}")
                    Start-Sleep -Milliseconds 120
                }
                [Console]::Write("`r  ${mauve}${bold}◆ POKÉFETCH${reset}  ${overlay}#$($id.ToString("D3"))${reset}  ${red}${bold}$alertText${reset}")
                [Console]::WriteLine()
            } else {
                [Console]::WriteLine("  ${mauve}${bold}◆ POKÉFETCH${reset}  ${overlay}#$($id.ToString("D3"))${reset}")
            }

            [Console]::WriteLine("  ${overlay}$("─" * 40)${reset}")
            Write-Host ""

            # ── Braille sprite fallback — side-by-side with stats ──
            $sColors = @($teal, $sapphire, $mauve, $green, $peach, $pink, $yellow)
            $sColor  = $sColors[$id % $sColors.Count]

            $isCharizard = ($id -eq 6)
            $isPikachu   = ($id -eq 25)

            if ($isCharizard) {
            $sArt = @(
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠖⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡤⢤⡀⠀⠀⠀⠀⢸⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠳⡀⠈⠢⡀⠀⠀⢀⠀⠈⡄⠀⠀⠀⠀⠀⠀⠀⠀⡔⠦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠊⡹⠀⠀⠘⢄⠀⠈⠲⢖⠈⠀⠀⠱⡀⠀⠀⠀⠀⠀⠀⠀⠙⣄⠈⠢⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠖⠁⢠⠞⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠉⠑⠢⢄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⡠⠚⠁⠀⠀⠀⡇⠀⠀⠀⠀⠀⢀⠇⠀⡤⡀⠀⠀⠀⢀⣼⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⢠⣾⣿⣷⣶⣤⣄⣉⠑⣄⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⢀⠞⢁⣴⣾⣿⣿⡆⢇⠀⠀⠀⠀⠀⠸⡀⠀⠂⠿⢦⡰⠀⠀⠋⡄⠀⠀⠀⠀⠀⠀⠀⢰⠁⣿⣿⣿⣿⣿⣿⣿⣿⣷⣌⢆⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⡴⢁⣴⣿⣿⣿⣿⣿⣿⡘⡄⠀⠀⠀⠀⠀⠱⣔⠤⡀⠀⠀⠀⠀⠀⠈⡆⠀⠀⠀⠀⠀⠀⡜⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⢣⠀⠀⠀⠀⠀",
                "⠀⠀⠀⡼⢠⣾⣿⣿⣿⣿⣿⣿⣿⣧⡘⢆⠀⠀⠀⠀⠀⢃⠑⢌⣦⠀⠩⠉⠀⡜⠀⠀⠀⠀⠀⠀⢠⠃⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣣⡀⠀⠀⠀",
                "⠀⠀⢰⢃⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠱⡀⠀⠀⠀⢸⠀⠀⠓⠭⡭⠙⠋⠀⠀⠀⠀⠀⠀⠀⡜⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡱⡄⠀⠀",
                "⠀⠀⡏⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⢃⠀⠀⠀⢸⠀⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠀⢀⠜⢁⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠘⣆⠀",
                "⠀⢸⢱⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡘⣆⠀⠀⡆⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⡠⠖⣡⣾⠁⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢸⠀",
                "⠀⡏⣾⣿⣿⣿⣿⡿⡛⢟⢿⣿⣿⣿⣿⣿⣿⣧⡈⢦⣠⠃⠀⠀⠀⠀⠀⢱⣀⠤⠒⢉⣾⡉⠻⠋⠈⢘⢿⣿⣿⣿⣿⠿⣿⣿⠏⠉⠻⢿⣿⣿⣿⣿⡘⡆",
                "⢰⡇⣿⣿⠟⠁⢸⣠⠂⡄⣃⠜⣿⣿⠿⠿⣿⣿⡿⠦⡎⠀⠀⠀⠀⠀⠒⠉⠉⠑⣴⣿⣿⣎⠁⠠⠂⠮⢔⣿⡿⠉⠁⠀⠹⡛⢀⣀⡠⠀⠙⢿⣿⣿⡇⡇",
                "⠘⡇⠏⠀⠀⠀⡾⠤⡀⠑⠒⠈⠣⣀⣀⡀⠤⠋⢀⡜⣀⣠⣤⣀⠀⠀⠀⠀⠀⠀⠙⢿⡟⠉⡃⠈⢀⠴⣿⣿⣀⡀⠀⠀⠀⠈⡈⠊⠀⠀⠀⠀⠙⢿⡇⡇",
                "⠀⠿⠀⠀⠀⠀⠈⠀⠉⠙⠓⢤⣀⠀⠁⣀⡠⢔⡿⠊⠀⠀⠀⠀⠙⢦⡀⠀⠐⠢⢄⡀⠁⡲⠃⠀⡜⠀⠹⠟⠻⣿⣰⡐⣄⠎⠀⠀⠀⠀⠀⠀⠀⠀⢣⡇",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠁⠀⡜⠀⠀⠀⠀⠀⠀⠀⠀⠱⡀⠀⠀⠀⠙⢦⣀⢀⡴⠁⠀⠀⠀⠀⠉⠁⢱⠈⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⠀⠀⠀⠀⠈⢏⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠈⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠱⡄⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡜⠀⢹⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠘⣆⠀⠀⠀⠀⠀⠀⣰⠃⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡾⠀⠀⠘⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠁⠀⠀⠀⠀⠀⠀⠸⡄⠀⠀⠀⢀⡴⠁⠀⠀⢀⠇⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢧⠀⠀⠀⠘⢆⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⣧⣠⠤⠖⠋⠀⠀⠀⠀⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⡀⠀⠀⠀⠳⢄⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⡏⠀⠀⠀⠀⠀⠀⢀⡴⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡠⠊⠈⠁⠀⠀⠀⡔⠛⠲⣤⣀⣀⣀⠀⠈⢣⡀⠀⠀⠀⠀⠀⢸⠁⠀⠀⠀⢀⡠⢔⠝⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢈⠤⠒⣀⠀⠀⠀⠀⣀⠟⠀⠀⠀⠑⠢⢄⡀⠀⠀⠈⡗⠂⠀⠀⠀⠙⢦⠤⠒⢊⡡⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠆⠒⣒⡁⠬⠦⠒⠉⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠒⢺⢠⠤⡀⢀⠤⡀⠠⠷⡊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠣⡀⡱⠧⡀⢰⠓⠤⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⠈⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            )
            } elseif ($isPikachu) {
            $sArt = @(
                "⢦⣄⡀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠛⣿⣿⣿⠷⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⡄⠀⠀⠀⠀",
                "⠀⠘⣿⣿⡀⠀⠈⠛⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡤⠞⠛⢹⣿⣿⡟⠁⠀⠀⠀⠀",
                "⠀⠀⠈⠻⣷⠀⠀⠀⠀⠙⢧⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠚⠁⠀⠀⢀⣿⢛⠋⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠙⢧⡀⠀⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⠋⠀⠀⠀⠀⠀⣼⠇⠀⠀⠀⠀⠀⠀⠀⣀",
                "⠀⠀⠀⠀⠀⠀⠙⢦⣀⠀⠀⠀⠀⠳⣄⣠⠴⠖⠛⠉⠉⠉⠉⠓⠲⢦⣤⡶⠀⠀⠀⠀⠀⣴⠃⠀⠀⠀⣀⣀⡤⠶⠒⠋⠁⢸",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⢤⣀⣠⠆⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⣀⣀⡤⣾⠟⣁⡠⠖⠛⠉⠀⠀⠀⠀⠀⠀⣿",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢯⡴⠚⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡏",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⣀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠁",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⣾⣿⠉⣿⠄⠀⠀⠀⠀⠀⠀⠀⣿⡉⣿⣷⡄⢘⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡟⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠃⠀⠿⣿⡿⠟⠀⠀⠀⢠⡤⠀⠀⠀⠻⣿⣿⠟⠀⠀⣿⠀⠀⠀⠀⢀⣀⣤⡤⠶⠒⠛⠉⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣶⣶⣄⡀⠀⠀⣀⠀⠀⣀⣄⡀⠀⠀⠀⠁⠀⢀⣴⣶⣿⠄⠀⠸⣟⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣟⣾⣿⣷⠀⠀⠈⠙⠋⠉⠈⠉⠛⠁⠀⠀⢰⣿⡿⣽⣿⠃⠀⠀⠘⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⠿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣽⣷⠟⢦⣄⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡟⠳⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠞⣇⣀⡤⠛⠀⢀⣠⣴⠾⠃⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠃⠀⠀⠉⠳⢶⣤⣄⣀⣀⣀⣀⣤⡶⠛⠉⠀⠀⢸⡇⢀⣴⠞⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠃⠀⠀⠀⠀⠀⠀⢤⡀⠉⠉⠁⢠⡟⠀⠀⠀⠀⠀⠈⢿⣿⣿⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠁⠀⠀⠀⠀⠀⠀⠀⠈⣇⠀⠀⢀⡿⠀⠀⠀⠀⠀⠀⠀⠀⢿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⢀⡞⠀⢀⡄⠀⠀⠀⠀⠀⠀⠀⢿⠀⠀⢸⠃⠀⠀⠀⠀⠀⠀⣰⠀⠈⢳⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⢰⣷⣿⠿⣧⠀⠈⣷⠀⠀⠀⠀⠀⠀⠀⢸⡀⠀⣾⠀⠀⠀⠀⠀⠀⢠⡏⠀⠀⢸⣧⣤⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠻⣿⢦⡀⠁⠀⠘⣦⠀⠀⠀⠀⠀⠀⢸⡇⠀⣿⠀⠀⠀⠀⠀⢠⡟⠀⠀⠴⢛⣩⣾⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠘⢷⣄⠱⠀⠀⣼⣧⡀⠀⠀⠀⠀⢸⣃⠀⣿⠀⠀⠀⠀⢠⡿⠀⠀⠀⣚⣩⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠙⢶⣅⣤⣿⣬⣿⣄⣀⣀⣠⡾⠛⠛⢿⣀⣀⣀⣰⣏⣠⣄⣠⣰⠾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⠀⠀⠈⠉⠉⠀⠀⠀⠀⠀⠈⠉⠉⠁⠀⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            )
            } else {
            $sArt = @(
                "⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣶⣶⣿⣿⣿⣿⣿⣶⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀",
                "⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠙⣿⣿⣿⣿⣿⣆⠀⠀",
                "⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⢿⣧⡀⠀⢠⣿⠟⠛⠛⠿⣿⡆⠀",
                "⠀⢰⣿⣿⣿⣿⣿⣿⠿⠟⠋⠉⠁⠀⠀⠀⠀⠀⠙⠿⠿⠟⠋⠀⠀⠀⣠⣿⠇⠀",
                "⠀⢸⣿⣿⡿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣾⠟⠋⠀⠀",
                "⠀⢸⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣴⣾⠿⠛⠉⠀⠀⠀⠀⠀",
                "⠀⠈⢿⣷⣤⣤⣄⣠⣤⣤⣤⣤⣶⣶⣾⠿⠿⠛⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⠀⠀⠀⠀",
                "⠀⢸⣿⡛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀",
                "⠀⠀⢻⣧⠀⠈⠙⠛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀",
                "⠀⠀⠈⢿⣧⠀⠀⠀⠀⠀⠀⠉⠙⠛⠻⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀",
                "⠀⠀⠀⠀⠻⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⠟⠀⣠⣾⠟⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠈⠻⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⢀⣤⣾⠟⠁⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⠿⣶⣦⣤⣤⣤⣤⣤⣤⣶⡿⠟⠋⠁⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            )
            }

            $statsLines = @(
                "  ${yellow}${bold}$name${reset}",
                "",
                "  ${overlay}Type   ${reset}  ${green}$types${reset}",
                "  ${overlay}Height ${reset}  ${peach}$height${reset}",
                "  ${overlay}Weight ${reset}  ${peach}$weight${reset}",
                "",
                "  ${overlay}HP     ${reset}  ${red}$hp${reset}",
                "  ${overlay}ATK    ${reset}  ${peach}$atk${reset}",
                "  ${overlay}DEF    ${reset}  ${green}$def${reset}",
                "  ${overlay}SPD    ${reset}  ${mauve}$speed${reset}"
            )

            $artCol    = 26
            $totalRows = [Math]::Max($statsLines.Count, $sArt.Count) + 1

            for ($r = 0; $r -lt $totalRows; $r++) { Write-Host "" }
            $baseRow = [Console]::CursorTop - $totalRows

            for ($r = 0; $r -lt $statsLines.Count; $r++) {
                [Console]::SetCursorPosition(0, $baseRow + $r)
                [Console]::Write($statsLines[$r])
            }

            for ($r = 0; $r -lt $sArt.Count; $r++) {
                [Console]::SetCursorPosition($artCol, $baseRow + $r)
                [Console]::Write("${sColor}$($sArt[$r])${reset}")
                Start-Sleep -Milliseconds 16
            }

            [Console]::SetCursorPosition(0, $baseRow + $totalRows)
            Write-Host ""
        }
    } catch {
        $errMsg = $_.Exception.Message + " " + $_.Exception.InnerException.Message + " " + $_.Exception.GetType().Name
        $isNetwork = $errMsg -match "connect|network|timeout|resolve|unreachable|WebException|HttpRequest|SocketException|RemoteServer|ServerError|NameResolution"

        if ($isNetwork -or [string]::IsNullOrWhiteSpace($_.Exception.Message)) {
            Write-Host ""
            [Console]::WriteLine("  ${pink}${bold}◆ POKÉFETCH${reset}  ${overlay}signal lost${reset}")
            [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
            Write-Host ""

            # Glitch intro
            $glitchChars = "!?#@%*<>=~".ToCharArray()
            for ($g = 0; $g -lt 6; $g++) {
                $noise = -join ("MEW SIGNAL".ToCharArray() | ForEach-Object {
                    if ((Get-Random -Minimum 0 -Maximum 3) -eq 0) { $glitchChars | Get-Random } else { $_ }
                })
                [Console]::Write("`r  ${overlay}$noise${reset}")
                Start-Sleep -Milliseconds 70
            }
            [Console]::Write("`r  ${pink}${bold}MEW SIGNAL${reset}          ")
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 300
            Write-Host ""

            # ASCII banner MEW — same box-drawing style as Mewtwo
            $mewBanner = @(
                "${pink}${bold}  ╔╦╗╔═╗╦ ╦${reset}",
                "${mauve}  ║║║║╣ ║║║${reset}",
                "${teal}  ╩ ╩╚═╝╚╩╝${reset}"
            )
            foreach ($line in $mewBanner) {
                [Console]::WriteLine($line)
                Start-Sleep -Milliseconds 100
            }
            Write-Host ""

            # Scan bar pink → mauve → teal
            $scanW = 44
            [Console]::Write("  ")
            for ($i = 0; $i -lt $scanW; $i++) {
                $sc = if ($i -lt $scanW * 0.4) { $pink } elseif ($i -lt $scanW * 0.7) { $mauve } else { $teal }
                [Console]::Write("${sc}▓${reset}")
                Start-Sleep -Milliseconds 15
            }
            [Console]::WriteLine()
            Start-Sleep -Milliseconds 400
            Write-Host ""

            $mewArt = @(
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣶⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⠿⠋⢀⣀⣀⣀⣀⣤⣤⣶⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⠟⢋⣉⣁⣉⣥⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⣠⣾⣿⣿⠿⠛⠉⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠻⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⣴⡿⠟⠉⠀⠀⠀⠀⠀⠀⣽⣿⡿⠻⢿⣿⣿⣿⣿⣿⣿⣿⠀⢀⣤⠈⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⢀⣾⠏⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⠀⠀⣀⠙⣿⣿⣿⣿⣿⣿⠀⠸⣿⣷⣿⣿⠟⠀⠀⠀⠀⠀⠀⣀⣀⣀⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣀⡀⠀⠀",
                "⠀⢠⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⡀⢸⣿⣧⣿⣿⣿⣿⣿⣿⣦⣴⣿⣿⠟⠉⣀⣤⣤⣶⠶⠿⠛⠛⠛⠉⠉⠉⠁⠀⠀⠀⠀⠀⠉⠉⠛⠿⣷⡄",
                "⢠⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣠⣶⣤⣭⣭⣤⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽⡇",
                "⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣉⠙⠿⣿⣿⣿⣿⡿⠟⢡⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠟⠀",
                "⠘⢿⣧⣀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣴⡾⠟⠋⠁⣀⣤⣤⣤⣤⣴⣶⣿⣿⣿⣿⣷⣦⡀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠟⠁⠀⠀",
                "⠀⠀⠉⠛⠿⠷⣶⣶⣶⣶⡶⠿⠟⠛⠉⠁⠀⠀⢠⣾⣿⡿⠟⠛⠉⢻⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⠟⠁⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⣠⣴⡿⠋⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⢀⣤⣶⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⢹⣿⣿⣿⣿⣿⣿⣷⠘⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⡆⢻⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣟⢿⣿⣿⣿⣿⣿⣷⡄⠹⢿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠙⠿⣦⡙⢿⣿⣿⣿⣿⣿⣦⡄⠙⠛⢿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣶⣤⣄⠀⠈⠙⠛⠛⠛⠉⠀⠀⠀⠈⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⡿⣿⣯⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠙⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣻⣿⣿⣹⡿⠀⠀⠀⠀⠀⠀⠀⠀",
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠃⠻⠿⠃⠁⠀⠀⠀⠀⠀⠀⠀⠀"
            )

            $artColors = @($pink, $mauve, $teal, $sapphire, $pink, $mauve, $teal)
            $artCol    = 58

            $fallbackLines = @(
                @{ t="...";                                c=$overlay; d=120 },
                @{ t="";                                   c="";       d=0   },
                @{ t="I am not reachable today.";          c=$pink;    d=22  },
                @{ t="";                                   c="";       d=0   },
                @{ t="Even I need the right conditions";   c=$mauve;   d=18  },
                @{ t="to appear.";                         c=$mauve;   d=22  },
                @{ t="";                                   c="";       d=0   },
                @{ t="Try again when the signal returns."; c=$teal;    d=18  },
                @{ t="And Only then will you be able to reach your goal"; c=$teal; d=45},
                @{ t="";                                   c="";       d=0   },
                @{ t="of being a Pokémon master";           c="$mauve"; d=60  }

            )

            $totalRows = [Math]::Max($mewArt.Count, $fallbackLines.Count + 4) + 2

            for ($r = 0; $r -lt $totalRows; $r++) { Write-Host "" }
            $baseRow = [Console]::CursorTop - $totalRows

            # Art on the right
            for ($r = 0; $r -lt $mewArt.Count; $r++) {
                $ac = $artColors[$r % $artColors.Count]
                [Console]::SetCursorPosition($artCol, $baseRow + $r)
                [Console]::Write($ac + $mewArt[$r] + $reset)
                Start-Sleep -Milliseconds 16
            }

            # Text on the left
            $speechRow = $baseRow + 4
            foreach ($entry in $fallbackLines) {
                if ($entry.t -ne "") {
                    [Console]::SetCursorPosition(0, $speechRow)
                    [Console]::Write("    " + $entry.c)
                    foreach ($ch in $entry.t.ToCharArray()) {
                        [Console]::Write($ch)
                        Start-Sleep -Milliseconds $entry.d
                    }
                    [Console]::Write($reset)
                }
                $speechRow++
            }

            [Console]::SetCursorPosition(0, $baseRow + $totalRows)
            Write-Host ""
            [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
            [Console]::WriteLine("  ${overlay}— ${reset}${pink}${bold}Mew${reset}${overlay},  signal lost${reset}")
            Write-Host ""

        } else {
            Write-Host ""
            [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
            [Console]::WriteLine("  ${red}✦  ${reset}${overlay}No Pokémon answers to${reset} ${peach}${bold}'$query'${reset}${overlay}.${reset}")
            [Console]::WriteLine("  ${overlay}    Check the name or ID and try again.${reset}")
            [Console]::WriteLine("  ${overlay}$("─" * 44)${reset}")
            Write-Host ""
        }
    }
}
