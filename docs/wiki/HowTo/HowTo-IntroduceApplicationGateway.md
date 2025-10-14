# How-to Guide: Introduce Application Gateway to the Platform Connectivity Subscription

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Step-by-Step Instructions](#step-by-step-instructions)
  - [Step 1: Implement Policy Exemptions](#step-1-implement-policy-exemptions)
  - [Step 2: Add Subnet for Application Gateway](#step-2-add-subnet-for-application-gateway)
  - [Step 3: Update Bicep Modules and Parameters](#step-3-update-bicep-modules-and-parameters)
  - [Step 4: Modify `platformConnectivity-hub.bicepparam`](#step-4-modify-platformconnectivity-hubbicepparam)
  - [Step 5: Manage Certificates and Deploy Application Gateway](#step-5-manage-certificates-and-deploy-application-gateway)
- [Tips and Best Practices](#tips-and-best-practices)

## Introduction

This guide provides steps to introduce an Application Gateway into the Platform Connectivity subscription. The process involves setting up policy exemptions, configuring necessary subnets, updating the Bicep modules, and managing certificates.

## Prerequisites

- Ensure you have the ability to edit the code and raise the appropriate PRs to complete pipelines.
- Familiarity with Bicep, Azure Policy, and Azure Application Gateway configurations.

> **Note**: Application Gateways in the Platform Connectivity Subscription is only supported when not using Azure vWAN. If you are using Azure vWAN, you must deploy the Application Gateway in its own vNet, which in that case would be better suited to live in a Subscription Vending Machine scope.

## Step-by-Step Instructions

### Step 1: Implement Policy Exemptions

- Put in place policy exemptions to prevent naming standards and blocking publicly deployed resources on the Platform Connectivity resource group that will hold the Application Gateway.
- This is necessary because the `Microsoft.Resources/deploymentScripts` require a publicly accessible storage account blob, which cannot be controlled.

**_Outcome:_** The resource group is exempt from restrictive policies, allowing the deployment of the Application Gateway and its supporting resources (Managed Identity, Web Application Firewall, Azure KeyVault).

### Step 2: Add Subnet for Application Gateway

- Edit `src\configuration\platform\platformConnectivity-hub.bicepparam`.

  > **Note**: _If this file is `-vWAN` in your repository, stop what you're doing and re-read the not above in Prerequisites_

- Add a subnet for the Application Gateway in the `subnetsArray` parameter.
- Ensure that the CIDR range is sufficient for the Application Gateway.

**_Outcome:_** A dedicated subnet is prepared for the Application Gateway deployment.

### Step 3: Update Bicep Modules and Parameters

- Edit `src\orchestration\platformConnectivity\platformConnectivity-*.bicep`.
- Add the Bicep module `src\modules\applicationGateway\applicationGateway.bicep` and surface its parameters to the `platformConnectivity-*.bicep` layer.
- Ensure that you create the resource group into which the Application Gateway will be deployed.

Example snippet configuration:

```bicep
description('Switch which allows the App Gateway to be provisioned.')
param deployAppGateway bool = true

description('Switch which allows a self-signed certificate to be created in the Key Vault for the App Gateway. Change this to false if you want to use a real certificate in its place. When false, you must upload certificate with the same secret/certificate in the Key Vault manually.')
param deploySelfSignedCert bool = true

description('Array of Certificates for the App Gateway. Certificates will also create the necessary front end listeners. Ensure the name of the certificate the certName in the internalServices object.')
param certificates array = []

description('Array of internal services for the App Gateway (backend pools and probes) with certName for linkage to the front end.')
param internalServices array = []

description('The private IP address for the App Gateway.')
param appGatewayPrivateIpAddress string

var resourceGroups = {
  network: '${argPrefix}-network'
  privateDns: '${argPrefix}-privatedns'
  appgateway: '${argPrefix}-appgateway'
}

// Module: Application Gateway
module appGateway '../../modules/applicationGateway/applicationGateway.bicep' = if (deployAppGateway) {
  scope: resourceGroup(subscriptionId, resourceGroups.appgateway)
  name: 'appGateway-${guid(deployment().name)}'
  dependsOn: [
    resourceGroupForAppGateway
  ]
  params: {
    location: location
    appGatewayName: resourceNames.appGateway
    appGatewayPublicIpName: resourceNames.appGatewayPublicIp
    keyVaultName: resourceNames.keyVault
    deploySelfSignedCert: deploySelfSignedCert
    certificates: certificates
    internalServices: internalServices
    subnetsArray: subnetsArray
    tags: tags
    subscriptionId: subscriptionId
    virtualNetworkName: resourceNames.virtualNetwork
    resourceGroupNetwork: resourceGroups.network
    uaiName: resourceNames.appGatewayUAI
    appGatewayWAFName: resourceNames.wafFirewall
    appGatewayPrivateIpAddress: appGatewayPrivateIpAddress
  }
}
```

> **Note**: The snippet above is not complete as it does not include the `var` for naming standards.

**_Outcome:_** The Application Gateway module is integrated into the platform connectivity Bicep configuration.

### Step 4: Modify `platformConnectivity-hub.bicepparam`

- Further modify `src\configuration\platform\platformConnectivity-hub.bicepparam` with the parameters now needed by `platformConnectivity-*.bicep`. I.e. Those from step 3.

**_Outcome:_** The parameter file is aligned with the platform connectivity configuration.

### Step 5: Manage Certificates and Deploy Application Gateway

- Initially, set the boolean parameter for deploying a self-signed certificate to `true` in your Bicep parameter file.
- Run the pipeline with the `true` setting to deploy the Application Gateway with a self-signed certificate(s).
- After successful deployment of the Application Gateway, change the parameter to `false` to allow the customer to replace the certificates in the Application Gateway Key Vault with their own issued certificates. _They complete this step via the Azure Portal._

> **Note**: This approach helps manage Key Vault certificates effectively, preventing Application Gateway deployment failures due to missing certificates.

**_Outcome:_** The Application Gateway is deployed with the correct certificates, allowing for customer-provided certificates to be upserted.

## Tips and Best Practices

- Ensure all policy exemptions are carefully documented and justified.
- Validate the CIDR range and subnet requirements before deployment to avoid conflict.
