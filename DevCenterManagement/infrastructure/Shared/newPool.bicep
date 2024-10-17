
targetScope = 'resourceGroup'

param DevProjectName string
param DevProjectPoolConfig object
param tags object

// ================== Variables ==================


// ================== Resources ==================

resource devProject 'Microsoft.DevCenter/projects@2024-02-01' existing = {
  name: DevProjectName
}

resource pool 'Microsoft.DevCenter/projects/pools@2024-05-01-preview' = {
  name: DevProjectPoolConfig.name
  location: DevProjectPoolConfig.networkConnectionLocation
  parent: devProject
  tags: tags
  properties: {
    displayName: DevProjectPoolConfig.displayName
    networkConnectionName: DevProjectPoolConfig.networkConnectionName
    licenseType: 'Windows_Client'
    singleSignOnStatus: DevProjectPoolConfig.singleSignOn
    stopOnDisconnect: DevProjectPoolConfig.StopOnDisconnectAfter >= 0 ? { gracePeriodMinutes: max(min(DevProjectPoolConfig.StopOnDisconnectAfter, 480), 60), status: 'Enabled' } : null
    devBoxDefinitionName: DevProjectPoolConfig.devBoxDefinition
    localAdministrator: DevProjectPoolConfig.localAdministrator
  }
}
