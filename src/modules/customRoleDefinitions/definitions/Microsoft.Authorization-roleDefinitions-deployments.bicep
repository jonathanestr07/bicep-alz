targetScope = 'managementGroup'

@description('The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.')
param assignableScopeManagementGroupId string = ''

var role = {
  name: '[${managementGroup().name}] Deployments'
  description: 'Microsoft Resources Deployments role for the service principals, users and groups to initiate deployments. Use this role with other roles like Network Contributor to deploy resources to explicit resources with automation and CI/CD tooling.'
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
          'Microsoft.Authorization/*/read'
          'Microsoft.Resources/deployments/*'
          'Microsoft.Resources/subscriptions/resourceGroups/read'
          'Microsoft.Support/*'
          'Microsoft.Insights/ActionGroups/*'
          'Microsoft.Insights/ActivityLogAlerts/*'
          'Microsoft.Insights/MetricAlerts/*'
          'Microsoft.Insights/ScheduledQueryRules/*'
          'Microsoft.Insights/diagnosticSettings/*'
          'Microsoft.OperationalInsights/workspaces/sharedKeys/action'
          // The actions below can be uncommented here if you don't plan to grant 'Network Contibutor' to the vNet in which Subscription Vending peering is made to/from
          // Recommendation is to grant 'Network Contributor' however and assign this role to the resource group where the vNet resides (two separate role assignments for the same service principals)
          //'Microsoft.Network/virtualNetworks/peer/action'
          //'Microsoft.Network/virtualNetworks/virtualNetworkPeerings/*'
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
