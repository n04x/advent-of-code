#region Parameters
$TESTING = $false
$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$OASISReports = @()
$extrapolatedVal = 0
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

function Get-OASISReports {
    param($l)
    $result = @()
    for($i = 0; $i -lt $l.Count; $i++) {
        $props = [ordered]@{
            History = [int[]]$lines[$i].Split(' ')
            Previous = @()
        }
        $result += New-Object -TypeName psobject -Property $props
    }
    return $result
}

function Get-ExtrapolateHistory {
    param ($history, $previous)
    $prev = $previous
    $current = $history
    $difference = @()
    for($i = 0; $i -lt $current.Count - 1; $i++) {
        $difference += $current[$i + 1] - $current[$i]
    }
    if(($difference | Where-Object {$_ -eq 0}).Count -eq $difference.Count) {
        return $current[-1] + $prev[-1]
    } else {
        return $prev[-1] + (Get-ExtrapolateHistory $difference $current)
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
$OASISReports = Get-OASISReports $lines
foreach($report in $OASISReports) {
    $extrapolatedVal += Get-ExtrapolateHistory $report.History $report.Previous
}
Write-Host "The answer for the part one is $extrapolatedVal" -ForegroundColor Green
#endregion