#region Parameters
$TESTING = $true
$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
#endregion

#region Functions
function Get-Data {
    param($d)
    $result = @()
    foreach($line in $d) {
        $result += $line
    }
    return $result
}

function Get-Values {
    param([int[]]$values)
    $differences = @()
    for($i = 0; $i -lt $values.Count -1; $i++) {
        $difference = $values[$i + 1] - $values[$i]
        $differences += $difference
    }
    Write-Host "The differences are: $differences"
    if($differences -notcontains 0) {
        Write-Host "Difference doesn't have zero!" -ForegroundColor Red
        $history = Get-Values $differences
    } else {
        Write-Host "Difference are all zero'd" -ForegroundColor Green
        return $history
    }
}
#endregion

#region Script
if($TESTING) { 
    $data = Get-Content "$scriptPath\test.txt" 
} else { 
    $data = Get-Content "$scriptPath\input.txt" 
}

$lines = Get-Data $data
foreach($line in $lines) {
    $histories = Get-Values $line.Split(' ')
    Write-Host $histories.Count -ForegroundColor Cyan
}
#endregion