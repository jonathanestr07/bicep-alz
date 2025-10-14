import * as shared from '../../configuration/shared.conf.bicep'
import * as type from '../../configuration/shared.type.bicep'

metadata name = 'ALZ Bicep - Virtual Network Peering module for vWAN'
metadata description = 'Module used to set up Virtual Network Peering for vWAN'
metadata version = '1.1.1'
metadata author = 'Insight APAC Platform Engineering'

type azFirewallIntelModeType = 'Alert' | 'Deny' | 'Off'

type azFirewallTierType = 'Basic' | 'Standard' | 'Premium'

type azFirewallAvailabilityZonesType = ('1' | '2' | '3')[]

type virtualWanOptionsType = ({
  @description('Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub.')
  vpnGatewayEnabled: bool

  @description('Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub.')
  expressRouteGatewayEnabled: bool

  @description('Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub.')
  azFirewallEnabled: bool

  @description('The IP address range in CIDR notation for the vWAN virtual Hub to use.')
  virtualHubAddressPrefix: string

  @description('The Virtual WAN Hub location.')
  hubLocation: string

  @description('The Virtual WAN Hub routing preference. The allowed values are `ASPath`, `VpnGateway`, `ExpressRoute`.')
  hubRoutingPreference: ('ExpressRoute' | 'VpnGateway' | 'ASPath')

  @description('The Virtual WAN Hub capacity. The value should be between 2 to 50.')
  @minValue(2)
  @maxValue(50)
  virtualRouterAutoScaleConfiguration: int

  @description('The Virtual WAN Hub routing intent destinations, leave empty if not wanting to enable routing intent. The allowed values are `Internet`, `PrivateTraffic`.')
  virtualHubRoutingIntentDestinations: ('Internet' | 'PrivateTraffic')[]

  @description('This parameter is used to specify a custom name for the VPN Gateway.')
  vpnGatewayCustomName: string?

  @description('This parameter is used to specify a custom name for the ExpressRoute Gateway.')
  expressRouteGatewayCustomName: string?

  @description('This parameter is used to specify a custom name for the Azure Firewall.')
  azFirewallCustomName: string?

  @description('This parameter is used to specify a custom name for the Virtual WAN Hub.')
  virtualWanHubCustomName: string?

  @description('Array of custom DNS servers used by Azure Firewall.')
  azFirewallDnsServers: array?

  @description('The Azure Firewall Threat Intelligence Mode.')
  azFirewallIntelMode: azFirewallIntelModeType?

  @description('Switch to enable/disable Azure Firewall DNS Proxy.')
  azFirewallDnsProxyEnabled: bool?

  @description('Azure Firewall Tier associated with the Firewall to deploy.')
  azFirewallTier: azFirewallTierType?

  @description('Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.')
  azFirewallAvailabilityZones: azFirewallAvailabilityZonesType?
})[]

@description('Optional. The Azure Region to deploy the resources into.')
param location string = resourceGroup().location

@description('Optional. Tags that will be applied to all resources in this module.')
param tags type.tagsType

@description('Optional. Switch which allows Virtual Hub deployment to be provisioned.')
param virtualHubEnabled bool = true

@description('Optional. Switch which allows Azure DDoS deployment to be provisioned.')
param ddosEnabled bool = false

@description('Azure Firewall Name.')
param azFirewallName string = 'afw-aue-platform-conn-01'

@description('Name of Azure Firewall Policy.')
param azFirewallPolicyName string = 'afp-aue-platform-conn-01'

@description('Optional. Prefix Used for Virtual WAN.')
param virtualWanName string = ''

@description('Optional. Prefix Used for Virtual Hub.')
param virtualWanHubName string = ''

@sys.description('Optional. The name of the route table that manages routing between the Virtual WAN Hub and the Azure Firewall.')
param virtualWanHubDefaultRouteName string = ''

@description('Optional. DDOS Plan Name.')
param ddosPlanName string = ''

@description('''Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.
- `vpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub.
- `expressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub.
- `azFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub.
- `virtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use.
- `hubLocation` - The Virtual WAN Hub location.
- `hubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASPath`, `VpnGateway`, `ExpressRoute`.
- `virtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50.
- `virtualHubRoutingIntentDestinations` - The Virtual WAN Hub routing intent destinations, leave empty if not wanting to enable routing intent. The allowed values are `Internet`, `PrivateTraffic`.''')
param vWanHubs virtualWanOptionsType = [
  {
    vpnGatewayEnabled: true
    expressRouteGatewayEnabled: true
    azFirewallEnabled: true
    virtualHubAddressPrefix: '10.100.0.0/23'
    hubLocation: location
    hubRoutingPreference: 'ExpressRoute'
    virtualRouterAutoScaleConfiguration: 2
    virtualHubRoutingIntentDestinations: []
    azFirewallDnsProxyEnabled: true
    azFirewallDnsServers: []
    azFirewallIntelMode: 'Alert'
    azFirewallTier: 'Standard'
    azFirewallAvailabilityZones: []
  }
]

