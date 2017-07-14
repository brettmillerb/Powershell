function Connect-SCCM {
    <#
    .SYNOPSIS
    Imports the Configuration Manager module, and maps drive to enable SCCM cmdlets to be used
    
    .DESCRIPTION
    Imports the configuration manger module, maps new Ps-drive to SCCM server and sets location

    .EXAMPLE
    Connect-SCCM
    
    .NOTES
    Needs x86 ISE/IDE
    #>
    process {
        Import-Module "C:\Program Files (x86)\Configuration Manager\Console\bin\ConfigurationManager.psd1" -Global

        New-PSDrive -Name PR1 -PSProvider CMSite -Root 'sccm001.domain.com' -Credential (Get-Credential) -Scope global

        Set-Location "PR1:"
    }
}