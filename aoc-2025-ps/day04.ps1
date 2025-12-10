param(
    [int]$Part = 0,
    [string]$InputFile = "inputs/day04.txt",
    [switch]$Test
)

#region Functions

# -------------------------------
# Parse grid into arrays of characters.
# -------------------------------
function Parse-Grid {
    param ([string]$data)
    
    $grid = @()
    foreach($line in ($data -split '\r?\n')) {
        $trim = $line.Trim()
        if($trim -ne "") {
            $grid += ,($trim.ToCharArray())
        }
    }
    return $grid
}

# -------------------------------
# Count adjacent '@'
# -------------------------------
function Count-Adjacent {
    param ( 
        [object[]]$Grid,
        [int]$R,
        [int]$C
    )

    $dirs = @(
        @(-1, -1), @(-1, 0), @(-1, 1),
        @(0, -1),           @(0, 1),
        @(1, -1),  @(1, 0), @(1, 1)
    )

    $rows = $Grid.Count
    $cols = $Grid[0].Count
    $count = 0

    foreach($d in $dirs) {
        $nr = $R + $d[0]
        $nc = $C + $d[1]

        if($nr -ge 0 -and $nc -ge 0 -and $nr -lt $rows -and $nc -lt $cols) {
            if($Grid[$nr][$nc] -eq '@') {
                $count++
            }
        }
    }

    return $count
}

function Solve-Part1 {
    param([string]$data)
    
    $grid = Parse-Grid $data
    $rows = $grid.Count
    if($rows -eq 0) { return 0 }
    $cols = $grid[0].Count

    $accessible = 0

    for($r = 0; $r -lt $rows; $r++) {
        for($c = 0; $c -lt $cols; $c++) {
            if($grid[$r][$c] -eq '@') {
                $adj = Count-Adjacent -Grid $grid -R $r -C $c
                if($adj -lt 4) {
                    $accessible++
                }
            }
        }
    }
    return $accessible
}

function Solve-Part2 {
    param([string]$data)

    $grid = Parse-Grid $data
    $rows = $grid.Count
    if($rows -eq 0) { return 0 }
    $cols = $grid[0].Count

    $totalRemoved = 0

    while($true) {
        $toRemove = @()

        for($r = 0; $r -lt $rows; $r++) {
            for($c = 0; $c -lt $cols; $c++) {
                if($grid[$r][$c] -eq '@') {
                    $adj = Count-Adjacent -Grid $grid -R $r -C $c
                    if($adj -lt 4) {
                        $toRemove += ,@($r, $c)
                    }
                }
            }
        }

        # Stop condition no more accessible @
        if($toRemove.Count -eq 0) { break }

        # Remove them
        foreach($cell in $toRemove) { 
            $r = $cell[0]
            $c = $cell[1]
            $grid[$r][$c] = '.'
         }

        $totalRemoved += $toRemove.Count
    }
    return $totalRemoved
}

#endregion

#region MAIN EXECUTION
function Run-Day04 {
    param ([int]$Part, [string]$InputFile)

    if(-not (Test-Path $InputFile)) {
        throw "Input file not found: $InputFile"
    }

    $data = Get-Content $InputFile -Raw

    if($Part -eq 1) {
        $result = Solve-Part1 $data
        Write-Output $result
    }
    elseif( $Part -eq 2) {
        $result = Solve-Part2 $data
        Write-Output $result
    }
    else {
        $p1 = Solve-Part1 $data
        $p2 = Solve-Part2 $data
        Write-Output "Day 04 - Part 1: $p1"
        Write-Output "Day 04 - Part 2: $p2"
    }
    
}
#endregion

#region TEST
if ($Test) {
    $raw = Get-Content $InputFile -Raw
    $data = ($raw -split "`n") | Where-Object { $_.Trim() -and $_ -notmatch "^#" } | Out-String

    if ($Part -eq 1) { Write-Output (Solve-Part1 $data) }
    elseif ($Part -eq 2) { Write-Output (Solve-Part2 $data) }
    else { throw "Test mode requires -Part 1 or -Part 2" }
}
else {
    Run-Day04 -Part $Part -InputFile $InputFile
}
#endregion