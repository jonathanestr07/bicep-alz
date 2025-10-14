# ALZ Bicep - Azure Platform Management Orchestration Module

Module used to create Azure Platform Management resources.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
lzPrefix       | Yes      | Required. Specifies the Landing Zone prefix for the deployment.
envPrefix      | Yes      | Required. Specifies the environment prefix for the deployment.
location       | No       | Optional. The Azure Region to deploy the resources into.
topLevelManagementGroupPrefix | No       | Required. Prefix for the management group hierarchy.
subscriptionId | Yes      | Required. The Subscription Id for the deployment.
tags           | Yes      | Optional. Tags that will be applied to all resources in this module.
subscriptionMgPlacement | No       | Optional. The Management Group Id to place the subscription in.
loggingEnabled | No       | Optional. Whether to deploy the logging module or not.
logAnalyticsConfiguration | Yes      | Optional. Configuration for Log Analytics.
logAnalyticsCustomTables | No       | Optional. Log Analytics Custom Tables to be deployed.
logAnalyticsWorkspaceSolutions | No       | Optional. Solutions that will be added to the Log Analytics Workspace.]
storageAccountConfiguration | Yes      | Optional. Configuration for Azure Storage Account.
virtualNetworkConfiguration | Yes      | Optional. Configuration for Azure Virtual Network.
virtualNetworkPeeringEnabled | No       | Optional. Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.
hubVirtualNetworkId | No       | Optional. Specifies the resource Id of the Hub Virtual Network, or Azure Virtuel WAN hub Id.
allowSpokeForwardedTraffic | No       | Optional. Switch to enable/disable forwarded Traffic from outside spoke network.
allowHubVpnGatewayTransit | No       | Optional. Switch to enable/disable VPN Gateway for the hub network peering.
budgetConfiguration | Yes      | Optional. Configuration for Azure Budgets.
startDate      | No       | Optional. Date timestamp.
actionGroupConfiguration | Yes      | Optional. Configuration for Action Groups.
containerRegistryConfiguration | Yes      | Optional. Configuration for Azure Container Registry.
deploySentinel | No       | Optional. Whether to deploy Azure Sentinel.
sentinelFirstDeploymentDate | No       | Required. Date when the Sentinel solution was first deployed, must be in YYYY-MM-DD format.
sentinelContentSolutions | No       | Optional. Array of Microsoft Sentinel Content Solutions to deploy.
deployKafka    | No       | Optional. Whether to deploy Kafka resources.
KafkaPrivateEndpointConfigs | No       | Optional. Configuration for Kafka Private Endpoints.
subnetResourceIdforKafka | No       | Optional. The subnet resource Id for Kafka Private Endpoints.
virtualMachines_Jumphosts | No       | Optional. Virtual Machine jump hosts to create.
jumpHostPassword | No       | Optional. Password for the Jump Host virtual machine(s).
enableJumphostAutomaticUpdates | No       | Whether to enable automatic updates on the virtual machines.
deployUpdateManagement | No       | Optional. Whether to deploy Azure Update Management.
maintenanceWindow | No       | Maintenance Window Configuration for Azure Update Manager.
rebootSetting  | No       | Optional. The reboot setting for the maintenance configuration
deployEASM     | No       | Optional. Whether to deploy Defender EASM.
defenderEASMName | No       | Optional. The Defender EASM instance name.
GitHubDatabaseId | No       | Optional. The GitHub database Id.
subnetResourceIdforGitHub | No       | Optional. The subnet resource Id for GitHub Private Endpoints.
GitHubOrganisationName | No       | Optional. The GitHub organisation name.
GitHubUserAssignedIdentities | No       | Optional. The GitHub user assigned identities.
deployGrafana  | No       | Optional. Whether to deploy Grafana.
grafanaAdminObjectIds | No       | Optional. Specifies an array of object IDs for Grafana admins.
grafanaEditorObjectIds | No       | Optional. Specifies an array of object IDs for Grafana editors.
grafanaViewerObjectIds | No       | Optional. Specifies an array of object IDs for Grafana viewers.
grafanaSMTPPassword | No       | Optional. Password for STMP configurations.
planIdGrafana  | No       | Optional. Grafana Enterprise Plan ID.
grafanaSMTPHost | No       | Required. Host for SMTP configurations
grafanaSMTPUser | No       | Required. User for SMTP configurations
grafanaSMTPemailAddress | No       | Required. email address for sending out emails for SMTP configurations
grafanaSMTPName | No       | Required. Name used for sending out emails for SMTP configurations

### lzPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Specifies the Landing Zone prefix for the deployment.

### envPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Specifies the environment prefix for the deployment.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure Region to deploy the resources into.

- Default value: `[deployment().location]`

### topLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. Prefix for the management group hierarchy.

- Default value: `alz`

### subscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The Subscription Id for the deployment.

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### subscriptionMgPlacement

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Management Group Id to place the subscription in.

### loggingEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Whether to deploy the logging module or not.

- Default value: `True`

### logAnalyticsConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Log Analytics.

### logAnalyticsCustomTables

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Log Analytics Custom Tables to be deployed.

### logAnalyticsWorkspaceSolutions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Solutions that will be added to the Log Analytics Workspace.]

- Default value: `SecurityInsights ChangeTracking SQLVulnerabilityAssessment`

- Allowed values: `SecurityInsights`, `ChangeTracking`, `SQLVulnerabilityAssessment`

### storageAccountConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Azure Storage Account.

### virtualNetworkConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Azure Virtual Network.

### virtualNetworkPeeringEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.

- Default value: `True`

### hubVirtualNetworkId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Specifies the resource Id of the Hub Virtual Network, or Azure Virtuel WAN hub Id.

### allowSpokeForwardedTraffic

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch to enable/disable forwarded Traffic from outside spoke network.

- Default value: `True`

### allowHubVpnGatewayTransit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch to enable/disable VPN Gateway for the hub network peering.

- Default value: `True`

### budgetConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Azure Budgets.

### startDate

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Date timestamp.

- Default value: `[format('{0}-{1}-01T00:00:00Z', utcNow('yyyy'), utcNow('MM'))]`

### actionGroupConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Action Groups.

### containerRegistryConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Configuration for Azure Container Registry.

### deploySentinel

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Whether to deploy Azure Sentinel.

- Default value: `False`

### sentinelFirstDeploymentDate

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. Date when the Sentinel solution was first deployed, must be in YYYY-MM-DD format.

### sentinelContentSolutions

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Array of Microsoft Sentinel Content Solutions to deploy.

### deployKafka

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Whether to deploy Kafka resources.

- Default value: `False`

### KafkaPrivateEndpointConfigs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Configuration for Kafka Private Endpoints.

### subnetResourceIdforKafka

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The subnet resource Id for Kafka Private Endpoints.

### virtualMachines_Jumphosts

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Virtual Machine jump hosts to create.

### jumpHostPassword

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Password for the Jump Host virtual machine(s).

- Default value: `[newGuid()]`

### enableJumphostAutomaticUpdates

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Whether to enable automatic updates on the virtual machines.

- Default value: `True`

### deployUpdateManagement

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Whether to deploy Azure Update Management.

- Default value: `False`

### maintenanceWindow

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Maintenance Window Configuration for Azure Update Manager.

- Default value: `@{startDateTime=2024-12-06 02:00; duration=03:55; timeZone=W. Australia Standard Time; expirationDateTime=; recurEvery=1Day}`

### rebootSetting

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The reboot setting for the maintenance configuration

- Default value: `IfRequired`

### deployEASM

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Whether to deploy Defender EASM.

- Default value: `False`

### defenderEASMName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Defender EASM instance name.

- Default value: `DefenderEASM`

### GitHubDatabaseId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The GitHub database Id.

### subnetResourceIdforGitHub

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The subnet resource Id for GitHub Private Endpoints.

### GitHubOrganisationName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The GitHub organisation name.

- Default value: `Insight-Services-APAC`

### GitHubUserAssignedIdentities

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The GitHub user assigned identities.

### deployGrafana

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Whether to deploy Grafana.

- Default value: `False`

### grafanaAdminObjectIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Specifies an array of object IDs for Grafana admins.

### grafanaEditorObjectIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Specifies an array of object IDs for Grafana editors.

### grafanaViewerObjectIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Specifies an array of object IDs for Grafana viewers.

### grafanaSMTPPassword

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Password for STMP configurations.

- Default value: `[newGuid()]`

### planIdGrafana

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Grafana Enterprise Plan ID.

### grafanaSMTPHost

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. Host for SMTP configurations

### grafanaSMTPUser

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. User for SMTP configurations

### grafanaSMTPemailAddress

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. email address for sending out emails for SMTP configurations

### grafanaSMTPName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. Name used for sending out emails for SMTP configurations

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
