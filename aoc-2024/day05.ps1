#region Parameters
$day = "05"
$title = "Day 5: Print Queue"
$testing = $false
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$pageRules = @()
$pageUpdates = @()
$middlePageScorePartOne = 0
$middlePageScorePartTwo = 0
#endregion

#region Modules
Import-Module -Name "$scriptPath/modules/OpenFile.psm1" -Force
Import-Module -Name "$scriptPath/modules/WriteOutcome.psm1" -Force
#endregion

#region Functions
function New-PagesOrderData {
    param ($data)
    $pr = @()
    $po = @()
    foreach($line in $data) {
        switch ($line) {
            {$line.Contains('|')} { 
                # Write-Host "$line" -ForegroundColor Green 
                $splitLine = $line.Split('|')
                $rule = [PSCustomObject]@{
                    Before = $splitLine[0]
                    After = $splitLine[1]
                }
                $pr += $rule
            }
            {$line.Contains(',')} { 
                # Write-Host "$line" -ForegroundColor Yellow 
                $splitLine = $line.Split(',')
                $order = [PSCustomObject]@{
                    Orders = [System.Collections.ArrayList]$splitLine
                    Valid = $false
                }
                $po += $order
            }
            Default { continue }
        }
    }  
    return $pr, $po  
}

function Test-Validity {
    param($sRules, $pageUpd)
    foreach($val in $pageUpd) {
        $valRules = $sRules.$val.After
        $valIndex = $pageUpd.IndexOf($val)
        foreach($rule in $valRules) {
            $ruleIndex = $pageUpd.IndexOf($rule)
            if($ruleIndex -eq -1) { continue }
            if($ruleIndex -lt $valIndex) { return $false }
        }
    }
    return $true
}

function Get-MiddlePage {
    param($up)
    return [int]$up[[System.Math]::Floor($up.Count / 2)]
}

function Update-PageOrders {
    param($sRules, $pageUpd)
    for($i = 0; $i -lt $pageUpd.Count; $i++) {
        $val = $pageUpd[$i]
        $valRules = $sRules.$val.After
        $valIndex = $pageUpd.IndexOf($val)

        foreach($rule in $valRules) {
            $ruleIndex = $pageUpd.IndexOf($rule)
            if($ruleIndex -eq -1) { continue }
            if($ruleIndex -lt $valIndex) { 
                $pageUpd.Remove($val)
                $pageUpd.Insert($ruleIndex, $val)
            }
        }

    }
}
#endregion

#region Main
$data = Open-DataFile -DayNumber $day -Testing $testing -ScriptPath $scriptPath
$pageRules, $pageUpdates = New-PagesOrderData $data
$sortedRules = $pageRules | Sort-Object Before | Group-Object Before -AsHashTable

foreach($update in $pageUpdates) {
    if(Test-Validity $sortedRules $update.Orders) {
        $middlePageScorePartOne += Get-MiddlePage $update.Orders
    } else {
        do {
            Update-PageOrders $sortedRules $update.Orders
        } while (!(Test-Validity $sortedRules $update.Orders))
        $middlePageScorePartTwo += Get-MiddlePage $update.Orders
    }
}

Write-Answer -Title $title -Testing $testing -ExpectedAnswer 143 -Answer $middlePageScorePartOne -Part 1
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 123 -Answer $middlePageScorePartTwo -Part 2
#endregion