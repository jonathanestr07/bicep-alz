targetScope = 'managementGroup'

@description('The management group scope to which the role can be assigned.  This management group ID will be used for the assignableScopes property in the role definition.')
param assignableScopeManagementGroupId string = ''

var role = {
  name: '[${managementGroup().name}] Subscription Owner Service Principal'
  description: 'A custom Role Definition for a Landing Zone / Subscription Service Principal that has the same RBAC permissions as the Contributor role, except for notActions on key networking resources.'
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
          '*'
        ]
        notActions: [
          'Microsoft.Authorization/elevateAccess/action'
          'Microsoft.Authorization/classicAdministrators/write'
          'Microsoft.Authorization/classicAdministrators/delete'
          'Microsoft.Authorization/denyAssignments/write'
          'Microsoft.Authorization/denyAssignments/delete'
          'Microsoft.Authorization/diagnosticSettings/write'
          'Microsoft.Authorization/diagnosticSettings/delete'
          'Microsoft.Authorization/policies/audit/action'
          'Microsoft.Authorization/policies/auditIfNotExists/action'
          'Microsoft.Authorization/policies/deny/action'
          'Microsoft.Authorization/policies/deployIfNotExists/action'
          'Microsoft.Authorization/policyAssignments/write'
          'Microsoft.Authorization/policyAssignments/delete'
          'Microsoft.Authorization/policyAssignments/exempt/action'
          'Microsoft.Authorization/policyAssignments/privateLinkAssociations/write'
          'Microsoft.Authorization/policyAssignments/privateLinkAssociations/delete'
          'Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/write'
          'Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/delete'
          'Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnectionProxies/write'
          'Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnectionProxies/delete'
          'Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnectionProxies/validate/action'
          'Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnections/write'
          'Microsoft.Authorization/policyAssignments/resourceManagementPrivateLinks/privateEndpointConnections/delete'
          'Microsoft.Authorization/policyDefinitions/write'
          'Microsoft.Authorization/policyDefinitions/delete'
          'Microsoft.Authorization/policyExemptions/write'
          'Microsoft.Authorization/policyExemptions/delete'
          'Microsoft.Authorization/policySetDefinitions/write'
          'Microsoft.Authorization/policySetDefinitions/delete'
          'Microsoft.Authorization/roleDefinitions/write'
          'Microsoft.Authorization/roleDefinitions/delete'
          'Microsoft.Authorization/roleEligibilityScheduleRequests/write'
          'Microsoft.Authorization/roleEligibilityScheduleRequests/cancel/action'
          'Microsoft.Authorization/roleManagementPolicies/write'
          'Microsoft.Network/vpnGateways/*'
          'Microsoft.Network/expressRouteCircuits/*'
          'Microsoft.Network/routeTables/write'
          'Microsoft.Network/routeTables/join/*'
          'Microsoft.Network/routeTables/delete'
          'Microsoft.Network/routeTables/routes/write'
          'Microsoft.Network/azurefirewalls/write'
          'Microsoft.Network/azurefirewalls/delete'
          'Microsoft.Network/firewallPolicies/write'
          'Microsoft.Network/firewallPolicies/join/action'
          'Microsoft.Network/firewallPolicies/delete'
          'Microsoft.Network/firewallPolicies/ruleGroups/write'
          'Microsoft.Network/firewallPolicies/ruleGroups/delete'
          'Microsoft.Network/vpnSites/*'
          'Microsoft.Network/applicationGateways/*'
          'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/*'
          'Microsoft.Network/networkSecurityGroups/securityRules/write'
          'Microsoft.Network/networkSecurityGroups/securityRules/delete'
          'Microsoft.Network/networkSecurityGroups/delete'
          'Microsoft.Network/networkSecurityGroups/write'
          'Microsoft.Network/virtualNetworks/joinLoadBalancer/action'
          'Microsoft.Network/virtualNetworks/peer/action'
          'Microsoft.Network/virtualNetworks/BastionHosts/action'
          'Microsoft.Network/virtualNetworks/listNetworkManagerEffectiveConnectivityConfigurations/action'
          'Microsoft.Network/virtualNetworks/listNetworkManagerEffectiveSecurityAdminRules/action'
          'Microsoft.Network/virtualNetworks/bastionHosts/default/action'
          'Microsoft.Network/virtualNetworks/customViews/get/action'
          'Microsoft.Network/virtualNetworks/providers/Microsoft.Insights/diagnosticSettings/write'
          'Microsoft.Network/virtualNetworks/remoteVirtualNetworkPeeringProxies/write'
          'Microsoft.Network/virtualNetworks/remoteVirtualNetworkPeeringProxies/delete'
          'Microsoft.Network/virtualNetworks/subnets/contextualServiceEndpointPolicies/write'
          'Microsoft.Network/virtualNetworks/subnets/contextualServiceEndpointPolicies/delete'
          'Microsoft.Network/virtualNetworks/subnets/resourceNavigationLinks/write'
          'Microsoft.Network/virtualNetworks/subnets/resourceNavigationLinks/delete'
          'Microsoft.Network/virtualNetworks/subnets/serviceAssociationLinks/write'
          'Microsoft.Network/virtualNetworks/subnets/serviceAssociationLinks/delete'
          'Microsoft.Network/virtualNetworks/subnets/serviceAssociationLinks/validate/action'
          'Microsoft.Network/virtualNetworks/subnets/serviceAssociationLinks/details/read'
          'Microsoft.Network/virtualNetworks/taggedTrafficConsumers/write'
          'Microsoft.Network/virtualNetworks/taggedTrafficConsumers/delete'
          'Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write'
          'Microsoft.Network/virtualNetworks/virtualNetworkPeerings/delete'
        ]
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
