using '../../modules/policy/assignments/alzDefault/alzDefaultPolicyAssignments.bicep'

param topLevelManagementGroupPrefix = 'mg-alz'
param listOfAllowedLocations = [
  'australiaeast'
  'global'
]
param logAnalyticsWorkSpaceAndAutomationAccountLocation = 'australiaeast'
param dataCollectionRuleVMInsightsResourceId = '/subscriptions/a50d2a27-93d9-43b1-957c-2a663ffaf37f/resourceGroups/arg-aue-plat-mgmt-logging/providers/Microsoft.Insights/dataCollectionRules/dcr-aue-plat-mgmt-vminsights'
param dataCollectionRuleChangeTrackingResourceId = '/subscriptions/a50d2a27-93d9-43b1-957c-2a663ffaf37f/resourceGroups/arg-aue-plat-mgmt-logging/providers/Microsoft.Insights/dataCollectionRules/dcr-aue-plat-mgmt-changetracking'
param dataCollectionRuleMDFCSQLResourceId = '/subscriptions/a50d2a27-93d9-43b1-957c-2a663ffaf37f/resourceGroups/arg-aue-plat-mgmt-logging/providers/Microsoft.Insights/dataCollectionRules/dcr-aue-plat-mgmt-mdfcsql'
param userAssignedManagedIdentityResourceId = '/subscriptions/a50d2a27-93d9-43b1-957c-2a663ffaf37f/resourcegroups/arg-aue-plat-mgmt-logging/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uai-aue-plat-mgmt-ama'
param logAnalyticsWorkspaceResourceId = '/subscriptions/a50d2a27-93d9-43b1-957c-2a663ffaf37f/resourceGroups/arg-aue-plat-mgmt-logging/providers/Microsoft.OperationalInsights/workspaces/law-aue-plat-mgmt-3gucev5z3p7a4'
param msDefenderForCloudEmailSecurityContact = 'changeme@change.com'
param privateDnsResourceGroupId = '/subscriptions/5cb7efe0-67af-4723-ab35-0f2b42a85839/resourceGroups/arg-aue-plat-conn-privatedns'
param privateDnsZonesLocation = 'australiaeast'
param excludedPolicyAssignments = [
  'Deploy-VM-Backup'
  'Deploy-Log-Analytics'
]
