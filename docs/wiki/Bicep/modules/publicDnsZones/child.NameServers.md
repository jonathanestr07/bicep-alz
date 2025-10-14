# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
nsServers      | Yes      | Array of name server addresses for the DNS zone.
dnsZoneName    | Yes      | The name of the DNS zone.
parentDnsZoneName | Yes      | The parent zone name

### nsServers

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Array of name server addresses for the DNS zone.

### dnsZoneName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the DNS zone.

### parentDnsZoneName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The parent zone name

## Outputs

Name | Type | Description
---- | ---- | -----------
computedVariable | array |
NSRecordName | string |

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
