import * as shared from '../shared.conf.bicep'
import * as type from '../shared.type.bicep'

using '../../modules/vpnConnectivity/vpnConnectivity-vwan.bicep'

param vWanId = '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/arg-aue-platform-conn-vwan/providers/Microsoft.Network/virtualWans/vwan-aue-platform-conn-ntr2ktfctrvbq'
param vpnGatewayName = 'vng-aue-plat-conn-vpnGwy' // existing VPN Gateway name
param vpnConfiguration = {
  vpnSite: [
    {
      name: 'vpn-site1'
      addressPrefixes: []
      deviceProperties: {
        deviceVendor: 'Cisco'
        deviceModel: 'ASA 5500'
        linkSpeedInMbps: 100
      }
    }
  ]
  vpnSiteLinks: [
    {
      name: 'vpn-site-link1'
      bgpProperties: {
        asn: 65515
        bgpPeeringAddress: ''
      }
      fqdn: ''
      ipAddress: ''
      linkProperties: {
        linkProviderName: 'Telstra'
        linkSpeedInMbps: 200
      }
    }
  ]
  vpnLinkConnections: [
    {
      name: 'vpn-link-connection1'
      connectionBandwidth: 100
      enableBgp: false
      ipsecPolicies: [
        {
          saLifeTimeSeconds: 27000
          saDataSizeKilobytes: 102400000
          ipsecEncryption: 'AES256'
          ipsecIntegrity: 'SHA256'
          ikeEncryption: 'AES256'
          ikeIntegrity: 'SHA256'
          dhGroup: 'DHGroup24'
          pfsGroup: 'PFS24'
        }
      ]
      useLocalAzureIpAddress: false
      usePolicyBasedTrafficSelectors: false
      vpnConnectionProtocolType: 'IKEv2'
      vpnGatewayCustomBgpAddresses: [
        {
          customBgpIpAddress: ''
          ipConfigurationId: 'Instance0'
        }
        {
          customBgpIpAddress: ''
          ipConfigurationId: 'Instance1'
        }
      ]
      vpnLinkConnectionMode: 'Default'
    }
  ]
}
