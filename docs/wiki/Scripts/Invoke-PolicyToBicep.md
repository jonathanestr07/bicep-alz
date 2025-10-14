# Invoke-PolicyToBicep.ps1

Outputs necessary details for authoring policy definitions and set definitions in a Bicep format.

## Script

```powershell
./scripts/Invoke-PolicyToBicep.ps1
```

## Description

This script generates .txt files that detail the names and paths of policy definitions and set definitions. It supports creating parameter files for each policy set definition. The script is useful for auditing changes in policies as it also outputs the number of policy and policy set definition files, aiding the review process in pull requests.

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
rootPath | ./src/modules/policy | Specifies the root path where module source files are located. Default is "./src/modules/policy".
definitionsRoot | definitions   | Specifies the subdirectory under rootPath where definitions are stored. Default is "definitions".
lineEnding | unix          | Specifies the type of line ending to use in output files. Default is "unix".
definitionsPath | lib/policy_definitions | Specifies the path where policy definitions are stored, relative to definitionsRoot. Default is "lib/policy_definitions".
definitionsLongPath | "$definitionsRoot/$definitionsPath" | _Not provided_
definitionsSetPath | lib/policy_set_definitions | Specifies the path where policy set definitions are stored, relative to definitionsRoot. Default is "lib/policy_set_definitions".
definitionsSetLongPath | "$definitionsRoot/$definitionsSetPath" | _Not provided_
assignmentsRoot | assignments   | Specifies the subdirectory under rootPath where assignments are stored. Default is "assignments".
assignmentsPath | lib/policy_assignments | Specifies the path where policy assignments are stored, relative to assignmentsRoot. Default is "lib/policy_assignments".
assignmentsLongPath | "$assignmentsRoot/$assignmentsPath" | _Not provided_
defintionsTxtFileName | _policyDefinitionsBicepInput.txt | Specifies the filename for policy definitions output. Default is "_policyDefinitionsBicepInput.txt".
defintionsSetTxtFileName | _policySetDefinitionsBicepInput.txt | Specifies the filename for policy set definitions output. Default is "_policySetDefinitionsBicepInput.txt".
assignmentsTxtFileName | _policyAssignmentsBicepInput.txt | Specifies the filename for policy assignments output. Default is "_policyAssignmentsBicepInput.txt".
WhatIf | _null_        | _Not provided_
Confirm | _null_        | _Not provided_
