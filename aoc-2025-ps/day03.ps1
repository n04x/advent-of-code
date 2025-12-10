param(
    [int]$Part = 0,
    [string]$InputFile = "inputs/day03.txt",
    [switch]$Test
)

#region Functions
# -------------------------------
# Convert a line of digits to an array of integers
# -------------------------------
function Convert-ToDigits {
    param ([string]$line)
    return $line.ToCharArray() | ForEach-Object { [int]$_ - 48 }
    
}
# PART ONE
# -------------------------------
function Solve-Part1 {
    param([string]$data)

    $result = 0
    $lines = $data -split '\r?\n' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    foreach($line in $lines) {
        $digits = Convert-ToDigits $line
        $largest = 0

        for($i = 0; $i -lt $digits.Count; $i++) {
            for($j = $i + 1; $j -lt $digits.Count; $j++) {
                $value = $digits[$i] * 10 + $digits[$j]
                if($value -gt $largest) {
                    $largest = $value
                }
            }
        }
        $result += $largest
    }
    return $result
}

# -------------------------------
# PART TWO
# -------------------------------
function Solve-Part2 {
    param([string]$data)
    $K = 12
    $result = 0
    $lines = $data -split '\r?\n' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    foreach($line in $lines) {
        $digits = Convert-ToDigits $line
        $n = $digits.Count

        if($n -lt $K) { throw "Bank has fewer than $K batteries: $line" }

        $stack = New-Object System.Collections.Generic.List[int]
        $toRemove = $n - $K

        foreach($d in $digits) {
            while($stack.Count -gt 0 -and $toRemove -gt 0 -and $stack[$stack.Count - 1] -lt $d) {
                $stack.RemoveAt($stack.Count - 1)
                $toRemove--
            }
            $stack.Add($d)
        }

        # if still need to remove more, remove from the end
        while($stack.Count -gt $K) { $stack.RemoveAt($stack.Count - 1) }

        # Convert stack to number
        $value = 0
        foreach($d in $stack) {
            $value = $value * 10 + $d
        }

        $result += $value
    }
    return $result
}
#endregion


#region MAIN EXECUTION
function Run-Day03 {
    param ([int]$Part, [string]$InputFile)
    if(-not (Test-Path $InputFile)) { throw "Input file not found: $InputFile" }
    $data = Get-Content $InputFile -Raw
    if($Part -eq 1) {
        $result = Solve-Part1 $data
        Write-Host "Day 03 - Part 1: $result" -ForegroundColor Green
    }
    elseif ($Part -eq 2) {
        $result = Solve-Part2 $data
        Write-Host "Day 03 - Part 2: $result" -ForegroundColor Green
    }
    else {
        $p1 = Solve-Part1 $data
        $p2 = Solve-Part2 $data
        Write-Host "Day 03 - Part 1: $p1" -ForegroundColor Green
        Write-Host "Day 03 - Part 2: $p2" -ForegroundColor Green
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
    Run-Day03 -Part $Part -InputFile $InputFile
}
#endregion