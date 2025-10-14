# ALZ Bicep - MS Defender EASM Module

ALZ Bicep Module used to set up EASM

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | Yes      | The location of the resource group
instanceName   | Yes      | The name of the Defender EASM instance
tags           | No       | The tags to apply to the Defender EASM instance

### location

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The location of the resource group

### instanceName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the Defender EASM instance

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The tags to apply to the Defender EASM instance

## Outputs

Name | Type | Description
---- | ---- | -----------
defenderEASMName | string |

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
