# Set-DocumentationforFirewall.ps1

Generates firewall rule documentation and exports data from Bicep templates to CSV and Markdown files using PSDocs.

## Script

```powershell
./scripts/Set-DocumentationforFirewall.ps1
```

### Notes

Requires PowerShell 7.0.0 or higher.
Requires the module: PSDocs.
Ensure the Bicep files are structured correctly for processing.

## Description

This script processes firewall rules, rule collection groups, and IP groups defined in Bicep templates.
It converts these Bicep files into JSON, extracts relevant data, and exports it to CSV files.
It also generates Markdown documentation for the firewall rules using PSDocs.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
firewallRules | src/modules/azFirewallRules/azFirewallRules.bicep | Specifies the path to the file containing firewall rule Bicep definitions. Default is 'src/modules/azFirewallRules/azFirewallRules.bicep'.
OutputPath | docs/wiki/Firewall | Specifies the output path where the CSV files and firewall rule documentation will be saved. Default is 'docs/wiki/Firewall'.
GitHub | False         | Indicates whether to update _Sidebar.md with the generated policy documentation.
diagrams | False         | Indicates whether to generate diagrams for the firewall rules.
WhatIf | _null_        | _Not provided_
Confirm | _null_        | _Not provided_

## Examples

### Example 1

```powershell
.\Get-DocumentationforFirewall.ps1
```

Executes the script using the default paths for firewall rules and the documentation output.

### Example 2

```powershell
.\Get-DocumentationforFirewall.ps1 -firewallRules 'src/firewall/rules.bicep' -OutputPath 'output/docs'
```

Executes the script with custom paths for the firewall rules and the documentation output.
