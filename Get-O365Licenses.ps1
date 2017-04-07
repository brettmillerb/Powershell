<#
.SYNOPSIS
    Gets the current O365 license status
.DESCRIPTION
    Connects to O365 tenancy and gets the current license total, used and remaining counts and outputs to console.
.EXAMPLE
    Get-O365Licenses
.EXAMPLE
    Get-O365Licnses | Out-GridView
.OUTPUTS
    Name                         LicensesTotal LicensesUsed LicensesRemaining
    ----                         ------------- ------------ -----------------
    ENTERPRISEPREMIUM                       25            5                20
    POWERAPPS_INDIVIDUAL_USER            10000            2              9998
    YAMMER_ENTERPRISE_STANDALONE             1            0                 1
    ENTERPRISEPACK                          52           41                11
.NOTES
    Must be connected to AzureAD to run this script
    Use the Connect-AzureAD cmdlet to connect
#>
function Get-O365Licenses {
    [CmdletBinding()]
      
    Param (
    )
    
    begin {}
    
    process {
        $skus = Get-AzureADSubscribedSku

        foreach ($sku in $skus) {
            $properties = [ordered]@{
                Name = $sku.skupartnumber
                LicensesTotal = $sku.prepaidunits.enabled
                LicensesUsed = $sku.consumedunits
                LicensesRemaining = ($sku.prepaidunits.enabled) - ($sku.consumedunits)
            }

            $OutputObj = New-Object -TypeName psobject -Property $properties
            Write-Output $OutputObj
        }
            
    }

    end {}
}
