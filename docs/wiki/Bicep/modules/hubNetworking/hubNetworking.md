# ALZ Bicep - Hub Networking Module

Module used to set up Hub Networking.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | No       | Optional. The Azure Region to deploy the resources into.
tags           | Yes      | Optional. Tags that will be applied to all resources in this module.
addressPrefixes | No       | Required. The IP address range for all virtual networks to use.
subnetsArray   | No       | Required. The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks.
dnsServerIps   | No       | Optional. Array of DNS Server IP addresses for the Hub virtual Network.
azFirewallEnabled | No       | Optional. Switch which allows Azure Firewall deployment to be provisioned.
erGwyEnabled   | No       | Optional. Switch which allows the Azure ER gateway to be provisioned.
vpnGwyEnabled  | No       | Optional. Switch which allows the Azure VPN gateway to be provisioned.
azBastionEnabled | No       | Switch which allows Azure Bastion deployment to be provisioned.
ddosEnabled    | No       | Optional. Switch which allows Azure DDoS deployment to be provisioned.
azFirewallTier | No       | Optional. Azure Firewall Tier associated with the Firewall to deploy.
azFirewallIntelMode | No       | Optional. The Azure Firewall Threat Intelligence Mode. If not set, the default value is Alert.
azFirewallCustomPublicIps | No       | Optional. List of Custom Public IPs, which are assigned to firewalls ipConfigurations.
azBastionSku   | No       | Optional. Azure Bastion SKU or Tier to deploy.  Currently two options exist Basic and Standard.
azBastionTunneling | No       | Optional. Switch to enable/disable Bastion native client support. This is only supported when the Standard SKU is used for Bastion as documented here: <https://learn.microsoft.com/azure/bastion/native-client/>
azFirewallAvailabilityZones | No       | Optional. Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.
azErGatewayAvailabilityZones | No       | Optional. Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP
azVpnGatewayAvailabilityZones | No       | Optional. Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP
azFirewallDnsProxyEnabled | No       | Optional. Switch which enables the Azure Firewall DNS Proxy to be enabled on the Azure Firewall.
publicIpSku    | No       | Optional. Public IP Address SKU.
azBastionName  | No       | Optional. Name Associated with Bastion Service.
azFirewallName | No       | Optional. Azure Firewall Name.
azFirewallPoliciesName | No       | Optional. Azure Firewall Policies Name.
hubRouteTableName | No       | Optional. Name of Route table to create for the default route of Hub.
hubNetworkName | Yes      | Required. Prefix Used for Hub Network.
azFirewallPublicIpName | No       | Optional. Azure Firewall Public IP Name.
azFirewallMgmtPublicIpName | No       | Optional. Azure Firewall Public IP Mgmt Name.
azBastionNsgName | No       | Optional. NSG Name for Azure Bastion Subnet NSG.
azBastionPublicIpName | No       | Optional. Name of Azure Bastion Public Ip.
ddosPlanName   | No       | Optional. DDoS Plan Name.
erGatewayName  | No       | Optional. Name of ER Gateway.
erGwyPublicIpName | No       | Optional. Name of ER Gateway Public Ip.
vpnGatewayName | No       | Optional. Name of VPN Gateway.
vpnGwyPublicIpName1 | No       | Optional. Name of VPN Gateway Public Ip 1.
vpnGwyPublicIpName2 | No       | Optional. Name of VPN Gateway Public Ip 2.
privateDnsResolverName | Yes      | Optional. Name of Private DNS Resolver.
privateDnsResolverRulesetName | Yes      | Optional. Name of Private DNS Resolver Ruleset.
disableBGPRoutePropagation | No       | Optional. Switch which allows BGP Propagation to be disabled on the route tables.
gatewayRoutes  | No       | Optional. An Array of Routes to be established within the route table for Gateway Subnet.
privateDnsZonesEnabled | No       | Optional. Switch which allows Private DNS Zones to be provisioned.
privateDnsZonesResourceGroup | No       | Resource Group Name for Private DNS Zones.
privateDnsZonesArray | No       | Optional. Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones
virtualNetworkIdToLink | No       | Optional. Resource Id of VNet for Private DNS Zone VNet Links.
privateDnsZoneAutoMergeAzureBackupZone | No       | Optional. Set Parameter to false to skip the addition of a Private DNS Zone for Azure Backup.
virtualNetworkIdToLinkFailover | No       | Optional. Resource ID of Failover VNet for Private DNS Zone VNet Failover Links
privateResolverEnabled | No       | Optional. Whether to deploy the Azure DNS Private resolver or not.
forwardingRules | No       | Optional. Array of Forwarding Rules for the Private DNS Resolver.
vpnGatewayConfig | No       | Optional. Configuration for VPN virtual network gateway to be deployed. If a VPN virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e.
erGatewayConfig | No       | Optional. Configuration for ExpressRoute virtual network gateway to be deployed. If a ExpressRoute virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e.
telemetryOptOut | No       | Optional. Set Parameter to true to Opt-out of deployment telemetry. Default: false
azBastionOutboundSshRdpPorts | No       | Optional. Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### addressPrefixes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. The IP address range for all virtual networks to use.

