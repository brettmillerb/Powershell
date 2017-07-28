<# Stolen from https://365lab.net/2014/12/17/office-365-assign-individual-parts-of-licenses-based-on-groups-using-powershell/
Edited to work with AzureADv2 Module
License a user based on group membership for Office365 #>

$licenses = @{
    'E1' = @{
        LicenseSKU = 'STANDARDPACK'
        Group = 'Test-E1Group'
        ObjectID = '1a209fe2-133b-4fa3-9064-1becf0a60497'
    }
    'E3' = @{
        LicenseSKU = 'ENTERPRISEPACK'
        Group = 'Test-E3Group'
        ObjectID = '4061d1ff-a786-40ae-a86f-87b79495f3bb'
    }
    'E5' = @{
        LicenseSKU = 'ENTERPRISEPREMIUM'
        Group = 'Test-E5Group'
        ObjectID = 'df837604-9e43-46fe-b321-d3f59127538c'
    }     
}


foreach ($license in $licenses.Keys) {
    $sku = Get-AzureADSubscribedSku | Where-Object -FilterScript { $_.skupartnumber -eq $licenses[$license].LicenseSKU }
    $unlicensedusers = Get-AzureADGroupMember -ObjectId $licenses[$license].ObjectID | Where-Object {($_.assignedlicenses | Measure-Object).Count -lt 1}

    if (($sku.prepaidunits.enabled) - ($sku.consumedunits) -lt ($unlicensedusers | Measure-Object).count) {
        Write-Warning "Not enough licenses remaining to license users"
        break
    }

    foreach ($user in $unlicensedusers) {
        Set-AzureADUser -ObjectId $user.userprincipalname -UsageLocation 'GB'
        
        if ($license -eq 'E5') {
            #Set-SkypeE5License -ObjectId $user.userprincipalname
            Write-Host "Setting E5 License on $($user.DisplayName)"
        }
        elseif ($license -eq 'E3') {
            #Set-SkypeE1License -ObjectId $user.userprincipalname
            Write-Host "Setting E3 License on $($user.DisplayName)"
        }
        else {
            #Set-SkypeE1License -ObjectId $user.userprincipalname
            Write-Host "Setting E1 License on $($user.DisplayName)"
        }
    }
}