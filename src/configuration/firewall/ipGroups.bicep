@export()
var ipGroupArray = [
  {
    name: 'ipg-azureSupernet'
    ipAddresses: [
      // Platform Connectivity
      '10.204.0.0/23' // Connectivity Platform vNet

      // Platform Management
      '10.204.2.0/23' // Management Platform vNet

      // Platform Identity
      '10.204.4.0/23' // Identity Platform vNet
    ]
  }

  // Platform Management Landing Zone
  {
    name: 'ipg-azurePlatformManagement'
    ipAddresses: [
      '10.204.2.0/23' // Management Platform vNet
    ]
  }

  // Platform Identity Landing Zone
  {
    name: 'ipg-azurePlatformIdentity'
    ipAddresses: [
      '10.204.4.0/23'
    ]
  }

  // Platform Connectivity Landing Zone
  {
    name: 'ipg-azurePlatformConnectivity'
    ipAddresses: [
      '10.204.0.0/23'
    ]
  }

  // Azure Bastion
  {
    name: 'ipg-azureBastion'
    ipAddresses: [
      '10.204.3.32/27'
    ]
  }


  // Platform Management JumpHosts
  {
    name: 'ipg-azurePlatMgmtJumpHost'
    ipAddresses: [
      '10.204.2.0/24'
    ]
  }

  // Platform Management LZ Central Runners for Azure DevOps/GitHub Actions
  {
    name: 'ipg-azureCentralRunners'
    ipAddresses: [
      '10.204.3.0/27'
    ]
  }

  // Azure Domain Controllers
  {
    name: 'ipg-azureADDS'
    ipAddresses: [
      '10.204.4.0/24'
    ]
  }

  // On-Premises Domain Controllers
  {
    name: 'ipg-onPremisesADDS'
    ipAddresses: [
      '10.0.0.0/24'
    ]
  }

  // Example Environment (Application Landing Zone #1)
  /*
  {
    name: 'ipg-example-edge'
    ipAddresses: [
      '10.204.18.0/24'
    ]
  }
  {
    name: 'ipg-example-authentication'
    ipAddresses: [
      '10.204.16.0/23'
    ]
  }
  {
    name: 'ipg-example-privateEndpoints'
    ipAddresses: [
      '10.204.19.128/25'
    ]
  }
  {
    // Example Environment (Application Landing Zone) All Subnets
    name: 'ipg-example-All'
    ipAddresses: [
      '10.204.18.0/24' // edge
      '10.204.16.0/23' // authentication
      '10.204.19.128/25' // privateEndpoints
    ]
  }
  */
]
