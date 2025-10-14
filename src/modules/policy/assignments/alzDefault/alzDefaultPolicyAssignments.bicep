metadata name = 'ALZ Bicep - ALZ Default Policy Assignments'
metadata description = 'This module will assign the ALZ Default Policy Assignments to the ALZ Management Group hierarchy'
metadata version = '2.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Prefix used for the management group hierarchy.')
@minLength(2)
@maxLength(15)
param topLevelManagementGroupPrefix string = 'alz'

@description('Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix')
@maxLength(10)
param topLevelManagementGroupSuffix string = ''

@description('Management, Identity and Connectivity Management Groups beneath Platform Management Group have been deployed. If set to false, platform policies are assigned to the Platform Management Group; otherwise policies are assigned to the child management groups.')
param platformMgAlzDefaultsEnable bool = true

@description('Corp & Online Management Groups beneath Landing Zones Management Groups have been deployed. If set to false, policies will not try to be assigned to corp or online Management Groups.')
param landingZoneChildrenMgAlzDefaultsEnable bool = true

@description('The region where the Log Analytics Workspace & Automation Account are deployed.')
param logAnalyticsWorkSpaceAndAutomationAccountLocation string = 'australiaeast'

@description('The list of locations that your organization can use to restrict deploying resources to. If left empty, only the deployment location will be allowed.')
param listOfAllowedLocations array = []

@description('Log Analytics Workspace Resource ID.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Data Collection Rule VM Insights Resource ID.')
param dataCollectionRuleVMInsightsResourceId string = ''

@description('Data Collection Rule Change Tracking Resource ID.')
param dataCollectionRuleChangeTrackingResourceId string = ''

@description('Data Collection Rule MDFC SQL Resource ID.')
param dataCollectionRuleMDFCSQLResourceId string = ''

@description('User Assigned Managed Identity Resource ID.')
param userAssignedManagedIdentityResourceId string = ''

@description('Number of days of log retention for Log Analytics Workspace.')
param logAnalyticsWorkspaceLogRetentionInDays string = '365'

@description('Automation account name.')
param automationAccountName string = 'alz-automation-account'

@description('An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.')
param msDefenderForCloudEmailSecurityContact string = 'security_contact@replace_me.com'

@description('Switch to enable/disable DDoS Network Protection deployment. True will enforce policy Enable-DDoS-VNET at connectivity or landing zone Management Groups. False will not enforce policy Enable-DDoS-VNET.')
param ddosEnabled bool = false

@description('ID of the DdosProtectionPlan which will be applied to the Virtual Networks.')
param ddosProtectionPlanId string = ''

@description('Resource ID of the Resource Group that contain the Private DNS Zones. If left empty, the policy Deploy-Private-DNS-Zones will not be assigned to the corp Management Group.')
param privateDnsResourceGroupId string = ''

@description('Provide an array/list of Private DNS Zones that you wish to audit if deployed into Subscriptions in the Corp Management Group. NOTE: The policy default values include all the static Private Link Private DNS Zones, e.g. all the DNS Zones that dont have a region or region shortcode in them. If you wish for these to be audited also you must provide a complete array/list to this parameter for ALL Private DNS Zones you wish to audit, including the static Private Link ones, as this parameter performs an overwrite operation. You can get all the Private DNS Zone Names form the `outPrivateDnsZonesNames` output in the Hub Networking or Private DNS Zone modules.')
param privateDnsZonesNamesToAuditInCorp array = []

@description('Set Enforcement Mode of all default Policies assignments to Do Not Enforce.')
param disableAlzDefaultPolicies bool = false

@description('Name of the tag to use for excluding VMs from the scope of this policy. This should be used along with the Exclusion Tag Value parameter.')
param vmBackupExclusionTagName string = ''

@description('Value of the tag to use for excluding VMs from the scope of this policy (in case of multiple values, use a comma-separated list). This should be used along with the Exclusion Tag Name parameter.')
param vmBackupExclusionTagValue array = []

@description('Adding assignment definition names to this array will exclude the specific policies from assignment. Find the correct values to this array in the following documentation: https://github.com/Azure/ALZ-Bicep/wiki/AssigningPolicies#what-if-i-want-to-exclude-specific-policy-assignments-from-alz-default-policy-assignments')
param excludedPolicyAssignments array = []

@description('Location of Private DNS Zones.')
param privateDnsZonesLocation string = ''

@description('Set Parameter to true to Opt-out of deployment telemetry')
param telemetryOptOut bool = false

var logAnalyticsWorkspaceName = split(logAnalyticsWorkspaceResourceId, '/')[8]

var logAnalyticsWorkspaceResourceGroupName = split(logAnalyticsWorkspaceResourceId, '/')[4]

var logAnalyticsWorkspaceSubscription = split(logAnalyticsWorkspaceResourceId, '/')[2]

var userAssignedManagedIdentityResourceName = split(userAssignedManagedIdentityResourceId, '/')[8]

// **Variables**
// Orchestration Module Variables
var deploymentNameWrappers = {
  basePrefix: 'ALZBicep'
  #disable-next-line no-loc-expr-outside-params //Policies resources are not deployed to a region, like other resources, but the metadata is stored in a region hence requiring this to keep input parameters reduced. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, topLevelManagementGroupPrefix)}'
}

var moduleDeploymentNames = {
  policyAssignmentIntRootEnforceSovereigntyGlobal: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enforceSovereigntyGlobal-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployMdfcConfig: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployMDFCConfig-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployAzActivityLog: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployAzActivityLog-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployAscMonitoring: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployASCMonitoring-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployResourceDiag: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployResourceDiag-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployMDEndpoints: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployMDEndpoints-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployMDEnpointsAma: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployMDEndpointsAma-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootEnforceAcsb: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enforceAcsb-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployMdfcOssDb: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployMdfcOssDb-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDeployMdfcSqlAtp: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployMdfcSqlAtp-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootAuditLocationMatch: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-auditLocationMatch-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootAuditZoneResiliency: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-auditZoneResiliency-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootAuditUnusedRes: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-auditUnusedRes-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootAuditTrustedLaunch: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-auditTrustedLaunch-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDenyClassicRes: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyClassicRes-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIntRootDenyUnmanagedDisks: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyUnmanagedDisks-intRoot-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentPlatformDeployVmArcTrack: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmArcChangeTrack-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentPlatformDeployVmChangeTrack: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmChangeTrack-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentPlatformDeployVmssChangeTrack: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmssChangeTrack-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentPlatformDeployVmArcMonitor: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmArcMonitor-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentPlatformDeployVmMonitor: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmMonitor-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentPlatformDeployVmssMonitor: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmssMonitor-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentPlatformDeployMdfcDefSqlAma: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyDeleteUamiAma-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentPlatformDenyDeleteUAMIAMA: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deny-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentPlatformEnforceGrKeyVault: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enforceGrKeyVault-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentPlatformEnforceAsr: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployEnforceBackup-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentPlatformEnforceAumCheckUpdates: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployEnforceAumCheckUpdates-platform-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentConnEnableDdosVnet: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enableDDoSVNET-conn-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIdentDenyPublicIp: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyPublicIP-ident-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIdentDenyMgmtPortsFromInternet: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyMgmtFromInet-ident-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIdentDenySubnetWithoutNsg: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-ident-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentIdentDeployVmBackup: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVMBackup-ident-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentMgmtDeployLogAnalytics: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployLAW-mgmt-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDenyIpForwarding: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyIPForward-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDenyMgmtPortsFromInternet: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyMgmtFromInet-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDenySubnetWithoutNsg: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeployVmBackup: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVMBackup-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsEnableDdosVnet: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enableDDoSVNET-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDenyStorageHttp: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyStorageHttp-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeployAksPolicy: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployAKSPolicy-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDenyPrivEscalationAks: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyPrivEscAKS-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDenyPrivContainersAks: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyPrivConAKS-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsEnforceAksHttps: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enforceAKSHTTPS-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsEnforceTlsSsl: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enforceTLSSSL-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeploySqlDbAuditing: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deploySQLDBAudit-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeployAzSqlDbAuditing: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployAzSQLDBAudit-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeploySqlThreat: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deploySQLThreat-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeploySqlTde: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deploySQLTde-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeployVmArcTrack: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmArcChangeTrack-Lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeployVmChangeTrack: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmChangeTrack-Lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeployVmssChangeTrack: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmssChangeTrack-Lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeployVmArcMonitor: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmArcMonitor-Lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeployVmMonitor: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmMonitor-Lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeployVmssMonitor: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployVmssMonitor-Lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsDeployMdfcDefSqlAma: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployMdfcDefSqlAma-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsEnforceGrKeyVault: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enforceGrKeyVault-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsEnforceAsr: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployEnforceBackup-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsAumCheckUpdates: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployEnforceAumCheckUpdates-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsAuditAppGwWaf: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-auditAppGwWaf-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsConfidentialOnlineEnforceSovereigntyConf: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enforceSovereigntyConf-confidential-online-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLZsDeploySQLSecurity: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deploySQLSecurity-lz-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLZsDenyResourceLocations: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyResourceLocations-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLZsDenyResourceGroupLocations: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyRGLocations-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )

  policyAssignmentLzsConfidentialCorpDenyPublicEndpoints: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyPublicEndpoints-confidential-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsCorpDenyPublicEndpoints: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyPublicEndpoints-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsCorpDeployPrivateDnsZones: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployPrivateDNS-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsConfidentialCorpEnforceSovereigntyConf: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enforceSovereigntyConf-confidential-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsConfidentialCorpDeployPrivateDnsZones: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-deployPrivateDNS-confidential-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsCorpDenyPipOnNic: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyPipOnNic-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsConfidentialCorpDenyPipOnNic: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyPipOnNic-confidential-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsCorpDenyHybridNet: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyHybridNet-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsConfidentialCorpDenyHybridNet: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-denyHybridNet-confidential-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsCorpAuditPeDnsZones: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-auditPeDnsZones-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentLzsConfidentialCorpAuditPeDnsZones: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-auditPeDnsZones-confidential-corp-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentDecommEnforceAlz: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enforceAlz-decomm-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
  policyAssignmentSandboxEnforceAlz: take(
    '${deploymentNameWrappers.basePrefix}-polAssi-enforceAlz-sbox-${deploymentNameWrappers.baseSuffixTenantAndManagementGroup}',
    64
  )
}

