using '../../modules/policy/assignments/custom/customPolicyAssignments.bicep'

param topLevelManagementGroupPrefix = 'mg-alz'
param storageAccountResourceId = '/subscriptions/a50d2a27-93d9-43b1-957c-2a663ffaf37f/resourceGroups/arg-aue-plat-mgmt-logging/providers/Microsoft.Storage/storageAccounts/staaueplatmgmt3gucev5z3p'
param virtualNetworkResourceId = [
  '/subscriptions/5cb7efe0-67af-4723-ab35-0f2b42a85839/resourceGroups/arg-aue-plat-conn-network/providers/Microsoft.Network/virtualNetworks/vnt-aue-plat-conn-10.52.0.0_24'
]
param logAnalyticsWorkspaceId = '/subscriptions/a50d2a27-93d9-43b1-957c-2a663ffaf37f/resourceGroups/arg-aue-plat-mgmt-logging/providers/Microsoft.OperationalInsights/workspaces/law-aue-plat-mgmt-3gucev5z3p7a4'
param excludedPolicyAssignments = [
  // List of policy assignments to exclude from the deployment, REMOVE these if you want them deployed
  'Deploy-AKS-Diag-Logs' // AKS Diagnostics Logs, do not enable without knowing the impact on cost as this will increase the amount of logs stored in the Log Analytics workspace dramatically.
]