@description('Optional. The scale unit for this VPN Gateway.')
param vpnGatewayScaleUnit int = 1

@description('Optional. The scale unit for this ExpressRoute Gateway.')
param expressRouteGatewayScaleUnit int = 1

@description('Optional. Name of VPN Gateway.')
param vpnGatewayName string = ''

@description('Optional. Name of ER Gateway.')
param erGatewayName string = ''

@description('Optional. Switch which allows Private DNS Zones to be provisioned.')
param privateDnsZonesEnabled bool = true

@description('Optional. Resource Group Name for Private DNS Zones.')
param privateDnsZonesResourceGroup string = resourceGroup().name

@description('Optional. Array of DNS Zones to provision in Hub Virtual Network.')
param privateDnsZonesArray array = [
  #disable-next-line line_length
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

@description('Optional. Set Parameter to false to skip the addition of a Private DNS Zone for Azure Backup.')
param privateDnsZoneAutoMergeAzureBackupZone bool = true

@description('Optional. Resource Id of VNet for Private DNS Zone VNet Links')
param virtualNetworkIdToLink string = ''

@description('Optional. Resource ID of Failover VNet for Private DNS Zone VNet Failover Links')
param virtualNetworkIdToLinkFailover string = ''

@description('Optional. Set Parameter to true to Opt-out of deployment telemetry.')
param telemetryOptOut bool = false

// Customer Usage Attribution Id
var cuaid = '7f94f23b-7a59-4a5c-9a8d-2a253a566f61'

@description('Module: Virtual WAN - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/virtual-wan')
module virtualWan 'br/public:avm/res/network/virtual-wan:0.3.1' = {
  name: 'virtualWan-${guid(deployment().name)}'
  params: {
    // Required parameters
    name: virtualWanName
    // Non-required parameters
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
    disableVpnEncryption: false
    tags: tags
    type: 'Standard'
  }
}

@description('Resource: Azure vHub')
resource vHub 'Microsoft.Network/virtualHubs@2024-05-01' = [
  for hub in vWanHubs: if (virtualHubEnabled && !empty(hub.virtualHubAddressPrefix)) {
    name: hub.?virtualWanHubCustomName ?? '${virtualWanHubName}-${hub.hubLocation}'
    location: hub.hubLocation
    tags: tags
    properties: {
      addressPrefix: hub.virtualHubAddressPrefix
      sku: 'Standard'
      virtualWan: {
        id: virtualWan.outputs.resourceId
      }
      virtualRouterAutoScaleConfiguration: {
        minCapacity: hub.virtualRouterAutoScaleConfiguration
      }
      hubRoutingPreference: hub.hubRoutingPreference
    }
  }
]


@description('Resource: Azure vHub Route Table')
resource vHubRouteTable 'Microsoft.Network/virtualHubs/hubRouteTables@2024-05-01' = [
  for (hub, i) in vWanHubs: if (virtualHubEnabled && hub.azFirewallEnabled && empty(hub.virtualHubRoutingIntentDestinations)) {
    parent: vHub[i]
    name: 'defaultRouteTable'
    properties: {
      labels: [
        'default'
      ]
      routes: [
        {
          name: virtualWanHubDefaultRouteName
          destinations: [
            '0.0.0.0/0'
          ]
          destinationType: 'CIDR'
          nextHop: (virtualHubEnabled && hub.azFirewallEnabled) ? azFirewall[i].id : ''
          nextHopType: 'ResourceID'
        }
      ]
    }
  }
]

@description('Resource: Azure vHub Routing Intent')
resource resVhubRoutingIntent 'Microsoft.Network/virtualHubs/routingIntent@2024-05-01' = [
  for (hub, i) in vWanHubs: if (virtualHubEnabled && hub.azFirewallEnabled && !empty(hub.virtualHubRoutingIntentDestinations)) {
    parent: vHub[i]
    name: !empty(hub.?virtualWanHubCustomName)
      ? '${hub.?virtualWanHubCustomName}-Routing-Intent'
      : '${virtualWanHubName}-${hub.hubLocation}-Routing-Intent'
    properties: {
      routingPolicies: [
        for destination in hub.virtualHubRoutingIntentDestinations: {
          name: destination == 'Internet' ? 'PublicTraffic' : destination == 'PrivateTraffic' ? 'PrivateTraffic' : 'N/A'
          destinations: [
            destination
          ]
          nextHop: azFirewall[i].id
        }
      ]
    }
  }
]

@description('Resource: VPN Gateway')
resource vpnGateway 'Microsoft.Network/vpnGateways@2024-05-01' = [
  for (hub, i) in vWanHubs: if ((virtualHubEnabled) && (hub.vpnGatewayEnabled)) {
    dependsOn: vHub
    name: '${vpnGatewayName}-${hub.hubLocation}'
    location: hub.hubLocation
    tags: tags
    properties: {
      bgpSettings: {
        asn: 65515
        bgpPeeringAddress: ''
        peerWeight: 5
      }
      virtualHub: {
        id: vHub[i].id
      }
      vpnGatewayScaleUnit: vpnGatewayScaleUnit
    }
  }
]

@description('Resource: ER Gateway')
resource erGateway 'Microsoft.Network/expressRouteGateways@2024-05-01' = [
  for (hub, i) in vWanHubs: if ((virtualHubEnabled) && (hub.expressRouteGatewayEnabled)) {
    dependsOn: vHub
    name: '${erGatewayName}-${hub.hubLocation}'
    location: hub.hubLocation
    tags: tags
    properties: {
      virtualHub: {
        id: vHub[i].id
      }
      autoScaleConfiguration: {
        bounds: {
          min: expressRouteGatewayScaleUnit
        }
      }
    }
  }
]

@description('Module: Azure Firewall Policy - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/firewall-policy')
module firewallPolicy 'br/public:avm/res/network/firewall-policy:0.3.1' = [
  for (hub, i) in vWanHubs: if (virtualHubEnabled && vWanHubs[0].azFirewallEnabled) {
    name: take('firewallPolicy-${guid(deployment().name)}-${hub.hubLocation}', 64)
    params: {
      // Required parameters
      name: '${azFirewallPolicyName}-${hub.hubLocation}'
      // Non-required parameters
      enableProxy: hub.?azFirewallTier == 'Basic' ? null : hub.?azFirewallDnsProxyEnabled
      servers: hub.?azFirewallTier == 'Basic' ? null : hub.?azFirewallDnsServers
      location: location
      tags: tags
      tier: hub.?azFirewallTier
      threatIntelMode: hub.?azFirewallTier == 'Basic' ? 'Alert' : hub.?azFirewallIntelMode
    }
  }
]

@description('Resource: Azure Firewall')
resource azFirewall 'Microsoft.Network/azureFirewalls@2024-05-01' = [
  for (hub, i) in vWanHubs: if ((virtualHubEnabled) && (hub.azFirewallEnabled)) {
    name: hub.?azFirewallCustomName ?? '${azFirewallName}-${hub.hubLocation}'
    location: hub.hubLocation
    tags: tags
    zones: hub.?azFirewallAvailabilityZones
    properties: {
      hubIPAddresses: {
        publicIPs: {
          count: 1
        }
      }
      sku: {
        name: 'AZFW_Hub'
        tier: hub.?azFirewallTier
      }
      virtualHub: {
        id: virtualHubEnabled ? vHub[i].id : ''
      }
      firewallPolicy: {
        id: (virtualHubEnabled && hub.azFirewallEnabled) ? firewallPolicy[i]!.outputs.resourceId : ''
      }
    }
  }
]

// DDoS plan is deployed even though not supported to attach to Virtual WAN today as per https://docs.microsoft.com/azure/firewall-manager/overview#known-issues - However, it can still be linked via policy to spoke VNets etc.
@description('Module: Azure DDoS Protection - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/ddos-protection-plan')
module ddosProtectionPlan 'br/public:avm/res/network/ddos-protection-plan:0.3.1' = if (ddosEnabled) {
  name: take('ddosProtectionPlan-${guid(deployment().name)}', 64)
  params: {
    // Required parameters
    name: ddosPlanName
    // Non-required parameters
    location: location
    tags: tags
  }
}

// Private DNS Zones cannot be linked to the Virtual WAN Hub today however, they can be linked to spokes as they are normal VNets as per https://docs.microsoft.com/azure/virtual-wan/howto-private-link
@description('Module: Private DNS Zones')
module privateDnsZones '../privateDnsZones/privateDnsZones.bicep' = if (privateDnsZonesEnabled) {
  name: 'privateDnsZones-${guid(deployment().name)}'
  scope: resourceGroup(privateDnsZonesResourceGroup)
  params: {
    location: location
    tags: tags
    privateDnsZoneAutoMergeAzureBackupZone: privateDnsZoneAutoMergeAzureBackupZone
    virtualNetworkIdToLink: virtualNetworkIdToLink
    privateDnsZonesArray: privateDnsZonesArray
    virtualNetworkIdToLinkFailover: virtualNetworkIdToLinkFailover
  }
}

@description('Module: Customer Usage Attribution')
module customerUsageAttribution '../CARML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params
  name: 'pid-${cuaid}-${uniqueString(resourceGroup().location)}'
  params: {}
}

output virtualWanName string = virtualWan.outputs.name
output virtualWanId string = virtualWan.outputs.resourceId
output virtualHubName array = [
  for (hub, i) in vWanHubs: {
    virtualhubname: vHub[i].name
  }
]
output virtualHubId array = [
  for (hub, i) in vWanHubs: {
    virtualhubid: vHub[i].id
  }
]
output ddosProtectionPlanId string = ddosProtectionPlan!.outputs.resourceId
output privateDnsZones array = (privateDnsZonesEnabled ? privateDnsZones!.outputs.privateDnsZones : [])
