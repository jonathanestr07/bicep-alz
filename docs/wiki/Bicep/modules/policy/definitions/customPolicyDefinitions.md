# ALZ Bicep Module - Custom Policy Definitions

Custom Policy Definitions for Azure Landing Zones

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
targetManagementGroupId | No       | The management group scope to which the policy definitions are to be created at.
telemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry. Default: false

### targetManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The management group scope to which the policy definitions are to be created at.

- Default value: `mg-alz`

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry. Default: false

- Default value: `False`

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
