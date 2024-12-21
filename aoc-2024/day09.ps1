#region Parameters
$day = "09"
$title = "Day 9: Disk Fragmenter"
$testing = $false
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
[System.Collections.ArrayList]$diskmap = @()
[System.Collections.ArrayList]$freeSpaces = @()
$filesystemChecksum = 0
#endregion

#region Modules
Import-Module -Name "$scriptPath/modules/OpenFile.psm1" -Force
Import-Module -Name "$scriptPath/modules/WriteOutcome.psm1" -Force
#endregion

#region Functions
function New-DiskMap {
    param($data, $part)
    [System.Collections.ArrayList]$result = @()
    $isFileBlock = $true
    $index = 0
    $IDNumber = 0
    switch ($part) {
        1 { 
            foreach($char in $data.ToCharArray()) {
                $value = [System.Int32]::Parse($char)
                if($isFileBlock) {
                    for($i = 0; $i -lt $value; $i++) { $result.Add($IDNumber) | Out-Null }
                    $isFileBlock = $false
                    $IDNumber++
                    $index += $value
                } else {
                    for($i = 0; $i -lt $value; $i++) {
                        $result.Add('.') | Out-Null
                        $freeSpaces.Add($index) | Out-Null
                        $index++
                    }
                    $isFileBlock = $true
                }

            }
         }
        2 { 
            foreach($char in $data.ToCharArray()) {
                $value = [System.Int32]::Parse($char)
                if($isFileBlock) {
                    $diskmapObj = [PSCustomObject]@{
                        StartingIndex = $index
                        Size = $value
                        ID = $IDNumber
                    }
                    $result.Add($diskmapObj) | Out-Null
                    $isFileBlock = $false
                    $IDNumber++
                } else {
                    if($value -gt 0) {
                        $freeSpaceObj = [PSCustomObject]@{
                            StartingIndex = $index
                            Size = $value
                        }
                        $freeSpaces.Add($freeSpaceObj) | Out-Null
                    }
                    $isFileBlock = $true
                }

                $index += $value
            }
         }
        Default { Write-Error "Provide a valid value for Part number"}
    }
    return $result
}

function Get-FileSystemCheckSum {
   param($map, $part)
   $result = 0
   switch ($part) {
    1 { 
        while($freeSpaces -and ($freeSpaces[0] -lt $map.Count)) {
            if($map[-1] -ne ".") {
                $map[$freeSpaces[0]] = $map[-1]
                $freeSpaces.RemoveAt(0)
            }
    
            $map.RemoveAt($map.Count -1)
        }
        for($i = 0; $i -lt $map.Count; $i++) {
            $result += $i * $map[$i]
        }
     }
    2 { 
        foreach($file in $map | Sort-Object ID -Descending) {
            $destination = $freeSpaces | Where-Object { ($_.Size -ge $file.Size) -and ($_.StartingIndex -lt $file.StartingIndex)} | Select-Object -First 1

            if($destination) {

                $file.StartingIndex = $destination.StartingIndex
                $destination.Size -= $file.Size

                if($destination.Size -eq 0) { $freeSpaces.Remove($destination) }
                else { $destination.StartingIndex += $file.Size }
            }
            for($i = $file.StartingIndex; $i -lt ($file.StartingIndex + $file.Size); $i++) {
                $result += $i  * $file.ID
                Write-Host "|" -NoNewline
            }
        }        
     }
    Default { Write-Error "Provide a valid value for Part number" }
   }
   return $result
}
#endregion

#region Main
$data = Open-DataFile -DayNumber $day -Testing $testing -ScriptPath $scriptPath
$diskmap = New-DiskMap $data 1
$filesystemChecksum = Get-FileSystemCheckSum $diskmap 1
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 1928 -Answer $filesystemChecksum -Part 1
$diskmap = New-DiskMap $data 2
$filesystemChecksum = Get-FileSystemCheckSum $diskmap 2
Write-Answer -Title $title -Testing $testing -ExpectedAnswer 2858 -Answer $filesystemChecksum -Part 2
#endregion