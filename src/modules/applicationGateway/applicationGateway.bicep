targetScope = 'resourceGroup'

metadata name = 'ALZ Bicep - Azure Application Gateway module'
metadata description = 'Deploy the Azure Application Gateway Module.'
metadata version = '1.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Required. Indicates whether to deploy a self-signed certificate.')
param deploySelfSignedCert bool

@description('Generated. The location where the resources will be deployed.')
param location string = resourceGroup().location

@description('Required. The name of the Application Gateway.')
param appGatewayName string

@description('Required. The name of the public IP address for the Application Gateway.')
param appGatewayPublicIpName string

@description('Required. The name of the Key Vault.')
param keyVaultName string

@description('Optional. The subscription ID where the resources will be deployed.')
param subscriptionId string = subscription().subscriptionId

@description('Optional. Tags that will be applied to all resources in this module.')
param tags object = {}

@description('Required. The name of the resource group for the network resources.')
param resourceGroupNetwork string

@description('Required. The name of the virtual network.')
param virtualNetworkName string

@description('Required. The name of the user-assigned identity.')
param uaiName string

@metadata({
  example: [
    {
      name: 'frontend-insight'
      commonName: 'example.insight.com'
    }
    {
      name: 'frontend-insight-dev'
      commonName: 'example.dev.insight.com'
    }
  ]
})
@description('Optional. The certificates to create if deploySelfSignedCert is true and the certificates to reference in the Application Gateway.')
param certificates array = []

@description('Optional. The backend internal services for the Application Gateway.')
param internalServices internalService[] = [
  {
    certName: 'frontend-insight'
    probe: {
      host: 'example.insight.internal'
      port: 443
      protocol: 'Https'
      path: '/status-0123456789abcdef'
      match: {
        statusCodes: [
          '200'
        ]
      }
    }
    name: 'appGwBackendPool'
    backendPoolproperties: {
      backendAddresses: [
        {
          ipAddress: '172.31.240.4'
        }
      ]
    }
  }
]

@description('Required. The name of Web Application Firewall.')
param appGatewayWAFName string

@description('Optional. The custom rules for the Web Application Firewall.')
param wafCustomRules array = []

@description('Optional. The policy settings for the Web Application Firewall.')
param wafPolicySettings object = {}

@description('The subnets array.')
param subnetsArray array

@description('Required. The private IP address for the Application Gateway. Must be Static for WAF v2 Skus.')
param appGatewayPrivateIpAddress string

@description('Module: User Assigned Identity - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/managed-identity/user-assigned-identity')
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: 'userAssignedIdentity-${guid(deployment().name)}'
  params: {
    name: uaiName
    location: location
  }
}

@description('Module: Public IP Address - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/public-ip-address')
module publicIPAddress 'br/public:avm/res/network/public-ip-address:0.9.0' = {
  name: 'publicIPAddress-${guid(deployment().name)}'
  params: {
    name: appGatewayPublicIpName
    location: location
    publicIPAllocationMethod: 'Static'
    tags: tags
  }
}

@description('Module: Azure Key Vault - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault')
module keyvault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: 'keyvault-${guid(deployment().name)}'
  params: {
    // Required parameters
    name: keyVaultName
    // Non-required parameters
    enablePurgeProtection: true
    location: location
    publicNetworkAccess: (deploySelfSignedCert) ? 'Enabled' : 'Disabled' // Deployment scripts are public in ARM
    networkAcls: {
      defaultAction: (deploySelfSignedCert) ? 'Allow' : 'Deny' // Deployment scripts are public in ARM
      bypass: 'AzureServices'
    }
    roleAssignments: [
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: '4633458b-17de-408a-b874-0445c86b69e6'
      }
      {
        principalId: userAssignedIdentity.outputs.principalId
        roleDefinitionIdOrName: 'a4417e6f-fecd-4de8-b567-7b0420556985'
      }
    ]
    privateEndpoints: (deploySelfSignedCert && !contains(map(subnetsArray, subnets => subnets.name), 'privateEndpoints'))
      ? []
      : [
          {
            subnetResourceId: resourceId(
              subscriptionId,
              resourceGroupNetwork,
              'Microsoft.Network/virtualNetworks/subnets',
              virtualNetworkName,
              'privateEndpoints'
            )
          }
        ]
  }
}

@batchSize(1)
@description('Module: Create Key Vault Certificate')
module akvCertFrontend 'br/public:deployment-scripts/create-kv-certificate:1.1.1' = [
  for cert in certificates: if (deploySelfSignedCert) {
    name: take('keyvault-AddCert-${cert.name}-${guid(deployment().name)}', 64)
    dependsOn: [
      keyvault
    ]
    params: {
      useExistingManagedIdentity: true
      managedIdentityName: userAssignedIdentity.outputs.name
      existingManagedIdentitySubId: subscriptionId
      existingManagedIdentityResourceGroupName: resourceGroup().name
      akvName: keyVaultName
      certificateName: cert.name
      certificateCommonName: cert.commonName
      rbacRolesNeededOnKV: '' // RBAC access is granted in the key vault module
    }
  }
]

@description('Module: Application Gateway Web Application Firewall Policy -https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/application-gateway-web-application-firewall-policy')
module applicationGatewayWebApplicationFirewallPolicy 'br/public:avm/res/network/application-gateway-web-application-firewall-policy:0.2.0' = {
  name: 'waf-${guid(deployment().name)}'
  params: {
    // Required parameters
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
        }
      ]
    }
    name: appGatewayWAFName
    // Non-required parameters
    customRules: wafCustomRules
    location: location
    policySettings: wafPolicySettings
  }
}

