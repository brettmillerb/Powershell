function Convert-ImmutableID {
    <#
    .SYNOPSIS
    Converts O365 ImmutableID to ActiveDirectory objectGUID
    
    .DESCRIPTION
    Converts O365 ImmutableID check cloud user against on-premises
    
    .PARAMETER ImmutableID
    The Immutable ID from O365/AzureAD which is a base-64 encoded version of the AD objectGUID
    
    .EXAMPLE
    Convert-ImmutableID 't3sJlM0QekeUJ32kOEe1hg=='
    
    .NOTES
    You can get the ImmutableID running:
    Get-AzureADUser -ObjectId brett.miller@millerb.co.uk | Select-Object immutableid
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$ImmutableID
    )
     process {
        [PSCustomObject]@{
            objectGUID = New-Object -TypeName guid (,[System.Convert]::FromBase64String($immutableid))
        }
     }
}