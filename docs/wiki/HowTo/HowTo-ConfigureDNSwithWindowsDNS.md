# How-to Guide: Configuring DNS for the platform to ensure proper DNS Resolution (Windows DNS)

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Step-by-Step Instructions](#step-by-step-instructions)
  - [Step 1: Link Private DNS Zones to Virtual Network](#step-1-link-private-dns-zones-to-virtual-network)
  - [Step 2: Deploy Windows DNS Virtual Machines](#step-2-deploy-windows-dns-virtual-machines)
  - [Step 3: Reconfigure Windows DNS in Azure](#step-3-reconfigure-windows-dns-in-azure)
  - [Step 4: Update Azure Firewall DNS Proxy Servers](#step-4-update-azure-firewall-dns-proxy-servers)
  - [Step 5: Update On-Premises DNS Servers (all other servers)](#step-5-update-on-premises-dns-servers-all-other-servers)
- [Tips and Best Practices](#tips-and-best-practices)
- [Summary](#summary)
- [FAQ](#faq)
- [References](#references)

## Introduction

This guide covers the steps to configure Azure and DNS in your environment to ensure proper DNS resolution for both Azure private and public endpoints, as well as internal DNS services. This setup is particularly relevant when you're using Windows DNS in Azure on a virtual machine, as described in the [Microsoft documentation](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver#use-a-dns-forwarder-vm).

## Prerequisites

- Ensure you have the ability to edit the code and raise the appropriate PRs to complete pipelines.
- Verify that your on-premises DNS servers can be reconfigured.
- Familiarity with Azure Firewall, DNS settings, and Azure VMs.

## Step-by-Step Instructions

### Step 1: Link Private DNS Zones to Virtual Network

- Ensure that the private DNS zones deployed are linked to the virtual network where the Windows DNS servers will be deployed. This can be achieved using one of the following methods:

  **Option 1:** Edit Platform Connectivity

  - Edit `src\configuration\platform\platformConnectivity-hub.bicepparam`
  - Set the parameter `virtualNetworkIdToLink` (`string`) to the resource ID of the virtual network that hosts the Windows DNS virtual machines.
  - Ensure the virtual network is deployed first.

  **Option 2:** Edit Azure Policy

  - Edit `src\configuration\platform\customPolicyAssignments.bicepparam`
  - Add to the parameter `virtualNetworkResourceId` (`array`) the resource ID of the virtual network that hosts the Windows DNS virtual machines.
  - Ensure that `Deploy-DNSZone-Link` is not part of the parameter `excludedPolicyAssignments`.

  > **Note**: Both options can be done together, but Option 2 is not recommended to be done without doing also Option 1 due to potential Azure Policy deployment errors. `DeployIfNotExists` is best effort at best.

**_Outcome:_** Private DNS zones are properly linked to the virtual network hosting the Windows DNS servers.

### Step 2: Deploy Windows DNS Virtual Machines

- Deploy the virtual machines that will host the Windows DNS servers in Azure. This is not part of this code repository.
- Install the Windows DNS Role on these virtual machines.

> **Note**: Active Directory Domain Services can coexist on these Windows DNS virtual machine(s) in Azure.

**_Outcome:_** Windows DNS servers are deployed and ready to manage DNS queries in Azure.

### Step 3: Reconfigure Windows DNS in Azure

- Set the forwarder on the Windows DNS servers in Azure to the Azure-provided IP, `168.63.129.16`.

> **Note**: **Do not** use conditional forwarders for Azure DNS zones for these Azure hosted virtual machines. You can of course use other non-related conditional forwarders those that are non-Azure-related.

**_Outcome:_** Windows DNS servers in Azure can resolve all private DNS zones deployed in Azure including any future zones that may be deployed. No future changes will ever be needed.

### Step 4: Update Azure Firewall DNS Proxy Servers

- Edit the Bicep parameter file located at `src\configuration\platform\azFirewallRules.bicepparam`.
- Find or add the array parameter `"servers"` and specify the Windows DNS servers you have deployed in Azure.

**_Outcome:_** Azure Firewall is configured to resolve on-premises domain records using the Windows DNS servers in Azure as well as the Private DNS Zones via the forwarders set on the Windows DNS servers in Azure.

### Step 5: Update On-Premises DNS Servers (all other servers)

> **Note**: **Never** use Active Directory integrated Conditional Forwarders. This will break DNS resolution for the Windows DNS servers hosted in Azure. Instead you **must** create the Conditional Forwarder zones on each Windows DNS server.

- On each Windows DNS server:
  - Create conditional forwarders (non-AD integrated zones) for _all_ known Azure DNS zones, even if they are not configured in Azure.
  - Set the conditional forwarders to resolve the internal `Azure Firewall IP address` for DNS queries related to Azure services.

> **Tip**: `scripts/Add-DNSConditionalForwardersforAzurePrivateDNSZones.ps1` has been created to help quickly create all the conditional forwarders on a given Windows DNS server. You can simply run this script on _all_ Windows DNS servers, except those hosted in Azure.

**_Outcome:_** On-premises DNS queries for Azure services are routed through Azure Firewall for better logging and visibility. The Azure Firewall passes that request to the Windows DNS Servers Hosted in Azure which can forward to the Azure DNS IP.

## Tips and Best Practices

- Always make these changes in the specified order to prevent DNS resolution issues.
- Ensure proper backup of DNS configurations before making changes.

## Summary

By following these steps, you will have configured Azure and DNS in your environment to ensure proper DNS resolution for Azure private and public endpoints, as well as your internal DNS services.

## FAQ

- **Q:** What if my environment doesn't use Windows DNS in Azure?

  **A:** This guide is specifically for environments using Windows DNS in Azure VMs. For other configurations, refer to the appropriate documentation by Microsoft. In principle however, the same approach would apply if you were using an alternative solution. E.g.Linux hosted DNS.

- **Q:** What about Azure Private DNS Resolver service?

  **A:** If you are using Azure Private DNS Resolver service. Please follow its appropriate documentation. This how-to guide is only for setting up DNS forwarder virtual machines up properly with the presence of an Azure Firewall.

- **Q:** Why put Azure Firewall DNS Proxy in front of Windows DNS in Azure? Why shouldn't we just allow vNet's to DNS resolve the Windows DNS Servers in Azure directly and then they forward their traffic to either Azure Firewall (which has DNS Proxy configured to Azure DNS) or the Azure DNS IP?

  **A:** Placing Azure Firewall as the first hop in your DNS topology is crucial for effective logging and traffic control. If you allow Windows DNS in Azure to be the first hop and then forward traffic to the Azure Firewall, the Firewall will only log DNS traffic from the Windows DNS servers, creating a single point of visibility. This limits your ability to track where DNS queries are originating from within your network which is super important for any DNS troubleshooting you may have to do!

  The Azure Firewall DNS Proxy allows you to control and monitor both north-south and east-west traffic flows, including DNS queries. This means you can see exactly which Azure resource is making DNS requests and to which endpoint, providing better security insights and control. It will also cache regular DNS queries to reduce load on the Windows DNS Servers in Azure meaning their SKU can be a less performant and cheaper one, saving money.

  Lastly, bypassing Azure Firewall in your DNS flow defeats the purpose of using a Firewall/Network Virtual Appliance in the first place, as it compromises visibility and control over your DNS traffic which is a critical piece of traffic you should always be controlling.

  > **Note:** The **_only_** exception to not having Azure Firewall as the first hop would be on Step 5 above which is specific to Windows DNS servers communicating directly with each other. If necessary, or required by the needs of say the organisation with child domains in a larger Active Directory forest, then allowing the Windows DNS servers (not in Azure) conditional forward directly to the Windows DNS servers (in Azure) is okay. This is because the traffic from on-premises (not Azure) might be significant enough for the Azure Firewall flood protection to kick in and block legitimate DNS requests.

## References

- [Microsoft documentation on using a DNS forwarder VM in Azure](https://learn.microsoft.com/en-us/azure/architecture/networking/architecture/azure-dns-private-resolver#use-a-dns-forwarder-vm)
