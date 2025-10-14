# Test-AzPester.ps1

Runs all Pester test files in the 'tests' directory of the project.

## Script

```powershell
./scripts/Test-AzPester.ps1
```

### Notes

- Requires PowerShell 7.0.0 or later.
- Expects the Pester module to be available.
- Set-StrictMode is enabled for robust error handling.
- Stops execution on errors.

## Description

This script locates and executes all PowerShell Pester test files (*.tests.ps1) found recursively under the 'tests' directory relative to the script's location. It ensures the Pester module is installed and imported before running tests. Each test file is executed individually, and detailed output is provided. If no test files are found, the script exits gracefully.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------


## Examples

### Example 1

```powershell
.\Test-AzPester.ps1
Runs all Pester tests in the 'tests' directory.
```

Requires -Version 7.0.0
