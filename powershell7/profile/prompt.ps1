function prompt {
    $ESC      = [char]27
    $mauve    = "$ESC[38;2;203;166;247m"
    $teal     = "$ESC[38;2;148;226;213m"
    $lavender = "$ESC[38;2;180;190;254m"
    $pink     = "$ESC[38;2;245;194;231m"
    $peach    = "$ESC[38;2;250;179;135m"
    $yellow   = "$ESC[38;2;249;226;175m"
    $green    = "$ESC[38;2;166;227;161m"
    $red      = "$ESC[38;2;243;139;168m"
    $overlay  = "$ESC[38;2;108;112;134m"
    $reset    = "$ESC[0m"

    $mochaPalette = @(
        "$ESC[38;2;243;139;168m"
        "$ESC[38;2;250;179;135m"
        "$ESC[38;2;249;226;175m"
        "$ESC[38;2;166;227;161m"
        "$ESC[38;2;137;220;235m"
        "$ESC[38;2;116;199;236m"
        "$ESC[38;2;137;180;250m"
        "$ESC[38;2;203;166;247m"
        "$ESC[38;2;245;194;231m"
    )

    $username = $env:USERNAME
    $hostname = (Get-Culture).TextInfo.ToTitleCase($env:COMPUTERNAME.ToLower())

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

    $gitBranch = ""
    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) {
            $gitStatus   = git status --porcelain 2>$null
            $branchColor = if ($gitStatus) { $yellow } else { $green }
            $gitBranch   = " ${overlay}on${reset} ${branchColor} $branch${reset}"
        }
    } catch {}

    $isAdmin     = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $symbol      = if ($isAdmin) { "#" } else { "$" }
    $symbolColor = if ($isAdmin) { $red } else { $peach }

    Write-Host "${green}┌─${reset}(${mauve}$username${reset}${pink}㉿${reset}${teal}$hostname${reset})${green}-${reset}[${path}${reset}]${gitBranch}"
    "${green}└─${reset}${symbolColor}${symbol} »${reset} "
}
