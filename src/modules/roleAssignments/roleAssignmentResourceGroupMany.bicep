targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to Resource Groups'
metadata description = 'Module used to assign a Role Assignment to multiple Resource Groups'
metadata author = 'Insight APAC Platform Engineering'

@description('A list of Resource Groups that will be used for role assignment in the format of subscriptionId/resourceGroupName (i.e. a1fe8a74-e0ac-478b-97ea-24a27958961b/rg01).')
param resourceGroupIds array = []

@description('Role Definition Id (i.e. GUID, Reader Role Definition ID:  acdd72a7-3385-48ef-bd42-f606fba81ae7)')
param roleDefinitionId string = ''

@description('Principal type of the assignee.  Allowed values are \'Group\' (Security Group) or \'ServicePrincipal\' (Service Principal or System/User Assigned Managed Identity)')
@allowed([
  'Group'
  'ServicePrincipal'
])
param assigneePrincipalType string

@description('Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID')
param assigneeObjectId string = ''

@description('Set Parameter to true to Opt-out of deployment telemetry')
param telemetryOptOut bool = false

module roleAssignment 'roleAssignmentResourceGroup.bicep' = [for resourceGroupId in resourceGroupIds: {
  name: 'rbac-assign-${uniqueString(resourceGroupId, assigneeObjectId, roleDefinitionId)}'
  scope: resourceGroup(split(resourceGroupId, '/')[0], split(resourceGroupId, '/')[1])
  params: {
    roleAssignmentNameGuid: guid(resourceGroupId, roleDefinitionId, assigneeObjectId)
    assigneeObjectId: assigneeObjectId
    assigneePrincipalType: assigneePrincipalType
    roleDefinitionId: roleDefinitionId
    telemetryOptOut: telemetryOptOut
  }
}]
