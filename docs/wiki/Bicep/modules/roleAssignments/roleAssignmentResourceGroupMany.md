# ALZ Bicep - Role Assignment to Resource Groups

Module used to assign a Role Assignment to multiple Resource Groups

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
resourceGroupIds | No       | A list of Resource Groups that will be used for role assignment in the format of subscriptionId/resourceGroupName (i.e. a1fe8a74-e0ac-478b-97ea-24a27958961b/rg01).
roleDefinitionId | No       | Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)
assigneePrincipalType | Yes      | Principal type of the assignee.  Allowed values are 'Group' (Security Group) or 'ServicePrincipal' (Service Principal or System/User Assigned Managed Identity)
assigneeObjectId | No       | Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID
telemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### resourceGroupIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

A list of Resource Groups that will be used for role assignment in the format of subscriptionId/resourceGroupName (i.e. a1fe8a74-e0ac-478b-97ea-24a27958961b/rg01).

### roleDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)

### assigneePrincipalType

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Principal type of the assignee.  Allowed values are 'Group' (Security Group) or 'ServicePrincipal' (Service Principal or System/User Assigned Managed Identity)

- Allowed values: `Group`, `ServicePrincipal`

### assigneeObjectId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry

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
