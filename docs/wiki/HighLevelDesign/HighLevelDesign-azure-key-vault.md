# Azure Key Vault

- [Azure Key Vault](#azure-key-vault)
  - [Azure Key Vault Overview](#azure-key-vault-overview)
  - [Azure Key Vault Design Decisions](#azure-key-vault-design-decisions)

## Azure Key Vault Overview

Azure Key Vault is a cloud service that works as a secure secrets store. Key Vault helps securely store a wide variety of information including passwords, connection strings, and application secrets. Key Vault provides a deep level of security by leveraging secure containers, called vaults. These vaults are backed by hardware security modules (HSMs).

[[/.media/azurekeyvault_overview.png]]
![Azure Key Vault](../.media/azurekeyvault_overview.png)

| **Feature Reference**                                                                                                                                    |
| -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Azure Key Vault Overview](https://docs.microsoft.com/en-us/azure/key-vault/key-vault-whatis)                                                            |
| [Cloud Adoption Framework Reference](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/encryption-and-keys) |

## Azure Key Vault Design Decisions

- A dedicated Azure Key Vault will be used for all platform keys, secrets and certificates across the environment, this instance will be created in the Platform Identity Subscription.
- Other Key Vaults can be created within the Landing Zone subscriptions. Along with it is recommended to have a dedicated one for Application Gateways and Azure Firewall Premium within the Connectivity Platform Subscription.
- All Key Vaults will enable access to the following
  - Azure Virtual Machines for deployment
  - Azure Resource Manager for template deployment
  - Azure Disk Encryption for volume encryption
- Key Vault resources will only be accessed from private addresses and on-premises locations.
- RBAC will be used to control access to the Key Vault, the _[Key Vault Administrator](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli)_ RBAC role will be enabled on the Platform Key Vaults.
- Soft-Delete will automatically be enabled for the Key Vault, where objects will be retained for 90 days after deletion.
- Purge Protection will be enabled to ensure deleted items can’t be purged for 90 days

> **Rationale:** Deploying Azure Key Vault into the Platform Identity subscription will provide a centralized secure solution for managing platform keys, secrets and certificates across the platform Identity subscriptions>
> **Implications:** Processes will need to be defined to review and manage the rotation of keys, secrets and certificates that are stored in Azure Key Vault.\*
