param keyvaultName string
param projectName string

var secretId = guid(projectName, resourceGroup().name)
var secretsOfficerRoleResourceId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b86a8fe4-44ce-4948-aee5-eccb2c155cd7')


// Get Project
resource devProject 'Microsoft.DevCenter/projects@2024-02-01' existing = {
  name: projectName
}

// Get the key vault
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyvaultName
}

// assign project identity secrets officer role on key vault
resource keyVaultAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: secretId
  properties: {
    principalId: devProject.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: secretsOfficerRoleResourceId
  }
  scope: keyVault
}
