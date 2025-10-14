import * as shared from '../../configuration/shared.conf.bicep'
import * as type from '../../configuration/shared.type.bicep'

targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Azure Platform Connectivity Orchestration Module'
metadata description = 'Module used to create Azure Platform Connectivity resources.'
metadata version = '1.1.0'
metadata author = 'Insight APAC Platform Engineering'

type subnetOptionsType = ({
  @description('Name of subnet.')
  name: string
  @description('IP address range for subnet.')
  ipAddressRange: string
  @description('Resource Id of Network Security Group to associate with subnet.')
  networkSecurityGroupId: string?
  @description('Resource Id of Route Table to associate with subnet.')
  routeTableId: string?
  @description('Name of the delegation to create for the subnet.')
  delegation: string?
})[]

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

@description('Required. The IP address range for all virtual networks to use.')
param addressPrefixes string = '10.52.0.0/16'

@description('Required. The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks.')
param subnetsArray subnetOptionsType = [
  {
    name: 'AzureBastionSubnet'
    ipAddressRange: '10.52.0.0/26'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'GatewaySubnet'
    ipAddressRange: '10.52.0.64/26'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'AzureFirewallSubnet'
    ipAddressRange: '10.52.0.128/26'
    networkSecurityGroupId: ''
    routeTableId: ''
  }
  {
    name: 'inboundDNSSubnet'
    ipAddressRange: '10.52.0.192/27'
    delegation: 'Microsoft.Network/dnsResolvers'
  }
  {
    name: 'outboundDNSSubnet'
    ipAddressRange: '10.52.0.224/27'
    delegation: 'Microsoft.Network/dnsResolvers'
  }
]

@description('Optional. Array of DNS Server IP addresses for the Hub virtual Network.')
param dnsServerIps array = []

@description('Optional. Switch which allows Azure Firewall deployment to be provisioned.')
param azFirewallEnabled bool = true

@description('Optional. Switch which allows the Azure ER gateway to be provisioned.')
param erGwyEnabled bool = true

@description('Optional. Switch which allows the Azure VPN gateway to be provisioned.')
param vpnGwyEnabled bool = true

@description('Switch which allows Azure Bastion deployment to be provisioned.')
param azBastionEnabled bool = true

@description('Optional. Switch which allows Azure DDoS deployment to be provisioned.')
param ddosEnabled bool = false

