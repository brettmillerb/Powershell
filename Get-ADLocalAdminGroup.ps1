function Get-ADLocalAdminGroup {
<#
.Synopsis
   Get AD Local Admin group for corresponding computer account
.DESCRIPTION
   Local Admin rights are granted via GPP using "OU ac-%computername%-LocalAdmin"
   AD accounts are created in Resource OU in AD and user added to those groups.
.EXAMPLE
   Get-ADLocalAdminGroup L9018210
   Get-ADLocalAdminGroup $machines
.EXAMPLE
   $machines | Get-LocalAdminGroup
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true)]
        [string[]]
        $Computername
    )

    Process {
        foreach ($computer in $computername) {
            $groupname = "FUJ ac-{0}-LocalAdmin" -f $computer
            try {
                $group = get-adgroup $groupname -Properties members
                [pscustomobject]@{
                    Computername = $computer
                    Groupname = $group.name
                    GroupExists = 'Yes'
                    Members = if (($group.members).count -lt 1) {
                                'No Members'
                              }
                              else {
                                (Get-ADGroupMember $groupname).samaccountname -join ","
                              }
                }
            }
            catch {
                [pscustomobject]@{
                    Computername = $computer
                    Groupname = $null
                    GroupExists = 'No'
                    Members = 'No Members'
                }
            }
        }
    }
}