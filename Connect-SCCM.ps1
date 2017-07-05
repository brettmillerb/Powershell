function Connect-SCCM {
    #[CmdletBinding()]
        process {
            #Import the Configuration Manager Module
            Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"

            #Create PSDrive with credentials that have rights in SCCM
            New-PSDrive -Name PR1 -PSProvider CMSite -Root 'sccm.domain.com' -Credential (Get-Credential)

            #Setting the working directory to PR1
            Set-Location "PR1:" 
        }
}