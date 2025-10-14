targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to Subscriptions'
metadata description = 'Module used to assign a Role Assignment to multiple Subscriptions'
metadata author = 'Insight APAC Platform Engineering'

@description('A list of subscription IDs that will be used for role assignment.')
param subscriptionIds array = []

@description('Role Definition Id (i.e. GUID, Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)')
param roleDefinitionId string = ''

@description('Principal type of the assignee. Allowed values are \'Group\' (Security Group) or \'ServicePrincipal\' (Service Principal or System/User Assigned Managed Identity).')
@allowed([
  'Group'
  'ServicePrincipal'
])
param assigneePrincipalType string = 'Group'

@description('Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID.')
param assigneeObjectId string = ''

module roleAssignment 'roleAssignmentSubscription.bicep' = [for subscriptionId in subscriptionIds: {
  name: 'rbac-assign-${uniqueString(subscriptionId, assigneeObjectId, roleDefinitionId)}'
  scope: subscription(subscriptionId)
  params: {
    roleAssignmentNameGuid: guid(subscriptionId, roleDefinitionId, assigneeObjectId)
    assigneeObjectId: assigneeObjectId
    assigneePrincipalType: assigneePrincipalType
    roleDefinitionId: roleDefinitionId
  }
}]
