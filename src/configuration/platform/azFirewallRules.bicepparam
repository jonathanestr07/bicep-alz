import * as shared from '../shared.conf.bicep'

using '../../modules/azFirewallRules/azFirewallRules.bicep'

// The below two parameters are automatically set to true/false based on changes detected in `src\configuration\firewall\ipGroups.bicep` using `git diff` and the pipeline inputs.
// Refer to the GitHub Actions workflow or Azure DevOps pipeline for more details.
param ipGroupDeployment = true
param azFirewallPolicyDeployment = true

param tier = shared.resources.platform.azFirewall.tier
param azFirewallPolicyName = 'afp-aue-plat-conn-4qluu6czrbyko'
param tags = {
  environment: 'Platform Production'
  applicationName: 'Platform Connectivity Landing Zone'
  owner: 'Platform Team'
  criticality: 'Tier0'
  costCenter: '1234'
  contactEmail: 'test@outlook.com'
  dataClassification: 'Internal'
  iac: 'Bicep'
}
