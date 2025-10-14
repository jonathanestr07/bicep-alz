# Insight Rules

A collection of rules and suppression group rules that support the use of the `/src/` Bicep files that have been purposefully created to be more modular in design then the Microsoft Cloud Adoption Framework (CAF) and Microsoft Well Architected Review (WAR) standards support. These rules should be updated or reviewed whenever changes are made to these files.

## Insight.Storage.DataReplication.Ignore

Suppress rules for data replication using Globally Redundant Storage (GRS) for data residency reasons. E.g. Avoid data being securely replicated outside of Australia.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.Storage.DataReplication.Ignore | SuppressionGroup | Azure.Storage.UseReplication

### Insight.Storage.DataReplication.Ignore Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.Storage.DataReplication.Ignore
  description: Suppress rules for data replication using Globally Redundant Storage (GRS) for data residency reasons. E.g. Avoid data being securely replicated outside of Australia.
spec:
  rule:
  - Azure.Storage.UseReplication
  if:
    type: .
    in:
    - Microsoft.Storage/storageAccounts
```

## Insight.Redis.Firewall.Ignore

Suppress rule for redis.bicep missing /firewallRules properties as it is captured in redis.FirewallRule.Add.bicep

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.Redis.Firewall.Ignore | SuppressionGroup | Azure.Redis.FirewallIPRange<br>Azure.Redis.FirewallRuleCount

### Insight.Redis.Firewall.Ignore Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.Redis.Firewall.Ignore
  description: Suppress rule for redis.bicep missing /firewallRules properties as it is captured in redis.FirewallRule.Add.bicep
spec:
  rule:
  - Azure.Redis.FirewallIPRange
  - Azure.Redis.FirewallRuleCount
  if:
    type: .
    in:
    - Microsoft.Cache/Redis
```

## Insight.Redis.MinSKU.Ignore

Suppress rule for redis.bicep minimum sku to support C0 workloads

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.Redis.MinSKU.Ignore | SuppressionGroup | Azure.Redis.MinSKU

### Insight.Redis.MinSKU.Ignore Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.Redis.MinSKU.Ignore
  description: Suppress rule for redis.bicep minimum sku to support C0 workloads
spec:
  rule:
  - Azure.Redis.MinSKU
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Cache/Redis
    - field: Properties.sku.capacity
      equals: "0"
```

## Insight.AppServices.PlanInstanceCount.Ignore

Suppress rule for number of App Service counts to keep costs down and support single app service design. Note, unplanned Azure outages will take the app service down.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.AppServices.PlanInstanceCount.Ignore | SuppressionGroup | Azure.AppService.PlanInstanceCount

### Insight.AppServices.PlanInstanceCount.Ignore Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.AppServices.PlanInstanceCount.Ignore
  description: Suppress rule for number of App Service counts to keep costs down and support single app service design. Note, unplanned Azure outages will take the app service down.
spec:
  rule:
  - Azure.AppService.PlanInstanceCount
  if:
    type: .
    in:
    - Microsoft.Web/sites
    - Microsoft.Web/serverfarms
```

## Insight.KeyVault.Outputs.SecretsURI.Ignore

Suppress rule to allow outputting KeyVault URI and URI with version to support reference in other bicep modules/files

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.KeyVault.Outputs.SecretsURI.Ignore | SuppressionGroup | Azure.Deployment.OutputSecretValue

### Insight.KeyVault.Outputs.SecretsURI.Ignore Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.KeyVault.Outputs.SecretsURI.Ignore
  description: Suppress rule to allow outputting KeyVault URI and URI with version to support reference in other bicep modules/files
spec:
  rule:
  - Azure.Deployment.OutputSecretValue
  if:
    allOf:
    - field: properties.template.outputs.secretUri
      exists: true
    - field: properties.template.outputs.secretUriWithVersion
      exists: true
    - type: .
      in:
      - Microsoft.Resources/deployments
      - Microsoft.KeyVault/vaults
```

## Insight.AppService.CodeVersions.Ignore

Ignore requirement for hardcoded settings PHP or .NET version in Bicep. Our Bicep files support multiple different configuration type for Microsoft.Web/site resource provider, as it is created dynamically via conditional statements.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.AppService.CodeVersions.Ignore | SuppressionGroup | Azure.AppService.NETVersion<br>Azure.AppService.PHPVersion

### Insight.AppService.CodeVersions.Ignore Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.AppService.CodeVersions.Ignore
  description: Ignore requirement for hardcoded settings PHP or .NET version in Bicep. Our Bicep files support multiple different configuration type for Microsoft.Web/site resource provider, as it is created dynamically via conditional statements.
spec:
  rule:
  - Azure.AppService.NETVersion
  - Azure.AppService.PHPVersion
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Web/sites
    - field: Properties.siteConfig.netFrameworkVersion
      equals: ""
    - field: Properties.siteConfig.phpVersion
      equals: ""
```

## Insight.PublicIP.ZoneAvailability.Ignore

Ignore Public IP zone availability as not all Azure regions support availability zones at this time. Note this may result in single datacentre outages in Azure and ideally should be configured in regions that do support it. Unfortunately PSRule.Rules.Azure has no way to specifically check a particular region at this time.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.PublicIP.ZoneAvailability.Ignore | SuppressionGroup | Azure.PublicIP.AvailabilityZone

### Insight.PublicIP.ZoneAvailability.Ignore Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.PublicIP.ZoneAvailability.Ignore
  description: Ignore Public IP zone availability as not all Azure regions support availability zones at this time. Note this may result in single datacentre outages in Azure and ideally should be configured in regions that do support it. Unfortunately PSRule.Rules.Azure has no way to specifically check a particular region at this time.
