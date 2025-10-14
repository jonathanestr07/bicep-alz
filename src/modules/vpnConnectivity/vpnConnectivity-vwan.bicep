import * as shared from '../../configuration/shared.conf.bicep'
import * as type from '../../configuration/shared.type.bicep'

targetScope = 'resourceGroup'

metadata name = 'ALZ Bicep - VPN Configuration for Azure vWAN'
metadata description = 'Module used to set up VPN Configuration for Azure vWAN'
metadata version = '2.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Optional. The Azure Region to deploy the resources into.')
param location string = resourceGroup().location

@description('Optional. Tags that will be applied to all resources in this module.')
param tags type.tagsType?

@description('Required. Specifies the resource ID of the Virtual WAN where the VPN Connectivity should be created')
param vWanId string

@description('Required. The VPN Gateway name.')
param vpnGatewayName string

@description('Required. IP Sec VPN Configuration.')
param vpnConfiguration type.vwanVpnConnectionType

@description('Resource: VPN Site')
resource vpnSite 'Microsoft.Network/vpnSites@2024-07-01' = [
  for (vpnConfig, index) in vpnConfiguration.?vpnLinkConnections ?? []: {
  name: vpnConfig.siteName
  location: location
  tags: tags
  properties: {
    addressSpace: !empty(vpnConfig.siteAddressPrefixes)
      ? {
          addressPrefixes: vpnConfig.siteAddressPrefixes
        }
      : null
    deviceProperties: !empty(vpnConfig.deviceProperties) ? vpnConfig.deviceProperties : null
    virtualWan: {
      id: vWanId
    }
  }
}]

@description('Resource: VPN Gateway (existing)')
resource vpnGateway 'Microsoft.Network/vpnGateways@2024-05-01' existing = {
  name: vpnGatewayName
}

@description('Resource: VPN Connection')
resource vpnConnections 'Microsoft.Network/vpnGateways/vpnConnections@2024-07-01' = [
  for (vpnConnection, index) in vpnConfiguration.?vpnLinkConnections ?? []: {
    name: 'vpnConnection-${index}'
    parent: vpnGateway
    properties: {
      remoteVpnSite: {
        id: vpnSite[index].id
      }
      vpnLinkConnections: [
        {
          name: vpnConnection.name
          properties: {
            enableBgp: vpnConnection.enableBgp
            useLocalAzureIpAddress: vpnConnection.useLocalAzureIpAddress
            usePolicyBasedTrafficSelectors: vpnConnection.usePolicyBasedTrafficSelectors
            vpnConnectionProtocolType: vpnConnection.vpnConnectionProtocolType
            ipsecPolicies: vpnConnection.ipsecPolicies
            vpnGatewayCustomBgpAddresses: vpnConnection.vpnGatewayCustomBgpAddresses
            vpnLinkConnectionMode: vpnConnection.vpnLinkConnectionMode
            vpnSiteLink: {
              id: vpnSite[index].properties.vpnSiteLinks[0].id
            }
          }
        }
      ]
    }
  }
]
