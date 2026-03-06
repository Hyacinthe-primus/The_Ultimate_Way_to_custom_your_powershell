# ─────────────────────────────────────────
#  Helpers — Type-Slow, Type-Fast, Pulse-Line
# ─────────────────────────────────────────
# Animation helpers — used at startup and inside the welcome sequence

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseApprovedVerbs', '')]
param()

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
    $dimC = "$ESC[2m"
    $boldC = "$ESC[1m"
    $pColors = @($overlay, "$dimC$color", $color, "$boldC$color", $color, "$dimC$color", $overlay)
    foreach ($c in $pColors) {
        [Console]::Write("`r  $c$text$reset")
        Start-Sleep -Milliseconds 80
    }
    [Console]::WriteLine()
}
