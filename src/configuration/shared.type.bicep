// Shared User Defined Types for Azure Services https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types
import * as commonTypes from 'br/public:avm/utl/types/avm-common-types:0.5.1' // Common Types including Locks, Managed Identities, Role Assignments, etc.

// Resource Tags Type
@export()
@description('The type for Azure Resource tags.')
type tagsType = {
  environment: 'mgmt' | 'conn' | 'idam'
  applicationName: string
  owner: string
  criticality: 'Tier0' | 'Tier1' | 'Tier2' | 'Tier3'
  costCenter: string
  contactEmail: string
  dataClassification: 'Internal' | 'Confidential' | 'Secret' | 'Top Secret'
  iac: 'Bicep'
  *: string
}

// Networking Types
@export()
@description('The type for Azure Virtual Network configuration.')
type virtualNetworkType = {
  @description('Optional. Whether to create an associated virtual network. Defaults to \'true\'.')
  enabled: bool?

  @minLength(1)
  @maxLength(64)
  @description('Optional. The name of the virtual network to create.')
  name: string?

  @description('Optional. The address prefix of the virtual network to create.')
  addressPrefix: string

  @description('Optional. The DDoS protection plan ID to associate with the virtual network.')
  ddosProtectionPlanId: string?

  @description('Optional. The DNS servers to associate with the virtual network.')
  dnsServerIps: string[]?

  @description('Optional. The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.')
  nextHopIpAddress: string?

  @description('Optional. A value indicating whether this route overrides overlapping BGP routes regardless of LPM.')
  disableBgpRoutePropagation: bool?

  @description('Optional. The subnet type.')
  subnets: subnetType?
}?

@export()
@description('The type for subnets within a virtual network.')
type subnetType = {
  @description('Required. The Name of the subnet resource.')
  name: string

  @description('Conditional. The address prefix for the subnet. Required if `addressPrefixes` is empty.')
  addressPrefix: string?

  @description('Conditional. List of address prefixes for the subnet. Required if `addressPrefix` is empty.')
  addressPrefixes: string[]?

  @description('Optional. The delegation to enable on the subnet.')
  delegation: string?

  @description('Optional. The resource ID of the network security group to assign to the subnet.')
  networkSecurityGroupResourceId: string?

  @description('Optional. enable or disable apply network policies on private endpoint in the subnet.')
  privateEndpointNetworkPolicies: ('Disabled' | 'Enabled' | 'NetworkSecurityGroupEnabled' | 'RouteTableEnabled')?

  @description('Optional. enable or disable apply network policies on private link service in the subnet.')
  privateLinkServiceNetworkPolicies: ('Disabled' | 'Enabled')?

  @description('Optional. The resource ID of the route table to assign to the subnet.')
  routeTableResourceId: string?

  @description('Optional. An array of custom routes.')
  routes: routeTableType[]?

  @description('Optional. The security group rules to apply to the subnet.')
  securityRules: securityRulesType?

  @description('Optional. An array of service endpoint policies.')
  serviceEndpointPolicies: object[]?

  @description('Optional. The service endpoints to enable on the subnet.')
  serviceEndpoints: string[]?
}[]?

@description('The type for Route Table routes.')
type routeTableType = {
  @description('Required. Name of the route table route.')
  name: string

  @description('Required. Properties of the route table route.')
  properties: {
    @description('Required. The type of Azure hop the packet should be sent to.')
    nextHopType: ('VirtualAppliance' | 'VnetLocal' | 'Internet' | 'VirtualNetworkGateway' | 'None')

    @description('Optional. The destination CIDR to which the route applies.')
    addressPrefix: string?

    @description('Optional. A value indicating whether this route overrides overlapping BGP routes regardless of LPM.')
    hasBgpOverride: bool?

    @description('Optional. The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.')
    nextHopIpAddress: string?
  }
}[]?

