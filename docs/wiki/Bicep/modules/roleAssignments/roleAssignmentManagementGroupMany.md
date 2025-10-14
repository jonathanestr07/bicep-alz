# ALZ Bicep - Role Assignment to Management Groups

Module used to assign a Role Assignment to multiple Management Groups

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
managementGroupIds | No       | A list of management group scopes that will be used for role assignment.
roleDefinitionId | No       | Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7).
assigneePrincipalType | No       | Principal type of the assignee. Allowed values are 'Group' (Security Group) or 'ServicePrincipal' (Service Principal or System/User Assigned Managed Identity).
assigneeObjectId | No       | Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID.

### managementGroupIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

A list of management group scopes that will be used for role assignment.

### roleDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7).

### assigneePrincipalType

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Principal type of the assignee. Allowed values are 'Group' (Security Group) or 'ServicePrincipal' (Service Principal or System/User Assigned Managed Identity).

- Default value: `Group`

- Allowed values: `Group`, `ServicePrincipal`

### assigneeObjectId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID.

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
