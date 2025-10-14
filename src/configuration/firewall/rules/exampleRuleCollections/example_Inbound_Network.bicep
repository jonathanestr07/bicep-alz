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
var inbound_example_network = {
  name: 'inbound_example_network'
  priority: 1010
  ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
  action: {
    type: 'Allow'
  }
  rules: [
    // examples Environment
    // Kubernetes API
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azurePlatMgmtJumpHost-TO-exampleKubernetesAPI'
      description: 'Allow traffic from Azure Platform Management Jump Host to examples Kubernetes API on port 6443 (TCP).'
      ipProtocols: [
        'TCP'
      ]
      sourceAddresses: []
      sourceIpGroups: [
        ipGroups.azurePlatMgmtJumpHost
      ]
      destinationIpGroups: [
        ipGroups.exampleEdge
        ipGroups.exampleAuthentication
      ]
      destinationFqdns: []
      destinationPorts: [
        '6443'
      ]
    }
    // Kubernetes Ports
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azurePlatMgmtJumpHost-TO-exampleEdge'
      description: 'Allow inbound traffic from Azure Platform Management Jump Host to examples example with specific destination ports.'
      ipProtocols: [
        'TCP'
      ]
      sourceIpGroups: [
        ipGroups.azurePlatMgmtJumpHost
      ]
      destinationIpGroups: [
        ipGroups.exampleEdge
      ]
      destinationPorts: [
        '2379-2380' // etcd server client API ports
        '10250' // Kubelet API port
        '10259' // kube-scheduler port
        '10257' // kube-controller-manager port
        '10249-10256' // kube-proxy ports
        '30000-32767' // NodePort services ports for external access
        '10443'
        '11443'
        '20305'
      ]
    }
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azurePlatMgmtJumpHost-TO-exampleauthentication'
      description: 'Allow inbound traffic from Azure Platform Management Jump Host to examples authentication with specific destination ports.'
      ipProtocols: [
        'TCP'
      ]
      sourceIpGroups: [
        ipGroups.azurePlatMgmtJumpHost
      ]
      destinationIpGroups: [
        ipGroups.exampleAuthentication
      ]
      destinationPorts: [
        '2379-2380' // etcd server client API ports
        '10250' // Kubelet API port
        '10259' // kube-scheduler port
        '10257' // kube-controller-manager port
        '10249-10256' // kube-proxy ports
        '30000-32767' // NodePort services ports for external access
        '10443'
        '11443'
        '20305'
      ]
    }
    // HTTPS, includes privateEndpoints and GitHub Runners
    {
      ruleType: 'NetworkRule'
      name: 'FROM-azureSupernet-TO-exampleAll-443-HTTPS'
      description: 'Allow inbound traffic from Azure Supernet to examples on port 443 (HTTPS).'
      ipProtocols: [
        'TCP'
      ]
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
      destinationIpGroups: [
        ipGroups.exampleAll
      ]
      destinationPorts: [
        '443' // HTTPS port
      ]
    }
  ]
}
