# Azure Landing Zones - Pipelines

This document provides high-level guidance for deploying the Azure Landing Zone modules with pipelines and provides examples for GitHub Actions and Azure DevOps Pipelines. The examples leverages the orchestration templates, deployment sequence, and prerequisites. In addition to these prerequisites, a GitHub or Azure DevOps account will be needed to run the pipelines.

## Azure Landing Zone Orchestration

### Overview

A pipeline is the repeatable process defined in a configuration file that you use to test and deploy your code. A pipeline includes all the steps you want to execute and in what order. You define your pipeline in a YAML file. A YAML file is a structured text file, similar to how Bicep is a structured text file. You can create and edit YAML files by using any text editor. Because a pipeline YAML file is a code file, the file is stored with your Bicep code in your Git repository. You use Git features to collaborate on your pipeline definition. You can manage different versions of your pipeline file by using commits and branches.

### Sample Pipelines

These Azure Landing Zone example sequentially deploys the associated modules. The pipelines have been configured with manual triggers for learning and experimentation.

### Example Pipeline Code

- [GitHub Actions](Pipelines-GitHubActions.md)
- [Azure DevOps Pipelines](Pipelines-AzureDevOps.md)

### Considerations

The example  provides a simple deployment pipeline. In production environments it will likely be necessary to use more advanced pipelines to meet additional requirements. Often different teams are responsible for the various Azure Landing Zone components and may need to manage their deployments/pipelines separately to meet their particular requirements.

The example uses manually triggered pipelines for learning purposes. For GitHub Actions we use `on: [workflow_dispatch]` event for a manually triggered workflow. For Azure DevOps we use `trigger: none` for a manually triggered pipeline run.

Typically teams will want to take a more automated approach to running workflows based upon events that occur in the repository, such as a pull request to the main branch. Normally protected by a branch policies to enforce all changes to a protected branch (e.g. `main`) must be made via a PR.

## Recommended Learning

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
