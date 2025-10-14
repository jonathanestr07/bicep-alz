# Set-GitHubEnvironments.ps1

This script creates GitHub Environments for a specified repository in a given GitHub organization using the GitHub API.

## Script

```powershell
./scripts/Set-GitHubEnvironments.ps1
```

### Notes

Ensure `Invoke-RestMethod` is available in your PowerShell environment before running this script. Also, ensure you have the necessary permissions for the specified GitHub organization and repository.

## Description

The script uses `Invoke-RestMethod` to interact with GitHub's API and create specified GitHub Environments within the repository.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
Organisation | _null_        | The name of the GitHub organization that owns the repository.
Repository | _null_        | The name of the repository within the specified organization.
EnvironmentNames | @("platform_managementGroup", "platform_connectivity", "platform_management", "platform_identity", "platform_policy", "platform_role", "platform_firewall") | A list of environment names to be created in the repository. Defaults to "platform_managementGroup", "platform_connectivity", "platform_management", "platform_identity", "platform_policy", "platform_role", "platform_firewall".

## Examples

### Example 1

```powershell
.\Set-GitHubEnvironments.ps1 -Organisation "example-org" -Repository "example-repo"
```

This example creates the environments 'platform_managementGroup', 'platform_connectivity', 'platform_management', 'platform_identity', 'platform_policy', 'platform_role', 'platform_firewall' in the 'example-repo' repository within the 'example-org' organization.