// Policy Assignments Modules Variables
var policyAssignmentAuditAppGWWAF = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/564feb30-bf6a-4854-b4bb-0d2d2d1e6c66'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_appgw_waf.tmpl.json')
}

var policyAssignmentAuditPeDnsZones = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Audit-PrivateLinkDnsZones'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_pednszones.tmpl.json')
}

var policyAssignmentAuditLocationMatch = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a914e76-4921-4c19-b460-a2d36003525a'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_res_location_match_rg_location.tmpl.json')
}

var policyAssignmentAuditTrustedLaunch = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Audit-TrustedLaunch'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_trustedlaunch.tmpl.json')
}

var policyAssignmentAuditUnusedResources = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Audit-UnusedResourcesCostOptimization'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_unusedresources.tmpl.json')
}

var policyAssignmentAuditZoneResiliency = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/130fb88f-0fc9-4678-bfe1-31022d71c7d5'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_audit_zoneresiliency.tmpl.json')
}

var policyAssignmentDenyClassicResources = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_classic-resources.tmpl.json')
}

var policyAssignmentDenyActionDeleteUAMIAMA = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/DenyAction-DeleteResources'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_deleteuamiama.tmlp.json')
}

var policyAssignmentEnforceAKSHTTPS = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1a5b4dca-0b6f-4cf5-907c-56316bc1bf3d'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_http_ingress_aks.tmpl.json')
}

var policyAssignmentDenyHybridNetworking = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_hybridnetworking.tmpl.json')
}

var policyAssignmentDenyIPForwarding = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_ip_forwarding.tmpl.json')
}

var policyAssignmentDenyMgmtPortsInternet = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-MgmtPorts-From-Internet'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_mgmtports_internet.tmpl.json')
}

var policyAssignmentDenyPrivContainersAKS = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_priv_containers_aks.tmpl.json')
}

var policyAssignmentDenyPrivEscalationAKS = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/1c6e92c9-99f0-4e55-9cf2-0c234dc48f99'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_priv_escalation_aks.tmpl.json')
}

var policyAssignmentDenyPublicEndpoints = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deny-PublicPaaSEndpoints'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_endpoints.tmpl.json')
}

var policyAssignmentDenyPublicIPOnNIC = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip_on_nic.tmpl.json')
}

var policyAssignmentDenyPublicIP = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip.tmpl.json')
}

var policyAssignmentDenyResourceLocations = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_resource_locations.tmpl.json')
}

var policyAssignmentDenyRSGLocations = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_rsg_locations.tmpl.json')
}

var policyAssignmentDenyStoragehttp = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_storage_http.tmpl.json')
}

var policyAssignmentDenySubnetWithoutNsg = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Nsg'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_subnet_without_nsg.tmpl.json')
}

var policyAssignmentDenyUnmanagedDisk = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_unmanageddisk.tmpl.json')
}

var policyAssignmentDeployAKSPolicy = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_aks_policy.tmpl.json')
}

var policyAssignmentDeployASCMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_asc_monitoring.tmpl.json')
}

var policyAssignmentDeployAzActivityLog = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/2465583e-4e78-4c15-b6be-a36cbc7c8b0f'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_azactivity_log.tmpl.json')
}

var policyAssignmentDeployAzSqlDbAuditing = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/25da7dfb-0666-4a15-a8f5-402127efd8bb'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_azsql_db_auditing.tmpl.json')
}

var policyAssignmentDeployLogAnalytics = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8e3e61b3-0b32-22d5-4edf-55f87fdb5955'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_log_analytics.tmpl.json')
}

var policyAssignmentDeployMDEndpointsAMA = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/77b391e3-2d5d-40c3-83bf-65c846b3c6a3'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_md_endpoints_ama.tmpl.json')
}

var policyAssignmentDeployMDEndpoints = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/e20d08c5-6d64-656d-6465-ce9e37fd0ebc'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdeendpoints.tmpl.json')
}

var policyAssignmentDeployMDFCConfigH224 = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-MDFC-Config_20240319'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdfc_config.tmpl.json')
}

var policyAssignmentDeployMDFCOssDb = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/e77fc0b3-f7e9-4c58-bc13-cb753ed8e46e'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdfc_ossdb.tmpl.json')
}

var policyAssignmentDeployMDFCDefSQLAMA = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/de01d381-bae9-4670-8870-786f89f49e26'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdfc_sql-ama.tmpl.json')
}

var policyAssignmentDeployMDFCSqlAtp = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/9cb3cc7a-b39b-4b82-bc89-e5a5d9ff7b97'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdfc_sqlatp.tmpl.json')
}

var policyAssignmentDeployPrivateDNSZones = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Private-DNS-Zones'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_private_dns_zones.tmpl.json')
}

var policyAssignmentDeployDiagLogs = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/0884adba-2312-4468-abeb-5422caed1038'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_resource_diag.tmpl.json')
}

var policyAssignmentDeploySQLSecurity = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_security.tmpl.json')
}

var policyAssignmentDeploySQLTDE = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/86a912f6-9a06-4e26-b447-11b16ba8659f'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_tde.tmpl.json')
}

var policyAssignmentDeploySQLThreat = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/36d49e87-48c4-4f2e-beed-ba4ed02b71f5'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_sql_threat.tmpl.json')
}

var policyAssignmentDeployvmArcChangeTrack = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/53448c70-089b-4f52-8f38-89196d7f2de1'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_arc_changetrack.tmpl.json')
}

var policyAssignmentDeployvmHybrMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/2b00397d-c309-49c4-aa5a-f0b2c5bc6321'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_arc_monitor.tmpl.json')
}

var policyAssignmentDeployVMBackup = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/98d0b9f8-fd90-49c9-88e2-d3baf3b0dd86'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_backup.tmpl.json')
}

var policyAssignmentDeployVMChangeTrack = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/92a36f05-ebc9-4bba-9128-b47ad2ea3354'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_changetrack.tmpl.json')
}

var policyAssignmentDeployVMMonitor24 = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/924bfe3a-762f-40e7-86dd-5c8b95eb09e6'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vm_monitor.tmpl.json')
}

var policyAssignmentDeployVMSSChangeTrack = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/c4a70814-96be-461c-889f-2b27429120dc'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vmss_changetrack.tmpl.json')
}

var policyAssignmentDeployVMSSMonitor24 = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/f5bf694c-cca7-4033-b883-3a23327d5485'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_vmss_monitor.tmpl.json')
}

var policyAssignmentEnableDDoSVNET = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/94de2ad3-e0c1-4caf-ad78-5d47bbc83d3d'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enable_ddos_vnet.tmpl.json')
}

var policyAssignmentEnforceACSB = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-ACSB'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_acsb.tmpl.json')
}

var policyAssignmentEnforceALZDecomm = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-ALZ-Decomm'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_alz_decomm.tmpl.json')
}

var policyAssignmentEnforceALZSandbox = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-ALZ-Sandbox'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_alz_sandbox.tmpl.json')
}

var policyAssignmentEnableAUMCheckUpdates = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-AUM-CheckUpdates'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_aum_checkupdates.tmpl.json')
}

var policyAssignmentEnforceASR = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Backup'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_backup.json')
}

var policyAssignmentEnforceGRKeyVault = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-Guardrails-KeyVault'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_gr_keyvault.tmpl.json')
}

var policyAssignmentEnforceTLSSSLQ225 = {
  definitionId: '${topLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Enforce-EncryptTransit_20241211'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_enforce_tls_ssl.tmpl.json')
}

