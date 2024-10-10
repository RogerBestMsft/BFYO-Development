targetScope = 'resourceGroup'

import * as consts from '../shared/consts.bicep'

param galleryName string
param galleryId string
param devcenterName string
//param win365Id string

 resource gallerydevcenter 'Microsoft.DevCenter/devcenters@2024-08-01-preview' existing =  {
  name: devcenterName
 }

  resource gallerydcconnect 'Microsoft.DevCenter/devcenters/galleries@2023-04-01' = {
  name: galleryName
  parent: gallerydevcenter
  properties: {
    galleryResourceId: galleryId
  }
 }
