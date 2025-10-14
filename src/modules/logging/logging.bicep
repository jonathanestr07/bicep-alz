import * as shared from '../../configuration/shared.conf.bicep'
import * as type from '../../configuration/shared.type.bicep'

metadata name = 'ALZ Bicep - Logging Module'
metadata description = 'ALZ Bicep Module used to set up Logging'
metadata version = '2.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Required. Log Analytics Workspace name.')
param logAnalyticsWorkspaceName string

@description('Optional. Configuration for Log Analytics.')
param logAnalyticsConfiguration type.logAnalyticsConfigurationType?

@description('Optional. Ensure the regions selected is a supported mapping as per: <https://docs.microsoft.com/azure/automation/how-to/region-mappings/>')
param logAnalyticsWorkspaceLocation string = resourceGroup().location

@description('Required. Data Collection Rule name for Linux Syslog for AMA integration.')
param dataCollectionRuleLinuxName string

@description('Required. Data Collection Rule name for Windows Common Event Logs for AMA integration.')
param dataCollectionRuleWindowsCommonName string

@description('Required. Data Collection Rule name for VM Insights for AMA integration.')
param dataCollectionRuleVMInsightsName string

@description('Required. Change Tracking Data Collection Rule name for AMA integration.')
param dataCollectionRuleChangeTrackingName string

@description('Required. MDFC for SQL Data Collection Rule name for AMA integration.')
param dataCollectionRuleMDFCSQLName string

@allowed([
  'SecurityInsights'
  'ChangeTracking'
  'SQLVulnerabilityAssessment'
])
@description('Optional. Solutions that will be added to the Log Analytics Workspace.')
param logAnalyticsWorkspaceSolutions array = [
  'SecurityInsights'
  'ChangeTracking'
  'SQLVulnerabilityAssessment'
]

@description('Required. Name of the User Assigned Managed Identity required for authenticating Azure Monitoring Agent to Azure.')
param userAssignedManagedIdentityName string

@description('Optional. User Assigned Managed Identity location.')
param userAssignedManagedIdentityLocation string = resourceGroup().location

@description('Optional. Log Analytics Workspace should be linked with the automation account.')
param logAnalyticsWorkspaceLinkAutomationAccount bool = true

@description('Required. Automation account name.')
param automationAccountName string = 'aaa-aue-plat-mgmt-01'

@description('Optional. Automation Account region name. - Ensure the regions selected is a supported mapping as per: <https://docs.microsoft.com/azure/automation/how-to/region-mappings/>ß')
param automationAccountLocation string = resourceGroup().location

@description('Optional. Configuration for Azure Storage Account.')
param storageAccountConfiguration type.storageAccountConfigurationType?

@description('Required. Storage Account Name.')
param storageAccountName string = 'staaueplatmgmt01'

@description('Optional. Location for the storage account.')
param location string = resourceGroup().location

@description('Optional. Tags that will be applied to all resources in this module.')
param tags type.tagsType

@description('Optional. Set Parameter to true to use Sentinel Classic Pricing Tiers, following changes introduced in July 2023 as documented here: <https://learn.microsoft.com/azure/sentinel/enroll-simplified-pricing-tier/>ß')
param useSentinelClassicPricingTiers bool = false

@description('Optional. Set Parameter to true to Opt-out of deployment telemetry.')
param telemetryOptOut bool = true

@description('Optional. Log Analytics Custom Tables to be deployed.')
param logAnalyticsCustomTables LogAnalyticsCustomTable[] = []

// Customer Usage Attribution Id
var cuaid = 'f8087c67-cc41-46b2-994d-66e4b661860d'

@description('Module: User Assigned Managed Identity - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/managed-identity/user-assigned-identity')
module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.1' = {
  name: take('userAssignedIdentity-${guid(deployment().name)}', 64)
  params: {
    // Required parameters
    name: userAssignedManagedIdentityName
    // Non-required parameters
    location: userAssignedManagedIdentityLocation
    tags: tags
  }
}

