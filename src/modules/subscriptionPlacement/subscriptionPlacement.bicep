targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Subscription Placement module'
metadata description = 'This Module is used to place Azure Subscriptions into a Management Group.'
metadata version = '1.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Array of Subscription Ids that should be moved to the new management group. Default: Empty Array')
param subscriptionIds array = []

@description('Target management group for the subscription. This management group must exist.')
param targetManagementGroupId string

@description('Set Parameter to true to Opt-out of deployment telemetry.')
param telemetryOptOut bool = false

// Customer Usage Attribution Id
var cuaid = '3dfa9e81-f0cf-4b25-858e-167937fd380b'

// Resource: Subscription PLacement
resource subscriptionPlacement 'Microsoft.Management/managementGroups/subscriptions@2023-04-01' = [for subscriptionId in subscriptionIds: {
  scope: tenant()
  name: '${targetManagementGroupId}/${subscriptionId}'
}]

// Module: Customer Usage Attribution
module customerUsageAttribution '../CARML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!telemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${cuaid}-${uniqueString(deployment().location)}'
  params: {}
}
