using '../../modules/roleAssignments/roleAssignments.bicep'

param rolesManagementGroup = [
  {
    // Security Operator
    managementGroupId: 'mg-alz'
    roleDefinitionId: 'f44ed55b-14ba-5869-86c2-768c52b87524'
    assigneePrincipalType: 'Group'
    assigneeObjectId: '40f29607-4e3d-4501-b400-f57723b2ae8e'
  }
  {
    // Platform Operator
    managementGroupId: 'mg-alz'
    roleDefinitionId: 'f01a6dfd-ba9b-5415-acba-cdd2b5e507d0'
    assigneePrincipalType: 'Group'
    assigneeObjectId: 'd84fcd16-2d4a-4938-8908-9e7be47fe0c6'
  }
  {
    // Network Operator
    managementGroupId: 'mg-alz'
    roleDefinitionId: '5d52c223-2936-50a8-842f-8337a39736bf'
    assigneePrincipalType: 'Group'
    assigneeObjectId: 'e660b762-5f6a-4b71-a62a-a9962832d41b'
  }
  /* Example assignment of service principal as Owner to Platform Connectivity Management group
  {
    managementGroupId: 'mg-alz-platform-connectivity'
    roleDefinitionId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
    assigneePrincipalType: 'User'
    assigneeObjectId: 'f06494de-7868-4e0c-89d8-61c3c627e230'
  }
  */
]

param roleSubscriptions = [
  /* Example assignment of service principal as Owner to a Subscription
  {
    subscriptionId: '30082970-a320-4a9e-84d2-e0154b6c3dc2'
    roleDefinitionId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
    assigneePrincipalType: 'User'
    assigneeObjectId: '35b8a3fd-783c-4930-8671-4849bcb6b1db'
  }
  */
]

param roleResourceGroup = [
  /* Example assignment of service principal as Owner to a Resource Group
  {
    subscriptionId: '30082970-a320-4a9e-84d2-e0154b6c3dc2'
    resourceGroupName: 'arg-aue-plat-conn-privatedns'
    roleDefinitionId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
    assigneePrincipalType: 'ServicePrincipal'
    assigneeObjectId: '35b8a3fd-783c-4930-8671-4849bcb6b1db'
  }
  */
]

param roleResource = [
  /* {
    // K8s Cluster DNS - QA - Postgres
    subscriptionId: 'f5641585-2899-435d-82d7-b59d9dbd74b9'
    resourceGroupName: 'arg-aue-plat-conn-privatedns'
    roleDefinitionId: 'b12aa53e-6015-4669-85d0-8515ebb3ae7f' //	Private DNS Zone Contributor
    resourceId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/arg-aue-plat-conn-privatedns/providers/Microsoft.Network/privateDnsZones/qa.postgres.database.azure.com'
    assigneePrincipalType: 'ServicePrincipal'
    assigneeObjectId: '19ac7df3-d476-4f81-8492-a5876bfce3ae'
 }  */
]
