#region Parameters
$TESTING = $false
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
    param($inst, $nodesList, $startNode)
    $goalReached = $false
    $index = 0
    $nextNode = $startNode
    $result = 0
    do {
        foreach($node in $nodesList) {
            if($node.Node -eq $nextNode) {
                if($nextNode -notlike "*A") {
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
        if($node.Node -like "*Z") {
            $goalReached = $true
        } else {
            $index = ($index + 1) % $inst.Length
        }

    }while(!$goalReached)

    return $result
}

function Get-AnswerP2 {
    param($inst, $nodesList)
    $startingNodes = @()
    foreach($node in $nodesList) {
        if($node.Type -eq "Start") {
            $startingNodes += $node
        }
    }
    $stepsPerNode = @()
    foreach($node in $startingNodes) {
        $stepsPerNode += Get-Steps $inst $nodesList $node.Node
    }
    $result = Find-LCM $stepsPerNode
    Write-Host "The result is $result for $stepsPerNode"
    return $result
}
Function Find-LCM {
    PARAM ($values)
    $array=@()
    $product=1
    $Numbers = $values
    foreach ($Number in $Numbers) {
        $sqrt=[math]::sqrt($number)
        $Factor=2
        $count=0
        while ( ($Number % $Factor) -eq 0) {
            $count+=1
            $Number=$Number/$Factor
            if (($array | Where-Object {$_ -eq $Factor}).count -lt $count) {
                $array+=$Factor
            }
        }
        $count=0
        $Factor=3
        while ($Factor -le $sqrt) {
            while ( ($Number % $Factor) -eq 0) {
                $count+=1
                $Number=$Number/$Factor
                if (($array | Where-Object {$_ -eq $Factor}).count -lt $count) {
                    $array+=$Factor
                    }
                }           
            $Factor+=2
            $count=0
        }
        if ($array -notcontains $Number) {
            $array+=$Number
        }
    }
    foreach($arra in $array) {$product = $product * $arra}
    return $product
}
#endregion

#region Script
if($TESTING) { 
    $data = Get-Content "$scriptPath\test.txt" 
} else { 
    $data = Get-Content "$scriptPath\input.txt" 
}

$instructions, $nodes = Get-Data $data
$answer_p1 = Get-Steps $instructions $nodes "AAA"
Write-Host "The answer for the part one is $answer_p1" -ForegroundColor Green

# Below are information used for testing purpose only.
if($TESTING) {
    $data_P2Test = Get-Content "$scriptPath\testp2.txt"
    $instructions_p2, $nodes_p2 = Get-Data $data_P2Test
    $answer_p2 = Get-AnswerP2 $instructions_p2 $nodes_p2
} else {
    $answer_p2 = Get-AnswerP2 $instructions $nodes
}
Write-Host "The answer for the part two is $answer_p2" -ForegroundColor Green

#endregion