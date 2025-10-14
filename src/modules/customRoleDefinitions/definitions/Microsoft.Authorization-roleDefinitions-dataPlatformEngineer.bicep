targetScope = 'managementGroup'

@description('The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.')
param assignableScopeManagementGroupId string = ''

var role = {
  name: '[${managementGroup().name}] Data Platform Engineer'
  description: 'Contributor role granted for the Data Platform Engineer role'
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
          'Microsoft.DataFactory/dataFactories/*'
          'Microsoft.DataFactory/factories/*'
          'Microsoft.Insights/alertRules/*'
          'Microsoft.ResourceHealth/availabilityStatuses/read'
          'Microsoft.Resources/deployments/*'
          'Microsoft.Resources/subscriptions/resourceGroups/read'
          'Microsoft.Support/*'
          'Microsoft.EventGrid/eventSubscriptions/write'
          'Microsoft.KeyVault/checkNameAvailability/read'
          'Microsoft.KeyVault/deletedVaults/read'
          'Microsoft.KeyVault/locations/*/read'
          'Microsoft.KeyVault/vaults/*/read'
          'Microsoft.KeyVault/operations/read'
          'Microsoft.Storage/storageAccounts/blobServices/containers/delete'
          'Microsoft.Storage/storageAccounts/blobServices/containers/read'
          'Microsoft.Storage/storageAccounts/blobServices/containers/write'
          'Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action'
        ]
        notActions: []
        dataActions: [
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action'
          'Microsoft.KeyVault/vaults/secrets/*'
        ]
        notDataActions: []
      }
    ]
    assignableScopes: [
      tenantResourceId('Microsoft.Management/managementGroups', assignableScopeManagementGroupId)
    ]
  }
}

output roleDefinitionId string = roleDefinition.id
