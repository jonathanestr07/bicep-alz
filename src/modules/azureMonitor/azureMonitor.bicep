@description('Specify the name of the workspace.')
param workspaceName string

@description('Specify the location for the workspace.')
param location string = resourceGroup().location

@description('Specify the name of the resource group where the virtual network is located.')
param resourceGroupNamevNet string

@description('Specify the name of the virtual network.')
param vnetName string

@description('Specify the name of the subnet.')
param subnetName string

@description('Optional. Specify the private DNS zone ID for the private endpoint.')
param privateDnsZoneId string = ''

resource workspace 'Microsoft.Monitor/accounts@2023-04-03' = {
  name: workspaceName
  location: location
}

var subnetId = resourceId(resourceGroupNamevNet, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-03-01' = {
  name: 'pe-${workspaceName}'
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    customNetworkInterfaceName: 'pe-${workspaceName}-nic'
    privateLinkServiceConnections: [
      {
        name: '${workspaceName}-link'
        properties: {
          privateLinkServiceId: workspace.id
          groupIds: [
            'prometheusMetrics'
          ]
        }
      }
    ]
  }
}

resource privateDnsZone 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-01-01' = if (!empty(privateDnsZoneId)) {
  name: 'default'
  parent: privateEndpoint
  properties: {
    privateDnsZoneConfigs: [
      {
        name: uniqueString(workspaceName)
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}

output workspaceId string = workspace.id
