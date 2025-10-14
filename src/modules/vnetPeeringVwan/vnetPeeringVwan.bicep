targetScope = 'subscription'

metadata name = 'ALZ Bicep - Virtual Network Peering to vWAN'
metadata description = 'Module used to set up Virtual Network Peering from Virtual Network back to vWAN'
metadata version = '1.0.0'
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

@description('Optional. Set Parameter to true to Opt-out of deployment telemetry.')
param telemetryOptOut bool = false

// Customer Usage Attribution Id
var cuaid = '7b5e6db2-1e8c-4b01-8eee-e1830073a63d'

var vwanSubscriptionId = split(virtualWanHubResourceId, '/')[2]
var vwanResourceGroup = split(virtualWanHubResourceId, '/')[4]
var spokeVnetName = split(remoteVirtualNetworkResourceId, '/')[8]
var hubVirtualNetworkConnectionDeploymentName = take('deploy-vnet-peering-vwan-${spokeVnetName}', 64)

// Module: vWAN Peering Connection
module hubVirtualNetworkConnection 'hubVirtualNetworkConnection.bicep' = if (!empty(virtualWanHubResourceId) && !empty(remoteVirtualNetworkResourceId)) {
  scope: resourceGroup(vwanSubscriptionId, vwanResourceGroup)
  name: hubVirtualNetworkConnectionDeploymentName
  params: {
    virtualWanHubResourceId: virtualWanHubResourceId
    remoteVirtualNetworkResourceId: remoteVirtualNetworkResourceId
    virtualHubConnectionPrefix: virtualHubConnectionPrefix
    virtualHubConnectionSuffix: virtualHubConnectionSuffix
    enableInternetSecurity: enableInternetSecurity
  }
}

// Module: Customer Usage Attribution
module customerUsageAttribution '../CARML/customerUsageAttribution/cuaIdSubscription.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params
  name: 'pid-${cuaid}-${uniqueString(subscription().id, spokeVnetName)}'
  params: {}
}

// Outputs
output hubVirtualNetworkConnectionName string = hubVirtualNetworkConnection.outputs.hubVirtualNetworkConnectionName
output hubVirtualNetworkConnectionResourceId string = hubVirtualNetworkConnection.outputs.hubVirtualNetworkConnectionResourceId
