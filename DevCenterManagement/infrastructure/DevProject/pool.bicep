
targetScope = 'resourceGroup'

param DevProjectName string
param DevProjectLocation string = resourceGroup().location
param DevProjectStage types.Stage
param DevProjectPool types.DevBoxPool
param NetworkConnectionInfo types.NetworkConnectionInfo[]

// ================== Variables ==================


// ================== Resources ==================

resource devProject 'Microsoft.DevCenter/projects@2024-02-01' existing = {
  name: tools.GetDevProjectResourceName(DevProjectName, DevProjectLocation, DevProjectStage)
}

resource pool 'Microsoft.DevCenter/projects/pools@2024-05-01-preview' = [for (item, index) in NetworkConnectionInfo: {
  name: tools.GetDevBoxPoolResourceName(DevProjectPool.Name, DevProjectLocation, DevProjectStage, uniqueString(tools.ToStringResourceId(item.NetworkResourceId)))
  location: DevProjectLocation
  parent: devProject
  properties: {
    displayName: '${DevProjectPool.Name}-${tools.GetSupportedRegionShortcutName(item.NetworkLocation)}'
    networkConnectionName: last(item.NetworkRegistrationResourceId.subResources).resourceName
    licenseType: 'Windows_Client'
    singleSignOnStatus: tools.ToEnabledDisabled(DevProjectPool.SingleSignOn)    
    stopOnDisconnect: DevProjectPool.StopOnDisconnectAfter >= 0 ? { gracePeriodMinutes: max(min(DevProjectPool.StopOnDisconnectAfter, 480), 60), status: 'Enabled' } : null
    devBoxDefinitionName: DevProjectPool.DevBoxDefinitionName
    localAdministrator: tools.ToEnabledDisabled(DevProjectPool.LocalAdministrator)
  }
}]
