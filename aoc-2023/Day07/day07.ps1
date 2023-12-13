#region Parameters
$TESTING = $false
$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$cardList = @("A","K","Q","J","T","9","8","7","6","5","4","3","2") # T is b, J is c, Q is d, K is e, A is f
#endregion

#region Functions
function Get-Data {
    param($d)
    $result = @()
    foreach($line in $d) {
        $lineArray = $line.Split(" ")
        $props = [ordered]@{
            Hand = $lineArray[0]
            CardValue = $lineArray[0].Replace('T','b').Replace('J','c').Replace('Q','d').Replace('K','e').Replace('A','f')
            Bid = [int]$lineArray[1]
            Rank = 0
        }
        $result += New-Object -TypeName psobject -Property $props
    }
    return $result
}

function Get-HandRank {
    param($hands)
    foreach($hand in $hands) {
        $cardCount = @()
        foreach($card in $cardList) {
            $cardCount += (($hand.Hand).ToCharArray() | Where-Object {$_ -eq $card} | Measure-Object).Count
        }
        
        if($cardCount -contains 5) { $hand.Rank = 6 } # 5 of a kind
        # if($cardCount -contains 5) { $hand.Rank = "6" + $hand.CardValue } # 5 of a kind
        elseif($cardCount -contains 4) { $hand.Rank = 5} # 4 of a kind
        # elseif($cardCount -contains 4) { $hand.Rank = "5" + $hand.CardValue } # 4 of a kind
        elseif(($cardCount -contains 3) -and ($cardCount -contains 2)) { $hand.Rank = 4 }# full house
        # elseif(($cardCount -contains 3) -and ($cardCount -contains 2)) { $hand.Rank = "4" + $hand.CardValue }# full house
        elseif($cardCount -contains 3) { $hand.Rank = 3 } # Three of a kind
        # elseif($cardCount -contains 3) { $hand.Rank = "3" + $hand.CardValue } # Three of a kind
        elseif(($cardCount | Where-Object {$_ -eq 2}).Count -eq 2) { $hand.Rank = 2 } # Two pairs
        # elseif(($cardCount | Where-Object {$_ -eq 2}).Count -eq 2) { $hand.Rank = "2" + $hand.CardValue } # Two pairs
        elseif(($cardCount | Where-Object {$_ -eq 2}).Count -eq 1) { $hand.Rank = 1 } # One pair
        # elseif(($cardCount | Where-Object {$_ -eq 2}).Count -eq 1) { $hand.Rank = "1" + $hand.CardValue } # One pair
        else {$hand.Rank = 0 }
    }
}

function Get-TotalWinnings {
    param($hStrSorted)
    $result = 0
    for($i = 0; $i -lt $hStrSorted.Count; $i++) {
        $result += $hStrSorted[$i].Bid * ($i + 1)
    }
    return $result
}
#endregion

#region Script
if($TESTING) {
    $data = Get-Content "$scriptPath\test.txt"
} else {
    $data = Get-Content "$scriptPath\input.txt"
}

$hands = Get-Data $data
Get-HandRank $hands
$handsSorted = $hands | Sort-Object Rank, CardValue
Write-Host "The answer for the part one is $(Get-TotalWinnings $handsSorted)" -ForegroundColor Green

#endregion