# Insight Platform Landing Zone Rules

A collection of rules and suppression group rules that support the use of the `/src/` Bicep files that have been purposefully created to be more modular in design than the Microsoft Cloud Adoption Framework (CAF) and Microsoft Well Architected Review (WAR) standards support for the Platform Landing Zone. These rules should be updated or reviewed whenever changes are made to these files.

## Insight.SuppressNSG.HubNetworking

AZR-000139: Consider configuring NSGs rules to block common outbound management traffic from non-management hosts.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.SuppressNSG.HubNetworking | SuppressionGroup | Azure.NSG.LateralTraversal

### Insight.SuppressNSG.HubNetworking Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.SuppressNSG.HubNetworking
  description: 'AZR-000139: Consider configuring NSGs rules to block common outbound management traffic from non-management hosts.'
spec:
  if:
    allOf:
    - source: Template
      endsWith:
      - hubNetworking.bicep
      - platformIdentity.bicepparam
      - platformManagement.bicepparam
  rule:
  - Azure.NSG.LateralTraversal
```

## Insight.DiagLogForAutomation.Automation

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.DiagLogForAutomation.Automation | SuppressionGroup | Azure.Automation.AuditLogs<br>Azure.Automation.PlatformLogs

### Insight.DiagLogForAutomation.Automation Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.DiagLogForAutomation.Automation
spec:
  rule:
  - Azure.Automation.AuditLogs
  - Azure.Automation.PlatformLogs
  if:
    allOf:
    - source: Template
      endsWith:
      - logging.bicep
```

## SuppressPublicIPAvailabilityZone

AZR-000157: Consider using zone-redundant Public IP addresses deployed with Standard SKU.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressPublicIPAvailabilityZone | SuppressionGroup | Azure.PublicIP.AvailabilityZone

### SuppressPublicIPAvailabilityZone Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressPublicIPAvailabilityZone
  description: 'AZR-000157: Consider using zone-redundant Public IP addresses deployed with Standard SKU.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/publicIPAddresses
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.PublicIP.AvailabilityZone
```

## SuppressNSGLateralTraversal_PublicIP

AZR-000139: Consider configuring NSGs rules to block common outbound management traffic from non-management hosts.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressNSGLateralTraversal_PublicIP | SuppressionGroup | Azure.NSG.LateralTraversal

### SuppressNSGLateralTraversal_PublicIP Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressNSGLateralTraversal_PublicIP
  description: 'AZR-000139: Consider configuring NSGs rules to block common outbound management traffic from non-management hosts.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/publicIPAddresses
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.NSG.LateralTraversal
```

## SuppressAutomationPlatformLogs

AZR-000089: Consider configuring diagnostic settings to capture platform logs from Automation accounts.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressAutomationPlatformLogs | SuppressionGroup | Azure.Automation.PlatformLogs

### SuppressAutomationPlatformLogs Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressAutomationPlatformLogs
  description: 'AZR-000089: Consider configuring diagnostic settings to capture platform logs from Automation accounts.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Automation/automationAccounts
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Automation.PlatformLogs
```

## SuppressResourceUseTagsForNSG

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard. Also consider using Azure Policy to enforce mandatory tags.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForNSG | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForNSG Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForNSG
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard. Also consider using Azure Policy to enforce mandatory tags.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/networkSecurityGroups
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForVNet

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForVNet | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForVNet Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForVNet
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/virtualNetworks
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForBastionHosts

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForBastionHosts | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForBastionHosts Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForBastionHosts
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/bastionHosts
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForVNetGateways

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForVNetGateways | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForVNetGateways Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForVNetGateways
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/virtualNetworkGateways
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForFirewallPolicies

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForFirewallPolicies | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForFirewallPolicies Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForFirewallPolicies
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/firewallPolicies
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForPublicIP

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForPublicIP | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForPublicIP Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForPublicIP
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/publicIPAddresses
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForAzureFirewalls

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForAzureFirewalls | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForAzureFirewalls Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForAzureFirewalls
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/azureFirewalls
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForRouteTables

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForRouteTables | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForRouteTables Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForRouteTables
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/routeTables
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForLocalNetworkGateways

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForLocalNetworkGateways | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForLocalNetworkGateways Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForLocalNetworkGateways
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/localNetworkGateways
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForNetworkConnections

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForNetworkConnections | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForNetworkConnections Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForNetworkConnections
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/connections
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForNetworkWatchers

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForNetworkWatchers | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForNetworkWatchers Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForNetworkWatchers
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/networkWatchers
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForResourceGroups

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForResourceGroups | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForResourceGroups Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForResourceGroups
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Resources/resourceGroups
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressDeploymentAdminUsername

Ref AZR-000284: Sensitive properties should be passed as parameters. Avoid using deterministic values for sensitive properties.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressDeploymentAdminUsername | SuppressionGroup | Azure.Deployment.AdminUsername

### SuppressDeploymentAdminUsername Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressDeploymentAdminUsername
  description: 'Ref AZR-000284: Sensitive properties should be passed as parameters. Avoid using deterministic values for sensitive properties.'
spec:
  if:
    allOf:
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Deployment.AdminUsername
```

