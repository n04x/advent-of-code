$i = 0
$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$TESTING = $false

if($TESTING) {$filePath = "$scriptPath\test.txt"} else {$filePath = "$scriptPath\input.txt"}

$content = Get-Content $filePath | Where-Object {$_}| ForEach-Object {
    ([regex]'(?<number>\d+)|(?<symbol>[@*/&#%+=$-])').Matches($_)| ForEach-Object {
        if($_.Groups[1].Success){
            [pscustomobject]@{
                type = "number";
                rows = ($i-1)..($i+1);
                columns = ($_.Index-1)..($_.Index + $_.Length);
                value = [int]$_.Value
            }
        } else {
            [pscustomobject]@{
                type = "symbol";
                row = $i;column = $_.Index;
                value = $_.Value
            }
        }
    }
    $i++
}

Write-Host "The answer for the part 1 is: " -NoNewline -ForegroundColor Green
$symbols = $content | Where-Object type -eq symbol
$content | Where-Object type -eq number | Where-Object {
    foreach($symbol in $symbols) {
        if($symbol.row -in $_.rows -and $symbol.column -in $_.columns) {
            $true
        }
    }
} | Measure-Object -Property value -Sum | ForEach-Object Sum 