@description('The type for NSG security Rules.')
type securityRulesType = {
  @description('Required. The name of the security rule.')
  name: string

  @description('Required. The properties of the security rule.')
  properties: {
    @description('Required. Whether network traffic is allowed or denied.')
    access: ('Allow' | 'Deny')

    @description('Optional. The description of the security rule.')
    description: string?

    @description('Optional. Optional. The destination address prefix. CIDR or destination IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used.')
    destinationAddressPrefix: string?

    @description('Optional. The destination address prefixes. CIDR or destination IP ranges.')
    destinationAddressPrefixes: string[]?

    @description('Optional. The resource IDs of the application security groups specified as destination.')
    destinationApplicationSecurityGroupResourceIds: string[]?

    @description('Optional. The destination port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
    destinationPortRange: string?

    @description('Optional. The destination port ranges.')
    destinationPortRanges: string[]?

    @description('Required. The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic.')
    direction: ('Inbound' | 'Outbound')

    @minValue(100)
    @maxValue(4096)
    @description('Required. Required. The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.')
    priority: int

    @description('Required. Network protocol this rule applies to.')
    protocol: ('Ah' | 'Esp' | 'Icmp' | 'Tcp' | 'Udp' | '*')

    @description('Optional. The CIDR or source IP range. Asterisk "*" can also be used to match all source IPs. Default tags such as "VirtualNetwork", "AzureLoadBalancer" and "Internet" can also be used. If this is an ingress rule, specifies where network traffic originates from.')
    sourceAddressPrefix: string?

    @description('Optional. The CIDR or source IP ranges.')
    sourceAddressPrefixes: string[]?

    @description('Optional. The resource IDs of the application security groups specified as source.')
    sourceApplicationSecurityGroupResourceIds: string[]?

    @description('Optional. The source port or range. Integer or range between 0 and 65535. Asterisk "*" can also be used to match all ports.')
    sourcePortRange: string?

    @description('Optional. The source port ranges.')
    sourcePortRanges: string[]?
  }
}[]?

@export()
@description('The type for virtual network peering configuration (Hub and Spoke).')
type vnetPeeringType = {
  @description('Optional. Whether to create an associated peering. Defaults to \'true\'.')
  enabled: bool?

  @description('Optional. The Name of VNET Peering resource. If not provided, default value will be peer-localVnetName-remoteVnetName.')
  name: string?

  @description('Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. Default is true.')
  allowForwardedTraffic: bool?

  @description('Optional. If gateway links can be used in remote virtual networking to link to this virtual network. Default is false.')
  allowGatewayTransit: bool?

  @description('Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. Default is true.')
  allowVirtualNetworkAccess: bool?

  @description('Optional. Do not verify the provisioning state of the remote gateway. Default is true.')
  doNotVerifyRemoteGateways: bool?

  @description('Optional. If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Default is false.')
  useRemoteGateways: bool?

  @description('Optional. Deploy the outbound and the inbound peering.')
  remotePeeringEnabled: bool?

  @description('Optional. The name of the VNET Peering resource in the remove Virtual Network. If not provided, default value will be peer-remoteVnetName-localVnetName.')
  remotePeeringName: string?

  @description('Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. Default is true.')
  remotePeeringAllowForwardedTraffic: bool?

  @description('Optional. If gateway links can be used in remote virtual networking to link to this virtual network. Default is false.')
  remotePeeringAllowGatewayTransit: bool?

  @description('Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. Default is true.')
  remotePeeringAllowVirtualNetworkAccess: bool?

  @description('Optional. Do not verify the provisioning state of the remote gateway. Default is true.')
  remotePeeringDoNotVerifyRemoteGateways: bool?

  @description('Optional. If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Default is false.')
  remotePeeringUseRemoteGateways: bool?
}?

@export()
@description('The type for Azure Virtual WAN peering configuration (vWAN).')
type vwanPeeringType = {
  @description('Optional. Whether to create virtual hub connection.')
  enabled: bool?

  @description('Optional. Enable internet security.')
  enableInternetSecurity: bool?

  @description('Optional. Indicates whether routing intent is enabled on the Virtual HUB within the virtual WAN.')
  routingIntentEnabled: bool?

  @description('Optional. The resource ID of the virtual hub route table to associate to the virtual hub connection (this virtual network). If left blank/empty default route table will be associated.')
  associatedRouteTableResourceId: string?

  @description('Optional. An array of virtual hub route table resource IDs to propagate routes to. If left blank/empty default route table will be propagated to only.')
  propagatedRouteTablesResourceIds: array[]

  @description('Optional. An array of virtual hub route table labels to propagate routes to. If left blank/empty default label will be propagated to only.')
  propagatedLabels: array[]
}?

@export()
@description('The type for Virtual Network Gateway configuration.')
type virtualNetworkGatewayType = {
  @description('Optional. Name of the Virtual Network gateway.')
  name: string?

  @description('Required. Type of gateway.')
  gatewayType: ('Vpn' | 'ExpressRoute')

  @description('Required. SKU of the gateway.')
  sku: (
    | 'Basic'
    | 'VpnGw1AZ'
    | 'VpnGw2AZ'
    | 'VpnGw3AZ'
    | 'VpnGw4AZ'
    | 'VpnGw5AZ'
    | 'ErGw1AZ'
    | 'ErGw2AZ'
    | 'ErGw3AZ'
    | 'ErGwScale'
    | 'HighPerformance'
    | 'Standard'
    | 'UltraPerformance')

  @description('Required. Type of VPN.')
  vpnType: ('PolicyBased' | 'RouteBased')

  @description('Required. Generation of the VPN Gateway.')
  vpnGatewayGeneration: ('Generation1' | 'Generation2' | 'None')

  @description('Required. Enable BGP on the gateway.')
  enableBgp: bool

  @description('Required. Enable Active-Active on the gateway.')
  activeActive: bool

  @description('Optional. Enable BGP Route Translation for NAT on the gateway.')
  enableBgpRouteTranslationForNat: bool?

  @description('Optional. Enable DNS Forwarding on the gateway.')
  enableDnsForwarding: bool?

  @description('Optional. BGP Settings for the gateway.')
  bgpSettings: {
    @minValue(0)
    @maxValue(4294967295)
    @description('Optional. ASN for the gateway.')
    asn: int?

    @description('Optional. Peer Weight for the gateway.')
    peerWeight: int?
  }?

  @description('Optional. VPN Client Configuration for the gateway.')
  vpnClientConfiguration: object?
}

// Local Network Gateway Types
import {
  bgpSettingsType
} from 'br/public:avm/res/network/local-network-gateway:0.4.0'
@export()
@description('The Local Network Gateway Type.')
type localNetworkGatewayType = {
  @minLength(1)
  @maxLength(64)
  @description('Required. Name of the Local Network Gateway.')
  name: string

  @description('Required. List of the local (on-premises) IP address ranges.')
  localAddressPrefixes: string[]

  @description('Required. Public IP of the local gateway.')
  localGatewayPublicIpAddress: string

  @description('Optional. Local network gateway\'s BGP speaker settings.')
  bgpSettings: bgpSettingsType?

  @description('Optional. FQDN of local network gateway.')
  fqdn: string?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?
}[]

// VPN Connection Types
import {
  customIPSecPolicyType
  trafficSelectorPolicyType
} from 'br/public:avm/res/network/connection:0.1.5'
@export()
@description('The type for VPN configuration.')
type hubVpnConnectionType = {
  @description('Optional. The type for VPN Link Connections.')
  vpnLinkConnections: {
    @description('Required. Name of the VPN link connection.')
    name: string

    @description('Optional. Value to specify if BGP is enabled or not.')
    enableBgp: bool?

    @description('Optional. Gateway connection connectionType.')
    connectionType: 'IPsec' | 'Vnet2Vnet' | 'ExpressRoute' | 'VPNClient'

    @description('Optional. Connection connectionProtocol used for this connection. Available for IPSec connections.')
    connectionProtocol: 'IKEv1' | 'IKEv2'

    @description('Optional. The weight added to routes learned from this BGP speaker.')
    routingWeight: int?

    @description('Optional. Bypass the ExpressRoute gateway when accessing private-links. ExpressRoute FastPath (expressRouteGatewayBypass) must be enabled. Only available when connection connectionType is Express Route.')
    enablePrivateLinkFastPath: bool?

    @description('Optional. Bypass ExpressRoute Gateway for data forwarding. Only available when connection connectionType is Express Route.')
    expressRouteGatewayBypass: bool?

    @minValue(9)
    @maxValue(3600)
    @description('Optional. The dead peer detection timeout of this connection in seconds. Setting the timeout to shorter periods will cause IKE to rekey more aggressively, causing the connection to appear to be disconnected in some instances. The general recommendation is to set the timeout between 30 to 45 seconds.')
    dpdTimeoutSeconds: int?

    @description('Optional. The connection connectionMode for this connection. Available for IPSec connections.')
    connectionMode: 'Default' | 'InitiatorOnly' | 'ResponderOnly'

    @description('Optional. Use private local Azure IP for the connection. Only available for IPSec Virtual Network Gateways that use the Azure Private IP Property.')
    useLocalAzureIpAddress: bool?

    @description('Optional. Enable policy-based traffic selectors.')
    usePolicyBasedTrafficSelectors: bool?

    @description('Optional. The traffic selector policies to be considered by this connection.')
    trafficSelectorPolicies: trafficSelectorPolicyType[]?

    @description('Optional. The IPSec Policies to be considered by this connection.')
    customIPSecPolicy: customIPSecPolicyType?

    @description('Optional. The lock settings of the service.')
    lock: commonTypes.lockType?

    @description('Optional. Array of role assignments to create.')
    roleAssignments: commonTypes.roleAssignmentType[]?
  }[]?
}

@export()
@description('The type for vWAN VPN configuration.')
type vwanVpnConnectionType = {
  @description('Required. VPN Site Configuration.')
  vpnSite: {
    @description('Required. Name of the VPN Site.')
    name: string

    @description('Optional. An array of IP address ranges that can be used by subnets of the virtual network. Required if no bgpProperties or VPNSiteLinks are configured.')
    addressPrefixes: string[]?

    @description('Optional. List of properties of the device.')
    deviceProperties: {
      @description('Model of the device.')
      deviceModel: string?

      @description('Device vendor.')
      deviceVendor: string?

      @description('Link speed.')
      linkSpeedInMbps: int?
    }?
  }[]

  @description('Optional. List of all VPN site links.')
  vpnSiteLinks: {
    @description('Required. Name of the VPN Site Link.')
    name: string

    @description('The set of bgp properties.')
    bgpProperties: {
      @description('Optional. The BGP peering address and BGP identifier of this BGP speaker.')
      bgpPeeringAddress: string?

      @description('Optional. The BGP speaker ASN.')
      asn: int?
    }?

    @description('The link provider properties.')
    linkProperties: {
      @description('Name of the link provider.')
      linkProviderName: string?

      @description('Link speed.')
      linkSpeedInMbps: int?
    }

    @description('The ip-address for the vpn-site-link.')
    ipAddress: string

    @description('FQDN of vpn-site-link.')
    fqdn: string
  }[]?

  @description('Optional. The type for VPN Link Connections.')
  vpnLinkConnections: {
    @description('Required. Name of the VPN link connection.')
    name: string

    @description('Optional. Expected bandwidth in MBPS.')
    connectionBandwidth: int?

    @description('Optional. Value to specify if BGP is enabled or not.')
    enableBgp: bool?

    @description('Optional. The IPSec Policies to be considered by this connection.')
    ipsecPolicies: {
      @description('Required. The IPSec Security Association (also called Quick Mode or Phase 2 SA) lifetime in seconds for a site to site VPN tunnel.')
      saLifeTimeSeconds: int

      @description('Required. The IPSec Security Association (also called Quick Mode or Phase 2 SA) payload size in KB for a site to site VPN tunnel.')
      saDataSizeKilobytes: int

      @description('Required. The IPSec encryption algorithm (IKE phase 1).')
      ipsecEncryption:
        | 'AES128'
        | 'AES192'
        | 'AES256'
        | 'DES'
        | 'DES3'
        | 'GCMAES128'
        | 'GCMAES192'
        | 'GCMAES256'
        | 'None'

      @description('Required. The IPSec integrity algorithm (IKE phase 1).')
      ipsecIntegrity: 'GCMAES128' | 'GCMAES192' | 'GCMAES256' | 'MD5' | 'SHA1' | 'SHA256'

      @description('Required. The IKE encryption algorithm (IKE phase 2).')
      ikeEncryption: 'AES128' | 'AES192' | 'AES256' | 'DES' | 'DES3' | 'GCMAES128' | 'GCMAES256'

      @description('Required. The IKE integrity algorithm (IKE phase 2).')
      ikeIntegrity: 'GCMAES128' | 'GCMAES256' | 'MD5' | 'SHA1' | 'SHA256' | 'SHA384'

      @description('Required. The DH Group used in IKE Phase 1 for initial SA.')
      dhGroup: 'None' | 'DHGroup1' | 'DHGroup2' | 'DHGroup14' | 'DHGroup2048' | 'DHGroup24' | 'ECP256' | 'ECP384'

      @description('Required. The Pfs Group used in IKE Phase 2 for new child SA.')
      pfsGroup: 'ECP256' | 'ECP384' | 'None' | 'PFS1' | 'PFS14' | 'PFS2' | 'PFS2048' | 'PFS24' | 'PFSMM'
    }[]?

    @description('Optional. Routing weight for vpn connection.')
    routingWeight: int?

    @description('Optional. Use private local Azure IP for the connection. Only available for IPSec Virtual Network Gateways that use the Azure Private IP Property.')
    useLocalAzureIpAddress: bool?

    @description('Optional. Enable policy-based traffic selectors.')
    usePolicyBasedTrafficSelectors: bool?

    @description('Optional. Connection protocol used for this connection.')
    vpnConnectionProtocolType: ('IKEv1' | 'IKEv2')?

    @description('Optional. vpnGatewayCustomBgpAddresses used by this connection.')
    vpnGatewayCustomBgpAddresses: {
      @description('Required. The custom BgpPeeringAddress which belongs to IpconfigurationId.')
      customBgpIpAddress: string

      @description('Required. The IpconfigurationId of ipconfiguration which belongs to gateway..')
      ipConfigurationId: string
    }[]?

    @description('Optional. Vpn link connection mode.')
    vpnLinkConnectionMode: 'Default' | 'InitiatorOnly' | 'ResponderOnly'
  }[]?
}

// Common Types
@export()
@description('The type for Azure Action Group configuration.')
type actionGroupConfigurationType = {
  @minLength(1)
  @maxLength(260)
  @description('Optional. The name of the Action Group.')
  name: string?

  @description('Optional. The shortname of the Action Group.')
  groupShortName: string?

  @description('Optional. The list of email receivers that are part of this action group.')
  emailReceivers: array?
}

@export()
@description('The type for Azure Budget configuration.')
type budgetConfigurationType = {
  @description('Optional. Deployment flag for Azure Budgets.')
  enabled: bool?

  @description('Optional. Budget  Type.')
  budgets: budgetType[]?
}

@export()
@description('The type for Azure Budgets')
type budgetType = {
  @minLength(1)
  @maxLength(63)
  @description('Required. The name of the budget.')
  name: string

  @description('Optional. The category of the budget, whether the budget tracks cost or usage.')
  category: 'Cost' | 'Usage'?

  @description('Required. The total amount of cost or usage to track with the budget.')
  amount: int

  @description('Optional. The type of threshold to use for the budget. The threshold type can be either `Actual` or `Forecasted`.')
  thresholdType: 'Actual' | 'Forecasted'?

  @maxLength(5)
  @description('Optional. Percent thresholds of budget for when to get a notification. Can be up to 5 thresholds, where each must be between 1 and 1000.')
  thresholds: array?

  @description('Conditional. The list of email addresses to send the budget notification to when the thresholds are exceeded. Required if neither `contactRoles` nor `actionGroups` was provided.')
  contactEmails: array?
}

// Role Permissions Types
@export()
@description('The type for Role Assignment configuration.')
type roleAssignmentConfigurationType = roleAssignmentType[]?

@export()
@description('The type for Role Assignments.')
type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @maxLength(36)
  @description('Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.')
  subscriptionId: string?

  @description('Name of the Resource Group to assign the RBAC role to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided RBAC role to the resource group.')
  resourceGroupName: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}?

