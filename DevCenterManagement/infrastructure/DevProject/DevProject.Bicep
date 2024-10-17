import * as consts from '../Shared/consts.bicep'
param devProjectConfigObject object
param devCenterResourceId string

resource devProject 'Microsoft.DevCenter/projects@2024-02-01' = {
  name: devProjectConfigObject.Name
  location: devProjectConfigObject.Location
  tags: devProjectConfigObject.tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    #disable-next-line use-resource-id-functions
    devCenterId: devCenterResourceId
    displayName: devProjectConfigObject.Name
    maxDevBoxesPerUser: devProjectConfigObject.devboxlimits
  }
}


// Create the DevCenter catalogs - GitHub
resource ghcatalogs 'Microsoft.DevCenter/projects/catalogs@2024-08-01-preview' = [for (catalog, index) in devProjectConfigObject.catalogs : if(catalog.properties.type == 'gitHub'){
  parent: devProject
  name: catalog.name
  properties: {
    gitHub: {
      uri: catalog.properties.uri
      path: catalog.properties.path
    }
  }
}]

// Create the DevCenter catalogs - GitHub
resource adocatalogs 'Microsoft.DevCenter/projects/catalogs@2024-08-01-preview' = [for (catalog, index) in devProjectConfigObject.catalogs : if(catalog.properties.type == 'adoGit'){
  parent: devProject
  name: catalog.name
  properties: {
    adoGit: {
      uri: catalog.properties.uri
      path: catalog.properties.path
    }
  }
}]

//resource devboxprojectdefinitions 'Microsoft.DevCenter/projects/devboxdefinitions@2024-08-01-preview' 

resource roleAssignmentProjectAdmin 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (item, index) in devProjectConfigObject.devProjectAdmins: {
  name: guid(devProject.id, item.PrincipalId, consts.DevProjectRoleDefinitionId.ProjectAdmin)
  scope: devProject
  properties: {
    #disable-next-line use-resource-id-functions
    roleDefinitionId: consts.DevProjectRoleDefinitionId.ProjectAdmin
    principalId: item.principalId
    principalType: item.type
  }
}]

resource roleAssignmentDevBoxUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (item, index) in devProjectConfigObject.devProjectDevboxUsers: {
  name: guid(devProject.id, item.PrincipalId, consts.DevProjectRoleDefinitionId.DevBoxUser)
  scope: devProject
  properties: {
    #disable-next-line use-resource-id-functions
    roleDefinitionId: consts.DevProjectRoleDefinitionId.DevBoxUser
    principalId: item.principalId
    principalType: item.type
  }
}]

resource roleAssignmentDeployEnvUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (item, index) in devProjectConfigObject.deploymentEnvironmentUsers: {
  name: guid(devProject.id, item.PrincipalId, consts.DevProjectRoleDefinitionId.EnvironmentUser)
  scope: devProject
  properties: {
    #disable-next-line use-resource-id-functions
    roleDefinitionId: consts.DevProjectRoleDefinitionId.EnvironmentUser
    principalId: item.principalId
    principalType: item.type
  }
}]

module environmentType '../Shared/newEnvironmentType.bicep' = [for (env, index) in devProjectConfigObject.environmentTypes: {
  name: '${env.dcEnvName}-ProjectEnvType'
  params: {
    devProjectName : devProject.name
    environmentType: env
  }
}]

