# Use this module to write output answers.

function Write-Answer {
    param (
        # Title of the Day
        [Parameter(Mandatory=$true)]
        [string]$Title,
        # Testing Mode
        [Parameter()]
        [bool]$Testing = $false,
        # Expected Answer, only use it if testing mode enable
        [Parameter()]
        [string]$ExpectedAnswer,
        # Answer provided
        [Parameter(Mandatory=$true)]
        $Answer,
        # Part
        [Parameter(Mandatory=$true)]
        [int]$Part   
    )
    if($Testing) {
        Write-Host "The expected answer for $Title part $Part is $ExpectedAnswer. The answer submit is: " -NoNewline
        if($Answer -eq $ExpectedAnswer) { Write-Host $Answer -ForegroundColor Blue } else { Write-Host $Answer -ForegroundColor Red}
    } else {
        Write-Host "The answers for Advent of Code $Title part $Part is $Answer."
    }
    return ""    
}

Export-ModuleMember Write-Answer