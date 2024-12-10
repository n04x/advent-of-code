#region Parameters
$day = "03"
$title = "Day 3: Mull It Over"
$testing = $false
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$mulRegex = "mul\((\d+)\,(\d+)\)|do\(\)|don't\(\)"
$enabled = $true
#endregion

#region Modules
Import-Module -Name "$scriptPath/modules/OpenFile.psm1" -Force
Import-Module -Name "$scriptPath/modules/WriteOutcome.psm1" -Force
#endregion

#region Functions
function Get-Multiplication {
    param($data)
    $results = [ordered]@{
        PartOne = 0
        PartTwo = 0
    }
    $instructions = Select-String -InputObject $data -Pattern $mulRegex -AllMatches

    foreach($inst in $instructions.Matches.Value) {
        if($inst -like "mul(*") {
            $values = (Select-String -InputObject $inst -Pattern "\d+" -AllMatches).Matches.Value
            $results['PartOne'] += ([int]$values[0] * [int]$values[1])
            if($enabled) {
                $results['PartTwo'] += ([int]$values[0] * [int]$values[1])
            }
        }
        elseif($inst -eq "do()") { $enabled = $true } 
        elseif($inst -eq "don't()") { $enabled = $false }
    }
    return New-Object psobject -Property $results
}
#endregion

#region Main
$data = Open-DataFile -DayNumber $day -Testing $testing -ScriptPath $scriptPath
$answers = Get-Multiplication $data
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 161 -Answer $answers.PartOne -Part 1
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 48 -Answer $answers.PartTwo -Part 2

#endregion