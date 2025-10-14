# Resources Tags Resource Group

This module deploys a Resource Tag on a Resource Group scope.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
tags           | Yes      | Optional. Tags for the resource group. If not provided, removes existing tags.
onlyUpdate     | No       | Optional. Instead of overwriting the existing tags, combine them with the new tags.
enableDefaultTelemetry | No       | Optional. Enable telemetry via a Globally Unique Identifier (GUID).

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Tags for the resource group. If not provided, removes existing tags.

### onlyUpdate

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Instead of overwriting the existing tags, combine them with the new tags.

- Default value: `False`

### enableDefaultTelemetry

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Enable telemetry via a Globally Unique Identifier (GUID).

- Default value: `True`

## Outputs

Name | Type | Description
---- | ---- | -----------
name | string | The name of the tags resource.
resourceId | string | The resource ID of the applied tags.
resourceGroupName | string | The name of the resource group the tags were applied to.
tags | object | The applied tags.

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
