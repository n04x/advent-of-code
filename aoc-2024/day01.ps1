# Region Parameters
$day = "01"
$title = "Day 1: Historian Hysteria"
$testing = $false
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$locationIDs1 = @()
$locationIDs2 = @()

#endregion

#region Function
Import-Module -Name "./modules/OpenFile.psm1" -Force
Import-Module -Name "./modules/WriteOutcome.psm1" -Force

function Get-Distance {
    param ($ids1, $ids2)
    $result = 0
    for($i = 0; $i -lt $ids1.Count; $i++) {
        $distance = [System.Math]::Abs($ids1[$i] - $ids2[$i])
        $result += $distance 
    }
    return $result    
}

function Get-Occurence {
    param($ids1, $ids2)
    $result = 0
    $hashed_ids2 = $ids2 | Group-Object -AsHashTable
    for($i = 0; $i -lt $ids1.Count; $i++) {
        $occurence = $hashed_ids2[$ids1[$i]].Count
        $result += [int]$ids1[$i] * [int]$occurence
    }
    return $result
}
#endregion

#region Main
$data = Open-DataFile -DayNumber $day -Testing $testing -ScriptPath $scriptPath
foreach($line in $data) {
    $val1, $val2 = $line.Split('   ')
    $locationIDs1 += $val1
    $locationIDs2 += $val2
}
$sorted_locID1 = $locationIDs1 | Sort-Object
$sorted_locID2 = $locationIDs2 | Sort-Object
$totalDistance = Get-Distance $sorted_locID1 $sorted_locID2
$totalOccurence = Get-Occurence $sorted_locID1 $sorted_locID2
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 11 -Answer $totalDistance -Part 1
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 31 -Answer $totalOccurence -Part 2 
#endregion