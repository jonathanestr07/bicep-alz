# ALZ Bicep - Custom Role Definitions

Custom Role Definitions for Azure Landing Zones

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
assignableScopeManagementGroupId | No       | Required. The management group scope to which the role can be assigned. This management group ID will be used for the assignableScopes property in the role definition.
telemetryOptOut | No       | Optional. Set Parameter to true to Opt-out of deployment telemetry. Default: false

### assignableScopeManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. The management group scope to which the role can be assigned. This management group ID will be used for the assignableScopes property in the role definition.

- Default value: `alz`

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Set Parameter to true to Opt-out of deployment telemetry. Default: false

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
subcriptionOwnerRoleId | string |
subcriptionOwnerSPNRoleId | string |
applicationOperatorRoleId | string |
networkOperatorRoleId | string |
securirtyOperatorRoleId | string |
platformOperatorRoleId | string |
virtualMachineOperatorRoleId | string |
deploymentsRoleId | string |

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
