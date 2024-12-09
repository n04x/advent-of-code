#region Parameters
$TESTING = $false
$XMAS_occurence = 0
$cross_MAS_occurence = 0
#endregion

#region Functions
function Search-XMAS {
    param (
        [int]$r,
        [int]$c,
        [array]$data,
        [int]$rows,
        [int]$columns
    )

    $word = "XMAS"

    if ($data[$r][$c] -ne $word[0]) {
        return 0
    }

    $dirs = @(
        @(-1, 0), @(1, 0), @(0, -1), @(0, 1), @(-1, -1), @(-1, 1), @(1, -1), @(1, 1)
    )

    $xmasFound = 0

    foreach ($dir in $dirs) {
        $i_XMAS = 1
        $cR = $r + $dir[0]
        $cC = $c + $dir[1]

        while ($i_XMAS -lt $word.Length) {
            if ($cR -lt 0 -or $cR -ge $rows -or $cC -lt 0 -or $cC -ge $columns) {
                break
            }

            if ($data[$cR][$cC] -ne $word[$i_XMAS]) {
                break
            }

            $i_XMAS++
            $cR += $dir[0]
            $cC += $dir[1]
        }

        if ($i_XMAS -eq $word.Length) {
            $xmasFound++
        }
    }

    return $xmasFound
}

function Search-CrossMAS {
    param (
        [int]$r,
        [int]$c,
        [array]$data,
        [int]$rows,
        [int]$columns
    )

    if ($data[$r][$c] -ne "A") {
        return 0
    }

    $dirs = @(
        @(-1, -1, 1, 1), @(-1, 1, 1, -1)
    )

    $crossFound = 0

    foreach ($dir in $dirs) {
        $r1 = $dir[0]
        $c1 = $dir[1]
        $r2 = $dir[2]
        $c2 = $dir[3]

        if ($r + $r1 -lt 0 -or $r + $r1 -ge $rows -or $r + $r2 -lt 0 -or $r + $r2 -ge $rows) {
            continue
        }

        if ($c + $c1 -lt 0 -or $c + $c1 -ge $columns -or $c + $c2 -lt 0 -or $c + $c2 -ge $columns) {
            continue
        }

        if ($data[$r + $r1][$c + $c1] -eq "S" -and $data[$r + $r2][$c + $c2] -eq "M") {
            $crossFound++
        } elseif ($data[$r + $r1][$c + $c1] -eq "M" -and $data[$r + $r2][$c + $c2] -eq "S") {
            $crossFound++
        }
    }

    if ($crossFound -eq 2) {
        return 1
    }

    return 0
}
#endregion

#region Main
$data = Get-Content -Path ($(if ($TESTING) { "test.txt" } else { "input.txt" }))

$columns = $data[0].Length
$rows = $data.Length

for ($row = 0; $row -lt $rows; $row++) {
    for ($col = 0; $col -lt $columns; $col++) {
        $XMAS_occurence += Search-XMAS -r $row -c $col -data $data -rows $rows -columns $columns
        $cross_MAS_occurence += Search-CrossMAS -r $row -c $col -data $data -rows $rows -columns $columns
    }
}

Write-Host "Part One Answer: $XMAS_occurence"
Write-Host "Part Two Answer: $cross_MAS_occurence"
#endregion
