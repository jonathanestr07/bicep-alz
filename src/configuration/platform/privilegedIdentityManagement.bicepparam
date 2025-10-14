using '../../orchestration/privilegedIdentityManagement/privilegedIdentityManagement.bicep'

param pimAssignmentsResourceGroup = [
  // {
  //   resourceGroup: 'rg-ae-plat-mgmt-jumphosts'
  //   subscriptionId: '693bc0de-b583-4f8a-93a4-3375fced6f04'
  //   principalId: '7189d5e8-1708-4f19-8361-ee345970871b' // SG-Bastion-Reader
  //   roleDefinitionId: 'fb879df8-f326-4884-b1cf-06f3ad86be52' // Virtual Machine User Login RoleId
  //   duration: 'PT8H' // 8 hours
  //   expirationType: 'AfterDuration'
  //   justification: 'Grant Virtual Machine User Login permissions to members of SG-Bastion-Reader for secure access to bastion hosts'
  //   requestType: 'AdminUpdate'
  // }
]

param pimAssignmentsSubscription = [
  //   {
  //     subscriptionId: '693bc0de-b583-4f8a-93a4-3375fced6f04'
  //     principalId: '0bbcc7d3-2af3-4ae0-8b3f-70521f8b6d8a' // SG-subscription-owner
  //     roleDefinitionId: 'ed50279f-0682-54b1-838d-10e0355b1050' // Subscription Owner RoleId
  //     duration: 'PT8H' // 8 hours
  //     expirationType: 'AfterDuration'
  //     justification: 'Assign Subscription Owner role to members of SG-subscription-owner for full control over subscription resources'
  //     requestType: 'AdminUpdate'
  //   }
]

param pimAssignmentsManagementGroup = [
  // {
  //   managementGroupId: 'mg-platform'
  //   principalId: '2e5413f4-8905-4d78-a2a6-f3fbb53f4c6e' // SG-Platform-owner
  //   roleDefinitionId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635' // Owner RoleId
  //   duration: 'PT8H' // 8 hours
  //   expirationType: 'AfterDuration'
  //   justification: 'Grant Owner role to members of SG-Platform-owner for full administrative control over platform resources'
  //   requestType: 'AdminUpdate'
  // }
]

param pimAssignmentsTenant = []
