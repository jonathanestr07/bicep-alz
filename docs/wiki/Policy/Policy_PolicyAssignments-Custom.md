# Policy Assignments - Custom

## Management Group (intRoot)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deploy-AKS-Diag-Logs | Deploy Azure Kubernetes Service Diagnostics Logs | Deploy Azure Kubernetes Service Diagnostics Logs for audit and traceability. | *     |  
Enforce-GR-Governance | Enforce Azure Governance Guardrails | Enforce Azure Governance Guardrails for Tagging, Hybrid Use Benefits and other governance constructs. | *     |  
Enforce-Naming-Standards | Enforce Azure Naming Standards | This Policy Assignment Enforces Azure Naming Standards across Azure Resources. | *     |  
Deploy-Activity-Log-Sta | Deploy Diagnostic Settings for Activity Log to Azure Storage | Ensures that Activity Log Diagnostics settings are set to push logs into a Storage Account for Long term retention. | *     |  
Deploy-DNSZone-Link-`[copyIndex()]` | Deploy Private DNS Zone Virtual Network Link to a Virtual Network | This policy deploys the Private DNS Zone Virtual Network Link to a Virtual Network if it doesn't exist. | *     |  
Deploy-AzFw-Diag-Res | Enable allLogs category group resource logging (resource specific) for Azure Firewall to Log Analytics | Resource logs should be enabled to track activities and events that take place on Azure Firewall to resource specific tables in Logs Analytics to give you visibility and insights into any changes that occur. | *     |  

## Management Group (landingZones)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deploy-Azure-CIS | CIS Microsoft Azure Foundations Benchmark v1.4.0 | The Center for Internet Security (CIS) is a nonprofit entity whose mission is to 'identify, develop, validate, promote, and sustain best practice solutions for cyber defense.' CIS benchmarks are configuration baselines and best practices for securely configuring a system. These policies address a subset of CIS Microsoft Azure Foundations Benchmark v1.4.0 controls. For more information, visit https://aka.ms/cisazure130-initiative | *     |  
Deploy-ISO-27001-2013 | ISO 27001:2013 | The International Organization for Standardization (ISO) 27001 standard provides requirements for establishing, implementing, maintaining, and continuously improving an Information Security Management System (ISMS). These policies address a subset of ISO 27001:2013 controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/iso27001-init | *     |  
Deploy-NIST-800-53 | NIST SP 800-53 Rev. 5 | National Institute of Standards and Technology (NIST) SP 800-53 Rev. 5 provides a standardized approach for assessing, monitoring and authorizing cloud computing products and services to manage information security risk. These policies address a subset of NIST SP 800-53 R5 controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/nist800-53r5-initiative | *     |  
Deploy-ISM-Protected | Australian Government ISM PROTECTED | This initiative includes policies that address a subset of Australian Government Information Security Manual (ISM) controls. Additional policies will be added in upcoming releases. For more information, visit https://aka.ms/auism-initiative. | *     |  
Deny-Azure-Resources | Deny Azure Resources | This policy denies the creation of specific Azure resources. | *     |  

## Management Group (platform)

Name | DisplayName | Description | Scope | NotScopes
---- | ----------- | ----------- | ----- | ---------
Deny-Resource-Delete | Deny Azure Resource Deletion for specific Azure Resources | Deny Resource Deletion for identified Azure Resources. | *     |  
