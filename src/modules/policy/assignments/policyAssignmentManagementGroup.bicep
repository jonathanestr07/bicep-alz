targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Management Group Policy Assignments'
metadata description = 'Module used to assign policy definitions to management groups'
metadata version = '1.0.0'
metadata author = 'Insight APAC Platform Engineering'

type nonComplianceMessageType = {
  @description('The message to display when the policy is non-compliant.')
  message: string

  @description('The reference ID of the policy definition.')
  policyDefinitionReferenceId: string
}[]

@minLength(1)
@maxLength(24)
@description('The name of the policy assignment. e.g. "Deny-Public-IP"')
param policyAssignmentName string = 'replaceme'

@description('The display name of the policy assignment. e.g. "Deny the creation of Public IPs"')
param policyAssignmentDisplayName string = 'replaceme'

@description('The description of the policy assignment. e.g. "This policy denies creation of Public IPs under the assigned scope."')
param policyAssignmentDescription string = 'replaceme'

@description('An object containing the metadata values.')
param policyAssignmentMetaData object = {
  assignedBy: 'GitHub'
}

@description('The policy definition ID for the policy to be assigned. e.g. "/providers/Microsoft.Authorization/policyDefinitions/9d0a794f-1444-4c96-9534-e35fc8c39c91" or "/providers/Microsoft.Management/managementgroups/alz/providers/Microsoft.Authorization/policyDefinitions/Deny-Public-IP"')
param policyAssignmentDefinitionId string = ''

@description('An object containing the parameter values for the policy to be assigned.')
param policyAssignmentParameters object = {}

@description('An object containing parameter values that override those provided to policyAssignmentParameters, usually via a JSON file and json(loadTextContent(FILE_PATH)). This is only useful when wanting to take values from a source like a JSON file for the majority of the parameters but override specific parameter inputs from other sources or hardcoded. If duplicate parameters exist between policyAssignmentParameters & policyAssignmentParameterOverrides, inputs provided to policyAssignmentParameterOverrides will win.')
param policyAssignmentParameterOverrides object = {}

@description('An array containing object/s for the non-compliance messages for the policy to be assigned. See <https://docs.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure#non-compliance-messages/> for more details on use.')
param policyAssignmentNonComplianceMessages nonComplianceMessageType = []

@description('An array containing a list of scope Resource IDs to be excluded for the policy assignment. e.g. [\'/providers/Microsoft.Management/managementgroups/alz\', \'/providers/Microsoft.Management/managementgroups/alz-sandbox\' ].')
param policyAssignmentNotScopes array = []

@allowed([
  'Default'
  'DoNotEnforce'
])
@description('The enforcement mode for the policy assignment. See <https://aka.ms/EnforcementMode/> for more details on use.')
param policyAssignmentEnforcementMode string = 'Default'

@description('An array containing a list of objects containing the required overrides to be set on the assignment. See <https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#overrides-preview/> for more details on use.')
param policyAssignmentOverrides array = []

@description('An array containing a list of objects containing the required resource selectors to be set on the assignment. See <https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#resource-selectors-preview/> for more details on use.')
param policyAssignmentResourceSelectors array = []

@allowed([
  'None'
  'SystemAssigned'
])
@description('The type of identity to be created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects.')
param policyAssignmentIdentityType string = 'None'

@description('An array containing a list of additional Management Group IDs (as the Management Group deployed to is included automatically) that the System-assigned Managed Identity, associated to the policy assignment, will be assigned to additionally. e.g. [\'alz\', \'alz-sandbox\' ].')
param policyAssignmentIdentityRoleAssignmentsAdditionalMGs array = []

@description('An array containing a list of Subscription IDs that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to. e.g. [\'8200b669-cbc6-4e6c-b6d8-f4797f924074\', \'7d58dc5d-93dc-43cd-94fc-57da2e74af0d\' ].')
param policyAssignmentIdentityRoleAssignmentsSubs array = []

@description('An array containing a list of Subscription IDs and Resource Group names seperated by a / (subscription ID/resource group name) that the System-assigned Managed Identity associated to the policy assignment will be assigned to in addition to the Management Group the policy is deployed/assigned to. e.g. [\'8200b669-cbc6-4e6c-b6d8-f4797f924074/rg01\', \'7d58dc5d-93dc-43cd-94fc-57da2e74af0d/rg02\' ].')
param policyAssignmentIdentityRoleAssignmentsResourceGroups array = []

@description('An array containing a list of RBAC role definition IDs to be assigned to the Managed Identity that is created and associated with the policy assignment. Only required for Modify and DeployIfNotExists policy effects. e.g. [\'/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c\']. DEFAULT VALUE = []')
param policyAssignmentIdentityRoleDefinitionIds array = []

