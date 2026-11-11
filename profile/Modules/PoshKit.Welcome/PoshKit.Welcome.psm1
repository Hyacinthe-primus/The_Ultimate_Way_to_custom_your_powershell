$ESC = [char]27
$script:Theme = @{
    Reset   = "$ESC[0m"
    Bold    = "$ESC[1m"
    Green   = "$ESC[38;2;166;227;161m"  # #A6E3A1
    Yellow  = "$ESC[38;2;249;226;175m"  # #F9E2AF
    Mauve   = "$ESC[38;2;203;166;247m"  # #CBA6F7
    Pink    = "$ESC[38;2;245;194;231m"  # #F5C2E7
    Peach   = "$ESC[38;2;250;179;135m"  # #FAB387
    Overlay = "$ESC[38;2;108;112;134m"  # #6C7086
}
Remove-Variable ESC -ErrorAction SilentlyContinue

$script:Quotes = @(
    "Code is like humor. When you have to explain it, it's bad."
    'First, solve the problem. Then, write the code.'
    'Simplicity is the ultimate sophistication.'
    'Programs must be written for people to read, not machines to execute.'
    'The best code is no code at all.'
    'Debugging is twice as hard as writing the code in the first place.'
    "If it works, don't touch it."
    'There is no place for magic in production code.'
    'Perfection is achieved when there is nothing left to remove.'
    'A good developer looks both ways before crossing a one-way street.'
    'Every sentient being possesses the capacity for change.'
    'Be strong enough to be gentle, be gentle enough to be strong.'
)

function Show-Welcome {
    $t      = $script:Theme
    $diamond = [string][char]0x25C6
    $star    = [string][char]0x2726

    $culture = [System.Globalization.CultureInfo]::GetCultureInfo('en-US')
    $now     = Get-Date
    $date    = $now.ToString('dddd, MMMM dd yyyy', $culture)
    $time    = $now.ToString('HH:mm')
    $quote   = $script:Quotes | Get-Random

    Write-Host ''
    Write-Host "  $($t.Green)$diamond$($t.Reset)  $($t.Yellow)$date$($t.Reset)  $($t.Mauve)$time$($t.Reset)"
    Write-Host "  $($t.Pink)$star$($t.Reset)  $($t.Peach)$quote$($t.Reset)"
    Write-Host ''
}

Export-ModuleMember -Function Show-Welcome
