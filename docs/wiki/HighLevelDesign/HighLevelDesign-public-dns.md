# Public DNS in Azure

- [Public DNS in Azure](#public-dns-in-azure)
  - [Public DNS Overview](#public-dns-overview)
    - [Azure Public DNS](#azure-public-dns)
    - [Global Anycast & CDN Integration](#global-anycast--cdn-integration)
  - [Public DNS Design Decisions](#public-dns-design-decisions)
  - [Public DNS Design](#public-dns-design)
  - [Platform Connectivity Subscription: Public DNS Zones](#platform-connectivity-subscription-public-dns-zones)

## Public DNS Overview

Azure Public DNS is a globally available Domain Name System (DNS) hosting service that provides reliable and secure name resolution using the Microsoft Azure infrastructure. It allows you to host your DNS domains and manage DNS records for your public-facing services. By using Azure Public DNS, organizations can leverage scalable, high-performance DNS management that integrates seamlessly with other Azure services.

### Azure Public DNS

Azure Public DNS provides the following benefits:

- **Global Availability**: With a global network of DNS servers, Azure Public DNS ensures fast and reliable query responses worldwide.
- **High Availability & Scalability**: The service is built on Azure’s resilient platform, offering high availability and the ability to handle large volumes of DNS queries.
- **Ease of Management**: Manage DNS records using the Azure portal, Azure CLI, or PowerShell, allowing for efficient integration with your deployment workflows.
- **Security**: Supports DNSSEC to help protect the integrity of your DNS records and mitigate cache poisoning risks.
- **Integration with Azure Services**: Seamlessly integrates with other Azure networking and compute services, providing a consistent management experience.

For more detailed information, see the [Azure Public DNS Documentation](https://docs.microsoft.com/en-us/azure/dns/dns-overview).

### Global Anycast & CDN Integration

Azure leverages anycast routing with its public DNS services, meaning that DNS queries are resolved by the nearest available server on the global network. This mechanism minimizes latency and improves the end-user experience. Furthermore, integration with Azure Content Delivery Network (CDN) and other edge services ensures that your public DNS zones support high-performance content delivery and scalability for global audiences.

## Public DNS Design Decisions

- **Centralized Management**: All public DNS zones will be centrally managed to ensure consistent policies, security, and compliance.
- **Integration with Traffic Manager**: Public DNS records are designed to work seamlessly with Azure Traffic Manager, facilitating intelligent traffic routing across multiple endpoints.
- **Global Resilience**: Public DNS zones are hosted on a globally distributed anycast network to guarantee high availability and performance.
- **Security and Compliance**: DNSSEC and other security features are enforced to maintain the integrity and authenticity of DNS data.
- **Automated Record Management**: Integration with Azure Resource Manager (ARM) enables automated updates to DNS records as services are deployed, updated, or decommissioned.

> **Rationale**: Centralized management and integration with Azure services ensure streamlined operations and enhanced security for public-facing applications.
>
> **Implications**: This approach guarantees optimal performance, simplifies DNS management, and maintains compliance with organizational policies.

## Public DNS Design

> **Note**: For public-facing services, DNS records should be configured with appropriate Time-To-Live (TTL) values and health monitoring. Integration with Traffic Manager and CDN services must be tested to ensure optimal performance and failover capabilities.

Key elements of the public DNS design include:

- **Zone Creation & Management**: Public DNS zones are created and maintained within dedicated resource groups, following organizational naming conventions.
- **Record Types**: Support for A, AAAA, CNAME, MX, TXT, and SRV records ensures that various public service requirements are met.
- **Automation**: Deployment pipelines integrate with Azure DNS to automatically update DNS records during service lifecycle events.
- **Monitoring & Alerting**: Continuous monitoring of DNS query performance and availability is implemented, with alerts configured for any anomalies.
- **Compliance & Auditing**: Regular audits and policy enforcement ensure that public DNS zones adhere to internal security and compliance guidelines.

## Platform Connectivity Subscription: Public DNS Zones

| **DNS Zone Name**            | **Type**        | **Resource Group**          | **Location** | **Subscription**                |
| ---------------------------- | --------------- | --------------------------- | ------------ | ------------------------------- |
| [[Customer_FriendlyDomain]]          | Public DNS zone | arg-plat-conn-publicdns      | Global       | sub-[[CustomerCode]]-plat-conn-01        |
