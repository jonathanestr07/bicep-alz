import * as shared from '../../configuration/shared.conf.bicep'
import * as type from '../../configuration/shared.type.bicep'

targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Azure Platform Identity Orchestration Module'
metadata description = 'Module used to create Azure Platform Identity resources.'
metadata version = '1.1.0'
metadata author = 'Insight APAC Platform Engineering'

// Subscription Module Parameters
@description('Required. Specifies the Landing Zone prefix for the deployment.')
param lzPrefix string

@description('Required. Specifies the environment prefix for the deployment.')
param envPrefix string

@description('Optional. The Azure Region to deploy the resources into.')
param location string = deployment().location

@description('Required. Prefix for the management group hierarchy.')
@minLength(2)
@maxLength(10)
param topLevelManagementGroupPrefix string = 'alz'

@description('Required. The Subscription Id for the deployment.')
@maxLength(36)
param subscriptionId string

@description('Optional. Tags that will be applied to all resources in this module.')
param tags type.tagsType

@description('Optional. The Management Group Id to place the subscription in.')
param subscriptionMgPlacement string = ''

// Spoke Networking Module Parameters

@description('Optional. Configuration for Azure Virtual Network.')
param virtualNetworkConfiguration type.virtualNetworkType?

// Virtual Networking Peering Modules Parameters
@description('Optional. Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.')
param virtualNetworkPeeringEnabled bool = true

@description('Optional. Specifies the resource Id of the Hub Virtual Network, or Azure Virtual WAN hub Id.')
param hubVirtualNetworkId string = ''

@description('Optional. Switch to enable/disable forwarded Traffic from outside spoke network.')
param allowSpokeForwardedTraffic bool = true

@description('Optional. Switch to enable/disable VPN Gateway for the hub network peering.')
param allowHubVpnGatewayTransit bool = true

// Key Vault Module Parameters

@description('Optional Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments array = []

@description('Optional. Service endpoint object information of Azure Key Vault. For security reasons, it is recommended to set the DefaultAction Deny.')
param networkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
  virtualNetworkRules: []
  ipRules: []
}

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkAcls are not set.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

// Subscription Budget Module Parameters
@description('Optional. Configuration for Azure Budgets.')
param budgetConfiguration type.budgetConfigurationType?

@description('Optional. Date timestamp.')
param startDate string = '${utcNow('yyyy')}-${utcNow('MM')}-01T00:00:00Z'

// Virtual Machines Active Directory Domain Services(adds) Module Parameters

@description('Optional. Prefix of the ADDS VMs.')
param addsVmPrefix string = 'azaue'

@description('Optional. Whether to enable deployment of ADDS Virtual Machines.')
param deployAdds bool = false // Set to true to deploy ADDS VMs

@description('Optional. Password for the Adds virtual machine(s).')
@secure()
param addsPassword string = newGuid() // This default parameter should be always overridden by CI/CD pipeline using a secure parameter injection

