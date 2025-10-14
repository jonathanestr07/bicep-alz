import { ipGroupArray } from '../../configuration/firewall/ipGroups.bicep'
import * as shared from '../../configuration/shared.conf.bicep'

targetScope = 'resourceGroup'

metadata name = 'ALZ Bicep - Azure Firewall Policy module'
metadata description = 'Deploy the Azure Firewall Policy Module.'
metadata version = '1.2.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Required. Name of the existing Azure Firewall Policy.')
param azFirewallPolicyName string

@description('Optional. Switch which allows Azure Firewall Policy to be provisioned.')
param azFirewallPolicyDeployment bool = true

@description('Generated. The Azure Region to deploy the resources into.')
param location string = resourceGroup().location

@description('Optional. Tags that will be applied to all resources in this module.')
param tags object = {}

@description('Optional. Resource ID of the base Azure Firewall policy.')
param basePolicyResourceId string = ''

@description('Optional. Enable DNS Proxy on Firewalls attached to the Firewall Policy.')
param enableProxy bool = true

@description('Optional. List of Custom DNS Servers.')
param servers array = []

@description('Optional. A flag to indicate if the insights are enabled on the policy.')
param insightsIsEnabled bool = false

@description('Optional. Default Log Analytics Resource ID for Firewall Policy Insights.')
param defaultWorkspaceResourceId string = ''

@description('Optional. Number of days the insights should be enabled on the policy.')
param retentionDays int = 90

@description('Optional. List of rules for traffic to bypass.')
param bypassTrafficSettings array = []

@description('Optional. List of specific signatures states.')
param signatureOverrides array = []

@description('Optional. The configuring of intrusion detection.')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param mode string = 'Off'

@description('Optional. Tier of Firewall Policy.')
@allowed([
  'Premium'
  'Standard'
  'Basic'
])
param tier string = 'Standard'

@description('Optional. List of private IP addresses/IP address ranges to not be SNAT.')
param privateRanges array = []

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. The operation mode for automatically learning private ranges to not be SNAT.')
param autoLearnPrivateRanges string = 'Enabled'

@description('Optional. The operation mode for Threat Intelligence.')
@allowed([
  'Alert'
  'Deny'
  'Off'
])
param threatIntelMode string = 'Deny'

@description('Optional. List of FQDNs for the ThreatIntel Allowlist.')
param fqdns array = []

@description('Optional. List of IP addresses for the ThreatIntel Allowlist.')
param ipAddresses array = []

@description('Optional. Secret ID of (base-64 encoded unencrypted PFX) Secret or Certificate object stored in KeyVault.')
#disable-next-line secure-secrets-in-params // Not a secret
param keyVaultSecretResourceId string = ''

@description('Optional. Name of the CA certificate.')
param certificateName string = ''

@description('Optional. Switch which allows Azure Bastion deployment to be provisioned.')
param ipGroupDeployment bool = false

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

type managedIdentitiesType = {
  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]
}?

var uaiPrefix = toLower('${shared.resPrefixes.userAssignedIdentity}-${shared.locPrefixes[location]}-${shared.resPrefixes.platform}-${shared.resPrefixes.platformConn}')

var resourceNames = {
  userAssignedIdentity: '${uaiPrefix}-azfw'
}

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: 'UserAssigned'
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

// Firewall Policy Variables
var firewallPolicyPremiumProperties = {
  basePolicy: !empty(basePolicyResourceId)
    ? {
        id: basePolicyResourceId
      }
    : null
  dnsSettings: enableProxy
    ? {
        enableProxy: enableProxy
        servers: servers
      }
    : null
  insights: insightsIsEnabled
    ? {
        isEnabled: insightsIsEnabled
        logAnalyticsResources: {
          defaultWorkspaceId: {
            id: !empty(defaultWorkspaceResourceId) ? defaultWorkspaceResourceId : null
          }
        }
        retentionDays: retentionDays
      }
    : null
  intrusionDetection: (mode != 'Off')
    ? {
        configuration: {
          bypassTrafficSettings: !empty(bypassTrafficSettings) ? bypassTrafficSettings : null
          signatureOverrides: !empty(signatureOverrides) ? signatureOverrides : null
          privateRanges: privateRanges
        }
        mode: mode
      }
    : null
  sku: {
    tier: 'Premium'
  }
  snat: !empty(privateRanges)
    ? {
        autoLearnPrivateRanges: autoLearnPrivateRanges
        privateRanges: privateRanges
      }
    : null
  threatIntelMode: threatIntelMode
  threatIntelWhitelist: {
    fqdns: fqdns
    ipAddresses: ipAddresses
  }
  transportSecurity: (!empty(keyVaultSecretResourceId) || !empty(certificateName))
    ? {
        certificateAuthority: {
          keyVaultSecretId: !empty(keyVaultSecretResourceId) ? keyVaultSecretResourceId : null
          name: !empty(certificateName) ? certificateName : null
        }
      }
    : null
}

