# Pipelines

For the Azure Landing Zone, we currently support two deployment toolings. These are:

- [GitHub Actions](./pipelines/Pipelines-GitHubActions.md)
- [Azure DevOps Pipeline](./pipelines/Pipelines-AzureDevOps.md)

In these markdown files are instructions to leverage the templated pipelines. These pipelines leverage the various orchestration templates and follow the correct deployment sequence.

> **Note:** Prerequisites must be completed first!
> Please ensure prerequisites described in [deployments/Deployments-pre-deploy.md](./deployments/Deployments-pre-deploy.md).

## Orchestration

This Azure Landing Zone has the following principles when it comes to orchestration and its deployment.

- **Pipeline Definition**: A pipeline is a repeatable process defined in a config file for testing and deploying code. It comprises various steps, executed in a specified sequence.
- **YAML File**: The pipeline is defined in a YAML file, akin to a Bicep structured text file. YAML files can be edited with any text editor, or your favorite IDE.
- **Integration with Git**: The pipeline YAML file, being a code file, is stored alongside your Bicep code in your Git repository.
  - **Collaboration**: Utilise Git features for collaborative pipeline definition.
  - **Version Management**: Manage different versions of your pipeline through commits and branches.

### Considerations

The example uses manually triggered pipelines for learning purposes. For GitHub Actions we use `on: [workflow_dispatch]` event for a manually triggered workflow. For Azure DevOps we use `trigger: none` for a manually triggered pipeline run.

Typically teams will want to take a more automated approach to running workflows based upon events that occur in the repository, such as a pull request to the main branch. Normally protected by a branch policies to enforce all changes to a protected branch (e.g. `main`) must be made via a PR.
