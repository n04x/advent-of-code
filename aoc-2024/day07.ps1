#region Parameters
$day = "07"
$title = "Day 7: Bridge Repair"
$testing = $false
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
[long]$sumOfValidEquation = 0
[long]$sumOfValidEquationWithConcat = 0
#endregion

#region Modules
Import-Module -Name "$scriptPath/modules/OpenFile.psm1" -Force
Import-Module -Name "$scriptPath/modules/WriteOutcome.psm1" -Force
#endregion

#region Functions

#endregion 
function Get-ValidEquation {
    param($eq, $useConcat)
    [long]$result = $eq.Split(':')[0].Trim() # use long instead since there's some value that are larger than int.
    $statement = $eq.Split(':')[1].Trim().Split(' ')

    [System.Collections.ArrayList]$qStatement = @(,@(0,[long]$statement[0]))

    while($qStatement) {
        [long]$currentNumber = $qStatement[0][1]
        $index = $qStatement[0][0] + 1
        $qStatement.RemoveAt(0)

        [long]$add = $currentNumber + $statement[$index]
        [long]$multi = $currentNumber * $statement[$index]
        [long]$concat = [string]$currentNumber + [string]$statement[$index]

        if($index -eq $statement.Count - 1) {
            if($add -eq $result) {
                return $add
            } elseif($multi -eq $result) {
                return $multi
            } elseif($useConcat -and ($concat -eq $result)) {
                return $concat
            }
        } else {
            if($add -le $result) { $qStatement.Add(@($index,$add)) | Out-Null }
            if($multi -le $result) { $qStatement.Add(@($index,$multi)) | Out-Null }
            if($useConcat -and ($concat -le $result)) { $qStatement.Add(@($index,$concat)) | Out-Null }
        }
    }
}

#region Main
$data = Open-DataFile -DayNumber $day -Testing $testing -ScriptPath $scriptPath
foreach($equation in $data) {
    Write-Host $equation -ForegroundColor Cyan
    $sumOfValidEquation += Get-ValidEquation $equation $false
    $sumOfValidEquationWithConcat += Get-ValidEquation $equation $true
}
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 3749 -Answer $sumOfValidEquation -Part 1
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 11387 -Answer $sumOfValidEquationWithConcat -Part 2

#endregion