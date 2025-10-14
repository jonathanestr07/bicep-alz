# ALZ Bicep Module - Custom Policy Exemptions

Insight custom Policy Exemptions for Azure Landing Zones

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
topLevelManagementGroupPrefix | No       | Prefix for the Management Group hierarchy.

### topLevelManagementGroupPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Prefix for the Management Group hierarchy.

- Default value: `alz`

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
