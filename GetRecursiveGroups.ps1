function GetGroups 
{ 
param ( $strGroup )

$CurrentGroupGroups = (GET-ADGROUP –Identity $strGroup –Properties MemberOf | Select-Object MemberOf).MemberOf 
foreach($Memgroup in $CurrentGroupGroups) 
{ 
$strMemGroup = $Memgroup.split(',')[0] 
$strMemGroup = $strMemGroup.split('=')[1] 
$strMemGroup 
GetGroups -strGroup $strMemGroup 
} 
}

Import-Module ActiveDirectory

$CurrentUser = "kay.hoyland" 
$CurrentUserGroups = (GET-ADUSER –Identity $CurrentUser –Properties MemberOf | Select-Object MemberOf).MemberOf

foreach($group in $CurrentUserGroups) 
{ 
$strGroup = $group.split(',')[0] 
$strGroup = $strGroup.split('=')[1] 
$strGroup 
GetGroups -strGroup $strGroup 
}

Remove-Module ActiveDirectory