- Default value: `10.52.0.0/16`

### subnetsArray

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. The name, IP address range, network security group, route table and delegation serviceName for each subnet in the virtual networks.

- Default value: `    `

### dnsServerIps

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Array of DNS Server IP addresses for the Hub virtual Network.

### azFirewallEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which allows Azure Firewall deployment to be provisioned.

- Default value: `True`

### erGwyEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which allows the Azure ER gateway to be provisioned.

- Default value: `True`

### vpnGwyEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which allows the Azure VPN gateway to be provisioned.

- Default value: `True`

### azBastionEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch which allows Azure Bastion deployment to be provisioned.

- Default value: `True`

### ddosEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which allows Azure DDoS deployment to be provisioned.

- Default value: `False`

### azFirewallTier

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Azure Firewall Tier associated with the Firewall to deploy.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`, `Premium`

### azFirewallIntelMode

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure Firewall Threat Intelligence Mode. If not set, the default value is Alert.

- Default value: `Alert`

- Allowed values: `Alert`, `Deny`, `Off`

### azFirewallCustomPublicIps

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. List of Custom Public IPs, which are assigned to firewalls ipConfigurations.

### azBastionSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Azure Bastion SKU or Tier to deploy.  Currently two options exist Basic and Standard.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`

### azBastionTunneling

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch to enable/disable Bastion native client support. This is only supported when the Standard SKU is used for Bastion as documented here: <https://learn.microsoft.com/azure/bastion/native-client/>

- Default value: `False`

### azFirewallAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Availability Zones to deploy the Azure Firewall across. Region must support Availability Zones to use. If it does not then leave empty.

- Allowed values: `1`, `2`, `3`

### azErGatewayAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP

- Allowed values: `1`, `2`, `3`

### azVpnGatewayAvailabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Availability Zones to deploy the VPN/ER PIP across. Region must support Availability Zones to use. If it does not then leave empty. Ensure that you select a zonal SKU for the ER/VPN Gateway if using Availability Zones for the PIP

- Allowed values: `1`, `2`, `3`

### azFirewallDnsProxyEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which enables the Azure Firewall DNS Proxy to be enabled on the Azure Firewall.

- Default value: `True`

### publicIpSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Public IP Address SKU.

- Default value: `Standard`

- Allowed values: `Basic`, `Standard`

### azBastionName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Name Associated with Bastion Service.

### azFirewallName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Azure Firewall Name.

### azFirewallPoliciesName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Azure Firewall Policies Name.

### hubRouteTableName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Name of Route table to create for the default route of Hub.

### hubNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Prefix Used for Hub Network.

### azFirewallPublicIpName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Azure Firewall Public IP Name.

### azFirewallMgmtPublicIpName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Azure Firewall Public IP Mgmt Name.

### azBastionNsgName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. NSG Name for Azure Bastion Subnet NSG.

### azBastionPublicIpName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Name of Azure Bastion Public Ip.

### ddosPlanName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. DDoS Plan Name.

### erGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Name of ER Gateway.

### erGwyPublicIpName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Name of ER Gateway Public Ip.

### vpnGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Name of VPN Gateway.

### vpnGwyPublicIpName1

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Name of VPN Gateway Public Ip 1.

### vpnGwyPublicIpName2

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Name of VPN Gateway Public Ip 2.

### privateDnsResolverName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Name of Private DNS Resolver.

### privateDnsResolverRulesetName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Name of Private DNS Resolver Ruleset.

### disableBGPRoutePropagation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which allows BGP Propagation to be disabled on the route tables.

- Default value: `False`

### gatewayRoutes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. An Array of Routes to be established within the route table for Gateway Subnet.

### privateDnsZonesEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which allows Private DNS Zones to be provisioned.

- Default value: `True`

### privateDnsZonesResourceGroup

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Group Name for Private DNS Zones.

- Default value: `[resourceGroup().name]`

