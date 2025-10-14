# How-to Guide: Using End-to-End and Individual Pipelines Effectively

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Pipeline Types](#pipeline-types)
  - [1. End-to-End Pipelines (Full Deployment)](#1-end-to-end-pipelines-full-deployment)
  - [2. Individual (Subset) Pipelines](#2-individual-subset-pipelines)
- [When to Use Which Pipeline](#when-to-use-which-pipeline)
  - [Scenario 1: Complex, Cross-Component Changes](#scenario-1-complex-cross-component-changes)
  - [Scenario 2: Targeted Updates or Quick Iterations](#scenario-2-targeted-updates-or-quick-iterations)
- [Running the Pipelines](#running-the-pipelines)
  - [For GitHub Workflows](#for-github-workflows)
  - [For Azure DevOps Pipelines](#for-azure-devops-pipelines)
- [Pipeline Dependencies and Ordering](#pipeline-dependencies-and-ordering)
- [Best Practices](#best-practices)
- [Troubleshooting & FAQ](#troubleshooting--faq)
- [Summary](#summary)

---

## Introduction

The Azure Platform offers two distinct pipeline approaches for deploying Azure environments:

1. **End-to-End Pipeline (Full Deployment)**: This runs the entire deployment from start to finish, ensuring every component is fully integrated and up to date.
2. **Individual (Subset) Pipelines**: These focus on deploying specific components or areas of the platform independently, saving time and facilitating faster iterations on isolated changes.

Using these pipelines effectively involves understanding when to run the full deployment versus a targeted subset pipeline, and how to sequence operations so that dependencies are met.

---

## Prerequisites

- Familiarity with the code repository structure, including `.github/workflows` and `.azdo` folders.
- Basic understanding of GitHub Actions and/or Azure DevOps Pipelines.
- Sufficient permissions to trigger and manage pipeline runs.

---

## Pipeline Types

### 1. End-to-End Pipelines (Full Deployment)

**Characteristics:**

- Located as `release.yml` in GitHub (GitHub Actions) or `azure-pipelines.yml` in Azure DevOps.
- Deploys the entire platform environment from scratch, including all resources and configurations.
- Typically takes more than 2 hours to complete due to its comprehensive coverage.
- Ideal for initial environment setups, major architectural changes, or “clean slate” scenarios where every resource must be validated and redeployed.

**Key Advantages:**

- Guarantees full platform consistency.
- Ensures that no component is left behind, making it ideal for production releases or complex changes.

### 2. Individual (Subset) Pipelines

**Characteristics:**

- Each subset corresponds to a specific functional area (e.g. Azure RBAC, Azure Policy, Azure Firewall Rules, Platform Management, Platform Identity, Platform Connectivity).
- Located as `release_*.yml` in `.github/workflows` or `azure-pipelines-*.yml` in `.azdo`.
- Deploys only the targeted components and their required dependencies.
- Faster to run than the full end-to-end pipeline, improving the development and testing cycle time.

**Key Advantages:**

- Accelerates changes to individual components without waiting for a full environment build.
- Useful for iterative development, testing small adjustments, and applying quick patches.
- Still ensures prerequisites are still deployed first.

---

## When to Use Which Pipeline

### Scenario 1: Complex, Cross-Component Changes

If you are introducing changes that impact multiple layers (e.g. modifying Management Groups, adjusting core RBAC, and adding a new resource type), it’s safer to run the end-to-end pipeline. This ensures that:

- All dependencies are met across all platform components.
- Potential “chicken and egg” scenarios are handled (e.g. a new Management Group must exist before applying RBAC).
- The final state of the platform is consistent and reliable.

**Recommendation:** Use the full end-to-end pipeline for major releases, large-scale architectural overhauls, or after significant refactoring.

> **Note**: It's also recommend to run this pipeline every month or so to avoid the typical 'click ops' actions that happen by Cloud Administrators using the Azure Portal.

### Scenario 2: Targeted Updates or Quick Iterations

If your changes are localised to a specific area (e.g. updating a role assignment, modifying a single Azure Policy, adding a firewall rule), running the corresponding individual pipeline will save time and resources. This is particularly useful when:

- Developing a proof-of-concept for a new role assignment or rule.
- Troubleshooting a specific resource’s configuration.
- Iterating on a single component until it meets requirements, without re-deploying everything else.

**Recommendation:** Use individual pipelines for smaller changes, incremental updates, and testing in isolation.

---

## Running the Pipelines

### For GitHub Workflows

1. **End-to-End Deployment:**
   - Trigger the `release.yml` workflow.
   - This will deploy all components and configurations in one go.

2. **Individual Deployment:**
   - Trigger the corresponding `release_*.yml` workflow (e.g. `release_AzureRBAC.yml`).
   - This will run the associated `deploy_*.yml` (e.g. `deploy_AzureRBAC.yml`) or default `deploy.yml` if no specialised deploy file exists.

> **Note 1:** If a `release_` pipeline doesn’t have a matching `deploy_` pipeline, it defaults to `deploy.yml`.
>
> **Note 2:** `triggers` on the release pipelines can be customised to meet your requirements.

### For Azure DevOps Pipelines

1. **End-to-End Deployment:**
   - Run the `azure-pipelines.yml` pipeline.
   - Uses the `deploy_Default.yml` if no specific template matches, ensuring a full-scale deployment.

2. **Individual Deployment:**
   - Run the appropriate `azure-pipelines-<ComponentName>.yml` (e.g. `azure-pipelines-AzureRBAC.yml`).
   - This calls the corresponding deployment template in `.azdo/templates` (e.g. `deploy_AzureRBAC.yml`).
   - If no specialised template exists, it falls back to `deploy_Default.yml`.

> **Note:** `triggers` on the `azure-pipelines-<ComponentName>.yml` pipelines can be customised to meet your requirements.

---

## Pipeline Dependencies and Ordering

- The individual pipelines are designed to handle their own prerequisites where possible. For example, if RBAC changes require a Management Group to exist, the pipeline includes steps to ensure that is already in place.
- The end-to-end pipeline runs everything, so dependencies are inherently managed in the correct order, making it ideal when you’re unsure of dependency states.

---

## Best Practices

1. **Start Simple:** For minor changes, run an individual pipeline first. Only escalate to the end-to-end pipeline if you encounter dependency issues or broader integration problems.
2. **Verify Dependencies:** Before running an individual pipeline, confirm that any prerequisites (e.g. Management Groups, Identities) are already deployed.
3. **Use Descriptive Commit Messages & PRs:** Clearly state which pipeline should be run and why. This helps reviewers understand the deployment approach.
4. **Leverage Pipeline Logs:** Check the logs for each pipeline run to diagnose errors. If a targeted pipeline fails due to missing prerequisites, consider running the full pipeline or first running a pipeline that ensures those prerequisites.
5. **Clean-Up Before Full Runs:** If you anticipate a major release or a rebuild, ensure that any stale resources or failed partial deployments are cleaned up to avoid conflicts.

---

## Troubleshooting & FAQ

**Q:** What if my targeted pipeline fails due to missing prerequisites?
**A:** This shouldn't happen as all dependencies are mapped in the individual pipelines. Consider running however the full end-to-end pipeline to guarantee all dependencies are resolved due to potential click-ops changes in the Azure Portal.

**Q:** Can I chain pipelines?
**A:** While direct chaining is not always straightforward, you can run them sequentially. In Azure DevOps, consider using pipeline dependencies or manual triggers. The end-to-end pipelines is effectively your chain.

**Q:** Why is the end-to-end pipeline so slow?
**A:** It’s performing a comprehensive, full-scale deployment, including all resources and configurations. Use it primarily for major changes or releases that require full validation. Some things also just take a long time to deploy, like linear changes to IP Groups on an Azure Firewall.

**Q:** Why this approach?
**A:** This approach adheres more closely to true SDLC (Software Development Life Cycle) practices, ensuring that the code in the repository directly reflects what is actually deployed. By doing so, it helps maintain consistency and reliability across environments. Additionally, this strategy can reduce the Mean Time to Recovery (MTTR), especially when using the end-to-end pipeline, since everything can be redeployed swiftly if needed.

---

## Summary

By understanding when to deploy everything end-to-end versus when to apply changes to a specific component, you can significantly improve your development efficiency and reduce deployment times. Use the end-to-end pipeline for comprehensive, large-scale changes to ensure full consistency, and rely on individual pipelines to rapidly iterate on specific resources or configurations. This approach streamlines the deployment process, optimises resource usage, and maintains a robust and secure Azure environment that meets your platform’s evolving needs.
