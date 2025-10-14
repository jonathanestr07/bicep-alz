# Test-BicepOrchestrations.ps1

Performs module bicep testing using PSRule.

## Script

```powershell
./scripts/Test-BicepOrchestrations.ps1
```

### Notes

This script requires PowerShell version 7.0.0 or later.
This script requires Bicep CLI if hardcoded variable is set to true

## Description

This script performs module bicep testing using PSRule. It validates Bicep module deployments and generates test reports.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
DeploymentJobId | _null_        | The DeploymentJobId to display in the Azure Portal.
TenantId | _null_        | The Azure AD tenant ID to use for the deployment.
ManagementGroupId | _null_        | _Not provided_
SubscriptionId | _null_        | The Azure subscription ID to use for the deployment.
AzureRegion | _null_        | _Not provided_
ResourceGroup | _null_        | _Not provided_
ConfigKey | _null_        | _Not provided_
ConfigurationFiles | _null_        | _Not provided_
Flags | _null_        | _Not provided_
Me   | _null_        | _Not provided_
AdditionalParameters | _null_        | _Not provided_
Diagnostics | _null_        | A hashtable of diagnostics settings to use during the deployment.
SecretsToIdempotentlyGenerate | _null_        | _Not provided_
PermissionLevels | _null_        | _Not provided_
isMain | False         | _Not provided_
SkipBicepBuild | False         | _Not provided_
WhatIf | _null_        | _Not provided_
Confirm | _null_        | _Not provided_

## Examples

### Example 1

```powershell
Test-Modules.ps1 -EnvironmentCode "DEV" -EnvironmentName "Development" -LocationCode "USE" -DeploymentJobId 'Local.1' -LocationName "East US" -TenantId "12345678-1234-1234-1234-123456789012" -SubscriptionId "12345678-1234-1234-1234-123456789012"
  -ConfigurationFile "myconfig.json" -Diagnostics @{ "enabled" = "true"; "storageAccountName" = "mystorageaccount" }
```

Tests the bicep files in the default templates and modules directories.
