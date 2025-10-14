# ALZ Bicep - Public IP module

Module used to set up Public IP for Azure Landing Zones

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | No       | Azure Region to deploy Public IP Address to.
publicIpName   | No       | Name of Public IP to create in Azure.
publicIpSku    | No       | Public IP Address SKU.
publicIpProperties | No       | Properties of Public IP to be deployed.
availabilityZones | No       | Availability Zones to deploy the Public IP across. Region must support Availability Zones to use. If it does not then leave empty.
tags           | No       | Tags to be applied to resource when deployed.
telemetryOptOut | No       | Optional. Set Parameter to true to Opt-out of deployment telemetry.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Azure Region to deploy Public IP Address to.

- Default value: `[resourceGroup().location]`

### publicIpName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of Public IP to create in Azure.

- Default value: `pip-ae-plat-conn-01`

### publicIpSku

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Public IP Address SKU.

- Default value: `@{name=Standard; tier=Regional}`

### publicIpProperties

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Properties of Public IP to be deployed.

### availabilityZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Availability Zones to deploy the Public IP across. Region must support Availability Zones to use. If it does not then leave empty.

- Allowed values: `1`, `2`, `3`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags to be applied to resource when deployed.

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
publicIpId | string |

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
