# GitHub Actions Pipeline

- [Create Service Principal(s)](#create-service-principals)
- [Adding Variables to GitHub Repository](#adding-variables-to-github-repository)
- [Adding Secrets to GitHub Repository](#adding-secrets-to-github-repository)
  - [Using Different Credentials for Each Part of the Platform](#using-different-credentials-for-each-part-of-the-platform)
- [Pipelines](#pipelines)
  - [Repository Management Pipeline](#repository-management-pipeline)
  - [Run This Pipeline in Standalone Mode](#run-this-pipeline-in-standalone-mode)

The following instructions detail how to set up GitHub Actions for a customer site deployment.

## Create Service Principal(s)

See [prerequisites](../deployments/Deployments-pre-deploy.md) to create the necessary Service Principal(s).

## Adding Variables to GitHub repository

Create the following `Repository` level variables.

| Variable name       | Variable context                                                 |
| ------------------- | ---------------------------------------------------------------- |
| LOCATION            | The suitable Azure region to run this from. E.g. `australiaeast` |
| MANAGEMENT_GROUP_ID | The management group id to deploy into. E.g. `mg-alz`            |

## Adding Secrets to GitHub repository

Create the following `Repository` level secrets.

| Secret name           | Secret context                                                                                                          |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| AZURE_CLIENT_ID       | The client Id of the Service Principal created as part of the [prerequisites](../deployments/Deployments-pre-deploy.md) |
| AZURE_SUBSCRIPTION_ID | The subscription Id the service principal has visibility of.                                                            |
| AZURE_TENANT_ID       | The Microsoft Entra Tenant Id associated with the subscription                                                          |

To create these secrets, execute the following steps:

1. On GitHub, navigate to the main page of the repository.
2. Under your repository name, click on the **Settings** tab.
3. In the left sidebar, click **Secrets**.
4. Click **New repository secret**.
5. Type the name as above for your secret in the Name input box.
6. Enter the secret value in the larger text box. Be mindful of any carriage returns!
7. Click **Add secret**.

> **Note:**
> Environmental level secrets are not supported for caller workflows. Please use repository secrets only.

### Using different credentials for each part of the platform

If you are using different credentials for part of the platform, simply append the `suffix` of what's needed to the `AZURE_CLIENT_X` values. E.g. `AZURE_CLIENT_ID_ROLE` or `AZURE_CLIENT_ID_CONNECTIVITY`.

Then ensure you have updated the `release_XXX.yml` file(s) with the necessary suffix.

## Pipelines

There are several available GitHub Action pipelines for usage in deploying and maintaining the Azure Platform Landing Zone. These are:

| Pipeline Name                              | Pipeline YAML File                 | Notes                                                                                                                                                                                                                                                                     | Conditions/ Options                                                             | Trigger                                  |
| ------------------------------------------ | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | ---------------------------------------- |
| Release - Platform Landing Zone            | `release.yml`                      | This pipeline is your first run and complete end-to-end pipeline (except site-to-site connectivity, unless option is checked). This pipeline is effectively the pipeline to run to deploy everything, or bring back everything into desired state if there is any issues. | - Deploy the entire platform (except S2S)<br>- Deploy Site-to-Site Connectivity | - Manual                                 |
| Release - Azure Firewall                   | `release_AzureFirewall.yml`        | This pipeline updates the configuration of the Azure Firewall.                                                                                                                                                                                                            | - Run this pipeline in standalone mode                                          | - Cron job, 7AM every Monday<br>- Manual |
| Release - Azure Policy                     | `release_AzurePolicy.yml`          | This pipeline updates the configuration of Azure Policy in the platform                                                                                                                                                                                                   | - Run this pipeline in standalone mode                                          | - Cron job, 8AM every Monday<br>- Manual |
| Release - Platform Connectivity            | `release_PlatformConnectivity.yml` | This pipeline deploys the connectivity subscription resources.                                                                                                                                                                                                            | - Run this pipeline in standalone mode                                          | - Manual                                 |
| Release - Platform Identity                | `release_PlatformIdentity.yml`     | This pipeline deploys the identity subscription resources.                                                                                                                                                                                                                | - Run this pipeline in standalone mode                                          | - Manual                                 |
| Release - Platform Management              | `release_PlatformManagement.yml`   | This pipeline deploys the management subscription resources.                                                                                                                                                                                                              | - Run this pipeline in standalone mode                                          | - Manual                                 |
| Release - Role Assignments and Definitions | `release_Role.yml`                 | This pipeline deploys all the role assignments, definitions and exemptions (if policyExemption is `true` in yaml) for the platform                                                                                                                                        | - Run this pipeline in standalone mode                                          | - Cron job, 9AM every Monday<br>- Manual |

### Repository Management Pipeline

The pipeline `repository-management.yml` automates repository maintenance tasks for Azure Landing Zone (ALZ) deployments. It runs weekly on the `main` branch using an Ubuntu runner, performs Bicep Unit Tests (simple build), and synchronises content from the official [ALZ repository](https://github.com/Azure/Enterprise-Scale).

> **Note:** The pipeline includes code to "Cleanup Azure Deployment" which is strictly for internal (Insight) purposes and should never be configured for a customer or organisation.

#### Bicep Unit Testing

The pipeline performs the following tasks:

- Validates the Bicep CLI version.
- Builds and lints Bicep templates.
- Automatically creates GitHub Issues if failures occur.

This ensures existing deployments remain functional against upstream changes.

#### Policy Synchronisation with Microsoft ALZ Repository

This pipeline updates policy templates by:

- Cloning the official repository.
- Applying detected policy updates.
- Converting updates into Bicep templates.
- Creating and pushing pull requests for detected changes.

If no changes are detected, pipeline steps are skipped, ensuring efficiency.

For environments and organisations using [Azure EPAC](https://azure.github.io/enterprise-azure-policy-as-code/), this synchronisation task can typically be disabled.

### Run this pipeline in standalone mode

Where the option `Run this pipeline in standalone mode` is made available, the intent of these pipelines is they are treated as post first-run pipelines only (e.g. after running `Release - Platform Landing Zone)`.

However, if you need to run this pipeline for whatever reason in a complete fashion, you can select this option to completely update predecessor jobs. E.g. Update the connectivity subscription before running the updates to Azure Firewall.

> **Note:** First-run is considered completed when a complete deployment (except Site-to-Site) is made with no errors.
