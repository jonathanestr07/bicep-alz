import * as shared from '../../configuration/shared.conf.bicep'
import * as type from '../../configuration/shared.type.bicep'

targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Azure Platform Management Orchestration Module'
metadata description = 'Module used to create Azure Platform Management resources.'
metadata version = '2.0.1'
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

// Logging Module Parameters
@description('Optional. Whether to deploy the logging module or not.')
param loggingEnabled bool = true

@description('Optional. Configuration for Log Analytics.')
param logAnalyticsConfiguration type.logAnalyticsConfigurationType?

@description('Optional. Log Analytics Custom Tables to be deployed.')
param logAnalyticsCustomTables type.LogAnalyticsCustomTable[] = []

@allowed([
  'SecurityInsights'
  'ChangeTracking'
  'SQLVulnerabilityAssessment'
])
@description('Optional. Solutions that will be added to the Log Analytics Workspace.]')
param logAnalyticsWorkspaceSolutions array = [
  'SecurityInsights'
  'ChangeTracking'
  'SQLVulnerabilityAssessment'
]

@description('Optional. Configuration for Azure Storage Account.')
param storageAccountConfiguration type.storageAccountConfigurationType?

// Spoke Networking Module Parameters

@description('Optional. Configuration for Azure Virtual Network.')
param virtualNetworkConfiguration type.virtualNetworkType?

// Virtual Networking Peering Modules Parameters
@description('Optional. Whether to enable peering/connection with the supplied hub Virtual Network or Virtual WAN Virtual Hub.')
param virtualNetworkPeeringEnabled bool = true

@description('Optional. Specifies the resource Id of the Hub Virtual Network, or Azure Virtuel WAN hub Id.')
param hubVirtualNetworkId string = ''

@description('Optional. Switch to enable/disable forwarded Traffic from outside spoke network.')
param allowSpokeForwardedTraffic bool = true

@description('Optional. Switch to enable/disable VPN Gateway for the hub network peering.')
param allowHubVpnGatewayTransit bool = true

// Subscription Budget Module Parameters
@description('Optional. Configuration for Azure Budgets.')
param budgetConfiguration type.budgetConfigurationType?

@description('Optional. Date timestamp.')
param startDate string = '${utcNow('yyyy')}-${utcNow('MM')}-01T00:00:00Z'

// Action Group Module Parameters
@description('Optional. Configuration for Action Groups.')
param actionGroupConfiguration type.actionGroupConfigurationType?

// ACR
@description('Optional. Configuration for Azure Container Registry.')
param containerRegistryConfiguration type.containerRegistryConfigurationType?

// Sentinel Module Parameters
@description('Optional. Whether to deploy Azure Sentinel.')
param deploySentinel bool = false

@description('Required. Date when the Sentinel solution was first deployed, must be in YYYY-MM-DD format.')
param sentinelFirstDeploymentDate string = ''

@description('Optional. Array of Microsoft Sentinel Content Solutions to deploy.')
param sentinelContentSolutions array = []

// Kafka Module Parameters
@description('Optional. Whether to deploy Kafka resources.')
param deployKafka bool = false

@description('Optional. Configuration for Kafka Private Endpoints.')
param KafkaPrivateEndpointConfigs array = []

@description('Optional. The subnet resource Id for Kafka Private Endpoints.')
param subnetResourceIdforKafka string = ''

