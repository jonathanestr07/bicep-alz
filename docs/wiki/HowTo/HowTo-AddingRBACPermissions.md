# How-to Guide: Adding RBAC Permissions to the Platform Code

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Step-by-Step Instructions](#step-by-step-instructions)
  - [Step 1: Identify RBAC Requirements](#step-1-identify-rbac-requirements)
  - [Step 2: Add Role Assignments to `roleAssignments.bicepparam`](#step-2-add-role-assignments-to-roleassignmentsbicepparam)
  - [Step 3: Validate Role Assignment Syntax](#step-3-validate-role-assignment-syntax)
  - [Step 4: Commit and PR Your Changes](#step-4-commit-and-pr-your-changes)
- [Tips and Best Practices](#tips-and-best-practices)
- [Summary](#summary)
- [FAQ](#faq)
- [References](#references)

## Introduction

This guide outlines the steps to add Role-Based Access Control (RBAC) permissions to the platform code in a structured and efficient manner. The RBAC configuration is managed through `src/configuration/platform/roleAssignments.bicepparam`. Each role assignment specifies the scope, principal type, and role definition, ensuring secure and organized access management across management groups, subscriptions, resource groups and resources.

> **Note**: Role Assignments assigned to Azure resources directly can be achieved with the code in creating the resource itself. E.g. See `src\configuration\platform\platformManagement.bicepparam` and `src\orchestration\platformManagement\platformManagement.bicep` respectively for how RBAC is created for the Azure Container Registry. It however can also be achieved in the `src/configuration/platform/roleAssignments.bicepparam`

## Prerequisites

- Familiarity with the RBAC model in Azure.
- Access to edit `roleAssignments.bicepparam` in the repository.
- An understanding of the platform's architecture and access requirements.
- Familiarity with Bicep syntax and Azure CLI/PowerShell for deployment testing.

## Step-by-Step Instructions

### Step 1: Identify RBAC Requirements

- Determine the access requirements for the role you need to add, including:
  - **Scope**: Management Group, Subscription, or Resource Group.
  - **Role Definition**: Built-in or custom roles (e.g., Contributor, Reader).
  - **Principal Type**: ServicePrincipal, Group, or User.
  - **Principal Object ID**: Azure AD Object ID for the assignee.

> **Tip**: Review existing entries in `roleAssignments.bicepparam` to identify similar roles for consistency.

**_Outcome:_** A clear understanding of the RBAC permissions to be added.

---

### Step 2: Add Role Assignments to `roleAssignments.bicepparam`

1. Open `src/configuration/platform/roleAssignments.bicepparam`.
2. Navigate to the appropriate array based on the scope:
   - **Management Group**: `rolesManagementGroup`
   - **Subscription**: `roleSubscriptions`
   - **Resource Group**: `roleResourceGroup`
   - **Resources**: `roleResource`
3. Add a new role assignment object. Below is an example for each scope:

```bicep
// Management Group Example
{
  roleDefinitionId: 'c0af1754-2bd4-50a8-bb6d-b923367f4630' // Platform Operator
  assigneePrincipalType: 'Group'
  assigneeObjectId: 'f05a3136-3053-49b8-8c92-5d89b80a99fa' // [[ADGroupPrefix]]-Azure-[[CustomerCode]]-PlatformOps
  managementGroupId: 'mg-[[CustomerCode_Lower]]'
}
```

```bicep
// Subscription Example
{
  subscriptionId: '693bc0de-b583-4f8a-93a4-3375fced6f04' // sub-[[CustomerCode]]-plat-mgmt-01
  roleDefinitionId: '749f88d5-cbae-40b8-bcfc-e573ddc772fa' // Monitoring Contributor
  assigneePrincipalType: 'ServicePrincipal'
  assigneeObjectId: 'df9477b6-9859-4083-a4c5-a2527890f5c5' // dergithubrunner (Managed Identity)
}
```

```bicep
// Resource Group Example
{
  subscriptionId: 'f5641585-2899-435d-82d7-b59d9dbd74b9' // sub-[[CustomerCode]]-plat-conn-01
  resourceGroupName: 'arg-[[locPrefix]]-plat-conn-privatedns'
  roleDefinitionId: 'b12aa53e-6015-4669-85d0-8515ebb3ae7f' // Private DNS Zone Contributor
  assigneePrincipalType: 'Group'
  assigneeObjectId: '737f4026-795a-4070-8041-00f4cdce37af' // [[ADGroupPrefix]]-Azure-[[CustomerCode]]-PrivateDNSContributor
}
```

```bicep
// Resource example
{
  subscriptionId: 'f5641585-2899-435d-82d7-b59d9dbd74b9' // sub-[[CustomerCode]]-plat-conn-01
  resourceGroupName: 'arg-[[locPrefix]]-plat-conn-privatedns'
  roleDefinitionId: 'b12aa53e-6015-4669-85d0-8515ebb3ae7f' // Private DNS Zone Contributor
  resourceId: '/subscriptions/f5641585-2899-435d-82d7-b59d9dbd74b9/resourceGroups/arg-[[locPrefix]]-plat-conn-privatedns/providers/Microsoft.Network/privateDnsZones/privatelink.australiaeast.azmk8s.io'
  assigneePrincipalType: 'ServicePrincipal'
  assigneeObjectId: '3f5d1fc3-212c-4ad9-8ccb-2fca5cf939ea' // uai-[[locPrefix]]-gh-ot-k8s-prd in arg-[[locPrefix]]-plat-mgmt-runners
}
```

> **Note**: Azure attribute-based access control (ABAC) is also supported in this code at the `management group`, `subscription` and `resource group` levels. Consider adding `condition` to limit the amount of privileges a role assignment can receive. `condition` is a `string` type so ensure you ABAC syntax is single line to support bicep.

**_Outcome:_** The new RBAC role assignment is added to the appropriate section.

---

### Step 3: Validate Role Assignment Syntax

- Check the syntax for errors or inconsistencies.
- Ensure all fields (`roleDefinitionId`, `assigneePrincipalType`, etc.) are correctly populated.

> **Tip**: Use an integrated development environment (IDE) like Visual Studio Code with Bicep extensions to catch syntax errors.

**_Outcome:_** The updated `roleAssignments.bicepparam` is error-free and ready for deployment.

---

### Step 4: Commit and PR Your Changes

1. Commit the changes to your branch:

   ```bash
   git add src/configuration/platform/roleAssignments.bicepparam
   git commit -m "Add new RBAC role assignment for <purpose>"
   git push origin <branch-name>
   ```

2. Create a pull request for review.
3. Once approved, merge the changes into the main branch.
4. Run the 'End to End' or 'Azure RBAC' pipeline to deploy the RBAC permissions.

> **Note**: The 'End to End' pipeline will deploy all resources for the platform which may be needed if a new identity, like a virtual machine managed identity needs to be created first to be able to receive Azure RBAC permissions

**_Outcome:_** The new role assignment is committed to the repository and integrated into the platform.

---

## Tips and Best Practices

- Use comments in the code to provide context for each role assignment. E.g. Make your code human readable.
- Remember resources like identities, Entra Groups and other principals must exist first for a role assignment to be associated with it.

---

## Summary

By following this guide, you can efficiently add RBAC permissions to the platform code, ensuring secure and organized access management while maintaining compliance with the platform's architecture.

---

## FAQ

- **Q:** What if I need to remove a role assignment?
  **A:** Comment out or remove the role assignment from `roleAssignments.bicepparam` and redeploy the pipeline to confirm success. As Bicep is not stateful (mode =), you'll need to log into the Azure Portal with a privileged account and then remove the role assignment manually.

- **Q:** How can I verify the assignee's object ID?
  **A:** Use Azure CLI to find the object ID:

  ```bash
  az ad group show --group <group-name> --query objectId
  ```

---

## References

- [Azure Role Assignments Documentation](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments)
- [Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
