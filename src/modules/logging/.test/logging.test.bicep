@description('This test deployment validates the configuration and deployment of the Logging module.')
import { resources } from '../../../configuration/shared.conf.bicep'

module loggingTestModule '../logging.bicep' = {
  name: 'loggingTestDeployment'
  params: {
    tags: {
      applicationName: 'Enterprise Connectivity Hub'
      contactEmail: 'contact@example.com'
      criticality: 'Tier0'
      dataClassification: 'Confidential'
      environment: 'conn'
      iac: 'Bicep'
      owner: 'John Doe'
      costCenter: '1234'
    }
    dataCollectionRuleChangeTrackingName: 'ChangeTrackingRule'
    dataCollectionRuleMDFCSQLName: 'MDFCSQLRule'
    dataCollectionRuleVMInsightsName: 'VMInsightsRule'
    dataCollectionRuleLinuxName: 'LinuxCCXRule'
    dataCollectionRuleWindowsCommonName: 'WindowsCommonCCXRule'
    logAnalyticsWorkspaceName: 'LogAnalyticsWorkspace'
    userAssignedManagedIdentityName: 'UserAssignedIdentity'
  }
}
