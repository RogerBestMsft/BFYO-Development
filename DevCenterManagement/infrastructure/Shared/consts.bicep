// =================================================================================
// Consts
// =================================================================================

func createRoleDefinitionId(roleDefinitionName string) string =>
  resourceId(subscription().subscriptionId, 'Microsoft.Authorization/roleDefinitions', roleDefinitionName)

@export()
func GetGeneralRoleDefinitionId() object => {
  Contributor: createRoleDefinitionId('b24988ac-6180-42a0-ab88-20f7382dd24c')
  Reader: createRoleDefinitionId('acdd72a7-3385-48ef-bd42-f606fba81ae7')
  Owner: createRoleDefinitionId('8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  RoleBasedAccessControlAdministrator: createRoleDefinitionId('f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  UserAccessAdministrator: createRoleDefinitionId('18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

@export()
var GeneralRoleDefinitionId = {
  Contributor: createRoleDefinitionId('b24988ac-6180-42a0-ab88-20f7382dd24c')
  Reader: createRoleDefinitionId('acdd72a7-3385-48ef-bd42-f606fba81ae7')
  Owner: createRoleDefinitionId('8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  RoleBasedAccessControlAdministrator: createRoleDefinitionId('f58310d9-a9f6-439a-9e8d-f62e7b41a168')
  UserAccessAdministrator: createRoleDefinitionId('18d7d88d-d35e-4fb5-a5c3-7773c20a72d9')
}

@export()
var DevProjectRoleDefinitionId = {
  ProjectAdmin: createRoleDefinitionId('331c37c6-af14-46d9-b9f4-e1909e1b95a0')
  DevBoxUser: createRoleDefinitionId('45d50f46-0b78-4001-a660-4198cbe8cd05')
  EnvironmentUser: createRoleDefinitionId('18e40d4e-8d2e-438d-97e1-9528336e149c')
}

@export()
var KeyVaultRoleDefinitionId = {
  SecretsUser: createRoleDefinitionId('4633458b-17de-408a-b874-0445c86b69e6')
}

@export()
type CharacterSet = 'Alphanumeric' | 'AlphanumericUCase'| 'AlphanumericLCase' | 'Numeric' | 'Alphabetic' | 'AlphabeticUCase' | 'AlphabeticLCase' | 'NonAlphanumeric' 

@export()
func GetCharacterSet(characterSet CharacterSet) string => 
  string(characterSet) == 'Alphanumeric' ? 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' 
  : string(characterSet) == 'AlphanumericUCase' ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' 
  : string(characterSet) == 'AlphanumericLCase' ? 'abcdefghijklmnopqrstuvwxyz0123456789' 
  : string(characterSet) == 'Numeric' ? '0123456789'
  : string(characterSet) == 'Alphabetic' ? 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  : string(characterSet) == 'AlphabeticUCase' ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  : string(characterSet) == 'AlphabeticLCase' ? 'abcdefghijklmnopqrstuvwxyz'
  : string(characterSet) == 'NonAlphanumeric' ? '!@#$%^&*()_+{}|:<>?~`-=[]\\;,./'
  : ''

@export()
func GetCharacterSetExtended(characterSet CharacterSet, customCharacterSet string) string =>
  '${GetCharacterSet(characterSet)}${customCharacterSet}'

