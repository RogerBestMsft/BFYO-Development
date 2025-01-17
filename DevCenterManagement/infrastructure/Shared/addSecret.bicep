param keyvaultName string
param secretName string
@secure()
param secretValue string
param tags object

resource keyVault 'Microsoft.KeyVault/vaults@2024-04-01-preview' existing = {
  name: keyvaultName
}

 resource repoAccessSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: secretName
  parent: keyVault
  properties: {
    value: secretValue
    attributes: {
      enabled: true
    }
  }
  tags: tags
}

output secretUri string = repoAccessSecret.properties.secretUri
