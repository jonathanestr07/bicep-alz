targetScope = 'managementGroup'
@description('Test Deployment for Azure Platform Management Landing Zone')
import { locPrefixes, resPrefixes, resources } from '../../../configuration/shared.conf.bicep'
module testPlatformConnLz '../platformManagement.bicep' = {
  name: 'testPlatformMgmtLz'
  params: {
    lzPrefix: 'plat'
    envPrefix: 'mgmt'
    topLevelManagementGroupPrefix: 'mg-alz'
    subscriptionId: 'a50d2a27-93d9-43b1-957c-2a663ffaf37f'
    subscriptionMgPlacement: 'mg-alz-platform-management'
    tags: {
      environment: 'mgmt'
      applicationName: 'Platform Management Landing Zone'
      owner: 'Platform Team'
      criticality: 'Tier0'
      costCenter: '1234'
      contactEmail: 'test@outlook.com'
      dataClassification: 'Internal'
      iac: 'Bicep'
    }
    budgetConfiguration: {
      enabled: true
      budgets: [
        {
          name: 'budget-forecasted'
          amount: 500
          thresholdType: 'Forecasted'
          thresholds: [
            90
            100
          ]
          contactEmails: [
            'test@outlook.com'
          ]
        }
        {
          name: 'budget-actual'
          amount: 500
          thresholdType: 'Actual'
          thresholds: [
            95
            100
          ]
          contactEmails: [
            'test@outlook.com'
          ]
        }
      ]
    }
    actionGroupConfiguration: {
      emailReceivers: [
        'test@outlook.com'
      ]
    }
    logAnalyticsConfiguration: {
      dataRetention: 90
      skuName: 'PerGB2018'
    }
    logAnalyticsWorkspaceSolutions: [
      'SecurityInsights'
      'ChangeTracking'
      'SQLVulnerabilityAssessment'
    ]
    virtualNetworkConfiguration: {
      addressPrefix: '10.52.6.0/24'
      nextHopIpAddress: '10.52.2.4'
      subnets: [
        {
          name: 'management'
          addressPrefix: '10.52.6.0/25'
          routes: []
          securityRules: [
            {
              name: 'INBOUND-FROM-RemoteAccessNetwork-TO-MgmtVM-PORT-22-3389-PROT-any-ALLOW'
              properties: {
                protocol: '*'
                sourcePortRange: '*'
                destinationPortRanges: [
                  '22'
                  '3389'
                ]
                sourceAddressPrefixes: [
                  '10.20.72.4' // Remote Access Network Ranges. Ex: Bastion or CyberArk IP. Replace it with actual ranges.
                ]
                destinationAddressPrefix: '10.52.6.0/25' // Platform Management Subnet Range .Replace it with actual range.
                access: 'Allow'
                priority: 500
                direction: 'Inbound'
                description: 'Inbound rule from allowed networks to Azure allowed network to management VM on port 22 3389 and any protocol'
              }
            }
            {
              name: 'INBOUND-FROM-subnet-TO-subnet-PORT-any-PROT-any-ALLOW'
              properties: {
                protocol: '*'
                sourcePortRange: '*'
                destinationPortRange: '*'
                sourceAddressPrefix: '10.52.6.0/25' // Platform Management Subnet Range .Replace it with actual range.
                destinationAddressPrefix: '10.52.6.0/25' // Platform Management Subnet Range .Replace it with actual range.
                access: 'Allow'
                priority: 999
                direction: 'Inbound'
                description: 'Inbound rule from the subnet to the subnet on any port and any protocol'
              }
            }
          ]
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      ]
    }
    hubVirtualNetworkId: '/subscriptions/5cb7efe0-67af-4723-ab35-0f2b42a85839/resourceGroups/arg-aue-plat-conn-network/providers/Microsoft.Network/virtualNetworks/vnt-aue-plat-conn-10.52.0.0_24'
    allowHubVpnGatewayTransit: false
  }
}
