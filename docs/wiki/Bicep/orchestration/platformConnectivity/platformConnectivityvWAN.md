# ALZ Bicep - Azure Platform Connectivity Orchestration Module

Module used to create Azure Platform Connectivity resources.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
lzPrefix       | Yes      | Required. Specifies the Landing Zone prefix for the deployment.
envPrefix      | Yes      | Required. Specifies the environment prefix for the deployment.
topLevelManagementGroupPrefix | No       | Required. Prefix for the management group hierarchy.
subscriptionId | Yes      | Required. The Subscription Id for the deployment.
subscriptionMgPlacement | No       | Optional. The Management Group Id to place the subscription in.
location       | No       | Optional. The Azure Region to deploy the resources into.
tags           | Yes      | Optional. Tags that will be applied to all resources in this module.
virtualHubEnabled | No       | Optional. Switch which allows Virtual Hub deployment to be provisioned.
ddosEnabled    | No       | Optional. Switch which allows Azure DDoS deployment to be provisioned.
vWanHubs       | No       | Optional. Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.  - `vpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub. - `expressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub. - `azFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub. - `virtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use. - `hubLocation` - The Virtual WAN Hub location. - `hubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASN`, `VpnGateway`, `ExpressRoute`. - `virtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50.
vpnGatewayScaleUnit | No       | Optional. The scale unit for this VPN Gateway.
expressRouteGatewayScaleUnit | No       | Optional. The scale unit for this ExpressRoute Gateway.
privateDnsZonesEnabled | No       | Optional. Switch which allows Private DNS Zones to be provisioned.
privateDnsZonesArray | No       | Optional. Array of DNS Zones to provision in Hub Virtual Network.
virtualNetworkIdToLink | No       | Optional. Resource Id of VNet for Private DNS Zone VNet Links
budgetConfiguration | Yes      | Optional. Configuration for Azure Budgets.
startDate      | No       | Optional. Date timestamp.

### lzPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Specifies the Landing Zone prefix for the deployment.

### envPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Specifies the environment prefix for the deployment.

### topLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. Prefix for the management group hierarchy.

- Default value: `alz`

### subscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The Subscription Id for the deployment.

### subscriptionMgPlacement

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Management Group Id to place the subscription in.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure Region to deploy the resources into.

- Default value: `[deployment().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### virtualHubEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which allows Virtual Hub deployment to be provisioned.

- Default value: `True`

### ddosEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which allows Azure DDoS deployment to be provisioned.

- Default value: `False`

### vWanHubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Array Used for multiple Virtual WAN Hubs deployment. Each object in the array represents an individual Virtual WAN Hub configuration. Add/remove additional objects in the array to meet the number of Virtual WAN Hubs required.

- `vpnGatewayEnabled` - Switch to enable/disable VPN Gateway deployment on the respective Virtual WAN Hub.
- `expressRouteGatewayEnabled` - Switch to enable/disable ExpressRoute Gateway deployment on the respective Virtual WAN Hub.
- `azFirewallEnabled` - Switch to enable/disable Azure Firewall deployment on the respective Virtual WAN Hub.
- `virtualHubAddressPrefix` - The IP address range in CIDR notation for the vWAN virtual Hub to use.
- `hubLocation` - The Virtual WAN Hub location.
- `hubRoutingPreference` - The Virtual WAN Hub routing preference. The allowed values are `ASN`, `VpnGateway`, `ExpressRoute`.
- `virtualRouterAutoScaleConfiguration` - The Virtual WAN Hub capacity. The value should be between 2 to 50.

### vpnGatewayScaleUnit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The scale unit for this VPN Gateway.

- Default value: `1`

### expressRouteGatewayScaleUnit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The scale unit for this ExpressRoute Gateway.

- Default value: `1`

### privateDnsZonesEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which allows Private DNS Zones to be provisioned.

- Default value: `True`

### privateDnsZonesArray

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Array of DNS Zones to provision in Hub Virtual Network.

- Default value: `[format('privatelink.{0}.azmk8s.io', toLower(parameters('location')))] [format('privatelink.{0}.batch.azure.com', toLower(parameters('location')))] [format('privatelink.{0}.kusto.windows.net', toLower(parameters('location')))] privatelink.adf.azure.com privatelink.afs.azure.net privatelink.agentsvc.azure-automation.net privatelink.analysis.windows.net privatelink.api.azureml.ms privatelink.azconfig.io privatelink.azure-api.net privatelink.azure-automation.net privatelink.azurecr.io privatelink.azure-devices.net privatelink.azure-devices-provisioning.net privatelink.azuredatabricks.net privatelink.azurehdinsight.net privatelink.azurehealthcareapis.com privatelink.azurestaticapps.net privatelink.azuresynapse.net privatelink.azurewebsites.net privatelink.batch.azure.com privatelink.blob.core.windows.net privatelink.cassandra.cosmos.azure.com privatelink.cognitiveservices.azure.com privatelink.database.windows.net privatelink.datafactory.azure.net privatelink.dev.azuresynapse.net privatelink.dfs.core.windows.net privatelink.dicom.azurehealthcareapis.com privatelink.digitaltwins.azure.net privatelink.directline.botframework.com privatelink.documents.azure.com privatelink.eventgrid.azure.net privatelink.file.core.windows.net privatelink.gremlin.cosmos.azure.com privatelink.guestconfiguration.azure.com privatelink.his.arc.azure.com privatelink.dp.kubernetesconfiguration.azure.com privatelink.managedhsm.azure.net privatelink.mariadb.database.azure.com privatelink.media.azure.net privatelink.mongo.cosmos.azure.com privatelink.monitor.azure.com privatelink.mysql.database.azure.com privatelink.notebooks.azure.net privatelink.ods.opinsights.azure.com privatelink.oms.opinsights.azure.com privatelink.pbidedicated.windows.net privatelink.postgres.database.azure.com privatelink.prod.migration.windowsazure.com privatelink.purview.azure.com privatelink.purviewstudio.azure.com privatelink.queue.core.windows.net privatelink.redis.cache.windows.net privatelink.redisenterprise.cache.azure.net privatelink.search.windows.net privatelink.service.signalr.net privatelink.servicebus.windows.net privatelink.siterecovery.windowsazure.com privatelink.sql.azuresynapse.net privatelink.table.core.windows.net privatelink.table.cosmos.azure.com privatelink.tip1.powerquery.microsoft.com privatelink.token.botframework.com privatelink.vaultcore.azure.net privatelink.web.core.windows.net privatelink.webpubsub.azure.com`

### virtualNetworkIdToLink

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Resource Id of VNet for Private DNS Zone VNet Links

### budgetConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Azure Budgets.

### startDate

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Date timestamp.

- Default value: `[format('{0}-{1}-01T00:00:00Z', utcNow('yyyy'), utcNow('MM'))]`

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
