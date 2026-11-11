$ESC = [char]27
$script:Theme = @{
    Reset    = "$ESC[0m"
    Bold     = "$ESC[1m"
    Red      = "$ESC[38;2;243;139;168m"  # #F38BA8
    Peach    = "$ESC[38;2;250;179;135m"  # #FAB387
    Yellow   = "$ESC[38;2;249;226;175m"  # #F9E2AF
    Green    = "$ESC[38;2;166;227;161m"  # #A6E3A1
    Teal     = "$ESC[38;2;148;226;213m"  # #94E2D5
    Sky      = "$ESC[38;2;137;220;235m"  # #89DCEB
    Sapphire = "$ESC[38;2;116;199;236m"  # #74C7EC
    Blue     = "$ESC[38;2;137;180;250m"  # #89B4FA
    Lavender = "$ESC[38;2;180;190;254m"  # #B4BEFE
    Mauve    = "$ESC[38;2;203;166;247m"  # #CBA6F7
    Pink     = "$ESC[38;2;245;194;231m"  # #F5C2E7
    Overlay  = "$ESC[38;2;108;112;134m"  # #6C7086
}
Remove-Variable ESC -ErrorAction SilentlyContinue

$script:Glyph = @{
    Diamond    = [string][char]0x25C6
    Star       = [string][char]0x2726
    Rule       = [string][char]0x2500
    Cross      = [string][char]0x2716
    Up         = [string][char]0x2191
    Down       = [string][char]0x2193
    MiddleDot  = [string][char]0x00B7
    Degree     = [string][char]0x00B0
}

$script:Settings = @{
    WeatherCity = 'Casablanca'
}

function proc {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)][ValidateRange(1, 1000)][int]$Count = 10,
        [switch]$ram
    )

    $t = $script:Theme
    $g = $script:Glyph

    $label = if ($ram) { 'RAM' } else { 'CPU' }

    Write-Host ''
    Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) TOP $Count PROCESSES$($t.Reset)  $($t.Overlay)by $label$($t.Reset)"
    Write-Host "  $($t.Overlay)$($g.Rule * 60)$($t.Reset)"
    Write-Host ''

    $cores     = [Environment]::ProcessorCount
    $processes = @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.Id -ne 0 })
    $sample    = $processes | Select-Object -First 1
    $hasCpu    = ($sample -and $null -ne $sample.CPU)

    if ($hasCpu) {
        # .CPU is total processor seconds, so take two samples and compare.
        $before = @{}
        foreach ($p in $processes) {
            if ($null -ne $p.CPU) { $before[$p.Id] = [double]$p.CPU }
        }

        $started = Get-Date
        Start-Sleep -Milliseconds 700
        $after   = @(Get-Process -ErrorAction SilentlyContinue)
        $elapsed = ((Get-Date) - $started).TotalSeconds

        $rows = foreach ($p in $after) {
            if ($p.Id -eq 0) { continue }
            $pct = 0.0
            if ($null -ne $p.CPU -and $before.ContainsKey($p.Id) -and $elapsed -gt 0) {
                $pct = [math]::Max(0, ($p.CPU - $before[$p.Id]) / $elapsed / $cores * 100)
            }
            [pscustomobject]@{
                Name       = $p.ProcessName
                Pct        = $pct
                WorkingSet = $p.WorkingSet64
            }
        }
    }
    else {
        # Windows PowerShell 5.1 does not expose Process.CPU. Use the WMI
        # performance counters for the percentage and Get-Process for memory.
        $byId = @{}
        foreach ($p in $processes) { $byId[$p.Id] = $p }

        $perf = @(Get-CimInstance -ClassName Win32_PerfFormattedData_PerfProc_Process -ErrorAction SilentlyContinue)
        $rows = foreach ($item in $perf) {
            if ($item.Name -in @('_Total', 'Idle')) { continue }
            $p = $byId[[int]$item.IDProcess]
            if (-not $p) { continue }
            [pscustomobject]@{
                Name       = $p.ProcessName
                Pct        = [math]::Max(0, [double]$item.PercentProcessorTime / $cores)
                WorkingSet = $p.WorkingSet64
            }
        }
    }

    $sorted = if ($ram) { $rows | Sort-Object WorkingSet -Descending } else { $rows | Sort-Object Pct -Descending }

    foreach ($p in ($sorted | Select-Object -First $Count)) {
        $cpuStr = '{0,5:N1}' -f $p.Pct
        $ramMB  = [math]::Round($p.WorkingSet / 1MB, 1)
        $name   = $p.Name.PadRight(28).Substring(0, 28)

        $cpuColor = if ($p.Pct -gt 50) { $t.Red } elseif ($p.Pct -gt 20) { $t.Yellow } else { $t.Green }
        $ramColor = if ($ramMB -gt 500) { $t.Red } elseif ($ramMB -gt 100) { $t.Yellow } else { $t.Green }

        Write-Host "  $($t.Teal)$name$($t.Reset)  $($t.Overlay)cpu$($t.Reset) ${cpuColor}$($t.Bold)$cpuStr %$($t.Reset)  $($t.Overlay)mem$($t.Reset) ${ramColor}$($t.Bold)$ramMB MB$($t.Reset)"
    }
    Write-Host ''
}

