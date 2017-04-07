# Powershell

Powershell Functions that I use to do bits and pieces at work. I've appropriately redacted them so that there is no identifying information present

## Cmdlets

### Get-O365Licenses.ps1
	Gets the O365 license count and usage

### Get-ADComputerOwner
	Gets the owner of the Computer object from the ACL of the AD Object

### Get-ADUserOwner
	Gets the owner of the User object from the ACL of the AD Object

### Get-ADExistence
	Gets whether a computer AD object exists for a given machine name.

### Get-FSRM.ps1
	Gets File Screen Monitoring filetypes from public API for recent ransomware attacks

### Search-GPOsForStringReturnAll
	Searches Group Policy Objects for a provided string

### GetRecursiveGroups
	Recursively lists a users AD group membership
