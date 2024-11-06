param sqlAdministratorLogin string
@secure()
param sqlAdministratorLoginPassword string
param location string = resourceGroup().location

var sqlServerName = 'sqlserver${uniqueString(resourceGroup().id)}'
var databaseName = 'sample-db'
var privateEndpointName = 'myPrivateEndpoint'
var vnetName = 'vnet${uniqueString(resourceGroup().id)}'
var subnetName = 'adesubnet'


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
  parent: sqlServer
  name: databaseName
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}

// resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = { 
//   name: 'DevboxVnetWest3'
// }
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

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





// @description('Specifies app plan SKU')
// param skuName string = 'F1'

// @description('Specifies app plan capacity')
// param skuCapacity int = 1

// @description('Specifies sql admin login')
// param sqlAdministratorLogin string

// @description('Specifies sql admin password')
// @secure()
// param sqlAdministratorPassword string

// param databaseName string

// param dacpacstorageuri string = 'https://bfyostoragealpha.blob.core.windows.net/sqldacpacs/AppDbInitial.bacpac'



// // Data resources
// resource sqlserver 'Microsoft.Sql/servers@2023-05-01-preview' = {
//   name: 'sqlserver${uniqueString(resourceGroup().id)}'
//   location: resourceGroup().location
//   identity: {
//     type: 'SystemAssigned'
//   }
//   properties: {
//     administratorLogin: sqlAdministratorLogin
//     administratorLoginPassword: sqlAdministratorPassword
//     version: '12.0'
//     publicNetworkAccess: 'Enabled'
//   }

//   resource database 'databases@2021-11-01-preview' = {
//     name: databaseName
//     location: resourceGroup().location
//     sku: {
//       name: 'Basic'
//     }
//     properties: {
//       collation: 'SQL_Latin1_General_CP1_CI_AS'
//       maxSizeBytes: 1073741824      
//     }
//   }

//   resource firewallRule 'firewallRules@2020-11-01-preview' = {
//     name: 'AllowAllWindowsAzureIps'
//     properties: {
//       endIpAddress: '0.0.0.0'
//       startIpAddress: '0.0.0.0'
//     }
//   }

//   resource sqlImport 'extensions@2023-05-01-preview' = {
//     name: 'sqlImportdacpac'    
//     properties: {
//       administratorLogin: sqlAdministratorLogin
//       administratorLoginPassword: sqlAdministratorPassword
//       operationMode: 'import'
//       storageUri: dacpacstorageuri
//     }
//     dependsOn:[ database]
//   }
  
// }


// // Web App resources
// resource hostingPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
//   name: 'hostingplan${uniqueString(resourceGroup().id)}'
//   location: resourceGroup().location
//   sku: {
//     name: skuName
//     capacity: skuCapacity
//   }
// }

// resource webSite 'Microsoft.Web/sites@2020-12-01' = {
//   name: 'webSite${uniqueString(resourceGroup().id)}'
//   location: resourceGroup().location
//   tags: {
//     'hidden-related:${hostingPlan.id}': 'empty'
//     displayName: 'Website'
//   }
//   properties: {
//     serverFarmId: hostingPlan.id
//   }
//   identity: {
//     type: 'SystemAssigned'    
//   }

//   resource connectionString 'config@2020-12-01' = {
//     name: 'connectionstrings'
//     properties: {
//       DefaultConnection: {
//         value: 'Data Source=tcp:${sqlserver.properties.fullyQualifiedDomainName},1433;Initial Catalog=${sqlserver::database.name};User Id=${sqlserver.properties.administratorLogin}@${sqlserver.properties.fullyQualifiedDomainName};Password=${sqlAdministratorPassword};'
//         type: 'SQLAzure'
//       }
//     }
//   }
// }

// // resource roleassignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
// //   name: guid(msi.id, resourceGroup().id, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
// //   properties: {
// //     principalType: 'ServicePrincipal'
// //     roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
// //     principalId: msi.properties.principalId
// //   }
// // }

// // Monitor
// resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
//   name: 'AppInsights${webSite.name}'
//   location: resourceGroup().location
//   tags: {
//     'hidden-link:${webSite.id}': 'Resource'
//     displayName: 'AppInsightsComponent'
//   }
//   kind: 'web'
//   properties: {
//     Application_Type: 'web'
//   }
// }
