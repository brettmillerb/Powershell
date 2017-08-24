function Get-ADUserAzure {
    <#
    .SYNOPSIS
    Gets the AzureAD account from the sAMAccountname of on-premises user
    
    .DESCRIPTION
    Looks up the on-premises sAMAccountname and queries AzureAD using the UPN from the on-premises account.
        
    .PARAMETER username
    sAMAccountname of on-premises user account
    
    .EXAMPLE
    Get-ADUserAzure brett.miller
    
    .NOTES
    Saves having to type out the full UPN of a user to look them up in AzureAD
    #>
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                try {
                    (Get-aduser -identity $_ -ErrorAction Stop)
                    $true
                }
                catch {
                    throw "User does not exist"
                }
        })] 
        [string[]]$username
    )
    process {
        foreach ($user in $username) {
            get-azureaduser -objectid (get-aduser -Identity $user).userprincipalname
        }
    }
}