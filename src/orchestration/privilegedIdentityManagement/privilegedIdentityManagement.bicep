targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Privileged Identity Management'
metadata description = 'Deploys a roleEligibilityScheduleRequests resource for Azure PIM with optional conditions and ticket info.'
metadata version = '1.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Array of PIM assignments for the resource group level. Uses the resource group name for the scope.')
param pimAssignmentsResourceGroup array = []

@description('Array of PIM assignments for the subscription level. Uses the subscription ID for the scope.')
param pimAssignmentsSubscription array = []

@description('Array of PIM assignments for the tenant level.')
param pimAssignmentsTenant array = []

@description('Array of PIM assignments for the management group level. Uses the management group ID for the scope.')
param pimAssignmentsManagementGroup array = []

module pimAssignmentsDeployResourceGroup '../../modules/privilegedIdentityManagement/pimResourceGroup.bicep' = [
  for assignment in pimAssignmentsResourceGroup: {
    name: take(
      'pimAssignment-rg-${guid(assignment.subscriptionId, assignment.resourceGroup, assignment.principalId, assignment.roleDefinitionId)}',
      64
    )
    scope: resourceGroup(assignment.subscriptionId, assignment.resourceGroup)
    params: {
      principalId: assignment.principalId
      roleDefinitionId: assignment.roleDefinitionId
      duration: assignment.duration
      endDateTime: assignment.?endDateTime ?? ''
      expirationType: assignment.expirationType
      justification: assignment.justification
      requestType: assignment.requestType
      targetRoleEligibilityScheduleId: assignment.?targetRoleEligibilityScheduleId ?? null
      targetRoleEligibilityScheduleInstanceId: assignment.?targetRoleEligibilityScheduleInstanceId ?? null
      ticketNumber: assignment.?ticketNumber ?? null
      ticketSystem: assignment.?ticketSystem ?? null
      condition: assignment.?condition ?? null
      deploymentSeedRandom: (assignment.requestType == 'AdminAssign') ? false : true
    }
  }
]

module pimAssignmentsDeploySubscription '../../modules/privilegedIdentityManagement/pimSubscription.bicep' = [
  for subscriptionAssignment in pimAssignmentsSubscription: {
    name: take(
      'pimAssignment-sub-${guid(subscriptionAssignment.subscriptionId, subscriptionAssignment.principalId, subscriptionAssignment.roleDefinitionId)}',
      64
    )
    scope: subscription(subscriptionAssignment.subscriptionId)
    params: {
      principalId: subscriptionAssignment.principalId
      roleDefinitionId: subscriptionAssignment.roleDefinitionId
      duration: subscriptionAssignment.duration
      endDateTime: subscriptionAssignment.?endDateTime ?? ''
      expirationType: subscriptionAssignment.expirationType
      justification: subscriptionAssignment.justification
      requestType: subscriptionAssignment.requestType
      targetRoleEligibilityScheduleId: subscriptionAssignment.?targetRoleEligibilityScheduleId ?? null
      targetRoleEligibilityScheduleInstanceId: subscriptionAssignment.?targetRoleEligibilityScheduleInstanceId ?? null
      ticketNumber: subscriptionAssignment.?ticketNumber ?? null
      ticketSystem: subscriptionAssignment.?ticketSystem ?? null
      condition: subscriptionAssignment.?condition ?? null
      deploymentSeedRandom: (subscriptionAssignment.requestType == 'AdminAssign') ? false : true
    }
  }
]

module pimAssignmentsDeployManagementGroup '../../modules/privilegedIdentityManagement/pimManagementGroup.bicep' = [
  for managementGroupAssignment in pimAssignmentsManagementGroup: {
    name: take(
      'pimAssignment-mg-${guid(managementGroupAssignment.managementGroupId, managementGroupAssignment.principalId, managementGroupAssignment.roleDefinitionId)}',
      64
    )
    scope: managementGroup(managementGroupAssignment.managementGroupId)
    params: {
      principalId: managementGroupAssignment.principalId
      roleDefinitionId: managementGroupAssignment.roleDefinitionId
      duration: managementGroupAssignment.duration
      endDateTime: managementGroupAssignment.?endDateTime ?? ''
      expirationType: managementGroupAssignment.expirationType
      justification: managementGroupAssignment.justification
      requestType: managementGroupAssignment.requestType
      targetRoleEligibilityScheduleId: managementGroupAssignment.?targetRoleEligibilityScheduleId ?? null
      targetRoleEligibilityScheduleInstanceId: managementGroupAssignment.?targetRoleEligibilityScheduleInstanceId ?? null
      ticketNumber: managementGroupAssignment.?ticketNumber ?? null
      ticketSystem: managementGroupAssignment.?ticketSystem ?? null
      condition: managementGroupAssignment.?condition ?? null
      deploymentSeedRandom: (managementGroupAssignment.requestType == 'AdminAssign') ? false : true
    }
  }
]

module pimAssignmentsDeployTenant '../../modules/privilegedIdentityManagement/pimTenant.bicep' = [
  for tenantAssignment in pimAssignmentsTenant: {
    name: take('pimAssignment-tenant-${guid(tenantAssignment.principalId, tenantAssignment.roleDefinitionId)}', 64)
    scope: tenant()
    params: {
      principalId: tenantAssignment.principalId
      roleDefinitionId: tenantAssignment.roleDefinitionId
      duration: tenantAssignment.duration
      endDateTime: tenantAssignment.?endDateTime ?? ''
      expirationType: tenantAssignment.expirationType
      justification: tenantAssignment.justification
      requestType: tenantAssignment.requestType
      targetRoleEligibilityScheduleId: tenantAssignment.?targetRoleEligibilityScheduleId ?? null
      targetRoleEligibilityScheduleInstanceId: tenantAssignment.?targetRoleEligibilityScheduleInstanceId ?? null
      ticketNumber: tenantAssignment.?ticketNumber ?? null
      ticketSystem: tenantAssignment.?ticketSystem ?? null
      condition: tenantAssignment.?condition ?? null
      deploymentSeedRandom: (tenantAssignment.requestType == 'AdminAssign') ? false : true
    }
  }
]
