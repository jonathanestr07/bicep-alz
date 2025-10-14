import * as shared from '../../configuration/shared.conf.bicep'
import * as type from '../../configuration/shared.type.bicep'

targetScope = 'resourceGroup'

metadata name = 'ALZ Bicep - VPN Connectivity for Azure Hub'
metadata description = 'Module used to set up VPN Connectivity for Azure Hub'
metadata version = '2.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Optional. The Azure Region to deploy the resources into.')
param location string = resourceGroup().location

@description('Optional. Tags that will be applied to all resources in this module.')
param tags object = {}

@secure()
@description('Required. Specifies a VPN shared key. The same value has to be specified on both Virtual Network Gateways.')
param vpnSharedKeySecret string

@description('Required. The VPN Gateway name.')
param vpnGatewayName string

@description('Required. The existing Azure Key Vault name.')
param keyVaultName string

@description('Required. Local Network Gateway Configuration.')
param localNetworkGatewayConfiguration type.localNetworkGatewayType

@description('Required. IP Sec VPN Configuration.')
param vpnConfiguration type.hubVpnConnectionType

var vpnSharedKeyName = 'vpnSharedKeyName'

@description('Module: Local Network Gateway - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/local-network-gateway')
module localNetworkGateway 'br/public:avm/res/network/local-network-gateway:0.4.0' = [
  for (localNetworkGateway, index) in (localNetworkGatewayConfiguration): {
    name: take('localNetworkGateway-${index}-${guid(deployment().name)}', 64)
    params: {
      // Required parameters
      localNetworkAddressSpace: {
        addressPrefixes: localNetworkGateway.localAddressPrefixes
      }
      localGatewayPublicIpAddress: localNetworkGateway.localGatewayPublicIpAddress
      name: localNetworkGateway.name
      // Non-required parameters
      fqdn: localNetworkGateway.?fqdn
      bgpSettings: localNetworkGateway.?bgpSettings
      location: location
      tags: tags
    }
  }
]

// Required to pass the Key Vault name and secret to the VPN connection module.
@description('Module: Hub VPN Connection')
module hubConnection './connection-hub.bicep' = {
  name: take('hubConnection-${guid(deployment().name)}', 64)
  params: {
    keyVaultName: vault.outputs.name
    location: location
    localNetworkGateways: [
      for (name, i) in localNetworkGatewayConfiguration: {
        name: localNetworkGateway[i].outputs.name
        id: localNetworkGateway[i].outputs.resourceId
      }
    ]
    tags: tags
    vpnConfiguration: vpnConfiguration
    vpnGatewayName: vpnGatewayName
    vpnSharedKeyName: vpnSharedKeyName
  }
}

@description('Module: Azure Key Vault - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault')
module vault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: take('vault-${guid(deployment().name)}', 64)
  params: {
    // Required parameters
    name: keyVaultName
    // Non-required parameters
    enablePurgeProtection: true
    enableSoftDelete: true
    enableVaultForTemplateDeployment: true
    location: location
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    publicNetworkAccess: 'Disabled'
    secrets: [
      {
        name: vpnSharedKeyName
        value: vpnSharedKeySecret
      }
    ]
    sku: 'standard'
    softDeleteRetentionInDays: 7
    tags: tags
  }
}
