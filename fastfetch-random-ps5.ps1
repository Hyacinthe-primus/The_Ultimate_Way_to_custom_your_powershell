$asciiFolder = "$env:USERPROFILE\.config\fastfetch"
$baseConfig  = "$env:USERPROFILE\.config\fastfetch\config.jsonc"

$palettes = @(
    @{ "1"="#F5E0DC"; "2"="#F2CDCD"; "3"="#F5C2E7"; "4"="#FAB387"; "5"="#F9E2AF"; "6"="#A6E3A1"; "7"="#94E2D5"; "8"="#89DCEB"; "9"="#74C7EC" },
    @{ "1"="#DD7878"; "2"="#EA76CB"; "3"="#8839EF"; "4"="#E64553"; "5"="#FE640B"; "6"="#DF8E1D"; "7"="#40A02B"; "8"="#179299"; "9"="#1E66F5" },
    @{ "1"="#FF79C6"; "2"="#BD93F9"; "3"="#6272A4"; "4"="#FF5555"; "5"="#FFB86C"; "6"="#F1FA8C"; "7"="#50FA7B"; "8"="#8BE9FD"; "9"="#FF79C6" },
    @{ "1"="#BF616A"; "2"="#D08770"; "3"="#EBCB8B"; "4"="#A3BE8C"; "5"="#B48EAD"; "6"="#88C0D0"; "7"="#81A1C1"; "8"="#5E81AC"; "9"="#8FBCBB" },
    @{ "1"="#F7768E"; "2"="#FF9E64"; "3"="#E0AF68"; "4"="#9ECE6A"; "5"="#73DACA"; "6"="#2AC3DE"; "7"="#7DCFFF"; "8"="#BB9AF7"; "9"="#C0CAF5" },
    @{ "1"="#CC241D"; "2"="#98971A"; "3"="#D79921"; "4"="#458588"; "5"="#B16286"; "6"="#689D6A"; "7"="#D65D0E"; "8"="#FB4934"; "9"="#FABD2F" },
    @{ "1"="#E67E80"; "2"="#E69875"; "3"="#DBBC7F"; "4"="#A7C080"; "5"="#83C092"; "6"="#7FBBB3"; "7"="#D699B6"; "8"="#859289"; "9"="#9DA9A0" },
    @{ "1"="#EB6F92"; "2"="#F6C177"; "3"="#EBBCBA"; "4"="#31748F"; "5"="#9CCFD8"; "6"="#C4A7E7"; "7"="#E0DEF4"; "8"="#6E6A86"; "9"="#908CAA" }
)

$asciiFiles = Get-ChildItem -Path $asciiFolder -Filter "*.txt" -File
if ($asciiFiles.Count -eq 0) {
    Write-Warning "No .txt files found in $asciiFolder"
    fastfetch --config $baseConfig
    return
}
$randomAscii   = ($asciiFiles | Get-Random).FullName -replace "\\", "/"
$randomPalette = $palettes | Get-Random

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$rawBytes  = [System.IO.File]::ReadAllBytes($baseConfig)

if ($rawBytes.Length -ge 3 -and $rawBytes[0] -eq 0xEF -and $rawBytes[1] -eq 0xBB -and $rawBytes[2] -eq 0xBF) {
    $rawBytes = $rawBytes[3..($rawBytes.Length - 1)]
}

$configContent = $utf8NoBom.GetString($rawBytes)

$colorBlock = "{`n  `"1`": `"$($randomPalette['1'])`",`n  `"2`": `"$($randomPalette['2'])`",`n  `"3`": `"$($randomPalette['3'])`",`n  `"4`": `"$($randomPalette['4'])`",`n  `"5`": `"$($randomPalette['5'])`",`n  `"6`": `"$($randomPalette['6'])`",`n  `"7`": `"$($randomPalette['7'])`",`n  `"8`": `"$($randomPalette['8'])`",`n  `"9`": `"$($randomPalette['9'])`"`n}"

$configContent = $configContent -replace '"source"\s*:\s*"[^"]*"', ('"source": "' + $randomAscii + '"')
$configContent = $configContent -replace '"color"\s*:\s*\{[^}]*\}', ('"color": ' + $colorBlock)

$tmpConfig = "$env:TEMP\fastfetch-tmp.json"
[System.IO.File]::WriteAllBytes($tmpConfig, $utf8NoBom.GetBytes($configContent))
fastfetch --config $tmpConfig
