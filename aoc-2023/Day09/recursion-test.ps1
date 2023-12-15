function Find-Recursion {
    param($array, $previous)
    $prev = $previous
    $current = $array
    $difference = @()
    $result = 0
    for($i = 0; $i -lt $current.Count - 1; $i++) {
        $difference += $current[$i+1] - $current[$i] 
    }
    if(($difference | Where-Object {$_ -eq 0}).Count -eq $difference.Count) {
        # Write-Host "$difference" -ForegroundColor Green
        return $current[-1] + $prev[-1]
    } else {
        # Write-Host "$difference" -ForegroundColor Red
        $prev = $current
        $nextIteration = $difference
        return $previous[-1] + (Find-Recursion $nextIteration $prev)
    }
}

function Find-RecursionP2 {
    param($array, $previous)
    $prev = $previous
    $current = $array
    $difference = @()
    for($i = 0; $i -lt $current.Count - 1; $i++) {
        $difference += $current[$i+1] - $current[$i] 
    }
    if(($difference | Where-Object {$_ -eq 0}).Count -eq $difference.Count) {
        $current = $difference
        return  $array[0] - $difference[0]
    } else {
        $prev = $current
        $nextIteration = $difference
        return $current[0] - (Find-RecursionP2 $nextIteration $prev)
    }
}
$val1 = @(0, 3, 6, 9, 12, 15)
$val2 = @(1, 3, 6, 10, 15, 21)
$val3 = @(10, 13, 16, 21, 30, 45)
# Part One
# $score = Find-Recursion $val1 @()
# $score += Find-Recursion $val2 @()
# $score += Find-Recursion $val3 @()
# Write-Host "Total score: $score"


$valScore = @()
Write-Host "Doing $val1" -ForegroundColor Cyan
$valScore += Find-RecursionP2 $val1 @()
Write-Host "Doing $val2" -ForegroundColor Cyan
$valScore += Find-RecursionP2 $val2 @()
Write-Host "Doing $val3" -ForegroundColor Cyan
$valScore += Find-RecursionP2 $val3 @()

if($valScore[0] -eq -3) {
    Write-Host "Value 1 Score: $($valScore[0])" -ForegroundColor Green
} else {
    Write-Host "Value 1 Score: $($valScore[0])" -ForegroundColor Red
}

if($valScore[1] -eq 0) {
    Write-Host "Value 2 Score: $($valScore[1])" -ForegroundColor Green
} else {
    Write-Host "Value 2 Score: $($valScore[1])" -ForegroundColor Red
}

if($valScore[2] -eq 5) {
    Write-Host "Value 3 Score: $($valScore[2])" -ForegroundColor Green
} else {
    Write-Host "Value 3 Score: $($valScore[2])" -ForegroundColor Red
}