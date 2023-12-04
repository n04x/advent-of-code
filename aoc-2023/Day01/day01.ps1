#region Functions
function Get-Integers {
    param([string]$str)
    $result = $str -replace '\D+'
    return $result
}

function Get-Values {
    param($values)
    $result = "$($values[0])$($values[-1])"
    return $result
}

function Get-NewString {
    param($str) 
    $str = $str -replace 'one', 'o1e'
    $str = $str -replace 'two', 't2o'
    $str = $str -replace 'three', 't3e'
    $str = $str -replace 'four', 'f4r'
    $str = $str -replace 'five', 'f5e'
    $str = $str -replace 'six', 's6x'
    $str = $str -replace 'seven', 's7n'
    $str = $str -replace 'eight', 'e8t'
    $str = $str -replace 'nine', 'n9n'
    return $str
}
#endregion

#region Parameters
$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$TESTING = $false
$sum_p1 = 0
$sum_p2 = 0
#endregion

#region Script
if($TESTING) {
    $data = Get-Content -Path "$scriptPath\test.txt"
} else {
    $data = Get-Content -Path "$scriptPath\input.txt"
}

# Part 1
foreach($d in $data) {
    $values = Get-Integers $d
    $sum_p1 += Get-Values $values
}

# Part 2
foreach($d in $data) {
    $newD = Get-NewString $d
    $values = Get-Integers $newD
    $sum_p2 += Get-Values $values
}
Write-Host "The answer for the part 1 is $sum_p1"
Write-Host "The answer for the part 2 is $sum_p2"
#endregion
