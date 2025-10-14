# How-to Guide: Understanding and Using Automatic Documentation Generation

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [How the Process Works](#how-the-process-works)
- [Scripts Involved in Documentation Generation](#scripts-involved-in-documentation-generation)
- [Running Documentation Generation Locally](#running-documentation-generation-locally)
  - [Example VS Code Launch Configuration](#example-vs-code-launch-configuration)
- [Benefits of Automatic Documentation](#benefits-of-automatic-documentation)
- [Troubleshooting & Common Issues](#troubleshooting--common-issues)
- [Maintaining Consistency](#maintaining-consistency)
- [Summary](#summary)

---

## Introduction

In this Azure Platform repository, some documentation is automatically generated whenever you raise or update a Pull Request (PR). This ensures that complex areas like Azure Firewall configurations, Azure Policy definitions, and other infrastructure details are made more human-readable. As a result, reviewers can easily understand what has changed without diving into raw Bicep or ARM code.

> **Important Note**: The documentation generation process involves also running `bicep build`. If your Bicep files contain syntax errors or issues, the pipeline will fail when attempting to build the bicep file. Use this early detection to fix code quality issues in the given `.bicep` files.

---

## Prerequisites

- Familiarity with the repository structure and the role of Bicep, markdown, and PowerShell scripts.
- Permissions to raise and manage PRs.
- A basic understanding of VS Code and its PowerShell extension if you plan to run documentation scripts locally.

---

## How the Process Works

1. **Raise or Update a PR:**
   When you open or modify a PR, a Continuous Integration (CI) pipeline (in GitHub Actions or Azure DevOps) is triggered.

2. **Documentation Scripts Run:**
   The pipeline checks out your PR branch and runs several PowerShell scripts that:
   - Generate markdown documentation from your Bicep and YAML files.
   - Convert documents into human-readable formats, including potential Word exports.
   - Validate that your Bicep code can successfully compile into ARM templates.

3. **Commit Back to PR Branch:**
   Any updated documentation files are automatically committed back into your PR branch, ensuring the documentation aligns with your changes.

4. **Review the PR with Updated Docs:**
   Reviewers see the updated markdown (and possibly Word documents) in the PR, making it easier to assess changes. If there’s an issue with the Bicep code, the pipeline’s failure is an immediate red flag.

---

## Scripts Involved in Documentation Generation

| Script Name                         | Location            | Purpose                                                                             | Output                                   |
|-------------------------------------|---------------------|-------------------------------------------------------------------------------------|-------------------------------------------|
| `Get-AzurePricingforSolution.ps1`   | `scripts` directory | Retrieves Azure retail pricing for certain resources and outputs as CSV.            | CSV files in `docs/wiki/Pricing/`         |
| `Set-Documentation.ps1`             | `scripts` directory | Converts code (including infrastructure definitions) into markdown files.           | Markdown files in `docs/wiki/`            |
| `Set-DocumentationforPolicy.ps1`    | `scripts` directory | Parses policy Bicep files into readable CSV and Markdown documentation.              | Markdown & CSV in policy documentation    |
| `Set-DocumentationforFirewall.ps1`  | `scripts` directory | Converts Azure Firewall rules and settings into CSV and Markdown documentation.      | Markdown & CSV in firewall documentation  |

**Note:** If you change how Bicep code is structured, the corresponding PowerShell scripts may need updates to reflect these new structures.

---

## Running Documentation Generation Locally

While automatic documentation generation happens upon PR creation or updates, you can also run these scripts locally. This helps you catch issues early and iterate faster without waiting for CI.

### Example VS Code Launch Configuration

```json
{
  "name": "Build Documentation from Code",
  "type": "PowerShell",
  "request": "launch",
  "script": "${workspaceFolder}/scripts/Set-Documentation.ps1",
  "args": [
    "-BicepDirectoryPaths ('src/orchestration', 'src/modules') -PSRuleDirectoryPaths ('.ps-rule') -ScriptsDirectoryPaths ('scripts') -PricingCSVFilePaths ('docs/wiki/Pricing') -GitHub"
  ],
  "cwd": "${workspaceFolder}",
  "presentation": {
    "hidden": false,
    "group": "3. Utilities"
  }
}
```

**How to Use Locally:**

1. Open the **Run and Debug** panel in VS Code.
2. Select the `Build Documentation from Code` configuration.
3. Press **F5** or click **Start Debugging**.
4. The script executes locally, generating documentation and validating your Bicep code. If issues arise, they’ll appear in the terminal, allowing you to fix them before pushing to the repository.

---

## Benefits of Automatic Documentation

1. **Enhanced Review Experience:**
   Automatically updated documentation in PRs helps reviewers understand complex changes immediately, speeding up the review process.

2. **Code-to-Doc Alignment:**
   Documentation is always in sync with the latest code changes, preventing discrepancies.

3. **Early Error Detection:**
   Running `bicep build` during documentation generation surfaces syntax or logical errors in Bicep code early, reducing the mean time to restore (MTTR) if something goes wrong.

---

## Troubleshooting & Common Issues

- **Documentation Generation Fails:**
  If the pipeline fails, it often indicates an error in your Bicep code. Check your syntax and structure. Running the generation script locally is a good way to pinpoint the issue.

- **Major Changes to Bicep Files:**
  Major structural changes to Bicep files may require updates to the PowerShell scripts. E.g. When the bicep builds to ARM, the JSON is imported in the powershell to read the configuration. If the changes to Bicep are substantial, like a re-architecture (e.g. two Azure Firewalls instead of one) you'll need to adjust the script logic to reflect the new resource layouts or structural changes.

---

## Maintaining Consistency

1. **Sync Scripts with Code:**
   When making fundamental changes to Bicep layouts or formats, update the corresponding documentation scripts to ensure they still produce accurate output. Do this in a separate PR without changes to end-result configuration. E.g. Change the Firewall bicep files but don't add/remove rules in the same PR.

2. **Validate Locally Before PR:**
   Test your changes and documentation generation locally to catch and fix errors early. This reduces friction during PR reviews and CI runs.

---

## Summary

By automating documentation generation and validating Bicep builds, the repository ensures that code changes are always accompanied by up-to-date, human-readable documentation. This approach streamlines PR reviews, improves code quality, and reduces deployment errors. Running the scripts locally via VS Code’s debug functionality further enhances developer productivity, allowing for quick feedback loops and early detection of issues.
