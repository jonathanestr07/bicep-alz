# Set-Documentation.ps1

Generates documentation for Bicep modules, PSRule custom rules, RBAC configurations, PIM configurations, scripts, and pricing data.

## Script

```powershell
./scripts/Set-Documentation.ps1
```

### Notes

This script requires PowerShell version 7.0.0 or later.
This script requires the Bicep CLI if the SkipBicepBuild switch is not set.
This script requires powershell-yaml, psdocs, and psdocs.azure modules installed.
When using AzureRolesDisplayName, ensure you are signed in to Azure with appropriate permissions.

## Description

This script uses PSDocs to generate documentation for Bicep modules, PSRule custom rules, RBAC configurations, PIM configurations, PowerShell scripts, and pricing CSV files. It uses a combination of Bicep and ARM templates to create detailed documentation for each resource. By default, the script looks for Bicep files in 'src/orchestration' and 'src/modules' directories, PSRule files in '.ps-rule' directory, scripts in 'scripts' directory, and pricing CSV files in 'docs/wiki/Pricing' directory. The script also processes RBAC and PIM Bicep parameter files to generate role-based access control and privileged identity management documentation. If the Bicep modules change frequently, set the SkipBicepBuild switch to false to rebuild the Bicep files into ARM templates and ensure the documentation is up-to-date. The script also creates necessary directories for storing the built templates and documentation.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
BicepDirectoryPaths | @('src/orchestration', 'src/modules') | An array of directories to scan for Bicep files. Defaults to 'src/orchestration' and 'src/modules'.
PSRuleDirectoryPaths | @('.ps-rule') | An array of directories to scan for PSRule files. Defaults to '.ps-rule'.
ScriptsDirectoryPaths | @('scripts')  | An array of directories to scan for custom scripts. Defaults to 'scripts'.
PricingCSVFilePaths | @('docs/wiki/Pricing') | An array of directories to scan for pricing CSV files. Defaults to 'docs/wiki/Pricing'.
RBACBicepParameterFile | src/configuration/platform/roleAssignments.bicepparam | Path to the RBAC Bicep parameter file. Defaults to 'src/configuration/platform/roleAssignments.bicepparam'.
PIMBicepParameterFile | src/configuration/platform/privilegedIdentityManagement.bicepparam | Path to the PIM Bicep parameter file. Defaults to 'src/configuration/platform/privilegedIdentityManagement.bicepparam'.
SkipBicepBuild | False         | A switch to skip the building of Bicep files into ARM templates. When set, the script uses the existing ARM templates.
GitHub | False         | Indicates whether to update _Sidebar.md with the generated documentation links.
AzureRolesDisplayName | False         | A switch to use Azure role definitions from the signed-in Azure context instead of local source data.
WhatIf | _null_        | _Not provided_
Confirm | _null_        | _Not provided_

## Examples

### Example 1

```powershell
.\Set-Documentation.ps1 -SkipBicepBuild:$false
```

Scans the default directories for Bicep, PSRule, scripts, and pricing files, builds the Bicep files into ARM templates, and generates the documentation.

### Example 2

```powershell
.\Set-Documentation.ps1 -GitHub -AzureRolesDisplayName
```

Generates documentation and updates the GitHub sidebar with links, using Azure role definitions from the current Azure context.
