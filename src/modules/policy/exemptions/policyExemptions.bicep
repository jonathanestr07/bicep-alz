targetScope = 'managementGroup'

metadata name = 'ALZ Bicep Module - Custom Policy Exemptions'
metadata description = 'Custom Policy Exemptions for Azure Landing Zones'
metadata version = '1.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Specifies the name of the policy exemption. Maximum length is 64 characters for management group scope.')
@maxLength(64)
param policyExemptionName string = 'policyExemptionName'

@description('The display name of the policy assignment. Maximum length is 128 characters.')
@maxLength(128)
param policyExemptionDisplayName string = 'policyExemptionDisplayName'

@description('The description of the policy exemption.')
param policyExemptionDescription string = 'policyExemptionDescription'

@description('The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.')
param policyExemptionMetadata object = {}

@description('The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated.')
@allowed([
  'Mitigated'
  'Waiver'
])
param policyExemptionCategory string = 'Mitigated'

@description('The resource ID of the policy assignment that is being exempted.')
param policyExemptionAssignmentId string = ''

@description('The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.')
param policyExemptionDefinitionReferenceIds array = []

@description('The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z.')
param policyExemptionExpiresOn string = ''

@description('The option whether validate the exemption is at or under the assignment scope.')
@allowed([
  ''
  'Default'
  'DoNotValidate'
])
param policyExemptionAssignmentScopeValidation string = ''

@description('The resource selector list to filter policies by resource properties.')
param policyExemptionResourceSelectors array = []

// Resource: Policy Exemption
resource policyExemption 'Microsoft.Authorization/policyExemptions@2022-07-01-preview' = {
  name: policyExemptionName
  properties: {
    displayName: !empty(policyExemptionDisplayName) ? policyExemptionDisplayName : null
    description: !empty(policyExemptionDescription) ? policyExemptionDescription : null
    metadata: !empty(policyExemptionMetadata) ? policyExemptionMetadata : null
    exemptionCategory: policyExemptionCategory
    policyAssignmentId: policyExemptionAssignmentId
    policyDefinitionReferenceIds: !empty(policyExemptionDefinitionReferenceIds) ? policyExemptionDefinitionReferenceIds : []
    expiresOn: !empty(policyExemptionExpiresOn) ? policyExemptionExpiresOn : null
    assignmentScopeValidation: !empty(policyExemptionAssignmentScopeValidation) ? policyExemptionAssignmentScopeValidation : null
    resourceSelectors: policyExemptionResourceSelectors
  }
}
