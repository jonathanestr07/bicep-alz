# ALZ Bicep - Management Groups Module

ALZ Bicep Module to set up Management Group structure

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
topLevelManagementGroupPrefix | No       | Prefix for the management group hierarchy. This management group will be created as part of the deployment.
topLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
topLevelManagementGroupDisplayName | No       | Display name for top level management group. This name will be applied to the management group prefix defined in topLevelManagementGroupPrefix parameter.
parTopLevelManagementGroupParentId | No       | Optional parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty, default, will deploy beneath Tenant Root Management Group.
landingZoneMgAlzDefaultsEnable | No       | Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true.
platformMgAlzDefaultsEnable | No       | Deploys Management, Identity and Connectivity Management Groups beneath Platform Management Group if set to true.
landingZoneMgConfidentialEnable | No       | Deploys Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true.
landingZoneMgChildren | No       | Dictionary Object to allow additional or different child Management Groups of Landing Zones Management Group to be deployed.
platformMgChildren | No       | Dictionary Object to allow additional or different child Management Groups of Platform Management Group to be deployed.
telemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### topLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for the management group hierarchy. This management group will be created as part of the deployment.

- Default value: `alz`

### topLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### topLevelManagementGroupDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Display name for top level management group. This name will be applied to the management group prefix defined in topLevelManagementGroupPrefix parameter.

- Default value: `Azure Landing Zones`

### parTopLevelManagementGroupParentId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty, default, will deploy beneath Tenant Root Management Group.

### landingZoneMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true.

- Default value: `True`

### platformMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Management, Identity and Connectivity Management Groups beneath Platform Management Group if set to true.

- Default value: `True`

### landingZoneMgConfidentialEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Deploys Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true.

- Default value: `False`

### landingZoneMgChildren

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Dictionary Object to allow additional or different child Management Groups of Landing Zones Management Group to be deployed.

### platformMgChildren

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Dictionary Object to allow additional or different child Management Groups of Platform Management Group to be deployed.

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
topLevelManagementGroupId | string |
platformManagementGroupId | string |
platformChildrenManagementGroupIds | array |
landingZonesManagementGroupId | string |
landingZoneChildrenManagementGroupIds | array |
sandboxManagementGroupId | string |
decommissionedManagementGroupId | string |
topLevelManagementGroupName | string |
platformManagementGroupName | string |
platformChildrenManagementGroupNames | array |
landingZonesManagementGroupName | string |
landingZoneChildrenManagementGroupNames | array |
sandboxManagementGroupName | string |
decommissionedManagementGroupName | string |

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