@description('Resource: Azure Automation Account')
resource automationAccount 'Microsoft.Automation/automationAccounts@2023-11-01' = {
  name: automationAccountName
  location: automationAccountLocation
  identity: {
    type: 'SystemAssigned'
  }
  tags: tags
  properties: {
    sku: {
      name: 'Basic'
    }
    encryption: {
      keySource: 'Microsoft.Automation'
    }
  }
}

@description('Resource: Log Analytics Workspace')
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: logAnalyticsWorkspaceLocation
  tags: tags
  properties: {
    sku: {
      name: logAnalyticsConfiguration.?skuName ?? 'PerGB2018'
      capacityReservationLevel: logAnalyticsConfiguration.?skuName == 'CapacityReservation'
        ? logAnalyticsConfiguration.?skuCapacityReservationLevel
        : null
    }
    retentionInDays: logAnalyticsConfiguration.?logRetentionInDays ?? 90
    workspaceCapping: {
      dailyQuotaGb: logAnalyticsConfiguration.?dailyQuotaGb ?? -1
    }
    publicNetworkAccessForIngestion: logAnalyticsConfiguration.?publicNetworkAccessForIngestion ?? 'Enabled'
    publicNetworkAccessForQuery: logAnalyticsConfiguration.?publicNetworkAccessForQuery ?? 'Enabled'
  }
}

@description('Resource: Log Analytics Custom Tables Deployment')
resource logAnalyticsCustomTablesDeploy 'Microsoft.OperationalInsights/workspaces/tables@2025-02-01' = [
  for table in logAnalyticsCustomTables: {
    parent: logAnalyticsWorkspace
    name: table.name
    properties: {
      schema: table.schema
      retentionInDays: table.retentionInDays
    }
  }
]

@description('Module: Data Collection Rules - VM Insights - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/insights/data-collection-rule')
module dataCollectionRuleVMInsights 'br/public:avm/res/insights/data-collection-rule:0.6.1' = {
  name: take('dataCollectionRuleVMInsights-${guid(deployment().name)}', 64)
  params: {
    name: dataCollectionRuleVMInsightsName
    dataCollectionRuleProperties: {
      description: 'Data collection rule for VM Insights.'
      dataSources: {
        performanceCounters: [
          {
            name: 'VMInsightsPerfCounters'
            streams: [
              'Microsoft-InsightsMetrics'
            ]
            counterSpecifiers: [
              '\\VmInsights\\DetailedMetrics'
            ]
            samplingFrequencyInSeconds: 60
          }
        ]
      }
      destinations: {
        logAnalytics: [
          {
            workspaceResourceId: logAnalyticsWorkspace.id
            name: 'VMInsightsPerf-Logs-Dest'
          }
        ]
      }
      dataFlows: [
        {
          streams: [
            'Microsoft-InsightsMetrics'
          ]
          destinations: [
            'VMInsightsPerf-Logs-Dest'
          ]
        }
      ]
      kind: 'All'
    }
    location: logAnalyticsWorkspaceLocation
    tags: tags
  }
}

@description('Module: Data Collection Rules - Linux Syslog')
module dataCollectionRuleLinux 'br/public:avm/res/insights/data-collection-rule:0.6.1' = {
  name: take('dataCollectionRuleLinux-${guid(deployment().name)}', 64)
  params: {
    name: dataCollectionRuleLinuxName
    location: logAnalyticsWorkspaceLocation
    tags: tags
    dataCollectionRuleProperties: {
      description: 'Data collection rule for Linux Syslog'
      kind: 'Linux'
      dataSources: {
        syslog: [
          {
            name: 'sysLogsDataSource--1469397783'
            streams: [
              'Microsoft-Syslog'
            ]
            facilityNames: [
              'alert'
              'audit'
              'auth'
              'authpriv'
            ]
            logLevels: [
              'Info'
              'Notice'
              'Warning'
              'Error'
              'Critical'
              'Alert'
              'Emergency'
            ]
          }
          {
            name: 'sysLogsDataSource--1469397789'
            streams: [
              'Microsoft-Syslog'
            ]
            facilityNames: [
              'daemon'
              'kern'
              'cron'
            ]
            logLevels: [
              'Error'
              'Critical'
              'Alert'
              'Emergency'
            ]
          }
        ]
      }
      destinations: {
        logAnalytics: [
          {
            workspaceResourceId: logAnalyticsWorkspace.id
            name: 'DataCollectionEvent'
          }
        ]
      }
      dataFlows: [
        {
          streams: [
            'Microsoft-Syslog'
          ]
          destinations: [
            'DataCollectionEvent'
          ]
        }
      ]
    }
  }
}

