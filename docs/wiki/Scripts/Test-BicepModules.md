# Test-BicepModules.ps1

Tests the validity of bicep files in the specified modules and modules directories.

## Script

```powershell
./scripts/Test-BicepModules.ps1
```

## Description

The Test-BicepModules function tests the validity of bicep files in the specified modules and modules directories. It checks that the files can be successfully built using the bicep build command. If any file fails to build, the script returns an error and the function stops.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
PSRule | False         | Whether to run PSRule Analyser instead of Bicep build validation.
ModulesDirectoryPaths | @('src/modules') | The paths to the directories containing the modules.
WhatIf | _null_        | _Not provided_
Confirm | _null_        | _Not provided_

## Examples

### Example 1

```powershell
.\Test-BicepModules.ps1 -modulesDirectoryPaths @('../modules')
```

Tests the bicep files in the default modules and modules directories.
