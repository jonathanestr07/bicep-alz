targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Management Group Policy Assignments'
metadata description = 'This module will assign Custom Policy Assignments to the ALZ Management Group hierarchy'
metadata version = '1.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Prefix for the management group hierarchy.')
@minLength(2)
@maxLength(15)
param topLevelManagementGroupPrefix string = 'alz'

@description('Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix')
@maxLength(10)
param topLevelManagementGroupSuffix string = ''

@description('Set Enforcement Mode on Azure Policy assignments to Do Not Enforce.')
param disablePolicies bool = false

@description('Required. Log Analytics Workspace Resource ID.')
param logAnalyticsWorkspaceId string

@description('DNS Server Virtual Network Resource Id.')
param virtualNetworkResourceId array = []

@description('Required. Resource Id of the Storage Account for Platform Logging.')
param storageAccountResourceId string = ''

@description('Adding assignment definition names to this array will exclude the specific policies from assignment.')
param excludedPolicyAssignments array = []

var deploymentNameWrappers = {
  basePrefix: 'Insight'
  #disable-next-line no-loc-expr-outside-params
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, topLevelManagementGroupPrefix)}'
}

var moduleDeploymentNames = {
  policyAssignmentIntRootDeployAzFWDiagnostics: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployAzFWDiagnostics-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployUpdateManager: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployUpdateManager-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployAutomanage: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployAutomanage-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployGovernance: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployGovernance-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployNsgFlowLogs: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployNSGFlowLogs-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootEnforceNaming: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enforceNaming-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployActivityLogsStorage: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployActivityLogsStorage-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployPrivateDNSZoneLinks: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployPrivateDNSZoneLinks-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    60
  )
  policyAssignmentIntRootDeployGuestConfigPolicy: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployGuestConfigPolicy-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )

  policyAssignmentLZsDeployCIS: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployCIS-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLZsDeployISO: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployISO-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLZsDeployNIST: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployNIST-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLZsDeployISM: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployISM-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLZsDenyAzureResources: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyResources-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )

  policyAssignmentPlatformDenyResourceDeletion: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyResourceDeletion-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )

  policyAssignmentDeployAKSLogs: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployAKSLogs-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
}

// Policy Assignments Modules Variables

var policyAssignmentAzFWDiagnosticAssign = {
	definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-AzFw-Diag-Res'
	libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_deploy_azureFirewall_diagnostics_resourceSpecific.custom.tmpl.json')
}

var policyAssignmentDenyAzureResources = {
	definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
	libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_es_deny_azure_resources.tmpl.json')
}

var policyAssignmentDenyResourceDelete = {
	definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deny-Resource-Delete'
	libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_deny_resource_deletion.custom.tmpl.json')
}

var policyAssignmentDeployAzureCIS = {
	definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/c3f5c4d9-9a1d-4a99-85c0-7f93e384d5c5'
	libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_deploy_azure_cis_1.4.0.custom.tmpl.json')
}

var policyAssignmentDeployActivityLogSta = {
	definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-Activity-Log-Sta'
	libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_deploy_diagnostics_activity_log_storage.custom.tmpl.json')
}

var policyAssignmentDeployDNSZoneLink = {
	definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-DNSZone-Link'
	libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_deploy_dns_zone_link.custom.tmpl.json')
}

var policyAssignmentDeployISMProtected = {
	definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/27272c0b-c225-4cc3-b8b0-f2534b093077'
	libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_deploy_ism_protected.custom.tmpl.json')
}

var policyAssignmentDeployISO270012013 = {
	definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/89c6cddc-1c73-4ac1-b19c-54d1a15a42f2'
	libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_deploy_iso_27001_2013.custom.tmpl.json')
}

var policyAssignmentDeployNIST80053 = {
	definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/179d1daa-458f-4e47-8086-2a68d0d6c38f'
	libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_deploy_nist_800_53.custom.tmpl.json')
}

