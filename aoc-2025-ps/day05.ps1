param(
    [int]$part = 0,
    [string]$inputFile = "inputs/day04.txt",
    [switch]$test
)

#region Helper Functions
function Parse-Ranges {
    param([string[]]$data)

    $ranges = @()

    foreach($line in $data) {
        if($line -match '^\s*(\d+)\s*-\s*(\d+)\s*$') {
            $start = [int64]$Matches[1]
            $end = [int64]$Matches[2]
            if($end -lt $start) { throw "Invalid range: $line" }
            $ranges += ,@($start, $end)
        }
    }

    return $ranges
}

function Merge-Ranges {
    param([object[]]$ranges)

    if($ranges.Count -eq 0) { return @() }

    $sorted = $ranges | Sort-Object { $_[0] }

    $merged = @()
    $current = @($sorted[0][0], $sorted[0][1])

    foreach($r in $sorted[1..($sorted.Count - 1)]) {
        $s = $r[0]
        $e = $r[1]

        if($s -le ($current[1] + 1)) {
            # overlapping or contiguous
            $current[1] = [Math]::Max($current[1], $e)
        } else {
            # no overlap
            $merged += ,$current
            $current = @($s, $e)
        }
    }
    $merged += ,$current
    return $merged
}

function ID-IsFresh {
    param([int64]$id, [object[]]$ranges)

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

    # If we are in Test mode.
    if($data -is [System.Array]) {
        # Remove comments + empty lines
        $clean = $data | Where-Object { $_ -match '\S' -and $_ -notmatch '^\s*#' }

        # Identify first non-range line (first time parsing fails)
        $ranges = @()
        $ids = @()

        $parsingRanges = $true

        foreach ($line in $clean) {
            if ($parsingRanges -and $line -match '^\s*(\d+)\s*-\s*(\d+)\s*$') {
                $ranges += $line
            }
            else {
                $parsingRanges = $false
                if ($line -match '^\s*\d+\s*$') {
                    $ids += $line
                }
            }
        }

        if ($ranges.Count -eq 0 -or $ids.Count -eq 0) {
            throw "Invalid test input format: could not split ranges and IDs."
        }

        $rangesParsed = Parse-Ranges -data $ranges

        $fresh = 0
        foreach ($idStr in $ids) {
            $id = [int64]$idStr
            if (ID-IsFresh -id $id -ranges $rangesParsed) { $fresh++ }
        }

        return $fresh
    }

    # If we are in actual run mode.
    $sections = $data -split '\r?\n\r?\n'
    if ($sections.Count -lt 2) { throw "Invalid input format." }

    $rangeLines = $sections[0] -split '\r?\n'
    $idLines    = $sections[1] -split '\r?\n'

    $ranges = Parse-Ranges -data $rangeLines

    $freshCount = 0

    foreach ($idStr in $idLines) {
        if ($idStr -match '^\s*(\d+)\s*$') {
            $id = [int64]$Matches[1]

            if (ID-IsFresh -id $id -ranges $ranges) { $freshCount++ }
        }
    }

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
        Default { 
            $p1 = Solve-Part1 $data
            # $p2 = Solve-Part2 $data
            Write-Output "Day 04 - Part 1: $p1"
            # Write-Output "Day 04 - Part 2: $p2"
         }
    }
}
#endregion

#region Test
if ($Test) {
    $raw = Get-Content $InputFile -Raw
    $data = (Get-Content $InputFile -Raw) -replace '(?m)^#.*(?:\r?\n)?', ''

    if ($Part -eq 1) { Write-Output (Solve-Part1 $data) }
    elseif ($Part -eq 2) { Write-Output (Solve-Part2 $data) }
    else { throw "Test mode requires -Part 1 or -Part 2" }
}
else {
    Run-Day05 -Part $Part -InputFile $InputFile
}
#end
