targetScope = 'managementGroup'

@description('The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.')
param assignableScopeManagementGroupId string = ''

var role = {
  name: '[${managementGroup().name}] Security Operations (SecOps)'
  description: 'Security Operations role with a horizontal view across the entire Azure estate and the Azure Key Vault purge policy'
}

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(role.name, assignableScopeManagementGroupId)
  properties: {
    roleName: role.name
    description: role.description
    permissions: [
      {
        actions: [
          '*/read'
          '*/register/action'
          'Microsoft.KeyVault/locations/deletedVaults/purge/action'
          'Microsoft.PolicyInsights/*'
          'Microsoft.Authorization/*/read'
          'Microsoft.Authorization/policyAssignments/*'
          'Microsoft.Authorization/policyDefinitions/*'
          'Microsoft.Authorization/policyExemptions/*'
          'Microsoft.Authorization/policySetDefinitions/*'
          'Microsoft.Insights/alertRules/*'
          'Microsoft.Management/managementGroups/read'
          'Microsoft.operationalInsights/workspaces/*/read'
          'Microsoft.Resources/deployments/*'
          'Microsoft.Resources/subscriptions/resourceGroups/read'
          'Microsoft.Security/*'
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
