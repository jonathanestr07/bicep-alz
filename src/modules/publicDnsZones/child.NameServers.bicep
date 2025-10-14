@description('Array of name server addresses for the DNS zone.')
param nsServers array

@description('The name of the DNS zone.')
param dnsZoneName string

@description('The parent zone name')
param parentDnsZoneName string

var nameServers = [
  for item in nsServers: {
    nsdname: item
  }
]

var parser = {
  nameServers: nameServers
  childPrefix: replace(dnsZoneName, '.${parentDnsZoneName}', '')
}

resource parentDnsZoneName_parser_childPrefix 'Microsoft.Network/dnszones/NS@2018-05-01' = {
  name: '${parentDnsZoneName}/${parser.childPrefix}'
  location: 'global'
  properties: {
    TTL: 3600
    NSRecords: parser.nameServers
  }
}

output computedVariable array = parser.nameServers
output NSRecordName string = parser.childPrefix