### privateDnsZonesArray

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Array of DNS Zones to provision in Hub Virtual Network. Default: All known Azure Private DNS Zones

- Default value: `[format('privatelink.{0}.azmk8s.io', toLower(parameters('location')))] [format('privatelink.{0}.batch.azure.com', toLower(parameters('location')))] [format('privatelink.{0}.kusto.windows.net', toLower(parameters('location')))] privatelink.adf.azure.com privatelink.afs.azure.net privatelink.agentsvc.azure-automation.net privatelink.analysis.windows.net privatelink.api.azureml.ms privatelink.azconfig.io privatelink.azure-api.net privatelink.azure-automation.net privatelink.azurecr.io privatelink.azure-devices.net privatelink.azure-devices-provisioning.net privatelink.azuredatabricks.net privatelink.azurehdinsight.net privatelink.azurehealthcareapis.com privatelink.azurestaticapps.net privatelink.azuresynapse.net privatelink.azurewebsites.net privatelink.batch.azure.com privatelink.blob.core.windows.net privatelink.cassandra.cosmos.azure.com privatelink.cognitiveservices.azure.com privatelink.database.windows.net privatelink.datafactory.azure.net privatelink.dev.azuresynapse.net privatelink.dfs.core.windows.net privatelink.dicom.azurehealthcareapis.com privatelink.digitaltwins.azure.net privatelink.directline.botframework.com privatelink.documents.azure.com privatelink.eventgrid.azure.net privatelink.file.core.windows.net privatelink.gremlin.cosmos.azure.com privatelink.guestconfiguration.azure.com privatelink.his.arc.azure.com privatelink.kubernetesconfiguration.azure.com privatelink.managedhsm.azure.net privatelink.mariadb.database.azure.com privatelink.media.azure.net privatelink.mongo.cosmos.azure.com privatelink.monitor.azure.com privatelink.mysql.database.azure.com privatelink.notebooks.azure.net privatelink.ods.opinsights.azure.com privatelink.oms.opinsights.azure.com privatelink.pbidedicated.windows.net privatelink.postgres.database.azure.com privatelink.prod.migration.windowsazure.com privatelink.purview.azure.com privatelink.purviewstudio.azure.com privatelink.queue.core.windows.net privatelink.redis.cache.windows.net privatelink.redisenterprise.cache.azure.net privatelink.search.windows.net privatelink.service.signalr.net privatelink.servicebus.windows.net privatelink.siterecovery.windowsazure.com privatelink.sql.azuresynapse.net privatelink.table.core.windows.net privatelink.table.cosmos.azure.com privatelink.tip1.powerquery.microsoft.com privatelink.token.botframework.com privatelink.vaultcore.azure.net privatelink.web.core.windows.net privatelink.webpubsub.azure.com`

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

### privateResolverEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Whether to deploy the Azure DNS Private resolver or not.

- Default value: `False`

### forwardingRules

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Array of Forwarding Rules for the Private DNS Resolver.

### vpnGatewayConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Configuration for VPN virtual network gateway to be deployed. If a VPN virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e.

- Default value: `@{name=[parameters('vpnGatewayName')]; gatewayType=Vpn; sku=VpnGw1AZ; vpnType=RouteBased; vpnGatewayGeneration=Generation1; enableBgp=True; activeActive=True; enableBgpRouteTranslationForNat=False; enableDnsForwarding=False; bgpSettings=; vpnClientConfiguration=}`

### erGatewayConfig

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Configuration for ExpressRoute virtual network gateway to be deployed. If a ExpressRoute virtual network gateway is not desired an empty object should be used as the input parameter in the parameter file, i.e.

- Default value: `@{name=[parameters('erGatewayName')]; gatewayType=ExpressRoute; sku=ErGw1AZ; vpnType=RouteBased; vpnGatewayGeneration=None; enableBgp=True; activeActive=True; enableBgpRouteTranslationForNat=False; enableDnsForwarding=False; bgpSettings=}`

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Set Parameter to true to Opt-out of deployment telemetry. Default: false

- Default value: `True`

### azBastionOutboundSshRdpPorts

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Define outbound destination ports or ranges for SSH or RDP that you want to access from Azure Bastion.

- Default value: `22 3389`

## Outputs

Name | Type | Description
---- | ---- | -----------
azFirewallPrivateIp | string |
azFirewallName | string |
privateDnsZones | array |
privateDnsZonesNames | array |
ddosPlanResourceId | string |
hubVirtualNetworkName | string |
hubVirtualNetworkId | string |

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
