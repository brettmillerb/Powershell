function Set-O365License {
    <#
    .SYNOPSIS
    Set S4b PSTN license and plans for a specified user(s)

    .DESCRIPTION
    S4b is replacing GoToMeeting and users need E5 license as well as PSTN functionality. This sets both in one go

    .PARAMETER UserToLicense
    Provide one or more UserPrincipalNames to assign a license and the relevant service plans.

    .EXAMPLE
    Set-SkypePSTNUser brett.miller@domain.com

    .NOTES
    Brett Miller - 2017-05-31 - https://millerb.co.uk
    Must be connected to AzureAD to run this script
    Use the Connect-AzureAD cmdlet to connect
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ObjectId
    )

    begin {
        #Test for AzureAD connectivity prior to attempting Set
        try {
            Get-AzureADTenantDetail -ErrorAction stop
        }
        catch {
            $_.exception.message
            break
        }

        #Define the plans that will be enabled (Exchange Online, Skype for Business and Office 365 ProPlus )
        #Write-Verbose "Enabled Plans are Skype for Business Plan2 and PSTN Conferencing"
        $enabledplans = 'MCOSTANDARD','MCOMEETADV'

        #Get the licensesku and create the Disabled ServicePlans object
        #Write-Verbose "License is set to Enterprise Premium (E5)"
        $licensesku = Get-AzureADSubscribedSku | Where-Object {$_.SkuPartNumber -eq 'ENTERPRISEPREMIUM'} 

        #Loop through all the individual plans and disable all plans except the one in $enabledplans
        $disabledplans = $licensesku.ServicePlans | ForEach-Object -Process { 
        $_ | Where-Object -FilterScript {$_.ServicePlanName -notin $enabledplans }
        }
        
        #Create the AssignedLicense object with the License and disabledplans created earlier
        $licenseobj = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
        $licenseobj.SkuId = $licensesku.SkuId
        $licenseobj.disabledplans = $disabledplans.ServicePlanId
        
        #Create the AssignedLicenses Object. Remove Licenses has to be declared as a null value
        $assignedlicenseobj = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
        $assignedlicenseobj.AddLicenses = $licenseobj
        $assignedlicenseobj.RemoveLicenses = @()
    }
    process {
        foreach ($User in $ObjectId) {

        #The user that will get a license
        $UserObj = Get-AzureADUser -ObjectId $User

        #Assign the license to the user
        Write-Verbose "Setting $($licensesku.SkuPartNumber) on $user"
        Set-AzureADUserLicense -ObjectId $UserObj.ObjectId -AssignedLicenses $AssignedLicenseObj -Verbose
        }
    }
    
    end {
    }
}