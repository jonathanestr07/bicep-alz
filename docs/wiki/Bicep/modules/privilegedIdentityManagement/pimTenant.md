# ALZ Bicep - Privileged Identity Management

Deploys a roleEligibilityScheduleRequests resource for Azure PIM with optional conditions and ticket info.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
deploymentSeedRandom | No       | Optional. Random for the deployment name.
condition      | Yes      | Optional. Condition for the role eligibility schedule request (e.g. a custom expression).
conditionVersion | No       | Optional. Condition version, must be set to "2.0" if condition is used. Allowed value: "2.0"
justification  | Yes      | Required. Reason or note justifying the request.
principalId    | Yes      | Required. Principal (user or service principal) object ID.
requestType    | Yes      | Required. Type of eligibility request.
roleDefinitionId | Yes      | Required. ID of the role definition.
duration       | Yes      | Required. The ISO 8601 time duration for eligibility.
endDateTime    | No       | Optional. Future date/time when eligibility ends (in ISO 8601 format).
expirationType | Yes      | Required. Defines how eligibility ends.
startDateTime  | No       | Optional. Date/time when eligibility starts, defaults to current UTC time.
targetRoleEligibilityScheduleId | Yes      | Optional. Resource ID of the target role eligibility schedule.
targetRoleEligibilityScheduleInstanceId | Yes      | Optional. Resource ID of the target role eligibility schedule instance.
ticketNumber   | Yes      | Optional. Ticket number for tracking.
ticketSystem   | Yes      | Optional. Ticket system name or identifier.

### deploymentSeedRandom

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Random for the deployment name.

- Default value: `False`

### condition

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Condition for the role eligibility schedule request (e.g. a custom expression).

### conditionVersion

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Condition version, must be set to "2.0" if condition is used. Allowed value: "2.0"

- Default value: `2.0`

### justification

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Reason or note justifying the request.

### principalId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Principal (user or service principal) object ID.

### requestType

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Type of eligibility request.

- Allowed values: `AdminAssign`, `AdminExtend`, `AdminRemove`, `AdminRenew`, `AdminUpdate`, `SelfActivate`, `SelfDeactivate`, `SelfExtend`, `SelfRenew`

### roleDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. ID of the role definition.

### duration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The ISO 8601 time duration for eligibility.

### endDateTime

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Future date/time when eligibility ends (in ISO 8601 format).

### expirationType

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Defines how eligibility ends.

- Allowed values: `AfterDateTime`, `AfterDuration`, `NoExpiration`

### startDateTime

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Date/time when eligibility starts, defaults to current UTC time.

- Default value: `[utcNow()]`

### targetRoleEligibilityScheduleId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Resource ID of the target role eligibility schedule.

### targetRoleEligibilityScheduleInstanceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Resource ID of the target role eligibility schedule instance.

### ticketNumber

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Ticket number for tracking.

### ticketSystem

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Ticket system name or identifier.

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
