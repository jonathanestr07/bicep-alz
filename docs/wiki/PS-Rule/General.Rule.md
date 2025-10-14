# Generic Rules

A collection of generic suppression group rules that remove documented and known false-positives in the PSRule.Rules.Azure PowerShell module. For example, suppress rules around tagging of resources in Azure that don't appropriately support tagging.

## SuppressTags

Suppress tagging requirement rule for non suitable resources. This suppression group rule works to reduce the number of false-positive failures reported from PSRule.Rules.Azure for resources that should not be validated against.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressTags | SuppressionGroup | Azure.Resource.UseTags

### SuppressTags Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressTags
  description: Suppress tagging requirement rule for non suitable resources. This suppression group rule works to reduce the number of false-positive failures reported from PSRule.Rules.Azure for resources that should not be validated against.
spec:
  rule:
  - Azure.Resource.UseTags
  if:
    type: .
    in:
    - Microsoft.OperationsManagement/solutions
    - Microsoft.ManagedServices/registrationDefinitions
    - Microsoft.ManagedServices/registrationAssignments
    - Microsoft.Management/managementGroups
    - Microsoft.Resources/resourceGroups
    - Microsoft.Network/networkWatchers
    - Microsoft.PolicyInsights/remediations
    - Microsoft.KubernetesConfiguration/fluxConfigurations
    - Microsoft.KubernetesConfiguration/extensions
    - Microsoft.Sql/managedInstances
    - Microsoft.Network/privateDnsZones
    - Microsoft.Authorization/policyAssignments
    - Microsoft.Authorization/policyDefinitions
    - Microsoft.Authorization/policyExemptions
    - Microsoft.Authorization/policySetDefinitions
    - Microsoft.Authorization/locks
    - Microsoft.AAD/DomainServices/oucontainer
    - Microsoft.ApiManagement/service/eventGridFilters
    - Microsoft.EventGrid/eventSubscriptions
    - Microsoft.Automation/automationAccounts/softwareUpdateConfigurations
```

## SuppressMinimumVersion

Suppress minimum version requirement rule for non suitable resources when it comes to applying tags of KeyVault Logs. This suppression group rule works to reduce the number of false-positive failures reported from PSRule.Rules.Azure for resources that should not be validated against.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressMinimumVersion | SuppressionGroup | Azure.Resource.UseTags<br>Azure.KeyVault.Logs

### SuppressMinimumVersion Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressMinimumVersion
  description: Suppress minimum version requirement rule for non suitable resources when it comes to applying tags of KeyVault Logs. This suppression group rule works to reduce the number of false-positive failures reported from PSRule.Rules.Azure for resources that should not be validated against.
spec:
  rule:
  - Azure.Resource.UseTags
  - Azure.KeyVault.Logs
  if:
    name: .
    contains:
    - min
```

## SuppressDependency

Suppress minimum version requirement rule for non suitable resources. This suppression group rule works to reduce the number of false-positive failures reported from PSRule.Rules.Azure for resources that should not be validated against.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressDependency | SuppressionGroup |

### SuppressDependency Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressDependency
  description: Suppress minimum version requirement rule for non suitable resources. This suppression group rule works to reduce the number of false-positive failures reported from PSRule.Rules.Azure for resources that should not be validated against.
spec:
  if:
    name: .
    startsWith:
    - dep
    - ms.
    - privatelink.
```

## SuppressNSGLateralWhenBastionIncluded

Ignore NSG lateral movement rule for Azure Bastion as this is needed for Bastion to work.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
SuppressNSGLateralWhenBastionIncluded | SuppressionGroup | Azure.NSG.LateralTraversal

### SuppressNSGLateralWhenBastionIncluded Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: SuppressNSGLateralWhenBastionIncluded
  description: Ignore NSG lateral movement rule for Azure Bastion as this is needed for Bastion to work.
spec:
  rule:
  - Azure.NSG.LateralTraversal
  if:
    allOf:
    - name: .
      contains: bastion
    - type: .
      in:
      - Microsoft.Network/networkSecurityGroups
```

## ALZ.PublicIPForBastion

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
ALZ.PublicIPForBastion | SuppressionGroup | Azure.PublicIP.AvailabilityZone

### ALZ.PublicIPForBastion Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: ALZ.PublicIPForBastion
spec:
  rule:
  - Azure.PublicIP.AvailabilityZone
  if:
    allOf:
    - name: .
      contains: bastion
    - type: .
      in:
      - Microsoft.Network/publicIPAddresses
```

## ALZ.DiagLogForAutomation

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
ALZ.DiagLogForAutomation | SuppressionGroup | Azure.Automation.AuditLogs<br>Azure.Automation.PlatformLogs

### ALZ.DiagLogForAutomation Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: ALZ.DiagLogForAutomation
spec:
  rule:
  - Azure.Automation.AuditLogs
  - Azure.Automation.PlatformLogs
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Automation/automationAccounts
```

## ALZ.MinimumSample

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
ALZ.MinimumSample | SuppressionGroup | Azure.Firewall.Mode<br>Azure.VNG.VPNAvailabilityZoneSKU<br>Azure.PublicIP.AvailabilityZone<br>Azure.VNG.VPNActiveActive<br>Azure.PublicIP.StandardSKU<br>Azure.VNET.UseNSGs

### ALZ.MinimumSample Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: ALZ.MinimumSample
spec:
  rule:
  - Azure.Firewall.Mode
  - Azure.VNG.VPNAvailabilityZoneSKU
  - Azure.PublicIP.AvailabilityZone
  - Azure.VNG.VPNActiveActive
  - Azure.PublicIP.StandardSKU
  - Azure.VNET.UseNSGs
  if:
    anyOf:
    - type: .
      in:
      - Microsoft.Network/azureFirewalls
      - Microsoft.Network/publicIPAddresses
      - Microsoft.Network/virtualNetworks
      - Microsoft.Network/virtualNetworkGateways
    - source: Template
      endsWith:
      - .bicep
```
