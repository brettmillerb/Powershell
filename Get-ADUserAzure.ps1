function Get-ADUserAzure {
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                try {
                    (Get-aduser $_ -ErrorAction Stop)
                    $true
                }
                catch {
                    throw "User does not exist"
                }
        })]
        [string]$username
    )
    process {
        get-azureaduser -objectid (get-aduser $username).userprincipalname
    }
}