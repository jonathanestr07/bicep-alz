# ALZ Bicep - Private DNS Zones Module

Module used to set up Private DNS Zones in accordance to Azure Landing Zones.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | No       | Optional. The Azure Region to deploy the resources into.
tags           | Yes      | Optional. Tags that will be applied to all resources in this module.
privateDnsZonesArray | No       | Optional. Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones
privateDnsZoneLinkResolutionPolicy | No       | Fallback to internet for Azure Private DNS zones. More details here https://learn.microsoft.com/en-us/azure/dns/private-dns-fallback
virtualNetworkIdToLink | No       | Optional. Resource Id of VNet for Private DNS Zone VNet Links.
privateDnsZoneAutoMergeAzureBackupZone | No       | Optional. Set Parameter to false to skip the addition of a Private DNS Zone for Azure Backup.
virtualNetworkIdToLinkFailover | No       | Optional. Resource ID of Failover VNet for Private DNS Zone VNet Failover Links
telemetryOptOut | No       | Optional. Set Parameter to true to Opt-out of deployment telemetry.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### privateDnsZonesArray

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones

- Default value: `[format('privatelink.{0}.azmk8s.io', toLower(parameters('location')))] [format('privatelink.{0}.batch.azure.com', toLower(parameters('location')))] [format('privatelink.{0}.kusto.windows.net', toLower(parameters('location')))] privatelink.adf.azure.com privatelink.afs.azure.net privatelink.agentsvc.azure-automation.net privatelink.analysis.windows.net privatelink.api.azureml.ms privatelink.azconfig.io privatelink.azure-api.net privatelink.azure-automation.net privatelink.azurecr.io privatelink.azure-devices.net privatelink.azure-devices-provisioning.net privatelink.azuredatabricks.net privatelink.azurehdinsight.net privatelink.azurehealthcareapis.com privatelink.azurestaticapps.net privatelink.azuresynapse.net privatelink.azurewebsites.net privatelink.batch.azure.com privatelink.blob.core.windows.net privatelink.cassandra.cosmos.azure.com privatelink.cognitiveservices.azure.com privatelink.database.windows.net privatelink.datafactory.azure.net privatelink.dev.azuresynapse.net privatelink.dfs.core.windows.net privatelink.dicom.azurehealthcareapis.com privatelink.digitaltwins.azure.net privatelink.directline.botframework.com privatelink.documents.azure.com privatelink.eventgrid.azure.net privatelink.file.core.windows.net privatelink.gremlin.cosmos.azure.com privatelink.guestconfiguration.azure.com privatelink.his.arc.azure.com privatelink.dp.kubernetesconfiguration.azure.com privatelink.managedhsm.azure.net privatelink.mariadb.database.azure.com privatelink.media.azure.net privatelink.mongo.cosmos.azure.com privatelink.monitor.azure.com privatelink.mysql.database.azure.com privatelink.notebooks.azure.net privatelink.ods.opinsights.azure.com privatelink.oms.opinsights.azure.com privatelink.pbidedicated.windows.net privatelink.postgres.database.azure.com privatelink.prod.migration.windowsazure.com privatelink.purview.azure.com privatelink.purviewstudio.azure.com privatelink.queue.core.windows.net privatelink.redis.cache.windows.net privatelink.redisenterprise.cache.azure.net privatelink.search.windows.net privatelink.service.signalr.net privatelink.servicebus.windows.net privatelink.siterecovery.windowsazure.com privatelink.sql.azuresynapse.net privatelink.table.core.windows.net privatelink.table.cosmos.azure.com privatelink.tip1.powerquery.microsoft.com privatelink.token.botframework.com privatelink.vaultcore.azure.net privatelink.web.core.windows.net privatelink.webpubsub.azure.com`

### privateDnsZoneLinkResolutionPolicy

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Fallback to internet for Azure Private DNS zones. More details here https://learn.microsoft.com/en-us/azure/dns/private-dns-fallback

- Default value: `Default`

- Allowed values: `Default`, `NxDomainRedirect`

### virtualNetworkIdToLink

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Resource Id of VNet for Private DNS Zone VNet Links.

### privateDnsZoneAutoMergeAzureBackupZone

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Set Parameter to false to skip the addition of a Private DNS Zone for Azure Backup.

- Default value: `True`

### virtualNetworkIdToLinkFailover

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Resource ID of Failover VNet for Private DNS Zone VNet Failover Links

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
privateDnsZones | array | Private DNS Zone Array output.
privateDnsZonesNames | array | Private DNS Zone Array Names.

## Snippets

### Command line

#### PowerShell

```powershell
New-AzResourceGroupDeployment -Name <deployment-name> -ResourceGroupName <resource-group-name> -TemplateFile <path-to-template> -TemplateParameterFile <path-to-templateparameter>
```

#### Azure CLI

```text
az group deployment create --name <deployment-name> --resource-group <resource-group-name> --template-file <path-to-template> --parameters @<path-to-templateparameterfile>
```
