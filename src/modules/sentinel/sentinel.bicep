import { locPrefixes, resPrefixes } from '../../configuration/shared.conf.bicep'

metadata name = 'Azure Sentinel'
metadata description = 'Deploys Azure Sentinel, settings, solutions and its dependencies. Expects Log Analytics Workspace to already exist.'
metadata version = '1.1.0'
metadata author = 'Trent Steenholdt'

@description('Optional. Location for the storage account.')
param location string = resourceGroup().location

@description('Required. Specifies the name of the Log Analytics Workspace.')
param workspaceName string

@description('Required. Specifies the name of the user-assigned identity to create for the deployment script.')
param uaiSentinelName string

@description('Optional. Specifies the state of all the data connectors deployed in this template.')
@allowed([
  'Enabled'
  'Disabled'
])
param dataState string = 'Enabled'

@description('Optional. Tags that will be applied to all resources in this module.')
param tags object = {}

@description('Optional. Array of Microsoft Sentinel Content Solutions to deploy.')
param sentinelContentSolutions array = []

@description('Required. Date when the Sentinel solution was first deployed, must be in YYYY-MM-DD format.')
param sentinelFirstDeploymentDate string

@description('Current date in UTC')
param currentDate string = utcNow()

var currentDateOnly = substring(currentDate, 0, 10)
var isAfterCutoff = currentDateOnly > sentinelFirstDeploymentDate
var isFirstRunbyDate = sentinelFirstDeploymentDate == currentDateOnly
var subscriptionId = subscription().subscriptionId
var tenantId = tenant().tenantId
var roleDefinitionId = 'ab8e14d6-4a74-4a29-9ba8-549422addade' // Microsoft Sentinel Contributor Role Definition ID 

@description('Resource: Log Analytics Workspace (Existing).')
resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: workspaceName
}

@description('Resource: Microsoft Sentinel solution.')
resource sentinel 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'SecurityInsights(${workspaceName})'
  location: location
  properties: {
    workspaceResourceId: workspace.id
  }
  plan: {
    name: 'SecurityInsights(${workspaceName})'
    product: 'OMSGallery/SecurityInsights'
    promotionCode: ''
    publisher: 'Microsoft'
  }
  tags: tags
}

@description('Resource: Enable Microsoft Sentinel.')
resource onboardingStates 'Microsoft.SecurityInsights/onboardingStates@2024-09-01' = {
  scope: workspace
  name: 'default'
}

@description('Resource: Entity Analytics Service for Microsoft Sentinel.')
// This is not truly idempotent, because of a etag bug in the API. See https://github.com/Azure/bicep-types-az/issues/1557. Hence the if statement.
resource EntityAnalytics 'Microsoft.SecurityInsights/settings@2024-04-01-preview' = if (!(isAfterCutoff)) {
  name: 'EntityAnalytics'
  kind: 'EntityAnalytics'
  scope: workspace
  properties: {
    entityProviders: [
      'AzureActiveDirectory'
    ]
  }
  dependsOn: [
    onboardingStates
  ]
}

@description('Resource: Data Connector - Azure Active Directory.')
resource azureADDataConnector 'Microsoft.SecurityInsights/dataConnectors@2024-09-01' = {
  name: '${workspaceName}-AzureActiveDirectory'
  kind: 'AzureActiveDirectory'
  scope: workspace
  dependsOn: [
    sentinel
  ]
  properties: {
    dataTypes: {
      alerts: {
        state: dataState
      }
    }
    tenantId: tenantId
  }
}

@description('Resource: Data Source - Azure Activity.')
resource azureActivityDataSource 'Microsoft.OperationalInsights/workspaces/dataSources@2023-09-01' = {
  parent: workspace
  name: replace(subscriptionId, '-', '')
  kind: 'AzureActivityLog'
  properties: {
    linkedResourceId: subscriptionResourceId('microsoft.insights/eventtypes', 'management')
  }
}