## SuppressResourceUseTagsForDeployments

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForDeployments | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForDeployments Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForDeployments
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressResourceUseTagsForWAFAligned

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForWAFAligned | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForWAFAligned Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForWAFAligned
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard.'
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Resources/resourceGroups
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Resource.UseTags
```

## SuppressDeploymentAdminUsernameWAFAligned

Ref AZR-000284: Sensitive properties should be passed as parameters. Avoid using deterministic values for sensitive properties.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressDeploymentAdminUsernameWAFAligned | SuppressionGroup | Azure.Deployment.AdminUsername

### SuppressDeploymentAdminUsernameWAFAligned Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressDeploymentAdminUsernameWAFAligned
  description: 'Ref AZR-000284: Sensitive properties should be passed as parameters. Avoid using deterministic values for sensitive properties.'
spec:
  if:
    allOf:
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Deployment.AdminUsername
```

## SuppressPolicyAssignmentAssignedBy

Azure Policy AssignmentAssignedBy not used in the platform deployment.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressPolicyAssignmentAssignedBy | SuppressionGroup | Azure.Policy.AssignmentAssignedBy

### SuppressPolicyAssignmentAssignedBy Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressPolicyAssignmentAssignedBy
  description: Azure Policy AssignmentAssignedBy not used in the platform deployment.
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Authorization/policyAssignments
    - source: Template
      withinPath:
      - src/modules
  rule:
  - Azure.Policy.AssignmentAssignedBy
```

## SuppressAzureVmAmaForVirtualMachines

Deployment of Azure Monitor Agent (AMA) is managed through Azure Policy.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressAzureVmAmaForVirtualMachines | SuppressionGroup | Azure.VM.AMA

### SuppressAzureVmAmaForVirtualMachines Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressAzureVmAmaForVirtualMachines
  description: Deployment of Azure Monitor Agent (AMA) is managed through Azure Policy.
spec:
  rule:
  - Azure.VM.AMA
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Compute/virtualMachines
```

## SuppressAzureVmMaintenanceConfigForVirtualMachines

The maintenance configuration is managed through either Azure Update Manager or other tools.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressAzureVmMaintenanceConfigForVirtualMachines | SuppressionGroup | Azure.VM.MaintenanceConfig

### SuppressAzureVmMaintenanceConfigForVirtualMachines Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressAzureVmMaintenanceConfigForVirtualMachines
  description: The maintenance configuration is managed through either Azure Update Manager or other tools.
spec:
  rule:
  - Azure.VM.MaintenanceConfig
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Compute/virtualMachines
```

## SuppressResourceUseTagsForSecurityInsights

Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard. Also consider using Azure Policy to enforce mandatory tags

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceUseTagsForSecurityInsights | SuppressionGroup | Azure.Resource.UseTags

### SuppressResourceUseTagsForSecurityInsights Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceUseTagsForSecurityInsights
  description: 'Ref AZR-000166: Consider tagging resources using a standard convention. Identify mandatory and optional tags then tag all resources and resource groups using this standard. Also consider using Azure Policy to enforce mandatory tags'
spec:
  rule:
  - Azure.Resource.UseTags
  if:
    allOf:
    - type: .
      in:
      - Microsoft.SecurityInsights/onboardingStates
```

## SuppressResourceAzureVNETSubnetNaming

Virtual Network subnets names will be derived based on the CAF Naming standards.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceAzureVNETSubnetNaming | SuppressionGroup | Azure.VNET.SubnetNaming

### SuppressResourceAzureVNETSubnetNaming Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceAzureVNETSubnetNaming
  description: Virtual Network subnets names will be derived based on the CAF Naming standards.
spec:
  rule:
  - Azure.VNET.SubnetNaming
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/virtualNetworks
    - field: properties.subnets[*]
      anyOf:
      - field: name
        hasValue: true
```

## SuppressResourceAzureKeyVaultFirewall

Azure Key Vault network policies will be imposed through Azure Policy and will be denied by default.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceAzureKeyVaultFirewall | SuppressionGroup | Azure.KeyVault.Firewall

### SuppressResourceAzureKeyVaultFirewall Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceAzureKeyVaultFirewall
  description: Azure Key Vault network policies will be imposed through Azure Policy and will be denied by default.
spec:
  rule:
  - Azure.KeyVault.Firewall
  if:
    allOf:
    - type: .
      in:
      - Microsoft.KeyVault/vaults
```

