#region Parameters
$day = "07"
$title = "Day 7: Bridge Repair"
$testing = $false
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
[long]$sumOfValidEquation = 0
#endregion

#region Modules
Import-Module -Name "$scriptPath/modules/OpenFile.psm1" -Force
Import-Module -Name "$scriptPath/modules/WriteOutcome.psm1" -Force
#endregion

#region Functions

#endregion 
function Get-ValidEquation {
    param($eq)
    [long]$result = $eq.Split(':')[0].Trim() # use long instead since there's some value that are larger than int.
    $statement = $eq.Split(':')[1].Trim().Split(' ')

    [System.Collections.ArrayList]$qStatement = @(,@(0,[long]$statement[0]))

    while($qStatement) {
        [long]$currentNumber = $qStatement[0][1]
        $index = $qStatement[0][0] + 1
        $qStatement.RemoveAt(0)

        [long]$add = $currentNumber + $statement[$index]
        [long]$multi = $currentNumber * $statement[$index]

        if($index -eq $statement.Count - 1) {
            if($add -eq $result) {
                Write-Host $qStatement -ForegroundColor Cyan
                return $add
            } elseif($multi -eq $result) {
                Write-Host $qStatement -ForegroundColor Cyan
                return $multi
            }
        } else {
            if($add -le $result) { $qStatement.Add(@($index,$add)) | Out-Null }
            if($multi -le $result) { $qStatement.Add(@($index,$multi)) | Out-Null }
        }
    }
}
#region Main
$data = Open-DataFile -DayNumber $day -Testing $testing -ScriptPath $scriptPath
foreach($equation in $data) {
    $sumOfValidEquation += Get-ValidEquation $equation
}
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 3749 -Answer $sumOfValidEquation -Part 1

#endregion