// RBAC Role Definitions Variables - Used For Policy Assignments
var rbacRoleDefinitionIds = {
  owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  networkContributor: '4d97b98b-1d4f-4787-a291-c67834d212e7'
  aksContributor: 'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8'
  logAnalyticsContributor: '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  sqlSecurityManager: '056cd41c-7e88-42e1-933e-88ba6a50c9c3'
  vmContributor: '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
  monitoringContributor: '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  aksPolicyAddon: '18ed5180-3e48-46fd-8541-4ea054d57064'
  sqlDbContributor: '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec'
  backupContributor: '5e467623-bb1f-42f4-a55d-6e525e11384b'
  rbacSecurityAdmin: 'fb1c8493-542b-48eb-b624-b4c8fea62acd'
  reader: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  managedIdentityOperator: 'f1a07417-d97a-45cb-824c-7a7467783830'
  connectedMachineResourceAdministrator: 'cd570a14-e51a-42ad-bac8-bafd67325302'
}

// Management Groups Variables - Used For Policy Assignments
var managementGroupIds = {
  intRoot: '${topLevelManagementGroupPrefix}${topLevelManagementGroupSuffix}'
  platform: '${topLevelManagementGroupPrefix}-platform${topLevelManagementGroupSuffix}'
  platformManagement: platformMgAlzDefaultsEnable
    ? '${topLevelManagementGroupPrefix}-platform-management${topLevelManagementGroupSuffix}'
    : '${topLevelManagementGroupPrefix}-platform${topLevelManagementGroupSuffix}'
  platformConnectivity: platformMgAlzDefaultsEnable
    ? '${topLevelManagementGroupPrefix}-platform-connectivity${topLevelManagementGroupSuffix}'
    : '${topLevelManagementGroupPrefix}-platform${topLevelManagementGroupSuffix}'
  platformIdentity: platformMgAlzDefaultsEnable
    ? '${topLevelManagementGroupPrefix}-platform-identity${topLevelManagementGroupSuffix}'
    : '${topLevelManagementGroupPrefix}-platform${topLevelManagementGroupSuffix}'
  landingZones: '${topLevelManagementGroupPrefix}-landingzones${topLevelManagementGroupSuffix}'
  landingZonesCorp: '${topLevelManagementGroupPrefix}-landingzones-corp${topLevelManagementGroupSuffix}'
  landingZonesOnline: '${topLevelManagementGroupPrefix}-landingzones-online${topLevelManagementGroupSuffix}'
  decommissioned: '${topLevelManagementGroupPrefix}-decommissioned${topLevelManagementGroupSuffix}'
  sandbox: '${topLevelManagementGroupPrefix}-sandbox${topLevelManagementGroupSuffix}'
}

var topLevelManagementGroupResourceId = '/providers/Microsoft.Management/managementGroups/${managementGroupIds.intRoot}'

// Deploy-Private-DNS-Zones Variables

var privateDnsZonesResourceGroupSubscriptionId = !empty(privateDnsResourceGroupId)
  ? split(privateDnsResourceGroupId, '/')[2]
  : ''

var privateDnsZonesBaseResourceId = '${privateDnsResourceGroupId}/providers/Microsoft.Network/privateDnsZones/'

var varGeoCodes = {
  australiacentral: 'acl'
  australiacentral2: 'acl2'
  australiaeast: 'ae'
  australiasoutheast: 'ase'
  brazilsoutheast: 'bse'
  brazilsouth: 'brs'
  canadacentral: 'cnc'
  canadaeast: 'cne'
  centralindia: 'inc'
  centralus: 'cus'
  centraluseuap: 'ccy'
  chilecentral: 'clc'
  eastasia: 'ea'
  eastus: 'eus'
  eastus2: 'eus2'
  eastus2euap: 'ecy'
  francecentral: 'frc'
  francesouth: 'frs'
  germanynorth: 'gn'
  germanywestcentral: 'gwc'
  israelcentral: 'ilc'
  italynorth: 'itn'
  japaneast: 'jpe'
  japanwest: 'jpw'
  koreacentral: 'krc'
  koreasouth: 'krs'
  malaysiasouth: 'mys'
  malaysiawest: 'myw'
  mexicocentral: 'mxc'
  newzealandnorth: 'nzn'
  northcentralus: 'ncus'
  northeurope: 'ne'
  norwayeast: 'nwe'
  norwaywest: 'nww'
  polandcentral: 'plc'
  qatarcentral: 'qac'
  southafricanorth: 'san'
  southafricawest: 'saw'
  southcentralus: 'scus'
  southeastasia: 'sea'
  southindia: 'ins'
  spaincentral: 'spc'
  swedencentral: 'sdc'
  swedensouth: 'sds'
  switzerlandnorth: 'szn'
  switzerlandwest: 'szw'
  taiwannorth: 'twn'
  uaecentral: 'uac'
  uaenorth: 'uan'
  uksouth: 'uks'
  ukwest: 'ukw'
  westcentralus: 'wcus'
  westeurope: 'we'
  westindia: 'inw'
  westus: 'wus'
  westus2: 'wus2'
  westus3: 'wus3'
}

var selectedGeoCode = !empty(privateDnsZonesLocation)
  ? varGeoCodes[privateDnsZonesLocation]
  : varGeoCodes[logAnalyticsWorkSpaceAndAutomationAccountLocation]

var privateDnsZonesFinalResourceIds = {
  azureAcrPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.azurecr.io'
  azureAppPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.azconfig.io'
  azureAppServicesPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.azurewebsites.net'
  azureArcGuestconfigurationPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.guestconfiguration.azure.com'
  azureArcHybridResourceProviderPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.his.arc.azure.com'
  azureArcKubernetesConfigurationPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.dp.kubernetesconfiguration.azure.com'
  azureAsrPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.siterecovery.windowsazure.com'
  azureAutomationDSCHybridPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.azure-automation.net'
  azureAutomationWebhookPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.azure-automation.net'
  azureBatchPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.batch.azure.com'
  azureBotServicePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.directline.botframework.com'
  azureCognitiveSearchPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.search.windows.net'
  azureCognitiveServicesPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.cognitiveservices.azure.com'
  azureCosmosCassandraPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.cassandra.cosmos.azure.com'
  azureCosmosGremlinPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.gremlin.cosmos.azure.com'
  azureCosmosMongoPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.mongo.cosmos.azure.com'
  azureCosmosSQLPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.documents.azure.com'
  azureCosmosTablePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.table.cosmos.azure.com'
  azureDataFactoryPortalPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.adf.azure.com'
  azureDataFactoryPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.datafactory.azure.net'
  azureDatabricksPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.azuredatabricks.net'
  azureDiskAccessPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureEventGridDomainsPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.eventgrid.azure.net'
  azureEventGridTopicsPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.eventgrid.azure.net'
  azureEventHubNamespacePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.servicebus.windows.net'
  azureFilePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.afs.azure.net'
  azureHDInsightPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.azurehdinsight.net'
  azureIotCentralPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.azureiotcentral.com'
  azureIotDeviceupdatePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.azure-devices.net'
  azureIotHubsPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.azure-devices.net'
  azureIotPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.azure-devices-provisioning.net'
  azureKeyVaultPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.vaultcore.azure.net'
  azureMachineLearningWorkspacePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.api.azureml.ms'
  azureMachineLearningWorkspaceSecondPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.notebooks.azure.net'
  azureManagedGrafanaWorkspacePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.grafana.azure.com'
  azureMediaServicesKeyPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMediaServicesLivePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMediaServicesStreamPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.media.azure.net'
  azureMigratePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.prod.migration.windowsazure.com'
  azureMonitorPrivateDnsZoneId1: '${privateDnsZonesBaseResourceId}privatelink.monitor.azure.com'
  azureMonitorPrivateDnsZoneId2: '${privateDnsZonesBaseResourceId}privatelink.oms.opinsights.azure.com'
  azureMonitorPrivateDnsZoneId3: '${privateDnsZonesBaseResourceId}privatelink.ods.opinsights.azure.com'
  azureMonitorPrivateDnsZoneId4: '${privateDnsZonesBaseResourceId}privatelink.agentsvc.azure-automation.net'
  azureMonitorPrivateDnsZoneId5: '${privateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureRedisCachePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.redis.cache.windows.net'
  azureServiceBusNamespacePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.servicebus.windows.net'
  azureSignalRPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.service.signalr.net'
  azureSiteRecoveryBackupPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.${selectedGeoCode}.backup.windowsazure.com'
  azureSiteRecoveryBlobPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureSiteRecoveryQueuePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.queue.core.windows.net'
  azureStorageBlobPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureStorageBlobSecPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.blob.core.windows.net'
  azureStorageDFSPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.dfs.core.windows.net'
  azureStorageDFSSecPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.dfs.core.windows.net'
  azureStorageFilePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.file.core.windows.net'
  azureStorageQueuePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.queue.core.windows.net'
  azureStorageQueueSecPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.queue.core.windows.net'
  azureStorageStaticWebPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.web.core.windows.net'
  azureStorageStaticWebSecPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.web.core.windows.net'
  azureStorageTablePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.table.core.windows.net'
  azureStorageTableSecondaryPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.table.core.windows.net'
  azureSynapseDevPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.dev.azuresynapse.net'
  azureSynapseSQLPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.sql.azuresynapse.net'
  azureSynapseSQLODPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.sql.azuresynapse.net'
  azureVirtualDesktopHostpoolPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.wvd.microsoft.com'
  azureVirtualDesktopWorkspacePrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.wvd.microsoft.com'
  azureWebPrivateDnsZoneId: '${privateDnsZonesBaseResourceId}privatelink.webpubsub.azure.com'
}

