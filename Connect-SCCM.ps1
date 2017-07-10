function Connect-SCCM {
    process {
        #Import the Configuration Manager Module
        Import-Module "C:\Program Files (x86)\Configuration Manager\Console\bin\ConfigurationManager.psd1" -Global

        #Create PSDrive with credentials that have rights in SCCM
        New-PSDrive -Name PR1 -PSProvider CMSite -Root 'sccm001.domain.com' -Credential (Get-Credential) -Scope global

        #Setting the working directory to PR1
        Set-Location "PR1:"
    }
}