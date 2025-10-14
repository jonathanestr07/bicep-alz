# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
childDnsZones  | No       | An array of child DNS zones.
tags           | No       | The tags to apply to the DNS zone.
primaryDnsZoneName | Yes      | The name of the primary DNS zone.

### childDnsZones

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

An array of child DNS zones.

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The tags to apply to the DNS zone.

- Default value: `@{environment=production}`

### primaryDnsZoneName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the primary DNS zone.

## Snippets

### Command line

#### PowerShell

```powershell
New-AzResourceGroupDeployment -Name <deployment-name> -ResourceGroupName <resource-group-name> -TemplateFile <path-to-template> -TemplateParameterFile <path-to-templateparameter>
```

#### Azure CLI

```text
az group deployment create --name <deployment-name> --resource-group <resource-group-name> --template-file <path-to-template> --parameters @<path-to-templateparameterfile>
```
