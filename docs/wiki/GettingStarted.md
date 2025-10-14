# Getting Started

- [Recommended Learning](#recommended-learning)
  - [GitHub Actions](#github-actions)
  - [Azure DevOps Pipelines](#azure-devops-pipelines)
  - [Bicep](#bicep)
  - [PSRule](#psrule)
  - [PSDocs](#psdocs)
  - [Pandoc](#pandoc)
  - [PowerShell](#powershell)
  - [Visual Studio Code](#visual-studio-code)
  - [Git](#git)
- [Tooling](#tooling)
  - [Required Tooling](#required-tooling)
  - [Recommended Extensions](#recommended-extensions)
  - [Getting Started with Code Tours](#getting-started-with-code-tours)
- [Contributing Guidelines](#contributing-guidelines)
  - [Bicep Formatting Guidelines](#bicep-formatting-guidelines)
  - [Bicep Best Practices](#bicep-best-practices)
  - [Bicep Code Styling](#bicep-code-styling)
  - [Bicep Common Parameters Naming Standards](#bicep-common-parameters-naming-standards)
  - [Bicep File Structure Example](#bicep-file-structure-example)
  - [Constructing a Bicep Module](#constructing-a-bicep-module)
  - [Resource API Versions](#resource-api-versions)

If you're looking to contribute to this project—whether adding Bicep code, examples, documentation, or GitHub/Azure DevOps automation—you're in the right place. Please review this wiki page for essential information to help you contribute effectively.

This repository heavily leverages [Azure Verified Modules (AVM)](https://azure.github.io/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/) because they bring the power of the open source community to this repository. AVM provides enterprise-ready, well-tested, and community-maintained Bicep modules that accelerate development while ensuring best practices and reliability.

## Recommended Learning

Before contributing to the code, we **highly recommend** completing the following Microsoft Learn paths, general guides, modules, and courses:

### GitHub Actions

- [Deploy Azure resources by using Bicep and GitHub Actions](https://docs.microsoft.com/learn/paths/bicep-github-actions/)
- [How to automatically trigger GitHub Actions workflows](https://docs.github.com/actions/using-workflows/triggering-a-workflow)
- [Using jobs in a GitHub Actions workflow](https://docs.github.com/actions/using-jobs/using-jobs-in-a-workflow)
- [Managing a branch protection rule](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/managing-a-branch-protection-rule)

### Azure DevOps Pipelines

- [Deploy Azure resources by using Bicep and Azure Pipelines](https://docs.microsoft.com/learn/paths/bicep-azure-pipelines/)
- [Azure DevOps Pipelines triggers](https://docs.microsoft.com/azure/devops/pipelines/build/triggers?view=azure-devops)
- [Azure DevOps Pipelines stages, dependencies, and conditions](https://docs.microsoft.com/azure/devops/pipelines/process/stages?view=azure-devops&tabs=yaml)
- [Azure DevOps Branch policies and settings](https://docs.microsoft.com/azure/devops/repos/git/branch-policies?view=azure-devops&tabs=browser)

### Bicep

- [Deploy and manage resources in Azure by using Bicep](https://docs.microsoft.com/learn/paths/bicep-deploy/)
- [Structure your Bicep code for collaboration](https://docs.microsoft.com/learn/modules/structure-bicep-code-collaboration/)
- [Manage changes to your Bicep code by using Git](https://docs.microsoft.com/learn/modules/manage-changes-bicep-code-git/)

### PSRule

- [PSRule for Azure Video Series](https://azure.github.io/PSRule.Rules.Azure/learn/learn-video-series/)

### PSDocs

- [PSDocs.Azure Quickstart](https://github.com/Azure/PSDocs.Azure-quickstart)
- [PSDocs.Azure Documentation](https://azure.github.io/PSDocs.Azure/)

### Pandoc

- [Pandoc User's Guide](https://pandoc.org/MANUAL.html)
- [Getting Started with Pandoc](https://pandoc.org/getting-started.html)

### Visual Studio Code

- [Multi-root Workspaces in Visual Studio Code](https://code.visualstudio.com/docs/editor/workspaces)
- [Getting Started with Visual Studio Code](https://code.visualstudio.com/docs/getstarted/getting-started)
- [Debugging in Visual Studio Code](https://code.visualstudio.com/docs/editor/debugging)

### Powershell

- [Script with PowerShell](https://learn.microsoft.com/en-us/training/modules/script-with-powershell/)

### Git

- [Introduction to version control with Git](https://docs.microsoft.com/learn/paths/intro-to-vc-git/)

### Pester

- [Introduction to Pester](https://pester.dev/)

## Tooling

### Required Tooling

To contribute to this project, you'll need the following tools:

- [Git](https://git-scm.com/downloads)
- [Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep/install#install-manually)
- [Pandoc](https://pandoc.org/installing.html) - Universal document converter for documentation
- [Visual Studio Code](https://code.visualstudio.com/download)
  - [Bicep extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
- [Python](https://www.python.org/downloads/)
- [PowerShell 7](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- [Latest AZ PowerShell module](https://docs.microsoft.com/en-us/powershell/azure/install-az-ps)
- [Pester](https://pester.dev/docs/quick-start)
- [Az CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (for debugging only)

> **Note**: If using GitHub Actions, it's recommended to also install the [GitHub CLI](https://cli.github.com/).

We recommend using package managers like WinGet (Windows Package Manager) or Chocolatey to streamline the download, installation, and management of the required development tools.

### Recommended Extensions

We strongly recommend installing all the following Visual Studio Code extensions to enhance your development experience:

- [CodeTour extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=vsls-contrib.codetour)
- [ARM Tools extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)
- [ARM Template Viewer extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=bencoleman.armview)
- [PSRule extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=bewhite.psrule-vscode)

**Install All Extensions**: All recommended extensions are included in the [.vscode/extensions.json](/.vscode/extensions.json) file. Visual Studio Code will prompt you to install these extensions when you open the project, or you can install them manually by running the "Extensions: Show Recommended Extensions" command.

For accessibility, if you have visibility or vision impairments, enable Bracket Pair Colorization by adding `"editor.bracketPairColorization.enabled": true` to your [.vscode/settings.json](/.vscode/settings.json).

### Getting Started with Code Tours

This repository includes interactive code tours that guide you through the codebase and help you understand the project structure. After installing the CodeTour extension, you can:

1. Open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`)
2. Search for "CodeTour: Start Tour"
3. Select from available tours to learn about different aspects of the project

These tours are an excellent way to familiarize yourself with the codebase and understand how different components work together.

## Contributing Guidelines

### Bicep Formatting Guidelines

Follow these guidelines when contributing Bicep code to the project.

#### Bicep Best Practices

Always follow the [Bicep Best Practices](https://docs.microsoft.com/azure/azure-resource-manager/bicep/best-practices) throughout your development.

#### Bicep Code Styling

- **Camel Casing** must be used for all symbolic names:
  - Parameters
  - Variables
  - Resources
  - Modules
  - Outputs
- Use [parameter decorators](https://docs.microsoft.com/azure/azure-resource-manager/bicep/parameters#decorators) to ensure input integrity and enable successful deployments
  - Only use the [`@secure()` parameter decorator](https://docs.microsoft.com/azure/azure-resource-manager/bicep/parameters#secure-parameters) for inputs, never for outputs (outputs are stored as plain text)
- **Comments** should provide additional context where needed:
  - Use single-line `// <comment here>` and multi-line `/* <comment here> */` comments
  - Include contextual Microsoft documentation URLs to help with understanding
  - Avoid redundant comments when decorators like `@description()` provide adequate coverage
- Store all expressions used in conditionals and loops in variables to improve readability
- **Default values** should be specified for all parameters where possible:
  - Call out default values in parameter descriptions
  - Document default values in appropriate locations
- Use **2-space tab indents** for all Bicep files
- Include **double line breaks** between each element type section
- Each Bicep file must contain a multi-line comment header with relevant details

#### Bicep Common Parameters Naming Standards

Follow these naming conventions for consistency:

- **`location`**
  - Use for all module parameters specifying the Azure region for deployment
  - Exception: When inter-related services lack region parity and require different regions (e.g., Log Analytics and Automation Accounts in China)

#### Bicep File Structure Example

Here's an example of a properly structured Bicep file:

```bicep
// SCOPE
targetScope = 'subscription' //Deploying at Subscription scope to allow resource groups to be created and resources in one deployment

// PARAMETERS
@description('Example description for parameter.')
param resourceGroupNamePrefix string = 'test'

// VARIABLES
// RESOURCE DEPLOYMENTS
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: 'australiaEast' // Hardcoded as an example of commenting inside a resource
}

/*
No modules being deployed in this example
*/

// OUTPUTS
output resourceGroupID string = resourceGroup.id

```

### Constructing a Bicep Module

To create Bicep modules that meet project requirements, ensure they:

- Follow the [Bicep Formatting Guidelines](#bicep-formatting-guidelines) above
- Are located in a folder: `<this-repo>/src/modules/...`
  - Use camelCase folder naming: `<this-repo>/src/modules/moduleName`
  - Also include a `.test.bicep` file under `<this-repo>/src/modules/moduleName/.test`

#### Resource API Versions

Each resource must use the latest available, working API version. If you cannot use the latest API version, include a comment above the resource explaining why and mention this in your pull request.