function serve {
    [CmdletBinding()]
    param([Parameter(Position = 0)][ValidateRange(1, 65535)][int]$Port = 8080)

    $t = $script:Theme
    $g = $script:Glyph

    $root        = (Resolve-Path -LiteralPath $PWD.Path).Path
    $rootDisplay = $root.TrimEnd('\', '/')
    if ($rootDisplay.Length -eq 2 -and $rootDisplay[1] -eq ':') { $rootDisplay += '\' }

    $prefix   = "http://localhost:$Port/"
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($prefix)

    $mimeMap = @{
        '.html' = 'text/html; charset=utf-8'; '.htm' = 'text/html; charset=utf-8'
        '.css'  = 'text/css'; '.js' = 'text/javascript'; '.json' = 'application/json'
        '.png'  = 'image/png'; '.jpg' = 'image/jpeg'; '.jpeg' = 'image/jpeg'
        '.gif'  = 'image/gif'; '.webp' = 'image/webp'; '.svg' = 'image/svg+xml'
        '.ico'  = 'image/x-icon'; '.txt' = 'text/plain; charset=utf-8'
        '.pdf'  = 'application/pdf'; '.mp4' = 'video/mp4'; '.woff2' = 'font/woff2'
    }

    # Ctrl+C is read as a normal keystroke. A CancelKeyPress handler runs on a
    # native signal thread without a PowerShell runspace attached, which crashes
    # pwsh when the handler invokes any script block.
    $previousCtrlCMode = $null
    try {
        $previousCtrlCMode = [Console]::TreatControlCAsInput
        [Console]::TreatControlCAsInput = $true
    }
    catch {
        # Console is redirected; Ctrl+C polling cannot work.
    }

    Write-Host ''
    Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) HTTP SERVER$($t.Reset)"
    Write-Host "  $($t.Overlay)$($g.Rule * 52)$($t.Reset)"
    Write-Host ''
    Write-Host "  $($t.Overlay)Root   $($t.Reset)  $($t.Teal)$rootDisplay$($t.Reset)"
    Write-Host "  $($t.Overlay)URL    $($t.Reset)  $($t.Green)$($t.Bold)$prefix$($t.Reset)"
    Write-Host "  $($t.Overlay)Press Ctrl+C to stop.$($t.Reset)"
    Write-Host ''

    $stopping = $false
    try {
        $listener.Start()

        while ($listener.IsListening -and -not $stopping) {
            $contextTask = $listener.GetContextAsync()

            while (-not $contextTask.Wait(200)) {
                try {
                    while ([Console]::KeyAvailable) {
                        $key = [Console]::ReadKey($true)
                        if ($key.Key -eq [ConsoleKey]::C -and
                            ($key.Modifiers -band [ConsoleModifiers]::Control)) {
                            $stopping = $true
                        }
                    }
                }
                catch {}
                if ($stopping) { break }
            }
            if ($stopping) { break }

            try {
                $context = $contextTask.GetAwaiter().GetResult()
            }
            catch [System.Net.HttpListenerException] {
                break
            }
            catch [System.ObjectDisposedException] {
                break
            }

            $request  = $context.Request
            $response = $context.Response

            $timestamp = "$($t.Overlay)$(Get-Date -Format 'HH:mm:ss')$($t.Reset)"
            $method    = "$($t.Yellow)$($request.HttpMethod)$($t.Reset)"
            $urlPath   = "$($t.Teal)$($request.Url.LocalPath)$($t.Reset)"

            try {
                $relativePath = [Uri]::UnescapeDataString($request.Url.LocalPath).TrimStart('/')
                $fullPath     = if ($relativePath) { Join-Path $root $relativePath } else { $root }
                $resolved     = try { (Resolve-Path -LiteralPath $fullPath -ErrorAction Stop).Path } catch { $null }

                # Block path traversal (../../whatever) outside the served root.
                if ($resolved) {
                    $rootBase = $root.TrimEnd('\', '/')
                    $rootPrefix = $rootBase + '\'
                    if (-not ($resolved -eq $rootBase -or
                              $resolved.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase))) {
                        $resolved = $null
                    }
                }

                if ($resolved -and (Test-Path -LiteralPath $resolved -PathType Leaf)) {
                    $extension = [System.IO.Path]::GetExtension($resolved).ToLowerInvariant()
                    $response.ContentType = if ($mimeMap.ContainsKey($extension)) { $mimeMap[$extension] } else { 'application/octet-stream' }
                    $content = [System.IO.File]::ReadAllBytes($resolved)
                    $response.StatusCode = 200
                    $response.OutputStream.Write($content, 0, $content.Length)
                    Write-Host "  $timestamp  $method  $urlPath  $($t.Green)200$($t.Reset)"
                }
                elseif ($resolved -and (Test-Path -LiteralPath $resolved -PathType Container)) {
                    $urlBase = '/' + $relativePath.TrimEnd('/')
                    if ($urlBase -eq '/') { $urlBase = '' }

                    $files = Get-ChildItem -LiteralPath $resolved | ForEach-Object {
                        $name   = if ($_.PSIsContainer) { "$($_.Name)/" } else { $_.Name }
                        $suffix = if ($_.PSIsContainer) { '/' } else { '' }
                        $encoded = [Uri]::EscapeDataString($_.Name) + $suffix
                        $safeName = [System.Net.WebUtility]::HtmlEncode($name)
                        "<li><a href='$urlBase/$encoded'>$safeName</a></li>"
                    }

                    $html    = "<!doctype html><html><head><meta charset='utf-8'><title>/$relativePath</title></head><body><h2>/$relativePath</h2><ul>$($files -join '')</ul></body></html>"
                    $content = [System.Text.Encoding]::UTF8.GetBytes($html)
                    $response.ContentType = 'text/html; charset=utf-8'
                    $response.StatusCode  = 200
                    $response.OutputStream.Write($content, 0, $content.Length)
                    Write-Host "  $timestamp  $method  $urlPath  $($t.Green)200 [dir]$($t.Reset)"
                }
                else {
                    $response.StatusCode = 404
                    Write-Host "  $timestamp  $method  $urlPath  $($t.Yellow)404$($t.Reset)"
                }
            }
            catch {
                # A single bad request must never kill the whole server loop.
                try { $response.StatusCode = 500 } catch {}
                Write-Host "  $timestamp  $method  $urlPath  $($t.Red)500 $($_.Exception.Message)$($t.Reset)"
            }
            finally {
                try { $response.Close() } catch {}
            }
        }
    }
    catch [System.Net.HttpListenerException] {
        Write-Host "  $($t.Red)$($g.Cross)  Could not start the server on $prefix$($t.Reset)"
        Write-Host "  $($t.Overlay)$($_.Exception.Message)$($t.Reset)"
    }
    finally {
        if ($null -ne $previousCtrlCMode) {
            try { [Console]::TreatControlCAsInput = $previousCtrlCMode } catch {}
        }
        try { $listener.Stop() } catch {}
        try { $listener.Close() } catch {}
        Write-Host ''
        Write-Host "  $($t.Overlay)Server stopped.$($t.Reset)"
        Write-Host ''
    }
}

function Get-WeatherCondition {
    param([int]$Code)

    $vs = [string][char]0xFE0F   # variation selector 16: forces emoji presentation
    $icon = @{
        Sun         = [string][char]0x2600 + $vs
        SunCloud    = [char]::ConvertFromUtf32(0x1F324) + $vs
        PartlyCloud = [string][char]0x26C5
        Cloud       = [string][char]0x2601 + $vs
        Fog         = [char]::ConvertFromUtf32(0x1F32B) + $vs
        Drizzle     = [char]::ConvertFromUtf32(0x1F326) + $vs
        Rain        = [char]::ConvertFromUtf32(0x1F327) + $vs
        Snow        = [string][char]0x2744 + $vs
        Storm       = [string][char]0x26C8 + $vs
        Unknown     = [char]::ConvertFromUtf32(0x1F321) + $vs
    }

    switch ($Code) {
        0                    { return [pscustomobject]@{ Description = 'Clear sky';         Icon = $icon.Sun } }
        1                    { return [pscustomobject]@{ Description = 'Mainly clear';      Icon = $icon.SunCloud } }
        2                    { return [pscustomobject]@{ Description = 'Partly cloudy';     Icon = $icon.PartlyCloud } }
        3                    { return [pscustomobject]@{ Description = 'Overcast';          Icon = $icon.Cloud } }
        { $_ -in 45, 48 }    { return [pscustomobject]@{ Description = 'Fog';               Icon = $icon.Fog } }
        { $_ -in 51, 53, 55 }{ return [pscustomobject]@{ Description = 'Drizzle';           Icon = $icon.Drizzle } }
        { $_ -in 56, 57 }    { return [pscustomobject]@{ Description = 'Freezing drizzle';  Icon = $icon.Drizzle } }
        { $_ -in 61, 63, 65 }{ return [pscustomobject]@{ Description = 'Rain';              Icon = $icon.Rain } }
        { $_ -in 66, 67 }    { return [pscustomobject]@{ Description = 'Freezing rain';     Icon = $icon.Rain } }
        { $_ -in 71, 73, 75 }{ return [pscustomobject]@{ Description = 'Snow';              Icon = $icon.Snow } }
        77                   { return [pscustomobject]@{ Description = 'Snow grains';       Icon = $icon.Snow } }
        { $_ -in 80, 81, 82 }{ return [pscustomobject]@{ Description = 'Rain showers';      Icon = $icon.Rain } }
        { $_ -in 85, 86 }    { return [pscustomobject]@{ Description = 'Snow showers';      Icon = $icon.Snow } }
        { $_ -in 95, 96, 99 }{ return [pscustomobject]@{ Description = 'Thunderstorm';      Icon = $icon.Storm } }
        default              { return [pscustomobject]@{ Description = 'Unknown';           Icon = $icon.Unknown } }
    }
}

function weather {
    [CmdletBinding()]
    param([Parameter(Position = 0)][string]$City = $script:Settings.WeatherCity)

    $t = $script:Theme
    $g = $script:Glyph
    $deg = $g.Degree

    Write-Host ''
    Write-Host "  $($t.Mauve)$($t.Bold)$($g.Diamond) WEATHER$($t.Reset)  $($t.Overlay)fetching for$($t.Reset) $($t.Peach)$($t.Bold)$City$($t.Reset)"
    Write-Host "  $($t.Overlay)$($g.Rule * 52)$($t.Reset)"
    Write-Host ''

    # Windows PowerShell 5.1 may not negotiate TLS 1.2 by default.
    if ($PSVersionTable.PSVersion.Major -lt 6) {
        [Net.ServicePointManager]::SecurityProtocol =
            [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }

    try {
        $encoded = [System.Uri]::EscapeDataString($City)
        $geoUrl  = "https://geocoding-api.open-meteo.com/v1/search?name=$encoded&count=1&language=en&format=json"
        $geo     = Invoke-RestMethod -Uri $geoUrl -TimeoutSec 8 -ErrorAction Stop

        if (-not $geo.results -or @($geo.results).Count -eq 0) {
            Write-Host "  $($t.Red)$($g.Star)  City not found:$($t.Reset)  $($t.Peach)$City$($t.Reset)"
            Write-Host ''
            return
        }

        $place = @($geo.results)[0]
        $lat   = $place.latitude
        $lon   = $place.longitude

        $wxUrl = "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon" +
                 '&current=temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code,visibility' +
                 '&daily=weather_code,temperature_2m_max,temperature_2m_min' +
                 '&wind_speed_unit=kmh&timezone=auto&forecast_days=3'
        $wx = Invoke-RestMethod -Uri $wxUrl -TimeoutSec 8 -ErrorAction Stop

        $current   = $wx.current
        $condition = Get-WeatherCondition -Code ([int]$current.weather_code)
        $visibilityText = if ($null -ne $current.visibility) { "$([math]::Round($current.visibility / 1000, 1)) km" } else { 'n/a' }

        Write-Host "  $($t.Overlay)location   $($t.Reset)  $($t.Yellow)$($t.Bold)$($place.name)$($t.Reset)$($t.Overlay), $($place.country)$($t.Reset)"
        Write-Host "  $($t.Overlay)condition  $($t.Reset)  $($condition.Icon)  $($t.Yellow)$($t.Bold)$($condition.Description)$($t.Reset)"
        Write-Host "  $($t.Overlay)temp       $($t.Reset)  $($t.Peach)$($t.Bold)$($current.temperature_2m) ${deg}C$($t.Reset)  $($t.Overlay)feels like$($t.Reset)  $($t.Sapphire)$($current.apparent_temperature) ${deg}C$($t.Reset)"
        Write-Host "  $($t.Overlay)humidity   $($t.Reset)  $($t.Teal)$($t.Bold)$($current.relative_humidity_2m)%$($t.Reset)"
        Write-Host "  $($t.Overlay)wind       $($t.Reset)  $($t.Green)$($t.Bold)$($current.wind_speed_10m) km/h$($t.Reset)"
        Write-Host "  $($t.Overlay)visibility $($t.Reset)  $($t.Pink)$($t.Bold)$visibilityText$($t.Reset)"

        Write-Host ''
        Write-Host "  $($t.Mauve)$($t.Bold)  3-DAY FORECAST$($t.Reset)"
        Write-Host "  $($t.Overlay)  $($g.Rule * 44)$($t.Reset)"

        $culture = [System.Globalization.CultureInfo]::GetCultureInfo('en-US')
        $days    = @($wx.daily.time)
        for ($i = 0; $i -lt $days.Count; $i++) {
            $date    = [datetime]::ParseExact($days[$i], 'yyyy-MM-dd', $culture)
            $dayName = $date.ToString('ddd dd MMM', $culture).PadRight(12)
            $maxC    = @($wx.daily.temperature_2m_max)[$i]
            $minC    = @($wx.daily.temperature_2m_min)[$i]
            $dayDesc = (Get-WeatherCondition -Code ([int]@($wx.daily.weather_code)[$i])).Description
            Write-Host "  $($t.Overlay)  $dayName$($t.Reset)  $($t.Peach)$($g.Up)$maxC${deg}$($t.Reset)  $($t.Sapphire)$($g.Down)$minC${deg}$($t.Reset)  $($t.Overlay)$dayDesc$($t.Reset)"
        }
    }
    catch {
        Write-Host "  $($t.Red)$($g.Star)  Could not fetch weather.$($t.Reset)  $($t.Overlay)$($_.Exception.Message)$($t.Reset)"
    }
    Write-Host ''
}

Export-ModuleMember -Function proc, serve, weather
