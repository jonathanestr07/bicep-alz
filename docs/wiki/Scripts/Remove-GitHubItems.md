# Remove-GitHubItems.ps1

This script deletes GitHub Actions runs and all deployments for a specified repository in a given GitHub organization, optionally including the 'main' branch and/or only cancelled runs.

## Script

```powershell
./scripts/Remove-GitHubItems.ps1
```

### Notes

Ensure the GitHub CLI is installed and configured on your system before running this script. Also, ensure you have the necessary permissions for the specified GitHub organization and repository.

## Description

The script uses the GitHub CLI to interact with GitHub's API. It fetches and deletes GitHub Actions runs in the specified repository, excluding the 'main' branch by default. If the 'includeMain' switch is used, runs on the 'main' branch will also be included. If the 'CancelledOnly' switch is used, only runs that have been cancelled will be deleted. It then proceeds to fetch and delete all deployments within the same repository.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
Organisation | _null_        | The name of the GitHub organization that owns the repository.
Repository | _null_        | The name of the repository within the specified organization.
includeMain | False         | Include GitHub Actions runs on the 'main' branch in the deletion process.
CancelledOnly | False         | Only remove GitHub Actions runs that have been cancelled.
FailedOnly | False         | Only remove GitHub Actions runs that have failed.

## Examples

### Example 1

```powershell
.\Remove-GitHubItems.ps1 -Organisation "example-org" -Repository "example-repo"
```

This example removes all non-main branch GitHub Actions runs and all deployments from the 'example-repo' repository within the 'example-org' organization.

### Example 2

```powershell
.\Remove-GitHubItems.ps1 -Organisation "example-org" -Repository "example-repo" -includeMain
```

This example removes all GitHub Actions runs (including those on the 'main' branch) and all deployments from the 'example-repo' repository.

### Example 3

```powershell
.\Remove-GitHubItems.ps1 -Organisation "example-org" -Repository "example-repo" -CancelledOnly
```

This example removes only cancelled GitHub Actions runs (excluding 'main' branch by default) and all deployments from the 'example-repo' repository.
