function Get-CMUserPrimaryDevice {
<#
.SYNOPSIS
Gets a user's primary device from SCCM database

.DESCRIPTION
Connects to SCCM and obtains a users primary device from the SMS database

.PARAMETER identity
This requires sAMAccountName in order to successfully find the user in SMS database.

.EXAMPLE
Get-CMUserPrimaryDevice -Identity Brett.Miller

.EXAMPLE
'Brett.Miller' | Get-CMUserPrimaryDevice

.Example
Get-aduser brett.miller | select -ExpandProperty samaccountname | Get-CMUserPrimaryDevice
#>
    [CmdletBinding(PositionalBinding=$false)]
    param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]$identity

    )
    process {
        foreach ($person in $identity) {
            $userobj = Get-CMUserDeviceAffinity -UserName ("bbds\{0}" -f $person)
            if ($userobj){
                [PSCustomObject]@{
                    sAMAccountName = ($userobj.uniqueusername | Select-Object -First 1).substring(5)
                    ComputerName = $userobj | Select-Object -ExpandProperty resourcename
                } 
            }
            else {
                [PSCustomObject]@{
                    sAMAccountName = $person
                    ComputerName = $null
                }
            }
        }
    }
}