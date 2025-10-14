# Identity Governance Strategies

- [Identity Governance Strategies](#identity-governance-strategies)
  - [Overview](#identity-governance-overview)
  - [Access Reviews](#access-reviews)
  - [Privileged Identity Management (PIM)](#privileged-identity-management-pim)
  - [Entitlement Management](#entitlement-management)
  - [Access Controls](#access-controls)
  - [External Identities Enhancements](#external-identities-enhancements)

## Overview

Implementing effective identity governance strategies is essential for maintaining security and compliance in the Entra tenant. This involves managing access rights, ensuring appropriate use of privileged accounts, and enforcing policies and procedures.

### Identity Governance Overview

Identity governance strategies should be designed to ensure that access to resources is appropriately managed and compliant with organisational policies.

**Design Considerations:**

- Establish processes for regular access reviews to ensure that only authorised users have access to critical resources.
- Implement Privileged Identity Management (PIM) to manage and monitor privileged accounts.
- Use entitlement management to automate access request workflows and lifecycle management.
- Enforce terms of use to ensure that users acknowledge and agree to organisational policies.

| **Item**                     | **Details**                                                                                                                                                                                                                                                                                                                             |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Access Review Processes      | Not applied                                                                                                                                                                                                                                                                                                                             |
| PIM Configuration            | All roles in Azure and Entra must be elevated                                                                                                                                                                                                                                                                                           |
| Entitlement Management Setup | Not applied                                                                                                                                                                                                                                                                                                                             |
| Terms of Use Policies        | Entra ID Security Defaults disabled, Entra ID Company branding set to be the same as main [[Customer_Shortname]] tenant. New background picture requirements: Image size: 1920x1080px, Max file size: 300KB, File Type: PNG, JPG, or JPEG, Entra ID Users settings updated to be the same as main [[Customer_Shortname]] tenant, Self-service password reset enabled. |

> **Rationale:** Effective identity governance ensures that access to resources is managed securely and in compliance with organisational policies and regulatory requirements.
>
> **Implications:**
>
> - Improved security posture by reducing the risk of unauthorized access.
> - Enhanced compliance with regulatory requirements and organisational policies.
> - Streamlined access management processes, reducing administrative overhead.
> - Increased accountability and visibility into access and usage of resources.
> - Better alignment of access rights with user roles and responsibilities.

### Access Reviews

Access reviews are critical for ensuring that only authorised users have access to resources, reducing the risk of unauthorized access.

**Design Considerations:**

- Define the scope and frequency of access reviews based on the sensitivity of the resources.
- Use automated tools to streamline the access review process.
- Involve resource owners and managers in the review process to ensure accuracy.

| **Item**         | **Details** |
| ---------------- | ----------- |
| Review Scope     | Not applied |
| Review Frequency | Not applied |
| Automation Tools | Not applied |

> **Rationale:** Regular access reviews help maintain the principle of least privilege, ensuring that users have the minimum access necessary to perform their roles.
>
> **Implications:**
>
> - Reduced risk of unauthorized access by regularly validating user access rights.
> - Improved compliance with regulatory requirements and internal policies.
> - Enhanced security posture by identifying and removing unnecessary access.
> - Increased accountability by involving resource owners in the review process.
> - Streamlined access management through the use of automated tools.

### Privileged Identity Management (PIM)

Privileged Identity Management (PIM) helps manage, control, and monitor access to critical resources, ensuring that privileged accounts are used appropriately.

**Design Considerations:**

- Configure PIM to require approval for activating privileged roles.
- Implement just-in-time (JIT) access to reduce the risk of prolonged privileged access.
- Monitor and audit privileged access to detect and respond to potential misuse.

| **Item**                 | **Details**                                                    |
| ------------------------ | -------------------------------------------------------------- |
| Role Activation Approval | Mandatory approval for activating all roles in Azure and Entra |
| Just-in-Time Access      | Not applied                                                    |
| Monitoring and Auditing  | Not applied                                                    |

> **Rationale:** PIM reduces the risk of misuse of privileged accounts by enforcing strict controls and providing visibility into privileged activities.
>
> **Implications:**
>
> - Enhanced security by minimizing the risk of misuse of privileged accounts.
> - Improved compliance with regulatory requirements and internal policies.
> - Increased visibility and accountability for privileged activities.
> - Reduced risk of prolonged privileged access through just-in-time access.
> - Streamlined management of privileged roles and activities.

### Entitlement Management

Entitlement management automates the process of managing access rights, streamlining access request workflows and lifecycle management.

**Design Considerations:**

- Define access packages that group related resources for specific roles or projects.
- Automate the approval and review process for access requests.
- Implement lifecycle policies to ensure that access rights are automatically revoked when no longer needed.

| **Item**           | **Details** |
| ------------------ | ----------- |
| Access Packages    | Not applied |
| Approval Workflows | Not applied |
| Lifecycle Policies | Not applied |

> **Rationale:** Automating entitlement management reduces administrative overhead and ensures that access rights are granted and revoked in a timely manner.
>
> **Implications:**
>
> - Streamlined access request workflows, reducing the time and effort required to manage access rights.
> - Improved compliance with organisational policies by ensuring timely revocation of access rights.
> - Enhanced security posture by reducing the risk of unauthorized access through automated lifecycle management.
> - Increased efficiency in managing access rights, allowing IT staff to focus on other critical tasks.
> - Better alignment of access rights with user roles and responsibilities through predefined access packages.

### Access Controls

Enforcing terms of use and access controls ensures that users acknowledge and agree to organisational policies, enhancing compliance and accountability.

**Design Considerations:**

- Define clear terms of use policies that outline acceptable use of resources.
- Require users to accept the terms of use before accessing critical resources.
- Track user acceptance to ensure compliance.

| **Item**                 | **Details**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Locations                | [[Customer_Shortname]] - same IP addresses as per [[Customer_Shortname]] tenant                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Acceptance Requirements  | Not applied                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Authentication Strengths | [[Customer_Shortname]] - Windows Hello For Business, Passkeys (FIDO2), Certificate-based Authentication (Multifactor), Microsoft Authenticator (Phone Sign-in), Temporary Access Pass (One-time use), Temporary Access Pass (Multi-use), Password + Microsoft Authenticator (Push Notification), Password + Software OATH token, Password + Hardware OATH token, Federated Multifactor, Federated Single factor + Microsoft Authenticator (Push Notification), Federated Single factor + Software OATH token, Federated Single factor + Hardware OATH token. Compliance Tracking: CA Policies: CA01-All Apps: MFA required for all users on the [[Customer_Shortname]] network, All users except break glass account, All cloud apps, All trusted locations, Allow access but require [[Customer_Shortname]] authentication strength MFA, Sign-in frequency: 8 hours. CA02-All Apps: Block access for all users unless on [[Customer_Shortname]] network, All users, All cloud apps, All locations except trusted locations, Block access. |

> **Rationale:** Requiring users to accept terms of use ensures that they are aware of and agree to organisational policies, promoting responsible use of resources.
>
> **Implications:**
>
> - Increased compliance with organisational policies by ensuring users acknowledge and agree to terms of use.
> - Enhanced accountability by tracking user acceptance of terms of use.
> - Improved security posture by enforcing clear guidelines for acceptable use of resources.
> - Reduced risk of misuse of resources through user awareness and agreement to policies.
> - Streamlined access management by integrating terms of use acceptance into the access control process.

### External Identities Enhancements

Recent configuration changes for external identities have strengthened the security posture:

- **Guest User Access Restrictions:** Guest users are now limited to accessing only the properties and memberships of their own directory objects.
- **Guest Invite Restrictions:** Only users assigned to specific admin roles are permitted to invite guest users.

These enhancements ensure tighter control over external collaborations and reduce the risk of excessive permissions.

| **Feature Reference**                                                                                                         |
| ----------------------------------------------------------------------------------------------------------------------------- |
| [Identity Governance Strategies](https://learn.microsoft.com/en-us/microsoft-365/education/deploy/design-identity-governance) |
