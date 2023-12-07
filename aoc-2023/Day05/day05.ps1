#region Parameters
$TESTING = $true
$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$Seeds = New-Object 'System.Collections.Generic.List[System.Object]'
$SeedsToSoil = New-Object 'System.Collections.Generic.List[System.Object]'
$SoilToFertilizer = New-Object 'System.Collections.Generic.List[System.Object]'
#endregion

#region Function

#endregion

#region Script
if($TESTING) {
    $data = Get-Content "$scriptPath\test.txt"
} else {
    $data = Get-Content "$scriptPath\input.txt"
}

$DigitRegex = "\d+"
$HeaderRegex = "^(.*):$"

# Parse seeds
$SeedRow = [regex]::Matches($Data[0], $DigitRegex)

foreach ($Seed in $SeedRow) {
    $Seeds.Add($Seed)
}
for($l = 0; $l -lt $data.Length; $l++) {
    $header = [regex]::Matches($data[$l], $HeaderRegex)
    if($header.Success) {
        Write-Host $header.Value 
        do {
            $l++
            $isDigit = [regex]::Matches($data[$l], $DigitRegex)
            Write-Host $data[$l]
        } while($isDigit.Success)
    }
}
#endregion