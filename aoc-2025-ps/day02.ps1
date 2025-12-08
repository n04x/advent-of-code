param(
    [int]$Part = 0,
    [string]$InputFile = "inputs/day02.txt",
    [switch]$Test
)

#region Functions
# -------------------------------
# Helper: Parse the range
# -------------------------------
function Parse-Range {
    param([string]$s)

    $parts = $s -split '-'

    if($parts.Count -ne 2) { throw "Invalid range format: $s" }

    $start = [uint64]$parts[0].Trim()
    $end   = [uint64]$parts[1].Trim()

    if($start -gt $end) { throw "Invalid range, start greater than end: $s" }

    return ,@($start, $end)
}

# -------------------------------
# Check if number has form XXYY where X == Y (even-length mirror)
# -------------------------------
function Is-DoubleRepeat {
    param([uint64]$id)

    $s = $id.ToString()
    $len = $s.Length

    if($len % 2 -ne 0) { return $false }

    $half = $len / 2
    $first = $s.Substring(0, $half)
    $second = $s.Substring($half)

    return ($first -eq $second)
}

# -------------------------------
# Check if number is repeating pattern (e.g. 123123, 456456)
# -------------------------------
function Is-MultiRepeat {
    param([uint64]$id)

    $s = $id.ToString()
    $len = $s.Length

    # Try all possible segment sizes
    for($size = 1; $size -le ($len /2 ); $size++) {
        if($len % $size -ne 0) { continue }

        $base = $s.Substring(0, $size)

        if($base[0] -eq '0') { continue } # leading zeroes not allowed

        $ok = $true
        for($i = $size; $i -lt $len; $i += $size) {
            if($s.Substring($i, $size) -ne $base) {
                $ok = $false
                break
            }
        }
        if($ok) { return $true }
    }
    return $false
}

# -------------------------------
# PART 1
# -------------------------------
function Solve-Part1 {
    param ([string]$data)
    
    $result = [uint64] 0

    $ranges = $data.Trim() -Split "," | Where-Object { $_.Trim() -ne "" }

    foreach($r in $ranges) {
        $pair = Parse-Range $r
        $start = $pair[0]
        $end = $pair[1]

        for($id = $start; $id -le $end; $id++) {
            if(Is-DoubleRepeat -id $id) {
                $result+= $id
            }
        }
    }
    return $result
}

# -------------------------------
# PART 2
# -------------------------------
function Solve-Part2 {
    param ([string]$data)
    
    $result = [uint64] 0

    $ranges = $data.Trim() -Split "," | ForEach-Object { $_.Trim() } | Where-Object { $_.Trim() -ne "" }

    foreach($r in $ranges) {
        $pair = Parse-Range $r
        $start = $pair[0]
        $end = $pair[1]

        for($id = $start; $id -le $end; $id++) {
            if(Is-MultiRepeat $id) {
                $result+= $id
            }
        }
    }
    return $result    
}
#endregion

#region Main Execution
function Run-Day02 {
    param([int]$Part, [string]$InputFile)

    if(-not (Test-Path $InputFile)) { throw "Input file not found: $InputFile" }
    $data = Get-Content $InputFile -Raw

    if($Part -eq 1) {
        $result = Solve-Part1 $data
        Write-Host "Day 02 - Part 1: $result" -ForegroundColor Green
    }
    elseif($Part -eq 2) {
        $result = Solve-Part2 $data
        Write-Host "Day 02 - Part 2: $result" -ForegroundColor Green
    }
    else {
        $p1 = Solve-Part1 $data
        $p2 = Solve-Part2 $data
        Write-Host "Day 02 - Part 1: $p1" -ForegroundColor Green
        Write-Host "Day 02 - Part 2: $p2" -ForegroundColor Green
    }
}

#region TEST
if ($Test) {
    $data = Get-Content $InputFile | Where-Object { $_ -and $_ -notmatch "^#" }

    if ($Part -eq 1) { Write-Output (Solve-Part1 $data) }
    elseif ($Part -eq 2) { Write-Output (Solve-Part2 $data) }
    else { throw "Test mode requires -Part 1 or -Part 2" }
}
else {
    Run-Day02 -Part $Part -InputFile $InputFile
}
#endregion