@description('Module: Data Collection Rules - Windows Common Event Logs')
module dataCollectionRuleWindowsCommon 'br/public:avm/res/insights/data-collection-rule:0.6.1' = {
  name: take('dataCollectionRuleWindowsCommon-${guid(deployment().name)}', 64)
  params: {
    name: dataCollectionRuleWindowsCommonName
    location: logAnalyticsWorkspaceLocation
    tags: tags
    dataCollectionRuleProperties: {
      description: 'Data collection rule for WindowsCommon Event Logs'
      kind: 'Windows'
      dataSources: {
        windowsEventLogs: [
          {
            streams: [
              'Microsoft-SecurityEvent'
            ]
            xPathQueries: [
              'Security!*[System[(EventID=1) or (EventID=299) or (EventID=300) or (EventID=324) or (EventID=340) or (EventID=403) or (EventID=404) or (EventID=410) or (EventID=411) or (EventID=412) or (EventID=413) or (EventID=431) or (EventID=500) or (EventID=501) or (EventID=1100)]]'
              'Security!*[System[(EventID=1102) or (EventID=1107) or (EventID=1108) or (EventID=4608) or (EventID=4610) or (EventID=4611) or (EventID=4614) or (EventID=4622) or (EventID=4624) or (EventID=4625) or (EventID=4634) or (EventID=4647) or (EventID=4648) or (EventID=4649) or (EventID=4657)]]'
              'Security!*[System[(EventID=4661) or (EventID=4662) or (EventID=4663) or (EventID=4665) or (EventID=4666) or (EventID=4667) or (EventID=4688) or (EventID=4670) or (EventID=4672) or (EventID=4673) or (EventID=4674) or (EventID=4675) or (EventID=4689) or (EventID=4697) or (EventID=4700)]]'
              'Security!*[System[(EventID=4702) or (EventID=4704) or (EventID=4705) or (EventID=4716) or (EventID=4717) or (EventID=4718) or (EventID=4719) or (EventID=4720) or (EventID=4722) or (EventID=4723) or (EventID=4724) or (EventID=4725) or (EventID=4726) or (EventID=4727) or (EventID=4728)]]'
              'Security!*[System[(EventID=4729) or (EventID=4733) or (EventID=4732) or (EventID=4735) or (EventID=4737) or (EventID=4738) or (EventID=4739) or (EventID=4740) or (EventID=4742) or (EventID=4744) or (EventID=4745) or (EventID=4746) or (EventID=4750) or (EventID=4751) or (EventID=4752)]]'
              'Security!*[System[(EventID=4754) or (EventID=4755) or (EventID=4756) or (EventID=4757) or (EventID=4760) or (EventID=4761) or (EventID=4762) or (EventID=4764) or (EventID=4767) or (EventID=4768) or (EventID=4771) or (EventID=4774) or (EventID=4778) or (EventID=4779) or (EventID=4781)]]'
              'Security!*[System[(EventID=4793) or (EventID=4797) or (EventID=4798) or (EventID=4799) or (EventID=4800) or (EventID=4801) or (EventID=4802) or (EventID=4803) or (EventID=4825) or (EventID=4826) or (EventID=4870) or (EventID=4886) or (EventID=4887) or (EventID=4888) or (EventID=4893)]]'
              'Security!*[System[(EventID=4898) or (EventID=4902) or (EventID=4904) or (EventID=4905) or (EventID=4907) or (EventID=4931) or (EventID=4932) or (EventID=4933) or (EventID=4946) or (EventID=4948) or (EventID=4956) or (EventID=4985) or (EventID=5024) or (EventID=5033) or (EventID=5059)]]'
              'Security!*[System[(EventID=5136) or (EventID=5137) or (EventID=5140) or (EventID=5145) or (EventID=5632) or (EventID=6144) or (EventID=6145) or (EventID=6272) or (EventID=6273) or (EventID=6278) or (EventID=6416) or (EventID=6423) or (EventID=6424) or (EventID=8001) or (EventID=8002)]]'
              'Security!*[System[(EventID=8003) or (EventID=8004) or (EventID=8005) or (EventID=8006) or (EventID=8007) or (EventID=8222) or (EventID=26401) or (EventID=30004)]]'
              'Microsoft-Windows-AppLocker/EXE and DLL!*[System[(EventID=8001) or (EventID=8002) or (EventID=8003) or (EventID=8004)]]'
              'Microsoft-Windows-AppLocker/MSI and Script!*[System[(EventID=8005) or (EventID=8006) or (EventID=8007)]]'
            ]
            name: 'eventLogsDataSource'
          }
        ]
      }
      destinations: {
        logAnalytics: [
          {
            workspaceResourceId: logAnalyticsWorkspace.id
            name: 'DataCollectionEvent'
          }
        ]
      }
      dataFlows: [
        {
          streams: [
            'Microsoft-SecurityEvent'
          ]
          destinations: [
            'DataCollectionEvent'
          ]
        }
      ]
    }
  }
}

