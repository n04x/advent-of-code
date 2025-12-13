param(
    [int]$part = 0,
    [string]$inputFile = "inputs/day05.txt",
    [switch]$test
)

#region Helper Functions
function Parse-Day05Sections {
    param ([string]$data)

    $lines = $data -split '\r?\n'

    $rangeLines = @()
    $idLines = @()
    $inID = $false

    foreach($line in $lines) {
        if($line -eq '') {
            $inID = $true
            continue
        }
        if($inID) {
            $idLines += $line
        } else {
            $rangeLines += $line
        }
    }
    if($rangeLines.Count -lt 1 -or $idLines.Count -lt 1) { throw "Invalid input format" }

    return @{
        Ranges  = $rangeLines
        IDs     = $idLines
    }
}

function Parse-Ranges {
    param ([string[]]$data)

    $out = @()
    foreach($line in $data) {
        if($line -match '^\s*(\d+)-(\d+)\s*$') {
            $start = [int64]$matches[1]
            $end = [int64]$matches[2]
            $out += ,@($start, $end)
        }
    }
    return $out    
}

function ID-IsFresh {
    param ([int64]$id, [Array]$ranges)

    foreach($r in $ranges) {
        if($id -ge $r[0] -and $id -le $r[1]) {
            return $true
        }
    }
    return $false
    
}
#endregion

#region Main Logic
function Solve-Part1 {
    param([string]$data)

    # Normalize if it comes from run-tests.ps1
    $parsed = Parse-Day05Sections -data $data
    $rangeLines = $parsed.Ranges
    $idLines = $parsed.IDs

    $ranges = Parse-Ranges -data $rangeLines
    $freshCount = 0
    foreach($line in $idLines) {
        if($line -match '^\s*(\d+)\s*$') {
            $id = [int64]$matches[1]
            if(ID-IsFresh -id $id -ranges $ranges) {
                $freshCount++
            }
        }
    }

    return $freshCount
}

function Solve-Part2 {
    param([string]$data)

    $parsed = Parse-Day05Sections -data $data
    $rangeLines = $parsed.Ranges

    $ranges = Parse-Ranges -data $rangeLines

    if($ranges.Count -eq 0) { return 0 }

    # Step 1, Sort and merge ranges
    $sorted = $ranges | Sort-Object { $_[0] }

    $merged = New-Object System.Collections.Generic.List[object]

    $currentStart   = $sorted[0][0]
    $currentEnd     = $sorted[0][1]

    for($i = 1; $i -lt $sorted.Count; $i++) {
        $s = $sorted[$i][0]
        $e = $sorted[$i][1]

        if($s -le ($currentEnd + 1)) { if ($e -gt $currentEnd) { $currentEnd = $e } }
        else {
            $merged.Add(@($currentStart, $currentEnd))
            $currentStart = $s
            $currentEnd = $e
        }
    }

    # push final range
    $merged.Add(@($currentStart, $currentEnd))

    # Step 2, Count unblocked IDs
    $freshCount = 0
    foreach($r in $merged) { $freshCount += ($r[1] - $r[0] + 1) }

    return $freshCount
}
#endregion

#region Main Execution
function Run-Day05 {
    param([int]$part, [string]$inputFile)

    if(-not (Test-Path $inputFile)) { throw "Input file not found: $inputFile" }

    $data = Get-Content $inputFile -Raw 

    switch ($part) {
        1 { Write-Output (Solve-Part1 $data) }
        2 { Write-Output (Solve-Part2 $data) }
        Default { 
            $p1 = Solve-Part1 $data
            $p2 = Solve-Part2 $data
            Write-Output "Day 04 - Part 1: $p1"
            Write-Output "Day 04 - Part 2: $p2"
         }
    }
}
#endregion

#region Test
if ($Test) {
    $raw = Get-Content $InputFile -Raw
    $data = ($raw -split "`n") | Where-Object { $_ -notmatch "^#" } | Out-String

    if ($Part -eq 1) { Write-Output (Solve-Part1 $data) }
    elseif ($Part -eq 2) { Write-Output (Solve-Part2 $data) }
    else { throw "Test mode requires -Part 1 or -Part 2" }
}
else {
    Run-Day05 -Part $Part -InputFile $InputFile
}
#endregion
