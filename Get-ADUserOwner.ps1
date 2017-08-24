<#
.Synopsis
   Checks who owns the user object in Active Directory
.DESCRIPTION
   Performs a lookup of the owner in the ACL of the user object in Active Directory
.EXAMPLE
   Get-ADComputerOwner $Users
.EXAMPLE
   Get-ADComputerOwner "User1", "User2"
#>
function Get-ADUserOwner
{
    [CmdletBinding()]
    Param
    (
        #$Users - Single or array of computers to search
        [Parameter(Mandatory=$false,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName=$true)]
        [string[]]$Users
    )

    Begin {}
    Process{
        foreach ($user in $users){
            try {
                $use = Get-ADUser $user -ErrorAction Stop
                $usepath = "AD:$($use.DistinguishedName.ToString())"
                $owner = (Get-Acl -Path $usepath).Owner
                $properties = @{Username = $user
                                Owner = $owner}
            } catch {
                $properties = @{Username = $user
                                Owner = $owner}
            } finally {
                $obj = New-Object -TypeName psobject -Property $properties
                Write-Output $obj
            } #End Finally
        } #End Foreach
    } #End Process
    End{}
} #End Function