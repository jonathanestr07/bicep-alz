# New-AzRoleAssignment.ps1

Assign the Service Principal that will be used for the Azure Landing Zone deployment to the root scope.

## Script

```powershell
./scripts/New-AzRoleAssignment.ps1
```

## Parameters

Name | Default Value | Description
---- | ------------- | -----------
objectId | _null_        | The ObjectId of the Service Principal that will be used for the assignment.
roleDefinitionName | owner         | The role Definition for the assignment, this should be owner.
scope | /             | The scope in which the assignment is assigned, this is '/'
