metadata name = 'ALZ Bicep - Virtual Network Peering module'
metadata description = 'Module used to set up Virtual Network Peering between Virtual Networks'
metadata version = '1.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('The Name of Vnet Peering resource.')
param name string = '${sourceVirtualNetworkName}-${destinationVirtualNetworkName}'

@description('Virtual Network ID of Virtual Network destination.')
param destinationVirtualNetworkId string = ''

@description('Name of source Virtual Network we are peering.')
param sourceVirtualNetworkName string = ''

@description('Name of destination virtual network we are peering.')
param destinationVirtualNetworkName string = ''

@description('Switch to enable/disable Virtual Network Access for the Network Peer.')
param allowVirtualNetworkAccess bool = true

@description('Switch to enable/disable forwarded traffic for the Network Peer.')
param allowForwardedTraffic bool = true

@description('Switch to enable/disable gateway transit for the Network Peer.')
param allowGatewayTransit bool = false

@description('Switch to enable/disable remote gateway for the Network Peer.')
param useRemoteGateways bool = false

@description('Set Parameter to true to Opt-out of deployment telemetry.')
param telemetryOptOut bool = false

// Customer Usage Attribution Id
var cuaid = 'ab8e3b12-b0fa-40aa-8630-e3f7699e2142'

// Resource: Virtual Network Peering
resource virtualNetworkPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  name: '${sourceVirtualNetworkName}/${name}'
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: destinationVirtualNetworkId
    }
  }
}

// Module: Customer Usage Attribution
module customerUsageAttribution '../CARML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${cuaid}-${uniqueString(resourceGroup().location)}'
  params: {}
}
