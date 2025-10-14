# ALZ Bicep - Role Assignment to a Management Group Loop

Module used to assign a roles to Management Group

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
rolesManagementGroup | No       | Array of roles to assign to the management group.
roleSubscriptions | No       | Array of roles to assign to the subscription.
roleResourceGroup | No       | Array of roles to assign to the resource group.
roleResource   | No       | Array of roles to assign to the resource.
telemetryOptOut | No       | Optional. Set Parameter to true to Opt-out of deployment telemetry.

### rolesManagementGroup

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of roles to assign to the management group.

### roleSubscriptions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of roles to assign to the subscription.

### roleResourceGroup

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of roles to assign to the resource group.

### roleResource

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of roles to assign to the resource.

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Set Parameter to true to Opt-out of deployment telemetry.

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
