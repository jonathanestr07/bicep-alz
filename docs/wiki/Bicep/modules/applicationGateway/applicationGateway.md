# ALZ Bicep - Azure Application Gateway module

Deploy the Azure Application Gateway Module.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
deploySelfSignedCert | Yes      | Required. Indicates whether to deploy a self-signed certificate.
location       | No       | Generated. The location where the resources will be deployed.
appGatewayName | Yes      | Required. The name of the Application Gateway.
appGatewayPublicIpName | Yes      | Required. The name of the public IP address for the Application Gateway.
keyVaultName   | Yes      | Required. The name of the Key Vault.
subscriptionId | No       | Optional. The subscription ID where the resources will be deployed.
tags           | No       | Optional. Tags that will be applied to all resources in this module.
resourceGroupNetwork | Yes      | Required. The name of the resource group for the network resources.
virtualNetworkName | Yes      | Required. The name of the virtual network.
uaiName        | Yes      | Required. The name of the user-assigned identity.
certificates   | No       | Optional. The certificates to create if deploySelfSignedCert is true and the certificates to reference in the Application Gateway.
internalServices | No       | Optional. The backend internal services for the Application Gateway.
appGatewayWAFName | Yes      | Required. The name of Web Application Firewall.
wafCustomRules | No       | Optional. The custom rules for the Web Application Firewall.
wafPolicySettings | No       | Optional. The policy settings for the Web Application Firewall.
subnetsArray   | Yes      | The subnets array.
appGatewayPrivateIpAddress | Yes      | Required. The private IP address for the Application Gateway. Must be Static for WAF v2 Skus.

### deploySelfSignedCert

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Indicates whether to deploy a self-signed certificate.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Generated. The location where the resources will be deployed.

- Default value: `[resourceGroup().location]`

### appGatewayName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The name of the Application Gateway.

### appGatewayPublicIpName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The name of the public IP address for the Application Gateway.

### keyVaultName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The name of the Key Vault.

### subscriptionId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The subscription ID where the resources will be deployed.

- Default value: `[subscription().subscriptionId]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### resourceGroupNetwork

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The name of the resource group for the network resources.

### virtualNetworkName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The name of the virtual network.

### uaiName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The name of the user-assigned identity.

### certificates

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The certificates to create if deploySelfSignedCert is true and the certificates to reference in the Application Gateway.

### internalServices

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The backend internal services for the Application Gateway.

### appGatewayWAFName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The name of Web Application Firewall.

### wafCustomRules

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The custom rules for the Web Application Firewall.

### wafPolicySettings

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The policy settings for the Web Application Firewall.

### subnetsArray

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The subnets array.

### appGatewayPrivateIpAddress

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The private IP address for the Application Gateway. Must be Static for WAF v2 Skus.

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
