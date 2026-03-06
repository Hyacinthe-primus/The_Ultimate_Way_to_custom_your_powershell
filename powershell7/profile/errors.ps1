# ─────────────────────────────────────────
#  CommandNotFound handler — Tobi / Madara
# ─────────────────────────────────────────
# ─────────────────────────────────────────
#  Wrong Command Handler — Tobi / Madara
# ─────────────────────────────────────────
$script:TobiRunning = $false

$ExecutionContext.InvokeCommand.CommandNotFoundAction = {
    param($commandName, $commandLookupEventArgs)

    $commandLookupEventArgs.StopSearch = $true

    if ($commandName -like 'get-*' -or $commandName -like '.\*' -or $commandName -like './*') { return }

    if ($script:TobiRunning) { return }
    $script:TobiRunning = $true

    $ESC    = [char]27
    $mauve  = "$ESC[38;2;203;166;247m"
    $peach  = "$ESC[38;2;250;179;135m"
    $red    = "$ESC[38;2;243;139;168m"
    $white  = "$ESC[38;2;205;214;244m"
    $grey   = "$ESC[38;2;108;112;134m"
    $bold   = "$ESC[1m"
    $reset  = "$ESC[0m"

    $cmd = $commandName

    # Check if a local file with that name exists
    $localExists = (Test-Path ".\$cmd.ps1") -or (Test-Path ".\$cmd.exe") -or (Test-Path ".\$cmd.bat") -or (Test-Path ".\$cmd")

    if ($localExists) {
        $speechTobi = @(
            @{ t="";                                                    c="";     d=0  },
            @{ t="";                                                    c="";     d=0  },
            @{ t="";                                                    c="";     d=0  },
            @{ t="";                                                    c="";     d=0  },
            @{ t="Hmm, it is just as I expected it.";                   c=$white; d=40 },
            @{ t="You are probably meaning '.\$cmd'...";                c=$white; d=40 },
            @{ t="";                                                    c="";     d=0  },
            @{ t="That mistake of yours could cost you";                c=$mauve; d=30 },
            @{ t="more in the future.";                                 c=$mauve; d=30 },
            @{ t="";                                                    c="";     d=0  },
            @{ t="I have seen too much to not advise you.";             c=$peach; d=30 },
            @{ t="";                                                    c="";     d=0  },
            @{ t="No need to guess who I am,";                         c=$grey;  d=22 },
            @{ t="because I am Nobody....";                             c=$grey;  d=16 }
        )
    } else {
        $speechTobi = @(
            @{ t="";                                                    c="";     d=0  },
            @{ t="";                                                    c="";     d=0  },
            @{ t="";                                                    c="";     d=0  },
            @{ t="";                                                    c="";     d=0  },
            @{ t="What was that command of yours?";                     c=$white; d=40 },
            @{ t="'$cmd' ???";                                          c=$white; d=40 },
            @{ t="";                                                    c="";     d=0  },
            @{ t="Is that what you really meant to type?";              c=$mauve; d=30 },
            @{ t="You are currently wondering who am I?";               c=$mauve; d=30 },
            @{ t="";                                                    c="";     d=0  },
            @{ t="Well then I will tell you...";                        c=$peach; d=30 },
            @{ t="Tobi or Madara...";                                   c=$peach; d=30 },
            @{ t="";                                                    c="";     d=0  },
            @{ t="call me whatever you want.";                          c=$grey;  d=22 },
            @{ t="But that command does not exist in my reality.";      c=$grey;  d=16 }
        )
    }

    $tobiArt = @(
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⢰⣄⡀⣀⣤⠆⠀⣀⣠⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⢠⣀⣙⣿⠶⣶⣿⣿⠿⠿⣿⣿⣿⣥⣤⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⣹⣿⣿⠿⠋⢁⣀⣀⣀⠀⠉⠿⣿⣿⡶⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠒⢻⢿⡿⠋⡴⠊⠀⠀⠀⠀⠈⠑⠄⠈⢿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠴⢿⣿⠃⠈⢠⠔⠉⠀⠀⠑⠢⣄⠈⢦⠈⢿⡍⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⣼⢿⠘⠀⡃⠔⠉⠉⠉⠢⡀⠈⢧⠀⢧⠘⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠈⠁⢸⡀⣿⣿⣾⣷⣎⠑⡄⠈⣆⠘⣇⠘⣇⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⡌⠻⠿⢫⣿⡇⠸⡀⢸⠀⢹⠀⢻⣼⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠱⡉⠓⠚⠋⣰⠇⢠⠃⢸⡇⢸⡄⡏⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣦⠤⠶⠋⣠⡾⠀⣸⠀⣸⢄⡇⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢘⣖⡶⠜⠛⠳⠊⠋⠉⠛⢛⡇⠀⠀⢿⡩⠲⣶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠀⢀⣤⡖⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢼⣇⠀⠀⢹⣯⣾⡿⢛⣽⣿⣿⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⣀⣴⠾⠋⠘⣿⡊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣟  ⣼⣿⣟⣶⣿⡻⣫⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⢫⢀⢀⠔⠀⢹⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠨⣿⣿  ⠀⢨⠋⠻⢯⣾⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⢧⠁⠀⡠⠊⢿⣧⠈⠀⠀⠀⠀⠀⠀⢠⣾⣿⠟⠁⢀⢆⠎⠀⠀⡴⠛⠺⣧⣤⣤⣤⡄⣀⠀⠀⠀⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠈⢶⠋⠄⠀⠈⢿⣇⠀⢀⣤⣤⣠⡤⣪⣿⡪⣦⣞⡏⣜⠀⢀⡸⠁⠀⡀⡈⡟⢩⣯⢋⣽⣟⣶⡄⠀⠀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⠀⠈⢦⠀⠌⢠⣼⣿⣶⣿⣿⣿⣿⣾⣿⡿⠀⠘⣸⢄⣪⣌⠀⣇⢠⠲⣳⢠⣿⣿⠋⡰⠚⡿⠋⣮⣦⡀⠀⠀⠀",
        "⠀⠀⠀⠀⠀⢀⡤⠜⠧⣀⢈⣽⣿⣿⣿⣯⣿⣿⣿⣿⣇⢀⠴⠇⡄⠐⡄⠉⡝⠓⠊⠁⢸⣿⣷⣿⣿⠏⢀⣺⣫⣿⣧⠀⠀⠀",
        "⠀⠀⠀⢠⡶⠋⠀⠀⠠⣽⢿⣾⣿⣿⣿⣿⣿⣿⣿⣟⣽⣆⠀⢸⠇⢃⢱⢰⠁⠀⠀⠀⢸⣿⣿⣟⣡⣴⡵⣻⣽⣿⣿⡆⠀⠀",
        "⠀⠀⣰⠉⡀⠀⠀⠀⠀⣠⣾⣿⢿⣿⣿⣿⣿⣿⡿⢛⣿⣿⣦⡀⠀⠘⣼⣿⠁⠀⠀⠀⣸⠄⢻⣿⣿⣿⣯⣿⣿⣿⣿⡇⠀⠀",
        "⠀⢰⣯⣦⣤⣠⠖⣡⣾⣿⣿⣿⣿⣿⣿⣿⣿⣯⣶⠟⣱⣿⣿⣿⣶⣄⣀⣙⣄⣀⡠⠚⠁⠀⢀⠿⣷⣿⣿⣾⣿⣿⣿⣿⡄⠀",
        "⠀⣮⣿⣻⣿⣥⣾⣿⢟⢟⣿⣿⣿⣟⣽⢿⡟⡁⠁⠀⡾⢟⣽⣿⣯⣶⡄⠀⣀⠀⠀⠀⠀⢀⠎⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⡄",
        "⢰⣻⣾⣿⣿⢟⣿⢕⣵⣿⣿⣿⣿⣿⡷⠊⠀⠀⠀⢋⢠⣪⣾⣿⣿⣽⣿⣤⣀⣰⣦⠤⠤⠋⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⠟⠁"
    )

    try {
        Write-Host ""

        $artCol         = 48
        $leftPad        = "    "
        $speechHeight   = $speechTobi.Count
        $artHeight      = $tobiArt.Count
        $totalHeight    = [Math]::Max($speechHeight, $artHeight) + 4
        $artStartRow    = [Math]::Floor(($totalHeight - $artHeight) / 2)
        $speechStartRow = 3

        for ($r = 0; $r -lt $totalHeight; $r++) { Write-Host "" }
        $baseRow = [Console]::CursorTop - $totalHeight

        for ($r = 0; $r -lt $tobiArt.Count; $r++) {
            if ($r -lt 3) {
                $ac = $mauve
            } elseif ($r -lt 10) {
                $ac = $peach
            } else {
                $remColors = @($red, $white, $grey)
                $ac = $remColors[($r - 10) % $remColors.Count]
            }

            [Console]::SetCursorPosition($artCol, $baseRow + $artStartRow + $r)
            [Console]::Write($ac + $tobiArt[$r] + $reset)
            Start-Sleep -Milliseconds 18
        }

        $speechRow = $baseRow + $speechStartRow
        foreach ($entry in $speechTobi) {
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
                [Console]::Write($reset)
            }
            $speechRow++
        }

        [Console]::SetCursorPosition(0, $baseRow + $totalHeight)
        Write-Host ""
        [Console]::WriteLine("  $grey$("─" * 44)$reset")
        Start-Sleep -Milliseconds 200
        [Console]::WriteLine("  $grey— ${reset}${mauve}${bold}Tobi${reset}${grey} or ${reset}${red}${bold}Madara${reset}${grey},  Naruto Shippuden${reset}")
        Write-Host ""
    }
    catch { }
    finally {
        $script:TobiRunning = $false
    }
}
