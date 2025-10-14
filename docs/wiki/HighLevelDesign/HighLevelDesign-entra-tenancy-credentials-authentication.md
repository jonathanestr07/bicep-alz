# Credential and Authentication Strategies

- [Credential and Authentication Strategies](#credential-and-authentication-strategies)
  - [Overview](#overview)
  - [Multi-Factor Authentication (MFA)](#multi-factor-authentication-mfa)
  - [Passwordless Authentication](#passwordless-authentication)
  - [Identity Federation](#identity-federation)
  - [Conditional Access Policies](#conditional-access-policies)

## Overview

Implementing effective credential and authentication strategies is crucial for securing access to the Entra tenant. This involves choosing the right authentication methods, enforcing strong credential policies, and integrating with existing identity providers.

### Credential and Authentication Overview

Credential and authentication strategies should be designed to ensure secure, seamless, and compliant access to the Entra tenant and its resources.

**Design Considerations:**

- Evaluate different authentication methods (e.g., password-based, multi-factor authentication, passwordless) to determine the best fit for the organisation.
- Enforce strong password policies and regular password changes to enhance security.
- Integrate with existing identity providers (e.g., Active Directory, third-party identity providers) to streamline user authentication processes.

| **Item**                      | **Details**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Authentication Methods        | Windows Hello For Business, Passkeys (FIDO2), Certificate-based Authentication (Multifactor), Microsoft Authenticator (Phone Sign-in), Temporary Access Pass (One-time use), Temporary Access Pass (Multi-use), Password + Microsoft Authenticator (Push Notification), Password + Software OATH token, Password + Hardware OATH token, Federated Multifactor, Federated Single factor + Microsoft Authenticator (Push Notification), Federated Single factor + Software OATH token, Federated Single factor + Hardware OATH token |
| Password Policies             | Enforced through existing organisational policies                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| Identity Provider Integration | Not applied                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |

> **Rationale:** Implementing robust credential and authentication strategies ensures that access to the tenant is secure and aligns with organisational policies and compliance requirements.
>
> **Implications:**
>
> - Enhanced security through the use of strong authentication methods and policies.
> - Improved compliance with regulatory requirements and organisational standards.
> - Streamlined user authentication processes by integrating with existing identity providers.
> - Reduced risk of unauthorized access and credential-based attacks.
> - Better user experience with seamless and secure access to resources.

### Multi-Factor Authentication (MFA)

Multi-Factor Authentication (MFA) adds an additional layer of security by requiring users to provide multiple forms of verification.

**Design Considerations:**

- Determine which MFA methods are suitable for the organisation (e.g., SMS, authenticator apps, hardware tokens).
- Enforce MFA for all users, especially for those with access to sensitive information and critical systems.
**Design Considerations:**

- Determine which MFA methods are suitable for the organisation (e.g., SMS, authenticator apps, hardware tokens).
- Enforce MFA for all users, especially for those with access to sensitive information and critical systems.
- Provide user training and support to facilitate smooth MFA adoption.

| **Item**             | **Details**                                                                           |
| -------------------- | ------------------------------------------------------------------------------------- |
| MFA Methods          | Microsoft Authenticator (Push Notification), Software OATH token, Hardware OATH token |
| Enforcement Policies | Enforce MFA for all users on the [[Customer_Shortname]] network, except break glass account |
| MFA Restoration | The setting **"Restore multi-factor authentication on all remembered devices"** has been disabled. This change ensures that users must reauthenticate as required, thereby reinforcing our MFA enforcement and reducing potential security gaps. |

> **Rationale:** MFA significantly reduces the risk of unauthorized access by adding an extra layer of verification, thereby enhancing overall security.
>
> **Implications:**
>
> - Increased security through additional verification steps.
> - Reduced risk of credential-based attacks.
> - Enhanced protection for sensitive information and critical systems.
> - Potential user inconvenience due to additional authentication steps.

### Passwordless Authentication

Passwordless authentication methods, such as biometrics and FIDO2 security keys, can improve security and user experience.

**Design Considerations:**

- Assess the feasibility of passwordless authentication for the organisation.
- Implement passwordless solutions where applicable to reduce reliance on traditional passwords.
- Ensure that passwordless methods comply with regulatory requirements and organisational policies.

| **Item**                  | **Details**                                                    |
| ------------------------- | -------------------------------------------------------------- |
| Passwordless Methods      | Windows Hello For Business, Passkeys (FIDO2)                   |
| Implementation Plan       | Not applied                                                    |
| Compliance Considerations | Ensure compliance with organisational policies and regulations |

> **Rationale:** Passwordless authentication provides a more secure and user-friendly alternative to traditional passwords, reducing the risk of credential-based attacks.
>
> **Implications:**
>
> - Enhanced security by eliminating password-related vulnerabilities.
> - Improved user experience with faster and more convenient authentication.
> - Reduced administrative overhead related to password management.
> - Compliance with modern security standards and regulations.

### Identity Federation

Integrating with existing identity providers through identity federation streamlines authentication processes and improves user experience.

**Design Considerations:**

- Choose appropriate federation protocols (e.g., SAML, OAuth, OpenID Connect) based on existing infrastructure and requirements.
- Configure identity federation to support single sign-on (SSO) across the organisation's applications and services.
- Ensure secure and reliable communication between the Entra tenant and federated identity providers.

| **Item**             | **Details** |
| -------------------- | ----------- |
| Federation Protocols | Not applied |
| SSO Configuration    | Not applied |
| Security Measures    | Not applied |

> **Rationale:** Identity federation simplifies the user authentication process and enhances security by leveraging existing identity management systems.
>
> **Implications:**
>
> - Streamlined user authentication through single sign-on (SSO).
> - Improved security by centralizing identity management.
> - Reduced administrative overhead by integrating with existing identity providers.
> - Enhanced user experience with seamless access to multiple applications and services.

### Conditional Access Policies

Conditional access policies control access to resources based on user conditions and device states, enhancing security.

**Design Considerations:**

- Define conditional access policies to enforce access controls based on risk levels, user roles, and device compliance.
- Implement policies to restrict access from untrusted locations or devices.
- Continuously monitor and adjust policies to address emerging threats and changing organisational needs.

| **Item**                   | **Details**                                                                                                                                                                                                                                                                                                                                                                                      |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Policy Definitions         | CA01-All Apps: Require MFA for all users on the [[Customer_Shortname]] network, All users except break glass account, All cloud apps, All trusted locations, Allow access but require [[Customer_Shortname]] authentication strength MFA, Sign-in frequency: 8 hours. CA02-All Apps: Block access for all users unless on [[Customer_Shortname]] network, All users, All cloud apps, All locations except trusted locations, Block access. |
| Access Restrictions        | Restrict access from untrusted locations or devices                                                                                                                                                                                                                                                                                                                                              |
| Monitoring and Adjustments | Continuously monitor and adjust policies                                                                                                                                                                                                                                                                                                                                                         |

> **Rationale:** Conditional access policies provide a dynamic and adaptive approach to securing access, ensuring that only trusted users and devices can access critical resources.
>
> **Implications:**
>
> - Enhanced security by enforcing access controls based on risk levels and device compliance.
> - Reduced risk of unauthorized access from untrusted locations or devices.
> - Improved compliance with organisational security policies and regulatory requirements.
> - Flexibility to adapt to emerging threats and changing organisational needs.
> - Better user experience by allowing access from trusted devices and locations.

| **Feature Reference**                                                                                                                                    |
| -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Credential and Authentication Strategies](https://learn.microsoft.com/en-us/microsoft-365/education/deploy/design-credential-authentication-strategies) |
