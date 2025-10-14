# ALZ Bicep - Management Group Policy Assignments

This module will assign Insight Policy Assignments to the ALZ Management Group hierarchy

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
topLevelManagementGroupPrefix | No       | Prefix for the management group hierarchy.
topLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
disablePolicies | No       | Set Enforcement Mode on Azure Policy assignments to Do Not Enforce.
logAnalyticsWorkspaceId | No       | Log Analytics Workspace Resource ID.
virtualNetworkResourceId | No       | DNS Server Virtual Network Resource Id.
actionGroupId  | No       | Action Group Resource Id for Azure Service Health Alerts.
serviceHealthAlertName | No       | Name of the service health alert.
serviceHealthAlertRG | No       | Resource Group of the service health alert.
configurationProfile | No       | The management services provided are based on your own settings from your custom Configuration Profile.
inclusionTagName | No       | Name of the tag to use for including VMs in the scope of this policy. This should be used along with the Inclusion Tag Value parameter.
inclusionTagValues | No       | Value of the tag to use for including VMs in the scope of this policy (in case of multiple values, use a comma-separated list). This should be used along with the Inclusion Tag Name parameter.
storageAccountResourceId | No       | Resource Id of the Storage Account for Platform Logging.
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

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace Resource ID.

### virtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

DNS Server Virtual Network Resource Id.

### actionGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Action Group Resource Id for Azure Service Health Alerts.

### serviceHealthAlertName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the service health alert.

### serviceHealthAlertRG

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Group of the service health alert.

### configurationProfile

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The management services provided are based on your own settings from your custom Configuration Profile.

### inclusionTagName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the tag to use for including VMs in the scope of this policy. This should be used along with the Inclusion Tag Value parameter.

### inclusionTagValues

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Value of the tag to use for including VMs in the scope of this policy (in case of multiple values, use a comma-separated list). This should be used along with the Inclusion Tag Name parameter.

### storageAccountResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource Id of the Storage Account for Platform Logging.

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
