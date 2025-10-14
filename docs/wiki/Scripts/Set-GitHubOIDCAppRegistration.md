# Set-GitHubOIDCAppRegistration.ps1

This script sets an app registration in Azure AD and connects it with a specified GitHub repository.

## Script

```powershell
./scripts/Set-GitHubOIDCAppRegistration.ps1
```

### Notes

Ensure Azure PowerShell is installed and you have the necessary permissions in Azure AD (Global Administrator, Application Developer or Application Administrator).

## Description

The script uses Azure PowerShell cmdlets to set an app registration in Azure AD and configure it for GitHub Actions OIDC authentication. It verifies if the app registration already exists, and if so, adds a new credential. If not, it creates a new app registration and adds the necessary credential.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
org  | Insight-Services-APAC | The name of the GitHub organization.
repo | azure-landing-zones-bicep | The name of the GitHub repository.
appRegistrationName | sub-plat-dev-01 | The name of the Azure AD app registration.
RemoveAllFedCreds | False         | Switch to remove all existing federated credentials before adding the new one.

## Examples

### Example 1

```powershell
.\Set-GitHubAppRegistration.ps1 -org "Insight-Services-APAC" -repo "azure-landing-zones-bicep" -appRegistrationName "Custom-App-Name"
```

This example sets an app registration with the name 'Custom-App-Name' for the 'azure-landing-zones-bicep' repository within the 'Insight-Services-APAC' organization.

### Example 2

```powershell
.\Set-GitHubAppRegistration.ps1 -org "Insight-Services-APAC" -repo "azure-landing-zones-bicep" -appRegistrationName "Custom-App-Name" -RemoveAllFedCreds
```

This example removes all existing federated credentials and sets a new app registration with the name 'Custom-App-Name' for the 'azure-landing-zones-bicep' repository within the 'Insight-Services-APAC' organization.
