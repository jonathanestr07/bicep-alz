# Using only defaults

This instance deploys the module with the minimum set of required parameters.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
serviceShort   | No       | Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.
enableDefaultTelemetry | No       | Optional. Enable telemetry via a Globally Unique Identifier (GUID).

### serviceShort

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.

- Default value: `rtmin`

### enableDefaultTelemetry

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Enable telemetry via a Globally Unique Identifier (GUID).

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
