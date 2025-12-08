Write-Host "`nRunning Advent of Code Tests..." -ForegroundColor Yellow

$testFiles = Get-ChildItem -Path "tests" -Filter "day*.test.txt" -ErrorAction SilentlyContinue

if (-not $testFiles) {
    Write-Host "No test files found in /tests folder." -ForegroundColor Yellow
    return
}

$passed = 0
$failed = 0

foreach ($file in $testFiles) {
    Write-Host "`nTesting $($file.Name)" -ForegroundColor Cyan

    $raw = Get-Content $file.FullName

    $p1Expected = ($raw | Where-Object { $_ -like "#PART1_EXPECTED*" }) -replace ".*=", ""
    $p2Expected = ($raw | Where-Object { $_ -like "#PART2_EXPECTED*" }) -replace ".*=", ""

    $input = $raw | Where-Object { $_ -notlike "#*" -and $_ -ne "" }

    $day = ($file.Name -replace "day", "" -replace "\.test\.txt", "")
    $script = Join-Path (Get-Location) "day$day.ps1"

    if (-not (Test-Path $script)) {
        Write-Host "❌ Missing script: $script" -ForegroundColor Red
        $failed++
        continue
    }

    # ---------------------------
    # ✅ Run Part 1
    # ---------------------------
    $p1Actual = (& powershell -NoProfile -Command "& $script -Part 1 -InputFile $($file.FullName) -Test" 2>$null) -join "`n"

    if ($p1Actual -eq $p1Expected) {
        Write-Host "[+] Part 1 Passed ($p1Actual)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "[-] Part 1 Failed: Expected $p1Expected, Got $p1Actual" -ForegroundColor Red
        $failed++
    }

    # ---------------------------
    # ✅ Run Part 2
    # ---------------------------
    $p2Actual = (& powershell -NoProfile -Command "& $script -Part 2 -InputFile $($file.FullName) -Test" 2>$null) -join "`n"

    if ($p2Actual -eq $p2Expected) {
        Write-Host "[+] Part 2 Passed ($p2Actual)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "[-] Part 2 Failed: Expected $p2Expected, Got $p2Actual" -ForegroundColor Red
        $failed++
    }
}

Write-Host "`n========================="
Write-Host "✅ Passed: $passed" -ForegroundColor Green
Write-Host "❌ Failed: $failed" -ForegroundColor Red
Write-Host "=========================`n"