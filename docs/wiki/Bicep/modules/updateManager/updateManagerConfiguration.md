# Azure template

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
maintenanceConfigName | Yes      | The name of the maintenance configuration
location       | Yes      | The location of the resource
tags           | Yes      | The tags to be applied to the resource
maintenanceWindow | No       | The maintenance window configuration
rebootSetting  | No       | The reboot setting for the maintenance configuration

### maintenanceConfigName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the maintenance configuration

### location

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The location of the resource

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The tags to be applied to the resource

### maintenanceWindow

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The maintenance window configuration

- Default value: `@{startDateTime=2024-12-06 02:00; duration=03:55; timeZone=W. Australia Standard Time; expirationDateTime=; recurEvery=1Day}`

### rebootSetting

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The reboot setting for the maintenance configuration

- Default value: `IfRequired`

- Allowed values: `IfRequired`, `Never`, `Always`, `RebootOnly`

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
