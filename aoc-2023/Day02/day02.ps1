#region Functions
function Get-Cubes {
    param($line)
    $impossible = $false
    $game, $cubes = $line.Split(':').Trim()
    $cube_drawing = $cubes.Split(';').Trim()
    foreach($cd in $cube_drawing) {
        $cube_result = $cd.Split(',').Trim()
        foreach($cr in $cube_result) {
            $amount, $color = $cr.Split(' ').Trim()
            $amountInt = [int]$amount
            if($amountInt -gt $MAX_CUBES.$color) {
                $impossible = $true
            }
        }
    }
    if(!$impossible) {
        $val = $game.Split(' ')
        return $val[1]
    } else {
        return 0
    }
}

function Get-FewestCubeValue {
    param($line)
    $FEWEST_CUBES = @{'red' = 0; 'green' = 0; 'blue' = 0}
    $game, $cubes = $line.Split(':').Trim()
    foreach($c in $cubes) {
        $amt_col = ($c -split ",|;").Trim() 
        foreach($val in $amt_col) {
            $amount, $color = $val.Split()
            $amountInt = [int]$amount
            if($amountInt -gt $FEWEST_CUBES.$color) {
                $FEWEST_CUBES[$color] = $amountInt
            }            
        }
    }
    $result = $FEWEST_CUBES['red'] * $FEWEST_CUBES['green'] * $FEWEST_CUBES['blue']
    return $result
}
#endregion

#region Parameters
$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$TESTING = $false
$MAX_CUBES = @{'red' = 12; 'green' = 13; 'blue' = 14}
$total_p1 = 0
$total_p2 = 0
#endregion

#region Script
if($TESTING) {
    $data = Get-Content -Path "$scriptPath\test.txt"
} else {
    $data = Get-Content -Path "$scriptPath\input.txt"
}

foreach($d in $data) {
    $total_p1 += Get-Cubes $d
    $total_p2 += Get-FewestCubeValue $d
}
Write-Host "The answer for the part 1 is $total_p1"
Write-Host "The answer for the part 2 is $total_p2"
#endregion