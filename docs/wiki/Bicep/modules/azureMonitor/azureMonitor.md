# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
workspaceName  | Yes      | Specify the name of the workspace.
location       | No       | Specify the location for the workspace.
resourceGroupNamevNet | Yes      | Specify the name of the resource group where the virtual network is located.
vnetName       | Yes      | Specify the name of the virtual network.
subnetName     | Yes      | Specify the name of the subnet.
privateDnsZoneId | No       | Optional. Specify the private DNS zone ID for the private endpoint.

### workspaceName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Specify the name of the workspace.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specify the location for the workspace.

- Default value: `[resourceGroup().location]`

### resourceGroupNamevNet

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Specify the name of the resource group where the virtual network is located.

### vnetName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Specify the name of the virtual network.

### subnetName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Specify the name of the subnet.

### privateDnsZoneId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Specify the private DNS zone ID for the private endpoint.

## Outputs

Name | Type | Description
---- | ---- | -----------
workspaceId | string |

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
