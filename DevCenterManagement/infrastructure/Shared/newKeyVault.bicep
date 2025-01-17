param keyvaultObject object
param tags object
param devCenterName string

var secretId = guid(keyvaultObject.name, resourceGroup().name)
var secretsOfficerRoleResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')


// Get devCenter
resource devCenter 'Microsoft.DevCenter/devcenters@2024-08-01-preview' existing = {
  name: devCenterName
}

// create a key vault
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyvaultObject.name
  location: keyvaultObject.location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: false
    tenantId: tenant().tenantId
    enableRbacAuthorization: true
    sku: {
      family: 'A'
      name: 'standard'
    }
  }
  tags: tags
}

// assign dev center identity secrets officer role on key vault
resource keyVaultAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: secretId
  properties: {
    principalId: devCenter.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: secretsOfficerRoleResourceId
  }
  scope: keyVault
}

// add the github pat token to the key vault
// resource repoAccessSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
//   name: 'github-pat'
//   parent: keyVault
//   properties: {
//     value: secretValue
//     attributes: {
//       enabled: true
//     }
//   }
//   tags: tags
// }


// module kvSecrets '../Shared/addSecret.bicep' = [for (secret,i) in secretValue: {
//   name: '${take(deployment().name, 36)}-vault${i}'
//   params: {
//     keyvaultName: keyVault.name
//     secretName: secret.name
//     secretValue: secret.value
//     tags: tags    
//   }
// }]



//output secretUri array = kvSecrets.properties.secretUriWithVersion
// output secretUri array  = [ for (secret,i) in secretValue: {
//   name: secret
//   value: secretValue[i].outputs
// }]

