metadata name = 'ALZ Bicep - Azure vWAN Hub Virtual Network Peerings'
metadata description = 'Module used to set up peering to Virtual Networks from vWAN Hub'
metadata author = 'Insight APAC Platform Engineering'

@description('Virtual WAN Hub resource Id.')
param virtualWanHubResourceId string = ''

@description('Remote Spoke virtual network resource Id.')
param remoteVirtualNetworkResourceId string = ''

@description('Optional Virtual Hub Connection Name Prefix.')
param virtualHubConnectionPrefix string = ''

@description('Optional Virtual Hub Connection Name Suffix. Example: -vhc')
param virtualHubConnectionSuffix string = '-vhc'

@description('Enable Internet Security for the Virtual Hub Connection.')
param enableInternetSecurity bool = false

var vwanHubName = split(virtualWanHubResourceId, '/')[8]
var spokeVnetName = split(remoteVirtualNetworkResourceId, '/')[8]
var vnetPeeringVwanName = '${vwanHubName}/${virtualHubConnectionPrefix}${spokeVnetName}${virtualHubConnectionSuffix}'

// Resource: vWAN Peering Connection
resource vnetPeeringVwan 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2023-02-01' = if (!empty(virtualWanHubResourceId) && !empty(remoteVirtualNetworkResourceId)) {
  name: vnetPeeringVwanName
  properties: {
    remoteVirtualNetwork: {
      id: remoteVirtualNetworkResourceId
    }
    enableInternetSecurity: enableInternetSecurity
  }
}

// Outputs
output hubVirtualNetworkConnectionName string = vnetPeeringVwan.name
output hubVirtualNetworkConnectionResourceId string = vnetPeeringVwan.id