@description('Optional. Virtual Machine ADDS to create.') // Update the required parameters for the virtual machine prior to deployment
param virtualMachines_Adds array = [
  {
    availabilityZone: 1
    vmSize: 'Standard_D2s_v5'
    osType: 'Windows'
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-Datacenter'
      version: 'latest'
    }
    storageProfile: {
      osDisk: {
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    dataDisks: [
      {
        diskSizeGB: 32
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
  }
  {
    availabilityZone: 2
    vmSize: 'Standard_D2s_v5'
    osType: 'Windows'
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-Datacenter'
      version: 'latest'
    }
    storageProfile: {
      osDisk: {
        diskSizeGB: 128
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    }
    dataDisks: [
      {
        diskSizeGB: 32
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
    ]
  }
]

@description('Whether to enable automatic updates on the virtual machines.')
param enableAddsAutomaticUpdates bool = true

// Orchestration Variables
var argPrefix = toLower('${shared.resPrefixes.resourceGroup}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var vntPrefix = toLower('${shared.resPrefixes.virtualNetwork}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}-')
var nsgPrefix = toLower('${shared.resPrefixes.networkSecurityGroup}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}-')
var udrPrefix = toLower('${shared.resPrefixes.routeTable}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}-')
var akvPrefix = toLower('${shared.resPrefixes.keyVault}${shared.locPrefixes[location]}${lzPrefix}')

var deployBudgets = budgetConfiguration.?enabled ?? true
var deployVirtualNetwork = virtualNetworkConfiguration.?enabled ?? true

var hubVirtualNetworkName = (!empty(hubVirtualNetworkId) && contains(
    hubVirtualNetworkId,
    '/providers/Microsoft.Network/virtualNetworks/'
  )
  ? split(hubVirtualNetworkId, '/')[8]
  : '')
var hubVirtualNetworkResourceGroup = (!empty(hubVirtualNetworkId) && contains(
    hubVirtualNetworkId,
    '/providers/Microsoft.Network/virtualNetworks/'
  )
  ? split(hubVirtualNetworkId, '/')[4]
  : '')
var hubVirtualNetworkSubscriptionId = (!empty(hubVirtualNetworkId) && contains(
    hubVirtualNetworkId,
    '/providers/Microsoft.Network/virtualNetworks/'
  )
  ? split(hubVirtualNetworkId, '/')[2]
  : '')

var resourceGroups = {
  network: '${argPrefix}-network'
  security: '${argPrefix}-security'
  adds: '${argPrefix}-adds'
}

var maxNameLength = 24
var uniquenameUntrim = '${akvPrefix}${uniqueString(subscriptionId)}'

var vnetAddressSpace = replace(virtualNetworkConfiguration.?addressPrefix!, '/', '_')

var resourceNames = {
  keyVault: (length(uniquenameUntrim) > maxNameLength ? substring(uniquenameUntrim, 0, maxNameLength) : uniquenameUntrim)
  virtualMachine_Adds: '${addsVmPrefix}adds'
  virtualNetwork: '${vntPrefix}${vnetAddressSpace}'
}

var adminUsername_Adds = 'adminAddsHost'

@description('Module: Subscription Placement')
module subscriptionPlacement '../../modules/subscriptionPlacement/subscriptionPlacement.bicep' = if (!empty(subscriptionMgPlacement)) {
  scope: managementGroup(topLevelManagementGroupPrefix)
  name: 'subscriptionPlacement-${guid(deployment().name)}'
  params: {
    targetManagementGroupId: subscriptionMgPlacement
    subscriptionIds: [
      subscriptionId
    ]
  }
}

@description('Module: Subscription Tags')
module subscriptionTags '../../modules/CARML/resources/tags/main.bicep' = if (!empty(tags)) {
  scope: subscription(subscriptionId)
  name: 'subTags-${guid(deployment().name)}'
  params: {
    subscriptionId: subscriptionId
    location: location
    onlyUpdate: false
    tags: tags
  }
}

@description('Module: Azure Budgets - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/consumption/budget')
module budget 'br/public:avm/res/consumption/budget:0.3.8' = [
  for (bg, index) in (budgetConfiguration.?budgets ?? []): if (!empty(budgetConfiguration) && deployBudgets) {
    name: take('budget-${guid(deployment().name)}-${index}', 64)
    scope: subscription(subscriptionId)
    params: {
      // Required parameters
      amount: bg.amount
      name: bg.name
      // Non-required parameters
      contactEmails: bg.contactEmails
      location: location
      startDate: startDate
      thresholdType: bg.thresholdType
      thresholds: bg.thresholds
    }
  }
]

@description('Resource Groups (Common) - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/resources/resource-group')
module commonResourceGroups 'br/public:avm/res/resources/resource-group:0.4.1' = [
  for commonResourceGroup in shared.commonResourceGroupNames: {
    name: take('commonResourceGroups-${commonResourceGroup}', 64)
    scope: subscription(subscriptionId)
    params: {
      // Required parameters
      name: commonResourceGroup
      // Non-required parameters
      location: location
      tags: tags
    }
  }
]

@description('Module: Network Watcher - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/network/network-watcher')
module networkWatcher 'br/public:avm/res/network/network-watcher:0.4.1' = if (deployVirtualNetwork) {
  name: take('networkWatcher-${guid(deployment().name)}', 64)
  scope: resourceGroup(subscriptionId, 'networkWatcherRG')
  dependsOn: [
    commonResourceGroups
  ]
  params: {
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: Resource Group (Network)')
module resourceGroupForNetwork 'br/public:avm/res/resources/resource-group:0.4.1' = if (deployVirtualNetwork) {
  scope: subscription(subscriptionId)
  name: 'resourceGroupForNetwork-${guid(deployment().name)}'
  params: {
    // Required parameters
    name: resourceGroups.network
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: Spoke Networking')
module spokeNetworking '../../modules/spokeNetworking/spokeNetworking.bicep' = if (deployVirtualNetwork && !empty(virtualNetworkConfiguration.?addressPrefix)) {
  scope: resourceGroup(subscriptionId, resourceGroups.network)
  name: 'spokeNetworking-${guid(deployment().name)}'
  dependsOn: [
    resourceGroupForNetwork
  ]
  params: {
    location: location
    nsgPrefix: nsgPrefix
    tags: tags
    udrPrefix: udrPrefix
    virtualNetworkConfiguration: virtualNetworkConfiguration
    vntPrefix: vntPrefix
  }
}

@description('Module: Virtual Network Peering (Hub to Spoke)')
module hubPeeringToSpoke '../../modules/vnetPeering/vnetPeering.bicep' = if (deployVirtualNetwork && virtualNetworkPeeringEnabled && !empty(hubVirtualNetworkId)) {
  scope: resourceGroup(hubVirtualNetworkSubscriptionId, hubVirtualNetworkResourceGroup)
  name: 'hubPeeringToSpoke-${guid(deployment().name)}'
  params: {
    sourceVirtualNetworkName: hubVirtualNetworkName
    destinationVirtualNetworkName: (!empty(hubVirtualNetworkName) ? spokeNetworking!.outputs.virtualNetworkName : '')
    destinationVirtualNetworkId: (!empty(hubVirtualNetworkName) ? spokeNetworking!.outputs.virtualNetworkId : '')
    allowForwardedTraffic: allowSpokeForwardedTraffic
    allowGatewayTransit: allowHubVpnGatewayTransit
  }
}

@description('Module: Virtual Network Peering (Spoke to Hub)')
module spokePeeringToHub '../../modules/vnetPeering/vnetPeering.bicep' = if (deployVirtualNetwork && virtualNetworkPeeringEnabled && !empty(hubVirtualNetworkId)) {
  scope: resourceGroup(subscriptionId, resourceGroups.network)
  name: 'spokePeeringToHub-${guid(deployment().name)}'
  params: {
    sourceVirtualNetworkName: (!empty(hubVirtualNetworkName) ? spokeNetworking!.outputs.virtualNetworkName : '')
    destinationVirtualNetworkName: hubVirtualNetworkName
    destinationVirtualNetworkId: hubVirtualNetworkId
    allowForwardedTraffic: allowSpokeForwardedTraffic
    useRemoteGateways: allowHubVpnGatewayTransit
  }
}

@description('Module: Resource Group (ADDS)')
module resourceGroupForAdds 'br/public:avm/res/resources/resource-group:0.4.1' = if (deployAdds) {
  scope: subscription(subscriptionId)
  name: 'resourceGroupForAdds-${guid(deployment().name)}'
  params: {
    // Required parameters
    name: resourceGroups.adds
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: Key Vault dedicated to ADDS')
module KeyVault 'br/public:avm-res-keyvault-vault:0.1.0' = if (deployAdds) {
  scope: resourceGroup(subscriptionId, resourceGroups.adds)
  name: 'keyVault-${guid(deployment().name)}'
  dependsOn: [
    resourceGroupForAdds
  ]
  params: {
    // Required parameters
    name: resourceNames.keyVault
    // Non-required parameters
    location: location
    tags: tags
    enableRbacAuthorization: true
    enablePurgeProtection: true
    networkAcls: networkAcls
    publicNetworkAccess: publicNetworkAccess
    roleAssignments: roleAssignments
    secrets: {
      name: 'virtualMachineAddsPassword'
      value: addsPassword
    }
  }
}

@description('Module: Virtual Machines for ADDS')
module virtualMachine_Adds '../../modules/virtualMachine/virtualMachine.bicep' = [
  for i in range(1, length(virtualMachines_Adds)): if (deployAdds) {
    name: take('virtualMachine_Adds-${guid(deployment().name)}-${i}', 64)
    scope: resourceGroup(subscriptionId, resourceGroups.adds)
    dependsOn: [
      resourceGroupForAdds
      resourceGroupForNetwork
      spokeNetworking
      KeyVault
    ]
    params: {
      tags: tags
      virtualMachines: virtualMachines_Adds
      location: location
      adminUsername: adminUsername_Adds
      keyVaultName: resourceNames.keyVault
      secretName: 'virtualMachineAddsPassword'
      virtualMachineName: resourceNames.virtualMachine_Adds
      enableAutomaticUpdates: enableAddsAutomaticUpdates
      resourceGroupNamevNet: resourceGroups.network
      virtualNetworkName: resourceNames.virtualNetwork
      subnetName: 'adds'
    }
  }
]
