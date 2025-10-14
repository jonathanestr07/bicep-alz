# Private DNS Zones

- [Private DNS Zones](#private-dns-zones)
  - [Private DNS Zones Overview](#private-dns-zones-overview)
    - [Azure Private DNS](#azure-private-dns)
    - [Azure Private Links](#azure-private-links)
    - [Private Endpoints](#private-endpoints)
  - [Private DNS Zones Design Decisions](#private-dns-zones-design-decisions)
  - [Private DNS Zones Design](#private-dns-zones-design)
  - [Platform Connectivity Subscription: Private DNS Zones](#platform-connectivity-subscription-private-dns-zones)

## Private DNS Zones Overview

### Azure Private DNS

Azure Private DNS provides a reliable and secure DNS service for your virtual network. Azure Private DNS manages and resolves domain names in the virtual network without the need to configure a custom DNS solution. By using private DNS zones, you can use your own custom domain name instead of the Azure-provided names during deployment. Using a custom domain name helps you tailor your virtual network architecture to best suit your organization's needs. It provides a naming resolution for virtual machines (VMs) within a virtual network and connected virtual networks. Additionally, you can configure zones names with a split-horizon view, which allows a private and a public DNS zone to share the name.

To resolve the records of a private DNS zone from your virtual network, you must link the virtual network with the zone. Linked virtual networks have full access and can resolve all DNS records published in the private zone. You can also enable auto-registration on a virtual network link. When you enable auto-registration on a virtual network link, the DNS records for the virtual machines in that virtual network are registered in the private zone. When auto-registration gets enabled, Azure DNS will update the zone record whenever a virtual machine gets created, changes its IP address, or gets deleted.

| **Feature Reference**                                                                         |
| --------------------------------------------------------------------------------------------- |
| [Azure Private DNS Overview](https://docs.microsoft.com/en-us/azure/dns/private-dns-overview) |

### Azure Private Links

Azure Private Link is a networking technology that enables applications running on-premises or in the cloud to access a [list](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview#availability) of Azure services (for example, Storage Account or and SQL Database) and Azure hosted customer-owned/partner services over a [private
endpoint](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview) defined in a virtual network. When you\'re connecting to a private link resource using its fully qualified domain name (FQDN) as part of the connection string, it's important to correctly configure your DNS settings to resolve the FQDN to the allocated private IP address. For more information on this, see [Azure Private Endpoint DNS configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns). Traffic between the virtual network and the service travels the Microsoft backbone network.

Azure Private Link provides the following benefits:

- **Privately access services on the Azure platform**: Connect your virtual network to services in Azure without a public IP address at the source or destination. Service providers can render their services in their own virtual network and consumers can access those services in their local virtual network. The Private Link platform will handle the connectivity between the consumer and services over the Azure backbone network.
- **On-premises and peered networks**: Access services running in Azure from on-premises over ExpressRoute private peering, VPN tunnels, and peered virtual networks using private endpoints. There\'s no need to set up public peering or traverse the internet to reach the service. Private Link provides a secure way to migrate workloads to Azure.
- **Protection against data leakage**: A private endpoint is mapped to an instance of a PaaS resource instead of the entire service. Consumers can only connect to the specific resource. Access to any other resource in the service is blocked. This mechanism provides protection against data leakage risks.
- **Global reach**: Connect privately to services running in other regions. The consumer\'s virtual network could be in region A and it can connect to services behind Private Link in region B.
- **Extend to your own services**: Enable the same experience and functionality to render your service privately to consumers in Azure. By placing your service behind a standard Azure Load Balancer, you can enable it for Private Link. The consumer can then connect directly to your service using a private endpoint in their own virtual network. You can manage the connection requests using an approval call flow. Azure Private Link works for consumers and services belonging to different Microsoft Entra ID tenants.

| **Feature Reference**                                                                          |
| ---------------------------------------------------------------------------------------------- |
| [Azure PrivateLink](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview) |

### Private Endpoints

Azure Private Endpoint is a network interface that connects applications privately and securely to an Azure service powered by Azure Private Link. Private Endpoint uses a private IP address from a virtual network, effectively bringing the service into your virtual network. The service could be an Azure service such as Azure Storage, Azure Cosmos DB, SQL, etc. or your own Private Link Service. Here are some key details about private endpoints:

- Private endpoint enables connectivity between the consumers from the same VNet, regionally peered VNets, globally peered VNets and on premises using [VPN](https://azure.microsoft.com/services/vpn-gateway/) or [ExpressRoute](https://azure.microsoft.com/services/expressroute/) and services powered by Private Link.
- Network connections can only be initiated by clients connecting to the Private endpoint, Service providers do not have any routing configuration to initiate connections into service consumers. Connections can only be established in a single direction.
- As shown in the picture below, when creating a private endpoint, a read-only network interface is also created for the lifecycle of the resource. By convention, the name of this network interface is equal to \<private-endpoint-name\>.nic.\<unique-identifier\>. The interface is assigned dynamically a private IP address from the subnet that maps to the private link resource. The value of the private IP address remains unchanged for the entire lifecycle of the private endpoint.
- The private endpoint must be deployed in the same region as the virtual network.
- The private link resource can be deployed in a different region than the virtual network and private endpoint.
- Multiple private endpoints can be created using the same private link resource. For a single network using a common DNS server configuration, the recommended practice is to use a single private endpoint for a given private link resource to avoid duplicate entries or conflicts in DNS resolution.
- Multiple private endpoints can be created on the same or different subnets within the same virtual network. There are limits to the number of private endpoints you can create in a subscription. For details, see [Azure limits](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits#networking-limits).
- The [PrivateDnsZoneGroup](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/privateendpoints/privateDnsZoneGroups) resource type establishes a relationship between the Private Endpoint and the Private DNS zone used for the name resolution of the fully qualified name of the resource referenced by the Private Endpoint. The [PrivateDnsZoneGroup](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/privateendpoints/privateDnsZoneGroups) is a sub-resource or child-resource of a Private Endpoint. The PrivateDnsZoneGroup type a single property that contains the resource if of the referenced Private DNS Zone. The user that creates a PrivateDnsZoneGroup requires write permission on the private DNS Zone. Once created, this resource is used to manage the lifecycle of the DNS A record used to resolve the fully qualified name of the resource referenced by the Private Endpoint. When creating a Private Endpoint, the related A record will automatically be created in the target Private DNS Zone with the private IP address of the network interface associated to the Private Endpoint and the name of the Azure resource referenced by the Private Endpoint. When deleting a Private Endpoint, the related A record gets automatically deleted from the corresponding Private DNS Zone. The network resource provider (Microsoft.Network) identity is used to perform both operations. This means that the user provisioning a Private Endpoint doesn't require any write permissions on the Private DNS Zone, or it's A records.

| **Feature Reference**                                                                                   |
| ------------------------------------------------------------------------------------------------------- |
| [Azure PrivateEndpoints](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview) |

## Private DNS Zones Design Decisions

- Azure Private DNS Zones will be used to provide private connectivity to Azure PaaS services using Private Endpoints.
- All Azure Private DNS Zones will be pre-provisioned and centrally managed in the Platform Connectivity Subscription.
- Azure Policy will be used to deny the creation of Private DNS Zones within Landing Zone subscriptions.
- Azure Policy will also be used to link to Connectivity and Identity virtual networks to use these Private DNS Zones and create the associated Private DNS records for the Private Endpoints.

## Private DNS Zones Design

> **Note**: The [[Customer_Shortname]] tenant does not have an on-premises component. Azure Firewall in Azure will simply forward traffic to the Azure-provided DNS service `168.63.129.16` to resolve private endpoint and public services.

## Platform Connectivity Subscription: Private DNS Zones

For a comprehensive list of Microsoft Private DNS Zones, refer to [Private DNS Zones list](https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns).

> **Note**: A vast majority, but not all, of these zones are configured as some zones, when enabled, enforce private traffic only. For the defined list in code, see `src\configuration\platform\platformConnectivity-xxx.bicepparam`

In additional to zones created used by Microsoft, the following zones will be configured for [[Customer_Shortname]].

| **DNS Zone Name**                                     | **Type**         | **Resource Group**         | **Location** | **Subscription**            | **Purpose**                                                                 |
| ----------------------------------------------------- | ---------------- | -------------------------- | ------------ | --------------------------- | --------------------------------------------------------------------------- |
| qa.postgres.database.azure.com                        | Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | QA environment Postgres SQL                                                 |
| qa.[[Customer_FriendlyDomain]]                                  | Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | QA environment Private DNS Zone                                             |
| certification.postgres.database.azure.com             | Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | Certification environment Postgres SQL                                      |
| certification.[[Customer_FriendlyDomain]]                       | Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | Certification environment Private DNS Zone                                  |
| staging.postgres.database.azure.com                   | Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | Staging environment Postgres SQL                                            |
| staging.[[Customer_FriendlyDomain]]                             | Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | Staging environment Private DNS Zone                                        |
| production.postgres.database.azure.com                | Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | Production environment Postgres SQL                                         |
| [[Customer_FriendlyDomain]]                                     | Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | Production environment Private DNS Zone                                     |
| j55eq8.australiaeast.azure.confluent.cloud            | Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | Private DNS zone for private link Confluent Cloud-Kafka (Non-Production)    |
| lkc-nm1r6-emkw1.australiaeast.azure.confluent.cloud   | Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | Private DNS zone for private link Confluent Cloud-Kafka (Production)        |
| privatelink.grafana.azure.com                         | Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | Short term monitoring solution Grafana                                      |
| privatelink.australiaeast.prometheus.monitor.azure.com| Private DNS Zone | arg-[[locPrefix]]-plat-conn-privatedns | Global       | sub-[[CustomerCode]]-plat-conn-01 | Short term monitoring solution Prometheus                                   |

See below Private DNS intententionally not deployed for the reasons such as enforcing pivate traffic only.

### DNS Private Zones not deployed

The following DNS Private Zones are not deployed by default as their enablement would prevent deployment/usage of their public service equivalent. I.e. These zones when deployed force all traffic to be either a private link or private endpoint and public ingress will stop working.

Only enable (uncomment) these Private DNS Zones when you _want_ to enforce all traffic to be private.

| **DNS Zone Name**                         | **Impacted Services** | **Reason**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ----------------------------------------- | --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| privatelink.adf.azure.com                 | Azure Data Factory    | Enabling this will impact the public Data Factory portal (<https://adf.azure.com/en/>) for public Azure Data Factory resources. More details can be found [here](https://learn.microsoft.com/en-us/azure/data-factory/data-factory-private-link).                                                                                                                                                                                                                                                                                                    |
| privatelink.azuredatabricks.net           | Azure Databricks      | Potential impacts to the Azure Databricks portal (<https://accounts.azuredatabricks.net/login>) for public Azure Databricks. For more information, check [here](https://learn.microsoft.com/en-us/azure/databricks/security/network/classic/private-link).                                                                                                                                                                                                                                                                                           |
| privatelink.azuresynapse.net              | Azure Synapse         | Interferes with Synapse Studio Portal (<https://web.azuresynapse.net/en/>) for Azure Synapse Workspaces not using private endpoints. Further details are available [here](https://learn.microsoft.com/en-us/purview/catalog-private-link-troubleshoot#recommended-troubleshooting-steps).                                                                                                                                                                                                                                                            |
| privatelink.eventgrid.azure.net           | Azure Event Grid      | Affects Push services with private link services, Pull services remain unaffected. More information is provided [here](https://learn.microsoft.com/en-us/azure/event-grid/consume-private-endpoints).                                                                                                                                                                                                                                                                                                                                              |
| privatelink.analysis.windows.net          | Power BI              | Affects Power BI if not configured to use private endpoints from the outset. Refer to this documentation for details [here](https://learn.microsoft.com/en-us/fabric/security/security-private-links-overview).                                                                                                                                                                                                                                                                                                                                    |
| privatelink.pbidedicated.windows.net      | Microsoft Fabric      | Impacts Microsoft Fabric services (<https://app.fabric.microsoft.com/home>). More details are available in the documentation [here](https://learn.microsoft.com/en-us/fabric/security/security-private-links-overview).                                                                                                                                                                                                                                                                                                                              |
| privatelink.purviewstudio.azure.com       | Microsoft Purview     | Affects Purview public web portal if not configured to use private endpoints from the outset. Refer to this guide for troubleshooting [here](https://learn.microsoft.com/en-us/purview/catalog-private-link-troubleshoot#recommended-troubleshooting-steps).                                                                                                                                                                                                                                                                                       |
| privatelink.tip1.powerquery.microsoft.com | Microsoft Fabric      | Affects Microsoft Fabric services if not configured to use private endpoints from the outset. For more details, consult [here](https://learn.microsoft.com/en-us/fabric/security/security-private-links-overview).                                                                                                                                                                                                                                                                                                                                 |
| privatelink.monitor.azure.com             | Azure Monitor         | Azure Monitor when enabled on private links has specific considerations due to its use of shared endpoints that are not resource-specific. This unique requirement needs to be managed carefully. For more information, see [Azure Monitor Private Link DNS configuration](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/private-link-security#azure-monitor-private-links-rely-on-your-dns). For [[Customer_Shortname]], this must be removed to support Prometheus private endpoints that use this zone as a private endpoint (not link scope). |
