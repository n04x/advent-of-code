#region Parameters
$TESTING = $false
$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$TotalPoints = 0
$winningCards = [System.Collections.Generic.List[string]]::New()
$numberRegEx = "\d+"
#endregion

#region Functions
function Get-PartOneAnswer {
    param($lines)
    
    foreach($line in $lines) {
        $cardNumber = $line.Split(":")[0]
        $scratchCard = $line.Split(":")[1].Split("|")

        $pts = 0

        $winningNumbers = [regex]::Matches($scratchCard[0], $numberRegEx)
        $numbersWeHave = [regex]::Matches($scratchCard[1], $numberRegEx)
        $cardIndex = [regex]::Matches($cardNumber, $numberRegEx)
        
        $compareParams = @{
            ReferenceObject = $numbersWeHave.Value
            DifferenceObject = $winningNumbers.Value
            ExcludeDifferent = $true
            IncludeEqual = $true
        }
        $sameNumbers = (Compare-Object @compareParams).InputObject

        if($sameNumbers) {
        $winningCards.Add($cardIndex) 
        } else { 
            continue 
        }

        $pts = 1

        for($i = 0; ($i -lt ($sameNumbers.Count - 1)); $i++) {
            $pts = $pts * 2
        }

        $TotalPoints += $pts
    }
    return $TotalPoints, $winningCards
}

function Find-WinningCard {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Lines,
        [Parameter(Mandatory)]
        $Card
    )
    if(($Card - 1) -gt $Lines.Count) {
        return
    }

    $line = $Lines[[int]$Card - 1]
    if(!$line) {
        return
    }

    $cardNumber = $line.Split(':')[0]
    $scratchCard = $line.Split(':')[1].Split("|")

    $winningNumbers = [regex]::Matches($scratchCard[0], $numberRegEx)
    $NumbersWeHave = [regex]::Matches($scratchCard[1], $numberRegEx)
    $cardIndex = [regex]::Matches($cardNumber, $AllNumbers)

    $compareParams = @{
        ReferenceObject = $NumbersWeHave.Value
        DifferenceObject = $winningNumbers.Value
        ExcludeDifferent = $true
        IncludeEqual = $true
    }

    $sameNumbers = (Compare-Object @compareParams).InputObject

    if($sameNumbers) {
        $cardData = [PSCustomObject]@{
            cardNumber = $cardIndex.Value
            Matches = (([int]$Card +1)..($sameNumbers.Count + $Card))
            RepeatCount = 1
        }
    } else {
        $cardData = [PSCustomObject]@{
            CardNumber = $cardIndex.Value
            Matches = @()
            RepeatCount = 1
        }
    }

    return $cardData

}
function Get-PartTwoAnswer {
    param ($lines)
    $outputs = [System.Collections.Generic.List[pscustomobject]]::New()
    # Get list of all matches 
    for($Card = 0; $Card -le $lines.Count; $Card++) {
        $outputs.Add((Find-WinningCard $lines ($Card + 1)))
    }
    # Iterate over each card
    for($MatchedData = 0; $MatchedData -le $outputs.Count - 1; $MatchedData++) {
        # Extract Card Details
        $winningCards = $outputs[$MatchedData]

        # Repeat count will be 1 if there are matches.
        if($WinningCard.RepeatCount -eq 0) {
            continue
        }

        # Iterate over each winning card
        foreach($RecursiveCard in $winningCards.Matches) {

            # Repeat for each repeat count, add one to each matching number
            for($repeat = 1; $repeat -le $winningCards.RepeatCount; $repeat++) {
                $outputs[($RecursiveCard - 1)].RepeatCount++
            }
        }
    }
    return $outputs
}


#endregion

#region Script
if($TESTING) {
    $data = Get-Content "$scriptPath\test.txt"
} else {
    $data = Get-Content "$scriptPath\input.txt"
}

$TotalPoints, $winningCards = Get-PartOneAnswer $data
Write-Host "The answer for the part one is $TotalPoints" -ForegroundColor Green
$outputsResult = Get-PartTwoAnswer $data
$part2_ans = ($outputsResult | Measure-Object RepeatCount -Sum).Sum
Write-Host "The answer for the part two is: $($part2_ans)"
#endregion

