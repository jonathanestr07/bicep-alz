# Invoke-LibraryUpdate.ps1

Updates template library in the local repository.

## Script

```powershell
./scripts/Invoke-LibraryUpdate.ps1
```

### Notes

Requires modules and custom configurations specified in the ALZ tools path.

## Description

This script updates the template library by exporting policy definitions and policy set definitions from the specified source path to a target library path. It uses a predefined schema to export the artifacts and supports optional parameters for recursive export and updating provider API versions.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
AlzToolsPath | "$PWD/enterprise-scale/src/Alz.Tools" | The path to the ALZ tools module which is used within the script for various operations. Default is "$PWD/enterprise-scale/src/Alz.Tools".
TargetPath | "$PWD/ALZ-Bicep" | The target path where the library artifacts are saved. Default is "$PWD/ALZ-Bicep".
SourcePath | "$PWD/enterprise-scale" | The source path from where the policy definitions and policy set definitions are read. Default is "$PWD/enterprise-scale".
InsightRootPath | src           | The root path inside the TargetPath where the files will be stored. Default is "src".
LineEnding | unix          | The type of line ending to use in the output files. Default is "unix".
Reset | False         | Switch to indicate whether to reset the library by deleting all existing artifacts before exporting new ones.
UpdateProviderApiVersions | False         | Switch to indicate whether to update provider API versions. If not set, the script uses cached versions if available.
WhatIf | _null_        | _Not provided_
Confirm | _null_        | _Not provided_

## Examples

### Example 1

```powershell
.\ScriptName.ps1 -Reset -UpdateProviderApiVersions
Executes the script with the reset and update provider API versions options enabled, clearing the existing artifacts and updating the API versions before exporting new artifacts.
```