var policyAssignmentEnforceGovernance = {
	definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-GR-Governance'
	libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_enforce_governance.custom.tmpl.json')
}

var policyAssignmentEnforceNamingStandards = {
	definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Naming-Standards'
	libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_enforce_naming_standards.custom.tmpl.json')
}

var policyAssignmentDeployAKSLogs = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c66c325-74c8-42fd-a286-a74b0e2939d8'
  libDefinition: loadJsonContent('../lib/policy_assignments_custom/policy_assignment_deploy_aks_logs.custom.tmpl.json')
}

// RBAC Role Definitions Variables - Used For Policy Assignments
var rbacRoleDefinitionIds = {
  owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  logAnalyticsContributor: '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  monitoringContributor: '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  privateDnsZoneContributor: 'b12aa53e-6015-4669-85d0-8515ebb3ae7f'
  userAccessAdministrator: '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  vmContributor: '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
  connectedMachineResourceAdmin: 'cd570a14-e51a-42ad-bac8-bafd67325302'
}

// Management Groups Variables - Used For Policy Assignments
var managementGroupIds = {
  intRoot: '${topLevelManagementGroupPrefix}${topLevelManagementGroupSuffix}'
  platform: '${topLevelManagementGroupPrefix}-platform${topLevelManagementGroupSuffix}'
  platformManagement: '${topLevelManagementGroupPrefix}-platform-management${topLevelManagementGroupSuffix}'
  platformConnectivity: '${topLevelManagementGroupPrefix}-platform-connectivity${topLevelManagementGroupSuffix}'
  platformIdentity: '${topLevelManagementGroupPrefix}-platform-identity${topLevelManagementGroupSuffix}'
  landingZones: '${topLevelManagementGroupPrefix}-landingzones${topLevelManagementGroupSuffix}'
  landingZonesCorp: '${topLevelManagementGroupPrefix}-landingzones-corp${topLevelManagementGroupSuffix}'
  landingZonesOnline: '${topLevelManagementGroupPrefix}-landingzones-online${topLevelManagementGroupSuffix}'
  decommissioned: '${topLevelManagementGroupPrefix}-decommissioned${topLevelManagementGroupSuffix}'
  sandbox: '${topLevelManagementGroupPrefix}-sandbox${topLevelManagementGroupSuffix}'
}

var topLevelManagementGroupResourceId = '/providers/Microsoft.Management/managementGroups/${managementGroupIds.intRoot}'

// Modules - Policy Assignments - Intermediate Root Management Group

// Module - Policy Assignment - AKS Logs
module policyAssignmentLZsDeployAKSLogs '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployAKSLogs.libDefinition.name
) && !empty(logAnalyticsWorkspaceId)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentDeployAKSLogs
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployAKSLogs.definitionId
    policyAssignmentName: policyAssignmentDeployAKSLogs.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployAKSLogs.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployAKSLogs.libDefinition.properties.description
    policyAssignmentMetaData: policyAssignmentDeployAKSLogs.libDefinition.properties.metadata
    policyAssignmentParameters: policyAssignmentDeployAKSLogs.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      logAnalytics: {
        value: logAnalyticsWorkspaceId
      }
      AllMetrics: {
        value: 'False'
      }
      'kube-scheduler': {
        value: 'False'
      }
      'cluster-autoscaler': {
        value: 'False'
      }
    }
    policyAssignmentIdentityType: policyAssignmentDeployAKSLogs.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.logAnalyticsContributor
    ]
    policyAssignmentEnforcementMode: disablePolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployAKSLogs.libDefinition.properties.enforcementMode
    policyAssignmentNonComplianceMessages: policyAssignmentDeployAKSLogs.libDefinition.properties.nonComplianceMessages
    policyAssignmentNotScopes: policyAssignmentDeployAKSLogs.libDefinition.properties.notScopes
    policyAssignmentResourceSelectors: policyAssignmentDeployAKSLogs.libDefinition.properties.resourceSelectors
    policyAssignmentOverrides: policyAssignmentDeployAKSLogs.libDefinition.properties.overrides
  }
}