// **Scope**
targetScope = 'managementGroup'

// Modules - Policy Assignments - Intermediate Root Management Group
// Module - Policy Assignment - Deploy-MDFC-Config-H224
module policyAssignmentIntRootDeployMdfcConfig '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployMDFCConfigH224.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDeployMdfcConfig
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployMDFCConfigH224.definitionId
    policyAssignmentName: policyAssignmentDeployMDFCConfigH224.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployMDFCConfigH224.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployMDFCConfigH224.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployMDFCConfigH224.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      emailSecurityContact: {
        value: msDefenderForCloudEmailSecurityContact
      }
      ascExportResourceGroupLocation: {
        value: logAnalyticsWorkSpaceAndAutomationAccountLocation
      }
      logAnalytics: {
        value: logAnalyticsWorkspaceResourceId
      }
    }
    policyAssignmentIdentityType: policyAssignmentDeployMDFCConfigH224.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.owner
    ]
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployMDFCConfigH224.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDeployMDFCConfigH224.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDEndpoints
module policyAssignmentIntRootDeployMDEndpoints '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployMDEndpoints.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDeployMDEndpoints
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployMDEndpoints.definitionId
    policyAssignmentName: policyAssignmentDeployMDEndpoints.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployMDEndpoints.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployMDEndpoints.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployMDEndpoints.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployMDEndpoints.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.contributor
    ]
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployMDEndpoints.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDeployMDEndpoints.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDEndpointsAMA
module policyAssignmentIntRootDeployMDEndpointsAMA '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployMDEndpointsAMA.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDeployMDEnpointsAma
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployMDEndpointsAMA.definitionId
    policyAssignmentName: policyAssignmentDeployMDEndpointsAMA.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployMDEndpointsAMA.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployMDEndpointsAMA.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployMDEndpointsAMA.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployMDEndpointsAMA.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.rbacSecurityAdmin
    ]
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployMDEndpointsAMA.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDeployMDEndpointsAMA.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AzActivity-Log
module policyAssignmentIntRootDeployAzActivityLog '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployAzActivityLog.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDeployAzActivityLog
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployAzActivityLog.definitionId
    policyAssignmentName: policyAssignmentDeployAzActivityLog.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployAzActivityLog.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployAzActivityLog.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployAzActivityLog.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      logAnalytics: {
        value: logAnalyticsWorkspaceResourceId
      }
    }
    policyAssignmentIdentityType: policyAssignmentDeployAzActivityLog.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
    ]
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployAzActivityLog.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDeployAzActivityLog.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-ASC-Monitoring
module policyAssignmentIntRootDeployAscMonitoring '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployASCMonitoring.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDeployAscMonitoring
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployASCMonitoring.definitionId
    policyAssignmentName: policyAssignmentDeployASCMonitoring.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployASCMonitoring.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployASCMonitoring.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployASCMonitoring.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployASCMonitoring.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployASCMonitoring.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDeployASCMonitoring.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-Diag-Logs
module policyAssignmentIntRootDeployResourceDiag '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployDiagLogs.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDeployResourceDiag
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployDiagLogs.definitionId
    policyAssignmentName: policyAssignmentDeployDiagLogs.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployDiagLogs.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployDiagLogs.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployDiagLogs.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      logAnalytics: {
        value: logAnalyticsWorkspaceResourceId
      }
    }
    policyAssignmentIdentityType: policyAssignmentDeployDiagLogs.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployDiagLogs.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
    ]
    policyAssignmentNotScopes: policyAssignmentDeployDiagLogs.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-ACSB
module policyAssignmentIntRootEnforceAcsb '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnforceACSB.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootEnforceAcsb
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnforceACSB.definitionId
    policyAssignmentName: policyAssignmentEnforceACSB.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnforceACSB.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnforceACSB.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnforceACSB.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentEnforceACSB.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnforceACSB.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.contributor
    ]
    policyAssignmentNotScopes: policyAssignmentEnforceACSB.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDFC-OssDb
module policyAssignmentIntRootDeployMdfcOssDb '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployMDFCOssDb.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDeployMdfcOssDb
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployMDFCOssDb.definitionId
    policyAssignmentName: policyAssignmentDeployMDFCOssDb.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployMDFCOssDb.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployMDFCOssDb.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployMDFCOssDb.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployMDFCOssDb.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployMDFCOssDb.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.contributor
    ]
    policyAssignmentNotScopes: policyAssignmentDeployMDFCOssDb.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDFC-SqlAtp
module policyAssignmentIntRootDeployMdfcSqlAtp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployMDFCSqlAtp.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDeployMdfcSqlAtp
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployMDFCSqlAtp.definitionId
    policyAssignmentName: policyAssignmentDeployMDFCSqlAtp.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployMDFCSqlAtp.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployMDFCSqlAtp.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployMDFCSqlAtp.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployMDFCSqlAtp.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployMDFCSqlAtp.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.sqlSecurityManager
    ]
    policyAssignmentNotScopes: policyAssignmentDeployMDFCSqlAtp.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Audit Location Match
