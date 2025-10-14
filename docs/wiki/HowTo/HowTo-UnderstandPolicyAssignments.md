# How-to Guide: Understanding Policy Assignments

This guide provides a basic understanding of how Azure Policy Assignments are structured and managed within this repository. For a deeper explanation, refer to the [PolicyDeepDive](https://github.com/Azure/ALZ-Bicep/wiki/PolicyDeepDive) documentation where the documentation was originally forked from.

---

## Overview of Policy Assignment Paths

### `src\modules\policy\assignments\alzDefault`

- **Purpose**:
  - Contains the default Azure Policy Assignments provided by Microsoft’s Azure Landing Zones (ALZ) framework.
  - Designed to align with Enterprise-Scale best practices for governance, security, and compliance.

- **Key Features**:
  - Predefined policies that enforce foundational governance requirements (e.g., mandatory tagging, allowed regions, or secure configurations).
  - Minimal customization is required for these policies to work across most Azure environments.

- **Examples**:
  - Enforcing tagging on all resources.
  - Restricting resource deployment to specific Azure regions.
  - Ensuring encryption is enabled on storage accounts and databases.

> **Note**: The intent of this directory is for it to be edited very little by developers of the local repository. Rather the original IP from the `ALZ-Bicep` can replace this directory with periodic updates as needed.

---

### `src\modules\policy\assignments\custom`

- **Purpose**:
  - This path contains **custom-built Azure Policy Assignments** developed originally by **Insight**. This directory should contain your own custom assignments.
  - These policies go beyond the defaults provided by Microsoft, addressing specific needs or preferences.

- **Key Features**:
  - Policies are tailored to enhance or refine governance, security, and monitoring capabilities.
  - Reflect Insight’s operational expertise or specific client requirements.
  - Likely include stricter controls or additional parameters not present in the default ALZ assignments.

- **Examples**:
  - Custom diagnostic settings that enforce specific log retention periods.
  - Policies requiring advanced telemetry or monitoring for all resources.
  - Enhanced role-based access controls (RBAC) or compliance configurations.

---

## How to Use These Paths

1. **Leave `alzDefault` as is**:
   - Begin by understanding the baseline policies from this directory.
   - These policies provide a foundational layer of governance and are designed to work with minimal configuration.

2. **Augment with `custom`**:
   - Review the custom policies in this directory to understand how they differ from the defaults.
   - Integrate these policies if they align with your organisation’s specific governance, security, or operational requirements.

3. **Customize Further**:
   - Modify or extend policies in the `custom` directory to further govern your environment.
   - For example, you can:
     - Adjust parameters to enforce stricter compliance.
     - Add exclusions for specific subscriptions or resource groups.
     - Refactor assignments to target different scopes (e.g., management groups or subscriptions).

---

## Customisation in this repository

- In the forked repository from the upstream source (Microsoft), Insight has tailored the policy structure to include custom paths and logic. This customization ensures that policies meet unique operational needs while leveraging Azure Landing Zones’ extensibility.
- **Recommendation**: Familiarise yourself with the changes made in the fork to ensure smooth integration and avoid conflicts with upstream updates.

---

## Synchronisation and Updates

- The repository uses GitHub Actions to synchronise with Microsoft’s `Azure/Enterprise-Scale` repository.
- Updates to default policies (`alzDefault`) will automatically be reflected in this local repository.
- Custom policies (`custom`) are managed independently, ensuring flexibility for Insight, your incumbent provider or your internal team(s) to adapt or create new assignments without upstream dependencies.

---

## Additional Resources

For a more detailed explanation of how Azure Policy Definitions and Assignments work within the ALZ-Bicep framework, refer to the [Policy Deep Dive documentation](https://github.com/Azure/ALZ-Bicep/wiki/PolicyDeepDive).

By understanding and leveraging these paths and deep dive documentation, you can build a robust Azure governance framework that balances default best practices with tailored customisations.
