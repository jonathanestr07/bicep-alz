# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
virtualMachines | No       | Array of virtual machine configurations
location       | No       | Location for the resources
tags           | No       | Tags to be applied to the resources
adminUsername  | No       | Administrator username for the virtual machines
keyVaultName   | No       | Name of the Key Vault containing the secret for the admin password
secretName     | No       | Name of the secret in the Key Vault for the admin password
virtualMachineName | No       | Base name for the virtual machines
virtualNetworkName | No       | Name of the virtual network
subnetName     | No       | Name of the subnet within the virtual network
resourceGroupNamevNet | No       | Name of the resource group containing the virtual network
enableAutomaticUpdates | No       | Enable automatic updates on the virtual machines

### virtualMachines

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Array of virtual machine configurations

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Location for the resources

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Tags to be applied to the resources

- Default value: `[resourceGroup().tags]`

### adminUsername

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Administrator username for the virtual machines

- Default value: `adminuser`

### keyVaultName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the Key Vault containing the secret for the admin password

- Default value: `keyvault`

### secretName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the secret in the Key Vault for the admin password

- Default value: `adminpassword`

### virtualMachineName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Base name for the virtual machines

- Default value: `vm`

### virtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the virtual network

- Default value: `vnet`

### subnetName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the subnet within the virtual network

- Default value: `subnet`

### resourceGroupNamevNet

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the resource group containing the virtual network

- Default value: `vnet`

### enableAutomaticUpdates

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Enable automatic updates on the virtual machines

- Default value: `True`

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
