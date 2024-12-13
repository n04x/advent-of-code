#region Parameters
$day = "07"
$title = "Day 7: Bridge Repair"
$testing = $true
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
    param($data)
    [long]$equalTo = $equation.Split(':')[0].Trim() # use long instead since there's some value that are larger than int.
    $statement = $equation.Split(':')[1].Trim().Split(' ')

    [System.Collections.ArrayList]$qStatement = @(,@(0,[long]$statement[0]))

    while($qStatement) {
        [long]$currentNumber = $qStatement[0][1]
        $index = $qStatement[0][0] + 1
        $qStatement.RemoveAt(0)

        [long]$add = $currentNumber + $statement[$index]
        [long]$multi = $currentNumber * $statement[$index]

        if($index -eq $statement.Count - 1) {
            if($add -eq $equalTo) {
                return $add
            } elseif($multi -eq $equalTo) {
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
Write-Host $sumOfValidEquation
#endregion