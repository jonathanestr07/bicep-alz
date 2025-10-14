import * as shared from '../../configuration/shared.conf.bicep'
import * as type from '../../configuration/shared.type.bicep'

metadata name = 'ALZ Bicep - Spoke Networking module'
metadata description = 'module used to create a spoke virtual network, including virtual network, subnets, NSGs and route tables'
metadata version = '2.1.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags type.tagsType

@description('Optional. Configuration for Azure Virtual Network.')
param virtualNetworkConfiguration type.virtualNetworkType?

@description('Optional. Network Security Group Token.')
param nsgPrefix string = ''

@description('Optional. User Defined Route Token.')
param udrPrefix string = ''

@description('Optional. Virtual Network Token.')
param vntPrefix string = ''

@description('Optional. Set Parameter to true to Opt-out of deployment telemetry.')
param telemetryOptOut bool = true

// Customer Usage Attribution Id
var cuaid = '0c428583-f2a1-4448-975c-2d6262fd193a'

var addressPrefix = virtualNetworkConfiguration.?addressPrefix ?? ''
var vNetAddressSpace = replace(addressPrefix, '/', '_')

@description('Module: Virtual Network - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/virtual-network')
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.7.0' = {
  name: take('virtualNetwork-${guid(deployment().name)}', 64)
  dependsOn: [
    networkSecurityGroup
    routeTable
  ]
  params: {
    // Required parameters
    addressPrefixes: [
      virtualNetworkConfiguration.?addressPrefix
    ]
    name: '${vntPrefix}${vNetAddressSpace}'
    // Non-required parameters
    ddosProtectionPlanResourceId: virtualNetworkConfiguration.?ddosProtectionPlanId ?? null
    dnsServers: virtualNetworkConfiguration.?dnsServerIps ?? []
    location: location
    subnets: [
      for (subnet, index) in (virtualNetworkConfiguration.?subnets ?? []): {
        name: subnet.name
        addressPrefix: subnet.addressPrefix
        addressPrefixes: subnet.?addressPrefixes
        delegation: subnet.?delegation
        networkSecurityGroupResourceId: resourceId(
          'Microsoft.Network/networkSecurityGroups',
          '${nsgPrefix}${subnet.name}'
        )
        privateEndpointNetworkPolicies: subnet.?privateEndpointNetworkPolicies
        privateLinkServiceNetworkPolicies: subnet.?privateLinkServiceNetworkPolicies
        routeTableResourceId: (!empty(virtualNetworkConfiguration.?nextHopIpAddress))
          ? resourceId('Microsoft.Network/routeTables', '${udrPrefix}${subnet.name}')
          : null
        serviceEndpointPolicies: subnet.?serviceEndpointPolicies
        serviceEndpoints: subnet.?serviceEndpointPolicies
      }
    ]
    tags: tags
  }
}

@description('Module: Route Table - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/route-table')
module routeTable 'br/public:avm/res/network/route-table:0.5.0' = [
  for (subnet, i) in (virtualNetworkConfiguration.?subnets ?? []): if (!empty(virtualNetworkConfiguration.?nextHopIpAddress)) {
    name: 'routeTable-${i}'
    params: {
      name: '${udrPrefix}${subnet.name}'
      location: location
      tags: tags
      routes: concat(shared.routes, subnet.routes)
      disableBgpRoutePropagation: virtualNetworkConfiguration.?disableBgpRoutePropagation ?? true
    }
  }
]

@description('Module: Network Security Group -https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/network-security-group')
module networkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.1' = [
  for (subnet, i) in (virtualNetworkConfiguration.?subnets ?? []): {
    name: 'networkSecurityGroup-${i}'
    params: {
      name: '${nsgPrefix}${subnet.name}'
      location: location
      tags: tags
      securityRules: concat(shared.sharedNSGrulesInbound, shared.sharedNSGrulesOutbound, subnet.securityRules)
    }
  }
]

// Module: Customer Usage Attribution
module customerUsageAttribution '../CARML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${cuaid}-${uniqueString(resourceGroup().location)}'
  params: {}
}

// Outputs
output virtualNetworkName string = virtualNetwork.outputs.name
output virtualNetworkId string = virtualNetwork.outputs.resourceId
output subnetsArray array = virtualNetwork.outputs.subnetNames

