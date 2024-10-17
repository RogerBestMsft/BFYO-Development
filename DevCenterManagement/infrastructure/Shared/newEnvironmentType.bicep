// This is the project environment type
targetScope = 'resourceGroup'

param devProjectName string
param environmentType object

var creatorRoleAssignment = { roles: toObject(environmentType.creatorRoleAssignment, item => item, item => {})}

resource devProject 'Microsoft.DevCenter/projects@2023-10-01-preview' existing = {
  name: devProjectName
}

resource environment 'Microsoft.DevCenter/projects/environmentTypes@2024-08-01-preview' = if (environmentType.Identity == 'SystemManaged') {
  name: environmentType.dcEnvName
  parent: devProject
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    deploymentTargetId: '/subscriptions/${environmentType.subscription}'
    status: 'Enabled'
    creatorRoleAssignment: creatorRoleAssignment
    userRoleAssignments: null
  }
}

output ZZZenvTypeRoleAssign object = creatorRoleAssignment
