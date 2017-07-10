# Powershell

Powershell Functions that I use regularly at work. I've appropriately redacted them so that there is no identifying information present.

## Cmdlets

### Connect-SCCM
	Imports Configuration Manager Module and Maps PSDrive to Primary server enabling SCCM cmdlets to be utilised.

### Get-ADComputerOwner
	Gets the owner of the Computer object from the ACL of the AD Object.

### Get-ADExistence
	Gets whether a computer AD object exists for a given machine name.

### Get-ADLocalAdminGroup
	Checks AD to see if a Local Admin Group exists for the corresponding computer account and it's members.

### Get-ADUserOwner
	Gets the owner of the User object from the ACL of the AD Object

### Get-FSRM.ps1
	Gets File Screen Monitoring filetypes from public API for recent ransomware attacks

### Get-O365Licenses.ps1
	Gets the O365 license count and usage for SKU.

### Search-GPOsForStringReturnAll
	Searches Group Policy Objects for a provided string