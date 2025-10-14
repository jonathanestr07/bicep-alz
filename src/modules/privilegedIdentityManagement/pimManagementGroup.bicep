targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Privileged Identity Management'
metadata description = 'Deploys a roleEligibilityScheduleRequests resource for Azure PIM with optional conditions and ticket info.'
metadata version = '1.0.0'
metadata author = 'Insight APAC Platform Engineering'

@description('Optional. Random for the deployment name.')
param deploymentSeedRandom bool = false

@description('Optional. Condition for the role eligibility schedule request (e.g. a custom expression).')
param condition string?

@description('Optional. Condition version, must be set to "2.0" if condition is used. Allowed value: "2.0"')
param conditionVersion string = '2.0'

@description('Required. Reason or note justifying the request.')
param justification string

@description('Required. Principal (user or service principal) object ID.')
param principalId string

@description('Required. Type of eligibility request.')
@allowed([
  'AdminAssign'
  'AdminExtend'
  'AdminRemove'
  'AdminRenew'
  'AdminUpdate'
  'SelfActivate'
  'SelfDeactivate'
  'SelfExtend'
  'SelfRenew'
])
param requestType string

@description('Required. ID of the role definition.')
param roleDefinitionId string

@description('Required. The ISO 8601 time duration for eligibility.')
param duration string

@description('Optional. Future date/time when eligibility ends (in ISO 8601 format).')
param endDateTime string = ''

@description('Required. Defines how eligibility ends.')
@allowed([
  'AfterDateTime'
  'AfterDuration'
  'NoExpiration'
])
param expirationType string

@description('Optional. Date/time when eligibility starts, defaults to current UTC time.')
param startDateTime string = utcNow()

@description('Optional. Resource ID of the target role eligibility schedule.')
param targetRoleEligibilityScheduleId string?

@description('Optional. Resource ID of the target role eligibility schedule instance.')
param targetRoleEligibilityScheduleInstanceId string?

@description('Optional. Ticket number for tracking.')
param ticketNumber string?

@description('Optional. Ticket system name or identifier.')
param ticketSystem string?

var endDateTimeMax = empty(endDateTime) ? dateTimeAdd(startDateTime, 'P1Y') : endDateTime

var deploymentName = deploymentSeedRandom
  ? guid(principalId, roleDefinitionId, managementGroup().id, startDateTime)
  : guid(principalId, roleDefinitionId, managementGroup().id)

resource pimConfiguration 'Microsoft.Authorization/roleEligibilityScheduleRequests@2022-04-01-preview' = {
  #disable-next-line use-stable-resource-identifiers
  name: deploymentName
  properties: {
    ...(condition != null
      ? {
          condition: condition
          conditionVersion: conditionVersion
        }
      : {})
    justification: justification
    principalId: principalId
    requestType: requestType
    roleDefinitionId: managementGroupResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    scheduleInfo: {
      expiration: {
        duration: (expirationType == 'NoExpiration' || expirationType != 'AfterDateTime' ? null : duration)
        endDateTime: (expirationType != 'NoExpiration' || expirationType != 'AfterDuration' ? endDateTimeMax : null)
        type: expirationType
      }
      startDateTime: startDateTime
    }
    targetRoleEligibilityScheduleId: targetRoleEligibilityScheduleId
    targetRoleEligibilityScheduleInstanceId: targetRoleEligibilityScheduleInstanceId
    ticketInfo: (ticketNumber != null && ticketSystem != null)
      ? {
          ...(ticketNumber != null ? { ticketNumber: ticketNumber } : {})
          ...(ticketSystem != null ? { ticketSystem: ticketSystem } : {})
        }
      : {}
  }
}