@export()
@description('The type for Privileged Identity Management role assignment configuration.')
type pimRoleAssignmentConfigurationType = pimRoleAssignmentType[]?

@export()
@description('The type for Privileged Identity Management role assignment.')
type pimRoleAssignmentType = {
  @description('Principal (user or service principal) object ID.')
  principalId: string

  @description('ID of the role definition.')
  roleDefinitionId: string

  @description('The ISO 8601 time duration for eligibility.')
  duration: string

  @description('Defines how eligibility ends.')
  expirationType: ('AfterDateTime' | 'AfterDuration' | 'NoExpiration')?

  @description('Reason or note justifying the request.')
  justification: string

  @description('Type of eligibility request (e.g., AdminAssign, AdminExtend, etc.).')
  requestType: (
    | 'AdminAssign'
    | 'AdminExtend'
    | 'AdminRemove'
    | 'AdminRenew'
    | 'AdminUpdate'
    | 'SelfActivate'
    | 'SelfDeactivate'
    | 'SelfExtend'
    | 'SelfRenew')

  @description('Optional. Random for the deployment name (true or false).')
  deploymentSeedRandom: bool?
}

// Platform Management LZ
// Azure Container Registry Configuration Type
@export()
@description('The type for Azure Container Registry configuration.')
type containerRegistryConfigurationType = {
  @description('Optional. Deployment flag for Azure Container Registry Service.')
  enabled: bool?

  @description('Optional. Deployment flag for Azure Container Registry Service Private Endpoint.')
  deployPrivateEndpoint: bool?

  @minLength(5)
  @maxLength(50)
  @description('Optional. The name of the container registry, Container registry names must be globally unique.')
  name: string?

  @description('Optional. Whether the trust policy is enabled for the container registry. Defaults to \'enabled\'.')
  trustPolicyStatus: 'enabled' | 'disabled'?

  @description('Optional. Tier of your Azure container registry.')
  sku: 'Basic' | 'Standard' | 'Premium'?

  @description('Optional. This value can be set to \'Enabled\' to avoid breaking changes on existing customer resources and templates. If set to \'Disabled\', traffic over public interface is not allowed, and private endpoint connections would be the exclusive access method.')
  publicNetworkAccess: 'Enabled' | 'Disabled'?

  @description('Optional. Soft Delete policy status. Default is disabled.')
  softDeletePolicyStatus: 'disabled' | 'enabled'?

  @description('Optional. The number of days after which a soft-deleted item is permanently deleted.')
  softDeletePolicyDays: int?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType[]?

  @description('Optional. Enable admin user that have push / pull permission to the registry.')
  acrAdminUserEnabled: bool?

  @description('Optional. The value that indicates whether the export policy is enabled or not.')
  exportPolicyStatus: 'disabled' | 'enabled'?

  @description('Optional. Whether or not zone redundancy is enabled for this container registry.')
  zoneRedundancy: 'Disabled' | 'Enabled'?

  @description('Optional. Whether to allow trusted Azure services to access a network restricted registry.')
  networkRuleBypassOptions: 'AzureServices' | 'None'?

  @description('Optional. Enables registry-wide pull from unauthenticated clients. It\'s in preview and available in the Standard and Premium service tiers.')
  anonymousPullEnabled: bool?
}

