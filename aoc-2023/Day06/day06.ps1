#region Parameters
$TESTING = $false
$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$answer_p1 = 0
#endregion

#region Function

function Get-DataSheetValues {
    param($d)
    $result = [System.Collections.Generic.List[array]]::New()

    $times = $d[0].Split(":").Trim().Split(" ") | Where-Object {$_ -and ($_ -ne "Time") }
    $result.Add($times)
    $distances = $d[1].Split(":").Trim().Split(" ") | Where-Object {$_ -and ($_ -ne "Distance") }
    $result.Add($distances)

    return $result
}

function Get-WaysToWin {
    param($infoSheet)
    $result = @()
    Write-Host $infoSheet[0][0]
    for($race = 0; $race -lt $infoSheet[0].Count; $race++) {
        $raceMaxTime = $infoSheet[0][$race]
        $raceDistanceRecord = $infoSheet[1][$race]
        $currentWayToWin = 0

        for($holdButtonTime = 0; $holdButtonTime -lt $raceMaxTime; $holdButtonTime++) {
            $currentDistance = $holdButtonTime * ($raceMaxTime - $holdButtonTime)
            
            if($currentDistance -gt $raceDistanceRecord) { $currentWayToWin++ }
        }

        $result += $currentWayToWin
    }
    Write-Host "result: $result"
    return $result
}

#endregion

#region Script
if($TESTING) {
    $data = Get-Content "$scriptPath\test.txt"
} else {
    $data = Get-Content "$scriptPath\input.txt"
}

$informationSheet = Get-DataSheetValues $data
$wayToWins = Get-WaysToWin $informationSheet

foreach($val in $wayToWins) {
    if($answer_p1 -eq 0) {
        $answer_p1 = $val
    } else {
        $answer_p1 = $answer_p1 * $val
    }
}
Write-Host "The answer for the part one is $answer_p1" -ForegroundColor Green

#endregion