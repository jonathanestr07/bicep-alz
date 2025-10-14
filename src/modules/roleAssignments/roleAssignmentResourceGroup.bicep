metadata name = 'ALZ Bicep - Role Assignment to a Resource Group'
metadata description = 'Module used to assign a Role Assignment to a Resource Group'
metadata author = 'Insight APAC Platform Engineering'

@description('A GUID representing the role assignment name.')
param roleAssignmentNameGuid string = guid(resourceGroup().id, roleDefinitionId, assigneeObjectId)

@description('Role Definition Id (i.e. GUID, Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7)')
param roleDefinitionId string = ''

@description('Principal type of the assignee. Allowed values are \'Group\' (Security Group) or \'ServicePrincipal\' (Service Principal or System/User Assigned Managed Identity)')
@allowed([
  'Group'
  'ServicePrincipal'
])
param assigneePrincipalType string = 'Group'

@description('Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID')
param assigneeObjectId string = ''

@description('Set Parameter to true to Opt-out of deployment telemetry.')
param telemetryOptOut bool = false

@description('Optional. Condition to apply to the role assignment.')
param condition string = ''

// Customer Usage Attribution Id
var cuaid = '59c2ac61-cd36-413b-b999-86a3e0d958fb'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentNameGuid
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: assigneeObjectId
    principalType: assigneePrincipalType
    condition: !empty(condition) ? condition : null
    conditionVersion: !empty(condition) ? '2.0' : null
  }
}

// Optional Deployment for Customer Usage Attribution
module customerUsageAttribution '../CARML/customerUsageAttribution/cuaIdSubscription.bicep' = if (!telemetryOptOut) {
  name: 'pid-${cuaid}-${uniqueString(resourceGroup().id, assigneeObjectId)}'
  params: {}
  scope: subscription()
}
