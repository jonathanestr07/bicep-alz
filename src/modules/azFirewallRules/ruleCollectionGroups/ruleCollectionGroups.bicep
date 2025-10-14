import { platform_activeDirectory_network } from '../../../configuration/firewall/rules/platformRuleCollections/platform_activeDirectory_Network.bicep'
import { platform_centralRunners_network } from '../../../configuration/firewall/rules/platformRuleCollections/platform_centralRunners_Network.bicep'
import { platform_centralRunners_application } from '../../../configuration/firewall/rules/platformRuleCollections/platform_centralRunners_Application.bicep'
import { platform_core_network } from '../../../configuration/firewall/rules/platformRuleCollections/platform_core_Network.bicep'
import { platform_core_application } from '../../../configuration/firewall/rules/platformRuleCollections/platform_core_Application.bicep'
import { platform_externalWeb_application } from '../../../configuration/firewall/rules/platformRuleCollections/platform_externalWeb_Application.bicep'
import { platform_remoteAccess_network } from '../../../configuration/firewall/rules/platformRuleCollections/platform_remoteAccess.bicep'

// Example Rule Collections
/*
import { inbound_example_network } from '../../../configuration/firewall/rules/exampleRuleCollections/example_Inbound_Network.bicep'
import { outbound_example_application } from '../../../configuration/firewall/rules/exampleRuleCollections/example_Outbound_Application.bicep'
import { outbound_example_network } from '../../../configuration/firewall/rules/exampleRuleCollections/example_Outbound_Network.bicep'
*/

@description('Required. Name of the existing Azure Firewall Policy.')
param parentName string

@description('Resource: Azure Firewall Policy (existing).')
resource firewallPolicy 'Microsoft.Network/firewallPolicies@2024-05-01' existing = {
  name: parentName
}

@description('Resource: Platform Rule Collection Group.')
resource ruleCollectionGroup_Platform 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-05-01' = {
  name: 'platformRuleCollectionGroup' // This must be unique within the Azure Firewall Policy and a string only to support automatic documentation generation
  parent: firewallPolicy
  properties: {
    priority: 100
    ruleCollections: [
      platform_activeDirectory_network
      platform_centralRunners_network
      platform_centralRunners_application
      platform_core_network
      platform_core_application
      platform_externalWeb_application
      platform_remoteAccess_network
    ]
  }
}

// Example Rule Collection Group
/*
@description('Resource: Example Rule Collection Group.')
resource ruleCollectionGroup_Example 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-05-01' = {
  name: 'ExampleRuleCollectionGroup' // This must be unique within the Azure Firewall Policy and a string only to support automatic documentation generation
  parent: firewallPolicy
  dependsOn: [
    ruleCollectionGroup_Platform // Ensure the Platform Rule Collection Group is created first.
  ]
  properties: {
    priority: 1000
    ruleCollections: [
      inbound_example_network
      outbound_example_application
      outbound_example_network
    ]
  }
}
*/
