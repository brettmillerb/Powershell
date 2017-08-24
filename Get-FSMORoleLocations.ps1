function Get-FSMORoleLocation {
    $ADDomain = Get-ADDomain | Select-Object pdcemulator,ridmaster,infrastructuremaster
    $ADForest = Get-ADForest fqdn.domain.com | Select-Object domainnamingmaster,schemamaster

    [PSCustomObject]@{
        PDCEmulator = $ADDomain.pdcemulator
        RIDMaster = $ADDomain.ridmaster
        InfrastructureMaster = $ADDomain.infrastructuremaster
        DomainNamingMaster = $ADForest.domainnamingmaster
        SchemaMaster = $ADForest.schemamaster        
    }
}