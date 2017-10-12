function Convert-ObjectGUID {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [guid[]]$ObjectGUID
    )
     process {
        foreach ($guid in $ObjectGUID) {
            [PSCustomObject]@{
                immutableid = [system.convert]::ToBase64String($guid.ToByteArray())
            }
        }
     }
}