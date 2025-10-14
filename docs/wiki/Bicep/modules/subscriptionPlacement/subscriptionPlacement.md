# ALZ Bicep - Subscription Placement module

This Module is used to place Azure Subscriptions into a Management Group.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
subscriptionIds | No       | Array of Subscription Ids that should be moved to the new management group. Default: Empty Array
targetManagementGroupId | Yes      | Target management group for the subscription. This management group must exist.
telemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### subscriptionIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of Subscription Ids that should be moved to the new management group. Default: Empty Array

### targetManagementGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Target management group for the subscription. This management group must exist.

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

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
