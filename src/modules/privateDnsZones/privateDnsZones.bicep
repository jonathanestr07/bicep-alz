import * as shared from '../../configuration/shared.conf.bicep'
import * as type from '../../configuration/shared.type.bicep'

metadata name = 'ALZ Bicep - Private DNS Zones Module'
metadata description = 'Module used to set up Private DNS Zones in accordance to Azure Landing Zones.'
metadata version = '1.1.1'
metadata author = 'Insight APAC Platform Engineering'

@description('Optional. The Azure Region to deploy the resources into.')
param location string = resourceGroup().location

@description('Optional. Tags that will be applied to all resources in this module.')
param tags type.tagsType

@description('Optional. Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones')
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

@description('Fallback to internet for Azure Private DNS zones. More details here https://learn.microsoft.com/en-us/azure/dns/private-dns-fallback')
@allowed([
  'Default'
  'NxDomainRedirect'
])
param privateDnsZoneLinkResolutionPolicy string = 'Default'

@description('Optional. Resource Id of VNet for Private DNS Zone VNet Links.')
param virtualNetworkIdToLink string = ''

@description('Optional. Set Parameter to false to skip the addition of a Private DNS Zone for Azure Backup.')
param privateDnsZoneAutoMergeAzureBackupZone bool = true

@description('Optional. Resource ID of Failover VNet for Private DNS Zone VNet Failover Links')
param virtualNetworkIdToLinkFailover string = ''

@description('Optional. Set Parameter to true to Opt-out of deployment telemetry.')
param telemetryOptOut bool = false

var azBackupGeoCodes = {
  australiacentral: 'acl'
  australiacentral2: 'acl2'
  australiaeast: 'ae'
  australiasoutheast: 'ase'
  brazilsouth: 'brs'
  brazilsoutheast: 'bse'
  centraluseuap: 'ccy'
  canadacentral: 'cnc'
  canadaeast: 'cne'
  centralus: 'cus'
  eastasia: 'ea'
  eastus2euap: 'ecy'
  eastus: 'eus'
  eastus2: 'eus2'
  francecentral: 'frc'
  francesouth: 'frs'
  germanynorth: 'gn'
  germanywestcentral: 'gwc'
  centralindia: 'inc'
  southindia: 'ins'
  westindia: 'inw'
  japaneast: 'jpe'
  japanwest: 'jpw'
  jioindiacentral: 'jic'
  jioindiawest: 'jiw'
  koreacentral: 'krc'
  koreasouth: 'krs'
  northcentralus: 'ncus'
  northeurope: 'ne'
  norwayeast: 'nwe'
  norwaywest: 'nww'
  qatarcentral: 'qac'
  southafricanorth: 'san'
  southafricawest: 'saw'
  southcentralus: 'scus'
  swedencentral: 'sdc'
  swedensouth: 'sds'
  southeastasia: 'sea'
  switzerlandnorth: 'szn'
  switzerlandwest: 'szw'
  uaecentral: 'uac'
  uaenorth: 'uan'
  uksouth: 'uks'
  ukwest: 'ukw'
  westcentralus: 'wcus'
  westeurope: 'we'
  westus: 'wus'
  westus2: 'wus2'
  westus3: 'wus3'
  usdodcentral: 'udc'
  usdodeast: 'ude'
  usgovarizona: 'uga'
  usgoviowa: 'ugi'
  usgovtexas: 'ugt'
  usgovvirginia: 'ugv'
  usnateast: 'exe'
  usnatwest: 'exw'
  usseceast: 'rxe'
  ussecwest: 'rxw'
  chinanorth: 'bjb'
  chinanorth2: 'bjb2'
  chinanorth3: 'bjb3'
  chinaeast: 'sha'
  chinaeast2: 'sha2'
  chinaeast3: 'sha3'
  germanycentral: 'gec'
  germanynortheast: 'gne'
}

// If region entered in Location and matches a lookup to AzBackupGeoCodes then insert Azure Backup Private DNS Zone with appropriate geo code inserted alongside zones in PrivateDnsZones. If not just return PrivateDnsZones
var privateDnsZonesMerge = privateDnsZoneAutoMergeAzureBackupZone && contains(azBackupGeoCodes, location)
  ? union(privateDnsZonesArray, ['privatelink.${azBackupGeoCodes[toLower(location)]}.backup.windowsazure.com'])
  : privateDnsZonesArray

// Customer Usage Attribution Id
var cuaid = '981733dd-3195-4fda-a4ee-605ab959edb6'

// Resource: Azure Private DNS Zones
resource privateDnsZones 'Microsoft.Network/privateDnsZones@2024-06-01' = [
  for privateDnsZone in privateDnsZonesMerge: {
    name: privateDnsZone
    location: 'global'
    tags: tags
  }
]

// Resource: Virtual Network Links
resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = [
  for privateDnsZoneName in privateDnsZonesMerge: if (!empty(virtualNetworkIdToLink)) {
    name: '${privateDnsZoneName}/${take('link-${uniqueString(virtualNetworkIdToLink)}', 80)}'
    location: 'global'
    properties: {
      registrationEnabled: false
      resolutionPolicy: privateDnsZoneLinkResolutionPolicy
      virtualNetwork: {
        id: virtualNetworkIdToLink
      }
    }
    dependsOn: [
      privateDnsZones
    ]
  }
]

// Resource: Virtual Network Link Failover
resource virtualNetworkLinkFailover 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = [
  for privateDnsZoneName in privateDnsZonesMerge: if (!empty(virtualNetworkIdToLinkFailover)) {
    name: '${privateDnsZoneName}/${take('fallbacklink-${uniqueString(virtualNetworkIdToLinkFailover)}', 80)}'
    location: 'global'
    properties: {
      registrationEnabled: false
      resolutionPolicy: privateDnsZoneLinkResolutionPolicy
      virtualNetwork: {
        id: virtualNetworkIdToLinkFailover
      }
    }
    dependsOn: privateDnsZones
  }
]

// Module: Customer Usage Attribution
module customerUsageAttribution '../CARML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${cuaid}-${uniqueString(resourceGroup().location)}'
  params: {}
}

// Outputs
@description('Private DNS Zone Array output.')
output privateDnsZones array = [
  for i in range(0, length(privateDnsZonesMerge)): {
    name: privateDnsZones[i].name
    id: privateDnsZones[i].id
  }
]

@description('Private DNS Zone Array Names.')
output privateDnsZonesNames array = [for i in range(0, length(privateDnsZonesMerge)): privateDnsZones[i].name]
