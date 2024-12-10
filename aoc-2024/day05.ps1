#region Parameters
$day = "05"
$title = "Day 5: Print Queue"
$testing = $true
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$pageRules = @()
$pageUpdates = @()
$middlePageNumber = 0
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
                    Orders = $splitLine
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
#endregion

#region Main
$data = Open-DataFile -DayNumber $day -Testing $testing -ScriptPath $scriptPath
$pageRules, $pageUpdates = New-PagesOrderData $data
$sortedRules = $pageRules | Sort-Object Before | Group-Object Before -AsHashTable

foreach($update in $pageUpdates) {
    if(Test-Validity $sortedRules $update.Orders) {
        $middlePageNumber += Get-MiddlePage $update.Orders
    }
}
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 143 -Answer $middlePageNumber -Part 1
#endregion