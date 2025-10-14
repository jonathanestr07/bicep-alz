# Resource Tagging

- [Resource Tagging](#resource-tagging)
  - [Resource Tagging Overview](#resource-tagging-overview)
  - [Resource Tagging Design Decisions](#resource-tagging-design-decisions)
  - [Resource Tagging Design](#resource-tagging-design)
    - [Platform Connectivity](#platform-connectivity)
    - [Platform Identity](#platform-identity)
    - [Platform Management](#platform-management)

## Resource Tagging Overview

Azure Resource Manager provides a tagging feature that facilitates resource categorization according to customer requirements for managing or billing. Tags are defined as Name-Value pairs assigned to resources or resource groups. They can be used in scenarios where customer business processes and organizational hierarchy call for a complex collection of resource groups, resources, and subscription assets that need to be structured according to established policies. Each resource can have up to 50 tags. Users can sort and organize resources through tags. Tags may be placed on a resource at the time of creation or added to an existing resource. Once a tag is placed on a billable resource, created via the Azure Resource Manager, the tag will be included in the usage details found in the Usage and Billing portal.

| **Feature Reference**                                                                                                                             |
| ------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Resource Tags Overview](https://azure.microsoft.com/en-us/documentation/articles/resource-group-using-tags/)                                     |
| [Cloud Adoption Framework Reference](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging) |

## Resource Tagging Design Decisions

- Resource tagging information will be used to provide granular reports that can be used for show-back and charge-back purposes.
- Resource tags will be used for billing management, identifying ownership of resources, environments, and other desired metadata.
- There will be required and optional tags for resources.
- Resource tags will be set during the provisioning of the resource groups and inherited by resources within that resource group. This will be achieved through a mixture of Azure Policy and Azure Automation.
- Individual resources within the resource group may have additional tags above and beyond that of the parent resource group.
- Resource Tags will be used for IaaS and other workloads that support the start and stopping of resources to assist in controlling costs.

> **Rationale:** Identification of resources using metadata will be important for billing management, operations, and governance purposes. Resource tags provide information that can change over time to complement the names of Azure resources.
>
> **Implications:** Maintaining a balance between mandatory and optional tags will provide a balance around governance and operational effort. Enforcement of tags will be achieved using Azure Policy to append, deploy, and modify tags during creation or changes to the resources. All resource tags are free text, so “Production” is a different tag to “production”, this needs to be factored in to ensure there are not multiple versions of the same tag.\*

## Resource Tagging Design

The tags are mandatory across the environment

| Name               | Type   | Description                                                                                         |
| ------------------ | ------ | --------------------------------------------------------------------------------------------------- |
| applicationName    | string | Application name for the resource group                                                             |
| owner              | string | Owner of the subscription/resource group/resource                                                   |
| criticality        | string | Tier0 = Platform Subscriptions, Tier1 = Production Landing Zones, Tier2 = Dev or Test Landing Zones |
| costCenter         | string | A cost center value for the subscription/resource group.                                            |
| contactEmail       | string | Email address of the owner of the resource/resource group or Subscription                           |
| dataClassification | string | Based on the data classification framework                                                          |
| environment        | string | Production, Development, Test                                                                       |
| createdDate        | string | utcNow() time                                                                                       |

### Platform Connectivity

| Tag Name           | Tag Value                         | Mandatory | Applied to               | Enforced by Policy? |
| ------------------ | --------------------------------- | --------- | ------------------------ | ------------------- |
| applicationName    | Platform Connectivity             | Yes       | ResourceGroup, Resources | Yes                 |
| contactEmail       | [[Customer_Email_Alerts]] | Yes       | ResourceGroup, Resources | Yes                 |
| costCenter         | [[Customer_CostCentre]]                              | Yes       | ResourceGroup, Resources | Yes                 |
| CreatedDate        | utcNow()                          | Yes       | ResourceGroup, Resources | Yes                 |
| criticality        | Tier0                             | Yes       | ResourceGroup, Resources | Yes                 |
| dataClassification | Internal                          | Yes       | ResourceGroup, Resources | Yes                 |
| owner              | [[Customer_Platform_Team_Name]]             | Yes       | ResourceGroup, Resources | Yes                 |
| environment        | Production                        | Yes       | Subscription, Resources  | Yes                 |

### Platform Identity

| Tag Name           | Tag Value                         | Mandatory | Applied to               | Enforced by Policy? |
| ------------------ | --------------------------------- | --------- | ------------------------ | ------------------- |
| applicationName    | Platform Identity                 | Yes       | ResourceGroup, Resources | Yes                 |
| contactEmail       | [[Customer_Email_Alerts]] | Yes       | ResourceGroup, Resources | Yes                 |
| costCenter         | [[Customer_CostCentre]]                              | Yes       | ResourceGroup, Resources | Yes                 |
| CreatedDate        | utcNow()                          | Yes       | ResourceGroup, Resources | Yes                 |
| criticality        | Tier0                             | Yes       | ResourceGroup, Resources | Yes                 |
| dataClassification | Internal                          | Yes       | ResourceGroup, Resources | Yes                 |
| owner              | [[Customer_Platform_Team_Name]]             | Yes       | ResourceGroup, Resources | Yes                 |
| environment        | Production                        | Yes       | Subscription, Resources  | Yes                 |

### Platform Management

| Tag Name           | Tag Value                         | Mandatory | Applied to               | Enforced by Policy? |
| ------------------ | --------------------------------- | --------- | ------------------------ | ------------------- |
| applicationName    | Platform Management               | Yes       | ResourceGroup, Resources | Yes                 |
| contactEmail       | [[Customer_Email_Alerts]] | Yes       | ResourceGroup, Resources | Yes                 |
| costCenter         | [[Customer_CostCentre]]                              | Yes       | ResourceGroup, Resources | Yes                 |
| CreatedDate        | utcNow()                          | Yes       | Resources                | Yes                 |
| criticality        | Tier0                             | Yes       | ResourceGroup, Resources | Yes                 |
| dataClassification | Internal                          | Yes       | ResourceGroup, Resources | Yes                 |
| owner              | [[Customer_Platform_Team_Name]]             | Yes       | ResourceGroup, Resources | Yes                 |
| environment        | Production                        | Yes       | Subscription, Resources  | Yes                 |
