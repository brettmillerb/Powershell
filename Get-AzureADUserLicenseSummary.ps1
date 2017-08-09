function Get-AzureADUserLicenseSummary {
    <#
    .SYNOPSIS
    Gets a summary of users license allocation and enabled plans in readable format.

    .DESCRIPTION
    Enables you to quickly identify O365 license allocated to a user as well as the plans that are enabled as part of their license.

    .PARAMETER ObjectID
    Specifies the ID (as a UPN or ObjectId) of a user in Azure AD.

    .EXAMPLE
    Get-AzureADUserLicenseSummary brett.miller@domain.com

    .EXAMPLE
    $users = 'brett.miller@domain.com','joe.bloggs@domain.com'

    Get-AzureADUserLicenseSummary $users

    .NOTES
    Requires connection to AzureAD
    Use Connect-AzureAD to establish connection
    #>
    
    [CmdletBinding()]

    Param (
        [Parameter(
            Mandatory=$true,
            Position=0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $ObjectID
    )

    process {
        foreach ($user in $ObjectID) {
            $userobj = Get-AzureADUser -ObjectId $user
            $UserLicenses = Get-AzureADUserLicenseDetail -ObjectId $user

            if ($UserLicenses) {
                [pscustomobject]@{
                    DisplayName = $userobj.DisplayName
                    UserPrincipalName = $userobj.UserPrincipalName
                    Licenses = ($UserLicenses.skupartnumber).replace('STANDARDPACK','ENTERPRISE E1').replace('ENTERPRISEPACK','ENTERPRISE E3').replace('ENTERPRISEPREMIUM','ENTERPRISE E5').replace('SHAREPOINTSTANDARD','SHAREPOINT ONLINE')
                    Plans = ($UserLicenses.serviceplans | Where-Object ProvisioningStatus -EQ Success).serviceplanname
                }
            }
            else {
                [PSCustomObject]@{
                    DisplayName = $userobj.DisplayName
                    UserPrincipalName = $userobj.UserPrincipalName
                    Licenses = $null
                    Plans = $null
                }
            }
        }
    }
}