# Resources Tags

This module deploys a Resource Tag at a Subscription or Resource Group scope.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
tags           | No       | Optional. Tags for the resource group. If not provided, removes existing tags.
onlyUpdate     | No       | Optional. Instead of overwriting the existing tags, combine them with the new tags.
resourceGroupName | No       | Optional. Name of the Resource Group to assign the tags to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription.
subscriptionId | No       | Optional. Subscription ID of the subscription to assign the tags to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription.
location       | No       | Optional. Location deployment metadata.
enableDefaultTelemetry | No       | Optional. Enable telemetry via a Globally Unique Identifier (GUID).

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags for the resource group. If not provided, removes existing tags.

### onlyUpdate

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Instead of overwriting the existing tags, combine them with the new tags.

- Default value: `False`

### resourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Name of the Resource Group to assign the tags to. If no Resource Group name is provided, and Subscription ID is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription.

### subscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Subscription ID of the subscription to assign the tags to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided tags to the subscription.

- Default value: `[subscription().id]`

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Location deployment metadata.

- Default value: `[deployment().location]`

### enableDefaultTelemetry

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Enable telemetry via a Globally Unique Identifier (GUID).

- Default value: `True`

## Outputs

Name | Type | Description
---- | ---- | -----------
name | string | The name of the tags resource.
tags | object | The applied tags.
resourceId | string | The resource ID of the applied tags.

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
