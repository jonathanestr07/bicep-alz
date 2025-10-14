# ALZ Bicep - Privileged Identity Management

Deploys a roleEligibilityScheduleRequests resource for Azure PIM with optional conditions and ticket info.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
pimAssignmentsResourceGroup | No       | Array of PIM assignments for the resource group level. Uses the resource group name for the scope.
pimAssignmentsSubscription | No       | Array of PIM assignments for the subscription level. Uses the subscription ID for the scope.
pimAssignmentsTenant | No       | Array of PIM assignments for the tenant level.
pimAssignmentsManagementGroup | No       | Array of PIM assignments for the management group level. Uses the management group ID for the scope.

### pimAssignmentsResourceGroup

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of PIM assignments for the resource group level. Uses the resource group name for the scope.

### pimAssignmentsSubscription

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of PIM assignments for the subscription level. Uses the subscription ID for the scope.

### pimAssignmentsTenant

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of PIM assignments for the tenant level.

### pimAssignmentsManagementGroup

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of PIM assignments for the management group level. Uses the management group ID for the scope.

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