var firewallPolicyStandardProperties = {
  basePolicy: !empty(basePolicyResourceId)
    ? {
        id: basePolicyResourceId
      }
    : null
  dnsSettings: enableProxy
    ? {
        enableProxy: enableProxy
        servers: servers
      }
    : null
  insights: insightsIsEnabled
    ? {
        isEnabled: insightsIsEnabled
        logAnalyticsResources: {
          defaultWorkspaceId: {
            id: !empty(defaultWorkspaceResourceId) ? defaultWorkspaceResourceId : null
          }
        }
        retentionDays: retentionDays
      }
    : null
  sku: {
    tier: 'Standard'
  }
  snat: !empty(privateRanges)
    ? {
        autoLearnPrivateRanges: autoLearnPrivateRanges
        privateRanges: privateRanges
      }
    : null
  threatIntelMode: threatIntelMode
  threatIntelWhitelist: {
    fqdns: fqdns
    ipAddresses: ipAddresses
  }
  transportSecurity: (!empty(keyVaultSecretResourceId) || !empty(certificateName))
    ? {
        certificateAuthority: {
          keyVaultSecretId: !empty(keyVaultSecretResourceId) ? keyVaultSecretResourceId : null
          name: !empty(certificateName) ? certificateName : null
        }
      }
    : null
}

// Module: User Assigned Identity
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = if (tier == 'Premium') {
  name: 'userAssignedIdentity-${guid(deployment().name)}'
  params: {
    name: resourceNames.userAssignedIdentity
    location: location
    tags: tags
  }
}

@batchSize(1)
@description('Module: IP Group - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/ip-group')
module ipGroup 'br/public:avm/res/network/ip-group:0.3.0' = [
  for item in ipGroupArray: if (ipGroupDeployment) {
    name: 'ipGroup-${item.name}'
    params: {
      name: item.name
      location: location
      tags: tags
      ipAddresses: item.ipAddresses
    }
  }
]

@description('Resource: Azure Firewall Policy')
resource firewallPolicy 'Microsoft.Network/firewallPolicies@2023-11-01' = if (azFirewallPolicyDeployment) {
  name: azFirewallPolicyName
  location: location
  tags: tags
  identity: identity
  dependsOn: [
    ipGroup
  ]
  properties: tier == 'Premium' ? firewallPolicyPremiumProperties : firewallPolicyStandardProperties
}

@description('Module: Rule Collection Groups')
module ruleCollectionGroups 'ruleCollectionGroups/ruleCollectionGroups.bicep' = {
  name: 'ruleCollectionGroups-${guid(deployment().name)}'
  params: {
    parentName: firewallPolicy.name
  }
}

// Outputs
@description('The name of the User Assigned Identity.')
output userAssignedIdentityName string = (tier == 'Premium') ? userAssignedIdentity!.outputs.name : ''

@description('The ID of the User Assigned Identity.')
output userAssignedIdentityId string = (tier == 'Premium') ? userAssignedIdentity!.outputs.resourceId : ''

@description('Array of IP Groups.')
output ipGroups array = [
  for i in range(0, length(ipGroupArray)): {
    name: ipGroupDeployment ? ipGroup[i]!.outputs.name : ''
  }
]

@description('The name of the Azure Firewall Policy.')
output firewallPolicyName string = azFirewallPolicyDeployment ? firewallPolicy.name : ''

@description('The ID of the Azure Firewall Policy.')
output firewallPolicyId string = azFirewallPolicyDeployment ? firewallPolicy.id : ''
