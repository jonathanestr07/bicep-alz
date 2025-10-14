# Entra Tenant Setup

- [Entra Tenant Setup](#entra-tenant-setup)
  - [Overview](#overview)
  - [Design Decisions](#design-decisions)
  - [Tenant Configuration](#tenant-configuration)
    - [Initial Setup](#initial-setup)
    - [Domain Configuration](#domain-configuration)
    - [User and Group Management](#user-and-group-management)
    - [Security and Compliance](#security-and-compliance)

## Overview

Setting up a new Entra tenant involves several critical steps to ensure a secure, scalable, and compliant environment. This document provides a comprehensive guide to configuring your Entra tenant following best practices.

| **Feature Reference**                                                                                                          |
| ------------------------------------------------------------------------------------------------------------------------------ |
| [Tenant Configuration Overview](https://learn.microsoft.com/en-us/microsoft-365/education/deploy/design-tenant-configurations) |

## Design Decisions

- The tenant will be configured to support multiple environments (e.g., production, development, testing).
- A simple/flat hierarchy for management groups will be adopted to reduce complexity.
- Security and compliance policies will be enforced from the top level down.
- Automated provisioning and configuration of resources will be implemented where possible.

> **Rationale:** A well-structured tenant configuration enhances security, manageability, and scalability.
>
> **Implications:** Careful planning and execution are required to ensure that the tenant meets organisational needs without unnecessary complexity.

## Tenant Configuration

### Initial Setup

The initial setup of the Entra tenant is crucial for establishing a secure and scalable foundation. This involves creating the tenant and configuring initial administrative access.

**Design Considerations:**

- Establish a clear naming convention for the tenant to ensure consistency and easy identification.
- Assign global administrators to key personnel to ensure redundancy and prevent single points of failure.

| **Item**                           | **Details**                                                                      |
| ---------------------------------- | -------------------------------------------------------------------------------- |
| Tenant Name                        | [[Customer_OnMicrosoftDomain]], `[[Customer_TenantId]]`           |
| Tenant Region                      | Australia                                                                        |
| Initial Admin Accounts (Jailbreak) | `admin1@[[Customer_OnMicrosoftDomain]]`, `admin2@[[Customer_OnMicrosoftDomain]]` |

> **Rationale:** A structured initial setup ensures that the tenant is configured correctly from the start, reducing the risk of misconfigurations and enhancing security.
>
> **Implications:**
>
> - Proper initial setup requires careful planning and execution to avoid potential issues.
> - Ensuring redundancy in administrative access helps prevent single points of failure.
> - Consistent naming conventions aid in the management and identification of resources.
> - Initial configurations set the foundation for future scalability and security enhancements.

### Domain Configuration

Configuring custom domains within the Entra tenant is essential for aligning the tenant with the organisation’s domain structure. This enables seamless integration and identity management across the organisation.

**Design Considerations:**

- Custom domains should reflect the organisation's branding and be easily identifiable.
- DNS configurations must be accurate to ensure domain verification and mail flow.

| **Item**            | **Details**         |
| ------------------- | ------------------- |
| Custom Domain       | [[Customer_FriendlyDomain]]   |
| DNS Provider        |      |
| Verification Method | TXT record          |

> **Rationale:** Proper domain configuration ensures that users can access services using familiar domain names, enhancing user experience and trust.
>
> **Implications:**
>
> - Accurate DNS configurations are critical to avoid service disruptions.
> - Ongoing management of domain settings is required to accommodate changes in the organisation's domain structure.
> - Verification processes must be followed to ensure domains are correctly configured and validated.

### User and Group Management

Effective user and group management is critical for maintaining security and operational efficiency within the Entra tenant. This includes creating users, setting up groups, and configuring group-based licensing.

**Design Considerations:**

- Implement a clear structure for user and group creation to align with organisational roles and responsibilities.
- Use group-based licensing to streamline license management and reduce administrative overhead.

| **Item**           | **Details**                                                                                    |
| ------------------ | ---------------------------------------------------------------------------------------------- |
| User Structure     | Users created based on department and role, e.g., `firstname.lastname@[[Customer_FriendlyDomain]]`           |
| Group Structure    | Groups created for each department and project, e.g., `IT-Admins`, `HR-Team`, `Project-X-Team`   |
| Licensing Strategy | Group-based licensing for Office 365 and other enterprise applications                         |

> **Rationale:** A well-defined user and group management strategy ensures that access controls are consistent and scalable, reducing the risk of security breaches and simplifying administration.
>
> **Implications:** Proper user and group management requires ongoing oversight to adapt to organizational changes and maintain security.

### Security and Compliance

Security and compliance are paramount in the design of an Entra tenant. This involves implementing multi-factor authentication (MFA), conditional access policies, and compliance configurations.

**Design Considerations:**

- Enforce MFA for all users to enhance security.
- Define conditional access policies to secure access to critical resources based on user and device conditions.
- Implement compliance policies to meet regulatory requirements and protect sensitive data.

| **Item**                    | **Details**                                                                    |
| --------------------------- | ------------------------------------------------------------------------------ |
| MFA Policy                  | Enforce MFA for all users, using Microsoft Authenticator as the primary method |
| Conditional Access Policies | Configured. See Tenancy Credentials page                                       |

**Security and Compliance Enhancements:**

To strengthen the security posture and ensure regulatory compliance, the following measures have been implemented within the Entra tenant:

- **Admin Password Reset Notifications:**
  The setting **"notify all admins when other admins reset their password"** has been enabled via the Microsoft Entra ID Console. This ensures transparency and prompt awareness of administrative password resets.

- **Restore MFA on Remembered Devices:**
  The option **"Restore multi-factor authentication on all remembered devices"** has been disabled in the per-user MFA settings, ensuring that users reauthenticate as required.

- **Guest User Access Restrictions:**
  External collaboration settings have been updated so that **guest users are restricted to properties and memberships of their own directory objects**. This limits excessive permissions.

- **Guest Invite Restrictions:**
  The guest invite settings now enforce that **only users assigned to specific admin roles can invite guest users**, enhancing control over external access.

> **Rationale:** These security and compliance measures are designed to protect the organisation from potential threats, enforce best practices in access control, and ensure adherence to regulatory standards. By implementing these configurations, the Entra tenant maintains a secure and compliant environment.
>
> **Implications:** Implementing these measures requires ongoing monitoring and management to ensure they remain effective and aligned with evolving security and compliance requirements.
