# ALZ Bicep - Logging Module

ALZ Bicep Module used to set up Logging

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
logAnalyticsWorkspaceName | Yes      | Required. Log Analytics Workspace name.
logAnalyticsConfiguration | Yes      | Optional. Configuration for Log Analytics.
logAnalyticsWorkspaceLocation | No       | Optional. Ensure the regions selected is a supported mapping as per: <https://docs.microsoft.com/azure/automation/how-to/region-mappings/>
dataCollectionRuleLinuxName | Yes      | Required. Data Collection Rule name for Linux Syslog for AMA integration.
dataCollectionRuleWindowsCommonName | Yes      | Required. Data Collection Rule name for Windows Common Event Logs for AMA integration.
dataCollectionRuleVMInsightsName | Yes      | Required. Data Collection Rule name for VM Insights for AMA integration.
dataCollectionRuleChangeTrackingName | Yes      | Required. Change Tracking Data Collection Rule name for AMA integration.
dataCollectionRuleMDFCSQLName | Yes      | Required. MDFC for SQL Data Collection Rule name for AMA integration.
logAnalyticsWorkspaceSolutions | No       | Optional. Solutions that will be added to the Log Analytics Workspace.
userAssignedManagedIdentityName | Yes      | Required. Name of the User Assigned Managed Identity required for authenticating Azure Monitoring Agent to Azure.
userAssignedManagedIdentityLocation | No       | Optional. User Assigned Managed Identity location.
logAnalyticsWorkspaceLinkAutomationAccount | No       | Optional. Log Analytics Workspace should be linked with the automation account.
automationAccountName | No       | Required. Automation account name.
automationAccountLocation | No       | Optional. Automation Account region name. - Ensure the regions selected is a supported mapping as per: <https://docs.microsoft.com/azure/automation/how-to/region-mappings/>ß
storageAccountConfiguration | Yes      | Optional. Configuration for Azure Storage Account.
storageAccountName | No       | Required. Storage Account Name.
location       | No       | Optional. Location for the storage account.
tags           | Yes      | Optional. Tags that will be applied to all resources in this module.
useSentinelClassicPricingTiers | No       | Optional. Set Parameter to true to use Sentinel Classic Pricing Tiers, following changes introduced in July 2023 as documented here: <https://learn.microsoft.com/azure/sentinel/enroll-simplified-pricing-tier/>ß
telemetryOptOut | No       | Optional. Set Parameter to true to Opt-out of deployment telemetry.
logAnalyticsCustomTables | No       | Optional. Log Analytics Custom Tables to be deployed.

### logAnalyticsWorkspaceName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Log Analytics Workspace name.

### logAnalyticsConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Log Analytics.

### logAnalyticsWorkspaceLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Ensure the regions selected is a supported mapping as per: <https://docs.microsoft.com/azure/automation/how-to/region-mappings/>

- Default value: `[resourceGroup().location]`

### dataCollectionRuleLinuxName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Data Collection Rule name for Linux Syslog for AMA integration.

### dataCollectionRuleWindowsCommonName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Data Collection Rule name for Windows Common Event Logs for AMA integration.

### dataCollectionRuleVMInsightsName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Data Collection Rule name for VM Insights for AMA integration.

### dataCollectionRuleChangeTrackingName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Change Tracking Data Collection Rule name for AMA integration.

### dataCollectionRuleMDFCSQLName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. MDFC for SQL Data Collection Rule name for AMA integration.

### logAnalyticsWorkspaceSolutions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Solutions that will be added to the Log Analytics Workspace.

- Default value: `SecurityInsights ChangeTracking SQLVulnerabilityAssessment`

- Allowed values: `SecurityInsights`, `ChangeTracking`, `SQLVulnerabilityAssessment`

### userAssignedManagedIdentityName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Name of the User Assigned Managed Identity required for authenticating Azure Monitoring Agent to Azure.

### userAssignedManagedIdentityLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. User Assigned Managed Identity location.

- Default value: `[resourceGroup().location]`

### logAnalyticsWorkspaceLinkAutomationAccount

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Log Analytics Workspace should be linked with the automation account.

- Default value: `True`

### automationAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. Automation account name.

- Default value: `aaa-aue-plat-mgmt-01`

### automationAccountLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Automation Account region name. - Ensure the regions selected is a supported mapping as per: <https://docs.microsoft.com/azure/automation/how-to/region-mappings/>ß

- Default value: `[resourceGroup().location]`

### storageAccountConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Azure Storage Account.

### storageAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. Storage Account Name.

- Default value: `staaueplatmgmt01`

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Location for the storage account.

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### useSentinelClassicPricingTiers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Set Parameter to true to use Sentinel Classic Pricing Tiers, following changes introduced in July 2023 as documented here: <https://learn.microsoft.com/azure/sentinel/enroll-simplified-pricing-tier/>ß

- Default value: `False`

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `True`

### logAnalyticsCustomTables

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Log Analytics Custom Tables to be deployed.

## Outputs

Name | Type | Description
---- | ---- | -----------
logAnalyticsWorkspaceName | string |
logAnalyticsWorkspaceId | string |
logAnalyticsCustomerId | string |
logAnalyticsSolutions | array |
automationAccountName | string |
automationAccountId | string |
storageAccountName | string |
storageAccountId | string |

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
