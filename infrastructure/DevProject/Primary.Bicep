targetScope = 'subscription'

param devProjectConfigObject object

resource devProjectResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: devProjectConfigObject.resourceGroupName
  location: devProjectConfigObject.Location
  tags: devProjectConfigObject.tags
}

module devproject 'DevProject.bicep' = {
  name: devProjectConfigObject.name
  scope: devProjectResourceGroup
  params: {
    devProjectConfigObject: devProjectConfigObject
  }  
}

resource devProjectNetworkResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = [for (network,i) in devProjectConfigObject.networks :{
  name: network.resourceGroupName
  location: network.Location
  tags: devProjectConfigObject.tags
}]


module devprojectnetwork '../Shared/network.bicep' = [for (network,i) in devProjectConfigObject.networks : {
  scope: devProjectNetworkResourceGroup[i]
  name: network.name
  params: {
    networkObject: network
    tags: devProjectConfigObject.tags
  }
 }]

//output devProjectObject object = devcenter.outputs

