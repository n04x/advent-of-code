#region Parameters
$day = "04"
$title = "Day 4: Ceres Search"
$testing = $false
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

$XMAS = 0
#endregion

#region Modules
Import-Module -Name "$scriptPath/modules/OpenFile.psm1" -Force
Import-Module -Name "$scriptPath/modules/WriteOutcome.psm1" -Force
#endregion

#region Functions
function Get-XMAS {
    param ($r, $c)
    $keyword = "XMAS"
    $xmas_found = 0
    $directions = @(
        @(-1, 0), @(1, 0), @(0, -1), @(0, 1), @(-1, -1), @(-1, 1), @(1, -1), @(1, 1)
        )
    if($data[$r][$c] -ne $keyword[0]) {
        return 0
    }

    foreach($dir in $directions) {
        $i_XMAS = 1
        $checkRow = $r + $dir[0]
        $checkCol = $c + $dir[1]

        while ($i_XMAS -lt $keyword.Length) {
            if($checkRow -lt 0 -or $checkRow -ge $rows -or $checkCol -lt 0 -or $checkCol -ge $columns) {
                break
            }

            if($data[$checkRow][$checkCol] -ne $keyword[$i_XMAS]) {
                break
            }

            $i_XMAS++
            $checkRow += $dir[0]
            $checkCol += $dir[1]
        }

        if($i_XMAS -eq $keyword.Length) {
            $xmas_found++
        }
    }
    return $xmas_found
}

function  Get-CrossMAS {
    param ($r, $c)
    $xmas_found = 0
    $directions = (@(-1,-1,1,1), @(-1,1,1,-1))
    if($data[$r][$c] -ne "A") {
        return 0
    }
    foreach($dir in $directions) {
        if($r + $dir[0] -lt 0 -or $r + $dir[0] -ge $rows) { continue }
        if($r + $dir[2] -lt 0 -or $r + $dir[2] -ge $rows) { continue }
        if($c + $dir[1] -lt 0 -or $c + $dir[1] -ge $columns) { continue }
        if($c + $dir[3] -lt 0 -or $c + $dir[3] -ge $columns) { continue }

        if(($data[$r+$dir[0]][$c+$dir[1]] -eq "S") -and ($data[$r+$dir[2]][$c+$dir[3]] -eq "M")) {
            $xmas_found++
        }
        elseif(($data[$r+$dir[0]][$c+$dir[1]] -eq "M") -and ($data[$r+$dir[2]][$c+$dir[3]] -eq "S")) {
            $xmas_found++
        }
    }
    if($xmas_found -eq 2) {
        return 1
    }
    return 0

}
#endregion

#region Main
$data = Open-DataFile -DayNumber $day -Testing $testing -ScriptPath $scriptPath
$columns = $data[0].Length
$rows = $data.Length

for($row = 0; $row -lt $rows; $row++) {
    for($col = 0; $col -lt $columns; $col++) {
        $XMAS += Get-XMAS $row $col
        $crossMAS += Get-CrossMAS $row $col
    }
}
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 18 -Answer $XMAS -Part 1
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 9 -Answer $crossMAS -Part 2
# Get-XMAS $data $data.Count $data[0].Length
#endregion