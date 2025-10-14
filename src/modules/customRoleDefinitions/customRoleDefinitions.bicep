targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Custom Role Definitions'
metadata description = 'Custom Role Definitions for Azure Landing Zones'
metadata version = '1.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Required. The management group scope to which the role can be assigned. This management group ID will be used for the assignableScopes property in the role definition.')
param assignableScopeManagementGroupId string = 'alz'

@description('Optional. Set Parameter to true to Opt-out of deployment telemetry. Default: false')
param telemetryOptOut bool = false

// Customer Usage Attribution Id
var cuaid = '032d0904-3d50-45ef-a6c1-baa9d82e23ff'

// Subscription Owner Role Definition
module subscriptionOwnerRole './definitions/Microsoft.Authorization-roleDefinitions-subscriptionOwner.bicep' = {
  name: 'deploy-subscription-owner-role'
  params: {
    assignableScopeManagementGroupId: assignableScopeManagementGroupId
  }
}

// Subscription Owner Service Principal Role Definition
module subscriptionOwnerSPNRole './definitions/Microsoft.Authorization-roleDefinitions-subscriptionOwnerSPN.bicep' = {
  name: 'deploy-subscription-owner-spn-role'
  params: {
    assignableScopeManagementGroupId: assignableScopeManagementGroupId
  }
}

// Application / DevOps Role Definition
module appOpsRole './definitions/Microsoft.Authorization-roleDefinitions-appOps.bicep' = {
  name: 'deploy-app-devops-role'
  params: {
    assignableScopeManagementGroupId: assignableScopeManagementGroupId
  }
}

// Network Operator Role Definition
module netOpsRole './definitions/Microsoft.Authorization-roleDefinitions-netOps.bicep' = {
  name: 'deploy-net-operator-role'
  params: {
    assignableScopeManagementGroupId: assignableScopeManagementGroupId
  }
}

// Deployments Role Definition
module deploymentsRole './definitions/Microsoft.Authorization-roleDefinitions-deployments.bicep' = {
  name: 'deploy-deployments-role'
  params: {
    assignableScopeManagementGroupId: assignableScopeManagementGroupId
  }
}

// Security Operator Role Definition
module secOpsRole './definitions/Microsoft.Authorization-roleDefinitions-secOps.bicep' = {
  name: 'deploy-sec-operator-role'
  params: {
    assignableScopeManagementGroupId: assignableScopeManagementGroupId
  }
}

// Platform Operator Role Definition
module platformOpsRole './definitions/Microsoft.Authorization-roleDefinitions-platformOps.bicep' = {
  name: 'deploy-platform-operator-role'
  params: {
    assignableScopeManagementGroupId: assignableScopeManagementGroupId
  }
}

// virtual Machine Operator Role Definition
module vmOpsRole './definitions/Microsoft.Authorization-roleDefinitions-virtualMachineOps.bicep' = {
  name: 'deploy-virtual-machine-operator-role'
  params: {
    assignableScopeManagementGroupId: assignableScopeManagementGroupId
  }
}

// Optional Deployment for Customer Usage Attribution
module CustomerUsageAttribution '../CARML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${cuaid}-${uniqueString(deployment().location)}'
  params: {}
}

// Outputs
output subcriptionOwnerRoleId string = subscriptionOwnerRole.outputs.roleDefinitionId
output subcriptionOwnerSPNRoleId string = subscriptionOwnerSPNRole.outputs.roleDefinitionId
output applicationOperatorRoleId string = appOpsRole.outputs.roleDefinitionId
output networkOperatorRoleId string = netOpsRole.outputs.roleDefinitionId
output securirtyOperatorRoleId string = secOpsRole.outputs.roleDefinitionId
output platformOperatorRoleId string = platformOpsRole.outputs.roleDefinitionId
output virtualMachineOperatorRoleId string = vmOpsRole.outputs.roleDefinitionId
output deploymentsRoleId string = deploymentsRole.outputs.roleDefinitionId
