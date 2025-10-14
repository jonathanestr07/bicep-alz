targetScope = 'managementGroup'
@description('Test Deployment for Azure Platform Identity Landing Zone')
import { locPrefixes, resPrefixes, resources } from '../../../configuration/shared.conf.bicep'
module testPlatformIdamLz '../platformIdentity.bicep' = {
  name: 'testPlatformIdamLz'
  params: {
    lzPrefix: 'plat'
    envPrefix: 'idam'
    topLevelManagementGroupPrefix: 'mg-alz'
    subscriptionId: 'a50d2a27-93d9-43b1-957c-2a663ffaf37f'
    subscriptionMgPlacement: 'mg-alz-platform-identity'
    tags: {
      environment: 'idam'
      applicationName: 'Platform Identity Landing Zone'
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
    virtualNetworkConfiguration: {
      addressPrefix: '10.52.4.0/24'
      nextHopIpAddress: '10.52.2.4'
      subnets: [
        {
          name: 'adds'
          addressPrefix: '10.52.4.0/26'
          routes: []
          securityRules: [
            {
              name: 'INBOUND-FROM-onPremisesADDS-TO-subnet-PORT-adServices-PROT-any-ALLOW'
              properties: {
                protocol: '*'
                sourcePortRange: '*'
                destinationPortRanges: [
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
                sourceAddressPrefixes: [
                  '10.20.11.47'
                  '10.20.11.48'
                ] //On-Premises Active Directory Services IPs. Replace it with actual ranges
                destinationAddressPrefix: '10.52.4.0/25' // Platform Identity ADDS Subnet Range. Replace it with actual range.
                access: 'Allow'
                priority: 500
                direction: 'Inbound'
                description: 'Inbound rules from on-premises & Azure Corp ADDS servers to the subnet for the required ports and protocols'
              }
            }
            {
              name: 'INBOUND-FROM-onPremisesCorpNetworks-TO-adds-PORT-aadServices-PROT-any-ALLOW'
              properties: {
                protocol: '*'
                sourcePortRange: '*'
                destinationPortRanges: [
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
                sourceAddressPrefixes: [
                  '10.20.76.0/24'
                ] // OnPremises Corporate networks. Replace it with actual ranges.
                destinationAddressPrefix: '10.52.4.0/25' // Platform Identity ADDS Subnet Range. Replace it with actual range.
                access: 'Allow'
                priority: 501
                direction: 'Inbound'
                description: 'Allow on-premises corp virtual networks traffic to adds subnet on adservices ports'
              }
            }
            {
              name: 'INBOUND-FROM-azureSupernet-TO-adds-PORT-aadServices-PROT-any-ALLOW'
              properties: {
                protocol: '*'
                sourcePortRange: '*'
                destinationPortRanges: [
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
                sourceAddressPrefix: ''
                sourceAddressPrefixes: [
                  '10.52.0.0/16'
                ] // Azure Supernet Range. Replace it with actual ranges.
                destinationAddressPrefix: '10.52.4.0/25' // Platform Identity ADDS Subnet Range. Replace it with actual ranges.
                access: 'Allow'
                priority: 502
                direction: 'Inbound'
                description: 'Inbound rules from Azure Supernet to the ADDS subnet for the required ports and protocols'
              }
            }
            {
              name: 'INBOUND-FROM-RemoteAccessNetwork-TO-azurePlatDCs-PORT-22-3389-PROT-any-ALLOW'
              properties: {
                protocol: '*'
                sourcePortRange: '*'
                destinationPortRanges: [
                  '3389'
                  '22'
                ]
                sourceAddressPrefixes: [
                  '10.20.72.4'
                ] // Remote Access Network Ranges. Ex: Bastion or CyberArk IP. Replace it with actual ranges.
                destinationAddressPrefix: '10.52.4.0/25' // Platform Identity ADDS Subnet Range. Replace it with actual ranges.
                access: 'Allow'
                priority: 503
                direction: 'Inbound'
                description: 'Inbound rule from allowed networks to Azure allowed network to azure Platform Domain Controllers on port 22, 3389 and any protocol'
              }
            }
            {
              name: 'INBOUND-FROM-subnet-TO-subnet-PORT-any-PROT-any-ALLOW'
              properties: {
                protocol: '*'
                sourcePortRange: '*'
                destinationPortRange: '*'
                sourceAddressPrefix: '10.52.4.0/25' // Platform Identity ADDS Subnet Range. Replace it with actual ranges.
                destinationAddressPrefix: '10.52.4.0/25' // Platform Identity ADDS Subnet Range .Replace it with actual ranges.
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
        {
          name: 'privateEndpoints'
          addressPrefix: '10.52.4.64/26'
          routes: []
          securityRules: [
            {
              name: 'INBOUND-FROM-virtualNetwork-TO-subnet-PORT-445-443-PROT-any-ALLOW'
              properties: {
                protocol: '*'
                sourcePortRange: '*'
                destinationPortRanges: [
                  '445'
                  '443'
                ]
                sourceAddressPrefix: 'VirtualNetwork'
                destinationAddressPrefix: '10.52.4.128/25' // Platform Identity PEP Subnet Range .Replace it with actual range.
                access: 'Allow'
                priority: 500
                direction: 'Inbound'
                description: 'Inbound rule from the virtual network to the subnet on port 445 and 443 on any protocol'
              }
            }
            {
              name: 'INBOUND-FROM-subnet-TO-subnet-PORT-any-PROT-any-ALLOW'
              properties: {
                protocol: '*'
                sourcePortRange: '*'
                destinationPortRange: '*'
                sourceAddressPrefix: '10.52.4.128/25' // Platform Identity PEP Subnet Range .Replace it with actual range.
                destinationAddressPrefix: '10.52.4.128/25' // Platform Identity PEP Subnet Range .Replace it with actual range.
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
