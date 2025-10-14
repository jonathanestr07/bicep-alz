# Update-AzModules.ps1

Updates Azure modules to their latest versions.

## Script

```powershell
./scripts/Update-AzModules.ps1
```

### Notes

- This script requires an internet connection to access the PowerShell Gallery.
- This script requires administrative privileges to update modules for all users.
- This script assumes you have already installed Az Modules for all users. If not, please do that instead.

## Description

This script checks for updates to Azure modules and updates them if necessary. It iterates through all installed Azure modules with names starting with "Az." and compares their current versions to the latest versions available in the PowerShell Gallery. If a newer version is found, it updates the module and uninstalls the outdated version.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------


## Examples

### Example 1

```powershell
.\Update-AzureModules.ps1
Updates Azure modules to their latest versions.
```
