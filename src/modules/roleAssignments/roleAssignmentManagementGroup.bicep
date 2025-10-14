targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to a Management Group'
metadata description = 'Module used to assign a role to Management Group'
metadata author = 'Insight APAC Platform Engineering'

@description('A GUID representing the role assignment name.')
param roleAssignmentNameGuid string = guid(managementGroup().name, roleDefinitionId, assigneeObjectId)

@description('Role Definition Id (i.e. GUID, Reader Role Definition ID: acdd72a7-3385-48ef-bd42-f606fba81ae7).')
param roleDefinitionId string = ''

@description('Principal type of the assignee. Allowed values are \'Group\' (Security Group) or \'ServicePrincipal\' (Service Principal or System/User Assigned Managed Identity)')
@allowed([
  'Group'
  'ServicePrincipal'
  'User'
])
param assigneePrincipalType string = 'Group'

@description('Object ID of groups, service principals or managed identities. For managed identities use the principal id. For service principals, use the object ID and not the app ID.')
param assigneeObjectId string = ''

@description('Optional. Set Parameter to true to Opt-out of deployment telemetry.')
param telemetryOptOut bool = true

@description('Optional. Condition to apply to the role assignment.')
param condition string = ''

// Customer Usage Attribution Id
var cuaid = '59c2ac61-cd36-413b-b999-86a3e0d958fb'

// Resource: Role Assignment
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentNameGuid
  properties: {
    roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: assigneeObjectId
    principalType: assigneePrincipalType
    condition: !empty(condition) ? condition : null
    conditionVersion: !empty(condition) ? '2.0' : null
  }
}

// Module: Customer Usage Attribution
module customerUsageAttribution '../CARML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${cuaid}-${uniqueString(deployment().location)}'
  params: {}
}
