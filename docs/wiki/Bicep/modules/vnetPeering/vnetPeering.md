# ALZ Bicep - Virtual Network Peering module

Module used to set up Virtual Network Peering between Virtual Networks

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
name           | No       | The Name of Vnet Peering resource.
destinationVirtualNetworkId | No       | Virtual Network ID of Virtual Network destination.
sourceVirtualNetworkName | No       | Name of source Virtual Network we are peering.
destinationVirtualNetworkName | No       | Name of destination virtual network we are peering.
allowVirtualNetworkAccess | No       | Switch to enable/disable Virtual Network Access for the Network Peer.
allowForwardedTraffic | No       | Switch to enable/disable forwarded traffic for the Network Peer.
allowGatewayTransit | No       | Switch to enable/disable gateway transit for the Network Peer.
useRemoteGateways | No       | Switch to enable/disable remote gateway for the Network Peer.
telemetryOptOut | No       | Set Parameter to true to Opt-out of deployment telemetry.

### name

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The Name of Vnet Peering resource.

- Default value: `[format('{0}-{1}', parameters('sourceVirtualNetworkName'), parameters('destinationVirtualNetworkName'))]`

### destinationVirtualNetworkId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Virtual Network ID of Virtual Network destination.

### sourceVirtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of source Virtual Network we are peering.

### destinationVirtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of destination virtual network we are peering.

### allowVirtualNetworkAccess

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable Virtual Network Access for the Network Peer.

- Default value: `True`

### allowForwardedTraffic

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable forwarded traffic for the Network Peer.

- Default value: `True`

### allowGatewayTransit

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable gateway transit for the Network Peer.

- Default value: `False`

### useRemoteGateways

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Switch to enable/disable remote gateway for the Network Peer.

- Default value: `False`

### telemetryOptOut

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Set Parameter to true to Opt-out of deployment telemetry.

- Default value: `False`

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
