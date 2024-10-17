targetScope = 'resourceGroup'

import * as consts from '../shared/consts.bicep'

param galleryConfigObject object
param devcenterPrincipalID string
param win365Id string

resource galleryResource 'Microsoft.Compute/galleries@2023-07-03' = {
  name: galleryConfigObject.name
  location: galleryConfigObject.location
  tags: galleryConfigObject.tags
  properties: {
    description: galleryConfigObject.description
    identifier: {}
  }
}

var ContributorRole = consts.GeneralRoleDefinitionId.Contributor
resource roleAssignmentContributor 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(devcenterPrincipalID, resourceGroup().name, ContributorRole)
  properties: {
    #disable-next-line use-resource-id-functions
    roleDefinitionId: ContributorRole
    principalId: devcenterPrincipalID
    principalType: 'ServicePrincipal'
  }
}

var ReaderRole = consts.GeneralRoleDefinitionId.Reader
resource roleAssignmentReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(devcenterPrincipalID, resourceGroup().name, ReaderRole)
  properties: {
    #disable-next-line use-resource-id-functions
    roleDefinitionId: ReaderRole
    principalId: win365Id
    principalType: 'ServicePrincipal'
  }
}

output galleryName string = galleryResource.name
output galleryId string = galleryResource.id
