@description('Module to create a network settings resource for a GitHub Action Hosted vNet integrated runners.')
param networkSettingsName string

@description('The database ID of the GitHub database related to the organisation or enterprise')
param databaseId string

@description('The subnet resource ID to associate with the network settings')
param subnetResourceId string

@description('The location of the network settings resource')
param location string

@description('The tags of the network settings resource')
param tags object

resource GitHubNetworkSettings 'GitHub.Network/networkSettings@2024-04-02' = if (!empty(databaseId) && !empty(subnetResourceId)) {
  location: location
  name: networkSettingsName
  properties: {
    businessId: databaseId
    subnetId: subnetResourceId
  }
  tags: tags
}