@description('Resource: UEBA configuration for Microsoft Sentinel')
// This is not truly idempotent, because of a etag bug in the API. See https://github.com/Azure/bicep-types-az/issues/1557. Hence the if statement.
resource uebaAnalytics 'Microsoft.SecurityInsights/settings@2024-04-01-preview' = if (!(isAfterCutoff)) {
  name: 'Ueba'
  kind: 'Ueba'
  scope: workspace
  properties: {
    dataSources: [
      'AuditLogs'
      'AzureActivity'
      'SigninLogs'
      'SecurityEvent'
    ]
  }
  dependsOn: [
    EntityAnalytics
  ]
}

@description('Resource: Data Connector - Microsoft Defender for Cloud.')
resource defenderCloudConnector 'Microsoft.SecurityInsights/dataConnectors@2024-09-01' = {
  name: '${workspaceName}-DefenderForCloud'
  kind: 'AzureSecurityCenter'
  scope: workspace
  dependsOn: [
    sentinel
  ]
  properties: {
    subscriptionId: subscription().subscriptionId
    dataTypes: {
      alerts: {
        state: dataState
      }
    }
  }
}

@description('Resource: Data Connector - Microsoft Entra ID (AAD Identity Protection).')
resource entraIDConnector 'Microsoft.SecurityInsights/dataConnectors@2024-09-01' = {
  name: '${workspaceName}-AzureAdvancedThreatProtection'
  kind: 'AzureAdvancedThreatProtection'
  scope: workspace
  dependsOn: [
    sentinel
  ]
  properties: {
    tenantId: tenantId
    dataTypes: {
      alerts: {
        state: dataState
      }
    }
  }
}

@description('Resource: Data Connector - Threat Intelligence.')
resource threatIntelligenceConnector 'Microsoft.SecurityInsights/dataConnectors@2024-09-01' = {
  name: '${workspaceName}-ThreatIntelligence'
  kind: 'ThreatIntelligence'
  scope: workspace
  dependsOn: [
    sentinel
  ]
  properties: {
    tenantId: tenantId
    dataTypes: {
      indicators: {
        state: dataState
      }
    }
  }
}
@description('Resource: User Assigned Identity.')
resource scriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: uaiSentinelName
  location: location
}

@description('Resource: Deploment Script - Pausing for 5 minutes to allow the new user identity to propagate. Do this only on the first run.')
resource pauseScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = if (isFirstRunbyDate) {
  name: 'pauseScript'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '12.2.0'
    scriptContent: 'Start-Sleep -Seconds 300'
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
  dependsOn: [
    scriptIdentity
  ]
}

@description('Resource: Role Assignment - Sentinel Contributor rights on the resource group to the user identity that was just created.')
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().name, roleDefinitionId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: scriptIdentity.properties.principalId
  }
  dependsOn: [
    pauseScript
  ]
}

@description('Resource: Deployment Script - Calls the external PowerShell script to deploy the solutions and rules.')
resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'sentinel-deployment-script'
  kind: 'AzurePowerShell'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${scriptIdentity.id}': {}
    }
  }
  properties: {
    azPowerShellVersion: '12.2.0'
    arguments: '-ResourceGroup ${resourceGroup().name} -Workspace ${workspaceName} -Region ${location} -Solutions ${sentinelContentSolutions}'
    scriptContent: loadTextContent('./Create-NewSolutionAndRulesFromList.ps1') // Local copy of script from https://github.com/Azure/Azure-Sentinel/blob/master/Tools/Sentinel-All-In-One/v2/Scripts/Create-NewSolutionAndRulesFromList.ps1
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
  dependsOn: [
    roleAssignment
  ]
}

// Outputs
output logAnalyticsWorkspaceName string = workspace.name
output logAnalyticsWorkspaceId string = workspace.id
output sentinelId string = sentinel.id
output sentinelName string = sentinel.name
output azureADDataConnectorId string = azureADDataConnector.id
output defenderCloudConnectorId string = defenderCloudConnector.id
output entraIDConnectorId string = entraIDConnector.id
output threatIntelligenceConnectorId string = threatIntelligenceConnector.id
