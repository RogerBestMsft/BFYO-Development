import * as consts from '../Shared/consts.bicep'
param devProjectConfigObject object

resource devProject 'Microsoft.DevCenter/projects@2024-02-01' = {
  name: devProjectConfigObject.Name
  location: devProjectConfigObject.Location
  tags: devProjectConfigObject.tags
  properties: {
    #disable-next-line use-resource-id-functions
    devCenterId: subscriptionResourceId(devProjectConfigObject.devCenter.subscriptionId,'DevCenter',devProjectConfigObject.devCenter.name)
    displayName: devProjectConfigObject.Name
    maxDevBoxesPerUser: devProjectConfigObject.devboxlimits
  }
}


// module pool 'pool.bicep' = [for (item, index) in DevProjectPools: {
//   name: tools.CreateModuleNameWithIndex('pool', index)
//   params: {
//     DevProjectName: DevProjectName
//     DevProjectLocation: DevProjectLocation
//     DevProjectStage: DevProjectStage
//     DevProjectPool: item
//     NetworkConnectionInfo: [for i in range(0, length(DevProjectSubnetResourceIds)): networkConnection[i].outputs.networkConnectionInfo]
//   }
// }]

resource roleAssignmentProjectAdmin 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (item, index) in devProjectConfigObject.devProjectAdmins: {
  name: guid(devProject.id, item.PrincipalId, consts.DevProjectRoleDefinitionId.ProjectAdmin)
  scope: devProject
  properties: {
    #disable-next-line use-resource-id-functions
    roleDefinitionId: consts.DevProjectRoleDefinitionId.ProjectAdmin
    principalId: item.PrincipalId
    principalType: item.PrincipalType
  }
}]

resource roleAssignmentDevBoxUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (item, index) in devProjectConfigObject.devProjectDevboxUsers: {
  name: guid(devProject.id, item.PrincipalId, consts.DevProjectRoleDefinitionId.DevBoxUser)
  scope: devProject
  properties: {
    #disable-next-line use-resource-id-functions
    roleDefinitionId: consts.DevProjectRoleDefinitionId.DevBoxUser
    principalId: item.PrincipalId
    principalType: item.PrincipalType
  }
}]

resource roleAssignmentDeployEnvUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (item, index) in devProjectConfigObject.deploymentEnvironmentUsers: {
  name: guid(devProject.id, item.PrincipalId, consts.DevProjectRoleDefinitionId.EnvironmentUser)
  scope: devProject
  properties: {
    #disable-next-line use-resource-id-functions
    roleDefinitionId: consts.DevProjectRoleDefinitionId.EnvironmentUser
    principalId: item.PrincipalId
    principalType: item.PrincipalType
  }
}]
