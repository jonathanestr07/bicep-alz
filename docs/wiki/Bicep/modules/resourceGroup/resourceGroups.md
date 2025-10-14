# ALZ Bicep - Resource Groups module

Module used to create multiple Resource Groups for Azure Landing Zones

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
resourceGroupNames | No       | An array of Resource Group Names.
location       | Yes      | Azure Region where Resource Group will be created.
tags           | No       | Tags you would like to be applied to all resources in this module.
telemetryOptOut | No       | Optional. Set Parameter to true to Opt-out of deployment telemetry.

### resourceGroupNames

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of Resource Group Names.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Azure Region where Resource Group will be created.

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags you would like to be applied to all resources in this module.

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `True`

## Outputs

Name | Type | Description
---- | ---- | -----------
resourceGroup | array |

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
