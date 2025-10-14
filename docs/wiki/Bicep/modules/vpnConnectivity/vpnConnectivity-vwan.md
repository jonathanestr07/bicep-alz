# ALZ Bicep - VPN Configuration for Azure vWAN

Module used to set up VPN Configuration for Azure vWAN

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | No       | Optional. The Azure Region to deploy the resources into.
tags           | Yes      | Optional. Tags that will be applied to all resources in this module.
vWanId         | Yes      | Required. Specifies the resource ID of the Virtual WAN where the VPN Connectivity should be created
vpnGatewayName | Yes      | Required. The VPN Gateway name.
vpnConfiguration | Yes      | Required. IP Sec VPN Configuration.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### vWanId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Specifies the resource ID of the Virtual WAN where the VPN Connectivity should be created

### vpnGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The VPN Gateway name.

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