// Azure Storage Account Configuration Type
@export()
@description('The type for Azure Storage Account configuration.')
type storageAccountConfigurationType = {
  @description('Optional. Deployment flag for Azure Storage.')
  enabled: bool?

  @minLength(3)
  @maxLength(24)
  @description('Optional. The name of the storage account, Storage Account names must be globally unique.')
  name: string?

  @description('Optional. Storage account SKU. Defaults to \'Standard_ZRS\'.')
  skuName:
    | 'Standard_LRS'
    | 'Standard_GRS'
    | 'Standard_RAGRS'
    | 'Standard_ZRS'?
    | 'Premium_LRS'
    | 'Premium_ZRS'
    | 'Standard_GZRS'
    | 'Standard_RAGZRS'

  @description('Optional. Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Microsoft Entra ID. Defaults to \'false\'.')
  allowSharedKeyAccess: bool?

  @description('Optional. Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false.')
  allowBlobPublicAccess: bool?

  @description('Optional. A boolean flag which indicates whether the default authentication is OAuth or not.')
  defaultToOAuthAuthentication: bool?

  @description('Optional. Allow large file shares if sets to \'Enabled\'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares).')
  largeFileSharesState: 'Disabled' | 'Enabled'?

  @description('Optional. Type of Storage Account to create.')
  kind: ('StorageV2' | 'StorageV2' | 'BlobStorage' | 'FileStorage' | 'BlockBlobStorage')?

  @description('Conditional. Required if the Storage Account kind is set to BlobStorage. The access tier is used for billing. The "Premium" access tier is the default value for premium block blobs storage account type and it cannot be changed for the premium block blobs storage account type.')
  accessTier: ('Premium' | 'Hot' | 'Cool' | 'Cold')?

  @description('Optional. Set the minimum TLS version on request to storage. The TLS versions 1.0 and 1.1 are deprecated and not supported anymore.')
  minimumTlsVersion: ('TLS1_2' | 'TLS1_3')?

  @description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.')
  publicNetworkAccess: ('' | 'Enabled' | 'Disabled')

  @description('Optional. Allows HTTPS traffic only to storage service if sets to true.')
  supportsHttpsTrafficOnly: bool?

  @description('Optional. The Azure Blob Container values.')
  containers: blobContainersType[]?

  @description('Optional. The Azure File Services values.')
  shares: fileSharesType[]?

  @description('Optional. Indicates whether containerDeleteRetentionPolicyEnabled is enabled.')
  containerDeleteRetentionPolicyEnabled: bool?

  @minValue(1)
  @maxValue(365)
  @description('Optional. Indicates the number of days that the deleted item should be retained.')
  containerDeleteRetentionPolicyDays: int?

  @description('Optional. Indicates whether deleteRetentionPolicyEnabled is enabled.')
  deleteRetentionPolicyEnabled: bool?

  @minValue(1)
  @maxValue(365)
  @description('Optional. Indicates the number of days that the deleted blob should be retained.')
  deleteRetentionPolicyDays: int?

  @description('Optional. Indicates whether shareDeleteRetentionPolicy is enabled.')
  shareDeleteRetentionPolicyEnabled: bool?

  @minValue(1)
  @maxValue(365)
  @description('Optional. The service properties for soft delete.')
  shareDeleteRetentionPolicyDays: int?
}

