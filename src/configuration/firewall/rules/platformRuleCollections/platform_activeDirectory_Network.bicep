var resourceGroupName = resourceGroup().name
var subscriptionId = subscription().subscriptionId

var resourceIdFoIPGroups = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Network/ipGroups/'

var ipGroups = {
  azureSupernet: '${resourceIdFoIPGroups}ipg-azureSupernet'
  onPremisesADDS: '${resourceIdFoIPGroups}ipg-onPremisesADDS'
  azureADDS: '${resourceIdFoIPGroups}ipg-azureADDS'
}

@export()
var platform_activeDirectory_network = {
  name: 'platform_activeDirectory_network'
  priority: 105
  ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
  action: {
    type: 'Allow'
  }
  rules: [
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azureSupernet-TO-azureADDS'
      description: 'Allow traffic from AzureSupernet to the Azure Active Directory Domain Services (ADDS) virtual machines on multiple ports.'
      ipProtocols: [
        'Any'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationAddresses: [
        ipGroups.azureADDS
      ]
      destinationIpGroups: []
      destinationFqdns: []
      destinationPorts: [
        '53'
        '88'
        '123'
        '135'
        '137-139'
        '389'
        '445'
        '464'
        '636'
        '3268'
        '3269'
        '5722'
        '9389'
        '49152-65535'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azureADDS-TO-azureSupernet'
      description: 'Allow traffic from Azure Active Directory Domain Services (ADDS) virtual machines to the AzureSupernet on multiple ports.'
      ipProtocols: [
        'Any'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureADDS
      ]
      destinationAddresses: []
      destinationIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationFqdns: []
      destinationPorts: [
        '53'
        '88'
        '123'
        '135'
        '137-139'
        '389'
        '445'
        '464'
        '636'
        '3268'
        '3269'
        '5722'
        '9389'
        '49152-65535'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azureSupernet-TO-onPremisesADDS'
      description: 'Allow traffic from the AzureSupernet to the On-Premises Active Directory Domain Services (ADDS) virtual machines on multiple ports.'
      ipProtocols: [
        'Any'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationAddresses: []
      destinationIpGroups: [
        ipGroups.onPremisesADDS
      ]
      destinationFqdns: []
      destinationPorts: [
        '53'
        '88'
        '123'
        '135'
        '137-139'
        '389'
        '445'
        '464'
        '636'
        '3268'
        '3269'
        '5722'
        '9389'
        '49152-65535'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-onPremisesADDS-TO-azureSupernet'
      description: 'Allow traffic from On-Premises Active Directory Domain Services (ADDS) virtual machines to the AzureSupernet on multiple ports.'
      ipProtocols: [
        'Any'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.onPremisesADDS
      ]
      destinationAddresses: []
      destinationIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationFqdns: []
      destinationPorts: [
        '53'
        '88'
        '123'
        '135'
        '137-139'
        '389'
        '445'
        '464'
        '636'
        '3268'
        '3269'
        '5722'
        '9389'
        '49152-65535'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-onPremisesADDS-TO-azureADDS'
      description: 'Allow traffic from On-Premises Active Directory Domain Services (ADDS) virtual machines to Azure Active Directory Domain Services (ADDS) virtual machines on multiple ports.'
      ipProtocols: [
        'Any'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.onPremisesADDS
      ]
      destinationAddresses: []
      destinationIpGroups: [
        ipGroups.azureADDS
      ]
      destinationFqdns: []
      destinationPorts: [
        '53'
        '88'
        '123'
        '135'
        '137-139'
        '389'
        '445'
        '464'
        '636'
        '3268'
        '3269'
        '5722'
        '9389'
        '49152-65535'
      ]
    }
  ]
}