@description('Module: Data Collection Rules - Change Tracking - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/insights/data-collection-rule')
module dataCollectionRuleChangeTracking 'br/public:avm/res/insights/data-collection-rule:0.6.1' = {
  name: take('dataCollectionRuleChangeTracking-${guid(deployment().name)}', 64)
  params: {
    name: dataCollectionRuleChangeTrackingName
    dataCollectionRuleProperties: {
      dataFlows: [
        {
          streams: [
            'Microsoft-ConfigurationChange'
            'Microsoft-ConfigurationChangeV2'
            'Microsoft-ConfigurationData'
          ]
          destinations: [
            'Microsoft-CT-Dest'
          ]
        }
      ]
      dataSources: {
        extensions: [
          {
            streams: [
              'Microsoft-ConfigurationChange'
              'Microsoft-ConfigurationChangeV2'
              'Microsoft-ConfigurationData'
            ]
            extensionName: 'ChangeTracking-Windows'
            extensionSettings: {
              enableFiles: true
              enableSoftware: true
              enableRegistry: true
              enableServices: true
              enableInventory: true
              registrySettings: {
                registryCollectionFrequency: 3000
                registryInfo: [
                  {
                    name: 'Registry_1'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Startup'
                    valueName: ''
                  }
                  {
                    name: 'Registry_2'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Shutdown'
                    valueName: ''
                  }
                  {
                    name: 'Registry_3'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Run'
                    valueName: ''
                  }
                  {
                    name: 'Registry_4'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components'
                    valueName: ''
                  }
                  {
                    name: 'Registry_5'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\ShellEx\\ContextMenuHandlers'
                    valueName: ''
                  }
                  {
                    name: 'Registry_6'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\Background\\ShellEx\\ContextMenuHandlers'
                    valueName: ''
                  }
                  {
                    name: 'Registry_7'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Classes\\Directory\\Shellex\\CopyHookHandlers'
                    valueName: ''
                  }
                  {
                    name: 'Registry_8'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellIconOverlayIdentifiers'
                    valueName: ''
                  }
                  {
                    name: 'Registry_9'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\ShellIconOverlayIdentifiers'
                    valueName: ''
                  }
                  {
                    name: 'Registry_10'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Browser Helper Objects'
                    valueName: ''
                  }
                  {
                    name: 'Registry_11'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Browser Helper Objects'
                    valueName: ''
                  }
                  {
                    name: 'Registry_12'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Internet Explorer\\Extensions'
                    valueName: ''
                  }
                  {
                    name: 'Registry_13'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Internet Explorer\\Extensions'
                    valueName: ''
                  }
                  {
                    name: 'Registry_14'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Drivers32'
                    valueName: ''
                  }
                  {
                    name: 'Registry_15'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\Software\\Wow6432Node\\Microsoft\\Windows NT\\CurrentVersion\\Drivers32'
                    valueName: ''
                  }
                  {
                    name: 'Registry_16'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\KnownDlls'
                    valueName: ''
                  }
                  {
                    name: 'Registry_17'
                    groupTag: 'Recommended'
                    enabled: false
                    recurse: true
                    description: ''
                    keyName: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\\Notify'
                    valueName: ''
                  }
                ]
              }
              fileSettings: {
                fileCollectionFrequency: 2700
              }
              softwareSettings: {
                softwareCollectionFrequency: 1800
              }
              inventorySettings: {
                inventoryCollectionFrequency: 36000
              }
              serviceSettings: {
                serviceCollectionFrequency: 1800
              }
            }
            name: 'CTDataSource-Windows'
          }
          {
            streams: [
              'Microsoft-ConfigurationChange'
              'Microsoft-ConfigurationChangeV2'
              'Microsoft-ConfigurationData'
            ]
            extensionName: 'ChangeTracking-Linux'
            extensionSettings: {
              enableFiles: true
              enableSoftware: true
              enableRegistry: false
              enableServices: true
              enableInventory: true
              fileSettings: {
                fileCollectionFrequency: 900
                fileInfo: [
                  {
                    name: 'ChangeTrackingLinuxPath_default'
                    enabled: true
                    destinationPath: '/etc/.*.conf'
                    useSudo: true
                    recurse: true
                    maxContentsReturnable: 5000000
                    pathType: 'File'
                    type: 'File'
                    links: 'Follow'
                    maxOutputSize: 500000
                    groupTag: 'Recommended'
                  }
                ]
              }
              softwareSettings: {
                softwareCollectionFrequency: 300
              }
              inventorySettings: {
                inventoryCollectionFrequency: 36000
              }
              serviceSettings: {
                serviceCollectionFrequency: 300
              }
            }
            name: 'CTDataSource-Linux'
          }
        ]
      }
      description: 'Data collection rule for CT.'
      destinations: {
        logAnalytics: [
          {
            workspaceResourceId: logAnalyticsWorkspace.id
            name: 'Microsoft-CT-Dest'
          }
        ]
      }
      kind: 'All'
    }
    // Non-required parameters
    location: logAnalyticsWorkspaceLocation
    tags: tags
  }
}

