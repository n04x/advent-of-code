param(
    [int]$part = 0,
    [string]$inputFile = "inputs/day06.txt",
    [switch]$test
)
#region Helper Functions
function Parse-Day06 {
    param([string]$data)

    #split into lines
    $lines = $data -split '\r?\n'

    if($lines.Count -lt 2) { throw "Invalid input: expected multiple rows." }

    $maxLen = ($lines | Measure-Object -Property Length -Maximum).Maximum

    $normalized = foreach($line in $lines) {
        if($line.Length -lt $maxLen) {
            $line + (' ' * ($maxLen - $line.Length))
        } else {
            $line
        }
    }

    # scan columns to find blank spaces.
    $columns = 0..($maxLen - 1)
    $colIsBlank = @{}
    foreach($col in $columns) {
        $colIsBlank[$col] = $true
        foreach($row in $normalized) {
            if($row[$col] -ne ' ') {
                $colIsBlank[$col] = $false
                break
            }
        }
    }

    # split into columns groups.
    $groups = @()
    $current = @()

    for($c = 0; $c -lt $maxLen; $c++) {
        if( -not $colIsBlank[$c]) {
            $current += $c
        } else {
            if($current.Count -gt 0) {
                $groups += ,$current
                $current = @()
            }
        }
    }
    if($current.Count -gt 0) { $groups += ,$current }

    $problems = foreach($g in $groups) {
        $start = $g[0]
        $end = $g[-1]

        $blocks = foreach($ln in $normalized) { $ln.Substring($start, $end - $start + 1)}
        ,$blocks
    }
    return $problems
}

function Solve-ProblemBlock {
    param([string[]]$block)

    $opLine = $block[-1]
    $operator = ($opLine -replace '\s','')
    if($operator -notin @('+','*')) { throw "Invalid operator in block:'$operator'" }

    $nums = @()
    for($i = 0; $i -lt $block.Count - 1; $i++) {
        $line = $block[$i]
        if($line -match '(\d+)') { $nums += [int64]$Matches[1] }
    }

    if($nums.Count -lt 1) { throw "Problem block has no numbers." }

    if($operator -eq "+") { return ($nums | Measure-Object -Sum).Sum }
    else { 
        $prod = 1
        foreach($n in $nums) { $prod *= $n }
        return $prod
    }
}

function Solve-ProblemBlock-Part2 {
    param([string[]]$block)

    $opLine = $block[-1]
    $operator = ($opLine -replace '\s','')
    if($operator -notin @('+','*')) { throw "Invalid operator in block:'$operator'" }

    # Remove the operator row
    $digitRow = $block[0..($block.Count-2)]

    # Convert row into 2d-matrix
    $height = $digitRow.Count
    $width = $digitRow[0].Length

    $nums = @()

    for($c = $width -1; $c -ge 0; $c--) {
        $digits = ""
        for($r = 0; $r -lt $height; $r++) {
            $ch = $digitRow[$r][$c]
            if($ch -match '\d') { $digits += $ch }
        }
        if($digits -ne "") { $nums += [int64]$digits }
    }

    if($nums.Count -lt 1) { throw "No numeric columns found in problem block." }

    if($operator -eq '+') { return ($nums | Measure-Object -Sum).Sum }
    else {
        $prod = 1
        foreach($n in $nums) { $prod *= $n }
        return $prod
    }
    
}
#endregion

#region Logic
function Solve-Part1 {
    param ([string]$data)
    
    $problems = Parse-Day06 $data
    $total = 0
    foreach($problem in $problems) {
        $total += Solve-ProblemBlock $problem
    }
    
    return $total
}

function Solve-Part2 {
    param ([string]$data)
    
    $problems = Parse-Day06 $data
    $total = 0
    foreach($problem in $problems) { $total += Solve-ProblemBlock-Part2 $problem }
    return $total
}
#endregion

#region Main Execution
function Run-Day06 {
    param ([int]$part, [string]$inputFile)
    if(-not (Test-Path $inputFile)) { throw "Input file not found: $inputFile" }
    
    $data = Get-Content $inputFile -Raw 
    
    switch ($part) {
        1 { Write-Host "Day 06 - Part 1:  $(Solve-Part1 $data)" }
        2 { Write-Host "Day 06 - Part 2:  $(Solve-Part2 $data)" }
        Default {
            $p1 = Solve-Part1 $data
            $p2 = Solve-Part2 $data
            Write-Host "Day 06 - Part 1: $p1"
            Write-Host "Day 06 - Part 2: $p2"
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
    Run-Day06 -Part $Part -InputFile $InputFile
}
#endregion