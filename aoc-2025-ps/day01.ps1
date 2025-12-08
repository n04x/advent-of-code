param(
    [int]$Part = 0,
    [string]$InputFile = "inputs/day01.txt",
    [switch]$Test
)

# -------------------------------
# PART ONE
# -------------------------------
function Solve-Part1 {
    param ([string[]]$data)
    $position = 50
    $hits = 0
    $dialSize = 100

    foreach($line in $data) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        
        $direction = $line.Substring(0,1)
        $distance = [int]$line.Substring(1)

        if($direction -eq "L") {
            $position = ($position - $distance) % $dialSize
        } elseif ($direction -eq "R") {
            $position = ($position + $distance) % $dialSize
        } else {
            throw "Invalid direction: $direction"
        }

        if($position -lt 0) { $position += $dialSize }
        if($position -eq 0) { $hits++ }
    }
    return $hits
}

# -------------------------------
# PART TWO
# -------------------------------
function Solve-Part2 {
    param ([string[]] $data)
    $position = 50
    $zeroHits = 0
    $dialSize = 100

    foreach($line in $data) {
        if([string]::IsNullOrWhiteSpace($line)) { continue }

        $direction = $line.Substring(0,1)
        $distance = [int]$line.Substring(1)

        $delta = switch ($direction) {
            "L" { -$distance }
            "R" { $distance }
            Default { throw "Invalid direction: $direction" }
        }
        $position_modulo = (($position % $dialSize) + $dialSize) % $dialSize

        if($delta -ge 0) { $offset = ($dialSize - $position_modulo) % $dialSize }
        else { $offset = $position_modulo % $dialSize }

        $d = [Math]::Abs($delta)

        if($d -le $offset) { $crosses = 0 }
        else { $crosses = [math]::Floor(($d - $offset - 1) / $dialSize) + 1 }

        $zeroHits += $crosses
        $position += $delta
    }
    return $zeroHits
}

# -------------------------------
# MAIN EXECUTION
# -------------------------------
function Run-Day01 {
    param (
        [int]$Part,
        [string]$InputFile
    )
    
    if(-not (Test-Path $InputFile)) { throw "Input file not found: $InputFile" }
    $data = Get-Content $InputFile | Where-Object { $_ -and $_ -notmatch "^#" }

    if($Part -eq 1) {
        $result = Solve-Part1 $data
        Write-Host "Day 01 - Part 1: $result" -ForegroundColor Green
    }
    elseif ($Part -eq 2) {
        $result = Solve-Part2 $data
        Write-Host "Day 01 - Part 2: $result" -ForegroundColor Green
    }
    else {
        $p1 = Solve-Part1 $data
        $p2 = Solve-Part2 $data
        Write-Host "Day 01 - Part 1: $p1" -ForegroundColor Green
        Write-Host "Day 01 - Part 2: $p2" -ForegroundColor Green
    }
}

if ($Test) {
    $data = Get-Content $InputFile | Where-Object { $_ -and $_ -notmatch "^#" }

    if ($Part -eq 1) { Write-Output (Solve-Part1 $data) }
    elseif ($Part -eq 2) { Write-Output (Solve-Part2 $data) }
    else { throw "Test mode requires -Part 1 or -Part 2" }
}
else {
    Run-Day01 -Part $Part -InputFile $InputFile
}