param networkObject object
param tags object


resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: networkObject.name
  location: networkObject.location
  tags: tags
  properties: {
    addressSpace: [for range in networkObject.properties.cdrRange: {
      addressPrefixes: range.cdr
    }]
    subnets: [for subnet in networkObject.properties.subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.cdrRange
      }
    }]
  }
}

// resource networkConnection 'Microsoft.DevCenter/networkConnections@2023-01-01-preview' = if (networkObject.devBoxAttach.domainjoinType == 'Entra') {
//   name: networkObject.devBoxAttach.name
//   location: networkObject.location
//   properties: {
//     subnetId: '${vnet.id}/subnets/${networkObject.devBoxAttach.subnetName}'
//     networkingResourceGroupName: networkObject.devBoxAttach.resourceGroupName
//     domainJoinType: Entra
//   }
//   tags: tags
// }

// // If a devcenter resource id was provided attach the nc to the devcenter
// module networkAttach 'networkAttach.bicep' = if ((!empty(devCenterId)) && (vnetObject.domainjoinType != 'None')) {
//   scope: resourceGroup(devCenterSub, devCenterGroup)
//   name: 'conn${vnetObject.name}-attach'
//   params: {
//     #disable-next-line BCP335
//     name: networkConnection.name
//     devCenterName: devCenterName
//     #disable-next-line BCP334
//     networkConnectionId: networkConnection.id
//   }
// }