@description('Set Parameter to true to Opt-out of deployment telemetry')
param telemetryOptOut bool = false

var policyAssignmentParametersMerged = union(policyAssignmentParameters, policyAssignmentParameterOverrides)

var policyIdentity = policyAssignmentIdentityType == 'SystemAssigned' ? 'SystemAssigned' : 'None'

var policyAssignmentIdentityRoleAssignmentsMGsConverged = policyAssignmentIdentityType == 'SystemAssigned' ? union(policyAssignmentIdentityRoleAssignmentsAdditionalMGs, (array(managementGroup().name))) : []

// Customer Usage Attribution Id
var cuaid = '78001e36-9738-429c-a343-45cc84e8a527'

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
  name: policyAssignmentName
  properties: {
    displayName: policyAssignmentDisplayName
    description: policyAssignmentDescription
    metadata: policyAssignmentMetaData
    policyDefinitionId: policyAssignmentDefinitionId
    parameters: policyAssignmentParametersMerged
    nonComplianceMessages: policyAssignmentNonComplianceMessages
    notScopes: policyAssignmentNotScopes
    enforcementMode: policyAssignmentEnforcementMode
    overrides: policyAssignmentOverrides
    resourceSelectors: policyAssignmentResourceSelectors
  }
  identity: {
    type: policyIdentity
  }
  #disable-next-line no-loc-expr-outside-params //Policies resources are not deployed to a region, like other resources, but the metadata is stored in a region hence requiring this to keep input parameters reduced. See <https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function/> for more information
  location: deployment().location
}

// Handle Managed Identity RBAC Assignments to Management Group scopes based on parameter inputs, if they are not empty and a policy assignment with an identity is required.
module policyIdentityRoleAssignmentMGsMany '../../roleAssignments/roleAssignmentManagementGroupMany.bicep' = [for roles in policyAssignmentIdentityRoleDefinitionIds: if ((policyIdentity == 'SystemAssigned') && !empty(policyAssignmentIdentityRoleDefinitionIds)) {
  name: 'rbac-assign-mg-policy-${policyAssignmentName}-${uniqueString(policyAssignmentName, roles)}'
  params: {
    managementGroupIds: policyAssignmentIdentityRoleAssignmentsMGsConverged
    assigneeObjectId: policyAssignment.identity.principalId
    assigneePrincipalType: 'ServicePrincipal'
    roleDefinitionId: roles
  }
}]

// Handle Managed Identity RBAC Assignments to Subscription scopes based on parameter inputs, if they are not empty and a policy assignment with an identity is required.
module policyIdentityRoleAssignmentSubsMany '../../roleAssignments/roleAssignmentSubscriptionMany.bicep' = [for roles in policyAssignmentIdentityRoleDefinitionIds: if ((policyIdentity == 'SystemAssigned') && !empty(policyAssignmentIdentityRoleDefinitionIds) && !empty(policyAssignmentIdentityRoleAssignmentsSubs)) {
  name: 'rbac-assign-sub-policy-${policyAssignmentName}-${uniqueString(policyAssignmentName, roles)}'
  params: {
    subscriptionIds: policyAssignmentIdentityRoleAssignmentsSubs
    assigneeObjectId: policyAssignment.identity.principalId
    assigneePrincipalType: 'ServicePrincipal'
    roleDefinitionId: roles
  }
}]

// Handle Managed Identity RBAC Assignments to Resource Group scopes based on parameter inputs, if they are not empty and a policy assignment with an identity is required.
module policyIdentityRoleAssignmentResourceGroupMany '../../roleAssignments/roleAssignmentResourceGroupMany.bicep' = [for roles in policyAssignmentIdentityRoleDefinitionIds: if ((policyIdentity == 'SystemAssigned') && !empty(policyAssignmentIdentityRoleDefinitionIds) && !empty(policyAssignmentIdentityRoleAssignmentsResourceGroups)) {
  name: 'rbac-assign-rg-policy-${policyAssignmentName}-${uniqueString(policyAssignmentName, roles)}'
  params: {
    resourceGroupIds: policyAssignmentIdentityRoleAssignmentsResourceGroups
    assigneeObjectId: policyAssignment.identity.principalId
    assigneePrincipalType: 'ServicePrincipal'
    roleDefinitionId: roles
  }
}]

// Optional Deployment for Customer Usage Attribution
module customerUsageAttribution '../../CARML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${cuaid}-${uniqueString(deployment().location, policyAssignmentName)}'
  params: {}
}