@description('Module: Data Collection Rules - Microsoft Defender for Cloud SQL - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/insights/data-collection-rule')
module dataCollectionRuleMDFCSQL 'br/public:avm/res/insights/data-collection-rule:0.6.1' = {
  name: take('dataCollectionRuleMDFCSQL-${guid(deployment().name)}', 64)
  params: {
    name: dataCollectionRuleMDFCSQLName
    dataCollectionRuleProperties: {
      dataFlows: [
        {
          streams: [
            'Microsoft-DefenderForSqlAlerts'
            'Microsoft-DefenderForSqlLogins'
            'Microsoft-DefenderForSqlTelemetry'
            'Microsoft-DefenderForSqlScanEvents'
            'Microsoft-DefenderForSqlScanResults'
          ]
          destinations: [
            'Microsoft-DefenderForSQL-Dest'
          ]
        }
      ]
      dataSources: {
        extensions: [
          {
            extensionName: 'MicrosoftDefenderForSQL'
            name: 'MicrosoftDefenderForSQL'
            streams: [
              'Microsoft-DefenderForSqlAlerts'
              'Microsoft-DefenderForSqlLogins'
              'Microsoft-DefenderForSqlTelemetry'
              'Microsoft-DefenderForSqlScanEvents'
              'Microsoft-DefenderForSqlScanResults'
            ]
            extensionSettings: {
              enableCollectionOfSqlQueriesForSecurityResearch: true
            }
          }
        ]
      }
      description: 'Data collection rule for Defender for SQL.'
      destinations: {
        logAnalytics: [
          {
            workspaceResourceId: logAnalyticsWorkspace.id
            name: 'Microsoft-DefenderForSQL-Dest'
          }
        ]
      }
      kind: 'All'
    }
    // Non-required parameters
    location: logAnalyticsWorkspaceLocation
    tags: tags
  }
}

@description('Resource: Sentinel Onboarding')
resource sentinelOnboarding 'Microsoft.SecurityInsights/onboardingStates@2024-03-01' = if (contains(
  logAnalyticsWorkspaceSolutions,
  'SecurityInsights'
)) {
  name: 'default'
  scope: logAnalyticsWorkspace
  properties: {}
}

