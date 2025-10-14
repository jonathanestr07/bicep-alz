# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
assignableScopeManagementGroupId | No       | The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.

### assignableScopeManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.

## Outputs

Name | Type | Description
---- | ---- | -----------
roleDefinitionId | string |

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