module policyAssignmentIntRootAuditLocationMatch '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentAuditLocationMatch.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootAuditLocationMatch
  params: {
    policyAssignmentDefinitionId: policyAssignmentAuditLocationMatch.definitionId
    policyAssignmentName: policyAssignmentAuditLocationMatch.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentAuditLocationMatch.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentAuditLocationMatch.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentAuditLocationMatch.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentAuditLocationMatch.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentAuditLocationMatch.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentAuditLocationMatch.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Audit Zone Resiliency
module policyAssignmentIntRootAuditZoneResiliency '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentAuditZoneResiliency.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootAuditZoneResiliency
  params: {
    policyAssignmentDefinitionId: policyAssignmentAuditZoneResiliency.definitionId
    policyAssignmentName: policyAssignmentAuditZoneResiliency.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentAuditZoneResiliency.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentAuditZoneResiliency.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentAuditZoneResiliency.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentAuditZoneResiliency.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentAuditZoneResiliency.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentAuditZoneResiliency.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Audit-UnusedResources
module policyAssignmentIntRootAuditUnusedRes '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentAuditUnusedResources.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootAuditUnusedRes
  params: {
    policyAssignmentDefinitionId: policyAssignmentAuditUnusedResources.definitionId
    policyAssignmentName: policyAssignmentAuditUnusedResources.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentAuditUnusedResources.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentAuditUnusedResources.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentAuditUnusedResources.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentAuditUnusedResources.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentAuditUnusedResources.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentAuditUnusedResources.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Audit Trusted Launch
module policyAssignmentIntRootAuditTrustedLaunch '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentAuditTrustedLaunch.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootAuditTrustedLaunch
  params: {
    policyAssignmentDefinitionId: policyAssignmentAuditTrustedLaunch.definitionId
    policyAssignmentName: policyAssignmentAuditTrustedLaunch.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentAuditTrustedLaunch.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentAuditTrustedLaunch.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentAuditTrustedLaunch.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentAuditTrustedLaunch.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentAuditTrustedLaunch.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentAuditTrustedLaunch.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-UnmanagedDisk
module policyAssignmentIntRootDenyUnmanagedDisks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyUnmanagedDisk.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDenyUnmanagedDisks
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyUnmanagedDisk.definitionId
    policyAssignmentName: policyAssignmentDenyUnmanagedDisk.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyUnmanagedDisk.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyUnmanagedDisk.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyUnmanagedDisk.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyUnmanagedDisk.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyUnmanagedDisk.libDefinition.properties.enforcementMode
    policyAssignmentOverrides: policyAssignmentDenyUnmanagedDisk.libDefinition.properties.overrides
    policyAssignmentNotScopes: policyAssignmentDenyUnmanagedDisk.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Classic-Resources
module policyAssignmentIntRootDenyClassicRes '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyClassicResources.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.intRoot)
  name: moduleDeploymentNames.policyAssignmentIntRootDenyClassicRes
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyClassicResources.definitionId
    policyAssignmentName: policyAssignmentDenyClassicResources.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyClassicResources.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyClassicResources.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyClassicResources.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyClassicResources.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyClassicResources.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyClassicResources.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Modules - Policy Assignments - Platform Management Group
// Module - Policy Assignment - Deploy-vmArc-ChangeTrack
module policyAssignmentPlatformDeployVmArcChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployvmArcChangeTrack.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformDeployVmArcTrack
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployvmArcChangeTrack.definitionId
    policyAssignmentName: policyAssignmentDeployvmArcChangeTrack.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployvmArcChangeTrack.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployvmArcChangeTrack.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployvmArcChangeTrack.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployvmArcChangeTrack.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployvmArcChangeTrack.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleChangeTrackingResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployvmArcChangeTrack.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-ChangeTrack
module policyAssignmentPlatformDeployVmChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployVMChangeTrack.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformDeployVmChangeTrack
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployVMChangeTrack.definitionId
    policyAssignmentName: policyAssignmentDeployVMChangeTrack.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployVMChangeTrack.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployVMChangeTrack.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployVMChangeTrack.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployVMChangeTrack.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployVMChangeTrack.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: userAssignedManagedIdentityResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.managedIdentityOperator
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployVMChangeTrack.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-ChangeTrack
module policyAssignmentPlatformDeployVmssChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployVMSSChangeTrack.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformDeployVmssChangeTrack
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployVMSSChangeTrack.definitionId
    policyAssignmentName: policyAssignmentDeployVMSSChangeTrack.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployVMSSChangeTrack.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployVMSSChangeTrack.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployVMSSChangeTrack.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployVMSSChangeTrack.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployVMSSChangeTrack.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: userAssignedManagedIdentityResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.managedIdentityOperator
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployVMSSChangeTrack.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-vmHybr-Monitoring
module policyAssignmentPlatformDeployVmArcMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployvmHybrMonitoring.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformDeployVmArcMonitor
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployvmHybrMonitoring.definitionId
    policyAssignmentName: policyAssignmentDeployvmHybrMonitoring.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployvmHybrMonitoring.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployvmHybrMonitoring.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployvmHybrMonitoring.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployvmHybrMonitoring.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployvmHybrMonitoring.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleVMInsightsResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployvmHybrMonitoring.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Monitor-24
module policyAssignmentPlatformDeployVmMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployVMMonitor24.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformDeployVmMonitor
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployVMMonitor24.definitionId
    policyAssignmentName: policyAssignmentDeployVMMonitor24.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployVMMonitor24.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployVMMonitor24.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployVMMonitor24.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployVMMonitor24.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployVMMonitor24.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleVMInsightsResourceId
      }
      userAssignedIdentityResourceId: {
        value: userAssignedManagedIdentityResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.managedIdentityOperator
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployVMMonitor24.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDFC-DefSQL-AMA
module policyAssignmentPlatformDeployMdfcDefSqlAma '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployMDFCDefSQLAMA.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformDeployMdfcDefSqlAma
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployMDFCDefSQLAMA.definitionId
    policyAssignmentName: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployMDFCDefSQLAMA.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      userWorkspaceResourceId: {
        value: logAnalyticsWorkspaceResourceId
      }
      dcrResourceId: {
        value: dataCollectionRuleMDFCSQLResourceId
      }
      userAssignedIdentityResourceId: {
        value: userAssignedManagedIdentityResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.managedIdentityOperator
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny Delete UAMI-AMA
module policyAssignmentPlatformDenyDeleteUAMIAMA '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyActionDeleteUAMIAMA.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformDenyDeleteUAMIAMA
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyActionDeleteUAMIAMA.definitionId
    policyAssignmentName: policyAssignmentDenyActionDeleteUAMIAMA.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyActionDeleteUAMIAMA.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      resourceName: {
        value: userAssignedManagedIdentityResourceName
      }
    }
    policyAssignmentNotScopes: policyAssignmentDenyActionDeleteUAMIAMA.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-Monitor-24
module policyAssignmentPlatformDeployVmssMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployVMSSMonitor24.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformDeployVmssMonitor
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployVMSSMonitor24.definitionId
    policyAssignmentName: policyAssignmentDeployVMSSMonitor24.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployVMSSMonitor24.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployVMSSMonitor24.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployVMSSMonitor24.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployVMSSMonitor24.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployVMSSMonitor24.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: userAssignedManagedIdentityResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.managedIdentityOperator
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployVMSSMonitor24.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-KeyVault
module policyAssignmentPlatformEnforceGrKeyVault '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnforceGRKeyVault.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformEnforceGrKeyVault
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnforceGRKeyVault.definitionId
    policyAssignmentName: policyAssignmentEnforceGRKeyVault.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnforceGRKeyVault.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnforceGRKeyVault.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnforceGRKeyVault.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentEnforceGRKeyVault.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnforceGRKeyVault.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentEnforceGRKeyVault.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-ASR
module policyAssignmentPlatformEnforceAsr '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnforceASR.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformEnforceAsr
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnforceASR.definitionId
    policyAssignmentName: policyAssignmentEnforceASR.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnforceASR.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnforceASR.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnforceASR.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentEnforceASR.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnforceASR.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.contributor
    ]
    policyAssignmentNotScopes: policyAssignmentEnforceASR.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Enable-AUM-CheckUpdates
module policyAssignmentPlatformEnforceAumCheckUpdates '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnableAUMCheckUpdates.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platform)
  name: moduleDeploymentNames.policyAssignmentPlatformEnforceAumCheckUpdates
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnableAUMCheckUpdates.definitionId
    policyAssignmentName: policyAssignmentEnableAUMCheckUpdates.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnableAUMCheckUpdates.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnableAUMCheckUpdates.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnableAUMCheckUpdates.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentEnableAUMCheckUpdates.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnableAUMCheckUpdates.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.connectedMachineResourceAdministrator
      rbacRoleDefinitionIds.managedIdentityOperator
    ]
    policyAssignmentNotScopes: policyAssignmentEnableAUMCheckUpdates.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Modules - Policy Assignments - Connectivity Management Group
// Module - Policy Assignment - Enable-DDoS-VNET
module policyAssignmentConnEnableDdosVnet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if ((!empty(ddosProtectionPlanId)) && (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnableDDoSVNET.libDefinition.name
))) {
  scope: managementGroup(managementGroupIds.platformConnectivity)
  name: moduleDeploymentNames.policyAssignmentConnEnableDdosVnet
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnableDDoSVNET.definitionId
    policyAssignmentName: policyAssignmentEnableDDoSVNET.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnableDDoSVNET.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnableDDoSVNET.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnableDDoSVNET.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      ddosPlan: {
        value: ddosProtectionPlanId
      }
    }
    policyAssignmentIdentityType: policyAssignmentEnableDDoSVNET.libDefinition.identity.type
    policyAssignmentEnforcementMode: !ddosEnabled || disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.networkContributor
    ]
    policyAssignmentNotScopes: policyAssignmentEnableDDoSVNET.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Modules - Policy Assignments - Identity Management Group
// Module - Policy Assignment - Deny-Public-IP
module policyAssignmentIdentDenyPublicIp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyPublicIP.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platformIdentity)
  name: moduleDeploymentNames.policyAssignmentIdentDenyPublicIp
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyPublicIP.definitionId
    policyAssignmentName: policyAssignmentDenyPublicIP.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyPublicIP.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyPublicIP.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyPublicIP.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyPublicIP.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyPublicIP.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyPublicIP.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-MgmtPorts-Internet
module policyAssignmentIdentDenyMgmtFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyMgmtPortsInternet.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platformIdentity)
  name: moduleDeploymentNames.policyAssignmentIdentDenyMgmtPortsFromInternet
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyMgmtPortsInternet.definitionId
    policyAssignmentName: policyAssignmentDenyMgmtPortsInternet.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyMgmtPortsInternet.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyMgmtPortsInternet.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyMgmtPortsInternet.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyMgmtPortsInternet.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyMgmtPortsInternet.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyMgmtPortsInternet.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module policyAssignmentIdentDenySubnetWithoutNsg '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenySubnetWithoutNsg.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platformIdentity)
  name: moduleDeploymentNames.policyAssignmentIdentDenySubnetWithoutNsg
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenySubnetWithoutNsg.definitionId
    policyAssignmentName: policyAssignmentDenySubnetWithoutNsg.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenySubnetWithoutNsg.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Backup
module policyAssignmentIdentDeployVmBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployVMBackup.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platformIdentity)
  name: moduleDeploymentNames.policyAssignmentIdentDeployVmBackup
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployVMBackup.definitionId
    policyAssignmentName: policyAssignmentDeployVMBackup.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployVMBackup.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployVMBackup.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployVMBackup.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      exclusionTagName: {
        value: vmBackupExclusionTagName
      }
      exclusionTagValue: {
        value: vmBackupExclusionTagValue
      }
    }
    policyAssignmentIdentityType: policyAssignmentDeployVMBackup.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.backupContributor
      rbacRoleDefinitionIds.vmContributor
    ]
    policyAssignmentNotScopes: policyAssignmentDeployVMBackup.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Modules - Policy Assignments - Management Management Group
// Module - Policy Assignment - Deploy-Log-Analytics
module policyAssignmentMgmtDeployLogAnalytics '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployLogAnalytics.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.platformManagement)
  name: moduleDeploymentNames.policyAssignmentMgmtDeployLogAnalytics
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployLogAnalytics.definitionId
    policyAssignmentName: policyAssignmentDeployLogAnalytics.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployLogAnalytics.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployLogAnalytics.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployLogAnalytics.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      rgName: {
        value: logAnalyticsWorkspaceResourceGroupName
      }
      workspaceName: {
        value: logAnalyticsWorkspaceName
      }
      workspaceRegion: {
        value: logAnalyticsWorkSpaceAndAutomationAccountLocation
      }
      dataRetention: {
        value: logAnalyticsWorkspaceLogRetentionInDays
      }
      automationAccountName: {
        value: automationAccountName
      }
      automationRegion: {
        value: logAnalyticsWorkSpaceAndAutomationAccountLocation
      }
    }
    policyAssignmentIdentityType: policyAssignmentDeployLogAnalytics.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployLogAnalytics.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.contributor
    ]
    policyAssignmentNotScopes: policyAssignmentDeployLogAnalytics.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Modules - Policy Assignments - Landing Zones Management Group
