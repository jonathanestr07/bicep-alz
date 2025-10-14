# ALZ Bicep - Azure vWAN Hub Virtual Network Peerings

Module used to set up peering to Virtual Networks from vWAN Hub

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
virtualWanHubResourceId | No       | Virtual WAN Hub resource Id.
remoteVirtualNetworkResourceId | No       | Remote Spoke virtual network resource Id.
virtualHubConnectionPrefix | No       | Optional Virtual Hub Connection Name Prefix.
virtualHubConnectionSuffix | No       | Optional Virtual Hub Connection Name Suffix. Example: -vhc
enableInternetSecurity | No       | Enable Internet Security for the Virtual Hub Connection.

### virtualWanHubResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Virtual WAN Hub resource Id.

### remoteVirtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Remote Spoke virtual network resource Id.

### virtualHubConnectionPrefix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional Virtual Hub Connection Name Prefix.

### virtualHubConnectionSuffix

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional Virtual Hub Connection Name Suffix. Example: -vhc

- Default value: `-vhc`

### enableInternetSecurity

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enable Internet Security for the Virtual Hub Connection.

- Default value: `False`

## Outputs

Name | Type | Description
---- | ---- | -----------
hubVirtualNetworkConnectionName | string |
hubVirtualNetworkConnectionResourceId | string |

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
