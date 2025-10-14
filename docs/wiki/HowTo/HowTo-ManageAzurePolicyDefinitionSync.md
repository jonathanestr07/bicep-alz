# How-to Guide: Understanding and Managing the Synchronisation of Azure Policy Definitions from Microsoft

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [How the Sync Works](#how-the-sync-works)
- [Reviewing & Handling Sync PRs](#reviewing--handling-sync-prs)
  - [Examining the Changes](#examining-the-changes)
  - [Adjusting Policy Assignments](#adjusting-policy-assignments)
  - [Collaborating on the Sync PR](#collaborating-on-the-sync-pr)
- [Validation and Testing](#validation-and-testing)
- [Common Scenarios and Best Practices](#common-scenarios-and-best-practices)
- [Troubleshooting & Rolling Back Changes](#troubleshooting--rolling-back-changes)
- [Summary](#summary)

---

## Introduction

This repository employs an automated process to periodically synchronise Azure Policy Definitions from an upstream Microsoft repository (`Azure/Enterprise-Scale`). By automatically pulling in these updates, we can ensure your Azure Platform environment remains aligned with Microsoft’s continuously evolving best practices, security standards, and feature enhancements for Azure Governance and Policy.

However, these automatic PRs are not simply "click and merge". For example, policy definitions can change significantly over time, and those changes may require updates to your existing policy assignments, parameter files, or related logic to remain functional and relevant to your environment. This guide helps you understand how the sync process works, how to review changes effectively, and how to integrate updates with minimal disruption.

---

## Prerequisites

- Familiarity with Azure Policy concepts, including definitions, assignments, and parameters.
- Understanding of GitHub workflows and how Pull Requests (PRs) are created, reviewed, and merged.
- Sufficient permissions within the repository to review, modify, and merge PRs.

**Note:** This automated syncing feature is supported only when hosted in GitHub using GitHub Actions. Azure DevOps synchronization is not supported at this time.

---

## How the Sync Works

1. **Scheduled Runs:**
   A GitHub Actions workflow is set to run on a schedule—typically on weekdays—checking for updates to the Microsoft-managed `Azure/Enterprise-Scale` repository. This upstream repo frequently publishes improvements, bug fixes, and new capabilities to Azure Policy definitions. See `.github\workflows\repository-management.yml`

2. **Branch Updates and Scripts:**
   If new changes are detected, a dedicated branch (e.g. `improvement/policy-library`) is created or updated. The workflow then runs custom PowerShell scripts (like `Invoke-LibraryUpdate.ps1` and `Invoke-PolicyToBicep.ps1`) to integrate these changes into your `src/modules/policy` directories. This process involves:
   - Converting and structuring policy definitions into a format compatible with your repository’s standards.
   - Updating or adding policy assignment templates to align with the incoming definitions.

3. **Automatic PR Creation:**
   Once the branch is updated, the workflow creates or updates a PR against your main branch. This PR encapsulates the latest policy definition changes from Microsoft, ready for your review.

4. **Continuous Integration Checks:**
   The CI pipeline runs `bicep build` checks or other validations to ensure that the updated definitions can still be compiled and integrated without errors. If something breaks, the PR will reflect these issues, prompting you to investigate further.

---

## Reviewing & Handling Sync PRs

When the sync PR appears, it’s essential to carefully examine the changes and understand their impact before merging.

### Examining the Changes

- **Check the “Files Changed” Tab:**
  The PR’s “Files changed” view shows a diff of all updated policy definitions and any associated files. Look out for:
  - **Added, Removed, or Renamed Policies:** A new policy might require additional parameters, while a removed policy may render some assignments irrelevant.
  - **Modified Conditions or Effects:** Even subtle changes in a policy rule or condition can change the compliance landscape of your environment.
  - **Parameter Updates:** If parameters are altered—e.g., a parameter is removed, or a new one is added—your existing assignments may need adjusting to remain valid.

- **Check the Commit History:**
  The commit messages in the upstream repository may provide insights into why these changes were introduced. Understanding the rationale can help you determine the best course of action for integration.

### Adjusting Policy Assignments

If the definitions are altered, you may need to:

- **Add New Parameters:**
  If a new parameter is introduced in a policy definition, update your assignment files to include it. Without this, your deployments might fail or become non-compliant.

- **Remove or Rename Parameters:**
  Similarly, if parameters are removed or renamed, adjust your assignments to match the new naming conventions or structure. Failing to do so could break existing pipelines or cause assignment errors.

- **Change Resource Scopes or Conditions:**
  If the scope or conditions of a policy change, consider whether the existing assignment scopes (management group, subscription, or resource group) need to be realigned.

### Collaborating on the Sync PR

- **Direct Edits in the PR Branch:**
  You may want to make the necessary code changes (such as tweaking policy assignments) directly in the same PR branch. This keeps all related updates in one place, making the final review simpler.

- **Create a Secondary PR into the Sync PR:**
  For more complex scenarios, you might prefer to create a new feature branch and PR that merges into the sync branch. This lets you break down changes into smaller increments while still centralising work around the main sync PR.

- **Add Reviewers and Comments:**
  Tag team members who understand your organisation’s governance model. Their insights can help ensure that policy updates align with your internal standards.

---

## Validation and Testing

- **Bicep Build Checks:**
  The pipeline runs `bicep build` commands to ensure that all Bicep files (including those referencing policy definitions) compile correctly. If these checks fail, inspect the build logs for clues. Common issues include missing parameters, invalid references, or syntax errors introduced by policy changes.

- **Local Testing (Optional):**
  If you need deeper control, consider pulling the branch locally and running `bicep build` or other validation scripts. This can help you isolate the issue and test potential fixes before pushing them back to the PR branch.

---

## Common Scenarios and Best Practices

1. **Minor Changes – Just Merge:**
   If the PR introduces small adjustments or refinements, and your assignments remain valid, you can safely merge it after a quick review.

2. **Parameter Additions or Removals:**
   Make sure to update assignments and run a local test build. It’s best to keep these updates in the same PR for clarity.

3. **Significant Overhauls:**
   If Microsoft introduces substantial changes (like restructuring entire sets of policies), thoroughly review the new layout. You might need multiple commits or an additional PR to adapt your environment. Consider involving your compliance or security teams for guidance.

4. **Documenting Your Changes:**
   When you modify assignments or related files, add comments or commit messages explaining the rationale. This documentation helps future maintainers understand why certain decisions were made.

---

## Troubleshooting & Rolling Back Changes

- **Failed Builds or Mysterious Errors:**
  If `bicep build` fails, examine the error messages closely. Often it’s a missing parameter or invalid reference introduced by the new definitions.

- **Unexpected Behaviour After Merge:**
  If, after merging, you find that policies aren’t applying as expected or compliance metrics drop unexpectedly, consider reverting the merge commit. Address the issues in a new branch and reintroduce the changes once resolved.

- **Re-running the Workflow:**
  If you suspect an issue in the automated sync process itself, it may be triggered again (if allowed by the configuration) to ensure you’re working with the latest upstream state.

---

## Summary

By periodically synchronising with Microsoft’s Azure Policy Definitions, your environment stays current with the latest improvements and best practices. While automation streamlines this process, human oversight and intervention are often necessary to ensure a smooth integration. Reviewing changes, adjusting policy assignments, validating Bicep builds, and occasionally collaborating with teammates or creating secondary PRs all form part of the effective adoption of these upstream updates.

By following these guidelines, you’ll maintain a well-governed, compliant, and adaptable Azure environment that benefits from the continuous evolution of Microsoft’s policy ecosystem.
