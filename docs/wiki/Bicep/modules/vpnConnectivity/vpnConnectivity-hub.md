# ALZ Bicep - VPN Connectivity for Azure Hub

Module used to set up VPN Connectivity for Azure Hub

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | No       | Optional. The Azure Region to deploy the resources into.
tags           | No       | Optional. Tags that will be applied to all resources in this module.
vpnSharedKeySecret | Yes      | Required. Specifies a VPN shared key. The same value has to be specified on both Virtual Network Gateways.
vpnGatewayName | Yes      | Required. The VPN Gateway name.
keyVaultName   | Yes      | Required. The existing Azure Key Vault name.
localNetworkGatewayConfiguration | Yes      | Required. Local Network Gateway Configuration.
vpnConfiguration | Yes      | Required. IP Sec VPN Configuration.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### vpnSharedKeySecret

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Specifies a VPN shared key. The same value has to be specified on both Virtual Network Gateways.

### vpnGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The VPN Gateway name.

### keyVaultName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The existing Azure Key Vault name.

### localNetworkGatewayConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Local Network Gateway Configuration.

### vpnConfiguration

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. IP Sec VPN Configuration.

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
