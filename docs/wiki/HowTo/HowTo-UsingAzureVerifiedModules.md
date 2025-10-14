# How-to Guide: Using Azure Verified Modules (AVM)

- [Introduction](#introduction)
- [Why Use Azure Verified Modules (AVM)?](#why-use-azure-verified-modules-avm)
- [Key Concepts of AVM](#key-concepts-of-avm)
- [Benefits of Avoiding ACR for Platform Deployments](#benefits-of-avoiding-acr-for-platform-deployments)
- [Steps to Use Azure Verified Modules](#steps-to-use-azure-verified-modules)
- [Best Practices](#best-practices)
- [Conclusion](#conclusion)

## Introduction

Azure Verified Modules (AVM) provide a standardized approach to Infrastructure-as-Code (IaC) by offering well-architected, pre-built modules. These modules enforce consistency, simplify deployment processes, and reduce complexity. This guide will walk you through the essentials of using AVM, its benefits, and how it integrates with repositories and deployments.

## Why Use Azure Verified Modules (AVM)?

Using AVM eliminates the need for storing templates in Azure Container Registries (ACRs), which previously led to deployment bottlenecks like the “chicken-and-egg” issue. By adopting AVM, your platform deployments become self-contained, avoiding the complexities involved with referencing modules from external sources like ACR. AVM ensures:

- **Standardization**: A unified approach to IaC across multiple tools (e.g., Bicep, Terraform).
- **Pre-Built Patterns**: Ready-to-use modules aligned with the Azure Well-Architected Framework.
- **Simplified Consumption**: Modules are easy to integrate directly from the repository.
- **Consistency & Reliability**: Tested and verified by Microsoft to ensure high standards.

> **Note**: [CARML templates](https://github.com/Azure/ResourceModules) is being replaced by Azure Verified Modules. Some of the Azure Landing Zone Platform code may use CARML for legacy purposes only.

## Key Concepts of AVM

1. **Self-Contained Platform Deployments**: All required modules reside in the repository, removing the dependency on external ACRs for platform code.
2. **Legacy ACR Usage**: While ACR can still store Bicep or Terraform modules, it is not necessary for platform-specific deployments.
3. **Cross-IaC Language Support**: AVM supports multiple IaC languages, ensuring seamless adoption whether you use Bicep, Terraform, or both.

## Benefits of Avoiding ACR for Platform Deployments

In earlier practices, referencing ACR for IaC modules introduced challenges:

- **Deployment Order Issue**: ACR had to exist before the platform was deployed, but the platform was required to create the ACR.
- **Simplified Dependencies**: With AVM, platform code stays in the repository, reducing external dependency management.
- **Accelerated Deployments**: No need to manage multiple registries, making deployment faster and easier to manage.

## Steps to Use Azure Verified Modules

Visit the [AVM Portal](https://aka.ms/AVM) to explore available modules and patterns to place into your code. They are simply referenced as a `module` from a public Azure Container Registry.

## Best Practices

- **Reuse and Optimize**: Use AVM modules to avoid duplicating code.
- **Test Before Deploying**: Validate modules in a test environment to ensure smooth integration.
- **Documentation**: Maintain documentation within the repository for easier adoption.

## Conclusion

Azure Verified Modules streamline platform deployments by eliminating unnecessary dependencies like ACR and providing ready-to-use, consistent IaC modules. With AVM, you gain access to Microsoft-verified patterns, simplifying and accelerating your Azure deployments.

For more information, visit the [AVM Portal](https://aka.ms/AVM).
