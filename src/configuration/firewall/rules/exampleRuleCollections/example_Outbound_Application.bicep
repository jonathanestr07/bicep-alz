var resourceGroupName = resourceGroup().name
var subscriptionId = subscription().subscriptionId

var resourceIdFoIPGroups = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Network/ipGroups/'

var ipGroups = {
  azureSupernet: '${resourceIdFoIPGroups}ipg-azureSupernet'
  azurePlatMgmtJumpHost: '${resourceIdFoIPGroups}ipg-azurePlatMgmtJumpHost'
  exampleEdge: '${resourceIdFoIPGroups}ipg-example-edge'
  exampleAuthentication: '${resourceIdFoIPGroups}ipg-example-authentication'
  exampleAll: '${resourceIdFoIPGroups}ipg-example-All'
}

@export()
var outbound_example_application = {
  name: 'outbound_example_application'
  priority: 1030
  ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
  action: {
    type: 'Allow'
  }
  rules: [
    // Example from platform to spoke
    {
      ruleType: 'ApplicationRule'
      name: 'FROM-example-All-TO-specificInternetHTTPS'
      description: 'Allow traffic from example to specific addresses required for AKS deployment and interoperability.'
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
        ipGroups.exampleAll
      ]
    }
    {
      ruleType: 'ApplicationRule'
      name: 'FROM-example-All-TO-specificInternetHTTPandHTTPS'
      description: 'Allow traffic from example to specific addresses required for AKS deployment and interoperability.'
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
        ipGroups.exampleAll
      ]
    }
  ]
}
