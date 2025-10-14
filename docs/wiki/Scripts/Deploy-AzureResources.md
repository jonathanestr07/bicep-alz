# Deploy-AzureResources.ps1

Executes Azure deployments, manages KeyVault secrets, and handles Bicep/ARM module deployments.

## Script

```powershell
./scripts/Deploy-AzureResources.ps1
```

### Notes

Requires PowerShell 7.0 or later. The script enforces strict mode to the latest version and stops on error.

## Description

This script manages initialization of deployment contexts, idempotent secret generation, KeyVault access policies, and the execution of Bicep module deployments. It supports verbose logging and robust error handling to facilitate complex deployment tasks.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
DeploymentJobId | _null_        | Specifies the ID of the deployment job which uniquely identifies the deployment operation.
TenantId | _null_        | Specifies the Azure Tenant ID where the deployment is to be executed.
ManagementGroupId | _null_        | (Optional) Specifies the Azure Management Group ID for deployments scoped at the management group level.
SubscriptionId | _null_        | (Optional) Specifies the Azure Subscription ID for deployments scoped at the subscription level.
AzureRegion | _null_        | Defines the Azure region where the deployment should take place.
ConfigurationFileKey | _null_        | Specifies the key for the configuration file which contains deployment settings.
ResourceGroup | _null_        | (Optional) Specifies the Azure Resource Group where the deployment should take place if scoped at the resource group level.
Orchestration | _null_        | (Optional) Specifies the Bicep orchestration file to be used for deployment. This parameter should not be used simultaneously with the 'Module' parameter.
Module | _null_        | (Optional) Specifies the Bicep module file to be used for deployment. This parameter should not be used simultaneously with the 'Orchestration' parameter.
ConfigKey | _null_        | (Optional) Specifies a key under which additional configuration data can be accessed within the deployment process.
ConfigurationFiles | _null_        | (Optional) Specifies a hashtable of configuration files needed for the deployment.
Flags | _null_        | (Optional) Specifies a hashtable of flags that alter the deployment process behavior.
Me   | _null_        | (Optional) Specifies a hashtable containing additional user information.
AdditionalParameters | _null_        | (Optional) Specifies a hashtable of additional parameters needed for the deployment process.
Diagnostics | _null_        | (Optional) Specifies a hashtable containing diagnostic information to aid in troubleshooting.
SecretsToIdempotentlyGenerate | _null_        | (Optional) Specifies an array of secrets that should be generated idempotently within KeyVault.
PermissionLevels | _null_        | _Not provided_
DeploymentScope | _null_        | _Not provided_
WhatIf | _null_        | _Not provided_
Confirm | _null_        | _Not provided_

## Examples

### Example 1

```powershell
.\Deploy-AzureResources.ps1 -DeploymentJobId "ID123" -TenantId "Tenant123" -SubscriptionId "Sub123" -AzureRegion "eastus" -ConfigurationFileKey "ConfigKey1" -Orchestration "OrchestrationFile.bicep"
```

This example demonstrates how to run the script with mandatory parameters and an orchestration file, specifying the deployment job ID, tenant ID, subscription ID, Azure region, and the configuration file key.
