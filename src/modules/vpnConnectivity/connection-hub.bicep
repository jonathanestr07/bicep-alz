targetScope = 'resourceGroup'

metadata name = 'ALZ Bicep - VPN Connection for Azure Hub'
metadata description = 'Module used to set up VPN Connection for Azure Hub'
metadata version = '1.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Optional. The Azure Region to deploy the resources into.')
param location string = resourceGroup().location

@description('Optional. Tags that will be applied to all resources in this module.')
param tags object = {}

@description('Required. The existing VPN Gateway name.')
param vpnGatewayName string

@description('Required. VPN Shared Key Name.')
param vpnSharedKeyName string

@description('Required. The existing Azure Key Vault name.')
param keyVaultName string

@description('Required. IP Sec VPN Configuration.')
param vpnConfiguration object

@description('Required. Local Network Gateway Array output.')
param localNetworkGateways array

@description('Resource: VPN Gateway')
resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2024-05-01' existing = {
  name: vpnGatewayName
}

@description('Resource: Azure Key Vault')
resource vault 'Microsoft.KeyVault/vaults@2024-11-01' existing = {
  name: keyVaultName
}

@description('Module: VPN Connection - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/connection')
module connection 'br/public:avm/res/network/connection:0.1.5' = [
  for (vpnConnection, index) in (vpnConfiguration.?vpnLinkConnections ?? []): {
    name: take('connection-${index}-${guid(deployment().name)}', 64)
    params: {
      // Required parameters
      name: vpnConnection.name
      virtualNetworkGateway1: {
        id: vpnGateway.id
      }
      // Non-required parameters
      connectionMode: vpnConnection.connectionType == 'IPsec' ? vpnConnection.connectionMode : null
      connectionProtocol: vpnConnection.connectionType == 'IPsec' ? vpnConnection.connectionProtocol : null
      connectionType: vpnConnection.connectionType
      customIPSecPolicy: !empty(vpnConnection.?customIPSecPolicy) ? vpnConnection.?customIPSecPolicy : null
      dpdTimeoutSeconds: vpnConnection.connectionType == 'IPsec' ? vpnConnection.?dpdTimeoutSeconds : null
      enableBgp: vpnConnection.?enableBgp
      localNetworkGateway2ResourceId: localNetworkGateways[index].id
      location: location
      routingWeight: vpnConnection.?routingWeight != -1 ? vpnConnection.?routingWeight : null
      tags: tags
      useLocalAzureIpAddress: vpnConnection.connectionType == 'IPsec' ? vpnConnection.?useLocalAzureIpAddress : null
      usePolicyBasedTrafficSelectors: vpnConnection.?usePolicyBasedTrafficSelectors
      vpnSharedKey: vault.getSecret(vpnSharedKeyName)
    }
  }
]