// Virtual Machines Jumphosts Module Parameters
@description('Optional. Virtual Machine jump hosts to create.')
param virtualMachines_Jumphosts array = [
  {
    vmSize: 'Standard_D2s_v3'
    osType: 'Windows'
    imageReference: {
      publisher: 'center-for-internet-security-inc'
      offer: 'cis-windows-server'
      sku: 'cis-windows-server2022-l1-gen2'
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
  }
]

@description('Optional. Password for the Jump Host virtual machine(s).')
@secure()
param jumpHostPassword string = newGuid() // This default parameter should be always overridden by CI/CD pipeline using a secure parameter injection

@description('Whether to enable automatic updates on the virtual machines.')
param enableJumphostAutomaticUpdates bool = true

// Update Management Module Parameters

@description('Optional. Whether to deploy Azure Update Management.')
param deployUpdateManagement bool = false

@description('Maintenance Window Configuration for Azure Update Manager.')
param maintenanceWindow object = {
  startDateTime: '2024-12-06 02:00'
  duration: '03:55'
  timeZone: 'W. Australia Standard Time'
  expirationDateTime: null
  recurEvery: '1Day'
}

@description('Optional. The reboot setting for the maintenance configuration')
param rebootSetting string = 'IfRequired'

// Defender EASM Module Parameters
@description('Optional. Whether to deploy Defender EASM.')
param deployEASM bool = false

@description('Optional. The Defender EASM instance name.')
param defenderEASMName string = 'DefenderEASM'

// GitHub (Hosted Virtual Network integrated) Module Parameters
@description('Optional. The GitHub database Id.')
param GitHubDatabaseId string = '' // See https://docs.github.com/en/enterprise-cloud@latest/admin/configuring-settings/configuring-private-networking-for-hosted-compute-products/configuring-private-networking-for-github-hosted-runners-in-your-enterprise#1-obtain-the-databaseid-for-your-enterprise

@description('Optional. The subnet resource Id for GitHub Private Endpoints.')
param subnetResourceIdforGitHub string = ''

@description('Optional. The GitHub organisation name.')
param GitHubOrganisationName string = 'Insight-Services-APAC'

@description('Optional. The GitHub user assigned identities.')
param GitHubUserAssignedIdentities array = []

// Grafana Module Parameters
@description('Optional. Whether to deploy Grafana.')
param deployGrafana bool = false

@description('Optional. Specifies an array of object IDs for Grafana admins.')
param grafanaAdminObjectIds array = []

@description('Optional. Specifies an array of object IDs for Grafana editors.')
param grafanaEditorObjectIds array = []

@description('Optional. Specifies an array of object IDs for Grafana viewers.')
param grafanaViewerObjectIds array = []

@description('Optional. Password for STMP configurations.')
@secure()
param grafanaSMTPPassword string = newGuid() // This default parameter should be always overridden by CI/CD pipeline using a secure parameter injection

@description('Optional. Grafana Enterprise Plan ID.')
param planIdGrafana string = ''

@description('Required. Host for SMTP configurations')
param grafanaSMTPHost string = ''

@description('Required. User for SMTP configurations')
param grafanaSMTPUser string = ''

@description('Required. email address for sending out emails for SMTP configurations')
param grafanaSMTPemailAddress string = ''

@description('Required. Name used for sending out emails for SMTP configurations')
param grafanaSMTPName string = ''

// Orchestration Variables
var argPrefix = toLower('${shared.resPrefixes.resourceGroup}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var lawPrefix = toLower('${shared.resPrefixes.logAnalytics}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var aaaPrefix = toLower('${shared.resPrefixes.azureAutomation}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var staPrefix = toLower('${shared.resPrefixes.storage}${shared.locPrefixes[location]}${lzPrefix}${envPrefix}')
var vntPrefix = toLower('${shared.resPrefixes.virtualNetwork}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}-')
var nsgPrefix = toLower('${shared.resPrefixes.networkSecurityGroup}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}-')
var udrPrefix = toLower('${shared.resPrefixes.routeTable}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}-')
var dcrPrefix = toLower('${shared.resPrefixes.dataCollectionRule}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var acrPrefix = toLower('${shared.resPrefixes.containerRegistry}${shared.locPrefixes[location]}${lzPrefix}${envPrefix}')
var uaiPrefix = toLower('${shared.resPrefixes.userAssignedIdentity}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var grfPrefix = toLower('${shared.resPrefixes.grafana}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var amoPrefix = toLower('${shared.resPrefixes.azureMonitor}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var umPrefix = toLower('${shared.resPrefixes.updateManagement}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var ghPrefix = toLower('${shared.resPrefixes.github}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')
var akvPrefix = toLower('${shared.resPrefixes.keyVault}-${shared.locPrefixes[location]}-${lzPrefix}-${envPrefix}')

var vnetAddressSpace = replace(virtualNetworkConfiguration!.addressPrefix, '/', '_')

var deployBudgets = budgetConfiguration.?enabled ?? true
var deployVirtualNetwork = virtualNetworkConfiguration.?enabled ?? true
var deployContainerRegistry = containerRegistryConfiguration.?enabled ?? true
var deployContainerRegistryPE = containerRegistryConfiguration.?deployPrivateEndpoints ?? false

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
  logging: '${argPrefix}-logging'
  containerRegistry: '${argPrefix}-acr'
  grafana: '${argPrefix}-grafana'
  jumphosts: '${argPrefix}-jumphosts'
  hostedrunners: '${argPrefix}-runners'
  kafka: '${argPrefix}-kafka'
  updates: '${argPrefix}-updates'
}

var resourceNames = {
  logAnalyticsWorkspace: '${lawPrefix}-${uniqueString(subscriptionId)}'
  azureAutomation: '${aaaPrefix}-${uniqueString(subscriptionId)}'
  storageAccount: storageAccountConfiguration.?name ?? take('${staPrefix}${uniqueString(subscriptionId)}', 24)
  dcrVMInsights: '${dcrPrefix}-vminsights'
  dcrCT: '${dcrPrefix}-changetracking'
  dcrLinux: '${dcrPrefix}-linux'
  dcrWindowsCommon: '${dcrPrefix}-windowscommon'
  dcrMDFCSQL: '${dcrPrefix}-mdfcsql'
  actionGroup: '${shared.resPrefixes.platform}${shared.resPrefixes.platformMgmt}ActionGroup'
  actionGroupShort: '${shared.resPrefixes.platform}AG'
  userAssignedIdentityAMA: '${uaiPrefix}-ama'
  virtualMachine_Jumphosts: '${shared.resPrefixes.platform}${shared.resPrefixes.platformMgmt}vm'
  keyvault: '${akvPrefix}-${uniqueString(subscriptionId)}'
  vmName: '${shared.resPrefixes.platform}${shared.resPrefixes.platformMgmt}vm'
  akvName: '${akvPrefix}-${uniqueString(subscriptionId)}'
  containerRegistry: '${acrPrefix}01'
  grafanaName: take('${grfPrefix}-01', 23)
  azureMonitorWorkspace: '${amoPrefix}-01'
  userAssignedManagedIdentityAMA: '${uaiPrefix}-ama'
  updateManagerConfiguration: '${umPrefix}-config'
  githubNetworkSettings: '${ghPrefix}-networksettings'
  userAssignedManagedIdentitySentinel: '${uaiPrefix}-sentineldeploy'
  virtualNetwork: '${vntPrefix}${vnetAddressSpace}'
}

var adminUsername_Jumphost = 'adminJumpHost'

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

@description('Module: Action Group - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/insights/action-group')
module actionGroup 'br/public:avm/res/insights/action-group:0.8.0' = if (!empty(actionGroupConfiguration.?emailReceivers)) {
  name: take('actionGroup-${guid(deployment().name)}', 64)
  scope: resourceGroup(subscriptionId, 'alertsRG')
  dependsOn: [
    commonResourceGroups
  ]
  params: {
    // Required parameters
    groupShortName: resourceNames.actionGroupShort
    name: resourceNames.actionGroup
    // Non-required parameters
    emailReceivers: [
      for email in actionGroupConfiguration.?emailReceivers ?? []: {
        emailAddress: email
        name: split(email, '@')[0]
        useCommonAlertSchema: true
      }
    ]
    location: 'Global'
  }
}

@description('Module: Resource Group (Logging)')
module resourceGroupForLogging 'br/public:avm/res/resources/resource-group:0.4.1' = if (loggingEnabled) {
  scope: subscription(subscriptionId)
  name: 'resourceGroupForLogging-${guid(deployment().name)}'
  params: {
    // Required parameters
    name: resourceGroups.logging
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: Logging (Log Analytics, Azure Automation, Sentinel and Azure Storage)')
module logging '../../modules/logging/logging.bicep' = if (loggingEnabled) {
  scope: resourceGroup(subscriptionId, resourceGroups.logging)
  name: 'logging-${guid(deployment().name)}'
  dependsOn: [
    resourceGroupForLogging
  ]
  params: {
    automationAccountName: resourceNames.azureAutomation
    automationAccountLocation: location
    dataCollectionRuleVMInsightsName: resourceNames.dcrVMInsights
    dataCollectionRuleLinuxName: resourceNames.dcrLinux
    dataCollectionRuleWindowsCommonName: resourceNames.dcrWindowsCommon
    dataCollectionRuleChangeTrackingName: resourceNames.dcrCT
    dataCollectionRuleMDFCSQLName: resourceNames.dcrMDFCSQL
    location: location
    logAnalyticsConfiguration: logAnalyticsConfiguration
    logAnalyticsWorkspaceName: resourceNames.logAnalyticsWorkspace
    logAnalyticsWorkspaceSolutions: logAnalyticsWorkspaceSolutions
    logAnalyticsWorkspaceLocation: location
    storageAccountConfiguration: storageAccountConfiguration
    storageAccountName: resourceNames.storageAccount
    tags: tags
    userAssignedManagedIdentityName: resourceNames.userAssignedIdentityAMA
    logAnalyticsCustomTables: logAnalyticsCustomTables
  }
}

@description('Module: Sentinel')
module sentinel '../../modules/sentinel/sentinel.bicep' = if (deploySentinel) {
  scope: resourceGroup(subscriptionId, resourceGroups.logging)
  name: 'sentinel-${guid(deployment().name)}'
  dependsOn: [
    logging
  ]
  params: {
    location: location
    tags: tags
    workspaceName: resourceNames.logAnalyticsWorkspace
    sentinelFirstDeploymentDate: sentinelFirstDeploymentDate
    sentinelContentSolutions: sentinelContentSolutions
    uaiSentinelName: resourceNames.userAssignedManagedIdentitySentinel
  }
}

@description('Module: Resource Group (Kafka)')
module resourceGroupForKafka 'br/public:avm/res/resources/resource-group:0.4.1' = if (deployKafka) {
  scope: subscription(subscriptionId)
  name: 'resourceGroupForKafka-${guid(deployment().name)}'
  params: {
    // Required parameters
    name: resourceGroups.kafka
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: Private Endpoint(s) for Kafka')
module privateEndpointsKafka 'br/public:avm/res/network/private-endpoint:0.11.0' = [
  for config in KafkaPrivateEndpointConfigs: if (deployKafka) {
    scope: resourceGroup(subscriptionId, resourceGroups.kafka)
    name: 'privateEndpoint-${config.name}'
    dependsOn: [
      resourceGroupForKafka
    ]
    params: {
      // Required parameters
      name: config.name
      tags: union(tags, config.tags ?? {})
      subnetResourceId: subnetResourceIdforKafka
      manualPrivateLinkServiceConnections: [
        {
          name: config.name
          properties: {
            privateLinkServiceId: config.privateLinkServiceId
            groupIds: []
          }
        }
      ]
      // Non-required parameters
      location: location
    }
  }
]

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

@description('Module: Resource Group (Jumphosts)')
module resourceGroupForJumpHosts 'br/public:avm/res/resources/resource-group:0.4.1' = if (!empty(virtualMachines_Jumphosts)) {
  scope: subscription(subscriptionId)
  name: take('resourceGroupForJumpHosts-${guid(deployment().name)}', 64)
  params: {
    // Required parameters
    name: resourceGroups.jumphosts
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: KeyVault for JumpHost password')
module keyVaultForJumpHostPassword 'br/public:avm/res/key-vault/vault:0.13.3' = if (!empty(virtualMachines_Jumphosts)) {
  scope: resourceGroup(subscriptionId, resourceGroups.jumphosts)
  name: take('keyVaultForJumpHostPassword-${guid(deployment().name)}', 64)
  params: {
    name: take(resourceNames.keyvault, 24)
    location: location
    tags: tags
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
    secrets: [
      {
        name: 'virtualMachineJumpHostPassword'
        value: jumpHostPassword
      }
    ]
  }
}

@description('Module: Virtual Machine for Jumphosts')
module virtualMachine_Jumphosts '../../modules/virtualMachine/virtualMachine.bicep' = if (!empty(virtualMachines_Jumphosts)) {
  name: take('virtualMachineJump-${guid(deployment().name)}', 64)
  scope: resourceGroup(subscriptionId, resourceGroups.jumphosts)
  dependsOn: [
    resourceGroupForJumpHosts
    resourceGroupForNetwork
    spokeNetworking
    keyVaultForJumpHostPassword
  ]
  params: {
    tags: tags
    keyVaultName: take(resourceNames.keyvault, 24)
    secretName: 'virtualMachineJumpHostPassword'
    virtualMachines: virtualMachines_Jumphosts
    location: location
    adminUsername: adminUsername_Jumphost
    virtualMachineName: resourceNames.virtualMachine_Jumphosts
    virtualNetworkName: resourceNames.virtualNetwork
    subnetName: 'management'
    resourceGroupNamevNet: resourceGroups.network
    enableAutomaticUpdates: enableJumphostAutomaticUpdates
  }
}

@description('Module: Resource Group (ACR)')
module resourceGroupForAcr 'br/public:avm/res/resources/resource-group:0.4.1' = if (deployContainerRegistry) {
  scope: subscription(subscriptionId)
  name: 'resourceGroupForAcr-${guid(deployment().name)}'
  params: {
    // Required parameters
    name: resourceGroups.containerRegistry
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: Azure Container Registry (Private Registry for Bicep)')
module containerRegistry 'br/public:avm/res/container-registry/registry:0.9.3' = if (deployContainerRegistry) {
  scope: resourceGroup(subscriptionId, resourceGroups.containerRegistry)
  name: 'containerRegistry-${guid(deployment().name)}'
  dependsOn: [
    resourceGroupForAcr
  ]
  params: {
    // Required parameters
    name: resourceNames.containerRegistry
    // Non-required parameters
    acrAdminUserEnabled: containerRegistryConfiguration.?acrAdminUserEnabled ?? false
    acrSku: containerRegistryConfiguration.?sku ?? 'Standard'
    location: location
    managedIdentities: {
      systemAssigned: true
    }
    networkRuleBypassOptions: containerRegistryConfiguration.?networkRuleBypassOptions ?? 'AzureServices'
    networkRuleSetDefaultAction: containerRegistryConfiguration.?networkRuleSetDefaultAction ?? 'Deny'
    privateEndpoints: containerRegistryConfiguration.?sku == 'Premium' && deployContainerRegistryPE && (contains(
        map(spokeNetworking!.outputs.subnetsArray, subnets => subnets.name),
        'privateEndpoints'
      ))
      ? [
          {
            subnetResourceId: '${spokeNetworking!.outputs.virtualNetworkId}/subnets/privateEndpoints'
          }
        ]
      : []
    publicNetworkAccess: containerRegistryConfiguration.?sku == 'Premium' ? 'Disabled' : 'Enabled'
    roleAssignments: [
      for roleAssignment in (containerRegistryConfiguration.?roleAssignments ?? []): {
        name: roleAssignment.name
        roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
        principalId: roleAssignment.principalId
        principalType: roleAssignment.principalType
        description: roleAssignment.description
        condition: roleAssignment.condition
        conditionVersion: roleAssignment.conditionVersion
        delegatedManagedIdentityResourceId: roleAssignment.delegatedManagedIdentityResourceId
      }
    ]
    softDeletePolicyStatus: containerRegistryConfiguration.?softDeletePolicyStatus ?? 'disabled' // Enabling soft delete is currently preview
    softDeletePolicyDays: containerRegistryConfiguration.?softDeletePolicyDays ?? 7
    tags: tags
    trustPolicyStatus: containerRegistryConfiguration.?sku == 'Premium' ? 'enabled' : 'disabled'
    zoneRedundancy: containerRegistryConfiguration.?sku == 'Premium'
      ? containerRegistryConfiguration.?zoneRedundancy
      : null
  }
}

@description('Module: Resource Group (Azure Update Manager - Configuration Management)')
module resourceGroupForUpdateManager 'br/public:avm/res/resources/resource-group:0.4.1' = if (deployUpdateManagement) {
  scope: subscription(subscriptionId)
  name: take('resourceGroupForUpdateManager-${guid(deployment().name)}', 64)
  params: {
    // Required parameters
    name: resourceGroups.updates
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: Azure Update Manager - Configuration Management')
module updateManagerConfiguration '../../modules/updateManager/updateManagerConfiguration.bicep' = if (deployUpdateManagement) {
  scope: resourceGroup(subscriptionId, resourceGroups.updates)
  dependsOn: [
    resourceGroupForUpdateManager
  ]
  name: take('updateManagerConfiguration-${guid(deployment().name)}', 64)
  params: {
    location: location
    maintenanceConfigName: resourceNames.updateManagerConfiguration
    tags: tags
    maintenanceWindow: maintenanceWindow
    rebootSetting: rebootSetting
  }
}

@description('Module: Defender EASM')
module defenderEasmConfiguration '../../modules/msDefenderEasm/msdefendereasm.bicep' = if (deployEASM) {
  scope: resourceGroup(subscriptionId, resourceGroups.logging)
  name: take('defenderEasmConfiguration-${guid(deployment().name)}', 64)
  params: {
    location: location
    instanceName: defenderEASMName
    tags: tags
  }
}

@description('Module: Resource Group (Github)')
module resourceGroupForGitHub 'br/public:avm/res/resources/resource-group:0.4.1' = if (!empty(GitHubDatabaseId)) {
  scope: subscription(subscriptionId)
  name: take('resourceGroupForGitHub-${guid(deployment().name)}', 64)
  params: {
    // Required parameters
    name: resourceGroups.hostedrunners
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: GitHub Hosted Network (vNet Integrated Runners) configuration')
module githubHostedNetwork '../../modules/githubHostedNetwork/githubHostedNetwork.bicep' = if (!empty(subnetResourceIdforGitHub) && !empty(GitHubDatabaseId)) {
  scope: resourceGroup(subscriptionId, resourceGroups.hostedrunners)
  name: take('githubHostedNetwork-${guid(deployment().name)}', 64)
  dependsOn: [
    spokeNetworking
    resourceGroupForGitHub
  ]
  params: {
    subnetResourceId: subnetResourceIdforGitHub
    databaseId: GitHubDatabaseId
    tags: tags
    location: location
    networkSettingsName: resourceNames.githubNetworkSettings
  }
}

@description('Module: User Assigned Identity for GitHub Hosted Network Runners to use')
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = [
  for (uai, index) in GitHubUserAssignedIdentities: {
    name: take('uaiRunners-${index}-${guid(deployment().name)}', 64)
    scope: resourceGroup(subscriptionId, resourceGroups.hostedrunners)
    params: {
      name: uai.name
      location: location
      federatedIdentityCredentials: [
        for fc in uai.federatedCredentials: {
          audiences: [
            'api://AzureADTokenExchange'
          ]
          issuer: 'https://token.actions.githubusercontent.com'
          name: '${fc.repository}-${fc.environment}'
          subject: 'repo:${GitHubOrganisationName}/${fc.repository}:environment:${fc.environment}'
        }
      ]
    }
  }
]

@description('Module: Resource Group (Grafana)')
module resourceGroupForGrafana 'br/public:avm/res/resources/resource-group:0.4.1' = if (deployGrafana) {
  scope: subscription(subscriptionId)
  name: take('resourceGroupForGrafana-${guid(deployment().name)}', 64)
  params: {
    // Required parameters
    name: resourceGroups.grafana
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: Azure Monitor (Workspace) for Grafana')
// Not to be confused with the Log Analytics Workspace which is part of the Logging module.
// Used by Grafana.
module azureMonitor '../../modules/azureMonitor/azureMonitor.bicep' = if (deployGrafana) {
  scope: resourceGroup(subscriptionId, resourceGroups.grafana)
  name: take('azureMonitor-${guid(deployment().name)}', 64)
  dependsOn: [
    resourceGroupForGrafana
  ]
  params: {
    workspaceName: resourceNames.azureMonitorWorkspace
    location: location
    resourceGroupNamevNet: resourceGroups.network
    vnetName: resourceNames.virtualNetwork
    subnetName: 'privateEndpoints'
  }
}

@description('Module: Grafana')
module grafana '../../modules/grafana/grafana.bicep' = if (deployGrafana) {
  scope: resourceGroup(subscriptionId, resourceGroups.grafana)
  name: take('grafana-${guid(deployment().name)}', 64)
  dependsOn: [
    resourceGroupForGrafana
    spokeNetworking
  ]
  params: {
    location: location
    tags: tags
    grafanaName: resourceNames.grafanaName
    skuName: 'Standard'
    identityType: 'SystemAssigned'
    autoGeneratedDomainNameLabelScope: 'TenantReuse'
    grafanaIntegrations: (loggingEnabled)
      ? {
          azureMonitorWorkspaceIntegrations: [
            {
              azureMonitorWorkspaceResourceId: azureMonitor!.outputs.workspaceId
            }
          ]
        }
      : {}
    publicAccessEnabled: false
    zoneRedundancy: 'Disabled'
    host: grafanaSMTPHost
    username: grafanaSMTPUser
    password: grafanaSMTPPassword
    fromAddress: grafanaSMTPemailAddress
    fromName: grafanaSMTPName
    startTLS: 'MandatoryStartTLS'
    planId: planIdGrafana
    virtualNetworkName: resourceNames.virtualNetwork
    subnetName: 'privateEndpoints'
    resourceGroupNamevNet: resourceGroups.network
    grafanaAdminsObjectIds: grafanaAdminObjectIds
    grafanaEditorObjectIds: grafanaEditorObjectIds
    grafanaViewerObjectIds: grafanaViewerObjectIds
  }
}
