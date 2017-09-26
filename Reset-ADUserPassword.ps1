function Reset-ADUserPassword {
    <#
    .SYNOPSIS
    Reset a user's password in Active Directory.
    
    .DESCRIPTION
    Quick function for resetting a user's password in Active Directory to be changed immediately.
    
    .PARAMETER Identity
    The user account to reset
    
    .EXAMPLE
    Reset-ADUserPassword brett.miller
    
    .NOTES
    This is insecure but a quick way to reset a password for an immediate user change.
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string[]]$Identity
    )
        
    process {
        foreach ($user in $Identity) {
            Set-ADAccountPassword -Identity $user -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "Pa55word1!" -Force) -Credential $creds
            Set-ADUser -Identity $user -ChangePasswordAtLogon $true -Credential $creds
        }
    }
}