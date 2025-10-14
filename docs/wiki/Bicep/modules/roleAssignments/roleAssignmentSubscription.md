# ALZ Bicep - Role Assignment to a Subscription

Module used to assign a Role Assignment to a Subscription

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
roleAssignmentNameGuid | No       | A GUID representing the role assignment name.
roleDefinitionId | No       | Role Definition Id (i.e. GUID, Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7).
assigneePrincipalType | No       | Principal type of the assignee. Allowed values are 'Group' (Security Group) or 'ServicePrincipal' (Service Principal or System/User Assigned Managed Identity).
assigneeObjectId | No       | Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID.
telemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.
condition      | No       | Optional. Condition to apply to the role assignment.

### roleAssignmentNameGuid

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

A GUID representing the role assignment name.

- Default value: `[guid(subscription().subscriptionId, parameters('roleDefinitionId'), parameters('assigneeObjectId'))]`

### roleDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Role Definition Id (i.e. GUID, Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7).

### assigneePrincipalType

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Principal type of the assignee. Allowed values are 'Group' (Security Group) or 'ServicePrincipal' (Service Principal or System/User Assigned Managed Identity).

- Default value: `Group`

- Allowed values: `Group`, `ServicePrincipal`

### assigneeObjectId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID.

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

### condition

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Condition to apply to the role assignment.

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
