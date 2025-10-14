targetScope = 'managementGroup'
@description('Test Deployment for Azure Platform Connectivity Landing Zone')
import { locPrefixes, resPrefixes, resources } from '../../../configuration/shared.conf.bicep'
module testPlatformConnLz '../platformConnectivity-hub.bicep' = {
  name: 'testPlatformConnLz'
  params: {
    lzPrefix: 'plat'
    envPrefix: 'conn'
    topLevelManagementGroupPrefix: 'mg-alz'
    subscriptionId: '5cb7efe0-67af-4723-ab35-0f2b42a85839'
    subscriptionMgPlacement: 'mg-alz-platform-connectivity'
    tags: {
      environment: 'conn'
      applicationName: 'Platform Connectivity Landing Zone'
      owner: 'Platform Team'
      criticality: 'Tier0'
      costCenter: '1234'
      contactEmail: 'test@outlook.com'
      dataClassification: 'Internal'
      iac: 'Bicep'
    }
    budgetConfiguration: {
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
    azFirewallEnabled: resources.platform.azFirewall.enabled
    erGwyEnabled: resources.platform.erGateway.enabled
    vpnGwyEnabled: resources.platform.vpnGateway.enabled
    azBastionEnabled: resources.platform.bastion.enabled
    ddosEnabled: false
    addressPrefixes: '10.52.0.0/24'
    subnetsArray: [
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
        name: 'AzureFirewallManagementSubnet'
        ipAddressRange: '10.52.0.192/26'
        networkSecurityGroupId: ''
        routeTableId: ''
      }
    ]
    azFirewallAvailabilityZones: [
      1
      2
      3
    ]
    azErGatewayAvailabilityZones: [
      1
      2
      3
    ]
    azVpnGatewayAvailabilityZones: [
      1
      2
      3
    ]
    publicIpSku: resources.platform.publicIp.sku
    azFirewallTier: resources.platform.azFirewall.tier
    disableBGPRoutePropagation: false
    privateDnsZonesEnabled: true
    privateDnsZonesArray: [
      'privatelink.australiaeast.azmk8s.io'
      'privatelink.australiaeast.batch.azure.com'
      'privatelink.australiaeast.kusto.windows.net'
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
    vpnGatewayConfig: {
      gatewayType: resources.platform.vpnGateway.type
      sku: resources.platform.vpnGateway.sku
      vpnType: 'RouteBased'
      vpnGatewayGeneration: 'Generation1'
      enableBgp: true
      activeActive: false // Change to True for Active-Active VPN Gateway
      enableBgpRouteTranslationForNat: false
      enableDnsForwarding: false
      bgpSettings: {
        asn: 65531
        bgpPeeringAddress: '1.1.1.1'
        peerWeight: 5
      }
      ipConfigurationName: 'vnetGatewayConfig'
      ipConfigurationActiveActiveName: 'vnetGatewayConfig2'
    }
  }
}