// Module - Policy Assignment - Deploy-Governance
module policyAssignmentIntRootDeployGovernance '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnforceGovernance.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDeployGovernance
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnforceGovernance.definitionId
    policyAssignmentName: policyAssignmentEnforceGovernance.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnforceGovernance.libDefinition.properties.displayName
    policyAssignmentMetaData: policyAssignmentEnforceGovernance.libDefinition.properties.metadata
    policyAssignmentDescription: policyAssignmentEnforceGovernance.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnforceGovernance.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {}
    policyAssignmentIdentityType: policyAssignmentEnforceGovernance.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.contributor
    ]
    policyAssignmentEnforcementMode: disablePolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnforceGovernance.libDefinition.properties.enforcementMode
    policyAssignmentNonComplianceMessages: policyAssignmentEnforceGovernance.libDefinition.properties.nonComplianceMessages
    policyAssignmentNotScopes: policyAssignmentEnforceGovernance.libDefinition.properties.notScopes
    policyAssignmentResourceSelectors: policyAssignmentEnforceGovernance.libDefinition.properties.resourceSelectors
    policyAssignmentOverrides: policyAssignmentEnforceGovernance.libDefinition.properties.overrides
  }
}

// Module - Policy Assignment - Enforce Naming Standards
module policyAssignmentIntRootEnforceNaming '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnforceNamingStandards.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootEnforceNaming
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnforceNamingStandards.definitionId
    policyAssignmentName: policyAssignmentEnforceNamingStandards.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnforceNamingStandards.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnforceNamingStandards.libDefinition.properties.description
    policyAssignmentMetaData: policyAssignmentEnforceNamingStandards.libDefinition.properties.metadata
    policyAssignmentParameters: policyAssignmentEnforceNamingStandards.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {}
    policyAssignmentIdentityType: policyAssignmentEnforceNamingStandards.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: []
    policyAssignmentEnforcementMode: disablePolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnforceNamingStandards.libDefinition.properties.enforcementMode
    policyAssignmentNonComplianceMessages: policyAssignmentEnforceNamingStandards.libDefinition.properties.nonComplianceMessages
    policyAssignmentNotScopes: policyAssignmentEnforceNamingStandards.libDefinition.properties.notScopes
    policyAssignmentResourceSelectors: policyAssignmentEnforceNamingStandards.libDefinition.properties.resourceSelectors
    policyAssignmentOverrides: policyAssignmentEnforceNamingStandards.libDefinition.properties.overrides
  }
}

// Module - Policy Assignment - Deploy Activity Logs to Storage
module policyAssignmentIntRootDeployActivityLogsStorage '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployActivityLogSta.libDefinition.name
) && !empty(storageAccountResourceId)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDeployActivityLogsStorage
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployActivityLogSta.definitionId
    policyAssignmentName: policyAssignmentDeployActivityLogSta.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployActivityLogSta.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployActivityLogSta.libDefinition.properties.description
    policyAssignmentMetaData: policyAssignmentDeployActivityLogSta.libDefinition.properties.metadata
    policyAssignmentParameters: policyAssignmentDeployActivityLogSta.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      storageId: {
        value: storageAccountResourceId
      }
    }
    policyAssignmentIdentityType: policyAssignmentDeployActivityLogSta.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.contributor
    ]
    policyAssignmentEnforcementMode: disablePolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployActivityLogSta.libDefinition.properties.enforcementMode
    policyAssignmentNonComplianceMessages: policyAssignmentDeployActivityLogSta.libDefinition.properties.nonComplianceMessages
    policyAssignmentNotScopes: policyAssignmentDeployActivityLogSta.libDefinition.properties.notScopes
    policyAssignmentResourceSelectors: policyAssignmentDeployActivityLogSta.libDefinition.properties.resourceSelectors
    policyAssignmentOverrides: policyAssignmentDeployActivityLogSta.libDefinition.properties.overrides
  }
}

