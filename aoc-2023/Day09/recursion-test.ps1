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
$val1 = @(0, 3, 6, 9, 12, 15)
$val2 = @(1, 3, 6, 10, 15, 21)
$val3 = @(10, 13, 16, 21, 30, 45)
$score = Find-Recursion $val1 @()
$score += Find-Recursion $val2 @()
$score += Find-Recursion $val3 @()

Write-Host "Total score: $score"