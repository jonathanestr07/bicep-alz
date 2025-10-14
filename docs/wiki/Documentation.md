# Documentation Generation

The process of generating documentation in this repository involves multiple directories and tools:

1. **PSDocs in the `.ps-docs/` Directory**
   Automatically generates markdown files from PowerShell and yaml files.

1. **PowerShell Scripts in the `scripts/` Directory**
   Includes `Set-Documentation.ps1` for converting code to markdown and `Convert-WikiMarkdowntoWord.ps1` for transforming markdown into Word documents.

1. **Metadata Configuration in `docs/.metadata`**
   Contains configuration information used by Pandoc and scripts to format and produce `.docx` files from markdown documents. Also aids in string find and replace with draw.io diagrams and wiki documentation.

## Steps to Generate Documentation

1. Execute `Set-Documentation.ps1` to generate markdown files from code.
1. Run `Set-DocumentationforWiki.ps1` to modify markdown files and draw.io diagrams with string find replace.
   - Update `.docs/metadata/config.jsonc` and key `WikiStringReplace` with strings you want replace.
   - Note this is a one-time run step.
1. Run `Convert-WikiMarkdowntoWord.ps1` to convert markdown files to Word format using the specified configuration.

These steps ensure the documentation is consistently formatted and easily updated.

## Azure Pricing

Azure Pricing can be calculated automatically for certain Azure resources. This is achieved by:

1. **Shared.bicep in the `src/configuration/shared` Directory**
   In this file is the `resource` export which includes a symlink using `pricing_serviceName` value.

2. **PowerShell Script `Get-AzurePricingforSolution.ps1` in the `scripts/` Directory**
   This files reads in the `shared.conf.bicep` file and makes Rest API calls to Azure retail pricing. This then saves the export as CSV files in the `docs/wiki/Pricing/` folder.

3. **Follows the existing Documentation Generation process**
   After steps 1 and 2 are run, the same logic above can be run to generate the markdown file and the associated word document.

## Azure Policy

Azure Policy documentation can be created automatically. This is achieved by:

1. **Appropriate bicep files in the `src/modules/policy` Directory**
   Includes files for Policy Assignments, Policy Definitions and Policy Exemptions

2. **PowerShell Script `Set-DocumentationforPolicy.ps1` in the `scripts/` Directory**
   This files reads Bicep files and converts them to CSV and Markdown files into the output directory.

## Azure Firewall

Azure Firewall documentation can be created automatically. This is achieved by:

1. **azFirewallRules.bicep in the `src/modules/azFirewallRules/` Directory**
   This file is read in for its variables and configuration

2. **PowerShell Script `Set-DocumentationforFirewall.ps1` in the `scripts/` Directory**
   This files reads Bicep file and converts the rules, collections and IP groups in it to CSV and Markdown files into the output directory.