// Module - Policy Assignment - Deploy-Private-DNS-Zone-Links
module policyAssignmentIntRootDeployPrivateDNSZoneLinks '../policyAssignmentManagementGroup.bicep' = [
  for (virtualNetworkResourceId, index) in virtualNetworkResourceId: if (!contains(
    excludedPolicyAssignments,
    policyAssignmentDeployDNSZoneLink.libDefinition.name
  )) {
    scope: managementGroup(managementGroupIds.intRoot)
    name: '${moduleDeploymentNames.policyAssignmentIntRootDeployPrivateDNSZoneLinks}${index}'
    params: {
      policyAssignmentDefinitionId: policyAssignmentDeployDNSZoneLink.definitionId
      policyAssignmentName: take('${policyAssignmentDeployDNSZoneLink.libDefinition.name}-${index + 1}', 24)
      policyAssignmentDisplayName: '${policyAssignmentDeployDNSZoneLink.libDefinition.properties.displayName} #${index + 1 }'
      policyAssignmentDescription: policyAssignmentDeployDNSZoneLink.libDefinition.properties.description
      policyAssignmentMetaData: policyAssignmentDeployDNSZoneLink.libDefinition.properties.metadata
      policyAssignmentParameters: policyAssignmentDeployDNSZoneLink.libDefinition.properties.parameters
      policyAssignmentParameterOverrides: {
        virtualNetworkResourceId: {
          value: virtualNetworkResourceId
        }
      }
      policyAssignmentIdentityType: policyAssignmentDeployDNSZoneLink.libDefinition.identity.type
      policyAssignmentIdentityRoleDefinitionIds: [
        rbacRoleDefinitionIds.privateDnsZoneContributor
      ]
      policyAssignmentEnforcementMode: disablePolicies
        ? 'DoNotEnforce'
        : policyAssignmentDeployDNSZoneLink.libDefinition.properties.enforcementMode
      policyAssignmentNonComplianceMessages: policyAssignmentDeployDNSZoneLink.libDefinition.properties.nonComplianceMessages
      policyAssignmentNotScopes: policyAssignmentDeployDNSZoneLink.libDefinition.properties.notScopes
      policyAssignmentResourceSelectors: policyAssignmentDeployDNSZoneLink.libDefinition.properties.resourceSelectors
      policyAssignmentOverrides: policyAssignmentDeployDNSZoneLink.libDefinition.properties.overrides
    }
  }
]

module policyAssignmentIntRootDeployAzFWDiagnostics '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentAzFWDiagnosticAssign.libDefinition.name
) && !empty(logAnalyticsWorkspaceId)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDeployAzFWDiagnostics
  params: {
    policyAssignmentDefinitionId: policyAssignmentAzFWDiagnosticAssign.definitionId
    policyAssignmentName: policyAssignmentAzFWDiagnosticAssign.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentAzFWDiagnosticAssign.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentAzFWDiagnosticAssign.libDefinition.properties.description
    policyAssignmentMetaData: policyAssignmentAzFWDiagnosticAssign.libDefinition.properties.metadata
    policyAssignmentParameters: policyAssignmentAzFWDiagnosticAssign.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      logAnalytics: {
        value: logAnalyticsWorkspaceId
      }
    }
    policyAssignmentIdentityType: policyAssignmentAzFWDiagnosticAssign.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: []
    policyAssignmentEnforcementMode: disablePolicies
      ? 'DoNotEnforce'
      : policyAssignmentAzFWDiagnosticAssign.libDefinition.properties.enforcementMode
    policyAssignmentNonComplianceMessages: policyAssignmentAzFWDiagnosticAssign.libDefinition.properties.nonComplianceMessages
    policyAssignmentNotScopes: policyAssignmentAzFWDiagnosticAssign.libDefinition.properties.notScopes
    policyAssignmentResourceSelectors: policyAssignmentAzFWDiagnosticAssign.libDefinition.properties.resourceSelectors
    policyAssignmentOverrides: policyAssignmentAzFWDiagnosticAssign.libDefinition.properties.overrides
  }
}

