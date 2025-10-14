import * as shared from '../shared.conf.bicep'

using '../../orchestration/platformConnectivity/platformConnectivity-hub.bicep'

param lzPrefix = 'plat'
param envPrefix = 'conn'
param topLevelManagementGroupPrefix = 'mg-alz'
param subscriptionId = '5cb7efe0-67af-4723-ab35-0f2b42a85839'
param subscriptionMgPlacement = 'mg-alz-platform-connectivity'
param tags = {
  environment: envPrefix
  applicationName: 'Platform Connectivity Landing Zone'
  owner: 'Platform Team'
  criticality: 'Tier0'
  costCenter: '1234'
  contactEmail: 'test@outlook.com'
  dataClassification: 'Internal'
  iac: 'Bicep'
}
param budgetConfiguration = {
  enabled: true
  budgets: [
    {
      name: 'budget-forecasted'
      amount: 500
      thresholdType: 'Forecasted'
      thresholds: [
        90
        100
      ]
      contactEmails: [
        'test@outlook.com'
      ]
    }
    {
      name: 'budget-actual'
      amount: 500
      thresholdType: 'Actual'
      thresholds: [
        95
        100
      ]
      contactEmails: [
        'test@outlook.com'
      ]
    }
  ]
}
param azFirewallEnabled = shared.resources.platform.azFirewall.enabled
param erGwyEnabled = shared.resources.platform.erGateway.enabled
param vpnGwyEnabled = shared.resources.platform.vpnGateway.enabled
param azBastionEnabled = shared.resources.platform.bastion.enabled
param ddosEnabled = false
param privateResolverEnabled = false
param addressPrefixes = '10.52.0.0/24'
param subnetsArray = [
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
param forwardingRules = [
  {
    domainName: 'contoso.com.'
    forwardingRuleState: 'Enabled'
    name: 'rule01'
    targetDnsServers: [
      {
        ipAddress: '192.168.0.1'
        port: '53'
      }
    ]
  }
]
param azFirewallAvailabilityZones = [
  1
  2
  3
]
param azErGatewayAvailabilityZones = [
  1
  2
  3
]
param azVpnGatewayAvailabilityZones = [
  1
  2
  3
]
param publicIpSku = shared.resources.platform.publicIp.sku
param azFirewallTier = shared.resources.platform.azFirewall.tier
param disableBGPRoutePropagation = false
param privateDnsZonesEnabled = true
param virtualNetworkIdToLink = '' // The resource ID of the Virtual Network in the Platform Identity Subscription for Hub and Spoke and other vnet for vWAN. If provided, the Virtual Network will receive the Virtual Network Links for the platform Private DNS Zones. Otherwise leave string empty.
param privateDnsZonesArray = [
  // Azure Data Factory
  //'privatelink.adf.azure.com' - Enabling this will impact the public Azure Data Factory portal (https://adf.azure.com/en/) for public Azure Data Factory resources. More details can be found here: https://learn.microsoft.com/en-us/azure/data-factory/data-factory-private-link

  //Azure Databricks
  //'privatelink.azuredatabricks.net' - Be aware of potential impacts to the Azure Databricks portal (https://accounts.azuredatabricks.net/login) for public Azure Databrick resources. For more information, check: https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/private-link

  // Azure Synapse
  //'privatelink.azuresynapse.net' - Activating this will interfere with the Synapse Studio Portal (https://web.azuresynapse.net/en/) for Azure Synapse Workspaces that are not private endpoint enabled from the outset. Further details are available here: https://learn.microsoft.com/en-us/purview/catalog-private-link-troubleshoot#recommended-troubleshooting-steps

  // EventGrid
  //'privatelink.eventgrid.azure.net' - This setting affects Push services with private link services, but Pull services remain unaffected. More information is provided here: https://learn.microsoft.com/en-us/azure/event-grid/consume-private-endpoints

  // Power BI
  //'privatelink.analysis.windows.net' - This will affect PowerBI (https://learn.microsoft.com/en-us/power-bi/enterprise/service-security-private-links-on-premises) if it's not configured to use private endpoints from the outset. Refer to this documentation for details: https://learn.microsoft.com/en-us/fabric/security/security-private-links-overview

  // Microsoft Fabric
  //'privatelink.pbidedicated.windows.net' - This will affect Microsoft Fabric services (https://app.fabric.microsoft.com/home). More details are available in the documentation: https://learn.microsoft.com/en-us/fabric/security/security-private-links-overview
  //'privatelink.purviewstudio.azure.com' - This will affect the Purview public web portal (https://web.purview.azure.com) if it's not configured to use private endpoints from the outset. Refer to this guide for troubleshooting: https://learn.microsoft.com/en-us/purview/catalog-private-link-troubleshoot#recommended-troubleshooting-steps
  //'privatelink.tip1.powerquery.microsoft.com' - This will affect Microsoft Fabric services (https://app.fabric.microsoft.com/home) if it's not configured to use private endpoints from the outset. For more details, consult: https://learn.microsoft.com/en-us/fabric/security/security-private-links-overview

  // Enabled Private DNS Zones
  'privatelink.australiaeast.azmk8s.io'
  'privatelink.australiaeast.batch.azure.com'
  'privatelink.australiaeast.kusto.windows.net'
  'privatelink.afs.azure.net'
  'privatelink.agentsvc.azure-automation.net'
  'privatelink.api.azureml.ms'
  'privatelink.azconfig.io'
  'privatelink.azure-automation.net'
  'privatelink.azurecr.io'
  'privatelink.azure-devices.net'
  'privatelink.azure-devices-provisioning.net'
  'privatelink.azurehdinsight.net'
  'privatelink.azurehealthcareapis.com'
  'privatelink.azurestaticapps.net'
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
  'privatelink.monitor.azure.com' // Be cautious when enabling Azure Monitor on private endpoints, as some shared endpoints are not resource-specific. Learn more here: https://learn.microsoft.com/en-us/azure/azure-monitor/logs/private-link-security#azure-monitor-private-links-rely-on-your-dns
  'privatelink.mysql.database.azure.com'
  'privatelink.notebooks.azure.net'
  'privatelink.ods.opinsights.azure.com'
  'privatelink.oms.opinsights.azure.com'
  'privatelink.postgres.database.azure.com'
  'privatelink.prod.migration.windowsazure.com'
  'privatelink.purview.azure.com'
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
  'privatelink.token.botframework.com'
  'privatelink.vaultcore.azure.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.web.core.windows.net'
  'privatelink.webpubsub.azure.com'
]
param vpnGatewayConfig = {
  gatewayType: shared.resources.platform.vpnGateway.type
  sku: shared.resources.platform.vpnGateway.sku
  vpnType: 'RouteBased'
  vpnGatewayGeneration: 'Generation1'
  enableBgp: true
  activeActive: true
  enableBgpRouteTranslationForNat: false
  enableDnsForwarding: false
  vpnClientConfiguration: {}
  bgpSettings: {}
}
param gatewayRoutes = [
  {
    name: 'FROM-onPremises-TO-10.0.0.0_8'
    properties: {
      addressPrefix: '10.0.0.0/8' // Spoke
      nextHopType: 'VirtualAppliance'
      nextHopIpAddress: '10.52.2.4'
    }
  }
]
