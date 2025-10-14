targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Role Assignment to a Management Group Loop'
metadata description = 'Module used to assign a roles to Management Group'
metadata author = 'Insight APAC Platform Engineering'

@description('Array of roles to assign to the management group.')
param roles array = [
  {
    roleDefinitionId: 'f21b586c-4dc0-5ea6-837b-101fd01291a4'
    assigneePrincipalType: 'Group'
    assigneeObjectId: '8fa2171b-c94f-498a-a71f-e46675590e4b'
  }
]

@description('Optional. Set Parameter to true to Opt-out of deployment telemetry.')
param telemetryOptOut bool = true

// Customer Usage Attribution Id
var cuaid = '59c2ac61-cd36-413b-b999-86a3e0d958fb'

// Resource: Role Assignment
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for role in roles: {
    name: guid(managementGroup().name, role.roleDefinitionId, role.assigneeObjectId)
    properties: {
      roleDefinitionId: tenantResourceId('Microsoft.Authorization/roleDefinitions', role.roleDefinitionId)
      principalId: role.assigneeObjectId
      principalType: role.assigneePrincipalType
    }
  }
]

// Module: Customer Usage Attribution
module customerUsageAttribution '../CARML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${cuaid}-${uniqueString(deployment().location)}'
  params: {}
}
