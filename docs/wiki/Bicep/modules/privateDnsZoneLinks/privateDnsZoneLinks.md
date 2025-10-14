# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
spokeVirtualNetworkResourceId | No       | The Spoke Virtual Network Resource Id.
privateDnsZoneResourceId | No       | The Private DNS Zone Resource Ids to associate with the spoke Virtual Network.

### spokeVirtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Spoke Virtual Network Resource Id.

### privateDnsZoneResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Private DNS Zone Resource Ids to associate with the spoke Virtual Network.

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