## SuppressAzureVmDiskCachingForVirtualMachines

Disk caching is configured correctly at the workload.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressAzureVmDiskCachingForVirtualMachines | SuppressionGroup | Azure.VM.DiskCaching

### SuppressAzureVmDiskCachingForVirtualMachines Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressAzureVmDiskCachingForVirtualMachines
  description: Disk caching is configured correctly at the workload.
spec:
  rule:
  - Azure.VM.DiskCaching
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Compute/virtualMachines
```

## SuppressResourceAzureVNETSingleDNS

Platform Virtual Networks will be pointed to the Azure Firewall Private IP which addresses redundancy

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceAzureVNETSingleDNS | SuppressionGroup | Azure.VNET.SingleDNS

### SuppressResourceAzureVNETSingleDNS Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceAzureVNETSingleDNS
  description: Platform Virtual Networks will be pointed to the Azure Firewall Private IP which addresses redundancy
spec:
  rule:
  - Azure.VNET.SingleDNS
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/virtualNetworks
    - field: properties.dhcpOptions
      anyOf:
      - field: dnsServers
        hasValue: true
```

## SuppressResourceAzureKeyVaultRBAC

Azure Key Vault RBAC permission model will not be used by Azure Firewall to manage access to the Key Vault due to Firewall limitation.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceAzureKeyVaultRBAC | SuppressionGroup | Azure.KeyVault.RBAC

### SuppressResourceAzureKeyVaultRBAC Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceAzureKeyVaultRBAC
  description: Azure Key Vault RBAC permission model will not be used by Azure Firewall to manage access to the Key Vault due to Firewall limitation.
spec:
  if:
    allOf:
    - type: .
      in:
      - Microsoft.KeyVault/vaults
    - field: tags.Purpose
      equals: TLS Certificate reference for Azure Firewall Policy
  rule:
  - Azure.KeyVault.RBAC
```

## SuppressResourceAzurePrivateSubnet

Virtual Networks will be allow subnet outbound access by default as they are controlled by the centralised Azure Firewall.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressResourceAzurePrivateSubnet | SuppressionGroup | Azure.VNET.PrivateSubnet

### SuppressResourceAzurePrivateSubnet Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressResourceAzurePrivateSubnet
  description: Virtual Networks will be allow subnet outbound access by default as they are controlled by the centralised Azure Firewall.
spec:
  rule:
  - Azure.VNET.PrivateSubnet
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/virtualNetworks
```

## SuppressAzureLogReplicationForPlatformManagement

Platform Management Log Analytics workspace is not replicated to a secondary region as part of the platform design.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressAzureLogReplicationForPlatformManagement | SuppressionGroup | Azure.Log.Replication

### SuppressAzureLogReplicationForPlatformManagement Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressAzureLogReplicationForPlatformManagement
  description: Platform Management Log Analytics workspace is not replicated to a secondary region as part of the platform design.
spec:
  rule:
  - Azure.Log.Replication
  if:
    allOf:
    - type: .
      in:
      - Microsoft.OperationalInsights/workspaces
    - source: Template
      withinPath:
      - src/modules/platformManagement.bicep
```

## SuppressAzureLogReplicationForPlatformManagementParameter

Platform Management Log Analytics workspace is not replicated to a secondary region as part of the platform design.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressAzureLogReplicationForPlatformManagementParameter | SuppressionGroup | Azure.Log.Replication

### SuppressAzureLogReplicationForPlatformManagementParameter Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressAzureLogReplicationForPlatformManagementParameter
  description: Platform Management Log Analytics workspace is not replicated to a secondary region as part of the platform design.
spec:
  rule:
  - Azure.Log.Replication
  if:
    allOf:
    - type: .
      in:
      - Microsoft.OperationalInsights/workspaces
    - source: Parameter
      withinPath:
      - src/configuration/platform
```

## SuppressAzureVirtualNetworkGatewayMaintenanceConfig

Platform Management does not contain Virtual Network Gateway Maintenance Configurations as part of the platform design.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressAzureVirtualNetworkGatewayMaintenanceConfig | SuppressionGroup | Azure.VNG.MaintenanceConfig

### SuppressAzureVirtualNetworkGatewayMaintenanceConfig Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressAzureVirtualNetworkGatewayMaintenanceConfig
  description: Platform Management does not contain Virtual Network Gateway Maintenance Configurations as part of the platform design.
spec:
  rule:
  - Azure.VNG.MaintenanceConfig
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/virtualNetworkGateways
```
