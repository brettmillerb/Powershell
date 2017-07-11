function Get-FSMORoleLocation {
    $ADDomain = Get-ADDomain | select pdcemulator,ridmaster,infrastructuremaster
    $ADForest = Get-ADForest bbds.balfourbeatty.com | select domainnamingmaster,schemamaster

    [PSCustomObject]@{
        PDCEmulator = $ADDomain.pdcemulator
        RIDMaster = $ADDomain.ridmaster
        InfrastructureMaster = $ADDomain.infrastructuremaster
        DomainNamingMaster = $ADForest.domainnamingmaster
        SchemaMaster = $ADForest.schemamaster        
    }
}