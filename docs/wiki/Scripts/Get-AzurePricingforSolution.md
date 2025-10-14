# Get-AzurePricingforSolution.ps1

This script automates the retrieval and documentation of Azure service pricing based on configurations defined in a Bicep file.

## Script

```powershell
./scripts/Get-AzurePricingforSolution.ps1
```

### Notes

Requires PowerShell 7.0.0 or higher.
The script sets strict error handling policies to ensure robustness.
It assumes that the shared Bicep file uses a standard JSON structure for defining resources.

## Description

The script takes parameters for localization, a shared Bicep file path, currency code, and output directory. It then generates a JSON from the Bicep file, uses this JSON to query the Azure Pricing API, and finally outputs the pricing data into CSV files in the specified directory. It supports conditional API calls based on resource configurations and includes robust error handling and path validations.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
location | _null_        | The Azure location for which pricing information should be retrieved. Default is 'australiaeast'.
sharedBicepFile | ./src/configuration/shared.conf.bicep | The path to the Bicep file containing the Azure resources configuration. Default is './src/configuration/shared.conf.bicep'.
currencyCode | _null_        | The currency code to use when retrieving pricing information. Default is 'AUD'.
OutputDirectory | ./docs/wiki/Pricing | The directory path where the output CSV files will be saved. Default is './docs/wiki/Pricing'.
WhatIf | _null_        | _Not provided_
Confirm | _null_        | _Not provided_

## Examples

### Example 1

```powershell
.\Get-AzurePricingforSolution.ps1
```

Runs the script with default parameters, retrieving pricing for services configured in './src/configuration/shared.conf.bicep' for 'australiaeast' in AUD, and outputs to './docs/wiki/Pricing'.

### Example 2

```powershell
.\Get-AzurePricingforSolution.ps1 -location "northeurope" -currencyCode "EUR" -OutputDirectory "./pricing/europe"
```

Runs the script with specified parameters for 'northeurope', using 'EUR' as the currency, and outputs the CSV files to './pricing/europe'.
