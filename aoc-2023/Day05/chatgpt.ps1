# Define the input data as a multi-line string
$inputData = @"
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"@

# Split the input data into lines
$inputLines = $inputData -split "`n"

# Parse seeds
$seeds = ($inputLines[0] -split ': ')[1] -split ' ' | ForEach-Object { [int]$_ }

# Initialize a hash table to store mappings
$maps = @{} 

# Parse the maps and populate the hash table
for ($i = 1; $i -lt $inputLines.Count; $i += 4) {
    $category = $inputLines[$i] -replace '-to-.+'
    $maps[$category] = @()
    $inputLines[$i+1..$i+3] | ForEach-Object {
        $map = $_ -split ' ' | ForEach-Object { [int]$_ }
        $maps[$category] += $map
    }
}

# Function to perform mappings
function MapValue ($value, $map) {
    $startDest, $startSource, $length = $map
    $index = $value - $startSource
    $result = $startDest + $index % $length
    return $result
}

# Iterate through the categories and perform mappings
$locationNumbers = $seeds
foreach ($category in $maps.Keys) {
    $newLocationNumbers = @()
    foreach ($seed in $locationNumbers) {
        $map = $maps[$category]
        $newLocationNumbers += $seed | ForEach-Object { MapValue $_ $map }
    }
    $locationNumbers = $newLocationNumbers
}

# Find the lowest location number
$lowestLocation = $locationNumbers | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum

# Output the result
Write-Host "The lowest location number is: $lowestLocation"
