@description('The name of the maintenance configuration')
param maintenanceConfigName string

@description('The location of the resource')
param location string

@description('The tags to be applied to the resource')
param tags object

@description('The maintenance window configuration')
param maintenanceWindow object = {
  startDateTime: '2024-12-06 02:00'
  duration: '03:55'
  timeZone: 'W. Australia Standard Time'
  expirationDateTime: null
  recurEvery: '1Day'
}

@description('The reboot setting for the maintenance configuration')
@allowed([
  'IfRequired'
  'Never'
  'Always'
  'RebootOnly'
])
param rebootSetting string = 'IfRequired'

// Resource: Azure Update Manager - Configuration Management
resource maintenanceConfig 'Microsoft.Maintenance/maintenanceConfigurations@2023-04-01' = {
  name: maintenanceConfigName
  location: location
  tags: tags
  properties: {
    maintenanceScope: 'InGuestPatch'
    installPatches: {
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
        packageNameMasksToExclude: null
        packageNameMasksToInclude: null
      }
      windowsParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
        kbNumbersToExclude: null
        kbNumbersToInclude: null
      }
      rebootSetting: rebootSetting
    }
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    maintenanceWindow: maintenanceWindow
  }
}
