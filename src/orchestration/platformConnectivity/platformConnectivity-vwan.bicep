import * as shared from '../../configuration/shared.conf.bicep'
import * as type from '../../configuration/shared.type.bicep'

targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Azure Platform Connectivity Orchestration Module'
metadata description = 'Module used to create Azure Platform Connectivity resources.'
metadata version = '2.0.0'
metadata author = 'Insight APAC Platform Engineering'

// Subscription Module Parameters
@description('Required. Specifies the Landing Zone prefix for the deployment.')
param lzPrefix string

@description('Required. Specifies the environment prefix for the deployment.')
param envPrefix string

@description('Required. Prefix for the management group hierarchy.')
@minLength(2)
@maxLength(10)
param topLevelManagementGroupPrefix string = 'alz'

@description('Required. The Subscription Id for the deployment.')
@maxLength(36)
param subscriptionId string

@description('Optional. The Management Group Id to place the subscription in.')
param subscriptionMgPlacement string = ''

@description('Optional. The Azure Region to deploy the resources into.')
param location string = deployment().location

@description('Optional. Tags that will be applied to all resources in this module.')
param tags type.tagsType

@description('Optional. Switch which allows Virtual Hub deployment to be provisioned.')
param virtualHubEnabled bool = true

@description('Optional. Switch which allows Azure DDoS deployment to be provisioned.')
param ddosEnabled bool = false

@description('''Optional. Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.

- `vpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub.
- `expressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub.
- `azFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub.
- `virtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use.
- `hubLocation` - The Virtual WAN Hub location.
- `hubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASN`, `VpnGateway`, `ExpressRoute`.
- `virtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50.''')
param vWanHubs array = []

@description('Optional. The scale unit for this VPN Gateway.')
param vpnGatewayScaleUnit int = 1

@description('Optional. The scale unit for this ExpressRoute Gateway.')
param expressRouteGatewayScaleUnit int = 1

@description('Optional. Switch which allows Private DNS Zones to be provisioned.')
param privateDnsZonesEnabled bool = true

@description('Optional. Array of DNS Zones to provision in Hub Virtual Network.')
param privateDnsZonesArray array = [
  'privatelink.${toLower(location)}.azmk8s.io'
  'privatelink.${toLower(location)}.batch.azure.com'
  'privatelink.${toLower(location)}.kusto.windows.net'
  'privatelink.adf.azure.com'
  'privatelink.afs.azure.net'
  'privatelink.agentsvc.azure-automation.net'
  'privatelink.analysis.windows.net'
  'privatelink.api.azureml.ms'
  'privatelink.azconfig.io'
  'privatelink.azure-api.net'
  'privatelink.azure-automation.net'
  'privatelink.azurecr.io'
  'privatelink.azure-devices.net'
  'privatelink.azure-devices-provisioning.net'
  'privatelink.azuredatabricks.net'
  'privatelink.azurehdinsight.net'
  'privatelink.azurehealthcareapis.com'
  'privatelink.azurestaticapps.net'
  'privatelink.azuresynapse.net'
  'privatelink.azurewebsites.net'
  'privatelink.batch.azure.com'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.blob.core.windows.net'
  'privatelink.cassandra.cosmos.azure.com'
  'privatelink.cognitiveservices.azure.com'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.database.windows.net'
  'privatelink.datafactory.azure.net'
  'privatelink.dev.azuresynapse.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.dfs.core.windows.net'
  'privatelink.dicom.azurehealthcareapis.com'
  'privatelink.digitaltwins.azure.net'
  'privatelink.directline.botframework.com'
  'privatelink.documents.azure.com'
  'privatelink.eventgrid.azure.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.file.core.windows.net'
  'privatelink.gremlin.cosmos.azure.com'
  'privatelink.guestconfiguration.azure.com'
  'privatelink.his.arc.azure.com'
  'privatelink.dp.kubernetesconfiguration.azure.com'
  'privatelink.managedhsm.azure.net'
  'privatelink.mariadb.database.azure.com'
  'privatelink.media.azure.net'
  'privatelink.mongo.cosmos.azure.com'
  'privatelink.monitor.azure.com'
  'privatelink.mysql.database.azure.com'
  'privatelink.notebooks.azure.net'
  'privatelink.ods.opinsights.azure.com'
  'privatelink.oms.opinsights.azure.com'
  'privatelink.pbidedicated.windows.net'
  'privatelink.postgres.database.azure.com'
  'privatelink.prod.migration.windowsazure.com'
  'privatelink.purview.azure.com'
  'privatelink.purviewstudio.azure.com'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.queue.core.windows.net'
  'privatelink.redis.cache.windows.net'
  'privatelink.redisenterprise.cache.azure.net'
  'privatelink.search.windows.net'
  'privatelink.service.signalr.net'
  'privatelink.servicebus.windows.net'
  'privatelink.siterecovery.windowsazure.com'
  'privatelink.sql.azuresynapse.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.table.core.windows.net'
  'privatelink.table.cosmos.azure.com'
  'privatelink.tip1.powerquery.microsoft.com'
  'privatelink.token.botframework.com'
  'privatelink.vaultcore.azure.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.web.core.windows.net'
  'privatelink.webpubsub.azure.com'
]

@description('Optional. Resource Id of VNet for Private DNS Zone VNet Links')
param virtualNetworkIdToLink string = ''

// Subscription Budget Module Parameters
@description('Optional. Configuration for Azure Budgets.')
param budgetConfiguration type.budgetConfigurationType?

@description('Optional. Date timestamp.')
param startDate string = '${utcNow('yyyy')}-${utcNow('MM')}-01T00:00:00Z'

