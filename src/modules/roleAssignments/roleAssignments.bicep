targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to a Management Group Loop'
metadata description = 'Module used to assign a roles to Management Group'
metadata author = 'Insight APAC Platform Engineering'

@description('Array of roles to assign to the management group.')
param rolesManagementGroup array = []

@description('Array of roles to assign to the subscription.')
param roleSubscriptions array = []

@description('Array of roles to assign to the resource group.')
param roleResourceGroup array = []

@description('Array of roles to assign to the resource.')
param roleResource array = []

@description('Optional. Set Parameter to true to Opt-out of deployment telemetry.')
param telemetryOptOut bool = true

// Customer Usage Attribution Id
var cuaid = '59c2ac61-cd36-413b-b999-86a3e0d958fb'

// Resource: Role Assignment - Management Group Loop
module roleAssignmentManagementGroup './roleAssignmentManagementGroup.bicep' = [
  for role in rolesManagementGroup: {
    name: 'deployMGRole-${guid(role.managementGroupId, role.roleDefinitionId, role.assigneeObjectId)}'
    scope: managementGroup(role.managementGroupId)
    params: {
      roleDefinitionId: role.roleDefinitionId
      assigneeObjectId: role.assigneeObjectId
      assigneePrincipalType: role.assigneePrincipalType
      condition: role.?condition ?? ''
      telemetryOptOut: telemetryOptOut
    }
  }
]

// Module: Role Assignment - Subscription Loop
module roleAssignmentsSubscription './roleAssignmentSubscription.bicep' = [
  for role in roleSubscriptions: {
    name: 'deploySUBRole-${guid(role.subscriptionId, role.roleDefinitionId, role.assigneeObjectId)}'
    scope: subscription(role.subscriptionId)
    params: {
      roleDefinitionId: role.roleDefinitionId
      assigneePrincipalType: role.assigneePrincipalType
      assigneeObjectId: role.assigneeObjectId
      condition: role.?condition ?? ''
      telemetryOptOut: telemetryOptOut
    }
  }
]

// Module: Role Assignment - Resource Group Loop
module roleAssignmentsResourceGroup './roleAssignmentResourceGroup.bicep' = [
  for role in roleResourceGroup: {
    name: 'deployARGRole-${guid(role.resourceGroupName, role.roleDefinitionId, role.assigneeObjectId)}'
    scope: resourceGroup(role.subscriptionId, role.resourceGroupName)
    params: {
      roleDefinitionId: role.roleDefinitionId
      assigneePrincipalType: role.assigneePrincipalType
      assigneeObjectId: role.assigneeObjectId
      condition: role.?condition ?? ''
      telemetryOptOut: telemetryOptOut
    }
  }
]

module resourceRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = [
  for role in roleResource: {
    scope: resourceGroup(role.subscriptionId, role.resourceGroupName)
    name: 'deployRole-${guid(role.subscriptionId, role.resourceGroupName, role.assigneeObjectId, role.resourceId)}'
    params: {
      principalId: role.assigneeObjectId
      principalType: role.assigneePrincipalType
      resourceId: role.resourceId
      roleDefinitionId: role.roleDefinitionId
    }
  }
]

// Module: Customer Usage Attribution
module customerUsageAttribution '../CARML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${cuaid}-${uniqueString(deployment().location)}'
  params: {}
}