spec:
  rule:
  - Azure.PublicIP.AvailabilityZone
  if:
    type: .
    in:
    - Microsoft.Network/publicIPAddresses
```

## Insight.NetworkSecurityGroup.LateralTraversal.Ignore

Ignore Network Security Group traversal rule as security rules in this template are dynamically created in array loop.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.NetworkSecurityGroup.LateralTraversal.Ignore | SuppressionGroup | Azure.NSG.LateralTraversal

### Insight.NetworkSecurityGroup.LateralTraversal.Ignore Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.NetworkSecurityGroup.LateralTraversal.Ignore
  description: Ignore Network Security Group traversal rule as security rules in this template are dynamically created in array loop.
spec:
  rule:
  - Azure.NSG.LateralTraversal
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Network/networkSecurityGroups
```

## Insight.AppInsights.WorkspaceId.Ignore

Ignore App Insights workspaceId missing as a condition is configured in our Bicep files to apply the workspaceId if only the Log Analytics workspace exists.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.AppInsights.WorkspaceId.Ignore | SuppressionGroup | Azure.AppInsights.Workspace

### Insight.AppInsights.WorkspaceId.Ignore Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.AppInsights.WorkspaceId.Ignore
  description: Ignore App Insights workspaceId missing as a condition is configured in our Bicep files to apply the workspaceId if only the Log Analytics workspace exists.
spec:
  rule:
  - Azure.AppInsights.Workspace
  if:
    allOf:
    - type: .
      in:
      - Microsoft.Insights/components
```

## Insight.KeyVault.Auditing.Ignore

Ignore PSRule.Azure audit logs on Azure KeyVault as a condition in the Bicep template is used to deploy if Log Analytic workspace exists.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.KeyVault.Auditing.Ignore | SuppressionGroup | Azure.KeyVault.Logs

### Insight.KeyVault.Auditing.Ignore Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.KeyVault.Auditing.Ignore
  description: Ignore PSRule.Azure audit logs on Azure KeyVault as a condition in the Bicep template is used to deploy if Log Analytic workspace exists.
spec:
  rule:
  - Azure.KeyVault.Logs
  if:
    type: .
    in:
    - Microsoft.KeyVault/vaults
```

## Insight.apiManagement.Ciphers.IfConsumption.Ignore

Suppress rule regarding Ciphers for Azure API Management when using the consumption SKU as they cannot be changed.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.apiManagement.Ciphers.IfConsumption.Ignore | SuppressionGroup | Azure.APIM.Ciphers

### Insight.apiManagement.Ciphers.IfConsumption.Ignore Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.apiManagement.Ciphers.IfConsumption.Ignore
  description: Suppress rule regarding Ciphers for Azure API Management when using the consumption SKU as they cannot be changed.
spec:
  rule:
  - Azure.APIM.Ciphers
  if:
    allOf:
    - type: .
      in:
      - Microsoft.ApiManagement/service
    - field: sku.name
      equals: Consumption
```

## Insight.apiManagement.MultiLineValidation.Skip

> [!WARNING]
> This rule will expire on 2025-01-01. This rule must be re-evaluated, with human intervention, for suitability in this solution as the rule has likely been superseded. Refer to any Azure and PSRule.Rules.Azure documentation for any changes that may have occurred.

Suppress rule regarding CORSPolicy and PolicyBase for Azure API Management as PSRule.Rules.Azure cannot support multi-line strings at this time. This rule will expire on 1 January 2025 where ideally PSRule.Rules.Azure supports multiline validation. Please check the documentation from PSRule.Rules.Azure to confirm.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules | Link
--------- | ---- | ----- | ----
Insight.apiManagement.MultiLineValidation.Skip | SuppressionGroup | Azure.APIM.CORSPolicy<br>Azure.APIM.PolicyBase | https://azure.github.io/PSRule.Rules.Azure/expanding-source-files/#limitations

### Insight.apiManagement.MultiLineValidation.Skip Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.apiManagement.MultiLineValidation.Skip
  description: Suppress rule regarding CORSPolicy and PolicyBase for Azure API Management as PSRule.Rules.Azure cannot support multi-line strings at this time. This rule will expire on 1 January 2025 where ideally PSRule.Rules.Azure supports multiline validation. Please check the documentation from PSRule.Rules.Azure to confirm.
  link: https://azure.github.io/PSRule.Rules.Azure/expanding-source-files/#limitations
spec:
  expiresOn: 2025-01-01T00:00:00Z
  rule:
  - Azure.APIM.CORSPolicy
  - Azure.APIM.PolicyBase
  if:
    allOf:
    - type: .
      in:
      - Microsoft.ApiManagement/service
```

## Insight.apiManagement.AvailabilityZone

Suppress rule regarding API management services deployed with Premium SKU should use availability zones in supported regions for high availability. Suppressed to save on cost as using additional geographic locations for high availability.

> [!NOTE]
> This custom rule suppresses default rules from PSRule.Rules.Azure.

Rule Name | Kind | Rules
--------- | ---- | -----
Insight.apiManagement.AvailabilityZone | SuppressionGroup | Azure.APIM.AvailabilityZone

### Insight.apiManagement.AvailabilityZone Code Snippet

The following is the extracted rule from the YAML file:

```yaml
apiVersion: github.com/microsoft/PSRule/v1
kind: SuppressionGroup
metadata:
  name: Insight.apiManagement.AvailabilityZone
  description: Suppress rule regarding API management services deployed with Premium SKU should use availability zones in supported regions for high availability. Suppressed to save on cost as using additional geographic locations for high availability.
spec:
  rule:
  - Azure.APIM.AvailabilityZone
  if:
    allOf:
    - type: .
      in:
      - Microsoft.ApiManagement/service
```
