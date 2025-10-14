targetScope = 'managementGroup'

metadata name = 'ALZ Bicep Module - Custom Policy Exemptions'
metadata description = 'Custom Policy Exemptions for Azure Landing Zones'
metadata author = 'Insight APAC Platform Engineering'

@description('Prefix for the Management Group hierarchy.')
@minLength(2)
@maxLength(15)
param topLevelManagementGroupPrefix string = 'alz'

// Module Variables
var deploymentNameWrappers = {
  basePrefix: 'custom'
  #disable-next-line no-loc-expr-outside-params
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, topLevelManagementGroupPrefix)}'
}

var moduleDeploymentNames = {
  policyExemptionLZsDeployISM: take(
    '${deploymentNameWrappers.basePrefix}-polExe-Deploy-ISM-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyExemptionLZsDeployASC: take(
    '${deploymentNameWrappers.basePrefix}-polExe-Deploy-ASC-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyExemptionLZsDeployCIS: take(
    '${deploymentNameWrappers.basePrefix}-polExe-Deploy-CIS-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyExemptionLZsDeployISO: take(
    '${deploymentNameWrappers.basePrefix}-polExe-Deploy-ISO-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyExemptionLZsDeployNIST: take(
    '${deploymentNameWrappers.basePrefix}-polExe-Deploy-NIST-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
}

// This variable contains a number of objects that load in the Azure Policy Exemptions that are provided from the Lib folder, this is automatically created in the file 'src\modules\policy\exemptions\lib\policy_exemptions\_policyExemptionsBicepInput.txt' and is then manually copied into this variable.
var policyExemptionDeployISMProtected = {
  libExemption: loadJsonContent('../lib/policy_exemptions/policy_exemption_augov_ism_protected.custom.jsonc')
}
var policyExemptionDeployAzureCIS = {
  libExemption: loadJsonContent('../lib/policy_exemptions/policy_exemption_azure_cis_v1.4.0.custom.jsonc')
}
var policyExemptionDeployASCMonitoring = {
  libExemption: loadJsonContent('../lib/policy_exemptions/policy_exemption_azure_security_benchmark_v3.custom.jsonc')
}
var policyExemptionDeployISO270012013 = {
  libExemption: loadJsonContent('../lib/policy_exemptions/policy_exemption_iso_27001-2013.custom.jsonc')
}
var policyExemptionDeployNIST80053 = {
  libExemption: loadJsonContent('../lib/policy_exemptions/policy_exemption_nist_sp_800_53.custom.jsonc')
}

// Management Groups Varaibles - Used For Policy Assignments
var managementGroupIDs = {
  intRoot: topLevelManagementGroupPrefix
  platform: '${topLevelManagementGroupPrefix}-platform'
  platformManagement: '${topLevelManagementGroupPrefix}-platform-management'
  platformConnectivity: '${topLevelManagementGroupPrefix}-platform-connectivity'
  platformIdentity: '${topLevelManagementGroupPrefix}-platform-identity'
  landingZones: '${topLevelManagementGroupPrefix}-landingzones'
  landingZonesCorp: '${topLevelManagementGroupPrefix}-landingzones-corp'
  landingZonesOnline: '${topLevelManagementGroupPrefix}-landingzones-online'
  decommissioned: '${topLevelManagementGroupPrefix}-decommissioned'
  sandbox: '${topLevelManagementGroupPrefix}-sandbox'
}

// Root Management Group Scope
// Module - Policy Exemption - Deploy-ASC-Monitoring
module policyExemptionLzDeployASC '../policyExemptions.bicep' = {
  scope: managementGroup(managementGroupIDs.intRoot)
  name: moduleDeploymentNames.policyExemptionLZsDeployASC
  params: {
    policyExemptionName: policyExemptionDeployASCMonitoring.libExemption.name
    policyExemptionDisplayName: policyExemptionDeployASCMonitoring.libExemption.properties.displayName
    policyExemptionDescription: policyExemptionDeployASCMonitoring.libExemption.properties.description
    policyExemptionMetadata: policyExemptionDeployASCMonitoring.libExemption.properties.metadata
    policyExemptionCategory: policyExemptionDeployASCMonitoring.libExemption.properties.exemptionCategory
    policyExemptionAssignmentId: policyExemptionDeployASCMonitoring.libExemption.properties.policyAssignmentId
    policyExemptionDefinitionReferenceIds: policyExemptionDeployASCMonitoring.libExemption.properties.policyDefinitionReferenceIds
    policyExemptionExpiresOn: policyExemptionDeployASCMonitoring.libExemption.properties.expiresOn
    policyExemptionAssignmentScopeValidation: policyExemptionDeployASCMonitoring.libExemption.properties.assignmentScopeValidation
  }
}

// Landing Zone Management Group Scope
// Module - Policy Exemption - Deploy-Azure-CIS
module policyExemptionLzDeployCIS '../policyExemptions.bicep' = {
  scope: managementGroup(managementGroupIDs.landingZones)
  name: moduleDeploymentNames.policyExemptionLZsDeployCIS
  params: {
    policyExemptionName: policyExemptionDeployAzureCIS.libExemption.name
    policyExemptionDisplayName: policyExemptionDeployAzureCIS.libExemption.properties.displayName
    policyExemptionDescription: policyExemptionDeployAzureCIS.libExemption.properties.description
    policyExemptionMetadata: policyExemptionDeployAzureCIS.libExemption.properties.metadata
    policyExemptionCategory: policyExemptionDeployAzureCIS.libExemption.properties.exemptionCategory
    policyExemptionAssignmentId: policyExemptionDeployAzureCIS.libExemption.properties.policyAssignmentId
    policyExemptionDefinitionReferenceIds: policyExemptionDeployAzureCIS.libExemption.properties.policyDefinitionReferenceIds
    policyExemptionExpiresOn: policyExemptionDeployAzureCIS.libExemption.properties.expiresOn
    policyExemptionAssignmentScopeValidation: policyExemptionDeployAzureCIS.libExemption.properties.assignmentScopeValidation
  }
}

// Module - Policy Exemption - Deploy-Azure-ISO
module policyExemptionLzDeployISO '../policyExemptions.bicep' = {
  scope: managementGroup(managementGroupIDs.landingZones)
  name: moduleDeploymentNames.policyExemptionLZsDeployISO
  params: {
    policyExemptionName: policyExemptionDeployISO270012013.libExemption.name
    policyExemptionDisplayName: policyExemptionDeployISO270012013.libExemption.properties.displayName
    policyExemptionDescription: policyExemptionDeployISO270012013.libExemption.properties.description
    policyExemptionMetadata: policyExemptionDeployISO270012013.libExemption.properties.metadata
    policyExemptionCategory: policyExemptionDeployISO270012013.libExemption.properties.exemptionCategory
    policyExemptionAssignmentId: policyExemptionDeployISO270012013.libExemption.properties.policyAssignmentId
    policyExemptionDefinitionReferenceIds: policyExemptionDeployISO270012013.libExemption.properties.policyDefinitionReferenceIds
    policyExemptionExpiresOn: policyExemptionDeployISO270012013.libExemption.properties.expiresOn
    policyExemptionAssignmentScopeValidation: policyExemptionDeployISO270012013.libExemption.properties.assignmentScopeValidation
  }
}

// Module - Policy Exemption - Deploy-Azure-NIST
module policyExemptionLzDeployNIST '../policyExemptions.bicep' = {
  scope: managementGroup(managementGroupIDs.landingZones)
  name: moduleDeploymentNames.policyExemptionLZsDeployNIST
  params: {
    policyExemptionName: policyExemptionDeployNIST80053.libExemption.name
    policyExemptionDisplayName: policyExemptionDeployNIST80053.libExemption.properties.displayName
    policyExemptionDescription: policyExemptionDeployNIST80053.libExemption.properties.description
    policyExemptionMetadata: policyExemptionDeployNIST80053.libExemption.properties.metadata
    policyExemptionCategory: policyExemptionDeployNIST80053.libExemption.properties.exemptionCategory
    policyExemptionAssignmentId: policyExemptionDeployNIST80053.libExemption.properties.policyAssignmentId
    policyExemptionDefinitionReferenceIds: policyExemptionDeployNIST80053.libExemption.properties.policyDefinitionReferenceIds
    policyExemptionExpiresOn: policyExemptionDeployNIST80053.libExemption.properties.expiresOn
    policyExemptionAssignmentScopeValidation: policyExemptionDeployNIST80053.libExemption.properties.assignmentScopeValidation
  }
}

// Module - Policy Exemption - Deploy-ISM-Protected
module policyExemptionLzDeployISM '../policyExemptions.bicep' = {
  scope: managementGroup(managementGroupIDs.landingZones)
  name: moduleDeploymentNames.policyExemptionLZsDeployISM
  params: {
    policyExemptionName: policyExemptionDeployISMProtected.libExemption.name
    policyExemptionDisplayName: policyExemptionDeployISMProtected.libExemption.properties.displayName
    policyExemptionDescription: policyExemptionDeployISMProtected.libExemption.properties.description
    policyExemptionMetadata: policyExemptionDeployISMProtected.libExemption.properties.metadata
    policyExemptionCategory: policyExemptionDeployISMProtected.libExemption.properties.exemptionCategory
    policyExemptionAssignmentId: policyExemptionDeployISMProtected.libExemption.properties.policyAssignmentId
    policyExemptionDefinitionReferenceIds: policyExemptionDeployISMProtected.libExemption.properties.policyDefinitionReferenceIds
    policyExemptionExpiresOn: policyExemptionDeployISMProtected.libExemption.properties.expiresOn
    policyExemptionAssignmentScopeValidation: policyExemptionDeployISMProtected.libExemption.properties.assignmentScopeValidation
  }
}