// Module - Policy Assignment - Deny-IP-Forwarding
module policyAssignmentLzsDenyIpForwarding '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyIPForwarding.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDenyIpForwarding
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyIPForwarding.definitionId
    policyAssignmentName: policyAssignmentDenyIPForwarding.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyIPForwarding.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyIPForwarding.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyIPForwarding.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyIPForwarding.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyIPForwarding.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyIPForwarding.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-MgmtPorts-Internet
module policyAssignmentLzsDenyMgmtFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyMgmtPortsInternet.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDenyMgmtPortsFromInternet
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyMgmtPortsInternet.definitionId
    policyAssignmentName: policyAssignmentDenyMgmtPortsInternet.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyMgmtPortsInternet.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyMgmtPortsInternet.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyMgmtPortsInternet.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyMgmtPortsInternet.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyMgmtPortsInternet.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyMgmtPortsInternet.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module policyAssignmentLzsDenySubnetWithoutNsg '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenySubnetWithoutNsg.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDenySubnetWithoutNsg
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenySubnetWithoutNsg.definitionId
    policyAssignmentName: policyAssignmentDenySubnetWithoutNsg.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenySubnetWithoutNsg.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Backup
module policyAssignmentLzsDeployVmBackup '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployVMBackup.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeployVmBackup
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployVMBackup.definitionId
    policyAssignmentName: policyAssignmentDeployVMBackup.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployVMBackup.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployVMBackup.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployVMBackup.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      exclusionTagName: {
        value: vmBackupExclusionTagName
      }
      exclusionTagValue: {
        value: vmBackupExclusionTagValue
      }
    }
    policyAssignmentIdentityType: policyAssignmentDeployVMBackup.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployVMBackup.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.owner
    ]
    policyAssignmentNotScopes: policyAssignmentDeployVMBackup.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Enable-DDoS-VNET
module policyAssignmentLzsEnableDdosVnet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if ((!empty(ddosProtectionPlanId)) && (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnableDDoSVNET.libDefinition.name
))) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsEnableDdosVnet
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnableDDoSVNET.definitionId
    policyAssignmentName: policyAssignmentEnableDDoSVNET.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnableDDoSVNET.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnableDDoSVNET.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnableDDoSVNET.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      ddosPlan: {
        value: ddosProtectionPlanId
      }
    }
    policyAssignmentIdentityType: policyAssignmentEnableDDoSVNET.libDefinition.identity.type
    policyAssignmentEnforcementMode: !ddosEnabled || disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnableDDoSVNET.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.networkContributor
    ]
    policyAssignmentNotScopes: policyAssignmentEnableDDoSVNET.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Storage-http
module policyAssignmentLzsDenyStorageHttp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyStoragehttp.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDenyStorageHttp
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyStoragehttp.definitionId
    policyAssignmentName: policyAssignmentDenyStoragehttp.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyStoragehttp.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyStoragehttp.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyStoragehttp.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyStoragehttp.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyStoragehttp.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyStoragehttp.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AKS-Policy
module policyAssignmentLzsDeployAksPolicy '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployAKSPolicy.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeployAksPolicy
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployAKSPolicy.definitionId
    policyAssignmentName: policyAssignmentDeployAKSPolicy.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployAKSPolicy.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployAKSPolicy.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployAKSPolicy.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployAKSPolicy.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployAKSPolicy.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.aksContributor
      rbacRoleDefinitionIds.aksPolicyAddon
    ]
    policyAssignmentNotScopes: policyAssignmentDeployAKSPolicy.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Escalation-AKS
module policyAssignmentLzsDenyPrivEscalationAks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyPrivEscalationAKS.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDenyPrivEscalationAks
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyPrivEscalationAKS.definitionId
    policyAssignmentName: policyAssignmentDenyPrivEscalationAKS.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyPrivEscalationAKS.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyPrivEscalationAKS.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyPrivEscalationAKS.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyPrivEscalationAKS.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyPrivEscalationAKS.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyPrivEscalationAKS.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Priv-Containers-AKS
module policyAssignmentLzsDenyPrivContainersAks '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyPrivContainersAKS.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDenyPrivContainersAks
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyPrivContainersAKS.definitionId
    policyAssignmentName: policyAssignmentDenyPrivContainersAKS.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyPrivContainersAKS.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyPrivContainersAKS.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyPrivContainersAKS.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyPrivContainersAKS.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyPrivContainersAKS.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyPrivContainersAKS.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-AKS-HTTPS
module policyAssignmentLzsEnforceAksHttps '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnforceAKSHTTPS.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsEnforceAksHttps
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnforceAKSHTTPS.definitionId
    policyAssignmentName: policyAssignmentEnforceAKSHTTPS.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnforceAKSHTTPS.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnforceAKSHTTPS.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnforceAKSHTTPS.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentEnforceAKSHTTPS.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnforceAKSHTTPS.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentEnforceAKSHTTPS.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-TLS-SSL
module policyAssignmentLzsEnforceTlsSsl '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnforceTLSSSLQ225.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsEnforceTlsSsl
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnforceTLSSSLQ225.definitionId
    policyAssignmentName: policyAssignmentEnforceTLSSSLQ225.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnforceTLSSSLQ225.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnforceTLSSSLQ225.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnforceTLSSSLQ225.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentEnforceTLSSSLQ225.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnforceTLSSSLQ225.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentEnforceTLSSSLQ225.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AzSqlDb-Auditing
module policyAssignmentLzsDeployAzSqlDbAuditing '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if ((!empty(logAnalyticsWorkspaceResourceId)) && (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployAzSqlDbAuditing.libDefinition.name
))) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeployAzSqlDbAuditing
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployAzSqlDbAuditing.definitionId
    policyAssignmentName: policyAssignmentDeployAzSqlDbAuditing.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      logAnalyticsWorkspaceId: {
        value: logAnalyticsWorkspaceResourceId
      }
    }
    policyAssignmentIdentityType: policyAssignmentDeployAzSqlDbAuditing.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.sqlSecurityManager
    ]
    policyAssignmentIdentityRoleAssignmentsSubs: [
      logAnalyticsWorkspaceSubscription
    ]
    policyAssignmentNotScopes: policyAssignmentDeployAzSqlDbAuditing.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-Threat
module policyAssignmentLzsDeploySqlThreat '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeploySQLThreat.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeploySqlThreat
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeploySQLThreat.definitionId
    policyAssignmentName: policyAssignmentDeploySQLThreat.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeploySQLThreat.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeploySQLThreat.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeploySQLThreat.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeploySQLThreat.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeploySQLThreat.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.owner
    ]
    policyAssignmentNotScopes: policyAssignmentDeploySQLThreat.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-TDE
module policyAssignmentLzsDeploySqlTde '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeploySQLTDE.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeploySqlTde
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeploySQLTDE.definitionId
    policyAssignmentName: policyAssignmentDeploySQLTDE.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeploySQLTDE.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeploySQLTDE.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeploySQLTDE.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeploySQLTDE.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeploySQLTDE.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.sqlDbContributor
    ]
    policyAssignmentNotScopes: policyAssignmentDeploySQLTDE.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-vmArc-ChangeTrack
module policyAssignmentLzsDeployVmArcTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployvmArcChangeTrack.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeployVmArcTrack
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployvmArcChangeTrack.definitionId
    policyAssignmentName: policyAssignmentDeployvmArcChangeTrack.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployvmArcChangeTrack.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployvmArcChangeTrack.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployvmArcChangeTrack.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployvmArcChangeTrack.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployvmArcChangeTrack.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleChangeTrackingResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployvmArcChangeTrack.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-ChangeTrack
module policyAssignmentLzsDeployVmChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployVMChangeTrack.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeployVmChangeTrack
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployVMChangeTrack.definitionId
    policyAssignmentName: policyAssignmentDeployVMChangeTrack.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployVMChangeTrack.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployVMChangeTrack.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployVMChangeTrack.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployVMChangeTrack.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployVMChangeTrack.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: userAssignedManagedIdentityResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.managedIdentityOperator
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployVMChangeTrack.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-ChangeTrack
module policyAssignmentLzsDeployVmssChangeTrack '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployVMSSChangeTrack.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeployVmssChangeTrack
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployVMSSChangeTrack.definitionId
    policyAssignmentName: policyAssignmentDeployVMSSChangeTrack.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployVMSSChangeTrack.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployVMSSChangeTrack.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployVMSSChangeTrack.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployVMSSChangeTrack.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployVMSSChangeTrack.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: userAssignedManagedIdentityResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.managedIdentityOperator
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployVMSSChangeTrack.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-vmHybr-Monitoring
module policyAssignmentLzsDeployVmArcMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployvmHybrMonitoring.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeployVmArcMonitor
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployvmHybrMonitoring.definitionId
    policyAssignmentName: policyAssignmentDeployvmHybrMonitoring.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployvmHybrMonitoring.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployvmHybrMonitoring.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployvmHybrMonitoring.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployvmHybrMonitoring.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployvmHybrMonitoring.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleVMInsightsResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployvmHybrMonitoring.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VM-Monitor-24
module policyAssignmentLzsDeployVmMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployVMMonitor24.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeployVmMonitor
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployVMMonitor24.definitionId
    policyAssignmentName: policyAssignmentDeployVMMonitor24.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployVMMonitor24.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployVMMonitor24.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployVMMonitor24.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployVMMonitor24.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployVMMonitor24.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleVMInsightsResourceId
      }
      userAssignedIdentityResourceId: {
        value: userAssignedManagedIdentityResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.managedIdentityOperator
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployVMMonitor24.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-VMSS-Monitor-24
module policyAssignmentLzsDeployVmssMonitor '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployVMSSMonitor24.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeployVmssMonitor
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployVMSSMonitor24.definitionId
    policyAssignmentName: policyAssignmentDeployVMSSMonitor24.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployVMSSMonitor24.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployVMSSMonitor24.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployVMSSMonitor24.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployVMSSMonitor24.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployVMSSMonitor24.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: userAssignedManagedIdentityResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.managedIdentityOperator
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployVMSSMonitor24.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-MDFC-DefSQL-AMA
module policyAssignmentLzsmDeployMdfcDefSqlAma '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployMDFCDefSQLAMA.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsDeployMdfcDefSqlAma
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployMDFCDefSQLAMA.definitionId
    policyAssignmentName: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployMDFCDefSQLAMA.libDefinition.properties.enforcementMode
    policyAssignmentParameterOverrides: {
      dcrResourceId: {
        value: dataCollectionRuleMDFCSQLResourceId
      }
      userAssignedIdentityResourceId: {
        value: userAssignedManagedIdentityResourceId
      }
    }
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.logAnalyticsContributor
      rbacRoleDefinitionIds.monitoringContributor
      rbacRoleDefinitionIds.managedIdentityOperator
      rbacRoleDefinitionIds.reader
    ]
    policyAssignmentNotScopes: policyAssignmentDeployMDFCDefSQLAMA.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-GR-KeyVault
module policyAssignmentLzsEnforceGrKeyVault '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnforceGRKeyVault.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsEnforceGrKeyVault
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnforceGRKeyVault.definitionId
    policyAssignmentName: policyAssignmentEnforceGRKeyVault.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnforceGRKeyVault.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnforceGRKeyVault.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnforceGRKeyVault.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentEnforceGRKeyVault.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnforceGRKeyVault.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentEnforceGRKeyVault.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Enforce-ASR
module policyAssignmentLzsEnforceAsr '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnforceASR.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsEnforceAsr
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnforceASR.definitionId
    policyAssignmentName: policyAssignmentEnforceASR.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnforceASR.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnforceASR.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnforceASR.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentEnforceASR.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnforceASR.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.contributor
    ]
    policyAssignmentNotScopes: policyAssignmentEnforceASR.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Enable-AUM-CheckUpdates
module policyAssignmentLzsAumCheckUpdates '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnableAUMCheckUpdates.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsAumCheckUpdates
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnableAUMCheckUpdates.definitionId
    policyAssignmentName: policyAssignmentEnableAUMCheckUpdates.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnableAUMCheckUpdates.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnableAUMCheckUpdates.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnableAUMCheckUpdates.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentEnableAUMCheckUpdates.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnableAUMCheckUpdates.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
      rbacRoleDefinitionIds.connectedMachineResourceAdministrator
      rbacRoleDefinitionIds.managedIdentityOperator
    ]
    policyAssignmentNotScopes: policyAssignmentEnableAUMCheckUpdates.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Audit-AppGW-WAF
module policyAssignmentLzsAuditAppGwWaf '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentAuditAppGWWAF.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLzsAuditAppGwWaf
  params: {
    policyAssignmentDefinitionId: policyAssignmentAuditAppGWWAF.definitionId
    policyAssignmentName: policyAssignmentAuditAppGWWAF.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentAuditAppGWWAF.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentAuditAppGWWAF.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentAuditAppGWWAF.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentAuditAppGWWAF.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentAuditAppGWWAF.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentAuditAppGWWAF.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Resource-Locations
module policyAssignmentLZsDenyResourceLocations '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyResourceLocations.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLZsDenyResourceLocations
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyResourceLocations.definitionId
    policyAssignmentName: policyAssignmentDenyResourceLocations.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyResourceLocations.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyResourceLocations.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyResourceLocations.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      listOfAllowedLocations: {
        value: listOfAllowedLocations
      }
    }
    policyAssignmentIdentityType: policyAssignmentDenyResourceLocations.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyResourceLocations.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyResourceLocations.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-ResourceGroup-Locations
module policyAssignmentLZsDenyResourceGroupLocations '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyRSGLocations.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLZsDenyResourceGroupLocations
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyRSGLocations.definitionId
    policyAssignmentName: policyAssignmentDenyRSGLocations.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyRSGLocations.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyRSGLocations.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyRSGLocations.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      listOfAllowedLocations: {
        value: listOfAllowedLocations
      }
    }
    policyAssignmentIdentityType: policyAssignmentDenyRSGLocations.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyRSGLocations.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyRSGLocations.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-SQL-Security
module policyAssignmentLZsDeploySQLSecurity '../policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeploySQLSecurity.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.landingZones)
  name: moduleDeploymentNames.policyAssignmentLZsDeploySQLSecurity
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeploySQLSecurity.definitionId
    policyAssignmentName: policyAssignmentDeploySQLSecurity.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeploySQLSecurity.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeploySQLSecurity.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeploySQLSecurity.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDeploySQLSecurity.libDefinition.identity.type
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.sqlDbContributor
    ]
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeploySQLSecurity.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDeploySQLSecurity.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Modules - Policy Assignments - Corp Management Group
// Module - Policy Assignment - Deny-Public-Endpoints
module policyAssignmentLzsDenyPublicEndpoints '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyPublicEndpoints.libDefinition.name
) && landingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(managementGroupIds.landingZonesCorp)
  name: moduleDeploymentNames.policyAssignmentLzsCorpDenyPublicEndpoints
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyPublicEndpoints.definitionId
    policyAssignmentName: policyAssignmentDenyPublicEndpoints.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyPublicEndpoints.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyPublicEndpoints.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyPublicEndpoints.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyPublicEndpoints.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyPublicEndpoints.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyPublicEndpoints.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-Private-DNS-Zones