@description('Optional. Azure Firewall Tier associated with the Firewall to deploy.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param azFirewallTier string = 'Standard'

@description('Optional. The Azure Firewall Threat Intelligence Mode. If not set, the default value is Alert.')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param azFirewallIntelMode string = 'Alert'

@description('Optional. List of Custom Public IPs, which are assigned to firewalls ipConfigurations.')
param azFirewallCustomPublicIps array = []

@description('Optional. Azure Bastion SKU or Tier to deploy.  Currently two options exist Basic and Standard.')
@allowed([
  'Basic'
  'Standard'
])
param azBastionSku string = 'Standard'

@description('Optional. Switch to enable/disable Bastion native client support. This is only supported when the Standard SKU is used for Bastion as documented here: <https://learn.microsoft.com/azure/bastion/native-client/>')
param azBastionTunneling bool = false

@allowed([
  1
  2
  3
])
@description('Optional. Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.')
param azFirewallAvailabilityZones int[] = []

@allowed([
  1
  2
  3
])
@description('Optional. Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP')
param azErGatewayAvailabilityZones int[] = []

@allowed([
  1
  2
  3
])
@description('Optional. Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP')
param azVpnGatewayAvailabilityZones int[] = []

@description('Optional. Switch which enables the Azure Firewall DNS Proxy to be enabled on the Azure Firewall.')
param azFirewallDnsProxyEnabled bool = true

@description('Optional. Public IP Address SKU.')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string = 'Standard'

@description('Optional. Switch which allows BGP Propagation to be disabled on the route tables.')
param disableBGPRoutePropagation bool = false

@description('Optional. An Array of Routes to be established within the route table for Gateway Subnet.')
param gatewayRoutes array = []

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

@description('Optional. Set Parameter to false to skip the addition of a Private DNS Zone for Azure Backup.')
param privateDnsZoneAutoMergeAzureBackupZone bool = true

@description('Optional. Resource ID of Failover VNet for Private DNS Zone VNet Failover Links')
param virtualNetworkIdToLinkFailover string = ''

@description('Optional.Whether to deploy the Azure DNS Private resolver or not.')
param privateResolverEnabled bool = false

@description('Optional. Array of Forwarding Rules for the Private DNS Resolver.')
param forwardingRules array = []

//ASN must be 65515 if deploying VPN & ER for co-existence to work: <https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-coexist-resource-manager#limits-and-limitations/>
@description('Configuration for VPN virtual network gateway to be deployed. If a VPN virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e.')
param vpnGatewayConfig type.virtualNetworkGatewayType = {
  gatewayType: 'Vpn'
  sku: 'VpnGw1AZ'
  vpnType: 'RouteBased'
  vpnGatewayGeneration: 'Generation1'
  enableBgp: true
  activeActive: true
  enableBgpRouteTranslationForNat: false
  enableDnsForwarding: false
  vpnClientConfiguration: {}
  bgpSettings: {}
}

var vpnGatewayName = {
  name: '${vngPrefix}-vpnGwy'
}

var vngConcatConfig = union(vpnGatewayName, vpnGatewayConfig)

@description('Optional. Configuration for ExpressRoute virtual network gateway to be deployed. If a ExpressRoute virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e.')
param erGatewayConfig type.virtualNetworkGatewayType = {
  name: ''
  gatewayType: 'ExpressRoute'
  sku: 'ErGw1AZ'
  vpnType: 'RouteBased'
  vpnGatewayGeneration: 'None'
  enableBgp: true
  activeActive: true
  enableBgpRouteTranslationForNat: false
  enableDnsForwarding: false
  bgpSettings: {}
}

var erGatewayName = {
  name: '${vngPrefix}-erGwy'
}

var erConcatConfig = union(erGatewayName, erGatewayConfig)

// Orchestration Variables
var argPrefix = toLower('${shared.resPrefixes.resourceGroup}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var vntPrefix = toLower('${shared.resPrefixes.virtualNetwork}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var vngPrefix = toLower('${shared.resPrefixes.virtualNetworkGateway}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var udrPrefix = toLower('${shared.resPrefixes.routeTable}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var basPrefix = toLower('${shared.resPrefixes.azureBastion}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var nsgPrefix = toLower('${shared.resPrefixes.networkSecurityGroup}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var afwPrefix = toLower('${shared.resPrefixes.azureFirewall}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var afpPrefix = toLower('${shared.resPrefixes.azureFirewallPolicy}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var pipPrefix = toLower('${shared.resPrefixes.publicIp}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var ddosPrefix = toLower('${shared.resPrefixes.azureDdos}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var dnsrPrefix = toLower('${shared.resPrefixes.privateDnsResolver}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')

var vnetAddressSpace = replace(addressPrefixes, '/', '_')
var deployBudgets = budgetConfiguration.?enabled ?? true

var resourceGroups = {
  network: '${argPrefix}-network'
  privateDns: '${argPrefix}-privatedns'
}

var resourceNames = {
  virtualNetwork: '${vntPrefix}-${vnetAddressSpace}'
  privateDnsResolver: '${dnsrPrefix}-privateresolver'
  privateDnsResolverRuleset: '${dnsrPrefix}-forwardingruleset'
  azureBastion: '${basPrefix}-${uniqueString(subscriptionId)}'
  azureFirewall: '${afwPrefix}-${uniqueString(subscriptionId)}'
  azureFirewallPolicy: '${afpPrefix}-${uniqueString(subscriptionId)}'
  routeTable: '${udrPrefix}-gatewaySubnet'
  ddosPlan: '${ddosPrefix}-${uniqueString(subscriptionId)}'
  bastionPublicIp: '${pipPrefix}-bastion'
  bastionNsg: '${nsgPrefix}-bastion'
  vpnGwyPublicIp1: '${pipPrefix}-vpnGwy1'
  vpnGwyPublicIp2: '${pipPrefix}-vpnGwy2'
  erGwyPublicIp: '${pipPrefix}-erGwy'
  azFwPublicIp: '${pipPrefix}-azFw'
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

@description('Module: Hub Networking')
module hubNetworking '../../modules/hubNetworking/hubNetworking.bicep' = if (virtualHubEnabled) {
  scope: resourceGroup(subscriptionId, resourceGroups.network)
  name: take('hubNetworking-${guid(deployment().name)}', 64)
  dependsOn: [
    resourceGroupForNetwork
  ]
  params: {
    location: location
    tags: tags
    erGwyEnabled: erGwyEnabled
    vpnGwyEnabled: vpnGwyEnabled
    azBastionEnabled: azBastionEnabled
    ddosEnabled: ddosEnabled
    azFirewallEnabled: azFirewallEnabled
    azFirewallDnsProxyEnabled: azFirewallDnsProxyEnabled
    disableBGPRoutePropagation: disableBGPRoutePropagation
    azFirewallTier: azFirewallTier
    azFirewallPoliciesName: resourceNames.azureFirewallPolicy
    azBastionSku: azBastionSku
    azFirewallAvailabilityZones: azFirewallAvailabilityZones
    azErGatewayAvailabilityZones: azErGatewayAvailabilityZones
    azVpnGatewayAvailabilityZones: azVpnGatewayAvailabilityZones
    publicIpSku: publicIpSku
    addressPrefixes: addressPrefixes
    subnetsArray: subnetsArray
    dnsServerIps: dnsServerIps
    erGatewayConfig: erConcatConfig
    vpnGatewayConfig: vngConcatConfig
    azFirewallName: resourceNames.azureFirewall
    azBastionName: resourceNames.azureBastion
    hubRouteTableName: resourceNames.routeTable
    hubNetworkName: resourceNames.virtualNetwork
    vpnGwyPublicIpName1: resourceNames.vpnGwyPublicIp1     
    vpnGwyPublicIpName2: resourceNames.vpnGwyPublicIp2
    erGwyPublicIpName: resourceNames.erGwyPublicIp
    azFirewallPublicIpName: resourceNames.azFwPublicIp
    azBastionPublicIpName: resourceNames.bastionPublicIp
    azBastionNsgName: resourceNames.bastionNsg
    ddosPlanName: resourceNames.ddosPlan
    vpnGatewayName: resourceNames.vpnGateway
    erGatewayName: resourceNames.erGateway
    privateDnsZonesEnabled: privateDnsZonesEnabled
    privateDnsZonesResourceGroup: privateDnsZonesEnabled ? resourceGroupForPrivateDns!.outputs.name : ''
    privateDnsZonesArray: privateDnsZonesArray
    privateResolverEnabled: privateResolverEnabled
    privateDnsResolverRulesetName: resourceNames.privateDnsResolverRuleset
    privateDnsResolverName: resourceNames.privateDnsResolver
    forwardingRules: forwardingRules
    virtualNetworkIdToLink: virtualNetworkIdToLink
    gatewayRoutes: gatewayRoutes
    azFirewallIntelMode: azFirewallIntelMode
    azFirewallCustomPublicIps: azFirewallCustomPublicIps
    azBastionTunneling: azBastionTunneling
    privateDnsZoneAutoMergeAzureBackupZone: privateDnsZoneAutoMergeAzureBackupZone
    virtualNetworkIdToLinkFailover: virtualNetworkIdToLinkFailover
  }
}

@description('Module: Resource Group (PrivateDNS)')
module resourceGroupForPrivateDns 'br/public:avm/res/resources/resource-group:0.4.1' = if (privateDnsZonesEnabled || privateResolverEnabled) {
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
