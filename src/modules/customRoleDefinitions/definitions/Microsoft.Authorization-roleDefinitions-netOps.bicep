targetScope = 'managementGroup'

@description('The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.')
param assignableScopeManagementGroupId string = ''

var role = {
  name: '[${managementGroup().name}] Network Operations (NetOps)'
  description: 'Platform-wide global connectivity management: Virtual networks, UDRs, NSGs, NVAs, VPN, Azure ExpressRoute, and others'
}

// Resource: Role Definition
resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(role.name, assignableScopeManagementGroupId)
  properties: {
    roleName: role.name
    description: role.description
    permissions: [
      {
        actions: [
          '*/read'
          'Microsoft.Authorization/*/read'
          'Microsoft.Insights/alertRules/*'
          'Microsoft.Network/*'
          'Microsoft.ResourceHealth/availabilityStatuses/read'
          'Microsoft.Resources/deployments/*'
          'Microsoft.Resources/subscriptions/resourceGroups/read'
          'Microsoft.Support/*'
        ]
        notActions: []
        dataActions: []
        notDataActions: []
      }
    ]
    assignableScopes: [
      tenantResourceId('Microsoft.Management/managementGroups', assignableScopeManagementGroupId)
    ]
  }
}

output roleDefinitionId string = roleDefinition.id
