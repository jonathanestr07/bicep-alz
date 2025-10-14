# ALZ Bicep - Private DNS Resolver

Module used to set up the Private DNS Resolver.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | No       | Optional. The Azure Region to deploy the resources into.
tags           | No       | Optional. Tags that will be applied to all resources in this module.
virtualNetworkResourceId | Yes      | Required. The resource ID of the Virtual Network.
privateDnsResolverName | Yes      | Required. Name of Private DNS Resolver.
privateDnsResolverRulesetName | Yes      | Required. Name of Private DNS Resolver Ruleset.
forwardingRules | No       | Optional. Array of Private DNS Resolver Forwarding Rules.

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### virtualNetworkResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The resource ID of the Virtual Network.

### privateDnsResolverName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Name of Private DNS Resolver.

### privateDnsResolverRulesetName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Name of Private DNS Resolver Ruleset.

### forwardingRules

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Array of Private DNS Resolver Forwarding Rules.

## Outputs

Name | Type | Description
---- | ---- | -----------
dnsResolverId | string | The resource ID of the DNS Private Resolver.
dnsResolverName | string | The name of the DNS Private Resolver.
dnsForwardingRulesetId | string | The resource ID of the DNS Forwarding Ruleset.
dnsForwardingRulesetName | string | The name of the DNS Forwarding Ruleset.

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