module policyAssignmentConnDeployPrivateDnsZones '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDeployPrivateDNSZones.libDefinition.name
) && landingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(managementGroupIds.landingZonesCorp)
  name: moduleDeploymentNames.policyAssignmentLzsCorpDeployPrivateDnsZones
  params: {
    policyAssignmentDefinitionId: policyAssignmentDeployPrivateDNSZones.definitionId
    policyAssignmentName: policyAssignmentDeployPrivateDNSZones.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDeployPrivateDNSZones.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDeployPrivateDNSZones.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDeployPrivateDNSZones.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: {
      azureAcrPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureAcrPrivateDnsZoneId
      }
      azureAppPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureAppPrivateDnsZoneId
      }
      azureAppServicesPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureAppServicesPrivateDnsZoneId
      }
      azureArcGuestconfigurationPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureArcGuestconfigurationPrivateDnsZoneId
      }
      azureArcHybridResourceProviderPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureArcHybridResourceProviderPrivateDnsZoneId
      }
      azureArcKubernetesConfigurationPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureArcKubernetesConfigurationPrivateDnsZoneId
      }
      azureAsrPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureAsrPrivateDnsZoneId
      }
      azureAutomationDSCHybridPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureAutomationDSCHybridPrivateDnsZoneId
      }
      azureAutomationWebhookPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureAutomationWebhookPrivateDnsZoneId
      }
      azureBatchPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureBatchPrivateDnsZoneId
      }
      azureBotServicePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureBotServicePrivateDnsZoneId
      }
      azureCognitiveSearchPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureCognitiveSearchPrivateDnsZoneId
      }
      azureCognitiveServicesPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureCognitiveServicesPrivateDnsZoneId
      }
      azureCosmosCassandraPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureCosmosCassandraPrivateDnsZoneId
      }
      azureCosmosGremlinPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureCosmosGremlinPrivateDnsZoneId
      }
      azureCosmosMongoPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureCosmosMongoPrivateDnsZoneId
      }
      azureCosmosSQLPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureCosmosSQLPrivateDnsZoneId
      }
      azureCosmosTablePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureCosmosTablePrivateDnsZoneId
      }
      azureDataFactoryPortalPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureDataFactoryPortalPrivateDnsZoneId
      }
      azureDataFactoryPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureDataFactoryPrivateDnsZoneId
      }
      azureDatabricksPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureDatabricksPrivateDnsZoneId
      }
      azureDiskAccessPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureDiskAccessPrivateDnsZoneId
      }
      azureEventGridDomainsPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureEventGridDomainsPrivateDnsZoneId
      }
      azureEventGridTopicsPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureEventGridTopicsPrivateDnsZoneId
      }
      azureEventHubNamespacePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureEventHubNamespacePrivateDnsZoneId
      }
      azureFilePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureFilePrivateDnsZoneId
      }
      azureHDInsightPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureHDInsightPrivateDnsZoneId
      }
      azureIotCentralPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureIotCentralPrivateDnsZoneId
      }
      azureIotDeviceupdatePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureIotDeviceupdatePrivateDnsZoneId
      }
      azureIotHubsPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureIotHubsPrivateDnsZoneId
      }
      azureIotPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureIotPrivateDnsZoneId
      }
      azureKeyVaultPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureKeyVaultPrivateDnsZoneId
      }
      azureMachineLearningWorkspacePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureMachineLearningWorkspacePrivateDnsZoneId
      }
      azureMachineLearningWorkspaceSecondPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureMachineLearningWorkspaceSecondPrivateDnsZoneId
      }
      azureManagedGrafanaWorkspacePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureManagedGrafanaWorkspacePrivateDnsZoneId
      }
      azureMediaServicesKeyPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureMediaServicesKeyPrivateDnsZoneId
      }
      azureMediaServicesLivePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureMediaServicesLivePrivateDnsZoneId
      }
      azureMediaServicesStreamPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureMediaServicesStreamPrivateDnsZoneId
      }
      azureMigratePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureMigratePrivateDnsZoneId
      }
      azureMonitorPrivateDnsZoneId1: {
        value: privateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId1
      }
      azureMonitorPrivateDnsZoneId2: {
        value: privateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId2
      }
      azureMonitorPrivateDnsZoneId3: {
        value: privateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId3
      }
      azureMonitorPrivateDnsZoneId4: {
        value: privateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId4
      }
      azureMonitorPrivateDnsZoneId5: {
        value: privateDnsZonesFinalResourceIds.azureMonitorPrivateDnsZoneId5
      }
      azureRedisCachePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureRedisCachePrivateDnsZoneId
      }
      azureServiceBusNamespacePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureServiceBusNamespacePrivateDnsZoneId
      }
      azureSignalRPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureSignalRPrivateDnsZoneId
      }
      azureSiteRecoveryBackupPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureSiteRecoveryBackupPrivateDnsZoneId
      }
      azureSiteRecoveryBlobPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureSiteRecoveryBlobPrivateDnsZoneId
      }
      azureSiteRecoveryQueuePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureSiteRecoveryQueuePrivateDnsZoneId
      }
      azureStorageBlobPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureStorageBlobPrivateDnsZoneId
      }
      azureStorageBlobSecPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureStorageBlobSecPrivateDnsZoneId
      }
      azureStorageDFSPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureStorageDFSPrivateDnsZoneId
      }
      azureStorageDFSSecPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureStorageDFSSecPrivateDnsZoneId
      }
      azureStorageFilePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureStorageFilePrivateDnsZoneId
      }
      azureStorageQueuePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureStorageQueuePrivateDnsZoneId
      }
      azureStorageQueueSecPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureStorageQueueSecPrivateDnsZoneId
      }
      azureStorageStaticWebPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureStorageStaticWebPrivateDnsZoneId
      }
      azureStorageStaticWebSecPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureStorageStaticWebSecPrivateDnsZoneId
      }
      azureStorageTablePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureStorageTablePrivateDnsZoneId
      }
      azureStorageTableSecondaryPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureStorageTableSecondaryPrivateDnsZoneId
      }
      azureSynapseDevPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureSynapseDevPrivateDnsZoneId
      }
      azureSynapseSQLPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureSynapseSQLPrivateDnsZoneId
      }
      azureSynapseSQLODPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureSynapseSQLODPrivateDnsZoneId
      }
      azureVirtualDesktopHostpoolPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureVirtualDesktopHostpoolPrivateDnsZoneId
      }
      azureVirtualDesktopWorkspacePrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureVirtualDesktopWorkspacePrivateDnsZoneId
      }
      azureWebPrivateDnsZoneId: {
        value: privateDnsZonesFinalResourceIds.azureWebPrivateDnsZoneId
      }
    }
    policyAssignmentIdentityType: policyAssignmentDeployPrivateDNSZones.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDeployPrivateDNSZones.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.networkContributor
    ]
    policyAssignmentIdentityRoleAssignmentsSubs: [
      privateDnsZonesResourceGroupSubscriptionId
    ]
    policyAssignmentNotScopes: policyAssignmentDeployPrivateDNSZones.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Public-IP-On-NIC
module policyAssignmentLzsCorpDenyPipOnNic '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyPublicIPOnNIC.libDefinition.name
) && landingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(managementGroupIds.landingZonesCorp)
  name: moduleDeploymentNames.policyAssignmentLzsCorpDenyPipOnNic
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyPublicIPOnNIC.definitionId
    policyAssignmentName: policyAssignmentDenyPublicIPOnNIC.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyPublicIPOnNIC.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyPublicIPOnNIC.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyPublicIPOnNIC.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyPublicIPOnNIC.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyPublicIPOnNIC.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyPublicIPOnNIC.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Deny-HybridNetworking
module policyAssignmentLzsCorpDenyHybridNet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentDenyHybridNetworking.libDefinition.name
) && landingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(managementGroupIds.landingZonesCorp)
  name: moduleDeploymentNames.policyAssignmentLzsCorpDenyHybridNet
  params: {
    policyAssignmentDefinitionId: policyAssignmentDenyHybridNetworking.definitionId
    policyAssignmentName: policyAssignmentDenyHybridNetworking.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentDenyHybridNetworking.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentDenyHybridNetworking.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentDenyHybridNetworking.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentDenyHybridNetworking.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentDenyHybridNetworking.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentDenyHybridNetworking.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Module - Policy Assignment - Audit-PeDnsZones
module policyAssignmentLzsCorpAuditPeDnsZones '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentAuditPeDnsZones.libDefinition.name
) && landingZoneChildrenMgAlzDefaultsEnable) {
  scope: managementGroup(managementGroupIds.landingZonesCorp)
  name: moduleDeploymentNames.policyAssignmentLzsCorpAuditPeDnsZones
  params: {
    policyAssignmentDefinitionId: policyAssignmentAuditPeDnsZones.definitionId
    policyAssignmentName: policyAssignmentAuditPeDnsZones.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentAuditPeDnsZones.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentAuditPeDnsZones.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentAuditPeDnsZones.libDefinition.properties.parameters
    policyAssignmentParameterOverrides: empty(privateDnsZonesNamesToAuditInCorp)
      ? {}
      : {
          privateLinkDnsZones: {
            value: privateDnsZonesNamesToAuditInCorp
          }
        }
    policyAssignmentIdentityType: policyAssignmentAuditPeDnsZones.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentAuditPeDnsZones.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentAuditPeDnsZones.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Modules - Policy Assignments - Decommissioned Management Group
// Module - Policy Assignment - Enforce-ALZ-Decomm
module policyAssignmentDecommEnforceAlz '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnforceALZDecomm.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.decommissioned)
  name: moduleDeploymentNames.policyAssignmentDecommEnforceAlz
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnforceALZDecomm.definitionId
    policyAssignmentName: policyAssignmentEnforceALZDecomm.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnforceALZDecomm.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnforceALZDecomm.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnforceALZDecomm.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentEnforceALZDecomm.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnforceALZDecomm.libDefinition.properties.enforcementMode
    policyAssignmentIdentityRoleDefinitionIds: [
      rbacRoleDefinitionIds.vmContributor
    ]
    policyAssignmentNotScopes: policyAssignmentEnforceALZDecomm.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}

// Modules - Policy Assignments - Sandbox Management Group
// Module - Policy Assignment - Enforce-ALZ-Sandbox
module policyAssignmentSandboxEnforceAlz '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = if (!contains(
  excludedPolicyAssignments,
  policyAssignmentEnforceALZSandbox.libDefinition.name
)) {
  scope: managementGroup(managementGroupIds.sandbox)
  name: moduleDeploymentNames.policyAssignmentSandboxEnforceAlz
  params: {
    policyAssignmentDefinitionId: policyAssignmentEnforceALZSandbox.definitionId
    policyAssignmentName: policyAssignmentEnforceALZSandbox.libDefinition.name
    policyAssignmentDisplayName: policyAssignmentEnforceALZSandbox.libDefinition.properties.displayName
    policyAssignmentDescription: policyAssignmentEnforceALZSandbox.libDefinition.properties.description
    policyAssignmentParameters: policyAssignmentEnforceALZSandbox.libDefinition.properties.parameters
    policyAssignmentIdentityType: policyAssignmentEnforceALZSandbox.libDefinition.identity.type
    policyAssignmentEnforcementMode: disableAlzDefaultPolicies
      ? 'DoNotEnforce'
      : policyAssignmentEnforceALZSandbox.libDefinition.properties.enforcementMode
    policyAssignmentNotScopes: policyAssignmentEnforceALZSandbox.libDefinition.properties.notScopes
    telemetryOptOut: telemetryOptOut
  }
}
