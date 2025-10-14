# Confirm-LandingZonePrerequisites.ps1

Executes prerequisite checks before deploying a new Landing Zone.

## Script

```powershell
./scripts/Confirm-LandingZonePrerequisites.ps1
```

## Description

This PowerShell script performs a series of prerequisite checks to confirm system compatibility before executing a new Landing Zone deployment. These checks include verifying the versions of PowerShell, Azure PowerShell, and Azure CLI, updating Bicep version, and ensuring the executing user has owner permissions at the root ("/") scope of the tenant.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
parIsSLZDeployedAtTenantRoot | True          | Indicates whether the Secure Landing Zone (SLZ) is deployed at the tenant root. Default is $true.

## Examples

### Example 1

```powershell
.\Confirm-LandingZonePrerequisites.ps1
Executes the prerequisite checks with default parameters.
```

### Example 2

```powershell
.\Confirm-LandingZonePrerequisites.ps1 -parIsSLZDeployedAtTenantRoot $false
Executes the prerequisite checks and assumes that the SLZ is not deployed at the tenant root.
```
