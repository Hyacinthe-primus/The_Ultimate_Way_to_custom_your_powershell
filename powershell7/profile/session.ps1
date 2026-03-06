# ─────────────────────────────────────────
#  Session memory + welcome sequence
# ─────────────────────────────────────────
# Session memory — stored in ~/.config/ps-profile/session.json
 $sessionDir  = "$env:USERPROFILE\.config\ps-profile"
 $sessionFile = "$sessionDir\session.json"
 $now         = Get-Date
 $today       = $now.ToString("yyyy-MM-dd")
 $sessionData = $null
 if (Test-Path $sessionFile) {
     try { $sessionData = Get-Content $sessionFile -Raw | ConvertFrom-Json } catch {}
 }
 if ($null -eq $sessionData) {
     $sessionData = [PSCustomObject]@{ lastSeen = ""; sessionCount = 0; todayCount = 0 }
 }
 $isFirstToday = ($sessionData.lastSeen -ne $today)
 if ($isFirstToday) { $sessionData.todayCount = 1 }
 else { $sessionData.todayCount = [int]$sessionData.todayCount + 1 }
 $sessionData.sessionCount = [int]$sessionData.sessionCount + 1
 $sessionData.lastSeen = $today
 if (-not (Test-Path $sessionDir)) { New-Item -ItemType Directory -Path $sessionDir -Force | Out-Null }
 $sessionData | ConvertTo-Json | Set-Content $sessionFile -Encoding UTF8

 $culture = [System.Globalization.CultureInfo]::GetCultureInfo("en-US")
 $date = (Get-Date).ToString("dddd, MMMM dd yyyy", $culture)
 $time = Get-Date -Format "HH:mm"
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
    "Don't comment bad code—rewrite it."
    "Always war in this world no matter the era"
    "Only the best of us can see the code behind the code."
    "Only stong enough people can talk about peace or justice"
    "As long as there is love, there will also be hate"
    "People only see the decisions you made, not the choice you had"
    "There is nothing in my heart"
)
 $quote = $quotes | Get-Random
Write-Host "  $pink✦$reset  $peach$quote$reset"
Write-Host ""

# Message selon la session
$hour = $now.Hour
if ($isFirstToday) {
    # ── Première session du jour → animation complète ─────────
    Type-Fast "IDENTITY VERIFICATION IN PROGRESS..." $overlay
    Start-Sleep -Milliseconds 100

    $scanWidth = 44
    [Console]::Write("  ")
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

    $hLines = @(
        "${mauve}${bold}  ██╗   ██╗███████╗███████╗██████╗ ███╗   ██╗ █████╗ ███╗   ███╗███████╗${reset}",
        "${pink}  ██║   ██║██╔════╝██╔════╝██╔══██╗████╗  ██║██╔══██╗████╗ ████║██╔════╝${reset}",
        "${peach}  ██║   ██║███████╗█████╗  ██████╔╝██╔██╗ ██║███████║██╔████╔██║█████╗  ${reset}",
        "${yellow}  ██║   ██║╚════██║██╔══╝  ██╔══██╗██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝  ${reset}",
        "${green}  ╚██████╔╝███████║███████╗██║  ██║██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗${reset}",
        "${teal}   ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝${reset}"
    )
    foreach ($line in $hLines) {
        [Console]::WriteLine($line)
        Start-Sleep -Milliseconds 60
    }
    Start-Sleep -Milliseconds 300
    Write-Host ""

    if ($hour -ge 0 -and $hour -lt 5) {
        # Nuit tardive
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
    } else {
        # Journée normale
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
    }

    Write-Host ""
    [Console]::WriteLine("  ${overlay}$("─" * 66)${reset}")
    Start-Sleep -Milliseconds 400
    Write-Host ""

} else {
    # ── Sessions suivantes → ligne statique sous les quotes ───
    if ($hour -ge 0 -and $hour -lt 5) {
        Write-Host "  ${overlay}still here at ${reset}${mauve}$time${reset}${overlay}. the terminal never sleeps.${reset}"
        Write-Host "  ${overlay}But you try to sleep even if your mind is feeling heavy.${reset}"
    } else {
        Write-Host "  ${overlay}back already, master.${reset}"
        Write-Host "  ${overlay}I hope you will find the answer you've been searching for so long.${reset}"
    }
    Write-Host ""
}
