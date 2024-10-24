targetScope = 'subscription'

param devCenterConfigObject object
param win365Id string
param repoSecrets string

resource devCenterResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: devCenterConfigObject.resourceGroupName
  location: devCenterConfigObject.Location
  tags: devCenterConfigObject.tags
}

module devcenter 'DevCenter.bicep' = {
  name: devCenterConfigObject.name
  scope: devCenterResourceGroup
  params: {
    devCenterConfigObject: devCenterConfigObject
    repoSecrets: repoSecrets
  }
}

resource galleryResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = [for galleryrg in devCenterConfigObject.galleries: {
  name: galleryrg.resourceGroupName
  location: galleryrg.location
  tags: devCenterConfigObject.tags
}]

module dcgallery '../Shared/newGallery.bicep' = [for (gallery,i) in devCenterConfigObject.galleries: {
  name: '${take(deployment().name, 36)}-gallery${i}'
  scope: galleryResourceGroup[i]
  params: {
    galleryConfigObject: gallery
    devcenterPrincipalID: devcenter.outputs.devCenterPrincipalId
    win365Id: win365Id
  }
  dependsOn: [
    galleryResourceGroup
  ]
}]

module gallerydcconnect '../Shared/devcenterGalleryConnect.bicep' = [for (gallery,i) in devCenterConfigObject.galleries : {
  scope: devCenterResourceGroup
  name: gallery.name
  params: {
    galleryName: dcgallery[i].outputs.galleryName
    galleryId: dcgallery[i].outputs.galleryId
    devcenterName: devcenter.name
  }
 }]

output test array = [for (gal,i) in devCenterConfigObject.galleries: {
  name: dcgallery[i].name
  outputs: dcgallery[i].outputs
}]

output devcenterObject object = devcenter.outputs

