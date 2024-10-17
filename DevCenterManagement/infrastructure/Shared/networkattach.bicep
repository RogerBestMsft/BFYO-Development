param netAttachName string
param devCenterName string
param networkConnectionId string

// Use the network connection name if no name was provided
var attachName = !empty(netAttachName) ? netAttachName : last(split(networkConnectionId, '/'))

resource devCenter 'Microsoft.DevCenter/devcenters@2023-01-01-preview' existing = {
  name: devCenterName
}

resource networkAttach 'Microsoft.DevCenter/devcenters/attachednetworks@2023-01-01-preview' = {
  name: attachName
  parent: devCenter
  properties: {
    networkConnectionId: networkConnectionId
  }
}
