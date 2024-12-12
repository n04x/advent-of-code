#region Parameters
$day = "06"
$title = "Day 6: Guard Gallivant"
$testing = $false
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$directionsIcons = "^>v<"
$directionsNames = ("UP","RIGHT","DOWN","LEFT")
$Cross = "X"
$answer = 0
#endregion

#region Modules
Import-Module -Name "$scriptPath/modules/OpenFile.psm1" -Force
Import-Module -Name "$scriptPath/modules/WriteOutcome.psm1" -Force
#endregion

#region Functions
function Find-Guard {
    param ($map)
    $Regex = "[v<>\^]"
    for($row = 0; $row -lt $map.Count; $row++) {
        $GuardPosition = [regex]::Match($map[$row], $Regex)
        if($GuardPosition.Success) {
            switch ($GuardPosition.Value) {
                '^' { $facing = "UP" }
                'v' { $facing = "DOWN" }
                '<' { $facing = "LEFT" }
                '>' { $facing = "RIGHT" }
            }
            $guardObject = [PSCustomObject]@{
                X = $GuardPosition.Index
                Y = $row
                DIRECTION = $facing
                ICON = $GuardPosition.Value
            }
            return $guardObject
        }
    }
}

function Update-MapRow {
    param($ch, [string]$line, $idx)
    $charArray = $line.ToCharArray()
    $charArray[$idx] = $ch
    return ($charArray -join '')
}
#endregion

#region Main
$map = Open-DataFile -DayNumber $day -Testing $testing -ScriptPath $scriptPath
$GuardPosition = Find-Guard $map 
$MaxX = $map[0].Length
Clear-Host
do {
    try {
        $GuardSurroundings = [PSCustomObject]@{
            UP = [PSCustomObject]@{
                Char = ($map[$GuardPosition.Y - 1][$GuardPosition.X])
                X = $GuardPosition.X
                Y = $GuardPosition.Y - 1
            }
            DOWN = [PSCustomObject]@{
                Char = ($map[$GuardPosition.Y + 1][$GuardPosition.X])
                X = $GuardPosition.X
                Y = $GuardPosition.Y + 1
            }
            LEFT = [PSCustomObject]@{
                Char = ($map[$GuardPosition.Y][$GuardPosition.X - 1])
                X = $GuardPosition.X - 1
                Y = $GuardPosition.Y
            }
            RIGHT = [PSCustomObject]@{
                Char = ($map[$GuardPosition.Y][$GuardPosition.X + 1])
                X = $GuardPosition.X + 1
                Y = $GuardPosition.Y
            }
        }
    }
    catch {
        Write-Host "$_"
        $OutOfBounds = $true
    }

    $chosenDirection = $GuardSurroundings.$($GuardPosition.DIRECTION)
    $chosenPosX = $chosenDirection.X
    $chosenPosY = $chosenDirection.Y

    if($chosenDirection.Char -eq "#") {
        # Turn the guard to the right
        $nextDirectionIconIndex = (($directionsIcons.IndexOf($GuardPosition.ICON) + 1) % $directionsIcons.Length)
        $nextDirectionIcon = $directionsIcons[$nextDirectionIconIndex]
        
        $nextDirectionNameIndex = (($DirectionsNames.IndexOf($GuardPosition.DIRECTION) + 1) % $directionsNames.Length)
        $nextDirectionName = $directionsNames[$nextDirectionNameIndex]

        $map[$GuardPosition.Y] = (Update-MapRow $nextDirectionIcon $map[$GuardPosition.Y] $GuardPosition.X)

        $GuardPosition.ICON = $nextDirectionIcon
        $GuardPosition.DIRECTION = $nextDirectionName
        continue
    }

    if($chosenPosX -ge $MaxX -or $chosenPosX -lt 0) { $OutOfBounds = $true }

    # set new guard position
    $map[$chosenPosY] = (Update-MapRow $GuardPosition.ICON $map[$chosenPosY] $chosenPosX)

    # set a cross for visited position by the guard.
    $map[$GuardPosition.Y] = (Update-MapRow $Cross $map[$GuardPosition.Y] $GuardPosition.X)

    $GuardPosition.X = $chosenPosX
    $GuardPosition.Y = $chosenPosY

    $Host.UI.RawUI.CursorPosition = @{ x = 0; y = 0}
    $map -join "`n"
}while(!($OutOfBounds))
$visitedPositionCounter = [regex]::Matches($map, "X")


Write-Answer -Title $title -Testing $testing -ExpectedAnswer 41 -Answer $visitedPositionCounter.Count -Part 1
#endregion