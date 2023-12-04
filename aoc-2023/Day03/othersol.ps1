$i=0
$content = Get-Content "$PSScriptRoot/test.txt" |?{$_}|%{
    ([regex]'(?<number>\d+)|(?<symbol>[@*/&#%+=$-])').Matches($_)|%{
        if($_.Groups[1].Success){
            [pscustomobject]@{type = "number";rows = ($i-1)..($i+1);columns = ($_.Index-1)..($_.Index + $_.Length);value = $_.Value -as [int]}
        } else {
            [pscustomobject]@{type = "symbol";row = $i;column = $_.Index;value = $_.Value}
        }
    }
    $i++
}

Write-Host "part 1: " -NoNewline
$symbols = $content |? type -eq symbol
$content |? type -eq number |? {foreach($symbol in $symbols){if($symbol.row -in $_.rows -and $symbol.column -in $_.columns){$true}}} | Measure-Object -Property value -Sum |% Sum

Write-Host "part 2: " -NoNewline
$symbols = $content |? value -eq '*'
@(foreach($symbol in $symbols){
    $cogs = @($content|? type -eq number|? { $symbol.row -in $_.rows -and $symbol.column -in $_.columns })
    if($cogs.Count -eq 2){
        $cogs[0].value * $cogs[1].value
    }
})| Measure-Object -Sum |% Sum

3
