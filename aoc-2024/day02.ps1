#region Parameters
$day = "02"
$title = "Day 2: Red-Nosed Reports"
$testing = $false
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$safeReports = 0
$dampenedSafeReports = 0
#endregion

#region Modules
Import-Module -Name "./modules/OpenFile.psm1" -Force
Import-Module -Name "./modules/WriteOutcome.psm1" -Force
#endregion

#region Functions
function Test-Safety {
    param ($rep)
    $differences = @()
    for($i = 1; $i -lt $rep.Count; $i++) {
        $differences += ($rep[$i] - $rep[$i-1])
    }
    $diffMinMax = $differences | Measure-Object -Minimum -Maximum
    if($diffMinMax.Minimum -gt 0 -and $diffMinMax.Minimum -lt 4 -and $diffMinMax.Maximum -gt 0 -and $diffMinMax.Maximum -lt 4) { return $true }
    elseif($diffMinMax.Minimum -lt 0 -and $diffMinMax.Minimum -gt -4 -and $diffMinMax.Maximum -lt 0 -and $diffMinMax.Maximum -gt -4) { return $true }
    else { return $false }
}

function Set-SafetyDampener {
    param($rep)
    for($i = 0; $i -lt $rep.Count; $i++) {
        [System.Collections.ArrayList]$dampenedReport =$rep
        $dampenedReport.RemoveAt($i)
        if(Test-Safety $dampenedReport) {
            return $true
        }
    }
    return $false
}
#endregion

#region Main
$data = Open-DataFile -DayNumber $day -Testing $testing -ScriptPath $scriptPath
foreach($line in $data) {
    $report = $line.Split(" ")
    if(Test-Safety $report) {
        $safeReports++
    } elseif (Set-SafetyDampener $report) {
        $dampenedSafeReports++
    }
}
$totalSafeReports = $safeReports + $dampenedSafeReports
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 2 -Answer $safeReports -Part 1
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 4 -Answer $totalSafeReports -Part 2

#endregion