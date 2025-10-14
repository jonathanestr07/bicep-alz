var resourceGroupName = resourceGroup().name
var subscriptionId = subscription().subscriptionId

var resourceIdFoIPGroups = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Network/ipGroups/'

var ipGroups = {
  azurePlatMgmtJumpHost: '${resourceIdFoIPGroups}ipg-azurePlatMgmtJumpHost'
}

@export()
var platform_externalWeb_application = {
  name: 'platform_externalWeb_application'
  priority: 503
  ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
  action: {
    type: 'Allow'
  }
  rules: [
    {
      ruleType: 'ApplicationRule'
      name: 'FROM-azure-TO-internet'
      description: 'Allow traffic from various Azure locations to the Internet.'
      protocols: [
        {
          protocolType: 'Http'
          port: 80
        }
        {
          protocolType: 'Https'
          port: 443
        }
      ]
      fqdnTags: []
      webCategories: []
      targetFqdns: [
        '*'
      ]
      targetUrls: []
      terminateTLS: false
      sourceAddresses: []
      destinationAddresses: []
      sourceIpGroups: [
        ipGroups.azurePlatMgmtJumpHost
      ]
    }
  ]
}
