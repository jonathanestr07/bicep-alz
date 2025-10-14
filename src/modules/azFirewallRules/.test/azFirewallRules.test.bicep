@description('Test Deployment for Azure Platform Firewall')
import { resources } from '../../../configuration/shared.conf.bicep'
module testAzureFirewall '../azFirewallRules.bicep' = {
  name: 'testAzureFirewall'
  params: {
    ipGroupDeployment: true
    azFirewallPolicyDeployment: true
    tier: resources.platform.azFirewall.tier
    azFirewallPolicyName: 'afp-aue-conn-plat-4qluu6czrbyko'
    tags: {
      applicationName: 'Platform Connectivity Landing Zone'
      owner: 'Platform Team'
      criticality: 'Tier0'
      costCenter: '1234'
      contactEmail: ''
      dataClassification: 'Internal'
      environment: 'Platform Production'
      iac: 'Bicep'
    }
  }
}
