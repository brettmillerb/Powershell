<#
.Synopsis
   Checks who owns the computer object in Active Directory
.DESCRIPTION
   Performs a lookup of the owner in the ACL of the computer object in Active Directory
.EXAMPLE
   Get-ADComputerOwner $Computers
.EXAMPLE
   Get-ADComputerOwner "Computer1", "Computer2"
#>
function Get-ADComputerOwner
{
    [CmdletBinding()]
    Param
    (
        #$computers - Single or array of computers to search
        [Parameter(Mandatory=$false,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName=$true)]
        $Computers
    )

    Begin {}
    Process{
        foreach ($computer in $computers){
            try {
                $comp = Get-ADComputer $computer -Properties Created -ErrorAction Stop
                $comppath = "AD:$($comp.DistinguishedName.ToString())"
                $owner = (Get-Acl -Path $comppath).Owner
                $properties = @{Computername = $comp.Name
                                Owner = $owner
                                Created = [datetime]$comp.Created
                                Enabled = $comp.enabled}
            } catch {
                $properties = @{Computername = $comp.Name
                                Owner = $null
                                Created = $null
                                Enabled = $null}
            } finally {
                $obj = New-Object -TypeName psobject -Property $properties
                Write-Output $obj
            } #End Finally
        } #End Foreach
    } #End Process
    End{}
} #End Function