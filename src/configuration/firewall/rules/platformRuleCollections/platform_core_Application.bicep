var resourceGroupName = resourceGroup().name
var subscriptionId = subscription().subscriptionId

var resourceIdFoIPGroups = '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Network/ipGroups/'

var ipGroups = {
  azureSupernet: '${resourceIdFoIPGroups}ipg-azureSupernet'
}

@export()
var platform_core_application = {
  name: 'platform_core_application'
  priority: 501
  ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
  action: {
    type: 'Allow'
  }
  rules: [
    {
      ruleType: 'ApplicationRule'
      name: 'FROM-azSupernet-TO-windowsUpdateService'
      description: 'Allow traffic from the AzureSupernet to the Windows Update Service.'
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
      fqdnTags: [
        'WindowsUpdate'
      ]
      webCategories: []
      targetFqdns: []
      targetUrls: []
      terminateTLS: false
      sourceAddresses: []
      destinationAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
    }
    {
      ruleType: 'ApplicationRule'
      name: 'FROM-azSupernet-TO-ubuntuUpdateService'
      description: 'Allow traffic from the AzureSupernet to the Ubuntu Update Service.'
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
        '*.security.ubuntu.com'
        '*.archive.ubuntu.com'
        'security.ubuntu.com'
        'archive.ubuntu.com'
      ]
      targetUrls: []
      terminateTLS: false
      sourceAddresses: []
      destinationAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
    }
    {
      ruleType: 'ApplicationRule'
      name: 'FROM-azSupernet-TO-azBackupService'
      description: 'Allow traffic from the AzureSupernet to the Azure Backup Service.'
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
      fqdnTags: [
        'AzureBackup'
      ]
      webCategories: []
      targetFqdns: []
      targetUrls: []
      terminateTLS: false
      sourceAddresses: []
      destinationAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
    }
    {
      ruleType: 'ApplicationRule'
      name: 'FROM-azSupernet-TO-windowsDiagnostics'
      description: 'Allow traffic from the AzureSupernet to the Windows Diagnostics Service.'
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
      fqdnTags: [
        'WindowsDiagnostics'
      ]
      webCategories: []
      targetFqdns: []
      targetUrls: []
      terminateTLS: false
      sourceAddresses: []
      destinationAddresses: []
      sourceIpGroups: [
        ipGroups.azureSupernet
      ]
    }
  ]
}