var sslCertificates = [
  for cert in certificates: {
    name: cert.name
    properties: {
      keyVaultSecretId: 'https://${keyVaultName}${environment().suffixes.keyvaultDns}/secrets/${cert.name}'
    }
  }
]

var backendAddressPoolsFormatted = [
  for pool in internalServices: {
    name: pool.name
    properties: pool.backendPoolproperties
  }
]

var httpListeners = [
  for cert in certificates: {
    name: 'listener-${cert.name}'
    properties: {
      frontendIPConfiguration: {
        id: resourceId(
          subscriptionId,
          resourceGroup().name,
          'Microsoft.Network/applicationGateways/frontendIPConfigurations',
          appGatewayName,
          'appGwPublicFrontendIp'
        )
      }
      frontendPort: {
        id: resourceId(
          subscriptionId,
          resourceGroup().name,
          'Microsoft.Network/applicationGateways/frontendPorts',
          appGatewayName,
          'appGwFrontendPort_443'
        )
      }
      protocol: 'Https'
      sslCertificate: {
        id: resourceId(
          subscriptionId,
          resourceGroup().name,
          'Microsoft.Network/applicationGateways/sslCertificates',
          appGatewayName,
          cert.name
        )
      }
      hostNames: [
        '*.${cert.commonName}'
        cert.commonName
      ]
    }
  }
]

var backendHttpSettingsCollectionOnCerts = [
  for cert in certificates: {
    name: cert.name
    properties: {
      port: 443
      protocol: 'Https'
      cookieBasedAffinity: 'Disabled'
      hostName: cert.commonName
      probe: {
        id: resourceId(
          subscriptionId,
          resourceGroup().name,
          'Microsoft.Network/applicationGateways/probes',
          appGatewayName,
          'probe-${cert.name}'
        )
      }
    }
  }
]

var probes = [
  for pool in internalServices: {
    name: 'probe-${pool.certName}'
    properties: {
      protocol: pool.probe.protocol
      host: pool.probe.host
      match: pool.probe.match
      port: pool.probe.port
      path: pool.probe.path
      timeout: 20
      interval: 30
      unhealthyThreshold: 3
    }
  }
]

var requestRoutingRules = [
  for (backendAddressPool, index) in internalServices: {
    name: 'appGwRoutingRule-${backendAddressPool.certName}'
    properties: {
      priority: 200 + index
      ruleType: 'Basic'
      httpListener: {
        id: resourceId(
          subscriptionId,
          resourceGroup().name,
          'Microsoft.Network/applicationGateways/httpListeners',
          appGatewayName,
          'listener-${backendAddressPool.certName}'
        )
      }
      backendAddressPool: {
        id: resourceId(
          subscriptionId,
          resourceGroup().name,
          'Microsoft.Network/applicationGateways/backendAddressPools',
          appGatewayName,
          backendAddressPool.name
        )
      }
      backendHttpSettings: {
        id: resourceId(
          subscriptionId,
          resourceGroup().name,
          'Microsoft.Network/applicationGateways/backendHttpSettingsCollection',
          appGatewayName,
          backendAddressPool.certName
        )
      }
    }
  }
]

@description('Module: Application Gateway - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/application-gateway')
module applicationGateway 'br/public:avm/res/network/application-gateway:0.7.1' = {
  name: 'applicationGateway-${guid(deployment().name)}'
  dependsOn: [
    publicIPAddress
    akvCertFrontend
  ]
  params: {
    // Required parameters
    name: appGatewayName
    // Non-required parameters
    location: location
    firewallPolicyResourceId: applicationGatewayWebApplicationFirewallPolicy.outputs.resourceId
    managedIdentities: {
      userAssignedResourceIds: [
        userAssignedIdentity.outputs.resourceId
      ]
    }
    sslCertificates: sslCertificates
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: resourceId(
              subscriptionId,
              resourceGroupNetwork,
              'Microsoft.Network/virtualNetworks/subnets',
              virtualNetworkName,
              'AppGateway'
            )
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId(
              subscriptionId,
              resourceGroup().name,
              'Microsoft.Network/publicIPAddresses',
              appGatewayPublicIpName
            )
          }
        }
      }
      {
        name: 'appGwPrivateFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: appGatewayPrivateIpAddress
          subnet: {
            id: resourceId(
              subscriptionId,
              resourceGroupNetwork,
              'Microsoft.Network/virtualNetworks/subnets',
              virtualNetworkName,
              'AppGateway'
            )
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'appGwFrontendPort_443'
        properties: {
          port: 443
        }
      }
      {
        name: 'appGwFrontendPort_80'
        properties: {
          port: 80
        }
      }
    ]
    httpListeners: httpListeners
    backendAddressPools: backendAddressPoolsFormatted
    backendHttpSettingsCollection: backendHttpSettingsCollectionOnCerts
    probes: probes
    requestRoutingRules: requestRoutingRules
    enableHttp2: true
    enableTelemetry: true
    sku: 'WAF_v2'
    tags: tags
  }
}

// User Defined Types
@description('The internal service for the Application Gateway.')
type internalService = {
  certName: string
  probe: {
    host: string
    port: int
    protocol: 'Http' | 'Https'
    path: string
    match: {
      statusCodes: array
    }
  }
  name: string
  backendPoolproperties: object
}
