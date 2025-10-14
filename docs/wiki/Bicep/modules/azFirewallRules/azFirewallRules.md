# ALZ Bicep - Azure Firewall Policy module

Deploy the Azure Firewall Policy Module.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
azFirewallPolicyName | Yes      | Required. Name of the existing Azure Firewall Policy.
azFirewallPolicyDeployment | No       | Optional. Switch which allows Azure Firewall Policy to be provisioned.
location       | No       | Generated. The Azure Region to deploy the resources into.
tags           | No       | Optional. Tags that will be applied to all resources in this module.
basePolicyResourceId | No       | Optional. Resource ID of the base Azure Firewall policy.
enableProxy    | No       | Optional. Enable DNS Proxy on Firewalls attached to the Firewall Policy.
servers        | No       | Optional. List of Custom DNS Servers.
insightsIsEnabled | No       | Optional. A flag to indicate if the insights are enabled on the policy.
defaultWorkspaceResourceId | No       | Optional. Default Log Analytics Resource ID for Firewall Policy Insights.
retentionDays  | No       | Optional. Number of days the insights should be enabled on the policy.
bypassTrafficSettings | No       | Optional. List of rules for traffic to bypass.
signatureOverrides | No       | Optional. List of specific signatures states.
mode           | No       | Optional. The configuring of intrusion detection.
tier           | No       | Optional. Tier of Firewall Policy.
privateRanges  | No       | Optional. List of private IP addresses/IP address ranges to not be SNAT.
autoLearnPrivateRanges | No       | Optional. The operation mode for automatically learning private ranges to not be SNAT.
threatIntelMode | No       | Optional. The operation mode for Threat Intelligence.
fqdns          | No       | Optional. List of FQDNs for the ThreatIntel Allowlist.
ipAddresses    | No       | Optional. List of IP addresses for the ThreatIntel Allowlist.
keyVaultSecretResourceId | No       | Optional. Secret ID of (base-64 encoded unencrypted PFX) Secret or Certificate object stored in KeyVault.
certificateName | No       | Optional. Name of the CA certificate.
ipGroupDeployment | No       | Optional. Switch which allows Azure Bastion deployment to be provisioned.
managedIdentities | Yes      | Optional. The managed identity definition for this resource.

### azFirewallPolicyName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Name of the existing Azure Firewall Policy.

### azFirewallPolicyDeployment

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which allows Azure Firewall Policy to be provisioned.

- Default value: `True`

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Generated. The Azure Region to deploy the resources into.

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags that will be applied to all resources in this module.

### basePolicyResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Resource ID of the base Azure Firewall policy.

### enableProxy

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Enable DNS Proxy on Firewalls attached to the Firewall Policy.

- Default value: `True`

### servers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. List of Custom DNS Servers.

### insightsIsEnabled

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. A flag to indicate if the insights are enabled on the policy.

- Default value: `False`

### defaultWorkspaceResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Default Log Analytics Resource ID for Firewall Policy Insights.

### retentionDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Number of days the insights should be enabled on the policy.

- Default value: `90`

### bypassTrafficSettings

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. List of rules for traffic to bypass.

### signatureOverrides

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. List of specific signatures states.

### mode

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The configuring of intrusion detection.

- Default value: `Off`

- Allowed values: `Alert`, `Deny`, `Off`

### tier

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tier of Firewall Policy.

- Default value: `Standard`

- Allowed values: `Premium`, `Standard`, `Basic`

### privateRanges

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. List of private IP addresses/IP address ranges to not be SNAT.

### autoLearnPrivateRanges

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The operation mode for automatically learning private ranges to not be SNAT.

- Default value: `Enabled`

- Allowed values: `Disabled`, `Enabled`

### threatIntelMode

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The operation mode for Threat Intelligence.

- Default value: `Deny`

- Allowed values: `Alert`, `Deny`, `Off`

### fqdns

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. List of FQDNs for the ThreatIntel Allowlist.

### ipAddresses

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. List of IP addresses for the ThreatIntel Allowlist.

### keyVaultSecretResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Secret ID of (base-64 encoded unencrypted PFX) Secret or Certificate object stored in KeyVault.

### certificateName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Name of the CA certificate.

### ipGroupDeployment

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Switch which allows Azure Bastion deployment to be provisioned.

- Default value: `False`

### managedIdentities

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Optional. The managed identity definition for this resource.

## Outputs

Name | Type | Description
---- | ---- | -----------
userAssignedIdentityName | string | The name of the User Assigned Identity.
userAssignedIdentityId | string | The ID of the User Assigned Identity.
ipGroups | array | Array of IP Groups.
firewallPolicyName | string | The name of the Azure Firewall Policy.
firewallPolicyId | string | The ID of the Azure Firewall Policy.

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
