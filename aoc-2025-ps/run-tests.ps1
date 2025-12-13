Write-Host "`nRunning Advent of Code Tests..." -ForegroundColor Yellow

$testsDir = Join-Path -Path (Get-Location) -ChildPath "tests"
if (-not (Test-Path $testsDir)) {
    Write-Host "tests/ directory not found. Create tests/day01.test.txt etc." -ForegroundColor Yellow
    exit 1
}

$testFiles = Get-ChildItem -Path $testsDir -Filter "day*.test.txt" -ErrorAction SilentlyContinue | Sort-Object Name
if(-not $testFiles -or $testFiles.Count -eq 0) {
    Write-Host "No test files found in tests/  (expected dayNN.test.txt)." -ForegroundColor Yellow
    exit 1
}
$passed = 0
$failed = 0

foreach ($file in $testFiles) {
    Write-Host "`nTesting $($file.Name)" -ForegroundColor Cyan

    $raw = Get-Content $file.FullName

    $p1Header = ($raw | Where-Object { $_ -match  '^\s*#\s*PART1_EXPECTED\s*=' }) | Select-Object -First 1
    $p2Header = ($raw | Where-Object { $_ -match '^\s*#\s*PART2_EXPECTED\s*='}) | Select-Object -First 1

    $p1Expected = $null
    $p2Expected = $null
    if($p1Header) { $p1Expected = ($p1Header -replace '.*=').Trim() }
    if($p2Header) { $p2Expected = ($p2Header -replace '.*=').Trim() }

    $inputLines = $raw | Where-Object { $_ -notmatch '^\s*#' }

    $day = [regex]::Match($file.Name, 'day(\d+)').Groups[1].Value
    $scriptName = "day$day.ps1"
    $scriptPath = Join-Path -Path (Get-Location) -ChildPath $scriptName

    if(-not (Test-Path $scriptPath)) {
        Write-Host "  Script $scriptName not found. Skipping test." -ForegroundColor Yellow
        $failed += 2
        continue
    }

    # Helper to call day script and capture output
    function Invoke-DayScript([string]$script, [int]$part, [string]$inputFile) {
        $exe = (Get-Command powershell).Source
        $args = @(
            "-ExecutionPolicy", "Bypass",
            "-File", $script,
            "-Part", $part,
            "-InputFile", $inputFile,
            "-Test"
        )
        $procOutput = & $exe @args 2>&1
        if($LASTEXITCODE -ne 0) { return @{ Success = $false; Output = ($procOutput -join "`n") } }
        else { return @{ Success = $true; Output = ($procOutput -join "`n") } }
    }

    # run part 1 if expected present
    if($p1Expected) {
        $res = Invoke-DayScript -script $scriptPath -part 1 -inputFile $file.FullName
        if($res.Success) {
            $p1Actual = $res.Output
            if($p1Actual -eq $p1Expected) {
                Write-Host " [+] Part 1 passed ($p1Actual)" -ForegroundColor Green
                $passed++
            } else {
                Write-Host " [-] Part 1 failed. Expected: $p1Expected, Got: $p1Actual" -ForegroundColor Red
                $failed++
            }
        } else {
            Write-Host " [-] Part 1 Error invoking script:`n$($res.Output)" -ForegroundColor Red
            $failed++
        }
    } else {
        Write-Host "[*] Skipping Part 1 (no #PART1_EXPECTED provided)" -ForegroundColor Yellow
    }

    # run part 2 if expected present
    if($p2Expected) {
        $res = Invoke-DayScript -script $scriptPath -Part 2 -inputFile $file.FullName
        if($res.Success) {
            $p2Actual = $res.Output
            if($p2Actual -eq $p2Expected) {
                Write-Host " [+] Part 2 passed ($p2Actual)" -ForegroundColor Green
                $passed++
            } else {
                Write-Host " [-] Part 2 failed. Expected: $p2Expected, Got: $p2Actual" -ForegroundColor Red
                $failed++
            }
        } else {
            Write-Host " [-] Part 2 Error invoking script:`n$($res.Output)" -ForegroundColor Red
            $failed++
        }
    } else {
        Write-Host "[*] Skipping Part 2 (no #PART2_EXPECTED provided)" -ForegroundColor Yellow
    }
}

Write-Host "`n========================="
Write-Host "[+] Tests Passed: $passed" -ForegroundColor Green
Write-Host "[-] Tests Failed: $failed" -ForegroundColor Red
Write-Host "=========================`n"