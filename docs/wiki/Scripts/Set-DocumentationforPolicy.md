# Set-DocumentationforPolicy.ps1

Generates policy documentation and exports data from Bicep templates to CSV and Markdown files using PSDocs.

## Script

```powershell
./scripts/Set-DocumentationforPolicy.ps1
```

### Notes

Requires PowerShell 7.0.0 or higher.
Requires the modules: psdocs
Make sure that the Bicep files are structured correctly for processing.

## Description

This script processes policy assignments, definitions, and exemptions defined in Bicep templates.
It converts these Bicep files into JSON, extracts relevant data, groups it by scope, and then exports it to CSV files.
It also generates Markdown documentation for the policies using PSDocs.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
policyDirectoryPath | src/modules/policy | Specifies the path to the directory containing the policy Bicep files. Default is 'src/modules/policy'.
OutputPath | docs/wiki/Policy | Specifies the output path where the CSV files and policy documentation will be saved. Default is 'docs/wiki/Policy'.
GitHub | False         | Indicates whether to update _Sidebar.md with the generated policy documentation.
WhatIf | _null_        | _Not provided_
Confirm | _null_        | _Not provided_

## Examples

### Example 1

```powershell
.\Set-DocumentationforPolicy.ps1
```

Executes the script using the default paths for policy directories and output.

### Example 2

```powershell
.\Set-DocumentationforPolicy.ps1 -policyDirectoryPath 'src/policies' -OutputPath 'output/docs'
```

Executes the script with custom paths for the policy directory and the documentation output.
