using '../../orchestration/platformManagement/platformManagement.bicep'

param lzPrefix = 'plat'
param envPrefix = 'mgmt'
param topLevelManagementGroupPrefix = 'mg-alz'
param subscriptionId = 'a50d2a27-93d9-43b1-957c-2a663ffaf37f'
param subscriptionMgPlacement = 'mg-alz-platform-management'
param tags = {
  environment: envPrefix
  applicationName: 'Platform Management Landing Zone'
  owner: 'Platform Team'
  criticality: 'Tier0'
  costCenter: '1234'
  contactEmail: 'test@outlook.com'
  dataClassification: 'Internal'
  iac: 'Bicep'
}
param budgetConfiguration = {
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
param actionGroupConfiguration = {
  emailReceivers: [
    'test@outlook.com'
  ]
}
param logAnalyticsConfiguration = {
  dataRetention: 90
  skuName: 'PerGB2018'
}
param logAnalyticsWorkspaceSolutions = [
  'SecurityInsights'
  'ChangeTracking'
  'SQLVulnerabilityAssessment'
]
param logAnalyticsCustomTables = [
  // Example of a custom table configuration (PKI)
  // {
  //   name: 'CustomPKI_CL'
  //   retentionInDays: 180
  //   schema: {
  //     name: 'CustomPKI_CL'
  //     columns: [
  //       { name: 'TimeGenerated', type: 'dateTime' }
  //       { name: 'EventTime', type: 'dateTime' }
  //       { name: 'EventLevel', type: 'string' }
  //       { name: 'Category', type: 'string' }
  //       { name: 'Outcome', type: 'string' }
  //       { name: 'User', type: 'string' }
  //       { name: 'ResultType', type: 'string' }
  //       { name: 'Thread', type: 'string' }
  //       { name: 'Message', type: 'string' }
  //       { name: 'RawData', type: 'string' }
  //     ]
  //   }
  // }
]
param virtualMachines_Jumphosts = []
param virtualNetworkConfiguration = {
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
param hubVirtualNetworkId = '/subscriptions/5cb7efe0-67af-4723-ab35-0f2b42a85839/resourceGroups/arg-aue-plat-conn-network/providers/Microsoft.Network/virtualNetworks/vnt-aue-plat-conn-10.52.0.0_24'
param allowHubVpnGatewayTransit = false
