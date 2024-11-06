param sqlAdministratorLogin string
@secure()
param sqlAdministratorLoginPassword string
param location string = resourceGroup().location

var sqlServerName = 'sqlserver${uniqueString(resourceGroup().id)}'
var databaseName = 'sample-db'
var privateEndpointName = 'myPrivateEndpoint'

resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    version: '12.0'
    publicNetworkAccess: 'Disabled'
  }
}

resource database 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  name: '${sqlServerName}/${databaseName}'
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = { 
  name: 'DevboxVnetWest3'
}
// resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
//   name: vnetName
//   location: location
//   properties: {
//     addressSpace: {
//       addressPrefixes: ['10.0.0.0/16']
//     }
//     subnets: [
//       {
//         name: subnetName
//         properties: {
//           addressPrefix: '10.0.0.0/24'
//         }
//       }
//     ]
//   }
// }

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-02-01' = {
  name: privateEndpointName
  location: location
  properties: {
    subnet: {
      id: vnet.properties.subnets[0].id
    }
    privateLinkServiceConnections: [
      {
        name: 'sqlPrivateLink'
        properties: {
          privateLinkServiceId: sqlServer.id
          groupIds: ['sqlServer']
        }
      }
    ]
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.database.windows.net'
  location: 'global'
}

// resource privateDnsZoneGroup 'Microsoft.Network/privateDnsZoneGroups@2024-01-01' = {
//   name: 'sqlPrivateDnsZoneGroup'
//   properties: {
//     privateDnsZoneConfigs: [
//       {
//         name: 'sqlPrivateDnsZoneConfig'
//         properties: {
//           privateDnsZoneId: privateDnsZone.id
//         }
//       }
//     ]
//   }
// }

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-01-01' = {
  parent: privateEndpoint
  name: 'sqlPrivateDnsZoneGroup'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'sqlPrivateDnsZoneConfig'
        properties: {
          privateDnsZoneId: privateDnsZone.id
        }
      }
    ]
  }
}
