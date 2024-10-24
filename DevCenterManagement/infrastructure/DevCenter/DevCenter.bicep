param devCenterConfigObject object
param repoSecrets string

// Create the DevCenter using the devCenterConfigObject from the configurations
resource devcenter 'Microsoft.DevCenter/devcenters@2024-08-01-preview' = {
  name: devCenterConfigObject.name
  location: devCenterConfigObject.location
  tags: devCenterConfigObject.tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    projectCatalogSettings: {
      catalogItemSyncEnableStatus: 'Enabled'
    }
  }
}

module keyvaults '../Shared/newKeyVault.bicep' = [for (vault,i) in devCenterConfigObject.keyvaults: {
  name: '${take(deployment().name, 36)}-vault${i}'
  params: {
    keyvaultObject: vault
    devCenterName: devcenter.name
    secretValue: repoSecrets
    tags: devCenterConfigObject.tags    
  }
}]


// Create the DevCenter environment types
resource environmenttype 'Microsoft.DevCenter/devcenters/environmentTypes@2024-08-01-preview' = [for environtype in devCenterConfigObject.environmenttypes : {
    parent: devcenter
    name: environtype.name
}]

// Create the DevCenter DevBox definitions
resource devboxdefinition 'Microsoft.DevCenter/devcenters/devboxdefinitions@2024-08-01-preview' = [for definition in devCenterConfigObject.devboxdefinitions : {
  parent: devcenter
  name: definition.name
  location: definition.location
  properties: {
    imageReference: definition.properties.imagereference
    sku: definition.properties.sku
    osStorageType: definition.properties.osstoragetype
    hibernateSupport: definition.properties.hibernateSupport
  }
}]

// Create the DevCenter catalogs - GitHub
resource ghcatalogs 'Microsoft.DevCenter/devcenters/catalogs@2024-08-01-preview' = [for (catalog, index) in devCenterConfigObject.catalogs : if(catalog.properties.type == 'gitHub'){
  parent: devcenter
  name: catalog.name
  properties: {
    gitHub: {
      uri: catalog.properties.uri
      path: catalog.properties.path
      secretIdentifier: keyvaults[index].outputs.secretUri
    }
  }
  dependsOn: [ keyvaults]
}]

// Create the DevCenter catalogs - ADOGit
// resource adocatalogs 'Microsoft.DevCenter/devcenters/catalogs@2024-08-01-preview' = [for (catalog, index) in devCenterConfigObject.catalogs : if(catalog.properties.type == 'adoGit'){
//   parent: devcenter
//   name: catalog.name
//   properties: {
//     adoGit: {
//       uri: catalog.properties.uri
//       path: catalog.properties.path
//     }
//   }
// }]


output devCenterPrincipalId string = devcenter.identity.principalId
output devCenterId string = devcenter.id
