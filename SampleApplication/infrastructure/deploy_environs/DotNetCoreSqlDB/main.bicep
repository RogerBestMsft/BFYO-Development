targetScope = 'subscription'

@description('Specifies region for all resources')
param resourceGroupName string

// @description('Specifies app plan SKU')
// param skuName string = 'F1'

// @description('Specifies app plan capacity')
// param skuCapacity int = 1

@description('Specifies sql admin login')
param sqlAdministratorLogin string

@description('Specifies sql admin password')
@secure()
param sqlAdministratorLoginPassword string

//var databaseName = 'sampledb'

resource primaryRg 'Microsoft.Resources/resourceGroups@2024-03-01' existing =  {
  name: resourceGroupName
}

module devcenter 'sqlResource.bicep' = {
  name: uniqueString(resourceGroupName)
  scope: primaryRg
  params: {
    //skuName: skuName
    //skuCapacity: skuCapacity
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
    //databaseName: databaseName
  }
}

