# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
parentName     | No       | Name of the existing Azure Firewall Policy.
priority       | No       | Priority for the Rule Collection Group.

### parentName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Name of the existing Azure Firewall Policy.

- Default value: `azureFirewallPolicyName`

### priority

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Priority for the Rule Collection Group.

- Default value: `0`

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
