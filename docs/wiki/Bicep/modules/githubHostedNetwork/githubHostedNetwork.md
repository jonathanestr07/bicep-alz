# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
networkSettingsName | Yes      | Module to create a network settings resource for a GitHub Action Hosted vNet integrated runners.
databaseId     | Yes      | The database ID of the GitHub database related to the organisation or enterprise
subnetResourceId | Yes      | The subnet resource ID to associate with the network settings
location       | Yes      | The location of the network settings resource
tags           | Yes      | The tags of the network settings resource

### networkSettingsName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Module to create a network settings resource for a GitHub Action Hosted vNet integrated runners.

### databaseId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The database ID of the GitHub database related to the organisation or enterprise

### subnetResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The subnet resource ID to associate with the network settings

### location

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The location of the network settings resource

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The tags of the network settings resource

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
