import * as shared from '../shared.conf.bicep'
import * as type from '../shared.type.bicep'

using '../../modules/vpnConnectivity/vpnConnectivity-hub.bicep'

param vpnSharedKeySecret = '' // Overwritten via CI/CD pipeline
param vpnGatewayName = 'vng-aue-plat-conn-vpnGwy' // existing VPN Gateway name
param keyVaultName = '${shared.resPrefixes.keyVault}-${shared.locPrefixes.australiaeast}-${shared.resPrefixes.platform}-${shared.resPrefixes.platformConn}-vpn'
param localNetworkGatewayConfiguration = [
  {
    name: '${shared.resPrefixes.localNetworkGateway}-${shared.locPrefixes.australiaeast}-${shared.resPrefixes.platform}-${shared.resPrefixes.platformConn}-01'
    localAddressPrefixes: []
    localGatewayPublicIpAddress: '' // Update with the public IP address of the on-premises VPN device
    bgpSettings: {
      localAsn: 65123
      localBgpPeeringAddress: '192.168.1.5'
      peerWeight: 100
    }
  }
]
param vpnConfiguration = {
  vpnLinkConnections: [
    {
      name: '${shared.resPrefixes.connection}-${shared.locPrefixes.australiaeast}-${shared.resPrefixes.platform}-${shared.resPrefixes.platformConn}-01'
      enableBgp: true
      connectionType: 'IPsec'
      connectionMode: 'Default'
      connectionProtocol: 'IKEv2'
      routingWeight: 0
      enablePrivateLinkFastPath: false
      expressRouteGatewayBypass: false
      dpdTimeoutSeconds: 30
      useLocalAzureIpAddress: false
      usePolicyBasedTrafficSelectors: false
      customIPSecPolicy: {
        saLifeTimeSeconds: 27000
        saDataSizeKilobytes: 102400000
        ipsecEncryption: 'AES256'
        ipsecIntegrity: 'SHA256'
        ikeEncryption: 'AES256'
        ikeIntegrity: 'SHA256'
        dhGroup: 'DHGroup24'
        pfsGroup: 'None'
      }
    }
  ]
}

