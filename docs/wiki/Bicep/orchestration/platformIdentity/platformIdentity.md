# ALZ Bicep - Azure Platform Identity Orchestration Module

Module used to create Azure Platform Identity resources.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
lzPrefix       | Yes      | Required. Specifies the Landing Zone prefix for the deployment.
envPrefix      | Yes      | Required. Specifies the environment prefix for the deployment.
location       | No       | Optional. The Azure Region to deploy the resources into.
topLevelManagementGroupPrefix | No       | Required. Prefix for the management group hierarchy.
subscriptionId | Yes      | Required. The Subscription Id for the deployment.
tags           | Yes      | Optional. Tags that will be applied to all resources in this module.
subscriptionMgPlacement | No       | Optional. The Management Group Id to place the subscription in.
virtualNetworkConfiguration | Yes      | Optional. Configuration for Azure Virtual Network.
virtualNetworkPeeringEnabled | No       | Optional. Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.
hubVirtualNetworkId | No       | Optional. Specifies the resource Id of the Hub Virtual Network, or Azure Virtual WAN hub Id.
allowSpokeForwardedTraffic | No       | Optional. Switch to enable/disable forwarded Traffic from outside spoke network.
allowHubVpnGatewayTransit | No       | Optional. Switch to enable/disable VPN Gateway for the hub network peering.
roleAssignments | No       | Optional Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
networkAcls    | No       | Optional. Service endpoint object information of Azure Key Vault. For security reasons, it is recommended to set the DefaultAction Deny.
publicNetworkAccess | No       | Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.
budgetConfiguration | Yes      | Optional. Configuration for Azure Budgets.
startDate      | No       | Optional. Date timestamp.
addsVmPrefix   | No       | Optional. Prefix of the ADDS VMs.
deployAdds     | No       | Optional. Whether to enable deployment of ADDS Virtual Machines.
addsPassword   | No       | Optional. Password for the Adds virtual machine(s).
virtualMachines_Adds | No       | Optional. Virtual Machine ADDS to create.
enableAddsAutomaticUpdates | No       | Whether to enable automatic updates on the virtual machines.

### lzPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Specifies the Landing Zone prefix for the deployment.

### envPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Specifies the environment prefix for the deployment.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure Region to deploy the resources into.

- Default value: `[deployment().location]`

### topLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. Prefix for the management group hierarchy.

- Default value: `alz`

### subscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The Subscription Id for the deployment.

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### subscriptionMgPlacement

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Management Group Id to place the subscription in.

### virtualNetworkConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Azure Virtual Network.

### virtualNetworkPeeringEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.

- Default value: `True`

### hubVirtualNetworkId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Specifies the resource Id of the Hub Virtual Network, or Azure Virtual WAN hub Id.

### allowSpokeForwardedTraffic

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch to enable/disable forwarded Traffic from outside spoke network.

- Default value: `True`

### allowHubVpnGatewayTransit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch to enable/disable VPN Gateway for the hub network peering.

- Default value: `True`

### roleAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

### networkAcls

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Service endpoint object information of Azure Key Vault. For security reasons, it is recommended to set the DefaultAction Deny.

- Default value: `@{bypass=AzureServices; defaultAction=Deny; virtualNetworkRules=System.Object[]; ipRules=System.Object[]}`

### publicNetworkAccess

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.

- Default value: `Disabled`

- Allowed values: `Enabled`, `Disabled`

### budgetConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Azure Budgets.

### startDate

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Date timestamp.

- Default value: `[format('{0}-{1}-01T00:00:00Z', utcNow('yyyy'), utcNow('MM'))]`

### addsVmPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Prefix of the ADDS VMs.

- Default value: `azaue`

### deployAdds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Whether to enable deployment of ADDS Virtual Machines.

- Default value: `False`

### addsPassword

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Password for the Adds virtual machine(s).

- Default value: `[newGuid()]`

### virtualMachines_Adds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Virtual Machine ADDS to create.

- Default value: ` `

### enableAddsAutomaticUpdates

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable automatic updates on the virtual machines.

- Default value: `True`

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
