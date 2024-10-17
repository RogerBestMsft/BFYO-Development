targetScope = 'subscription'

param resourceGroupObject object

resource newResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupObject.Name
  location: resourceGroupObject.Location
}
