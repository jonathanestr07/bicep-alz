# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
resourceGroupName | No       | Optional. The name of the resource group to deploy for testing purposes.
location       | No       | Optional. The location to deploy resources to.
serviceShort   | No       | Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.
enableDefaultTelemetry | No       | Optional. Enable telemetry via a Globally Unique Identifier (GUID).
namePrefix     | No       | Optional. A token to inject into the name of each resource.

### resourceGroupName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The name of the resource group to deploy for testing purposes.

- Default value: `[format('dep-{0}-resources.tags-{1}-rg', parameters('namePrefix'), parameters('serviceShort'))]`

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The location to deploy resources to.

- Default value: `[deployment().location]`

### serviceShort

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.

- Default value: `rtrg`

### enableDefaultTelemetry

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Enable telemetry via a Globally Unique Identifier (GUID).

- Default value: `True`

### namePrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. A token to inject into the name of each resource.

- Default value: `[[[namePrefix]]`

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
