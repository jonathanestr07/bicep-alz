# Azure Sentinel

Deploys Azure Sentinel, settings, solutions and its dependencies. Expects Log Analytics Workspace to already exist.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | No       | Optional. Location for the storage account.
workspaceName  | Yes      | Required. Specifies the name of the Log Analytics Workspace.
uaiSentinelName | Yes      | Required. Specifies the name of the user-assigned identity to create for the deployment script.
dataState      | No       | Optional. Specifies the state of all the data connectors deployed in this template.
tags           | No       | Optional. Tags that will be applied to all resources in this module.
sentinelContentSolutions | No       | Optional. Array of Microsoft Sentinel Content Solutions to deploy.
sentinelFirstDeploymentDate | Yes      | Required. Date when the Sentinel solution was first deployed, must be in YYYY-MM-DD format.
currentDate    | No       | Current date in UTC

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Location for the storage account.

- Default value: `[resourceGroup().location]`

### workspaceName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Specifies the name of the Log Analytics Workspace.

### uaiSentinelName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Specifies the name of the user-assigned identity to create for the deployment script.

### dataState

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Specifies the state of all the data connectors deployed in this template.

- Default value: `Enabled`

- Allowed values: `Enabled`, `Disabled`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### sentinelContentSolutions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Array of Microsoft Sentinel Content Solutions to deploy.

### sentinelFirstDeploymentDate

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Date when the Sentinel solution was first deployed, must be in YYYY-MM-DD format.

### currentDate

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Current date in UTC

- Default value: `[utcNow()]`

## Outputs

Name | Type | Description
---- | ---- | -----------
logAnalyticsWorkspaceName | string |
logAnalyticsWorkspaceId | string |
sentinelId | string |
sentinelName | string |
azureADDataConnectorId | string |
defenderCloudConnectorId | string |
entraIDConnectorId | string |
threatIntelligenceConnectorId | string |

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
