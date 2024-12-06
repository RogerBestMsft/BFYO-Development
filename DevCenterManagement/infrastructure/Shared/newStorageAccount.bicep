param storageAccountObject object
param devCenterName string
param tags object

var roleId = guid(storageAccountObject.name, resourceGroup().name)

resource storagedevcenter 'Microsoft.DevCenter/devcenters@2024-08-01-preview' existing =  {
  name: devCenterName
 }


// create storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: storageAccountObject.Name
  location: storageAccountObject.Location
  kind: 'StorageV2'
  sku: {
   name: 'Standard_LRS'
  }
  tags:tags
}

// assign dev center identity secrets officer role on key vault
resource storageAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleId
  properties: {
    principalId: storagedevcenter.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: secretsOfficerRoleResourceId
  }
  scope: storageAccount
}

// add the data to the storage account

