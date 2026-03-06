# ─────────────────────────────────────────
#  Prompt — Catppuccin Mocha + Git branch
# ─────────────────────────────────────────
# ─────────────────────────────────────────
#  Prompt — Catppuccin Mocha + Git branch
#  Kali-style two-line prompt
# ─────────────────────────────────────────
function prompt {
    $ESC      = [char]27
    $mauve    = "$ESC[38;2;203;166;247m"  # #CBA6F7
    $teal     = "$ESC[38;2;148;226;213m"  # #94E2D5
    $lavender = "$ESC[38;2;180;190;254m"  # #B4BEFE
    $pink     = "$ESC[38;2;245;194;231m"  # #F5C2E7
    $peach    = "$ESC[38;2;250;179;135m"  # #FAB387
    $yellow   = "$ESC[38;2;249;226;175m"  # #F9E2AF
    $green    = "$ESC[38;2;166;227;161m"  # #A6E3A1
    $red      = "$ESC[38;2;243;139;168m"  # #F38BA8
    $overlay  = "$ESC[38;2;108;112;134m"  # #6C7086
    $reset    = "$ESC[0m"

    $mochaPalette = @(
        "$ESC[38;2;243;139;168m"  # Red      #F38BA8
        "$ESC[38;2;250;179;135m"  # Peach    #FAB387
        "$ESC[38;2;249;226;175m"  # Yellow   #F9E2AF
        "$ESC[38;2;166;227;161m"  # Green    #A6E3A1
        "$ESC[38;2;137;220;235m"  # Sky      #89DCEB
        "$ESC[38;2;116;199;236m"  # Sapphire #74C7EC
        "$ESC[38;2;137;180;250m"  # Blue     #89B4FA
        "$ESC[38;2;203;166;247m"  # Mauve    #CBA6F7
        "$ESC[38;2;245;194;231m"  # Pink     #F5C2E7
    )

    $username  = $env:USERNAME
    $hostname  = (Get-Culture).TextInfo.ToTitleCase($env:COMPUTERNAME.ToLower())

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

    # Git branch detection
    $gitBranch = ""
    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) {
            $gitStatus   = git status --porcelain 2>$null
            $branchColor = if ($gitStatus) { $yellow } else { $green }
            $gitBranch   = " ${overlay}on${reset} ${branchColor} $branch${reset}"
        }
    } catch {}

    # Admin detection
    $isAdmin     = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $symbol      = if ($isAdmin) { "#" } else { "$" }
    $symbolColor = if ($isAdmin) { $red } else { $peach }

    Write-Host "${green}┌─${reset}(${mauve}$username${reset}${pink}㉿${reset}${teal}$hostname${reset})${green}-${reset}[${path}${reset}]${gitBranch}"
    "${green}└─${reset}${symbolColor}${symbol} »${reset} "
}