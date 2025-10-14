# ALZ Bicep Module - Custom Policy Exemptions

Custom Policy Exemptions for Azure Landing Zones

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
policyExemptionName | No       | Specifies the name of the policy exemption. Maximum length is 64 characters for management group scope.
policyExemptionDisplayName | No       | The display name of the policy assignment. Maximum length is 128 characters.
policyExemptionDescription | No       | The description of the policy exemption.
policyExemptionMetadata | No       | The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.
policyExemptionCategory | No       | The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated.
policyExemptionAssignmentId | No       | The resource ID of the policy assignment that is being exempted.
policyExemptionDefinitionReferenceIds | No       | The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.
policyExemptionExpiresOn | No       | The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z.
policyExemptionAssignmentScopeValidation | No       | The option whether validate the exemption is at or under the assignment scope.
policyExemptionResourceSelectors | No       | The resource selector list to filter policies by resource properties.

### policyExemptionName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies the name of the policy exemption. Maximum length is 64 characters for management group scope.

- Default value: `policyExemptionName`

### policyExemptionDisplayName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The display name of the policy assignment. Maximum length is 128 characters.

- Default value: `policyExemptionDisplayName`

### policyExemptionDescription

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The description of the policy exemption.

- Default value: `policyExemptionDescription`

### policyExemptionMetadata

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.

### policyExemptionCategory

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The policy exemption category. Possible values are Waiver and Mitigated. Default is Mitigated.

- Default value: `Mitigated`

- Allowed values: `Mitigated`, `Waiver`

### policyExemptionAssignmentId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The resource ID of the policy assignment that is being exempted.

### policyExemptionDefinitionReferenceIds

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.

### policyExemptionExpiresOn

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. e.g. 2021-10-02T03:57:00.000Z.

### policyExemptionAssignmentScopeValidation

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The option whether validate the exemption is at or under the assignment scope.

- Allowed values: ``, `Default`, `DoNotValidate`

### policyExemptionResourceSelectors

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The resource selector list to filter policies by resource properties.

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
