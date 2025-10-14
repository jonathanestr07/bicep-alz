# Azure Governance: Resource Locks and Deny Effect

- [Resource Locks Overview](#1-resource-locks-overview)
  - [Lock Inheritance](#lock-inheritance)
- [Design Decision: Using Azure Policy Deny Effect over traditional resource locks](#2-design-decision-using-azure-policy-deny-effect-over-traditional-resource-locks)
  - [Why the Switch?](#why-the-switch)
- [Deny Effect in Azure Policy](#3-deny-effect-in-azure-policy)
  - [Deny Evaluation](#deny-evaluation)
  - [Deny Properties for Resource Provider Mode](#deny-properties-for-resource-provider-mode)
- [Deny Policy Assignment Configuration](#4-deny-policy-assignment-configuration)
  - [Policy Assignment](#policy-assignment)
  - [Default resources prevented from Deletion](#default-resources-prevented-from-deletion)
  - [Policy Set Definition](#policy-set-definition)
- [Summary](#summary)

This document provides an in-depth overview of our Azure governance strategy. Traditionally, resource locks were used to protect critical resources from accidental or malicious changes. However, current best practices have shifted towards using the deny effect in Azure Policy. This change offers a more proactive, granular, and integrated approach to enforcing governance, ensuring that non-compliant operations are blocked before they can be executed.

## Option 1: Resource Locks

Azure Resource Manager (ARM) provides the ability to restrict operations on resources through **resource locks**. These locks enforce a specified lock level at a given scope (either a resource or a resource group). The available lock levels are:

- **CanNotDelete (Delete Lock):**
  Authorized users can read and modify a resource, but they cannot delete it.
- **ReadOnly Lock:**
  Authorized users can read a resource, but they cannot delete or update it. This effectively restricts users to the permissions provided by the Reader role.

### Lock Inheritance

When a lock is applied at a parent scope, all resources within that scope inherit the same lock. This includes resources that are added later. The most restrictive lock in the inheritance chain takes precedence.

| **Feature Reference**                                                                                                  |
| ---------------------------------------------------------------------------------------------------------------------- |
| [Resource Locks Overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-lock-resources) |

**Traditional Use Case:**
Resource locks were typically applied to all critical Azure resources (such as those in Platform Identity, Connectivity, and Management subscriptions) and in Landing Zone Subscriptions to prevent accidental deletion of key resources. They were enforced using Azure Policy for identified resources, with the possibility of adding additional locks via IaC templates.

## Option 2: Using Azure Policy `Deny` Effect over traditional resource locks

**Default Governance Approach:**
For the Azure Landing Zone now use the **deny effect** as the default governance mechanism in Azure Policy rather than relying solely on resource locks.

### Why the Switch?

- **Proactive Enforcement:**
  The deny effect stops non-compliant operations (e.g., unauthorized creation, modification, or deletion) **before** they are sent to the resource provider. This proactive enforcement ensures that violations are caught immediately, returning a 403 (Forbidden) error and preventing any changes from being executed.

- **Granular Control:**
  With the deny effect, policies can be more finely tuned to specific actions and resources. This allows for a tailored approach to governance that aligns with the specific needs and compliance requirements of the organization.

- **Integrated Governance:**
  The deny effect is integrated directly into Azure Policy, which means that governance is enforced at the point of request. This integration offers a consistent and comprehensive management experience across all resources.

- **Enhanced Compliance Reporting:**
  Non-compliant resources are clearly marked during policy evaluation, providing better insight into compliance status and easier remediation.

> **Rationale:** The deny effect in Azure Policy allows [[Customer_Shortname]] to enforce governance policies more effectively and with greater precision. It reduces the risk of accidental changes and ensures that only authorized and compliant actions are executed, thereby protecting critical Azure resources more robustly than traditional resource locks.
> **Implications**
>
> - **Operational Impact:** Teams need to understand the deny policies to avoid disruptions. Training and documentation are essential for smooth adoption.
> - **Policy Management:** Policies must be regularly reviewed and updated to meet changing compliance requirements and organizational needs.
> - **Monitoring and Reporting:** Enhanced mechanisms are needed to track policy compliance and address non-compliant resources promptly.
> - **Resource Management:** Resource owners must be aware of the policies affecting their resources and collaborate with governance teams to ensure compliance.
> - **Security Posture:** The deny effect strengthens security by preventing unauthorized actions before they occur, reducing the risk of accidental or malicious changes.

#### Deny Evaluation

When a resource operation (create or update) is attempted and matches a deny policy:

- **Resource Manager Mode:**
  The deny effect intercepts the request **before** it is processed by the resource provider, returning a 403 (Forbidden) error. In the Azure portal, this appears as a deployment status that was blocked due to the policy assignment.

- **Existing Resources:**
  During policy evaluation, resources that match a deny policy are flagged as non-compliant.

- **Resource Provider Mode:**
  For certain services (e.g., Microsoft.Kubernetes.Data), the resource provider handles the evaluation of the deny effect. Additional properties, such as `templateInfo` and `sourceType`, are used to define the constraint template details.

#### Deny Properties for Resource Provider Mode

- **templateInfo (required):**
  Contains details about the constraint template and replaces the deprecated `constraintTemplate`. Must be used with a `sourceType`.

- **sourceType (required):**
  Specifies the type of source for the constraint template. Allowed values include `PublicURL` (with a public URL provided) or `Base64Encoded` (with the template content encoded in Base64).

- **constraint (optional):**
  Defines the CRD implementation of the Constraint template, using parameters passed via `values`.

- **constraintInfo (optional):**
  Can generate the constraint from `templateInfo` and policy when not explicitly provided.

**Deny Example (Resource Manager mode):**

```json
"then": {
  "effect": "deny"
}
```

#### Deny Policy Assignment Configuration

Below is the configuration for the policy assignment that denies the deletion of key Azure Landing Zone Platform Services. This assignment ensures that critical resources cannot be deleted by unauthorized actions.

#### Policy Assignment

**File Path:**
`src\modules\policy\assignments\lib\policy_assignments_custom\policy_assignment_deny_resource_deletion.custom.tmpl.json`

#### Default resources prevented from Deletion

The following table summarizes the key Azure resources for which deletion is denied by our governance policy:

| **Resource Type**            | **PolicyDefinitionReferenceId** |
|------------------------------|---------------------------------|
| Automation Accounts          | automationAccounts              |
| Azure Bastion                | azureBastion                    |
| Azure Firewall               | azureFirewall                   |
| Connections                  | connections                     |
| EventHub Namespace           | eventhubNamespace               |
| ExpressRoute Circuit         | expressRouteCircuit             |
| ExpressRoute Gateway         | expressRouteGateway             |
| Key Vault                    | keyVault                        |
| Load Balancer                | loadBalancer                    |
| Local Network Gateway        | localNetworkGateway             |
| Network Security Group       | networkSecurityGroup            |
| Network Watchers             | networkWatchers                 |
| Public IP Addresses          | publicIpAddresses               |
| Recovery Services Vault      | recoveryServicesVault           |
| Route Tables                 | routeTables                     |
| Storage Accounts             | storageAccounts                 |
| User Assigned Identity       | userAssignedIdentity            |
| Virtual Network Gateway      | virtualNetworkGateway           |
| Virtual Networks             | virtualNetworks                 |

#### Policy Set Definition

The corresponding policy set definition, which aggregates the individual policy definitions referenced by the assignment, is located at:

`src\modules\policy\definitions\lib\policy_set_definitions\policy_set_definition_Insight_Deny-Resource-Delete.json`

## Summary

The governance model has evolved from using resource locks—an effective, yet reactive, method to protect Azure resources—to employing the deny effect in Azure Policy, which proactively prevents non-compliant operations. This approach:

- Blocks unauthorized operations at the time of request (returning a 403 error),
- Provides more granular and integrated control,
- Enhances compliance visibility, and
- Better aligns with modern cloud governance best practices.

By adopting the deny effect as our default mechanism, we ensure that our critical Azure resources remain secure and compliant, while reducing the risk of accidental or malicious changes.
