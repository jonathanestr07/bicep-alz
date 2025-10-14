# Invoke-AzurePolicyRemediationDINE.ps1

Invokes Azure Policy Remediation for non-compliant policies with deployIfNotExists action.

## Script

```powershell
./scripts/Invoke-AzurePolicyRemediationDINE.ps1
```

### Notes

Author: Trent Steenholdt
Date: 2025-01-30

## Description

This script retrieves all non-compliant policies with the action 'deployIfNotExists' and starts a remediation task for each policy.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------


## Examples

### Example 1

```powershell
.\Invoke-AzurePolicyRemediationDINE.ps1
This will execute the script and start remediation tasks for all applicable policies.
```