@description('Resource: Log Analytics Solutions')
resource logAnalyticsSolutions 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = [
  for solution in logAnalyticsWorkspaceSolutions: {
    name: '${solution}(${logAnalyticsWorkspace.name})'
    location: location
    tags: tags
    #disable-next-line BCP037
    properties: solution == 'SecurityInsights'
      ? {
          workspaceResourceId: logAnalyticsWorkspace.id
          sku: useSentinelClassicPricingTiers
            ? null
            : {
                name: 'Unified'
              }
        }
      : {
          workspaceResourceId: logAnalyticsWorkspace.id
        }
    plan: {
      name: '${solution}(${logAnalyticsWorkspace.name})'
      product: 'OMSGallery/${solution}'
      publisher: 'Microsoft'
      promotionCode: ''
    }
  }
]

@description('Resource: Log Analytics Linked Service')
resource logAnalyticsLinkedServiceForAutomationAccount 'Microsoft.OperationalInsights/workspaces/linkedServices@2020-08-01' = if (logAnalyticsWorkspaceLinkAutomationAccount) {
  #disable-next-line use-parent-property
  name: '${logAnalyticsWorkspace.name}/Automation'
  properties: {
    resourceId: automationAccount.id
  }
}

@description('Module: Storage Account - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/storage/storage-account')
module storageAccount 'br/public:avm/res/storage/storage-account:0.19.0' = {
  name: take('storageAccount-${guid(deployment().name)}', 64)
  params: {
    // Required parameters
    name: storageAccountName
    // Non-required parameters
    accessTier: storageAccountConfiguration.?accessTier ?? 'Hot'
    allowBlobPublicAccess: storageAccountConfiguration.?allowBlobPublicAccess ?? false
    allowSharedKeyAccess: storageAccountConfiguration.?allowSharedKeyAccess ?? false
    blobServices: {
      containerDeleteRetentionPolicyDays: storageAccountConfiguration.?containerDeleteRetentionPolicyDays ?? 7
      containerDeleteRetentionPolicyEnabled: storageAccountConfiguration.?containerDeleteRetentionPolicyEnabled ?? true
      deleteRetentionPolicyDays: storageAccountConfiguration.?deleteRetentionPolicyDays ?? 7
      deleteRetentionPolicyEnabled: storageAccountConfiguration.?deleteRetentionPolicyEnabled ?? true
    }
    defaultToOAuthAuthentication: !(storageAccountConfiguration.?allowSharedKeyAccess ?? true)
    managedIdentities: {
      systemAssigned: true
    }
    kind: storageAccountConfiguration.?kind ?? 'StorageV2'
    location: location
    minimumTlsVersion: storageAccountConfiguration.?minimumTlsVersion ?? 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: []
    }
    publicNetworkAccess: storageAccountConfiguration.?publicNetworkAccess ?? 'Enabled'
    skuName: storageAccountConfiguration.?skuName ?? 'Standard_ZRS'
    supportsHttpsTrafficOnly: storageAccountConfiguration.?supportsHttpsTrafficOnly ?? true
    tags: tags
  }
}

@description('Module: Customer Usage Attribution')
module customerUsageAttribution '../CARML/customerUsageAttribution/cuaIdResourceGroup.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See  <https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function/> for more information //Only to ensure telemetry data is stored in same location as deployment. See <https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function> for more information
  name: 'pid-${cuaid}-${uniqueString(resourceGroup().location)}'
  params: {}
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

@description('Defines a Log Analytics Custom Table.')
type LogAnalyticsCustomTable = {
  name: string
  schema: LogAnalyticsCustomTableSchema
  retentionInDays: int
}

// Outputs
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
output logAnalyticsCustomerId string = logAnalyticsWorkspace.properties.customerId
output logAnalyticsSolutions array = logAnalyticsWorkspaceSolutions
output automationAccountName string = automationAccount.name
output automationAccountId string = automationAccount.id
output storageAccountName string = storageAccount.outputs.name
output storageAccountId string = storageAccount.outputs.resourceId
