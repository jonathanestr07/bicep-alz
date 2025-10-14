# ALZ Bicep - Spoke Networking module

module used to create a spoke virtual network, including virtual network, subnets, NSGs and route tables

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | No       | Optional. Location for all resources.
tags           | Yes      | Optional. Tags of the resource.
virtualNetworkConfiguration | Yes      | Optional. Configuration for Azure Virtual Network.
nsgPrefix      | No       | Optional. Network Security Group Token.
udrPrefix      | No       | Optional. User Defined Route Token.
vntPrefix      | No       | Optional. Virtual Network Token.
telemetryOptOut | No       | Optional. Set Parameter to true to Opt-out of deployment telemetry.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Location for all resources.

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Tags of the resource.

### virtualNetworkConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Azure Virtual Network.

### nsgPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Network Security Group Token.

### udrPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. User Defined Route Token.

### vntPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Virtual Network Token.

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `True`

## Outputs

Name | Type | Description
---- | ---- | -----------
virtualNetworkName | string |
virtualNetworkId | string |
subnetsArray | array |

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
