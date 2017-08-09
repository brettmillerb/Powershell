<# Stolen from https://365lab.net/2014/12/17/office-365-assign-individual-parts-of-licenses-based-on-groups-using-powershell/
Reworked to work with AzureADv2 Module
License a user based on group membership for Office365 #>

#requires -modules AzureAD

<# SkuHashtable to convert SkuId to SkuPartNumber as this is not returned in Get-AzureADUser even though it was in Get-MsolUser
it's less resource heavy than querying every user solely for the SkuPartNumber #>
$SkuHashtable = @{}
Get-AzureADSubscribedSku | ForEach-Object {
    $key = $_.skuid
    $value = @{
        SkuPartNumber = $_.skupartnumber
        EnabledLicenses = $EnabledUnits = $_.prepaidunits.enabled
        ConsumedUnits = $ConsumedUnits = $_.ConsumedUnits
        RemainingUnits = $EnabledUnits - $ConsumedUnits
    }
    $SkuHashtable.Add($key,$value)
}

<# Dynamically create a Hashtable with group:license information for use later in the script
Group format Test-E1-StandardPack, Test-E3-EnterprisePack
The only way to correlate the Security Group with the license is via SkuPartNumber #>
$GroupHashtable = @{}
Get-AzureADGroup -SearchString 'test-e' | ForEach-Object {
    $key = $_.displayname
    $value = @{
        LicenseSkuPartNumber = $PartNo = (($_.displayname).split("-")[2])
        LicenseSkuId         = $SkuHashtable.GetEnumerator() | Where-Object {$_.value.skupartnumber -EQ $PartNo} | select -ExpandProperty name
        GroupObjectId        = $_.ObjectID
    }
    $GroupHashtable.Add($key,$value)
}

<# Get all currently licensed users (Users can have multiple licenses.
Exclude admin accounts as these have RBAC and PowerBi AzureAnalysis plans assigned. #>
$licensedusers = get-azureaduser -top 150 | Where-Object {
    $_.assignedlicenses.skuid -ne $null -and 
    $_.userprincipalname -notlike 'adm-*'} | ForEach-Object {
        [pscustomobject]@{
            userprincipalname = $_.userprincipalname
            LicenseSKU = $SkuID = $_.assignedlicenses.skuid
            SkuPartNumber = $SkuHashtable[$SkuID].skupartnumber
        }
}

foreach ($Group in $GroupHashtable.Keys) {
    #Get the SKU of each of the licenses
    #$sku = Get-AzureADSubscribedSku | Where-Object -FilterScript { $_.skupartnumber -eq $GroupHashtable[$Group].licenseskupartnumber }
    #Get all members of the Licensing Group
    $groupmembers = (Get-AzureADGroupMember -ObjectId $GroupHashtable[$Group].GroupObjectId).userprincipalname
    $grouplicensedusers = ($licensedusers | Where-Object {$_.skupartnumber -eq $GroupHashtable[$group].LicenseSkuPartNumber}).userprincipalname

    $comparisonobj = Compare-Object -ReferenceObject $groupmembers -DifferenceObject $grouplicensedusers

    

    if ($SkuHashtable[$group].remainingunits -lt ($unlicensedusers | Measure-Object).count) {
        Write-Warning "Not enough licenses remaining to license users"
        break
    }

    foreach ($user in $unlicensedusers) {
        Set-AzureADUser -ObjectId $user.userprincipalname -UsageLocation 'GB'
        
        if ($Group -eq 'E5') {
            #Set-SkypeE5License -ObjectId $user.userprincipalname
            Write-Host "Setting E5 License on $($user.DisplayName)"
        }
        elseif ($Group -eq 'E3') {
            #Set-SkypeE1License -ObjectId $user.userprincipalname
            Write-Host "Setting E3 License on $($user.DisplayName)"
        }
        else {
            #Set-SkypeE1License -ObjectId $user.userprincipalname
            Write-Host "Setting E1 License on $($user.DisplayName)"
        }
    }
}