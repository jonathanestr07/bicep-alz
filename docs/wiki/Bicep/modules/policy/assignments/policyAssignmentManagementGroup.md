# ALZ Bicep - Management Group Policy Assignments

Module used to assign policy definitions to management groups

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
policyAssignmentName | No       | The name of the policy assignment. e.g. "Deny-Public-IP"
policyAssignmentDisplayName | No       | The display name of the policy assignment. e.g. "Deny the creation of Public IPs"
policyAssignmentDescription | No       | The description of the policy assignment. e.g. "This policy denies creation of Public IPs under the assigned scope."
policyAssignmentMetaData | No       | An object containing the metadata values.
policyAssignmentDefinitionId | No       | The policy definition ID for the policy to be assigned. e.g. "/providers/Microsoft.Authorization/policyDefinitions/9d0a794f-1444-4c96-9534-e35fc8c39c91" or "/providers/Microsoft.Management/managementgroups/alz/providers/Microsoft.Authorization/policyDefinitions/Deny-Public-IP"
policyAssignmentParameters | No       | An object containing the parameter values for the policy to be assigned.
policyAssignmentParameterOverrides | No       | An object containing parameter values that override those provided to policyAssignmentParameters, usually via a JSON file and json(loadTextContent(FILE_PATH)). This is only useful when wanting to take values from a source like a JSON file for the majority of the parameters but override specific parameter inputs from other sources or hardcoded. If duplicate parameters exist between policyAssignmentParameters & policyAssignmentParameterOverrides, inputs provided to policyAssignmentParameterOverrides will win.
policyAssignmentNonComplianceMessages | No       | An array containing object/s for the non-compliance messages for the policy to be assigned. See <https://docs.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#non-compliance-messages/> for more details on use.
policyAssignmentNotScopes | No       | An array containing a list of scope Resource IDs to be excluded for the policy assignment. e.g. ['/providers/Microsoft.Management/managementgroups/alz', '/providers/Microsoft.Management/managementgroups/alz-sandbox' ].
policyAssignmentEnforcementMode | No       | The enforcement mode for the policy assignment. See <https://aka.ms/EnforcementMode/> for more details on use.
policyAssignmentOverrides | No       | An array containing a list of objects containing the required overrides to be set on the assignment. See <https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#overrides-preview/> for more details on use.
policyAssignmentResourceSelectors | No       | An array containing a list of objects containing the required resource selectors to be set on the assignment. See <https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#resource-selectors-preview/> for more details on use.
policyAssignmentIdentityType | No       | The type of identity to be created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects.
policyAssignmentIdentityRoleAssignmentsAdditionalMGs | No       | An array containing a list of additional Management Group IDs (as the Management Group deployed to is included automatically) that the System-assigned Managed Identity, associated to the policy assignment, will be assigned to additionally. e.g. ['alz', 'alz-sandbox' ].
policyAssignmentIdentityRoleAssignmentsSubs | No       | An array containing a list of Subscription IDs that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to. e.g. ['8200b669-cbc6-4e6c-b6d8-f4797f924074', '7d58dc5d-93dc-43cd-94fc-57da2e74af0d' ].
policyAssignmentIdentityRoleAssignmentsResourceGroups | No       | An array containing a list of Subscription IDs and Resource Group names seperated by a / (subscription ID/resource group name) that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to. e.g. ['8200b669-cbc6-4e6c-b6d8-f4797f924074/rg01', '7d58dc5d-93dc-43cd-94fc-57da2e74af0d/rg02' ].
policyAssignmentIdentityRoleDefinitionIds | No       | An array containing a list of RBAC role definition IDs to be assigned to the Managed Identity that is created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects. e.g. ['/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c']. DEFAULT VALUE = []
telemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry

### policyAssignmentName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the policy assignment. e.g. "Deny-Public-IP"

- Default value: `replaceme`

### policyAssignmentDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The display name of the policy assignment. e.g. "Deny the creation of Public IPs"

- Default value: `replaceme`

### policyAssignmentDescription

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The description of the policy assignment. e.g. "This policy denies creation of Public IPs under the assigned scope."

- Default value: `replaceme`

### policyAssignmentMetaData

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An object containing the metadata values.

- Default value: `@{assignedBy=GitHub}`

### policyAssignmentDefinitionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The policy definition ID for the policy to be assigned. e.g. "/providers/Microsoft.Authorization/policyDefinitions/9d0a794f-1444-4c96-9534-e35fc8c39c91" or "/providers/Microsoft.Management/managementgroups/alz/providers/Microsoft.Authorization/policyDefinitions/Deny-Public-IP"

### policyAssignmentParameters

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An object containing the parameter values for the policy to be assigned.

### policyAssignmentParameterOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An object containing parameter values that override those provided to policyAssignmentParameters, usually via a JSON file and json(loadTextContent(FILE_PATH)). This is only useful when wanting to take values from a source like a JSON file for the majority of the parameters but override specific parameter inputs from other sources or hardcoded. If duplicate parameters exist between policyAssignmentParameters & policyAssignmentParameterOverrides, inputs provided to policyAssignmentParameterOverrides will win.

### policyAssignmentNonComplianceMessages

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing object/s for the non-compliance messages for the policy to be assigned. See <https://docs.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#non-compliance-messages/> for more details on use.

### policyAssignmentNotScopes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing a list of scope Resource IDs to be excluded for the policy assignment. e.g. ['/providers/Microsoft.Management/managementgroups/alz', '/providers/Microsoft.Management/managementgroups/alz-sandbox' ].

### policyAssignmentEnforcementMode

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The enforcement mode for the policy assignment. See <https://aka.ms/EnforcementMode/> for more details on use.

- Default value: `Default`

- Allowed values: `Default`, `DoNotEnforce`

### policyAssignmentOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing a list of objects containing the required overrides to be set on the assignment. See <https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#overrides-preview/> for more details on use.

### policyAssignmentResourceSelectors

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing a list of objects containing the required resource selectors to be set on the assignment. See <https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#resource-selectors-preview/> for more details on use.

### policyAssignmentIdentityType

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The type of identity to be created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects.

- Default value: `None`

- Allowed values: `None`, `SystemAssigned`

### policyAssignmentIdentityRoleAssignmentsAdditionalMGs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing a list of additional Management Group IDs (as the Management Group deployed to is included automatically) that the System-assigned Managed Identity, associated to the policy assignment, will be assigned to additionally. e.g. ['alz', 'alz-sandbox' ].

### policyAssignmentIdentityRoleAssignmentsSubs

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing a list of Subscription IDs that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to. e.g. ['8200b669-cbc6-4e6c-b6d8-f4797f924074', '7d58dc5d-93dc-43cd-94fc-57da2e74af0d' ].

### policyAssignmentIdentityRoleAssignmentsResourceGroups

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing a list of Subscription IDs and Resource Group names seperated by a / (subscription ID/resource group name) that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to. e.g. ['8200b669-cbc6-4e6c-b6d8-f4797f924074/rg01', '7d58dc5d-93dc-43cd-94fc-57da2e74af0d/rg02' ].

### policyAssignmentIdentityRoleDefinitionIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array containing a list of RBAC role definition IDs to be assigned to the Managed Identity that is created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects. e.g. ['/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c']. DEFAULT VALUE = []

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
