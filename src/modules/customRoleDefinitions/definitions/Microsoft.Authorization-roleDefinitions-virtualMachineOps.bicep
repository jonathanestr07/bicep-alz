targetScope = 'managementGroup'

@description('The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.')
param assignableScopeManagementGroupId string = ''

var role = {
  name: '[${managementGroup().name}] VM Operator'
  description: 'Start and Stop Virtual Machines and reader access'
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
          'Microsoft.Compute/virtualMachines/read'
          'Microsoft.Compute/virtualMachines/start/action'
          'Microsoft.Compute/virtualMachines/restart/action'
          'Microsoft.Resources/subscriptions/resourceGroups/read'
          'Microsoft.Compute/virtualMachines/deallocate/action'
          'Microsoft.Compute/virtualMachineScaleSets/deallocate/action'
          'Microsoft.Compute/virtualMachineScaleSets/virtualMachines/deallocate/action'
          'Microsoft.Compute/virtualMachines/powerOff/action'
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
