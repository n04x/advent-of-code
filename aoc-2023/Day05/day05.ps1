#region Parameters
$TESTING = $false
$scriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent
$Seeds = New-Object 'System.Collections.Generic.List[System.Object]'
$MappingsObject = @()
$outcomes_p1 = @()
$outcomes_p2 = @()
#endregion
function Get-Seeds {
    param($data)
    $SeedRow = [regex]::Matches($Data[0], $DigitRegex)

    foreach ($Seed in $SeedRow) {
        $Seeds.Add($Seed)
    }
}

function Get-Mappings {
    param($data)
    $result = @()
    for($line = 0; $line -lt $data.Length; $line++) {
        $header = [regex]::Matches($data[$line], $HeaderRegex)
        if($header.Success) {
            $line++;
            for($line; $line -lt $data.Length; $line++) {
                $mapping = [regex]::Matches($data[$line], $DigitRegex)
                if ($mapping.Success) {
                    $mappingProps = [ordered]@{
                        Mapping = $header.Value
                        Destination = [UInt64]($mapping.Value).Split(' ')[0]
                        Source = [UInt64]($mapping.Value).Split(' ')[1]
                        Range = [UInt64]($mapping.Value).Split(' ')[2]
                    }
                    $result += New-Object psobject -Property $mappingProps
                } else {
                    break
                }
            }
        }
    }
    return $result
}

function  Get-MappingNumber {
    param ([UInt64]$s, $maps)
    $result = $s
    foreach($map in $maps) {
        $maxSrc = ($map.Source + $map.Range -1)
        if(($s -ge $map.Source) -and ($s -le $maxSrc)) {
            $offset = $s - $map.Source
            $result = $map.Destination + $offset
        }
    }
    return $result
}

function Get-AnswerPartOne {
    param($mappingObj)
    $result = @()
    $seedToSoilMaps = $mappingObj | Where-Object {$_.Mapping -like 'seed-to-soil*'}
    $SoilToFertilizerMaps = $mappingObj | Where-Object {$_.Mapping -like 'soil-to-fertilizer*'}
    $FertilizerToWaterMaps = $mappingObj | Where-Object {$_.Mapping -like 'fertilizer-to-water*'}
    $WaterToLightMaps = $mappingObj | Where-Object {$_.Mapping -like 'water-to-light*'}
    $LightToTemperatureMaps = $mappingObj | Where-Object {$_.Mapping -like 'light-to-temperature*'}
    $TemperatureToHumidyMaps = $mappingObj | Where-Object {$_.Mapping -like 'temperature-to-humidity*'}
    $HumidityToLocationMaps = $mappingObj | Where-Object {$_.Mapping -like 'humidity-to-location*'}
    
    foreach($seed in $Seeds) {
        # Filter out mapping
        $soil = Get-MappingNumber $seed.Value $seedToSoilMaps
        $fertilizer = Get-MappingNumber $soil $SoilToFertilizerMaps
        $water = Get-MappingNumber $fertilizer $FertilizerToWaterMaps
        $light = Get-MappingNumber $water $WaterToLightMaps
        $temperature = Get-MappingNumber $light $LightToTemperatureMaps
        $humidity = Get-MappingNumber $temperature $TemperatureToHumidyMaps
        $location = Get-MappingNumber $humidity $HumidityToLocationMaps
        $props = [ordered]@{
            Seed = $seed.Value
            Soil = $soil
            Fertilizer = $fertilizer
            Water = $water
            Light = $light
            Temperature = $temperature
            Humidity = $humidity
            Location = $location
        }
        $result += New-Object psobject -Property $props
    }
    return $result
}

function Get-AnswerPartTwo {
    param ($mappingObj)
    $result = @()
    $seedToSoilMaps = $mappingObj | Where-Object {$_.Mapping -like 'seed-to-soil*'}
    $SoilToFertilizerMaps = $mappingObj | Where-Object {$_.Mapping -like 'soil-to-fertilizer*'}
    $FertilizerToWaterMaps = $mappingObj | Where-Object {$_.Mapping -like 'fertilizer-to-water*'}
    $WaterToLightMaps = $mappingObj | Where-Object {$_.Mapping -like 'water-to-light*'}
    $LightToTemperatureMaps = $mappingObj | Where-Object {$_.Mapping -like 'light-to-temperature*'}
    $TemperatureToHumidyMaps = $mappingObj | Where-Object {$_.Mapping -like 'temperature-to-humidity*'}
    $HumidityToLocationMaps = $mappingObj | Where-Object {$_.Mapping -like 'humidity-to-location*'}
    for($i = 0; $i -lt $Seeds.Value.Count; $i += 2) {
        $currentSeed = [uint64]$Seeds[$i].Value
        $maxSeed = [uint64]([uint64]$Seeds[$i].Value + [uint64]$Seeds[$i + 1].Value)
        for($seed = $currentSeed; $seed -lt $maxSeed; $seed++) {
            # Filter out mapping
            $soil = Get-MappingNumber $seed $seedToSoilMaps
            $fertilizer = Get-MappingNumber $soil $SoilToFertilizerMaps
            $water = Get-MappingNumber $fertilizer $FertilizerToWaterMaps
            $light = Get-MappingNumber $water $WaterToLightMaps
            $temperature = Get-MappingNumber $light $LightToTemperatureMaps
            $humidity = Get-MappingNumber $temperature $TemperatureToHumidyMaps
            $location = Get-MappingNumber $humidity $HumidityToLocationMaps
            $props = [ordered]@{
                Seed = $seed
                Soil = $soil
                Fertilizer = $fertilizer
                Water = $water
                Light = $light
                Temperature = $temperature
                Humidity = $humidity
                Location = $location
            }
            $result += New-Object psobject -Property $props
        }
    }
    return $result
}
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
Get-Seeds $data
# Mapping 
$MappingsObject = Get-Mappings $data
$outcomes_p1 = Get-AnswerPartOne $MappingsObject
$outcomes_p1 | Select-Object * | Format-Table
$p1_answer = $outcomes_p1 | Measure-Object -Property Location -Minimum

$outcomes_p2 = Get-AnswerPartTwo $MappingsObject
$outcomes_p2 | Select-Object * | Format-Table
$p2_answer = $outcomes_p2 | Measure-Object -Property Location -Minimum

Write-Host "The answer for the part one is $($p1_answer.Minimum)" -ForegroundColor Green
Write-Host "The answer for the part two is $($p2_answer.Minimum)" -ForegroundColor Green
#endregion