// Orchestration Variables
var argPrefix = toLower('${shared.resPrefixes.resourceGroup}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var vngPrefix = toLower('${shared.resPrefixes.virtualNetworkGateway}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var afwPrefix = toLower('${shared.resPrefixes.azureFirewall}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var afpPrefix = toLower('${shared.resPrefixes.azureFirewallPolicy}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var ddosPrefix = toLower('${shared.resPrefixes.azureDdos}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var vwanPrefix = toLower('${shared.resPrefixes.azureVwan}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var vhubPrefix = toLower('${shared.resPrefixes.azureVwanHub}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')

var deployBudgets = budgetConfiguration.?enabled ?? true

var resourceGroups = {
  network: '${argPrefix}-network'
  privateDns: '${argPrefix}-privatedns'
}

var resourceNames = {
  azureFirewall: '${afwPrefix}-${uniqueString(subscriptionId)}'
  azureFirewallPolicy: '${afpPrefix}-${uniqueString(subscriptionId)}'
  ddosPlan: '${ddosPrefix}-${uniqueString(subscriptionId)}'
  vWan: '${vwanPrefix}-${uniqueString(subscriptionId)}'
  vHub: '${vhubPrefix}-${uniqueString(subscriptionId)}'
  vpnGateway: '${vngPrefix}-vpnGwy'
  erGateway: '${vngPrefix}-erGwy'
}

@description('Module: Subscription Placement')
module subscriptionPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(subscriptionMgPlacement)) {
  scope: managementGroup(topLevelManagementGroupPrefix)
  name: 'subscriptionPlacement-${guid(deployment().name)}'
  params: {
    targetManagementGroupId: subscriptionMgPlacement
    subscriptionIds: [
      subscriptionId
    ]
  }
}

@description('Module: Subscription Tags')
module subscriptionTags '../../modules/CARML/resources/tags/main.bicep' = if (!empty(tags)) {
  scope: subscription(subscriptionId)
  name: 'subTags-${guid(deployment().name)}'
  params: {
    subscriptionId: subscriptionId
    location: location
    onlyUpdate: false
    tags: tags
  }
}

@description('Module: Azure Budgets - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/consumption/budget')
module budget 'br/public:avm/res/consumption/budget:0.3.8' = [
  for (bg, index) in (budgetConfiguration.?budgets ?? []): if (!empty(budgetConfiguration) && deployBudgets) {
    name: take('budget-${guid(deployment().name)}-${index}', 64)
    scope: subscription(subscriptionId)
    params: {
      // Required parameters
      amount: bg.amount
      name: bg.name
      // Non-required parameters
      contactEmails: bg.contactEmails
      location: location
      startDate: startDate
      thresholdType: bg.thresholdType
      thresholds: bg.thresholds
    }
  }
]

@description('Resource Groups (Common) - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/resources/resource-group')
module commonResourceGroups 'br/public:avm/res/resources/resource-group:0.4.1' = [
  for commonResourceGroup in shared.commonResourceGroupNames: {
    name: take('commonResourceGroups-${commonResourceGroup}', 64)
    scope: subscription(subscriptionId)
    params: {
      // Required parameters
      name: commonResourceGroup
      // Non-required parameters
      location: location
      tags: tags
    }
  }
]

@description('Module: Network Watcher - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/network-watcher')
module networkWatcher 'br/public:avm/res/network/network-watcher:0.4.1' = {
  name: take('networkWatcher-${guid(deployment().name)}', 64)
  scope: resourceGroup(subscriptionId, 'networkWatcherRG')
  dependsOn: [
    commonResourceGroups
  ]
  params: {
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: Resource Group (Network)')
module resourceGroupForNetwork 'br/public:avm/res/resources/resource-group:0.4.1' = {
  scope: subscription(subscriptionId)
  name: 'resourceGroupForNetwork-${guid(deployment().name)}'
  params: {
    // Required parameters
    name: resourceGroups.network
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: vWAN Hub Networking')
module vhubNetworking '../../modules/vwanConnectivity/vwanConnectivity.bicep' = if (virtualHubEnabled) {
  scope: resourceGroup(subscriptionId, resourceGroups.network)
  name: take('vhubNetworking-${guid(deployment().name)}', 64)
  dependsOn: [
    resourceGroupForNetwork
  ]
  params: {
    location: location
    tags: tags
    virtualHubEnabled: virtualHubEnabled
    ddosEnabled: ddosEnabled
    azFirewallName: resourceNames.azureFirewall
    azFirewallPolicyName: resourceNames.azureFirewallPolicy
    virtualWanName: resourceNames.vWan
    virtualWanHubName: resourceNames.vHub
    vWanHubs: vWanHubs
    vpnGatewayScaleUnit: vpnGatewayScaleUnit
    expressRouteGatewayScaleUnit: expressRouteGatewayScaleUnit
    ddosPlanName: resourceNames.ddosPlan
    vpnGatewayName: resourceNames.vpnGateway
    erGatewayName: resourceNames.erGateway
    privateDnsZonesEnabled: privateDnsZonesEnabled
    privateDnsZonesResourceGroup: privateDnsZonesEnabled ? resourceGroupForPrivateDns!.outputs.name : ''
    privateDnsZonesArray: privateDnsZonesArray
    virtualNetworkIdToLink: virtualNetworkIdToLink
  }
}

@description('Module: Resource Group (PrivateDNS)')
module resourceGroupForPrivateDns 'br/public:avm/res/resources/resource-group:0.4.1' = if (privateDnsZonesEnabled) {
  scope: subscription(subscriptionId)
  name: take('resourceGroupForPrivateDns-${guid(deployment().name)}', 64)
  params: {
    // Required parameters
    name: resourceGroups.privateDns
    // Non-required parameters
    location: location
    tags: tags
  }
}
