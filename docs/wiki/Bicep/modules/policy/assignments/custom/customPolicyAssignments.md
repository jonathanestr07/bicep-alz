# ALZ Bicep - Management Group Policy Assignments

This module will assign Custom Policy Assignments to the ALZ Management Group hierarchy

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
topLevelManagementGroupPrefix | No       | Prefix for the management group hierarchy.
topLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
disablePolicies | No       | Set Enforcement Mode on Azure Policy assignments to Do Not Enforce.
logAnalyticsWorkspaceId | Yes      | Required. Log Analytics Workspace Resource ID.
virtualNetworkResourceId | No       | DNS Server Virtual Network Resource Id.
storageAccountResourceId | No       | Required. Resource Id of the Storage Account for Platform Logging.
excludedPolicyAssignments | No       | Adding assignment definition names to this array will exclude the specific policies from assignment.

### topLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for the management group hierarchy.

- Default value: `alz`

### topLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### disablePolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Enforcement Mode on Azure Policy assignments to Do Not Enforce.

- Default value: `False`

### logAnalyticsWorkspaceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Log Analytics Workspace Resource ID.

### virtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

DNS Server Virtual Network Resource Id.

### storageAccountResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. Resource Id of the Storage Account for Platform Logging.

### excludedPolicyAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Adding assignment definition names to this array will exclude the specific policies from assignment.

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
