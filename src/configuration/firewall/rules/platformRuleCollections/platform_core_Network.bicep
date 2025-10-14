var resourceGroupName = resourceGroup().name
var subscriptionId = subscription().subscriptionId

var resourceIdFoIPGroups = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Network/ipGroups/'

var ipGroups = {
  azureSupernet: '${resourceIdFoIPGroups}ipg-azureSupernet'
}

@export()
var platform_core_network = {
  name: 'platform_core_network'
  priority: 101
  ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
  action: {
    type: 'allow'
  }
  rules: [
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azSuperNet-TO-azCloud.AustraliaEast'
      description: 'Allow traffic from the AzureSupernet to the Azure Management Control Plane.'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationAddresses: [
        'AzureCloud.AustraliaEast'
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azSuperNet-TO-microsoftEntra'
      description: 'Allow traffic from the AzureSupernet to the Microsoft Entra service.'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationAddresses: [
        'AzureActiveDirectory'
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azSuperNet-TO-azMonitor'
      description: 'Allow traffic from the AzureSupernet to the Azure Monitor service.'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationAddresses: [
        'AzureMonitor'
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azSuperNet-TO-microsoftDefenderForEndpoint'
      description: 'Allow traffic from the AzureSupernet to the Microsoft Defender For Endpoint service.'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationAddresses: [
        'MicrosoftDefenderForEndpoint'
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azSuperNet-TO-azArcInfrastructure'
      description: 'Allow traffic from the AzureSupernet to the Azure Arc service'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationAddresses: [
        'AzureArcInfrastructure'
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azSuperNet-TO-azServiceBus'
      description: 'Allow traffic from the AzureSupernet to the Azure ServiceBus service'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationAddresses: [
        'ServiceBus'
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azSuperNet-TO-powerBi'
      description: 'Allow traffic from the AzureSupernet to the PowerBi service'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationAddresses: [
        'PowerBI'
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azSuperNet-TO-azSuperNet'
      description: 'Allow traffic from the AzureSupernet to itself for ICMP network validation.'
      ipProtocols: [
        'ICMP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationAddresses: []
      destinationIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationFqdns: []
      destinationPorts: [
        '*'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azSuperNet-TO-azKMS'
      description: 'Allow traffic from AzureSupernet to the Azure KMS Service for activation of Windows OS.'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationAddresses: []
      destinationIpGroups: []
      destinationFqdns: [
        #disable-next-line no-hardcoded-env-urls
        'kms.core.windows.net'
        #disable-next-line no-hardcoded-env-urls
        'azkms.core.windows.net'
      ]
      destinationPorts: [
        '1688'
      ]
    }
  ]
}
