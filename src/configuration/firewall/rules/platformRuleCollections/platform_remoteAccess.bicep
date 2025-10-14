var resourceGroupName = resourceGroup().name
var subscriptionId = subscription().subscriptionId

var resourceIdFoIPGroups = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Network/ipGroups/'

var ipGroups = {
  azureSupernet: '${resourceIdFoIPGroups}ipg-azureSupernet'
  azureBastion: '${resourceIdFoIPGroups}ipg-azureBastion'
  azurePlatMgmtJumpHost: '${resourceIdFoIPGroups}ipg-azurePlatMgmtJumpHost'
}

@export()
var platform_remoteAccess_network = {
  name: 'platform_remoteAccess_network'
  priority: 104
  ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
  action: {
    type: 'Allow'
  }
  rules: [
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azureBastion-TO-azurePlatMgmtJumpHosts'
      description: 'Allow traffic from the Azure Bastion Service to the Platform Management Landing Zone Jumphosts for RDP and SSH access.'
      ipProtocols: [
        'TCP'
        'UDP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureBastion
      ]
      destinationAddresses: []
      destinationIpGroups: [
        ipGroups.azurePlatMgmtJumpHost
      ]
      destinationFqdns: []
      destinationPorts: [
        '3389'
        '22'
      ]
    }
  ]
}
