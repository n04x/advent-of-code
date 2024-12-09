# Module to open file that is imported in all PSS script.

function Open-DataFile {
    param(
        # Write the day number
        [Parameter(Mandatory=$true)]
        [string]$DayNumber,
        # Set the testing mode
        [Parameter()]
        [bool]$Testing = $true,
        # Set the Script Path if there is any
        [Parameter()]
        [string]$scriptPath = (Split-Path -Parent $MyInvocation.MyCommand.Definition)
    )
    if($Testing) { 
        return Get-Content "$scriptPath\test\day$DayNumber.test"
    } else {
        return Get-Content "$scriptPath\inputs\day$DayNumber.txt"
    }    
}

Export-ModuleMember Open-DataFile