// Azure Blob Container Configuration Type
@description('The type for Azure Storage Account Blob Container configuration.')
type blobContainersType = {
  @minLength(3)
  @maxLength(63)
  @description('Required. The name of the Blob Container.')
  name: string

  @description('Specifies whether data in the container may be accessed publicly and the level of access.')
  publicAccess: 'None' | 'Blob' | 'Container'
}

// Azure File Share Configuration Type
@description('The type for Azure Storage Account File Shares configuration.')
type fileSharesType = {
  @minLength(3)
  @maxLength(63)
  @description('Required. The name of the File Share.')
  name: string

  @description('The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5120 (5TB). For Large File Shares, the maximum size is 102400 (100TB)..')
  @minValue(0)
  @maxValue(102400)
  shareQuota: int?
}

// Log Analytics Workspace Configuration Type
@export()
@description('The type for Log Analytics configuration.')
type logAnalyticsConfigurationType = {
  @description('Optional. Deployment flag for Log Analytics Workspace.')
  enabled: bool?

  @minLength(4)
  @maxLength(63)
  @description('Optional. The name of the Log Analytics workspace.')
  name: string?

  @description('Optional. The existing Log Analytics Workspace Resource Id.')
  existingLogAnalyticsWorkspaceResourceId: string?

  @description('Optional. The name of the SKU.')
  skuName: (
    | 'CapacityReservation'
    | 'Free'
    | 'LACluster'
    | 'PerGB2018'
    | 'PerNode'
    | 'Premium'
    | 'Standalone'
    | 'Standard')?

  @minValue(0)
  @maxValue(730)
  @description('Optional. Number of days data will be retained for.')
  dataRetention: int?

  @description('Optional. The network access type for accessing Log Analytics ingestion.')
  publicNetworkAccessForIngestion: ('Enabled' | 'Disabled')?

  @description('Optional. The network access type for accessing Log Analytics query.')
  publicNetworkAccessForQuery: ('Enabled' | 'Disabled')?

  @minValue(100)
  @maxValue(5000)
  @description('Optional. The capacity reservation level in GB for this workspace, when CapacityReservation sku is selected. Must be in increments of 100 between 100 and 5000.')
  skuCapacityReservationLevel: 100 | 200 | 300 | 400 | 500 | 1000 | 2000 | 5000?

  @description('Optional. The workspace daily quota for ingestion.')
  @minValue(-1)
  dailyQuotaGb: int?
}

@description('Defines the schema for a Log Analytics Custom Table.')
type LogAnalyticsCustomTableSchema = {
  name: string
  columns: {
    name: string
    type: 'boolean' | 'dateTime' | 'dynamic' | 'guid' | 'int' | 'long' | 'real' | 'string'
    displayName: string?
    description: string?
    dataTypeHint: 'armPath' | 'guid' | 'ip' | 'uri'?
  }[]
}

@export()
@description('Defines a Log Analytics Custom Table.')
type LogAnalyticsCustomTable = {
  name: string
  schema: LogAnalyticsCustomTableSchema
  retentionInDays: int
}