// Modules - Policy Assignments - Connectivity Management Group

// Modules - Policy Assignments - Identity Management Group

// Modules - Policy Assignments - Landing Zones Management Group
// Module - Policy Assignment - Deploy-Azure-CIS
module policyAssignmentLZsDeployAzureCIS '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployAzureCIS.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLZsDeployCIS
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployAzureCIS.definitionId
    policyAssignmentName: policyAssignmentDeployAzureCIS.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployAzureCIS.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployAzureCIS.libDefinition.properties.description
    policyAssignmentMetaData: policyAssignmentDeployAzureCIS.libDefinition.properties.metadata
    policyAssignmentParameters: policyAssignmentDeployAzureCIS.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {}
    policyAssignmentIdentityType: policyAssignmentDeployAzureCIS.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: []
    policyAssignmentEnforcementMode: disablePolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployAzureCIS.libDefinition.properties.enforcementMode
    policyAssignmentNonComplianceMessages: policyAssignmentDeployAzureCIS.libDefinition.properties.nonComplianceMessages
    policyAssignmentNotScopes: policyAssignmentDeployAzureCIS.libDefinition.properties.notScopes
    policyAssignmentResourceSelectors: policyAssignmentDeployAzureCIS.libDefinition.properties.resourceSelectors
    policyAssignmentOverrides: policyAssignmentDeployAzureCIS.libDefinition.properties.overrides
  }
}

// Module - Policy Assignment - Deploy-ISO-27001-2013
module policyAssignmentLZsDeployISO27001 '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployISO270012013.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLZsDeployISO
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployISO270012013.definitionId
    policyAssignmentName: policyAssignmentDeployISO270012013.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployISO270012013.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployISO270012013.libDefinition.properties.description
    policyAssignmentMetaData: policyAssignmentDeployISO270012013.libDefinition.properties.metadata
    policyAssignmentParameters: policyAssignmentDeployISO270012013.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {}
    policyAssignmentIdentityType: policyAssignmentDeployISO270012013.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.contributor
    ]
    policyAssignmentEnforcementMode: disablePolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployISO270012013.libDefinition.properties.enforcementMode
    policyAssignmentNonComplianceMessages: policyAssignmentDeployISO270012013.libDefinition.properties.nonComplianceMessages
    policyAssignmentNotScopes: policyAssignmentDeployISO270012013.libDefinition.properties.notScopes
    policyAssignmentResourceSelectors: policyAssignmentDeployISO270012013.libDefinition.properties.resourceSelectors
    policyAssignmentOverrides: policyAssignmentDeployISO270012013.libDefinition.properties.overrides
  }
}

// Module - Policy Assignment - Deploy-NIST-800-53
module policyAssignmentLZsDeployNist '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployNIST80053.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLZsDeployNIST
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployNIST80053.definitionId
    policyAssignmentName: policyAssignmentDeployNIST80053.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployNIST80053.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployNIST80053.libDefinition.properties.description
    policyAssignmentMetaData: policyAssignmentDeployNIST80053.libDefinition.properties.metadata
    policyAssignmentParameters: policyAssignmentDeployNIST80053.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {}
    policyAssignmentIdentityType: policyAssignmentDeployNIST80053.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.contributor
    ]
    policyAssignmentEnforcementMode: disablePolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployNIST80053.libDefinition.properties.enforcementMode
    policyAssignmentNonComplianceMessages: policyAssignmentDeployNIST80053.libDefinition.properties.nonComplianceMessages
    policyAssignmentNotScopes: policyAssignmentDeployNIST80053.libDefinition.properties.notScopes
    policyAssignmentResourceSelectors: policyAssignmentDeployNIST80053.libDefinition.properties.resourceSelectors
    policyAssignmentOverrides: policyAssignmentDeployNIST80053.libDefinition.properties.overrides
  }
}

