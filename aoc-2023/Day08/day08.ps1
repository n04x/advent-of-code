#region Parameters
$TESTING = $true
$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$nodes = @()
#endregion

#region Functions
function Get-Data {
    param ($d)
    $result = @()
    $dataArray = $d.Split("`n",[System.StringSplitOptions]::RemoveEmptyEntries).Trim()
    $instructions = $dataArray[0]
    for($i = 1; $i -lt $dataArray.Count; $i++) {
        $elements = $dataArray[$i].Split('=')[1].Replace('(','').Replace(')','').Split(',').Trim()
        if($dataArray[$i].Split("=")[0].Trim() -like "*A") {
            $type = "Start"
        } elseif ($dataArray[$i].Split("=")[0].Trim() -like "*Z") {
            $type = "End"
        } else {
            $type = "Mid"
        }
        $props = [ordered]@{
            Node = $dataArray[$i].Split("=")[0].Trim()
            Type = $type
            Left = $elements[0]
            Right = $elements[1]
        }
        $result += New-Object -TypeName psobject -Property $props
    }
    return $instructions, $result
    
}
function Get-Steps {
    param($inst, $nodesList)
    $goalReached = $false
    $index = 0
    $nextNode = "AAA"
    $result = 0
    do {
        foreach($node in $nodesList) {
            if($node.Node -eq $nextNode) {
                if($nextNode -ne "AAA") {
                    $result++
                }
                if($inst[$index] -eq "L") { 
                    $nextNode = $node.Left
                } else { 
                    $nextNode = $node.Right
                }
                break
            }
        }
        if($node.Node -eq "ZZZ") {
            $goalReached = $true
        } else {
            $index = ($index + 1) % $inst.Length
        }

    }while(!$goalReached)

    return $result
}
#endregion

#region Script
if($TESTING) { 
    $data = Get-Content "$scriptPath\test.txt" 
    $data_P2Test = Get-Content "$scriptPath\testp2.txt"
} else { 
    $data = Get-Content "$scriptPath\input.txt" 
}

$instructions, $nodes = Get-Data $data
$nodes | Format-Table
$answer_p1 = Get-Steps $instructions $nodes
Write-Host "The answer for the part one is $answer_p1" -ForegroundColor Green

# Below are information used for testing purpose only.
$nodes | Format-Table
#endregion