metadata name = 'ALZ Bicep - MS Defender EASM Module'
metadata description = 'ALZ Bicep Module used to set up EASM'
metadata version = '1.0.0'
metadata author = 'Insight Platform Engineering'

@description('The location of the resource group')
param location string

@description('The name of the Defender EASM instance')
param instanceName string

@description('The tags to apply to the Defender EASM instance')
param tags object = {}

resource defenderEASM 'Microsoft.Easm/workspaces@2023-04-01-preview' = {
  name: instanceName
  location: location
  tags: tags
  properties: {}
}

output defenderEASMName string = defenderEASM.name
