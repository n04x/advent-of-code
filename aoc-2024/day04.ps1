#region Parameters
$day = "04"
$title = "Day 4: Ceres Search"
$testing = $false
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$directions = @(
    @(-1, 0), @(1, 0), @(0, -1), @(0, 1), @(-1, -1), @(-1, 1), @(1, -1), @(1, 1)
    )
$XMAS = 0
#endregion

#region Modules
Import-Module -Name "./modules/OpenFile.psm1" -Force
Import-Module -Name "./modules/WriteOutcome.psm1" -Force
#endregion

#region Functions
function Get-XMAS {
    param ($r, $c)
    $keyword = "XMAS"

    if($data[$r][$c] -ne $keyword[0]) {
        return 0
    }

    $xmas_found = 0
    foreach($dir in $directions) {
        $i_XMAS = 1
        $checkRow = $r + $dir[0]
        $checkCol = $c + $dir[1]

        while ($i_XMAS -lt $keyword.Length) {
            if($checkRow -lt 0 -or $checkRow -ge $rows -or $checkCol -lt 0 -or $checkRow -ge $columns) {
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
#endregion

#region Main
$data = Open-DataFile -DayNumber $day -Testing $testing -ScriptPath $scriptPath
$columns = $data[0].Length
$rows = $data.Length

for($row = 0; $row -lt $rows; $row++) {
    for($col = 0; $col -lt $columns; $col++) {
        $XMAS += Get-XMAS $row $col
    }
}
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 18 -Answer $XMAS -Part 1
# Get-XMAS $data $data.Count $data[0].Length
#endregion