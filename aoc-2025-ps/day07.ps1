param(
    [int]$part = 0,
    [string]$inputFile = "inputs/day07.txt",
    [switch]$test
)

#region Helper
function Parse-Grid {
    param ([string]$data)

    return ($data -split "\r?\n") | Where-Object { $_ -ne "" }
    
}

#endregion

#region Logic
function Solve-Part1 {
    param([string]$data)

    $grid = Parse-Grid $data
    $rows = $grid.Count
    $cols = $grid[0].Length

    # Locate S (Start)
    $startCol = -1
    for($c=0; $c -lt $cols; $c++) {
        if($grid[0][$c] -eq 'S') { 
            $startCol = $c 
            break
        }
    }
    if($startCol -lt 0) { throw "Start position (S) not found!" }

    # Activate beams
    $beams = [System.Collections.Generic.HashSet[string]]::new()
    $beams.Add("1,$startCol") | Out-Null

    $splits = 0
    $step = 0
    while($beams.Count -gt 0) {
        $step++
        $nextBeams = [System.Collections.Generic.HashSet[string]]::new()

        foreach($b in $beams) {
            $parts = $b -split ','
            $r = [int]$parts[0]
            $c = [int]$parts[1]

            if($r -ge $rows) { continue }

            $cell = $grid[$r][$c]

            if($cell -eq '^') { 
                # Split the beams
                $splits++

                if($c -gt 0) { $nextBeams.Add(($r + 1).ToString() + "," + ($c - 1)) | Out-Null }
                if($c -lt $cols - 1) { $nextBeams.Add(($r + 1).ToString() + "," + ($c + 1)) | Out-Null }
            }
            else {
                # Continue straight down
                $nextBeams.Add(($r + 1).ToString() + "," + $c) | Out-Null
            }
        }
        $beams = $nextBeams
    }

    return $splits
}

function Solve-Part2 {
    param ([string]$data)
    return 0
}
#endregion

#region Main Execution
function Run-Day07 {
    param ([string]$part, [string]$InputFile)
    if(-not (Test-Path $inputFile)) { throw "Input file not found: $inputFile" }
    $raw = Get-Content $inputFile -Raw 
    $data = (($raw -split "`n") | Where-Object { $_ -notmatch "^#" }) -join "`n"
    
    switch ($part) {
        1 { Write-Output "Day 07 - Part 1:  $(Solve-Part1 $data)" }
        2 { Write-Output "Day 07 - Part 2:  $(Solve-Part2 $data)" }
        Default {
            $p1 = Solve-Part1 $data
            $p2 = Solve-Part2 $data
            Write-Output "Day 07 - Part 1: $p1"
            Write-Output "Day 07 - Part 2: $p2"
        }
    }
}
#endregion

#region Test
if ($Test) {
    $raw = Get-Content $InputFile -Raw
    $data = (($raw -split "`n") | Where-Object { $_ -notmatch "^#" }) -join "`n"

    if ($Part -eq 1) { Write-Output (Solve-Part1 $data) }
    elseif ($Part -eq 2) { Write-Output (Solve-Part2 $data) }
    else { throw "Test mode requires -Part 1 or -Part 2" }
}
else {
    Run-Day07 -Part $Part -InputFile $InputFile
}
#endregion