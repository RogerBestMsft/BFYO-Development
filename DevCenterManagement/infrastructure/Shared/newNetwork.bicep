param networkObject object
param tags object


resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: networkObject.name
  location: networkObject.location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: networkObject.properties.cdrRange
    }
    subnets: [for subnet in networkObject.properties.subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.cdrRange
      }
    }]
  }
}

resource networkConnectionEntra 'Microsoft.DevCenter/networkConnections@2023-04-01' = if (networkObject.devBoxConnect.joinType == 'EntraJoin') {
  name: networkObject.devBoxConnect.name
  location: networkObject.location
  properties: {
    subnetId: '${vnet.id}/subnets/${networkObject.devBoxConnect.subnetName}'
    networkingResourceGroupName: networkObject.devBoxConnect.resourceGroupName
    domainJoinType: 'AzureADJoin'
  }
  tags: tags
}

// resource networkConnectionHybrid 'Microsoft.DevCenter/networkConnections@2023-01-01-preview' = if (networkObject.devBoxConnect.domainjoinType == 'HybridJoin') {
//   name: networkObject.devBoxConnect.Name
//   location: networkObject.location
//   properties: {
//     subnetId: '${vnet.id}/subnets/${networkObject.devBoxConnect.subnetName}'
//     networkingResourceGroupName: networkObject.devBoxConnect.resourceGroupName
//     domainJoinType: 'HybridAzureADJoin'
//     // Missing other information
//   }
//   tags: tags
// }

//output networkConnectionObject object = networkConnectionEntra
output networkAttachId string = networkConnectionEntra.id
