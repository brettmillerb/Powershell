######################################################### 
# 
# Name: Search-GPOsForString.ps1 
# Author: Tony Murray
# Amendments: Adam Fowler https://www.adamfowlerit.com/
# Version: 1.0 
# Date: 13/07/2016 
# Comment: Simple search for GPOs within a domain 
# that match a given string 
######################################################## 
 
# Get the string we want to search for 
$string = Read-Host -Prompt "What string do you want to search for?" 
 
# Set the domain to search for GPOs 
$DomainName = $env:USERDNSDOMAIN 
 
# Find all GPOs in the current domain 
write-host "Finding all the GPOs in $DomainName" 
Import-Module grouppolicy 
$allGposInDomain = Get-GPO -All -Domain $DomainName 
 
# Look through each GPO's XML for the string 
Write-Host "Starting search...." 
foreach ($gpo in $allGposInDomain) { 
    $report = Get-GPOReport -Guid $gpo.Id -ReportType Xml 
    if ($report -match $string) { 
        write-host "********** Match found in: $($gpo.DisplayName) **********"
}
} # end foreach
