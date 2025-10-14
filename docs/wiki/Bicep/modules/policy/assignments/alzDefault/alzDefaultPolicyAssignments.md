# ALZ Bicep - ALZ Default Policy Assignments

This module will assign the ALZ Default Policy Assignments to the ALZ Management Group hierarchy

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
topLevelManagementGroupPrefix | No       | Prefix used for the management group hierarchy.
topLevelManagementGroupSuffix | No       | Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix
platformMgAlzDefaultsEnable | No       | Management, Identity and Connectivity Management Groups beneath Platform Management Group have been deployed. If set to false, platform policies are assigned to the Platform Management Group; otherwise policies are assigned to the child management groups.
landingZoneChildrenMgAlzDefaultsEnable | No       | Corp & Online Management Groups beneath Landing Zones Management Groups have been deployed. If set to false, policies will not try to be assigned to corp or online Management Groups.
logAnalyticsWorkSpaceAndAutomationAccountLocation | No       | The region where the Log Analytics Workspace & Automation Account are deployed.
listOfAllowedLocations | No       | The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed.
logAnalyticsWorkspaceResourceId | No       | Log Analytics Workspace Resource ID.
dataCollectionRuleVMInsightsResourceId | No       | Data Collection Rule VM Insights Resource ID.
dataCollectionRuleChangeTrackingResourceId | No       | Data Collection Rule Change Tracking Resource ID.
dataCollectionRuleMDFCSQLResourceId | No       | Data Collection Rule MDFC SQL Resource ID.
userAssignedManagedIdentityResourceId | No       | User Assigned Managed Identity Resource ID.
logAnalyticsWorkspaceLogRetentionInDays | No       | Number of days of log retention for Log Analytics Workspace.
automationAccountName | No       | Automation account name.
msDefenderForCloudEmailSecurityContact | No       | An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.
ddosEnabled    | No       | Switch to enable/disable DDoS Network Protection deployment. True will enforce policy Enable-DDoS-VNET at connectivity or landing zone Management Groups. False will not enforce policy Enable-DDoS-VNET.
ddosProtectionPlanId | No       | ID of the DdosProtectionPlan which will be applied to the Virtual Networks.
privateDnsResourceGroupId | No       | Resource ID of the Resource Group that contain the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group.
privateDnsZonesNamesToAuditInCorp | No       | Provide an array/list of Private DNS Zones that you wish to audit if deployed into Subscriptions in the Corp Management Group. NOTE: The policy default values include all the static Private Link Private DNS Zones, e.g. all the DNS Zones that dont have a region or region shortcode in them. If you wish for these to be audited also you must provide a complete array/list to this parameter for ALL Private DNS Zones you wish to audit, including the static Private Link ones, as this parameter performs an overwrite operation. You can get all the Private DNS Zone Names form the `outPrivateDnsZonesNames` output in the Hub Networking or Private DNS Zone modules.
disableAlzDefaultPolicies | No       | Set Enforcement Mode of all default Policies assignments to Do Not Enforce.
vmBackupExclusionTagName | No       | Name of the tag to use for excluding VMs from the scope of this policy. This should be used along with the Exclusion Tag Value parameter.
vmBackupExclusionTagValue | No       | Value of the tag to use for excluding VMs from the scope of this policy (in case of multiple values, use a comma-separated list). This should be used along with the Exclusion Tag Name parameter.
excludedPolicyAssignments | No       | Adding assignment definition names to this array will exclude the specific policies from assignment. Find the correct values to this array in the following documentation: https://github.com/Azure/ALZ-Bicep/wiki/AssigningPolicies#what-if-i-want-to-exclude-specific-policy-assignments-from-alz-default-policy-assignments
privateDnsZonesLocation | No       | Location of Private DNS Zones.
telemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### topLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix used for the management group hierarchy.

- Default value: `alz`

### topLevelManagementGroupSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix

### platformMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Management, Identity and Connectivity Management Groups beneath Platform Management Group have been deployed. If set to false, platform policies are assigned to the Platform Management Group; otherwise policies are assigned to the child management groups.

- Default value: `True`

### landingZoneChildrenMgAlzDefaultsEnable

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Corp & Online Management Groups beneath Landing Zones Management Groups have been deployed. If set to false, policies will not try to be assigned to corp or online Management Groups.

- Default value: `True`

### logAnalyticsWorkSpaceAndAutomationAccountLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The region where the Log Analytics Workspace & Automation Account are deployed.

- Default value: `australiaeast`

### listOfAllowedLocations

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed.

### logAnalyticsWorkspaceResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Log Analytics Workspace Resource ID.

### dataCollectionRuleVMInsightsResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Data Collection Rule VM Insights Resource ID.

### dataCollectionRuleChangeTrackingResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Data Collection Rule Change Tracking Resource ID.

### dataCollectionRuleMDFCSQLResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Data Collection Rule MDFC SQL Resource ID.

### userAssignedManagedIdentityResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

User Assigned Managed Identity Resource ID.

### logAnalyticsWorkspaceLogRetentionInDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Number of days of log retention for Log Analytics Workspace.

- Default value: `365`

### automationAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Automation account name.

- Default value: `alz-automation-account`

### msDefenderForCloudEmailSecurityContact

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.

- Default value: `security_contact@replace_me.com`

### ddosEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable DDoS Network Protection deployment. True will enforce policy Enable-DDoS-VNET at connectivity or landing zone Management Groups. False will not enforce policy Enable-DDoS-VNET.

- Default value: `False`

### ddosProtectionPlanId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

ID of the DdosProtectionPlan which will be applied to the Virtual Networks.

### privateDnsResourceGroupId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Resource ID of the Resource Group that contain the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group.

### privateDnsZonesNamesToAuditInCorp

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Provide an array/list of Private DNS Zones that you wish to audit if deployed into Subscriptions in the Corp Management Group. NOTE: The policy default values include all the static Private Link Private DNS Zones, e.g. all the DNS Zones that dont have a region or region shortcode in them. If you wish for these to be audited also you must provide a complete array/list to this parameter for ALL Private DNS Zones you wish to audit, including the static Private Link ones, as this parameter performs an overwrite operation. You can get all the Private DNS Zone Names form the `outPrivateDnsZonesNames` output in the Hub Networking or Private DNS Zone modules.

### disableAlzDefaultPolicies

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Enforcement Mode of all default Policies assignments to Do Not Enforce.

- Default value: `False`

### vmBackupExclusionTagName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the tag to use for excluding VMs from the scope of this policy. This should be used along with the Exclusion Tag Value parameter.

### vmBackupExclusionTagValue

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Value of the tag to use for excluding VMs from the scope of this policy (in case of multiple values, use a comma-separated list). This should be used along with the Exclusion Tag Name parameter.

### excludedPolicyAssignments

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Adding assignment definition names to this array will exclude the specific policies from assignment. Find the correct values to this array in the following documentation: https://github.com/Azure/ALZ-Bicep/wiki/AssigningPolicies#what-if-i-want-to-exclude-specific-policy-assignments-from-alz-default-policy-assignments

### privateDnsZonesLocation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Location of Private DNS Zones.

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