// Module - Policy Assignment - Deploy-ISM-Protected
module policyAssignmentLZsDeployIsm '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployISMProtected.libDefinition.name
) && !empty(logAnalyticsWorkspaceId)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLZsDeployISM
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployISMProtected.definitionId
    policyAssignmentName: policyAssignmentDeployISMProtected.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployISMProtected.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployISMProtected.libDefinition.properties.description
    policyAssignmentMetaData: policyAssignmentDeployISMProtected.libDefinition.properties.metadata
    policyAssignmentParameters: policyAssignmentDeployISMProtected.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      logAnalyticsWorkspaceId: {
        value: logAnalyticsWorkspaceId
      }
    }
    policyAssignmentIdentityType: policyAssignmentDeployISMProtected.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.contributor
    ]
    policyAssignmentEnforcementMode: disablePolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployISMProtected.libDefinition.properties.enforcementMode
    policyAssignmentNonComplianceMessages: policyAssignmentDeployISMProtected.libDefinition.properties.nonComplianceMessages
    policyAssignmentNotScopes: policyAssignmentDeployISMProtected.libDefinition.properties.notScopes
    policyAssignmentResourceSelectors: policyAssignmentDeployISMProtected.libDefinition.properties.resourceSelectors
    policyAssignmentOverrides: policyAssignmentDeployISMProtected.libDefinition.properties.overrides
  }
}

// Module - Policy Assignment - Deny Azure Resources
module policyAssignmentLZsDenyAzureResources '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyAzureResources.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLZsDenyAzureResources
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyAzureResources.definitionId
    policyAssignmentName: policyAssignmentDenyAzureResources.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyAzureResources.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyAzureResources.libDefinition.properties.description
    policyAssignmentMetaData: policyAssignmentDenyAzureResources.libDefinition.properties.metadata
    policyAssignmentParameters: policyAssignmentDenyAzureResources.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {}
    policyAssignmentIdentityType: policyAssignmentDenyAzureResources.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: []
    policyAssignmentEnforcementMode: disablePolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyAzureResources.libDefinition.properties.enforcementMode
    policyAssignmentNonComplianceMessages: policyAssignmentDenyAzureResources.libDefinition.properties.nonComplianceMessages
    policyAssignmentNotScopes: policyAssignmentDenyAzureResources.libDefinition.properties.notScopes
    policyAssignmentResourceSelectors: policyAssignmentDenyAzureResources.libDefinition.properties.resourceSelectors
    policyAssignmentOverrides: policyAssignmentDenyAzureResources.libDefinition.properties.overrides
  }
}

// Modules - Policy Assignments - Corp Management Group

// Landing Zone - Decommissioned Management Group Scope

// Landing Zone - Platform Management Group Scope

// Module - Policy Assignment - Deny Resource Deletion
module policyAssignmentPlatfornDenyResourceDeletion '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyResourceDelete.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformDenyResourceDeletion
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyResourceDelete.definitionId
    policyAssignmentName: policyAssignmentDenyResourceDelete.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyResourceDelete.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyResourceDelete.libDefinition.properties.description
    policyAssignmentMetaData: policyAssignmentDenyResourceDelete.libDefinition.properties.metadata
    policyAssignmentParameters: policyAssignmentDenyResourceDelete.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {}
    policyAssignmentIdentityType: policyAssignmentDenyResourceDelete.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.owner
    ]
    policyAssignmentEnforcementMode: disablePolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyResourceDelete.libDefinition.properties.enforcementMode
    policyAssignmentNonComplianceMessages: policyAssignmentDenyResourceDelete.libDefinition.properties.nonComplianceMessages
    policyAssignmentNotScopes: policyAssignmentDenyResourceDelete.libDefinition.properties.notScopes
    policyAssignmentResourceSelectors: policyAssignmentDenyResourceDelete.libDefinition.properties.resourceSelectors
    policyAssignmentOverrides: policyAssignmentDenyResourceDelete.libDefinition.properties.overrides
  }
}
