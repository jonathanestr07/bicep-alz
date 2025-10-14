@description('An array of child DNS zones.')
param childDnsZones array = []

@description('The tags to apply to the DNS zone.')
param tags object = {
  environment: 'production'
}

@description('The name of the primary DNS zone.')
param primaryDnsZoneName string

// Create the child DNS zones
resource dnsZone 'Microsoft.Network/dnsZones@2023-07-01-preview' = [
  for (dnsZoneName, index) in childDnsZones: {
    name: '${dnsZoneName}.${primaryDnsZoneName}'
    location: 'global'
    tags: tags
    properties: {}
  }
]

// Apply the name servers to the parent DNS zone
module childDomain './child.NameServers.bicep' = [
  for (child, index) in childDnsZones: {
    name: 'nameservers-${child}-${index}'
    params: {
      nsServers: dnsZone[index].properties.nameServers
      parentDnsZoneName: primaryDnsZoneName
      dnsZoneName: child
    }
  }
]
