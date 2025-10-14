var resourceGroupName = resourceGroup().name
var subscriptionId = subscription().subscriptionId

var resourceIdFoIPGroups = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Network/ipGroups/'

var ipGroups = {
  azureCentralRunners: '${resourceIdFoIPGroups}ipg-azureCentralRunners'
}

@export()
var platform_centralRunners_application = {
  name: 'platform_centralRunners_application'
  priority: 506
  ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
  action: {
    type: 'Allow'
  }
  rules: [
    {
      ruleType: 'ApplicationRule'
      name: 'FROM-azureCentralRunner-TO-google.com'
      description: 'Allow traffic from central runners to google.com URLs.'
      protocols: [
        {
          protocolType: 'Https'
          port: 443
        }
      ]
      targetFqdns: [
        'google.com'
        '*.google.com'
      ]
      sourceIpGroups: [
        ipGroups.azureCentralRunners
      ]
    }
    {
      ruleType: 'ApplicationRule'
      name: 'FROM-centralRunners-TO-ubuntu.com'
      description: 'Allow traffic from central runners to ubuntu.com URLS.'
      protocols: [
        {
          protocolType: 'Https'
          port: 443
        }
        {
          protocolType: 'Http'
          port: 80
        }
      ]
      targetFqdns: [
        'archive.ubuntu.com'
        'security.ubuntu.com'
      ]
      sourceIpGroups: [
        ipGroups.azureCentralRunners
      ]
    }
  ]
}
