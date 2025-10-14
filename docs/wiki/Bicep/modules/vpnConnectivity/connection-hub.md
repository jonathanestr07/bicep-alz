# ALZ Bicep - VPN Connection for Azure Hub

Module used to set up VPN Connection for Azure Hub

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | No       | Optional. The Azure Region to deploy the resources into.
tags           | No       | Optional. Tags that will be applied to all resources in this module.
vpnGatewayName | Yes      | Required. The existing VPN Gateway name.
vpnSharedKeyName | Yes      | Required. VPN Shared Key Name.
keyVaultName   | Yes      | Required. The existing Azure Key Vault name.
vpnConfiguration | Yes      | Required. IP Sec VPN Configuration.
localNetworkGateways | Yes      | Required. Local Network Gateway Array output.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### vpnGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The existing VPN Gateway name.

### vpnSharedKeyName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. VPN Shared Key Name.

### keyVaultName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The existing Azure Key Vault name.

### vpnConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. IP Sec VPN Configuration.

### localNetworkGateways

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Local Network Gateway Array output.

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
