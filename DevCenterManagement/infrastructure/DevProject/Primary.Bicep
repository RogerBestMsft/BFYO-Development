targetScope = 'subscription'

param devProjectConfigObject object

resource devCenterGroup 'Microsoft.Resources/resourceGroups@2024-03-01' existing = {
  name: devProjectConfigObject.devCenter.resourceGroupName
}

resource devcenter 'Microsoft.DevCenter/devcenters@2024-08-01-preview' existing = {
  scope: devCenterGroup
  name: devProjectConfigObject.devCenter.name
}

resource devProjectResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: devProjectConfigObject.resourceGroupName
  location: devProjectConfigObject.Location
  tags: devProjectConfigObject.tags
}

module devproject 'DevProject.bicep' = {
  scope: devProjectResourceGroup
  name: devProjectConfigObject.name  
  params: {
    devProjectConfigObject: devProjectConfigObject
    devCenterResourceId: devcenter.id
  }  
}

resource devProjectNetworkResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = [for (network,i) in devProjectConfigObject.networks :{
  name: network.resourceGroupName
  location: network.Location
  tags: devProjectConfigObject.tags
}]


module devprojectnetwork '../Shared/newNetwork.bicep' = [for (network,i) in devProjectConfigObject.networks : {
  scope: devProjectNetworkResourceGroup[i]
  name: network.name
  params: {
    networkObject: network
    tags: devProjectConfigObject.tags
  }
 }]

// If a devcenter resource id was provided attach the nc to the devcenter
// Use the index from the list of networks to get the correct networkConnection object - Yay indexes

module networkAttach '../Shared/networkattach.bicep' = [for (network,i) in devProjectConfigObject.networks : {
  scope: devCenterGroup
  name: network.devBoxNetAttachName
  params: {
    #disable-next-line BCP335
    netAttachName: devprojectnetwork[i].name
    devCenterName: devcenter.name
    #disable-next-line BCP334
    networkConnectionId: devprojectnetwork[i].outputs.networkAttachId
  }
}]

module pool '../Shared/newPool.bicep' = [for (pool, index) in devProjectConfigObject.pools: {
  scope: devProjectResourceGroup
  dependsOn: [ networkAttach ]
  name: pool.name
  params: {
    DevProjectName: devproject.name
    DevProjectPoolConfig: pool
    tags: devProjectConfigObject.tags
  }
}]

module environmentType '../Shared/newEnvironmentType.bicep' = [for (env, index) in devProjectConfigObject.environmentTypes: {
  scope: devProjectResourceGroup
  dependsOn: [pool]
  name: '${env.dcEnvName}-ProjectEnvType'
  params: {
    devProjectName : devproject.name
    environmentType: env
  }
}]


output devProjectObject object = devproject
output devProjectNetworks array  = [ for (network,i) in devProjectConfigObject.networks: {
  id: devprojectnetwork[i].outputs
  name: devprojectnetwork[i].name
}]


