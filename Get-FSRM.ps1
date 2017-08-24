<#
.Synopsis
   Get List of Ransomware filetypes from Public API
.DESCRIPTION
   Function to public API https://fsrm.experiant.ca/ to call data
   for use in FileSystem Resource Manager (FSRM) groups.
.EXAMPLE
   Get-FSRM (No Parementers required)
#>

function Get-FSRM
{
    Process {
        $webClient = New-Object System.Net.WebClient

        #Download JSON from API
        $jsonStr = $webClient.DownloadString("https://fsrm.experiant.ca/api/v1/combined")

        #Convert JSON to Custom Object
        $Raw = ConvertFrom-Json $jsonStr #Contains api

        #Add each file extension to an array for output
        $monitoredextensions = @(ConvertFrom-Json($jsonStr) | ForEach-Object { $_.filters })

        #Create custom object containing info from API
        $properties = @{DateExtracted = ((Get-Date).ToShortDateString())
                        GroupCount = $raw.api.file_group_count
                        LastUpdated = $raw.lastUpdated.date
                        Extensions = $monitoredextensions}

        $obj = New-Object -TypeName psobject -Property $properties
        Write-Output $obj
    }
}