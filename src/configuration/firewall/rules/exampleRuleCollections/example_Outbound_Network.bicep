var resourceGroupName = resourceGroup().name
var subscriptionId = subscription().subscriptionId

var resourceIdFoIPGroups = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Network/ipGroups/'

var ipGroups = {
  azureSupernet: '${resourceIdFoIPGroups}ipg-azureSupernet'
  azurePlatMgmtJumpHost: '${resourceIdFoIPGroups}ipg-azurePlatMgmtJumpHost'
  exampleEdge: '${resourceIdFoIPGroups}ipg-example-Edge'
  exampleAuthentication: '${resourceIdFoIPGroups}ipg-example-authentication'
  exampleAll: '${resourceIdFoIPGroups}ipg-example-All'
}

@export()
var outbound_example_network = {
  name: 'outbound_example_network'
  priority: 1020
  ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
  action: {
    type: 'Allow'
  }
  rules: [
    // example Environment - Microsoft Container Registry
    {
      ruleType: 'NetworkRule'
      name: 'FROM-example-TO-MicrosoftContainerRegistry'
      description: 'Allow traffic from example to Microsoft Container Registry (MCR) using service tags.'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.exampleAll
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
      destinationAddresses: [
        'MicrosoftContainerRegistry'
        'AzureFrontDoorFirstParty'
      ]
    }
    // example Environment - Azure Container Registry
    {
      ruleType: 'NetworkRule'
      name: 'FROM-example-TO-ContainerRegistry'
      description: 'Allow traffic from example to Azure Container Registry (ACR) using service tags.'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.exampleAll
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
      destinationAddresses: [
        'AzureContainerRegistry'
        'AzureActiveDirectory'
      ]
    }
    // example Environment - Azure Key Vault
    {
      ruleType: 'NetworkRule'
      name: 'FROM-example-TO-AzureKeyVault'
      description: 'Allow traffic from example to Azure Key Vault using service tags.'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.exampleAll
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
      destinationAddresses: [
        'AzureKeyVault'
        'AzureActiveDirectory'
      ]
    }
    // example Environment - Managed Identity
    {
      ruleType: 'NetworkRule'
      name: 'FROM-example-TO-ManagedIdentity'
      description: 'Allow traffic from example to Managed Identity using service tags.'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.exampleAll
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
      destinationAddresses: [
        'AzureActiveDirectory'
      ]
    }
  ]
}
